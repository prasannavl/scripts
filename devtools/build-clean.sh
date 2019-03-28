#!/bin/bash

set -Eeuo pipefail

run() {
    local target="${1:?target required}"
    local do_clean=${2:-false}
    if [[ $do_clean == false ]]; then
    	echo "> [dry run]";
    else 
    	echo "> [cleaning up]";
    fi
    walk_dir "${target}" ${do_clean}
}

walk_dir() {
    local dir="${1:?}"
    local do_clean=${2:-false}
    for x in "${dir}"/*; do
        if [[ -d "$x" ]]; then 
            if [[ -f "${x}/Makefile" ]]; then
                echo "make: ${x}/Makefile"
                make_clean "${x}" ${do_clean}
            fi
            if [[ -d "${x}/node_modules" ]]; then
                echo "node: ${x}/node_modules"
                rmf "${x}/node_modules" ${do_clean}
            elif [[ -f "${x}/Cargo.toml" ]]; then
                echo "rust: ${x}"
                rmf "${x}/target" ${do_clean}
            fi 
            walk_dir "${x}" ${do_clean}
        fi
    done
}

make_clean() {
    local target=${1:?}
    local do_clean=${2:-false}
    if [[ $do_clean == true ]]; then 
        make --directory="${target}" purge || true
    	make --directory="${target}" clean || true
    fi
}

rmf() {
    local target=${1:?}
    local do_clean=${2:-false}
    if [[ $do_clean == true ]]; then 
    	rm -rf "${target}" || true
    fi
}

run "$@"
