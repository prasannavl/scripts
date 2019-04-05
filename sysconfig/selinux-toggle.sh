#!/bin/bash

file=/etc/selinux/config
val=${1:-permissive}
m='^(SELINUX)=(.*)$'
r="\\1=${val}"
pattern="s/${m}/${r}/"

if [ ! -f "$file" ]; then
    echo "config not found: ${file}"
    exit 1
fi

case "$val" in
"permissive" | "enforcing" | "disabled") : ;;
*)
    printf "Invalid option given: '${val}'; Continue? (y/[n]): "
    read cont
    if [ ! "x$cont" = "xy" ]; then
        echo "> exiting."
        exit 1
    fi
    ;;
esac

echo "> original from: $file"
grep -P "${m}" $file

echo "processing: $file"
sudo sed -i -E "${pattern}" $file

printf "\n> processed:\n"
grep -P "${m}" $file

sudo setenforce $val
