#!/bin/sh
set -eu

chain=SOAL14_PENPEN
if ! iptables -w 5 -S "$chain" >/dev/null 2>&1; then
    iptables -w 5 -N "$chain"
fi

ensure() {
    target_chain=$1
    shift
    if ! iptables -w 5 -C "$target_chain" "$@" 2>/dev/null; then
        if [ "$target_chain" = INPUT ]; then
            iptables -w 5 -I "$target_chain" 1 "$@"
        else
            iptables -w 5 -A "$target_chain" "$@"
        fi
    fi
}

# Modul time menggunakan UTC. Jadwal berakhir tepat saat batas jam WIB tercapai.
for pilot in 10.82.4.66 10.82.4.67 10.82.4.68 10.82.3.130; do
    ensure "$chain" -s "$pilot/32" -m time --timestart 01:00:00 --timestop 08:59:59 \
        --weekdays Mon,Tue,Wed,Thu,Fri -j ACCEPT
    ensure "$chain" -s "$pilot/32" -j DROP
done

for staf in 10.82.4.74 10.82.4.75; do
    ensure "$chain" -s "$staf/32" -m time --timestart 10:00:00 --timestop 15:59:59 -j ACCEPT
    ensure "$chain" -s "$staf/32" -j DROP
done

for terduga in 10.82.4.50 10.82.4.51 10.82.4.102; do
    ensure "$chain" -s "$terduga/32" -j DROP
done

ensure "$chain" -j ACCEPT
ensure INPUT -p icmp --icmp-type echo-request -j "$chain"
ensure INPUT -p tcp --dport 80 -j "$chain"
