#!/bin/bash

sudo mkdir -p /etc/systemd/logind.conf.d
cat <<END | sudo tee /etc/systemd/logind.conf.d/10-ignore-lid.conf && sudo systemctl daemon-reload
[Login]
HandleLidSwitch=ignore
END
