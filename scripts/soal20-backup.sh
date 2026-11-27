#!/bin/sh
set -eu

snapshot() {
    target=$1
    if [ -e "$target" ]; then
        printf 'Cadangan sudah ada di %s.\n' "$target" >&2
        exit 1
    fi

    umask 077
    pending=$(mktemp -d "${target}.XXXXXX")
    trap 'rm -rf "$pending"' EXIT
    iptables-save > "$pending/iptables.rules"
    ip -4 route show table main > "$pending/routes.txt"
    ip -o -4 addr show scope global | awk '{sub(/@.*/, "", $2); print $2, $4}' > "$pending/interfaces.txt"
    sysctl -n net.ipv4.ip_forward > "$pending/ip_forward.txt"
    (cd "$pending" && sha256sum iptables.rules routes.txt interfaces.txt ip_forward.txt > SHA256SUMS)
    mv -T -- "$pending" "$target"
    printf 'Cadangan tersimpan di %s.\n' "$target"
}

restore_routes() {
    # Rute terhubung harus tersedia sebelum static route yang memakai next-hop.
    set -f
    while IFS= read -r route; do
        case " $route " in
            *' scope link '*) ip -4 route replace $route ;;
        esac
    done < "$source/routes.txt"
    while IFS= read -r route; do
        case " $route " in
            *' scope link '*) ;;
            *) ip -4 route replace $route ;;
        esac
    done < "$source/routes.txt"
    set +f
}

rules_without_counters() {
    sed -E -e '/^#/d' -e 's/^(:.*) \[[0-9]+:[0-9]+\]$/\1/'
}

verify_restore() {
    source=$1
    parent_namespace=$2
    if [ "$(readlink /proc/self/ns/net)" = "$parent_namespace" ] ||
        [ "$(ip -o link show | wc -l)" -ne 1 ]; then
        printf '%s\n' 'Uji pulih memerlukan namespace jaringan baru.' >&2
        exit 1
    fi

    (cd "$source" && sha256sum -c SHA256SUMS)
    ip link set lo up
    while read -r interface address; do
        if ! ip link show dev "$interface" >/dev/null 2>&1; then
            ip link add "$interface" type dummy
            ip link set dev "$interface" up
        fi
        ip addr add "$address" dev "$interface"
    done < "$source/interfaces.txt"
    sysctl -qw "net.ipv4.ip_forward=$(cat "$source/ip_forward.txt")"

    iptables-restore -w 5 < "$source/iptables.rules"
    restore_routes
    printf 'Sebelum reset uji: %s aturan, %s rute.\n' \
        "$(iptables-save | grep -c '^-A ' || true)" "$(ip -4 route show table main | wc -l)"

    sed -n 's/^\*//p' "$source/iptables.rules" | while IFS= read -r table; do
        iptables -w 5 -t "$table" -F
    done
    ip -4 route flush table main
    test "$(iptables-save | grep -c '^-A ' || true)" -eq 0
    test -z "$(ip -4 route show table main)"
    printf '%s\n' 'Sesudah reset uji: 0 aturan, 0 rute.'

    iptables-restore -w 5 < "$source/iptables.rules"
    restore_routes
    scratch=$(mktemp -d)
    trap 'rm -rf "$scratch"' EXIT
    iptables-save | rules_without_counters > "$scratch/iptables-restored"
    rules_without_counters < "$source/iptables.rules" > "$scratch/iptables-original"
    ip -4 route show table main | sort > "$scratch/routes-restored"
    sort "$source/routes.txt" > "$scratch/routes-original"
    cmp "$scratch/iptables-original" "$scratch/iptables-restored"
    cmp "$scratch/routes-original" "$scratch/routes-restored"
    printf '%s\n' 'Pulih: aturan iptables dan tabel rute cocok dengan cadangan.'
    printf 'Jumlah hasil pulih: %s aturan, %s rute.\n' \
        "$(grep -c '^-A ' "$scratch/iptables-restored" || true)" "$(wc -l < "$scratch/routes-restored")"
}

case ${1:-} in
    backup) snapshot "${2:?Direktori cadangan diperlukan}" ;;
    verify) unshare -n "$0" isolated "${2:?Direktori cadangan diperlukan}" "$(readlink /proc/self/ns/net)" ;;
    isolated) verify_restore "${2:?Direktori cadangan diperlukan}" "${3:?Identitas namespace awal diperlukan}" ;;
    *) printf 'Pemakaian: %s backup|verify DIREKTORI\n' "$0" >&2; exit 1 ;;
esac
