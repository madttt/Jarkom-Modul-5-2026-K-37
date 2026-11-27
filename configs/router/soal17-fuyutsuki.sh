#!/bin/sh
set -eu

# Balasan Pen-Pen kembali ke Casper melalui Fuyutsuki, sehingga conntrack membalik DNAT.
set -- -i eth1 -s 10.82.4.58/32 -d 10.82.4.82/32 -p tcp --dport 9000 \
    -m comment --comment soal17-casper-zeruel -j DNAT --to-destination 10.82.3.194:9000
if ! iptables -w 5 -t nat -C PREROUTING "$@" 2>/dev/null; then
    iptables -w 5 -t nat -I PREROUTING 1 "$@"
fi
