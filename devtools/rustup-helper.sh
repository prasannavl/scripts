#!/bin/bash

set -Eeuo pipefail

run() {
    local VERSION=${1:?version not set}

    local COMPONENTS=${COMPONENTS:-"rustfmt \
                            clippy \
                            rust-src \
                            rust-analysis \
                            rls"}

    local TARGETS=${TARGETS:-"wasm32-unknown-unknown \
                        aarch64-linux-android \
                        armv7-linux-androideabi \
                        i686-linux-android"}
    
    rustup toolchain install ${VERSION}
    rustup component add --toolchain ${VERSION} ${COMPONENTS}
    rustup target add --toolchain ${VERSION} ${TARGETS}
}

run "$@"