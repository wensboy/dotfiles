# shellcheck shell=bash
# Pipeline stages; every distro or layout specific value comes from config.sh.

DISTRO=''

# stow needs a stable order for readable output, associative arrays have none.
entry_keys() { printf '%s\n' "${!ENTRIES[@]}" | sort; }

# package list of <group> for <distro>, resolved by name so a new group only
# needs a table plus an entry in PKG_GROUPS
group_packages() {
	local -n table="PKG_${1^^}"
	printf '%s' "${table[$2]:-}"
}

resolve_distro() {
	local id='' like='' candidate group

	[[ -r /etc/os-release ]] || die '/etc/os-release is not readable'
	# shellcheck disable=SC1091
	id="$(. /etc/os-release && printf '%s' "${ID:-}")"
	# shellcheck disable=SC1091
	like="$(. /etc/os-release && printf '%s' "${ID_LIKE:-}")"

	# a derivative such as cachyos only matches through ID_LIKE, so try both
	for candidate in "$id" $like; do
		[[ -n $candidate ]] || continue
		for group in "${PKG_GROUPS[@]}"; do
			[[ -n "$(group_packages "$group" "$candidate")" ]] || continue
			DISTRO="$candidate"
			return 0
		done
	done

	die "unsupported distro '${id:-unknown}', add it to scripts/config.sh"
}

stage_distro() {
	step 'detect distro'
	resolve_distro
	item "id     $DISTRO"
	item "source $(short "$REPO_DIR")"
	item "target $(short "$TARGET_DIR")"
}

stage_packages() {
	local -a cmd list all=() missing=()
	local group pkg

	read -r -a cmd <<< "${PKG_INSTALL[$DISTRO]}"
	command -v "${cmd[0]}" >/dev/null 2>&1 || die "package manager not found: ${cmd[0]}"

	step 'install packages'
	item "cmd    ${cmd[*]}"

	for group in "${PKG_GROUPS[@]}"; do
		read -r -a list <<< "$(group_packages "$group" "$DISTRO")"
		((${#list[@]})) || continue
		item "$(printf '%-5s' "$group") ${#list[@]}"
		"${cmd[@]}" "${list[@]}" || die "installation failed: $group"
		all+=("${list[@]}")
	done

	read -r -a cmd <<< "${PKG_QUERY[$DISTRO]}"
	for pkg in "${all[@]}"; do
		"${cmd[@]}" "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
	done

	if ((${#missing[@]})); then
		warn "not installed: ${missing[*]}"
		die 'package verification failed'
	fi

	ok "${#all[@]} packages verified"
}

stage_precheck() {
	local -a conflicts=()
	local pkg path dst

	step 'precheck targets'
	command -v stow >/dev/null 2>&1 || die 'stow is not installed'

	while IFS= read -r pkg; do
		for path in ${ENTRIES[$pkg]}; do
			[[ -e $REPO_DIR/$pkg/$path ]] || die "missing package file: $(short "$REPO_DIR/$pkg/$path")"
		done
		# a fully linked package is the end state a re-run should reach
		link_ok "$pkg" && continue
		for path in ${ENTRIES[$pkg]}; do
			dst="$TARGET_DIR/$path"
			[[ -e $dst || -L $dst ]] && conflicts+=("$dst")
		done
	done < <(entry_keys)

	if ((${#conflicts[@]})); then
		err 'target already exists, remove it before syncing:'
		printf '%s\n' "${conflicts[@]}" | sed "s|^$HOME|~|" | detail
		die 'aborted, nothing was changed'
	fi

	ok "${#ENTRIES[@]} targets free"
}

stage_sync() {
	local i=1 pkg output
	local total=${#ENTRIES[@]}

	step "sync entries ($total)"
	mkdir -p -- "$TARGET_DIR"

	while IFS= read -r pkg; do
		printf '  [%d/%d] %-14s ' "$i" "$total" "$pkg"
		if link_ok "$pkg"; then
			printf '%sunchanged%s\n' "$C_DIM" "$C_OFF"
		elif output=$(sync_entry "$pkg"); then
			printf '%slinked%s\n' "$C_OK" "$C_OFF"
		else
			printf '%sskipped%s\n' "$C_ERR" "$C_OFF"
			printf '%s\n' "$output" | detail
		fi
		i=$((i + 1))
	done < <(entry_keys)
}

sync_entry() {
	local pkg="$1" output path

	# create the parent first, otherwise stow folds at the highest missing
	# directory and would turn something like ~/.local into a link into the repo
	for path in ${ENTRIES[$pkg]}; do
		mkdir -p -- "$(dirname -- "$TARGET_DIR/$path")"
	done

	if output=$(stow --dir "$REPO_DIR" --target "$TARGET_DIR" --verbose=0 "$pkg" 2>&1); then
		return 0
	fi

	# a failed stow may leave half of the links behind, which would also confuse
	# the verification below, so undo whatever it managed to create
	stow --delete --dir "$REPO_DIR" --target "$TARGET_DIR" --verbose=0 "$pkg" >/dev/null 2>&1
	printf '%s\n' "$output"
	return 1
}

stage_verify() {
	local -a linked=() missing=()
	local pkg

	step 'verify'
	while IFS= read -r pkg; do
		if link_ok "$pkg"; then
			linked+=("$pkg")
		else
			missing+=("$pkg")
		fi
	done < <(entry_keys)

	ok "${#linked[@]}/${#ENTRIES[@]} entries linked"
	item "${linked[*]:-none}"

	if ((${#missing[@]})); then
		printf '\n'
		err "not synced: ${missing[*]}"
		err 'resolve the conflicts above and re-run, nothing else was touched'
		exit 1
	fi
}

link_ok() {
	local pkg="$1" path

	for path in ${ENTRIES[$pkg]}; do
		[[ -L $TARGET_DIR/$path ]] || return 1
		[[ "$(readlink -f -- "$TARGET_DIR/$path")" == "$(readlink -f -- "$REPO_DIR/$pkg/$path")" ]] || return 1
	done
}
