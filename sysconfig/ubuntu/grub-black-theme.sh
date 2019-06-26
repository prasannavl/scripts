#!/bin/bash

file="/etc/grub.d/black_background"

cat <<EOF | sudo tee "${file}"
echo "if background_color 0,0,0; then"
echo "  clear"
echo "fi"
echo "set color_normal=light-gray/black"
echo "set color_highlight=black/light-gray"
echo "set menu_color_normal=light-gray/black"
echo "set menu_color_highlight=black/light-gray"
EOF

sudo chmod +x "${file}"

debian_theme_file="/etc/grub.d/05_debian_theme"
if [[ -x "${debian_theme_file}" ]]; then
    sudo chmod -x "${debian_theme_file}"
fi