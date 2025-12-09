#!/bin/bash

sudo mkdir -p /etc/systemd/system/evremap.service.d
cat <<-END | sudo tee /etc/systemd/system/evremap.service.d/default.conf
    [Unit]
    Before=keyd.service display-manager.service

    [Service]
    Restart=on-failure
END

cat <<-END | sudo tee /etc/evremap.toml
    device_name = "AT Translated Set 2 keyboard"
    # device_name = "Asus WMI hotkeys"

    [[remap]]
    input = [ "KEY_PROG3" ]
    output = [ "KEY_SYSRQ" ]
END

sudo systemctl daemon-reload
sudo systemctl enable evremap.service && sudo systemctl restart evremap.service
