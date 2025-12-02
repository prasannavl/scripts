#!/bin/bash

cat <<END | sudo tee /etc/default/grub.d/50-ramoops.cfg
# 1mb of ramoops memory, 64kb records, 32kb console
GRUB_CMDLINE_LINUX_DEFAULT="\$GRUB_CMDLINE_LINUX_DEFAULT ramoops.mem_size=0x100000 ramoops.record_size=0x10000 ramoops.console_size=0x8000"
END
