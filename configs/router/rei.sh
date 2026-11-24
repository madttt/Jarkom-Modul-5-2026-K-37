#!/bin/bash
# Rei: eth0 ke Yui, eth1 gateway Switch-Quarters
DNS=192.168.122.1

ip addr replace 10.82.4.142/30 dev eth0
ip addr replace 10.82.0.1/23 dev eth1
ip link set eth0 up
ip link set eth1 up

sysctl -w net.ipv4.ip_forward=1

# router ujung, cukup satu default route ke atas
ip route replace default via 10.82.4.141

echo "nameserver $DNS" > /etc/resolv.conf
