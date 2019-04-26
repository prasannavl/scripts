#!/bin/bash

cat <<END  | sudo tee /usr/share/X11/xorg.conf.d/10-synaptics-disable.conf
# Disable generic Synaptics device
Section "InputClass"
        Identifier "SynPS/2 Synaptics TouchPad"
        MatchProduct "SynPS/2 Synaptics TouchPad"
        MatchIsTouchpad "on"
        MatchOS "Linux"
        MatchDevicePath "/dev/input/event*"
        Option "Ignore" "on"
EndSection
END
