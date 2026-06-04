#!/usr/bin/env bash

WAYBAR_ON_SIGN=true

no_sign() {
    PID_WAYBAR=$(pidof waybar)
    if [[ -n $PID_WAYBAR ]]; then
        kill -9 $PID_WAYBAR
    fi

    waybar
}

sign() {
    kill -SIGUSR2 waybar
}

${WAYBAR_ON_SIGN} && sign || no_sign
