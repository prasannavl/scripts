#!/bin/bash

set -Eeuo pipefail

FLAGS=" --force-device-scale-factor=1.25 --password-store=gnome"
m='^(Exec=.*)$'
r="\\1${FLAGS}"
PATTERN="s/${m}/${r}/g"
SHOULD_UPDATE=0

update_file() {
	local f="${1:?file required}"
	local result="$(grep -P "${FLAGS}" "$f" || echo "")"
	if [[ -z "$result" ]]; then
		echo "> current config: ${f}:"
		echo "$result"
		sudo sed -i -E "${PATTERN}" "$f"
		SHOULD_UPDATE=1
		echo "> updated:" 
		echo "$(grep -P "${FLAGS}" "$f")"
	fi;
}

run() {
	echo "> check chrome config";
	# chrome main application
	for f in /usr/share/applications/google-chrome*.desktop; do
		[[ -f "$f" ]] && update_file $f
	done

	if [ $SHOULD_UPDATE -eq 0 ]; then return 0; fi;

	# chrome apps
	for f in $HOME/.local/share/applications/chrome-*.desktop; do 
		[[ -f "$f" ]] && update_file $f
	done
	echo "> chrome config updated";
}

run "$@"


