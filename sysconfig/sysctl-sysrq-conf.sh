#!/bin/bash

cat <<END | sudo tee /etc/sysctl.d/90-sysrq.conf && sudo sysctl --system
kernel.sysrq=1
END
