#!/bin/bash

sudo mkdir -p /etc/systemd/system/evremap.service.d
cat <<-END | sudo tee /etc/systemd/system/evremap.service.d/default.conf
    [Unit]
    Restart=on-failure
    Before=keyd.service display-manager.service
END

cat <<-END | sudo tee /etc/evremap.toml
    device_name = "Asus WMI hotkeys"

    [[remap]]
    input = [ "KEY_PROG3" ]
    output = [ "KEY_SYSRQ" ]
END

sudo systemctl daemon-reload
sudo systemctl enable evremap.service --now
