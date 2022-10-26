#!/bin/bash

file=/etc/systemd/logind.conf

# options: suspend (default), ignore, etc
val=${1:-ignore}

m='^#?HandleLidSwitch=.*$'
r="HandleLidSwitch=${val}\n"
pattern="s/${m}/${r}/"

echo "> original from: $file"
grep -P "${m}" $file

echo "processing: $file"
sudo sed -i -E "${pattern}" $file

printf "\n> processed:\n"
grep -P "${m}" $file
