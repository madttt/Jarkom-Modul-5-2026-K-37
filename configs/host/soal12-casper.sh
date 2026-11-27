#!/bin/sh
set -eu

chain=SOAL12_CASPER
if ! iptables -w 5 -S "$chain" >/dev/null 2>&1; then
    iptables -w 5 -N "$chain"
fi

ensure_rule() {
    if ! iptables -w 5 -C "$chain" "$@" 2>/dev/null; then
        iptables -w 5 -A "$chain" "$@"
    fi
}

# Tolak echo-request sebelum memeriksa state agar balasan untuk ping keluar tetap bisa masuk.
ensure_rule -i lo -j ACCEPT
ensure_rule -p icmp --icmp-type echo-request -j DROP
ensure_rule -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ensure_rule -p tcp --dport 5000 -m conntrack --ctstate NEW -j ACCEPT

if ! iptables -w 5 -C INPUT -j "$chain" 2>/dev/null; then
    iptables -w 5 -I INPUT 1 -j "$chain"
fi
iptables -w 5 -P INPUT DROP
