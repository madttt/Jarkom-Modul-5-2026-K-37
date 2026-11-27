#!/bin/bash
# Zeruel: bagian isolasi Armisael (soal 19).
# Armisael dan Zeruel satu Switch-Monolith, trafik di antara keduanya tidak
# melewati Shigeru, jadi blokirnya dipasang di sisi Zeruel (bukan di Armisael).
# Rule hanya menyasar Armisael, trafik Zeruel ke tujuan lain tidak terpengaruh.
ARMISAEL=10.82.4.83
ARMISAEL_MAC=02:42:fa:6a:2a:00

for c in INPUT OUTPUT; do
    while iptables -D $c -s $ARMISAEL -j DROP 2>/dev/null; do :; done
    while iptables -D $c -d $ARMISAEL -j DROP 2>/dev/null; do :; done
done
while iptables -D INPUT -m mac --mac-source $ARMISAEL_MAC -j DROP 2>/dev/null; do :; done

iptables -I INPUT 1  -s $ARMISAEL -j DROP
iptables -I INPUT 2  -m mac --mac-source $ARMISAEL_MAC -j DROP
iptables -I OUTPUT 1 -d $ARMISAEL -j DROP
