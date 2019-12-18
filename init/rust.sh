#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    ensure_script_dir
}

main() {
    setup_vars
    curl https://sh.rustup.rs -sSf | sh
    ${_SCRIPT_DIR}/rust-components.sh stable
    ${_SCRIPT_DIR}/rust-components.sh nightly
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

main "$@"
