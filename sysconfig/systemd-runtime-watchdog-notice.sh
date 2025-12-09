#!/bin/bash

sudo mkdir -p /etc/systemd/system.conf.d
cat <<END | sudo tee /etc/systemd/system.conf.d/10-watchdog.conf && sudo systemctl daemon-reload
[Manager]
# Notify
# default: off
RuntimeWatchdogPreSec=60s

# Reboot if PID 1 (systemd) stops 
# kicking the watchdog over this limit
# default: off
RuntimeWatchdogSec=off

# Ensure the HW watchdog will reset 
# if shutdown/reboot hangs over this limit
# default: 10min
RebootWatchdogSec=5min
END
