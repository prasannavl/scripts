#!/bin/bash

submodule_remove() {
	local target_dir="${1:?}"
	local leaf="$(basename "$1")"
	# Remove the submodule entry from .git/config
	git submodule deinit -f "target_dir"

	# Remove the submodule directory from the superproject's .git/modules directory
	rm -rf ".git/modules/$leaf"

	# Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
	git rm -f "$target_dir" # git rm with '--cached' instead of '-f' to keep files on disk.
}

rm_all() {
	local target="${1:?}"
	git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $1" \
		--prune-empty --tag-name-filter cat -- --all
}

git_postrm_gc() {
	git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
	git reflog expire --expire=now --all
	git gc --prune=now
}

main() {
	case $1 in 
		submodule_remove|rm_all|git_postrm_gc)
			eval $1 "$2 $3 $4 $5 $6 $7 $8 $9"
			;;
		*)
		echo "Usage: "
		echo "submodule_remove <target_dir>"
		echo "rm_all <match-filter>"
		echo "git_postrm_gc"
		exit 1;
	esac
}

main "$@"