#!/bin/bash

file=/etc/default/grub
val=${1:-4}
m='^#?\s*(GRUB_TIMEOUT=)([0-9]+)\s*$'
r="\\1${val}\n"
pattern="s/${m}/${r}/"

echo "> original from: $file"
grep -P "${m}" $file

echo "processing: $file"
sudo sed -i -E "${pattern}" $file

printf "\n> processed:\n"
grep -P "${m}" $file
