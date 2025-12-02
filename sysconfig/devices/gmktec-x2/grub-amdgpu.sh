#!/bin/bash

cat <<END | sudo tee /etc/default/grub.d/20-amdgpu.cfg
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT amdgpu.dcdebugmask=0x10"
END
