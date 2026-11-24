#!/bin/bash
# Asuka: eth0 ke Gendou, eth1 gateway Switch-Archive, eth2 Kensuke, eth3 Ritsuko
DNS=192.168.122.1

ip addr replace 10.82.4.122/30 dev eth0
ip addr replace 10.82.4.97/30  dev eth1
ip addr replace 10.82.4.157/30 dev eth2
ip addr replace 10.82.4.161/30 dev eth3
for i in eth0 eth1 eth2 eth3; do ip link set $i up; done

sysctl -w net.ipv4.ip_forward=1

ip route replace default via 10.82.4.121
ip route replace 10.82.3.128/26 via 10.82.4.158   # Switch-Bunker lewat Kensuke
ip route replace 10.82.4.48/29  via 10.82.4.162   # Switch-Lab lewat Ritsuko

echo "nameserver $DNS" > /etc/resolv.conf
