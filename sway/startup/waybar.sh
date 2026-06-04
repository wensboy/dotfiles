#!/usr/bin/env bash

# if waybar is running and kill it
PID_WAYBAR=$(pidof waybar)
if [[ -n $PID_WAYBAR ]]; then
    kill -9 $PID_WAYBAR
fi

# start waybar
waybar
