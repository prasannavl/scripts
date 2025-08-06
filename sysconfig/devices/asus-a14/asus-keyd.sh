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
    *
    -0000:0000:16a83aed
    [main]
    leftshift+leftmeta = layer(control)
END

sudo systemctl daemon-reload
sudo systemctl enable keyd.service --now
