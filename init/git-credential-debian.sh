#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    ensure_script_dir
    SCRIPTS_DIR=${_SCRIPT_DIR}/..
    LOCAL_BIN=$HOME/.local/bin
    LOCAL_APP_SRC=$HOME/.local/src/git-credential-libsecret
    DIST_APP_SRC=/usr/share/doc/git/contrib/credential/libsecret
}

check_src() {
    [[ -d "${DIST_APP_SRC}" ]] || { 
            echo "> git-credential-libsecret src not found at: ${DIST_APP_SRC}"
            exit 1
        }
    if ! dpkg -l libsecret-1-dev &> /dev/null; then 
        "> package libsecret-1-dev not found; installing.."
        sudo apt install libsecret-1-dev
    fi
}

main() {
    setup_vars
    check_src
    mkdir ${LOCAL_BIN} -p
    mkdir ${LOCAL_APP_SRC} -p
    echo "> copying src to: ${LOCAL_APP_SRC}"
    cp -R ${DIST_APP_SRC}/. ${LOCAL_APP_SRC}
    cd ${LOCAL_APP_SRC}
    echo "> building.."
    make
    echo "> build success"
    mv ./git-credential-libsecret ${LOCAL_BIN}/
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

main "$@"
