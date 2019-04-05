#!/bin/bash

cat <<END | sudo tee /etc/sysctl.d/90-coredump.conf && sudo sysctl --system
kernel.core_uses_pid=1
END
