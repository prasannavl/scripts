#!/bin/bash

# Show battery info

upower -i /org/freedesktop/UPower/devices/battery_BAT0

# alternate options
  
# https://askubuntu.com/questions/69556/how-do-i-check-the-batterys-status-via-the-terminal/102863
# 
# grep POWER_SUPPLY_CAPACITY /sys/class/power_supply/BAT1/uevent
# acpi -V 
