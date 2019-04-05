#!/bin/bash

cat <<EOF | sudo tee /etc/systemd/system/hp-keycodes-fix.service && sudo systemctl enable hp-keycodes-fix

# Set HP e057 and e058 as Keycode 240 (KEY_UNKNOWN)
# This helps fix the automatic switch to airplane mode
# on gnome-shell, while laptop tilt/lid open-close, etc.

[Unit]
Description=HP Keycodes

[Service]
Type=simple
ExecStart=/usr/bin/setkeycodes e057 240 e058 240

[Install]
WantedBy=sysinit.target

EOF
