#!/bin/bash

HWDB_PATH="/etc/udev/hwdb.d/90-sysrq-at-remap.hwdb"
sudo mkdir -p $(dirname $HWDB_PATH)

#  Right ctrl on the AT keyboard
#  KEYBOARD_KEY_6e=sysrq
# Compose key // Fn + Left Ctrl
#  KEYBOARD_KEY_dd=sysrq

cat <<-END | sudo tee $HWDB_PATH
evdev:name:AT Translated Set 2 keyboard:*
 KEYBOARD_KEY_dd=sysrq
END

sudo systemd-hwdb update
sudo udevadm trigger

systemd-hwdb query 'evdev:name:AT Translated Set 2 keyboard:*'
sudo udevadm info /sys/class/input/event0 | grep KEYBOARD_KEY