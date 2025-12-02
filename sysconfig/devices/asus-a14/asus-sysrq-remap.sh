#!/bin/bash

HWDB_PATH="/etc/udev/hwdb.d/90-custom-sysrq.hwdb"
sudo mkdir -p $(dirname $HWDB_PATH)

cat <<-END | sudo tee $HWDB_PATH
evdev:name:Asus WMI hotkeys:
 KEYBOARD_KEY_26=sysrq
END

sudo systemd-hwdb update
sudo udevadm trigger
