#!/bin/bash

HWDB_PATH="/etc/udev/hwdb.d/90-sysrq-wmi-remap.hwdb"
sudo mkdir -p $(dirname $HWDB_PATH)

 # ASUS crate key
#  KEYBOARD_KEY_38=sysrq

cat <<-END | sudo tee $HWDB_PATH
evdev:name:Asus WMI hotkeys:*
 KEYBOARD_KEY_38=sysrq
END

sudo systemd-hwdb update
sudo udevadm trigger

systemd-hwdb query 'evdev:name:Asus WMI hotkeys:*'
# sudo udevadm info /sys/class/input/event14 | grep KEYBOARD_KEY