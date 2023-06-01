#!/bin/bash

set -Eeuo pipefail

setup() {
    BACKUP_TARGET="$HOME/data/backup/dconf/"

    # Keybindings
    KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings
    KEYS_GNOME_SHELL=/org/gnome/shell/keybindings
    KEYS_MUTTER=/org/gnome/mutter/keybindings
    KEYS_MEDIA=/org/gnome/settings-daemon/plugins/media-keys
    KEYS_MUTTER_WAYLAND_RESTORE=/org/gnome/mutter/wayland/keybindings/restore-shortcuts
    ALL_KEYBINDING_KEYS=("$KEYS_GNOME_WM" "$KEYS_GNOME_SHELL" "$KEYS_MUTTER" "$KEYS_MEDIA" "$KEYS_MUTTER_WAYLAND_RESTORE")
}

backup() {
    local target_dir="$BACKUP_TARGET"
    local all_keybinding_keys=("${ALL_KEYBINDING_KEYS[@]}")
    mkdir -p "$target_dir"

    dconf dump / > $target_dir/all.dconf
    gsettings list-recursively > $target_dir/all.gsettings

    # Key bindings
    local x
    local settings_file
    for x in "${all_keybinding_keys[@]}"; do
        settings_file="$target_dir/settings${x//\//.}.dconf"
        echo "$x" "=>" "$settings_file"
        dconf dump "$x/" > "$settings_file"
    done
}

restore() {
    local target_dir="$BACKUP_TARGET"
    local all_keybinding_keys=("${ALL_KEYBINDING_KEYS[@]}")

    # Key bindings
    local x
    local settings_file
    local dconf_path
    for x in "${all_keybinding_keys[@]}"; do
        settings_file="$target_dir/settings${x//\//.}.dconf"
        echo "$settings_file" "=>" "$x" 
        dconf load "$x/" > "$settings_file"
    done
}

main() {
    setup
    backup
}

main