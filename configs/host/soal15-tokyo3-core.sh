#!/bin/sh
set -eu

chain=SOAL15_ICMP
if ! iptables -w 5 -S "$chain" >/dev/null 2>&1; then
    iptables -w 5 -N "$chain"
fi

ensure() {
    if ! iptables -w 5 -C "$chain" "$@" 2>/dev/null; then
        iptables -w 5 -A "$chain" "$@"
    fi
}

# Satu token awal membatasi lonjakan. Token berikutnya tersedia setiap 200 ms.
ensure -m limit --limit 5/second --limit-burst 1 -j ACCEPT
ensure -j DROP

set -- -p icmp --icmp-type echo-request -j "$chain"
if ! iptables -w 5 -C INPUT "$@" 2>/dev/null; then
    iptables -w 5 -I INPUT 1 "$@"
fi
