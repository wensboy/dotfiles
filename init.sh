#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/log.sh
source "${SCRIPT_DIR}/scripts/log.sh"
# shellcheck source=scripts/config.sh
source "${SCRIPT_DIR}/scripts/config.sh"
# shellcheck source=scripts/lib.sh
source "${SCRIPT_DIR}/scripts/lib.sh"

main() {
	stage_distro
	stage_packages
	stage_precheck
	stage_sync
	stage_verify
	printf '\n'
	step 'done'
}

main "$@"
