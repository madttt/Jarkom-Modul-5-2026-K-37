# Soal 18 - Gerbang Monolith + Radar (rule lengkap di configs/router/shigeru.sh).
ZERUEL=10.82.4.8x                # isi IP Zeruel (cek: ip -br a di Zeruel)

# [Shigeru]
bash /root/shigeru.sh
iptables -S FORWARD

# [Magi-casper] (Terminal) ping Zeruel -> berhasil
ping -c 2 $ZERUEL
# [Lilith] ping Zeruel -> gagal
ping -c 2 $ZERUEL
# [Zeruel] keluar zona tetap bisa
ping -c 2 8.8.8.8

# [Shigeru] cek counter
iptables -L FORWARD -nv
