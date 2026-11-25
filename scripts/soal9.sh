# Soal 9 - Sabotase routing di Shigeru.
# [Shigeru] lepas rule 18-19 sementara, simpan baseline
iptables -F INPUT; iptables -F FORWARD; iptables -F OUTPUT
bash /root/snapshot.sh /root/baseline.txt
# [Lilith] ping -c 2 10.82.4.83   -> harus berhasil

# [Shigeru] praktikan jalankan break_routing.sh (jangan dibaca), lalu:
bash /root/snapshot.sh /root/after.txt
diff /root/baseline.txt /root/after.txt

# [Shigeru] perbaikan
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.conf.all.accept_redirects=0
while ip rule del lookup 100 2>/dev/null; do :; done
ip route flush table 100
ip route del blackhole 10.82.4.72/29
ip route replace default via 10.82.4.133 dev eth0
ip route get 10.82.4.74 from 10.82.4.83 iif eth1   # harus lewat eth0
# [Lilith] ping -c 2 10.82.4.83   -> berhasil lagi

# [Shigeru] pasang lagi rule 18-19
bash /root/shigeru.sh
