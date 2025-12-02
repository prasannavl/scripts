#!/usr/bin/env bash

set -Eeuo pipefail

function main() {
    setup_vars
    run_pre
    run_apt
    run_fwupdmgr
    run_flatpak
    run_nvidia
    run_asus
    [[ "$NIX_RUN" -gt 0 ]] && run_nix
    run_summary
}

function setup_vars() {
    NIX_RUN="${NIX_RUN:-0}"
    NVIDIA_URL="https://www.nvidia.com/en-us/drivers/unix/"
    ASUS_URL="https://www.asus.com/laptops/for-gaming/tuf-gaming/asus-tuf-gaming-a14-2024/helpdesk_bios?model2Name=FA401WV"
}

function run_pre() {
    echo "=== update info ==="
    echo ""
    echo "Kernel: $(uname -rv)"
    echo "nvidia: $(nvidia-settings --version | grep version)"
    echo "bios: "
    echo "$(sudo dmidecode -t bios | grep -E 'Version|Date')"
    echo ""
    echo "=== links ==="
    echo ""
    echo "Kernel: https://kernel.org/"
    echo "Debian: https://tracker.debian.org/pkg/linux"
    echo "nvidia: $NVIDIA_URL"
    echo "asus: $ASUS_URL"
    echo ""
}

function run_summary() {
    run_pre
}

function run_apt() {
    echo "=== apt ==="
    sudo apt update && sudo apt dist-upgrade && sudo apt autopurge && sudo apt autoclean
    echo ""
}

function run_fwupdmgr() {
    echo "=== fwupdmgr ==="
    sudo fwupdmgr update || true
    echo ""
}

function run_flatpak() {
    echo ""
    echo "=== flatpak ==="
    flatpak update
    echo ""
}

function run_nix() {
    echo "=== nix ==="
    if [[ "$NIX_RUN" -gt 1 ]]; then
        nix-collect-garbage -d && sudo nix-collect-garbage -d
        #nix-collect-garbage --delete-older-than 7d && sudo nix-collect-garbage --delete-older-than 7d
    fi
    sudo nix-channel --update && nix-channel --update && nix profile upgrade --all --impure
    echo ""
}

function run_nvidia() {
    echo "=== nvidia ==="
    echo ""
    echo "$(nvidia-settings --version | grep version)"
    echo ""
    curl --silent "$NVIDIA_URL" | htmlq "#rightContent > p:nth-child(1) > a:nth-of-type(-n+3)"
    echo ""
}

function run_asus() {
    echo "=== asus ==="
    echo ""
    echo "$(sudo dmidecode -t bios | grep -E 'Version|Date')"
    echo ""
    curl -silent "$ASUS_URL" | pup ':parent-of(div:contains("BIOS for ASUS EZ Flash Utility")) text{}' | tr -s '[:space:]' ' ' | cut -c1-100
    echo ""
}

main "$@"
