#!/bin/sh
set -eu

# Echo-reply untuk ping yang dimulai Casper tetap melewati aturan INPUT yang sudah ada.
set -- -p icmp --icmp-type echo-request -m comment --comment soal11-casper-echo-request -j DROP
if ! iptables -w 5 -C INPUT "$@" 2>/dev/null; then
    iptables -w 5 -I INPUT 1 "$@"
fi
