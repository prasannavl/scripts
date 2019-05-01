#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    ensure_script_dir
    SCRIPTS_DIR=${_SCRIPT_DIR}/..
    LOCAL_BIN=$HOME/.local/bin
}

main() {
    setup_vars
    mkdir ${LOCAL_BIN} -p
    ln -s -T ${SCRIPTS_DIR}/devtools/node-repl.sh ${LOCAL_BIN}/node-repl
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

main "$@"