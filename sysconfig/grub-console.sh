#!/bin/bash

cat <<END | sudo tee /etc/default/grub.d/10-console.cfg
# Enable console framebuffer on first VGA device / first monitor
GRUB_CMDLINE_LINUX_DEFAULT="\$GRUB_CMDLINE_LINUX_DEFAULT fbcon=map:0"
END
