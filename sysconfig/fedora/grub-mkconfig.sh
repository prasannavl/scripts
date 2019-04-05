#!/bin/bash

set -x
file=/boot/efi/EFI/fedora/grub.cfg

sudo test -f $file || { echo "config not found: ${file}" && exit 1; }

echo "> grub2-mkconfig:"
sudo grub2-mkconfig -o ${file}
