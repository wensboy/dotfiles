#!/usr/bin/env bash

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    notify-send -a "Bluetooth" "bluetooth power off." 2>/dev/null
else
    bluetoothctl power on
    notify-send -a "Bluetooth" "bluetooth power on." 2>/dev/null
fi