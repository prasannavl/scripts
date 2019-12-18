#!/bin/bash

set -Eeuo pipefail

post_install() {
    test -f /etc/os-release
    source /etc/os-release
    [[ "$ID" == "ubuntu" ]] && post_install_ubuntu
}

post_install_ubuntu() {
    if $(apt show docker-ce &> /dev/null); then return; fi
    # docker-ce package is not found. Let's warn user
    echo "WARNING> docker-ce package not yet available for $NAME $VERSION ($VERSION_CODENAME)";
    echo "WARNING> Consider changing the ubuntu version of /etc/apt/sources.list.d/docker.list"
    echo "WARNING> to a lower release."
    exit 1
}

check_exists() {
    if ! $(command -v docker &> /dev/null); then return; fi 
    echo "WARNING> docker already installed"
    exit 1
}

main() {
    check_exists
    curl -fsSL https://get.docker.com/ | sh
    post_install
}

main "$@"