#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    PALETTE="$(mktemp /tmp/ffmpeg2gifXXXXXX.png)"
}

main() {
    if [[ $# -lt 4 || $# -gt 5 ]]; then
        cat <<-EOH
		$0: Script to generate animated gif from video.
		
		Usage:
		$0 input.(mp4|avi|webm|flv|...) output.gif horizontal_resolution fps "[opts]"
		> opts: -ss seconds [-to seconds || -t duration]
		EOH
    else
        setup_vars
        trap cleanup 1 2 3 6 15 ERR
        run "$@"
    fi
    cleanup
}

run() {
    local input="${1:?input required}"
    local output="${2:?output required}"
    local resolution=${3:?resolution required}
    local fps=${4:?fps required}
    local opts="${5:-}"                                             # -ss seconds [-to seconds/-t duration]

    local filters="fps=${fps},scale=${resolution}:-1:flags=lanczos" #crop=w:h:x:y

    ffmpeg -v warning $opts -i "${input}" -vf "$filters,palettegen" -y "$PALETTE"
    ffmpeg -v warning $opts -i "${input}" -i $PALETTE -lavfi "$filters [x]; [x][1:v] paletteuse" -y "${output}"
}

cleanup() {
    rm -f $PALETTE
}

main "$@"
