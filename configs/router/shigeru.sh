#!/bin/bash
# Shigeru: eth0 ke Gendou, eth1 gateway Switch-Monolith, eth2 Makoto
# firewall soal 18-19 ditambahkan belakangan di file ini
DNS=192.168.122.1

ip addr replace 10.82.4.134/30 dev eth0
ip addr replace 10.82.4.81/29  dev eth1
ip addr replace 10.82.4.169/30 dev eth2
for i in eth0 eth1 eth2; do ip link set $i up; done

# ip_forward=1 juga menyalakan ulang forwarding di semua interface (all/default/eth*)
sysctl -w net.ipv4.ip_forward=1
# router tidak boleh mengubah rute karena ICMP redirect
sysctl -w net.ipv4.conf.all.accept_redirects=0

# soal 9: buang policy routing yang memaksa traffic dari Monolith (eth1)
# ke tabel 100 berisi "unreachable default", serta blackhole ke Switch-Dogma
while ip rule del lookup 100 2>/dev/null; do :; done
ip route flush table 100 2>/dev/null
ip route del blackhole 10.82.4.72/29 2>/dev/null

# default route harus ke Gendou, bukan ke Makoto (Makoto juga default ke sini -> loop)
ip route replace default via 10.82.4.133 dev eth0
ip route replace 10.82.4.88/29 via 10.82.4.170   # Switch-Radar lewat Makoto

echo "nameserver $DNS" > /etc/resolv.conf

# ---------- soal 18 & 19: firewall zona Monolith + Radar ----------
GENDOU_SIDE=eth0              # interface Shigeru yang menghadap Gendou
TERMINAL=10.82.4.56/29        # subnet Switch-Terminal (MAGI)
ARMISAEL=10.82.4.83
ARMISAEL_MAC=02:42:e4:de:74:00

# tulis ulang dari awal supaya aman dijalankan ulang
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F INPUT
iptables -F FORWARD
iptables -F OUTPUT

# soal 19: Armisael diputus total, diletakkan paling atas supaya tidak
# lolos lewat rule ESTABLISHED atau pengecualian ping Terminal.
# dicocokkan lewat IP dan MAC, jadi ganti IP pun tetap terblokir.
iptables -A INPUT   -s $ARMISAEL -j DROP
iptables -A INPUT   -m mac --mac-source $ARMISAEL_MAC -j DROP
iptables -A OUTPUT  -d $ARMISAEL -j DROP
iptables -A FORWARD -s $ARMISAEL -j DROP
iptables -A FORWARD -d $ARMISAEL -j DROP
iptables -A FORWARD -m mac --mac-source $ARMISAEL_MAC -j DROP

# soal 18: dari dalam zona bebas keluar, balasannya boleh masuk
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# satu-satunya pengecualian: ping dari subnet Terminal
iptables -A FORWARD -i $GENDOU_SIDE -s $TERMINAL -p icmp --icmp-type echo-request -j ACCEPT
# selain itu, koneksi baru yang datang dari arah Gendou ditolak (tanpa daftar subnet luar)
iptables -A FORWARD -i $GENDOU_SIDE -m conntrack --ctstate NEW -j DROP
