#!/bin/bash

cat <<END | sudo tee /etc/sysctl.d/90-kernel-panic.conf && sudo sysctl --system
kernel.panic_on_oops=1
kernel.panic=60

kernel.hung_task_timeout_secs=120
kernel.hung_task_panic=0

kernel.softlockup_panic=1
kernel.hardlockup_panic=1

kernel.watchdog=1
kernel.watchdog_thresh=30
END
