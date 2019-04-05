#!/bin/bash

cat <<EOF | sudo tee /etc/modprobe.d/intel-i915.conf
options i915 enable_psr=0
EOF
# modeset=1 enable_fbc=1 enable_psr=1 enable_execlists=0
