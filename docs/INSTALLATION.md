# Installation and setup tutorial

This guide installs the rice on CachyOS with KDE Plasma 6. The repository is private, so the computer needs access through the owning GitHub account or an invited collaborator account.

The snapshot is tailored to the original laptop and its Plasma panel. The installer backs up files it replaces, but it does not restore panel layout or pinned apps, change panel dimensions, or add the Sessions widget to the panel.

## 1. Install the tools

In Konsole, install the packages used by the rice. This command works from Fish:

```bash
sudo pacman -S --needed git base-devel fish konsole cmatrix cava fastfetch qt6-multimedia qt6-multimedia-ffmpeg
```

Waybar is optional. Install it only if you want the extra bar:

```bash
sudo pacman -S --needed waybar
```

`base-devel` provides the C compiler used for the fetch theme watcher. `fastfetch` is only used once if the theme-sync script needs to create a CachyOS logo file; it is not the terminal greeting. The greeting uses [areofyl/fetch](https://github.com/areofyl/fetch).

## 2. Install areofyl/fetch

The upstream project documents the Arch AUR package as `fetch-git`. Use whichever AUR helper is already installed:

```bash
paru -S fetch-git
```

Or, with yay:

```bash
yay -S fetch-git
```

The rice's watcher needs the upstream executable at `~/.local/libexec/areofyl-fetch/fetch`. On a fresh computer, after installing `fetch-git`, copy the system executable there:

```bash
install -Dm755 /usr/bin/fetch "$HOME/.local/libexec/areofyl-fetch/fetch"
```

If the AUR package installed `fetch` somewhere other than `/usr/bin/fetch`, use that installed path in the command. On the original laptop, the upstream executable is already at the destination, so skip the copy step there.

## 3. Get the private repository

Clone it if Git is signed in to an account that has access:

```bash
git clone https://github.com/grahamwe4-bit/cachyos-kde-rice.git
cd cachyos-kde-rice
```

Or sign in to GitHub in a browser, open this repository, choose **Code → Download ZIP**, extract it, then open Konsole in the extracted folder.

## 4. Install the rice files

Run the included installer from the repository folder:

```bash
bash install.sh
```

It installs the mode-switching and startup scripts, custom color schemes, Konsole profiles, icon and wallpaper bundles, the Sessions widget, Fish snippets, and Waybar configuration. Before replacing existing files or theme folders, it saves copies under:

```text
~/.local/state/cachyos-kde-rice/backups/
```

The installer does not install the upstream fetch program or the live-wallpaper plugin. Those are separate steps in this guide. It also does not apply a theme or change your panel's size or pinned items.

## 5. Build the theme-aware fetch launcher

The installer copied the watcher source into `~/.local/libexec/areofyl-fetch/fetch-watch.c`. Build the small launcher with:

```bash
cc -O2 -Wall -Wextra -o "$HOME/.local/bin/fetch" "$HOME/.local/libexec/areofyl-fetch/fetch-watch.c"
```

If Fish does not find `fetch`, add the local bin directory to its path:

```fish
fish_add_path "$HOME/.local/bin"
```

The watcher restarts areofyl/fetch when the theme-sync script updates its color configuration. The original executable must remain at `~/.local/libexec/areofyl-fetch/fetch`.

If rebuilding on an existing setup, preserve the current launcher first:

```fish
test -e "$HOME/.local/bin/fetch"; and cp -a "$HOME/.local/bin/fetch" "$HOME/.local/bin/fetch.before-watcher"
```

The compiler command replaces `~/.local/bin/fetch` with the watcher.

## 6. Install the live-wallpaper plugin

On the desktop, right-click an empty area and open **Desktop and Wallpaper**. Choose **Get New Plugins**, search for **Smart Video Wallpaper Reborn**, and install it. The project also documents this flow in its [README](https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn#usage).

The `qt6-multimedia` and `qt6-multimedia-ffmpeg` packages are included in the package command above. If the plugin installs but a video stays blank, check that the required media codecs are available for the video files.

## 7. Apply a first theme

After installing the plugin, apply a mode once to load its matching colors, icons, Konsole profile, lock-screen image, wallpaper, and fetch colors. For example:

```bash
~/.local/bin/rice-switch lofi14
```

Other example commands:

```bash
~/.local/bin/rice-switch overdrive14
~/.local/bin/rice-switch old-times
~/.local/bin/phosphor-season winter
```

For the season-aware automatic choice, use:

```bash
~/.local/bin/phosphor-season auto
```

Once the widget is on the panel, use **Sessions** to pick a mode or season instead of typing these commands.

## 8. Add the Sessions widget to the panel

1. Right-click the Plasma panel and choose **Enter Edit Mode**.
2. Choose **Add Widgets**.
3. Search for **Sessions**.
4. Drag it to the panel and leave edit mode.

Adding the widget does not resize the panel or remove pinned apps. The repository intentionally does not contain the panel-layout file, so it will not recreate the original taskbar arrangement.

The switcher scripts also refer to the original Plasma applet IDs when refreshing the launcher artwork. On a different Plasma profile, those IDs may differ; review the applet ID values in `scripts/rice-switch` and `scripts/phosphor-season` before using the switcher there.

## 9. Start CMatrix and CAVA

The installer adds the rice's autostart entry. Log out of Plasma and back in once; it launches the two Konsole visualizers and positions them as borderless panes. The script places CMatrix on the left and CAVA on the right. You can also launch them manually from Fish with `cmatrix` and `cava`.

## 10. Add Waybar (optional)

Start it once from Konsole:

```bash
waybar
```

The provided config targets the original laptop display (`eDP-1`) and places the bar at the top. Check its position before making it start automatically; press **Ctrl+C** in Konsole to stop this test run. This config has `"exclusive": false`, which allows the bar to overlay the top of a window; if it covers Chrome's tabs, change that value to `true` in `~/.config/waybar/config.jsonc` and restart Waybar. On another monitor, update the `output` setting to match that display or remove it to let Waybar use the default output.

After confirming its placement, add **Waybar** from **System Settings → Autostart → Add Application** if you want it at every login. Waybar is separate from Plasma's panel and can be skipped.

## 11. Verify the setup

- Click **Sessions** and switch between Lo-Fi, Phosphor, Overdrive, Old Times, and Colorways. Check that the icons, colors, terminal profile, and wallpaper match.
- Choose a Phosphor season and confirm that the wallpaper and icons change with it.
- Open a new Fish terminal and confirm the animated areofyl/fetch greeting appears.
- Log out and back in to confirm the CMatrix/CAVA startup pair appears.
- If the desktop wallpaper stays static, confirm Smart Video Wallpaper Reborn is installed and restart the Plasma session.

## Restore backed-up files

The installer's dated backups are under `~/.local/state/cachyos-kde-rice/backups/`. To restore a file, copy its saved version back to the matching location. The installer does not change the Plasma panel layout or pinned apps, so there is no panel state to restore.
