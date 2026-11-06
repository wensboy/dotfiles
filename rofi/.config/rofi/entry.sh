#!/usr/bin/env bash

## Author : wensboy
## Github : @wensboy
## Fork: https://github.com/adi1090x/rofi
## Rofi Entry

set -uo pipefail

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

theme_dir="$HOME/.config/rofi/themes"
extra_dir="$HOME/.config/rofi/extra"
launcher_theme='launcher'
window_theme='window'
dmenu_theme='dmenu'
bluetooth_theme='bluetooth'
network_theme='network'
wallpaper_theme='wallpaper'
default_theme='default'

require_var() {
    local name="$1"
    if [[ -z "${!name:-}" ]]; then
        die "variable '$name' is not set or empty"
    fi
}

show() {
    if [[ $# -ne 2 ]]; then
        printf 'error: invalid number of arguments: %d, expected 2.\n' "$#" >&2
        return 1
    fi

    local mode="$1"
    local theme="$2"

    local theme_file="${theme_dir}/${theme}.rasi"
    if [[ ! -f "$theme_file" ]]; then
        printf 'error: theme file not found: %s\n' "$theme_file" >&2
        return 1
    fi

    command -v rofi >/dev/null 2>&1 || {
        printf 'error: rofi is not installed or not in PATH.\n' >&2
        return 1
    }

    rofi -show "$mode" -theme "$theme_file"
}

# shared checks for the helpers below, prints the resolved theme file path
preflight() {
    local theme="$1"

    local theme_file="${theme_dir}/${theme}.rasi"
    if [[ ! -f "$theme_file" ]]; then
        printf 'error: theme file not found: %s\n' "$theme_file" >&2
        return 1
    fi

    command -v rofi >/dev/null 2>&1 || {
        printf 'error: rofi is not installed or not in PATH.\n' >&2
        return 1
    }

    printf '%s\n' "$theme_file"
}

# menu, entries come from stdin and the selection goes to stdout.
show_menu() {
    if [[ $# -lt 1 ]]; then
        printf 'error: invalid number of arguments: %d, expected at least 1.\n' "$#" >&2
        return 1
    fi

    local theme="$1"
    shift

    local theme_file
    theme_file="$(preflight "$theme")" || return 1

    rofi -dmenu -theme "$theme_file" "$@"
}

# session menu, entries are built in and the selected action is executed
show_session_menu() {
    if [[ $# -lt 1 ]]; then
        printf 'error: invalid number of arguments: %d, expected at least 1.\n' "$#" >&2
        return 1
    fi

    local theme="$1"
    shift

    local theme_file
    theme_file="$(preflight "$theme")" || return 1

    # nerd font icons for the menu entries
    local ico_lock=$'\uf023'
    local ico_logout=$'\uf08b'
    local ico_suspend=$'\uf186'
    local ico_reboot=$'\uf021'
    local ico_shutdown=$'\uf011'

    local -a options=(
        "$ico_lock Lock"
        "$ico_logout Logout"
        "$ico_suspend Suspend"
        "$ico_reboot Reboot"
        "$ico_shutdown Shutdown"
    )

    # rofi reads the options from stdin and prints the selected one to stdout
    local choice
    choice="$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "$ico_lock Menu" -theme "$theme_file" "$@")"

    case "${choice##* }" in
        Lock)     hyprlock ;;
        Logout)   hyprctl dispatch exit ;;
        Suspend)  systemctl suspend ;;
        Reboot)   systemctl reboot ;;
        Shutdown) systemctl poweroff ;;
        *)        return 0 ;;
    esac
}

# run a script from the extra dir, the theme is forwarded to it as -theme
show_extra() {
    if [[ $# -ne 2 ]]; then
        printf 'error: invalid number of arguments: %d, expected 2.\n' "$#" >&2
        return 1
    fi

    local script="$1"
    local theme="$2"

    local script_file="${extra_dir}/${script}.sh"
    if [[ ! -f "$script_file" ]]; then
        printf 'error: script not found: %s\n' "$script_file" >&2
        return 1
    fi
    if [[ ! -x "$script_file" ]]; then
        printf 'error: script is not executable: %s\n' "$script_file" >&2
        return 1
    fi

    local theme_file
    theme_file="$(preflight "$theme")" || return 1

    # the script forwards its arguments to rofi, see extra/bluetooth.sh
    "$script_file" -theme "$theme_file"
}

main() {
    if [[ $# -lt 1 ]]; then
        die "invalid number of arguments: $#, expected at least 1."
    fi

    require_var theme_dir

    # only `dmenu` takes extra arguments, they are forwarded to rofi
    if [[ "$1" != dmenu && $# -ne 1 ]]; then
        die "invalid number of arguments: $#, expected 1."
    fi

    case "$1" in
        launcher)
            require_var launcher_theme
            show "drun" "$launcher_theme"
            ;;
        window)
            require_var window_theme
            show "window" "$window_theme"
            ;;
        default)
            require_var default_theme
            show "drun" "$default_theme"
            ;;
        bluetooth)
            require_var extra_dir
            require_var bluetooth_theme
            show_extra "bluetooth" "$bluetooth_theme"
            ;;
        network)
            require_var extra_dir
            require_var network_theme
            show_extra "network/wifi" "$network_theme"
            ;;
        wallpaper)
            require_var extra_dir
            require_var wallpaper_theme
            show_extra "wallpaper" "$wallpaper_theme"
            ;;
        dmenu)
            require_var dmenu_theme
            shift
            # entries piped in -> plain dmenu, otherwise the built-in session menu
            if [[ -p /dev/stdin || -f /dev/stdin ]]; then
                show_menu "$dmenu_theme" "$@"
            else
                show_session_menu "$dmenu_theme" "$@"
            fi
            ;;
        *)
            die "unknown argument: '$1'. expected one of: launcher, window, dmenu, bluetooth, network, wallpaper, default."
            ;;
    esac
}

main "$@"