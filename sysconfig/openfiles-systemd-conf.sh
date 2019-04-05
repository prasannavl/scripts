#!/bin/bash

conf_dirs="/etc/systemd/system.conf.d /etc/systemd/user.conf.d"
filename="40-open-files.conf"
val=${1:-1048576}

for d in $conf_dirs; do
    sudo mkdir -p "$d"
    cat <<END | sudo tee "${d}/${filename}"
[Manager]
DefaultLimitNOFILE=${val}
END
done
