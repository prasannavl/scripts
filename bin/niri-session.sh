#!/usr/bin/bash
set -Eeuo pipefail

log() { printf '%s\n' "$*" | systemd-cat -t niri-session || printf '[niri-session] %s\n' "$*"; }

vars() {
    NIXGL="${NIXGL:-0}"
    NIXGL_BIN="${NIXGL_BIN:-nixGL}"

    NIRI_CMD="${NIRI_CMD:-niri --session}"

    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=niri

    LID_DISPLAY="eDP-1"
    POWER_FILE="/sys/class/power_supply/ADP0/online"
    LOCK_CMD="swaylock -f -c 000000 --indicator-idle-visible"

    # Policy (seconds)
    LOCK_OFFLINE=$((1 * 60)) # AC offline: lock after 1m
    OFF_OFFLINE=$((5 * 60))  # AC offline: screen off after 5m

    LOCK_ONLINE=$((7 * 60)) # AC online:  lock after 7m
    OFF_ONLINE=$((7 * 60))  # AC online:  screen off after 7m

    SCRIPT_PATH="$(readlink -f "$0" 2>/dev/null || printf '%s' "$0")"
}

import_systemd_user_env() {
    log "import in systemd user env"
    while IFS= read -r kv; do [ -n "$kv" ] && export "$kv"; done < <(systemctl --user show-environment)

    export -n DISPLAY WAYLAND_DISPLAY NIRI_SOCKET
    unset DISPLAY WAYLAND_DISPLAY NIRI_SOCKET
}

setup_env_pre() {
    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment --systemd \
            XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
        log "pre env updated"
    fi
}

setup_env_post() {
    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment --systemd \
            WAYLAND_DISPLAY DISPLAY NIRI_SOCKET
        log "post env updated"
    fi
}

start_polkit_agent() {
    local agents=(
        "/usr/bin/lxpolkit"
    )
    for bin in "${agents[@]}"; do
        if [ -x "$bin" ]; then
            "$bin" &
            log "Started polkit agent: $bin"
            return
        fi
    done
    log "polkit agent not found"
}

start_gnome_keyring_agent() {
    local out
    out="$(busctl --user --no-pager \
        call org.freedesktop.DBus /org/freedesktop/DBus \
        org.freedesktop.DBus NameHasOwner s org.freedesktop.secrets 2>/dev/null)"
    if [[ "$out" == "b true" ]]; then
        log "keyring exists; not starting"
        return
    fi

    if command -v gnome-keyring-daemon >/dev/null 2>&1; then
        eval "$(gnome-keyring-daemon --start --components=secrets,pkcs11)" || true
        log "Started gnome-keyring (secrets, pkcs11)"
    else
        log "gnome-keyring-daemon not found; install gnome-keyring"
    fi
}

