#!/bin/bash

cat <<EOF | sudo tee /usr/share/X11/xorg.conf.d/20-intel.conf
Section "Device"
  Identifier  "Intel Graphics"
  Driver      "intel"
  Option      "TearFree" "true"
  Option      "AccelMethod" "sna"
  Option      "DRI" "2"
EndSection
EOF

## Other options for reference
# Option      "DRI" "3"
# Option      "TearFree" "true"
# Option      "AccelMethod" "sna"
