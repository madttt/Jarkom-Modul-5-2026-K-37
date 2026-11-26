#!/bin/sh
set -eu

chain=SOAL13_BALTHASAR
if ! iptables -w 5 -S "$chain" >/dev/null 2>&1; then
    iptables -w 5 -N "$chain"
fi

ensure_rule() {
    if ! iptables -w 5 -C "$chain" "$@" 2>/dev/null; then
        iptables -w 5 -A "$chain" "$@"
    fi
}

ensure_rule -i lo -j ACCEPT
# Terima balasan untuk koneksi keluar Balthasar.
ensure_rule -m conntrack --ctstate ESTABLISHED,RELATED --ctdir REPLY -j ACCEPT
ensure_rule -s 10.82.4.58/32 -j ACCEPT

for pilot in 10.82.4.66 10.82.4.67 10.82.4.68; do
    ensure_rule -s "$pilot/32" -p tcp -m multiport --dports 5000,5001 -j ACCEPT
done

ensure_rule -p tcp -j REJECT --reject-with tcp-reset
ensure_rule -j DROP

if ! iptables -w 5 -C INPUT -j "$chain" 2>/dev/null; then
    iptables -w 5 -I INPUT 1 -j "$chain"
fi
iptables -w 5 -P INPUT DROP
