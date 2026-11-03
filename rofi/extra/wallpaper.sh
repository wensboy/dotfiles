#!/usr/bin/env bash

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/.config/hypr/wallpapers}"
HYPRPAPER_CONF="${HYPRPAPER_CONF:-$HOME/.config/hypr/hyprpaper.conf}"

# extra arguments (e.g. -theme) are forwarded to rofi, see rofi/entry.sh
rofi_command="rofi -dmenu $*"

die() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

[ -d "$WALLPAPER_DIR" ] || die "wallpaper directory not found: $WALLPAPER_DIR"
[ -f "$HYPRPAPER_CONF" ] || die "hyprpaper config not found: $HYPRPAPER_CONF"

mapfile -t images < <(
	find "$WALLPAPER_DIR" -type f \
		\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) |
		sort
)
[ ${#images[@]} -eq 0 ] && die "no image found in $WALLPAPER_DIR"

chosen=$(printf '%s\n' "${images[@]#"$WALLPAPER_DIR/"}" | $rofi_command -p 'Wallpaper:')
[ -z "$chosen" ] && exit 0

wallpaper="$WALLPAPER_DIR/$chosen"
[ -f "$wallpaper" ] || exit 0

# the config keeps a path relative to $HOME so it is not bound to one user
if [[ $wallpaper == "$HOME"/* ]]; then
	config_path="~${wallpaper#"$HOME"}"
else
	config_path="$wallpaper"
fi

# only the first `path =` is the main wallpaper, the fallback block keeps its own
escaped=$(printf '%s' "$config_path" | sed 's/[\\&|]/\\&/g')
sed -i -E "0,/^([[:space:]]*path[[:space:]]*=[[:space:]]*).*/s||\1$escaped|" "$HYPRPAPER_CONF"

# monitor of the main block, empty means every output
monitor=$(awk '
	/^[[:space:]]*wallpaper[[:space:]]*\{/ { block = 1; next }
	block && /^[[:space:]]*monitor[[:space:]]*=/ {
		sub(/^[[:space:]]*monitor[[:space:]]*=[[:space:]]*/, "")
		sub(/[[:space:]]+$/, "")
		print
		exit
	}
' "$HYPRPAPER_CONF")

# the config is written above, so either branch below ends up consistent
if ! pgrep -x hyprpaper >/dev/null 2>&1; then
	hyprpaper -c "$HYPRPAPER_CONF" >/dev/null 2>&1 &
	exit 0
fi

# a repaint reuses the running instance, a restart would flash the previous
# wallpaper back until the old instance is gone
if hyprctl hyprpaper wallpaper "${monitor},${wallpaper}" >/dev/null 2>&1; then
	exit 0
fi

# the request was refused, restart from the config that is already on disk
pkill -x hyprpaper
for _ in {1..50}; do
	pgrep -x hyprpaper >/dev/null 2>&1 || break
	sleep 0.1
done
hyprpaper -c "$HYPRPAPER_CONF" >/dev/null 2>&1 &
