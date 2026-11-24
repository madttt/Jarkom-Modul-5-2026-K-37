#!/bin/bash
# Gendou: router pusat, satu-satunya yang terhubung ke NAT1
# eth0 NAT1, eth1 Switch-Cmd, eth2 Fuyutsuki, eth3 Yui, eth4 Hikari,
# eth5 Asuka, eth6 Kaji, eth7 Misato, eth8 Shigeru
PREFIX=10.82.0.0/16
WAN=eth0

# ---------- soal 2: alamat interface & forwarding ----------
ip addr replace 10.82.4.105/30 dev eth1
ip addr replace 10.82.4.109/30 dev eth2
ip addr replace 10.82.4.113/30 dev eth3
ip addr replace 10.82.4.117/30 dev eth4
ip addr replace 10.82.4.121/30 dev eth5
ip addr replace 10.82.4.125/30 dev eth6
ip addr replace 10.82.4.129/30 dev eth7
ip addr replace 10.82.4.133/30 dev eth8
for i in eth0 eth1 eth2 eth3 eth4 eth5 eth6 eth7 eth8; do ip link set $i up; done

sysctl -w net.ipv4.ip_forward=1

# eth0 minta IP ke NAT1 lewat DHCP (sekalian dapat default route dan DNS).
# image debinet tidak membawa dhclient, jadi pakai udhcpc bawaan GNS3.
# udhcpc jalan di background supaya lease diperpanjang kalau IP NAT1 berganti.
if command -v dhclient >/dev/null; then
    ip -4 addr show $WAN | grep -q inet || dhclient $WAN
elif ! pgrep -f "udhcpc -i $WAN" >/dev/null; then
    /gns3/bin/busybox udhcpc -i $WAN -s /gns3/etc/udhcpc/default.script -b -t 5 -T 3
    sleep 3
fi

# ---------- soal 3: rute ke tiap cabang ----------
# cabang Fuyutsuki
ip route replace 10.82.4.56/29  via 10.82.4.110   # Switch-Terminal
ip route replace 10.82.3.192/27 via 10.82.4.110   # Switch-Medic
ip route replace 10.82.4.72/29  via 10.82.4.110   # Switch-Dogma
ip route replace 10.82.4.148/30 via 10.82.4.110   # link Fuyutsuki-Maya
ip route replace 10.82.4.152/30 via 10.82.4.110   # link Fuyutsuki-Toji
# cabang Yui
ip route replace 10.82.3.0/25   via 10.82.4.114   # Switch-Hangar
ip route replace 10.82.4.32/28  via 10.82.4.114   # Switch-Dock
ip route replace 10.82.0.0/23   via 10.82.4.114   # Switch-Quarters
ip route replace 10.82.4.0/27   via 10.82.4.114   # Switch-Garden
ip route replace 10.82.4.136/30 via 10.82.4.114   # link Yui-Mari
ip route replace 10.82.4.140/30 via 10.82.4.114   # link Yui-Rei
ip route replace 10.82.4.144/30 via 10.82.4.114   # link Yui-Shinji
# cabang Hikari
ip route replace 10.82.2.0/24   via 10.82.4.118   # Switch-Comm
ip route replace 10.82.3.224/27 via 10.82.4.118   # Switch-Relay
ip route replace 10.82.4.164/30 via 10.82.4.118   # link Hikari-Kaworu
# cabang Asuka
ip route replace 10.82.4.96/30  via 10.82.4.122   # Switch-Archive
ip route replace 10.82.3.128/26 via 10.82.4.122   # Switch-Bunker
ip route replace 10.82.4.48/29  via 10.82.4.122   # Switch-Lab
ip route replace 10.82.4.156/30 via 10.82.4.122   # link Asuka-Kensuke
ip route replace 10.82.4.160/30 via 10.82.4.122   # link Asuka-Ritsuko
# cabang Kaji dan Misato
ip route replace 10.82.4.100/30 via 10.82.4.126   # Switch-Intel
ip route replace 10.82.4.64/29  via 10.82.4.130   # Switch-Cage
# cabang Shigeru: Monolith (4.80/29) + Radar (4.88/29) pas jadi satu /28
ip route replace 10.82.4.80/28  via 10.82.4.134
ip route replace 10.82.4.168/30 via 10.82.4.134   # link Shigeru-Makoto

# ---------- soal 4: NAT ----------
command -v iptables >/dev/null || { apt-get update && apt-get install -y iptables; }

# mulai dari kondisi bersih supaya script aman dijalankan ulang
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -t nat -F

# MASQUERADE ikut IP eth0 yang sedang dipakai, jadi aman kalau IP dari NAT1 berganti.
# -s dan -o membatasi hanya traffic internal yang keluar ke NAT1 yang diterjemahkan.
# soal 10: tidak boleh ada rule RETURN/ACCEPT untuk subnet mana pun sebelum rule ini,
# karena subnet yang lolos tanpa di-NAT akan keluar dengan IP privat 10.82.x.x.
# flush di atas sudah membuang pengecualian seperti itu.
iptables -t nat -A POSTROUTING -s $PREFIX -o $WAN -j MASQUERADE

# ---------- soal 5: firewall ----------
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i $WAN -p udp --sport 67 --dport 68 -j ACCEPT
iptables -A INPUT -s $PREFIX -j ACCEPT

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s $PREFIX -o $WAN -j ACCEPT
iptables -A FORWARD -s $PREFIX -d $PREFIX -j ACCEPT

iptables -P INPUT DROP
iptables -P FORWARD DROP
