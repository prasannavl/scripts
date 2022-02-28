#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    LOCAL_BIN=$HOME/.local/bin
}

symlink_to_local_bin() {
    mkdir ${LOCAL_BIN} -p
    rm ${LOCAL_BIN}/deno || true
    ln -s $HOME/.deno/bin/deno ${LOCAL_BIN}
}

main() {
    setup_vars
    curl -fsSL https://deno.land/x/install/install.sh | sh
    symlink_to_local_bin
}

main "$@"
