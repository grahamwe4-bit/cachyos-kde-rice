# tut in docs




# CachyOS KDE Rice

A snapshot of a custom CachyOS KDE Plasma 6 desktop rice, assembled from the running setup on 2026-11-23. It includes the theme switcher, the seasonal/session widget, Waybar, Konsole profiles, Matrix and CAVA launchers, synchronized icons and color schemes, and the wallpaper collections.

This repository is private because it contains a detailed personal desktop configuration. The copied files have home-directory paths removed or templated. No application binaries, backups, caches, personal desktop shortcuts, or credentials are included.

## What is included

- 54 custom icon themes and 54 KDE color schemes.
- 50 wallpaper collections with their static artwork and available live-video variants.
- 54 themed Konsole profiles and matching color schemes.
- The `local.phosphor.seasons` Plasma widget, including its session artwork.
- Rice scripts for switching modes, changing seasons, refreshing icons, starting and positioning CMatrix/CAVA, and recoloring Waybar and areofyl/fetch.
- The Waybar configuration and style, plus Fish snippets for the Matrix/CAVA launchers and the current `fetch` greeting.
- Source for the small areofyl/fetch theme-change watcher. The upstream `fetch` executable is not included.

The icon collection and 50 wallpaper collections are in three compressed bundles at the repository root: `rice-icons-54.tar.gz` and `rice-wallpapers-01-of-02.tar.gz` / `rice-wallpapers-02-of-02.tar.gz`. They preserve the original icon and wallpaper folder names. Extract the icon bundle under `~/.local/share/` and the wallpaper bundles under `~/.local/share/`.

## Install on the original setup

On CachyOS with KDE Plasma 6, run:

```bash
bash install.sh
```

The installer backs up files it replaces to `~/.local/state/cachyos-kde-rice/backups/` before copying the rice. It does not change panel geometry or add the session widget to a panel. Add **Sessions** from Plasma's widget picker if you want the dropdown on the panel.

The live wallpaper switching uses the KDE **Smart Video Wallpaper Reborn** wallpaper plugin. Static backgrounds are included as fallbacks. The Waybar configuration targets the original laptop display (`eDP-1`) and is optional; it does not replace Plasma's panel.

For the full order of operations—including package setup, areofyl/fetch, live wallpapers, the Sessions widget, startup visualizers, and optional Waybar—see the [installation and setup tutorial](docs/INSTALLATION.md).

## Tools and upstream software

The setup uses KDE Plasma 6, Konsole, Fish, CAVA, CMatrix, Waybar, `plasma-apply-colorscheme`, and KDE's `kwriteconfig6`/`kreadconfig6`. The Fish greeting runs the live command [areofyl/fetch](https://github.com/areofyl/fetch); its upstream program is intentionally not copied as a compiled binary. Install it from its upstream project, then use the included theme-sync scripts. `fastfetch` is only used by the theme-sync script as a one-time CachyOS logo extractor if no fetch logo has been saved yet. Building the included watcher requires a C compiler.

The exact scripts and configuration here reflect one machine and its installed KDE widgets and applications. Review `install.sh` and the configuration before adapting it to another desktop.
