#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    PROJECT_NAME="${1?project name required as argument}"
    PROJECT_DIR="${_WORKING_DIR}/${PROJECT_NAME}"
}

init() {
    mkdir -p "${PROJECT_DIR}/src" || true
    cd "${PROJECT_DIR}"
    cargo init
    init_files
}

init_files() {
    cat <<EOF > ${PROJECT_DIR}/src/main.rs
#![feature(async_await, existential_type)]
#![deny(
    nonstandard_style,
    rust_2018_idioms,
    future_incompatible,
    missing_debug_implementations
)]

#[macro_use]
extern crate log;

use quixutils::prelude::*;

fn main() -> Result<(), exitfailure::ExitFailure> {
    quixutils::logger::init();
    info!("init");
    Ok(())
}

EOF
}

add() {
    cd "${PROJECT_DIR}"
    # Binary crates
    cargo add env_logger exitfailure structopt
    # Lib crates
    cargo add log failure itertools serde serde_json \
        lazy_static chrono clap rand walkdir time regex \
        hyper quixutils \
        tokio futures-preview@0.3.0-alpha.16
}

run() {
    init
    add
}

main() {
    COMMANDS=("run" "init" "add")

    if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
        usage
        return 0
    fi
    
    ensure_script_dir
    cd "$_SCRIPT_DIR"
    trap cleanup 1 2 3 6 15 ERR
    
    for x in "${COMMANDS[@]}"; do
        local cmd="${1-}"
        if [[ "$x" == "${cmd}" ]]; then
            shift
            setup_vars "$@"
            ${cmd//-/_} "$@"
            cleanup
            return 0
        fi
    done
    
    usage
    cleanup
    return 1
}

usage() {
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "${COMMANDS[@]}"
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

cleanup() {
    cd "$_WORKING_DIR"
}

main "$@"
