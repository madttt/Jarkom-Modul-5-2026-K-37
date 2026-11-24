#!/bin/bash
# Misato: eth0 ke Gendou, eth1 gateway Switch-Cage
DNS=192.168.122.1

ip addr replace 10.82.4.130/30 dev eth0
ip addr replace 10.82.4.65/29 dev eth1
ip link set eth0 up
ip link set eth1 up

sysctl -w net.ipv4.ip_forward=1

# router ujung, cukup satu default route ke atas
ip route replace default via 10.82.4.129

echo "nameserver $DNS" > /etc/resolv.conf

# soal 10: Misato bukan titik NAT. Source NAT ke internet hanya dilakukan Gendou
# (MASQUERADE di eth0 NAT1), jadi POSTROUTING di sini harus kosong. SNAT ke
# alamat lain membuat Gendou menolak paket (sumbernya bukan 10.82.0.0/16)
# dan balasan dari internet tidak tahu jalan pulang.
iptables -t nat -F POSTROUTING
