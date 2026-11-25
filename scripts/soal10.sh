# Soal 10 - Sabotase NAT di Misato dan Gendou.
# [Unit-01 / Spy] ping -c 2 8.8.8.8   -> berhasil
# [Misato dan Gendou] simpan baseline
bash /root/snapshot.sh /root/baseline.txt

# [Misato dan Gendou] praktikan jalankan break_nat.sh (jangan dibaca), lalu:
iptables -Z; iptables -t nat -Z
# [Unit-01] ping 8.8.8.8 -> gagal,  [Spy] ping 8.8.8.8 -> normal
bash /root/snapshot.sh /root/after.txt
diff /root/baseline.txt /root/after.txt
iptables -t nat -L POSTROUTING -nv --line-numbers
iptables -L FORWARD -nv

# perbaikan
bash /root/misato.sh     # [Misato] kosongkan nat POSTROUTING
bash /root/gendou.sh     # [Gendou] flush nat, pasang ulang MASQUERADE + firewall soal 5
# [Unit-01 / Spy] ping -c 2 8.8.8.8 -> berhasil
