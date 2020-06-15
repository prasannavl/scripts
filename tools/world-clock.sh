#!/bin/bash

# Display world clock

declare -a TIME_ZONES

# Timezones from: /usr/share/zoneinfo/
TIME_ZONES=(
    US/Pacific
    US/Central
    US/Eastern
    UTC
    Europe/London
    Asia/Kolkata
    Singapore
)

for tz in "${TIME_ZONES[@]}"; do
    echo -e "$tz:\t$(TZ=$tz date "$@")"
done
