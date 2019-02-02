#!/bin/bash

FLAGS=" --force-device-scale-factor=1.25 --password-store=gnome"

m='^(Exec=.*)$'
r="\\1${FLAGS}"
pattern="s/${m}/${r}/g"

SHOULD_UPDATE=0

echo "> check chrome config";

update_file() {
	local f="$1"
	result="$(grep -P "${FLAGS}" "$f")"
	if [ -z "$result" ]; then
		echo "> current config: ${f}:"
		echo "$result"
		sudo sed -i -E "${pattern}" "$f"
		SHOULD_UPDATE=1
		echo "> updated:" 
		echo "$(grep -P "${FLAGS}" "$f")"
	fi;
}

# chrome main application
for f in /usr/share/applications/google-chrome*.desktop; do
	update_file $f
done

if [ $SHOULD_UPDATE -eq 0 ]; then exit 0; fi;

# chrome apps
for f in $HOME/.local/share/applications/chrome-*.desktop; do 
	update_file $f
done

echo "> chrome config updated";
