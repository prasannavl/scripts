#!/bin/bash

files="/etc/systemd/user.conf /etc/systemd/system.conf"
val=${1:-1048576}
m='^#?\s*DefaultLimitNOFILE=.*$'
r="DefaultLimitNOFILE=${val}"
pattern="s/$m/$r/"

for f in $files; do
    printf "processing: $f\n"
    sudo sed -i -E "$pattern" $f
    grep DefaultLimitNOFILE $f
    printf "\n"
done
