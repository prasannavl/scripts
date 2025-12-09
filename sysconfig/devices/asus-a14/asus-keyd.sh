#!/bin/bash

sudo mkdir -p /etc/systemd/system/keyd.service.d
cat <<-END | sudo tee /etc/systemd/system/keyd.service.d/default.conf
    [Unit]
    # Requires=evremap.service

    [Service]
    Restart=on-failure
END

sudo mkdir -p /etc/keyd/
cat <<-END | sudo tee /etc/keyd/default.conf
    [ids]
    # ASUS WMI keyboard
    # 0000:0000:785d076f
    # AT Translated Set 2 keyboard
    0001:0001:3cf016cc

    [main]
    leftmeta+leftshift+f23 = layer(control)
    # leftmeta+leftshift+sysrq = layer(control)
END

sudo systemctl daemon-reload
sudo systemctl enable keyd.service && sudo systemctl restart keyd.service
