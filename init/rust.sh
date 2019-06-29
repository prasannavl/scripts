#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    ensure_script_dir
    SCRIPTS_DIR=${_SCRIPT_DIR}/..
}

main() {
    setup_vars
    curl https://sh.rustup.rs -sSf | sh
    ${SCRIPTS_DIR}/devtools/rustup-helper.sh stable
    ${SCRIPTS_DIR}/devtools/rustup-helper.sh nightly
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

main "$@"
