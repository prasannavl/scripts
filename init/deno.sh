#!/bin/bash

set -Eeuo pipefail

LOCAL_BIN=$HOME/.local/bin

curl -fsSL https://deno.land/x/install/install.sh | sh
mkdir ${LOCAL_BIN} -p
ln -s $HOME/.deno/bin/deno ${LOCAL_BIN}