lid_init_state() {
    local state
    local lid_display=${LID_DISPLAY?lid display not set}

    state=$(awk '{print $2}' /proc/acpi/button/lid/*/state 2>/dev/null | head -n1)
    if [[ "$state" == "closed" ]]; then
        log "output $lid_display: disable"
        # we call get_outputs so that sway builds it output tree
        # otherwise it doesn't seem to set it: schrodinger effect
        niri msg outputs
        niri msg output $lid_display disable
    else
        log "output $lid_display: enable"
        niri msg output $lid_display enable
    fi
}

run() {
    ensure_bash_login_exec "$@"
    setup_env_pre
    systemctl_reset_failed_graphical_units

    # we stop any existing portal so that it can be restarted automatically
    # correctly; this is needed or xdg-portal could linger without wlr, gtk etc
    systemctl stop --user xdg-desktop-portal.service
    start_gnome_keyring_agent

    local niri_cmd="${NIRI_CMD}"
    if [[ "${NIXGL}" == "1" ]]; then
        log "start: using nixGL"
        niri_cmd="${NIXGL_BIN} ${niri_cmd}"
    fi

    if [[ -z "${DBUS_SESSION_BUS_ADDRESS}" ]]; then
        log "start: new dbus session"
        exec /usr/bin/dbus-run-session -- ${niri_cmd}
    else
        log "start: existing dbus"
        exec ${niri_cmd}
    fi
}

niri_init() {
    setup_env_post
    lid_init_state
    start_polkit_agent
    start_swayidle
}

usage() {
    cat <<EOF
Usage: $(basename "$0") [run|niri-init]

  run         Pre-session setup and exec niri (default)
  niri-init   Post start runtime setup (call from niri)
EOF
}

is_ac_online() {
    local v=0
    [[ -r "$POWER_FILE" ]] && read -r v <"$POWER_FILE" || true
    [[ "${v:-0}" == "1" ]]
}

idle_maybe() {
    local want="${1:-}"
    shift || true
    local action="${1:-}"
    shift || true

    local online=1
    is_ac_online || online=0

    case "$want" in
    online) ((online == 1)) || exit 0 ;;
    offline) ((online == 0)) || exit 0 ;;
    *)
        echo "bad condition: $want" >&2
        exit 2
        ;;
    esac

    case "$action" in
    lock) exec $LOCK_CMD ;;
    off) niri msg action power-off-monitors >/dev/null ;;
    *)
        echo "bad action: $action" >&2
        exit 2
        ;;
    esac
}

start_swayidle() {
    kill_swayidle
    swayidle -w \
        timeout "$OFF_ONLINE" "$SCRIPT_PATH idle-maybe online  off" \
        resume 'niri msg action power-on-monitors' \
        timeout "$OFF_OFFLINE" "$SCRIPT_PATH idle-maybe offline off" \
        resume 'niri msg action power-on-monitors' \
        timeout "$LOCK_OFFLINE" "$SCRIPT_PATH idle-maybe offline lock" \
        timeout "$LOCK_ONLINE" "$SCRIPT_PATH idle-maybe online  lock" \
        before-sleep "$LOCK_CMD" \
        >/dev/null 2>&1 &
}

kill_swayidle() { pkill -x swayidle 2>/dev/null || true; }

lock_now() { { $LOCK_CMD; } || true; }

lid_closed() {
    if ! is_ac_online; then
        return
    fi
    niri msg output ${LID_DISPLAY} disable >/dev/null
}

lid_opened() {
    niri msg output ${LID_DISPLAY} enable >/dev/null
}

### --- end: swayidle stuff

systemctl_reset_failed_graphical_units() {
    # From: https://people.debian.org/~mpitt/systemd.conf-2016-graphical-session.pdf
    if command -v systemctl >/dev/null; then
        # robustness: if the previous graphical session left some failed units,
        # reset them so that they don't break this startup
        for unit in $(systemctl --user --no-legend --state=failed --plain list-units | cut -f1 -d' '); do
            partof="$(systemctl --user show -p PartOf --value "$unit")"
            for target in graphical-session.target; do
                if [ "$partof" = "$target" ]; then
                    systemctl --user reset-failed "$unit"
                    break
                fi
            done
        done
    fi
}

ensure_bash_login_exec() {
    local arg=${2:-}
    # use the user's preferred shell to acquire environment variables
    # see: https://github.com/pop-os/cosmic-session/issues/23
    if [ -n "${SHELL}" ]; then
        # --in-login-shell: our flag to indicate that we don't need to recurse any further
        if [ "${arg}" != "--in-login-shell" ]; then
            # `exec -l`: like `login`, prefixes $SHELL with a hyphen to start a login shell
            import_systemd_user_env
            exec bash -c "exec -l '${SHELL}' -c '${0} run --in-login-shell'"
        fi
    fi
}

main() {
    vars
    log "call: $*"
    case "${1:-run}" in
    run)
        run "$@"
        exit 0
        ;;
    niri-init)
        sway_init
        exit 0
        ;;
    lock)
        lock_now
        exit 0
        ;;
    lid-opened)
        lid_opened
        exit 0
        ;;
    lid-closed)
        lid_closed
        exit 0
        ;;
    idle-maybe)
        shift
        idle_maybe "$@"
        exit 0
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        usage
        exit 2
        ;;
    esac
}

main "$@"
