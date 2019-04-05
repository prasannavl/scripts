#!/bin/bash

file=/etc/default/grub

# Scrollback, and systemd status
OPTS="fbcon=scrollback:4096k systemd.status=1"

m='^#?\s*(GRUB_CMDLINE_LINUX=)(.*)$'
r="\\1\"${OPTS}\""
pattern="s/${m}/${r}/"

# Comment out the LINUX_DEFAULT line
# This by default usually has quiet and splash
m2='^\s*(GRUB_CMDLINE_LINUX_DEFAULT=.*)$'
r2="\#\1"
pattern2="s/${m2}/${r2}/"

echo "> original from: $file"
grep -P "${m}" $file

echo "processing: $file"
sudo sed -i -E "${pattern}" $file
sudo sed -i -E "${pattern2}" $file

printf "\n> processed:\n"
grep -P "${m}" $file
