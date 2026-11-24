#!/bin/bash
# Yui: eth0 ke Gendou, eth1 gateway Switch-Hangar, eth2 Mari, eth3 Rei, eth4 Shinji
DNS=192.168.122.1

ip addr replace 10.82.4.114/30 dev eth0
ip addr replace 10.82.3.1/25   dev eth1
ip addr replace 10.82.4.137/30 dev eth2
ip addr replace 10.82.4.141/30 dev eth3
ip addr replace 10.82.4.145/30 dev eth4
for i in eth0 eth1 eth2 eth3 eth4; do ip link set $i up; done

sysctl -w net.ipv4.ip_forward=1

ip route replace default via 10.82.4.113
ip route replace 10.82.4.32/28 via 10.82.4.138   # Switch-Dock lewat Mari
ip route replace 10.82.0.0/23  via 10.82.4.142   # Switch-Quarters lewat Rei
ip route replace 10.82.4.0/27  via 10.82.4.146   # Switch-Garden lewat Shinji

echo "nameserver $DNS" > /etc/resolv.conf
