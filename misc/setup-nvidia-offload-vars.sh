#!/bin/bash

# This script sets up NVIDIA prime offload variables
# when sourced.

main() {
    if [[ $_ != $0 ]]; then
        set_vars
    else 
        err_exit
    fi
}

set_vars() {
    if [[ -n "${__NV_PRIME_RENDER_OFFLOAD}" ]]; then
        echo "WARN: __NV_PRIME_RENDER_OFFLOAD currently set to \"${__NV_PRIME_RENDER_OFFLOAD}\""
    fi
    if [[ -n "${__GLX_VENDOR_LIBRARY_NAME}" ]]; then
        echo "WARN: __GLX_VENDOR_LIBRARY_NAME currently set to \"${__GLX_VENDOR_LIBRARY_NAME}\""
    fi
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    echo "__NV_PRIME_RENDER_OFFLOAD and __GLX_VENDOR_LIBRARY_NAME set"
}

err_exit() {
    echo "ERROR: This script is meant to be sourced, not executed"
    echo "INFO: It sets __NV_PRIME_RENDER_OFFLOAD and __GLX_VENDOR_LIBRARY_NAME, when sourced"
    exit 1
}

main "$@"