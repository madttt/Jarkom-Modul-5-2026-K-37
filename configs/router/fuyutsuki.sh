#!/bin/bash
# Fuyutsuki: eth0 ke Gendou, eth1 gateway Switch-Terminal, eth2 Maya, eth3 Toji
# catatan: script ini hanya mengatur IP dan rute, rule iptables Fuyutsuki tidak disentuh
DNS=192.168.122.1

ip addr replace 10.82.4.110/30 dev eth0
ip addr replace 10.82.4.57/29  dev eth1
ip addr replace 10.82.4.149/30 dev eth2
ip addr replace 10.82.4.153/30 dev eth3
for i in eth0 eth1 eth2 eth3; do ip link set $i up; done

sysctl -w net.ipv4.ip_forward=1

ip route replace default via 10.82.4.109
ip route replace 10.82.3.192/27 via 10.82.4.150   # Switch-Medic lewat Maya
ip route replace 10.82.4.72/29  via 10.82.4.154   # Switch-Dogma lewat Toji

echo "nameserver $DNS" > /etc/resolv.conf
