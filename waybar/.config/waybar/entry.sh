#!/usr/bin/env bash

set -uo pipefail

WAYBAR_BIN="${WAYBAR_BIN:-waybar}"
NAME="${WAYBAR_BIN##*/}"

usage() {
    cat <<EOF
usage: ${0##*/} <command>

  start    start waybar when it is not running
  stop     terminate waybar, escalating to SIGKILL when it does not exit
  restart  stop then start
  reload   reload the config in place, starts waybar when it is not running
  toggle   hide or show the bar
  status   report whether waybar is running
EOF
}

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

is_running() {
    pgrep -x "$NAME" >/dev/null 2>&1
}

running_pids() {
    pgrep -x "$NAME" | paste -sd ' ' -
}

wait_pids() {
    local want="$1"
    local _
    for _ in {1..50}; do
        if [[ "$want" == up ]]; then
            is_running && return 0
        else
            is_running || return 0
        fi
        sleep 0.1
    done
    return 1
}

do_start() {
    if is_running; then
        printf 'waybar: already running (pid: %s)\n' "$(running_pids)"
        return 0
    fi

    command -v "$WAYBAR_BIN" >/dev/null 2>&1 || die "'$WAYBAR_BIN' is not in PATH"

    setsid --fork "$WAYBAR_BIN" >/dev/null 2>&1
    wait_pids up || die "waybar did not come up, run '$WAYBAR_BIN' manually to see why"

    printf 'waybar: started (pid: %s)\n' "$(running_pids)"
}

do_stop() {
    if ! is_running; then
        printf 'waybar: not running\n'
        return 0
    fi

    pkill -TERM -x "$NAME"
    if wait_pids down; then
        printf 'waybar: stopped\n'
        return 0
    fi

    printf 'waybar: ignored SIGTERM, sending SIGKILL\n' >&2
    pkill -KILL -x "$NAME"
    wait_pids down || die "waybar could not be stopped"

    printf 'waybar: killed\n'
}

do_restart() {
    do_stop
    do_start
}

do_reload() {
    if ! is_running; then
        printf 'waybar: not running, starting it first\n'
        do_start
        return 0
    fi

    pkill -USR2 -x "$NAME"
    printf 'waybar: config reloaded\n'
}

do_toggle() {
    if ! is_running; then
        do_start
        return 0
    fi

    pkill -USR1 -x "$NAME"
    printf 'waybar: visibility toggled\n'
}

do_status() {
    if is_running; then
        printf 'waybar: running (pid: %s)\n' "$(running_pids)"
        return 0
    fi

    printf 'waybar: not running\n'
    return 1
}

main() {
    case "${1:-}" in
        start)    do_start ;;
        stop)     do_stop ;;
        restart)  do_restart ;;
        reload)   do_reload ;;
        toggle)   do_toggle ;;
        status)   do_status ;;
        -h|--help|help) usage ;;
        '')
            usage >&2
            exit 1
            ;;
        *)
            printf 'error: unknown command: %s\n\n' "$1" >&2
            usage >&2
            exit 1
            ;;
    esac
}

main "$@"
