#!/bin/bash
# Hikari: eth0 ke Gendou, eth1 gateway Switch-Comm, eth2 Kaworu
DNS=192.168.122.1

ip addr replace 10.82.4.118/30 dev eth0
ip addr replace 10.82.2.1/24   dev eth1
ip addr replace 10.82.4.165/30 dev eth2
for i in eth0 eth1 eth2; do ip link set $i up; done

sysctl -w net.ipv4.ip_forward=1

ip route replace default via 10.82.4.117
ip route replace 10.82.3.224/27 via 10.82.4.166   # Switch-Relay lewat Kaworu

echo "nameserver $DNS" > /etc/resolv.conf
