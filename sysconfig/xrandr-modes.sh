#!/bin/bash

set -Eeuo pipefail

# https://xorg-team.pages.debian.net/xorg/howto/use-xrandr.html
# autoscan: xrandr --auto
# turn off: xrandr --output eDP --off
# default: xrandr --output eDP --auto
# mode: xrandr --output eDP --mode 1024x768 --rate 75
# scale: xrandr --output eDP --scale 0.8x0.8
# ls /sys/class/drm/*/edid | xargs -i{} sh -c "echo {}; parse-edid < {}"
# https://tomverbeure.github.io/video_timings_calculator

setup_vars() {
    OUTPUT="eDP"
}

xrandr_add() {
    local cvtmode=${1?-cvt mode line required}
    local output=${2:-$OUTPUT}

    local modeline
    local modename

    modeline=$(echo $cvtmode | sed 's/.*Modeline \(.*\)/\1/' | xargs)
    modename=$(echo $modeline | cut -d" " -f1)
    [[ -z $modeline ]] && echo "error: Invalid mode line" && return 

    xrandr --newmode $modeline
    xrandr --addmode "$output" "$modename"
    echo "$modename"
}

xrandr_del() {
    local modename=${1?-mode name required}
    local output=${2:-$OUTPUT}

    xrandr --delmode "$output" "$modename" || true
    xrandr --rmmode "$modename"
    xrandr -q
}

main() {
    setup_vars
    local cvtmode
    # cvtmode=$(cvt -r 1920 1080 60)
    cvtmode=$(cvt 1920 1080 60)
    # xrandr_add "$cvtmode"
}

main