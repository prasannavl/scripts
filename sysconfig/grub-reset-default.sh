#!/bin/bash

cat <<END | sudo tee /etc/default/grub.d/00-reset-default.cfg
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
END
