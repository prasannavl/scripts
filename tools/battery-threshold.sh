#!/bin/bash

set -Eeuo pipefail

main() {
    local start=${1:--1}
    local end=${2:--1}
    if [[ $start -gt -1 ]] && [[ $end -gt -1 ]]; then
        set $start $end
    else
        get
    fi
}

get() {
    grep "" /sys/class/power_supply/BAT*/charge_*
}

set() {
    echo "set BAT0 start:" $(sudo tee /sys/class/power_supply/BAT0/charge_start_threshold <<< $1)
    echo "set BAT0 end:" $(sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold <<< $2)
}

main "$@"
