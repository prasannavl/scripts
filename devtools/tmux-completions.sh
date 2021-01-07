#!/bin/sh

set -Eeuo pipefail

out_file="$HOME/.bash_completion.d/tmux"
dir_path="$(dirname "$out_file")"
if ! [ -d "$dir_path" ]; then
    echo ">> $dir_path not found"
    exit 1
fi

wget -O "$out_file" https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux
