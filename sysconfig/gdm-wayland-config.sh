#!/bin/bash

val=${1:-false}
m='^#?\s*(WaylandEnable=)(.*)$'
r="\\1${val}"
pattern="s/${m}/${r}/"

# fedora and debian use different paths
if [ -f /etc/gdm/custom.conf ]; then
    file=/etc/gdm/custom.conf
elif [ -f /etc/gdm3/custom.conf ]; then
    file=/etc/gdm3/custom.conf
else
    echo "gdm custom.conf not found. exiting"
    exit 1
fi

case "$val" in
"true" | "false") : ;;
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
