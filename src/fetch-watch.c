#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/inotify.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <unistd.h>

static int config_event(int fd) {
    _Alignas(struct inotify_event) char buffer[16384];
    ssize_t count;
    int changed = 0;
    while ((count = read(fd, buffer, sizeof(buffer))) > 0) {
        for (char *p = buffer; p < buffer + count;) {
            struct inotify_event *event = (struct inotify_event *)p;
            if ((event->mask & IN_Q_OVERFLOW) ||
                (event->len && strcmp(event->name, "config") == 0))
                changed = 1;
            p += sizeof(*event) + event->len;
        }
    }
    return changed;
}

static int exit_code(int status) {
    if (WIFEXITED(status))
        return WEXITSTATUS(status);
    if (WIFSIGNALED(status))
        return 128 + WTERMSIG(status);
    return 1;
}

static int wait_for_child(pid_t child, int *status) {
    while (waitpid(child, status, 0) < 0) {
        if (errno == EINTR)
            continue;
        return -1;
    }
    return 0;
}

int main(int argc, char **argv) {
    (void)argc;
    const char *home = getenv("HOME");
    if (!home || !*home) {
        fprintf(stderr, "fetch: HOME is not set\n");
        return 127;
    }

    char real[PATH_MAX], directory[PATH_MAX];
    if (snprintf(real, sizeof(real), "%s/.local/libexec/areofyl-fetch/fetch", home) >= (int)sizeof(real) ||
        snprintf(directory, sizeof(directory), "%s/.config/fetch", home) >= (int)sizeof(directory)) {
        fprintf(stderr, "fetch: configured path is too long\n");
        return 127;
    }

    int fd = inotify_init1(IN_NONBLOCK | IN_CLOEXEC);
    if (fd < 0 || inotify_add_watch(fd, directory,
            IN_MOVED_TO | IN_CLOSE_WRITE | IN_CREATE | IN_DELETE | IN_ATTRIB) < 0) {
        if (fd >= 0)
            close(fd);
        argv[0] = "fetch";
        execv(real, argv);
        perror("fetch: could not start the original program");
        return 127;
    }

    prctl(PR_SET_NAME, "fetch", 0, 0, 0);
    argv[0] = "fetch";

    for (;;) {
        pid_t child = fork();
        if (child < 0) {
            perror("fetch: fork");
            close(fd);
            return 127;
        }
        if (child == 0) {
            execv(real, argv);
            perror("fetch: could not start the original program");
            _exit(127);
        }

        int status = 0;
        int restart = 0;
        for (;;) {
            pid_t result = waitpid(child, &status, WNOHANG);
            if (result == child)
                break;
            if (result < 0 && errno != EINTR) {
                perror("fetch: waitpid");
                close(fd);
                return 1;
            }

            struct pollfd event = {.fd = fd, .events = POLLIN};
            int ready = poll(&event, 1, 500);
            if (ready > 0 && (event.revents & POLLIN) && config_event(fd)) {
                kill(child, SIGINT);
                if (wait_for_child(child, &status) < 0) {
                    perror("fetch: waitpid after theme change");
                    close(fd);
                    return 1;
                }
                restart = 1;
                break;
            }
        }

        if (restart)
            continue;
        close(fd);
        return exit_code(status);
    }
}
