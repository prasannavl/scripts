#!/bin/bash

set -Eeuo pipefail

main() {
    if [[ $# -lt 1 || $# -gt 2 ]]; then
        echo "Usage: $0 device_number [brightness_to_set]"
        echo 
        # ls -ld /sys/class/backlight/ddcci*
        find /sys/class/backlight/ -type l -name "ddcci*" -exec \
         sh -c "echo \$(basename {}): \$(readlink -e {})" \;
        return 1
    fi
    local device_num=${1?-device number required}
    shift
    ensure_script_dir
    BRIGHTNESS_DEVICE="/sys/class/backlight/ddcci${device_num}" "${_SCRIPT_DIR}/brightness.sh" "$@"
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

main "$@"
