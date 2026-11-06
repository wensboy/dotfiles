# shellcheck shell=bash
# Data only: no logic here, so a new distro is a table entry, not a code change.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${HOME}"

# Keys must match /etc/os-release ID or one of its ID_LIKE words.
declare -A PKG_INSTALL=(
	[arch]="sudo pacman -S --needed --noconfirm"
	[debian]="sudo apt-get install -y"
)

# Each command is called as "<cmd> <package>" and must exit non-zero when absent.
declare -A PKG_QUERY=(
	[arch]="pacman -Q"
	[debian]="dpkg -s"
)

# Packages are grouped by role and installed in PKG_GROUPS order: `base` is what
# any session needs, `wm` is the compositor and bar stack. Names are literal, the
# lists are split on whitespace so brace expansion does not apply.
PKG_GROUPS=(base wm)

declare -A PKG_BASE=(
	[arch]="stow git vim tmux  foot  brightnessctl bluez bluez-utils"
	[debian]="stow fcitx5 tmux neovim foot rofi brightnessctl bluez"
)

declare -A PKG_WM=(
	[arch]="hyprland hyprpaper hypridle hyprlock waybar mako rofi fcitx5 fcitx5-rime fcitx5-qt fcitx5-gtk fcitx5-lua grim satty cliphist"
	[debian]="sway waybar mako"
)

# stow packages, keyed by directory under REPO_DIR. Each package holds one mirror
# of the target tree, so the value is the path stow links relative to TARGET_DIR.
# sway is deliberately absent: it never runs alongside hypr, so it stays unsynced.
declare -A ENTRIES=(
	[fcitx5]=.config/fcitx5
	[fcitx5-themes]=.local/share/fcitx5/themes
	[foot]=.config/foot
	[hypr]=.config/hypr
	[mako]=.config/mako
	[rofi]=.config/rofi
	[tmux]=.config/tmux
	[waybar]=.config/waybar
)
