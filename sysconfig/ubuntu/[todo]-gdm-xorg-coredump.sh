#!/bin/bash

echo "[not implemented yet]"
exit 1

# fedora and debian use different paths
if [ -f /etc/gdm/custom.conf ]; then
    file=/etc/gdm/custom.conf
elif [ -f /etc/gdm3/custom.conf ]; then
    file=/etc/gdm3/custom.conf
else
    echo "gdm custom.conf not found. exiting"
    exit 1
fi

# TODO:

# [debug]
# Uncomment the line below to turn on debugging
# More verbose logs
# Additionally lets the X server dump core if it crashes
#Enable=true
