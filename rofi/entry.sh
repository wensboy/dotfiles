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
launcher_theme='launcher'
window_theme='window'
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

main() {
    if [[ $# -ne 1 ]]; then
        die "invalid number of arguments: $#, expected 1."
    fi

    require_var theme_dir

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
        *)
            die "unknown argument: '$1'. expected one of: launcher, window, default."
            ;;
    esac
}

main "$@"