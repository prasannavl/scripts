#!/bin/bash

# Display world clock

set -Eeuo pipefail

setup_vars() {
    # Timezones from: /usr/share/zoneinfo/ (tzselect)
    TIME_ZONES=(
        US/Pacific
        US/Central
        US/Eastern
        UTC
        Europe/London
        Europe/Zurich
        Asia/Kolkata
        Asia/Singapore
        Asia/Tokyo
        Australia/Sydney
    )
}

main() {
    setup_vars

    if [[ "$#" -gt 0 ]]; then
        for tz in "${TIME_ZONES[@]}"; do
            printf "%s\n%-22s %s\n" "------" "$tz" "$(date --date="TZ=\"$tz\" ${*:-now}")"
        done
    else
        for tz in "${TIME_ZONES[@]}"; do
            printf "%s\n%-22s %s\n" "------" "$tz" "$(TZ=$tz date)"
        done
    fi
}

main "$@"

