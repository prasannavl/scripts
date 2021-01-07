#!/bin/bash

set -Eeuo pipefail

suffix="$(set +o pipefail && cat /dev/urandom | base64 | head -c8)"

echo "moving $1 to $1.${suffix}"
mv "$1" "$1.${suffix}"
echo "moving $2 to $1"
mv "$2" "$1"
echo "moving $1.${suffix} to $2"
mv "$1.${suffix}" "$2"