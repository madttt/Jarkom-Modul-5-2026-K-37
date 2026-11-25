# Soal 4 - NAT + DNS.
# [Gendou] rule NAT (sudah ada di gendou.sh), nolkan counter dulu
iptables -t nat -C POSTROUTING -s 10.82.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null ||
iptables -t nat -A POSTROUTING -s 10.82.0.0/16 -o eth0 -j MASQUERADE
iptables -t nat -Z POSTROUTING
iptables -t nat -L POSTROUTING -nv

# [Armisael / Lilith]
echo nameserver 192.168.122.1 > /etc/resolv.conf
ping -c 2 8.8.8.8
ping -c 2 deb.debian.org

# [Gendou] counter MASQUERADE harus naik
iptables -t nat -L POSTROUTING -nv
