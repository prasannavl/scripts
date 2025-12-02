#!/bin/bash

sudo mkdir -p /etc/systemd/logind.conf.d
cat <<END | sudo tee /etc/systemd/logind.conf.d/10-ignore-lid-on-ext-power.conf && sudo systemctl daemon-reload
[Login]
HandleLidSwitchExternalPower=ignore
END
