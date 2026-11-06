# shellcheck shell=bash
# Output helpers; colours are dropped when the stream is not a terminal.

if [[ -t 1 ]]; then
	readonly C_STEP=$'\033[1;34m' C_OK=$'\033[1;32m' C_WARN=$'\033[1;33m'
	readonly C_ERR=$'\033[1;31m' C_DIM=$'\033[2m' C_OFF=$'\033[0m'
else
	readonly C_STEP='' C_OK='' C_WARN='' C_ERR='' C_DIM='' C_OFF=''
fi

step() { printf '%s==>%s %s\n' "$C_STEP" "$C_OFF" "$*"; }
item() { printf '    %s%s%s\n' "$C_DIM" "$*" "$C_OFF"; }
ok() { printf '  %sok%s %s\n' "$C_OK" "$C_OFF" "$*"; }
warn() { printf '  %s!!%s %s\n' "$C_WARN" "$C_OFF" "$*" >&2; }
err() { printf '%serror%s %s\n' "$C_ERR" "$C_OFF" "$*" >&2; }
die() {
	err "$*"
	exit 1
}
detail() { sed 's/^/      /' >&2; }
short() { printf '%s' "${1/#$HOME/\~}"; }
