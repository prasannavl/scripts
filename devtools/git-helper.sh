#!/bin/bash

set -Eeuo pipefail

# remove a submodule from the repo given the dir
# deinit, cleanup .git, remove dir
submodule_rm() {
    local target_dir="${1:?target dir required}"
    local leaf="$(basename "$1")"
    # Remove the submodule entry from .git/config
    git submodule deinit -f "target_dir"

    # Remove the submodule directory from the superproject's .git/modules directory
    rm -rf ".git/modules/$leaf"

    # Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
    git rm -f "$target_dir" # git rm with '--cached' instead of '-f' to keep files on disk.
}

# remove a file from all git commits
purge() {
    local target="${1:?purge target required}"
    git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $1" \
        --prune-empty --tag-name-filter cat -- --all
}

postrm_gc() {
    git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
    git reflog expire --expire=now --all
    git gc --prune=now
}

main() {
    local commands=("submodule_rm" "purge" "postrm_gc")
    for x in "${commands[@]}"; do
        if [[ "$x" == "${1-}" ]]; then
            eval "$@"
            return 0
        fi
    done
    usage
}

usage() {
    echo "Usage: $0 <commands>"
    echo ""
    echo "Commands: "
    echo ""
    echo "submodule_rm <target_dir>"
    echo "purge <match-filter>"
    echo "postrm_gc"
    echo ""
    return 1
}

main "$@"
