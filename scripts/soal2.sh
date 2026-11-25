# Soal 2 - IP router + IP forwarding. Jalankan di TIAP router (isi script ada di configs/router/).
bash /root/gendou.sh            # ganti sesuai router: yui.sh, fuyutsuki.sh, asuka.sh, ...
ip -br a
sysctl net.ipv4.ip_forward      # harus = 1
ping -c 2 10.82.4.110           # ping router bawah di link (contoh Gendou -> Fuyutsuki)
