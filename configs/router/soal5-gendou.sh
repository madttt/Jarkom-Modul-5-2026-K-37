#!/bin/sh
set -eu

wan=eth0
internal=10.82.0.0/16

ensure() {
    chain=$1
    shift
    if ! iptables -w 5 -C "$chain" "$@" 2>/dev/null; then
        iptables -w 5 -A "$chain" "$@"
    fi
}

ensure INPUT -i lo -j ACCEPT
ensure INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ensure INPUT -i "$wan" -p udp --sport 67 --dport 68 -j ACCEPT
ensure INPUT ! -i "$wan" -s "$internal" -j ACCEPT

ensure FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ensure FORWARD ! -i "$wan" -s "$internal" -o "$wan" -j ACCEPT
ensure FORWARD ! -i "$wan" -s "$internal" -d "$internal" -j ACCEPT

iptables -w 5 -P INPUT DROP
iptables -w 5 -P FORWARD DROP
