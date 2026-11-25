# Soal 3 - Routing statis. Rute sudah ada di /root/<router>.sh, tinggal cek.
# [Gendou / Yui / Shigeru]
ip route

# [Armisael] IP sementara (tidak ditulis ke file)
ip addr add 10.82.4.83/29 dev eth0
ip route replace default via 10.82.4.81
ping -c 2 10.82.4.74     # Lilith
ping -c 2 10.82.3.130    # Sachiel
ping -c 2 10.82.2.2      # Comm-Net
