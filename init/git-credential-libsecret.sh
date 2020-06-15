#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    ensure_script_dir
    LOCAL_BIN=$HOME/.local/bin
    DEBIAN_WORK_DIR=$HOME/.local/src/git-credential-libsecret
    DEBIAN_SRC_DIR=/usr/share/doc/git/contrib/credential/libsecret
}

check_os() {
    test -f /etc/os-release
    source /etc/os-release
    [[ "$ID_LIKE" == "debian" ]] || {
        echo "> This script only works on Debian based OS. Exiting"
        exit 1
    }
}

check_src() {
    check_os
    [[ -d "${DEBIAN_SRC_DIR}" ]] || { 
            echo "> git-credential-libsecret src not found at: ${DEBIAN_SRC_DIR}"
            exit 1
        }
    if ! dpkg -l libsecret-1-dev &> /dev/null; then 
        echo "> package libsecret-1-dev not found; installing.."
        sudo apt install libsecret-1-dev
    fi
}

main() {
    setup_vars
    check_src
    mkdir ${LOCAL_BIN} -p
    mkdir ${DEBIAN_WORK_DIR} -p
    echo "> copying src to: ${DEBIAN_WORK_DIR}"
    cp -R ${DEBIAN_SRC_DIR}/. ${DEBIAN_WORK_DIR}
    cd ${DEBIAN_WORK_DIR}
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
