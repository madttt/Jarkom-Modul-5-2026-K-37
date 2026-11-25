# Soal 5 - Firewall Gendou (rule lengkap ada di configs/router/gendou.sh).
# [Gendou]
bash /root/gendou.sh
iptables -S
iptables -Z

# [Armisael] internet tetap bisa (balasan lolos ESTABLISHED,RELATED)
ping -c 2 8.8.8.8

# [Gendou] lihat counter, policy DROP di INPUT naik dari trafik NAT1
iptables -L -nv
