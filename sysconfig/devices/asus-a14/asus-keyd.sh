#!/bin/bash

sudo mkdir -p /etc/systemd/system/keyd.service.d
cat <<-END | sudo tee /etc/systemd/system/keyd.service.d/default.conf
    [Unit]
    Restart=on-failure
    Requires=evremap.service
END

sudo mkdir -p /etc/keyd/
cat <<-END | sudo tee /etc/keyd/default.conf
    [ids]
    0001:0001:09b4e68d

    [main]
    leftshift+leftmeta+f23 = layer(control)
END

sudo systemctl daemon-reload
sudo systemctl enable keyd.service --now
