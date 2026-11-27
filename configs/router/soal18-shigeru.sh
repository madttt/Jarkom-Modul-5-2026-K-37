#!/bin/sh
set -eu

chain=SOAL18_GERBANG
if ! iptables -w 5 -S "$chain" >/dev/null 2>&1; then
    iptables -w 5 -N "$chain"
fi

ensure() {
    if ! iptables -w 5 -C "$chain" "$@" 2>/dev/null; then
        iptables -w 5 -A "$chain" "$@"
    fi
}

# Balasan untuk koneksi dari dalam zona dan ping Terminal boleh melewati gerbang.
ensure -m conntrack --ctstate ESTABLISHED,RELATED --ctdir REPLY -j ACCEPT
ensure -s 10.82.4.56/29 -p icmp --icmp-type echo-request -j ACCEPT
ensure -j DROP

if ! iptables -w 5 -C FORWARD -i eth0 -j "$chain" 2>/dev/null; then
    iptables -w 5 -I FORWARD 1 -i eth0 -j "$chain"
fi
