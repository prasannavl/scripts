#!/usr/bin/env bash
set -Eeuo pipefail

# Run any program in its own per-app scope under app.slice
# Examples:
#   app-scope firefox
#   app-scope gtk-launch org.gnome.Nautilus

die() { printf 'app-scope: %s\n' "$*" >&2; exit 1; }

escape() {
  # Escape a string for a systemd unit name component
  systemd-escape -- "$1"
}

unit_free() {
  # Returns 0 if unit name is unused/not loaded, 1 if taken
  systemctl --user status "$1" >/dev/null 2>&1 && return 1 || return 0
}

pick_unit_name() {
  local prog="$1"
  local base="app-$(escape "$prog")"
  local unit="${base}.scope"

  if unit_free "$unit"; then
    printf '%s\n' "$unit"
    return
  fi

  # Find the first free numeric suffix (predictable)
  local i
  for i in $(seq 2 999); do
    unit="${base}-${i}.scope"
    if unit_free "$unit"; then
      printf '%s\n' "$unit"
      return
    fi
  done

  die "could not find a free unit name for $prog"
}

main() {
  [ $# -ge 1 ] || die "need a command to run"

  local app unit
  app="$(basename -- "$1")"
  unit="$(pick_unit_name "$app")"

  exec systemd-run --user --scope --quiet \
    --slice=app.slice \
    --unit="$unit" \
    --property=CollectMode=inactive-or-failed \
    --property=CPUWeight=200 \
    --property=IOWeight=200 \
    -- "$@"
}

main "$@"
