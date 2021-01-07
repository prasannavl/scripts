#!/bin/bash

set -Eeuo pipefail

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

main() {
    ensure_script_dir
    local conf_path=/etc/sudoers.d/50-brightness-scripts
    local script_path1="$HOME/bin/brightness.sh"
    local script_path2="$HOME/bin/brightness-ext.sh"

    cat <<END | sudo tee ${conf_path}
# Allow brightness scripts to be run as root
${USER} ALL=(ALL) NOPASSWD: ${script_path1}
${USER} ALL=(ALL) NOPASSWD: ${script_path2}
END

    sudo chmod 0440 ${conf_path}
}

main "$@"