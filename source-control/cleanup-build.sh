#!/bin/bash

main() {
    target="${1:-}"
    do_clean=${2:-false}
    walk_dir "${target}" ${do_clean}
}

walk_dir() {
    dir="${1:?}"
    do_clean=${2:-false}
    for x in "${dir}"/*; do
        if [ -d "$x" ]; then 
            if [ -f "${x}/Makefile" ]; then
                echo "make: ${x}/Makefile"
                make_clean "${x}" ${do_clean}
            fi
            if [ -d "${x}/node_modules" ]; then
                echo "node: ${x}/node_modules"
                rmf "${x}/node_modules" ${do_clean}
            elif [ -f "${x}/Cargo.toml" ]; then
                echo "rust: ${x}"
                rmf "${x}/target" ${do_clean}
            fi 
            walk_dir "${x}" ${do_clean}
        fi
    done
}

make_clean() {
    target=${1:?}
    do_clean=${2:-false}
    if [[ $do_clean == true ]]; then 
        make --directory="${target}" purge || true
    	make --directory="${target}" clean || true
    fi
}

rmf() {
    target=${1:?}
    do_clean=${2:-false}
    if [[ $do_clean == true ]]; then 
    	rm -rf "${target}" || true
    fi
}


run() {
    init
    main "$@"
    cleanup
}

init() {
    if [ -z "$_INIT" ]; then 
        _INIT="1"
    else
        return 0
    fi
    set -Eeuo pipefail
    _OPWD="$(pwd)"
    trap cleanup 1 2 3 6 15 ERR
    
    # script dir
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SPWD="$( cd "${dir}/" && pwd )"
    # cd "${_SPWD}"
    if [ "$(type -t setup_vars)" == "function" ]; then
        setup_vars
    fi
}

cleanup() {
    : # cd "$_OPWD"
}

run "$@"
