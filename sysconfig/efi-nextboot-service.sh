#!/bin/bash

cat <<EOF | sudo tee /etc/systemd/system/efi-nextboot.service && sudo systemctl enable efi-nextboot

[Unit]
Description=EFI Next Boot

[Service]
Type=simple
ExecStart=/bin/sh -c "efibootmgr -n \$(efibootmgr | head -n1 | grep -Po '[0-9]+')"

[Install]
WantedBy=sysinit.target

EOF
