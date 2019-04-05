#!/bin/bash

file=/etc/default/grub
OPTS="rhgb quiet acpi_osi=Linux fbcon=scrollback:4096k"
m='^#?\s*(GRUB_CMDLINE_LINUX=)(.*)$'
r="\\1\"${OPTS}\""
pattern="s/${m}/${r}/"

echo "> original from: $file"
grep -P "${m}" $file

echo "processing: $file"
sudo sed -i -E "${pattern}" $file

printf "\n> processed:\n"
grep -P "${m}" $file
