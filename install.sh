#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")" && pwd)
stamp=$(date +%Y%m%d-%H%M%S)
backup_root="$HOME/.local/state/cachyos-kde-rice/backups/$stamp"

backup_path() {
    target=$1
    if [ -e "$target" ]; then
        saved_dir=$(dirname "$target" | sed 's#[^A-Za-z0-9_.-]#_#g')
        mkdir -p "$backup_root/$saved_dir"
        cp -a "$target" "$backup_root/$saved_dir/"
    fi
}

install_file() {
    source=$1
    target=$2
    mode=$3
    mkdir -p "$(dirname "$target")"
    backup_path "$target"
    install -m "$mode" "$source" "$target"
}

install_tree() {
    source=$1
    target=$2
    mkdir -p "$(dirname "$target")"
    backup_path "$target"
    mkdir -p "$target"
    cp -a "$source"/. "$target"/
}

asset_tmp=$(mktemp -d)
trap 'rm -rf "$asset_tmp"' EXIT

install_theme_bundle() {
    bundle=$1
    folder=$2
    target_root=$3
    tar -xzf "$bundle" -C "$asset_tmp"
    mkdir -p "$target_root"
    for source in "$asset_tmp/$folder"/*; do
        [ -d "$source" ] || continue
        backup_path "$target_root/$(basename "$source")"
        cp -a "$source" "$target_root/"
    done
}

for source in "$repo_dir"/scripts/*; do
    [ -f "$source" ] || continue
    install_file "$source" "$HOME/.local/bin/$(basename "$source")" 755
done

install_file "$repo_dir/src/fetch-watch.c" "$HOME/.local/libexec/areofyl-fetch/fetch-watch.c" 644
install_theme_bundle "$repo_dir/rice-icons-54.tar.gz" icons "$HOME/.local/share/icons"
install_theme_bundle "$repo_dir/rice-wallpapers-01-of-02.tar.gz" wallpapers "$HOME/.local/share/wallpapers"
install_theme_bundle "$repo_dir/rice-wallpapers-02-of-02.tar.gz" wallpapers "$HOME/.local/share/wallpapers"

for source in "$repo_dir"/assets/color-schemes/*.colors; do
    [ -f "$source" ] || continue
    install_file "$source" "$HOME/.local/share/color-schemes/$(basename "$source")" 644
done

for source in "$repo_dir"/config/konsole/*; do
    [ -f "$source" ] || continue
    install_file "$source" "$HOME/.local/share/konsole/$(basename "$source")" 644
done

install_tree "$repo_dir/config/plasma/local.phosphor.seasons" "$HOME/.local/share/plasma/plasmoids/local.phosphor.seasons"
qml="$HOME/.local/share/plasma/plasmoids/local.phosphor.seasons/contents/ui/main.qml"
sed -i "s|@HOME@|$HOME|g" "$qml"

for source in "$repo_dir"/config/waybar/*; do
    [ -f "$source" ] || continue
    install_file "$source" "$HOME/.config/waybar/$(basename "$source")" 644
done

install_file "$repo_dir/config/fish/90-rice-visualizer.fish" "$HOME/.config/fish/conf.d/90-rice-visualizer.fish" 644
install_file "$repo_dir/config/fish/fish-greeting.fish" "$HOME/.config/fish/conf.d/91-rice-fetch-greeting.fish" 644
install_file "$repo_dir/config/autostart/cyberpunk-rice.desktop" "$HOME/.config/autostart/cyberpunk-rice.desktop" 644
sed -i "s|@HOME@|$HOME|g" "$HOME/.config/autostart/cyberpunk-rice.desktop"

printf 'Rice files installed. Backups are in %s\n' "$backup_root"
printf 'Add the Sessions widget from Plasma’s widget picker if you want it on the panel.\n'
