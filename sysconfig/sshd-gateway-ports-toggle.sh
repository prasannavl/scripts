#!/bin/bash

file=/etc/ssh/sshd_config
val=${1:-clientspecified}
m='^#?\s*(GatewayPorts) (.*)\s*$'
r="\\1 $val\n"
pattern="s/${m}/${r}/"

if [ ! -f "$file" ]; then
    echo "config not found: ${file}"
    exit 1
fi

case "$val" in
"yes" | "no" | "clientspecified") : ;;
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
sudo grep -P "${m}" $file

echo "processing: $file"
sudo sed -i -E "${pattern}" $file

printf "\n> processed:\n"
sudo grep -P "${m}" $file
