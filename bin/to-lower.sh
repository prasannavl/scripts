#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<EOF
Usage: ${0##*/} [options] [paths...]

Rename items to a normalized form.

Default behavior (no paths given):
  - Operates in the current directory.
  - Processes only non-hidden regular files.
  - Converts names to lowercase.

If one or more paths are given:
  - Only those paths are considered (no directory scan).
  - Directory portion is preserved; only the basename is changed.

Options:
  -d, --dirs      Also rename directories (in current dir or among given paths)
  -h, --hidden    When scanning current dir, also include hidden entries
  -x, --xdash     Also replace underscores (_) with dashes (-) in names
  --help          Show this help

Examples:
  ${0##*/}                # lowercase non-hidden files in .
  ${0##*/} -d -h          # lowercase files + dirs, including hidden, in .
  ${0##*/} -x foo_bar Baz # foo_bar -> foo-bar, Baz -> baz
EOF
}

parse_args() {
  include_dirs=false
  include_hidden=false
  transform_xdash=false
  positional_targets=()

  while (($#)); do
    case "$1" in
      -d|--dirs)
        include_dirs=true
        ;;
      -h|--hidden)
        include_hidden=true
        ;;
      -x|--xdash)
        transform_xdash=true
        ;;
      --help|-H|-\?)
        usage
        exit 0
        ;;
      --)
        shift
        while (($#)); do
          positional_targets+=("$1")
          shift
        done
        break
        ;;
      -*)
        printf 'Unknown option: %s\n' "$1" >&2
        exit 1
        ;;
      *)
        positional_targets+=("$1")
        ;;
    esac
    shift || true
  done
}

rename_entry() {
  local path=$1
  local dir base newbase target

  dir=${path%/*}
  base=${path##*/}

  if [[ "$dir" == "$path" ]]; then
    dir=""
  else
    dir="${dir}/"
  fi

  newbase=$(printf '%s\n' "$base" | tr 'A-Z' 'a-z')

  if [[ "$transform_xdash" == true ]]; then
    newbase=${newbase//_/-}
  fi

  target="${dir}${newbase}"

  if [[ "$path" == "$target" ]]; then
    return 0
  fi

  if [[ -e "$target" ]]; then
    printf "Skipping '%s' -> '%s' (target already exists)\n" "$path" "$target"
    return 0
  fi

  printf "Renaming '%s' -> '%s'\n" "$path" "$target"
  mv -- "$path" "$target"
}

process_entries() {
  shopt -s nullglob

  local -a items=()

  if ((${#positional_targets[@]} > 0)); then
    items=("${positional_targets[@]}")
  else
    if [[ "$include_hidden" == true ]]; then
      items=(.* *)
    else
      items=(*)
    fi
  fi

  local f
  for f in "${items[@]}"; do
    # Skip pseudo-entries when scanning current dir
    if [[ "$f" == "." || "$f" == ".." ]]; then
      continue
    fi

    if [[ ! -e "$f" ]]; then
      printf "Skipping '%s' (does not exist)\n" "$f"
      continue
    fi

    if [[ -f "$f" ]]; then
      : # always OK: regular file
    elif [[ "$include_dirs" == true && -d "$f" ]]; then
      : # directory if enabled
    else
      continue
    fi

    rename_entry "$f"
  done
}

main() {
  parse_args "$@"
  process_entries
}

main "$@"
