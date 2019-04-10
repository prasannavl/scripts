#!/bin/bash

set -Eeuo pipefail

LOCAL_BIN=$HOME/.local/bin

mkdir ${LOCAL_BIN} -p
ln -s -T $HOME/scripts/devtools/node-repl.js ${LOCAL_BIN}/node-repl