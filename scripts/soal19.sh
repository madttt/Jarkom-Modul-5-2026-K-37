# Soal 19 - Isolasi Armisael (tidak ada rule di Armisael).
bash /root/shigeru.sh            # [Shigeru] rule IP + MAC Armisael paling atas
bash /root/zeruel.sh             # [Zeruel] blokir Armisael di switch yang sama

# [Zeruel dan Lilith] listener
nc -lk 9000 > /tmp/nc9000.log &

# [Armisael] semua harus gagal
ping -c 2 10.82.4.81             # gateway
ping -c 2 10.82.4.74             # Lilith
echo halo | nc -w 2 10.82.4.74 9000

# [Zeruel] harus berhasil
ping -c 2 10.82.4.74
echo dari-zeruel | nc -w 2 10.82.4.74 9000

# [Lilith] hanya ada pesan Zeruel
cat /tmp/nc9000.log
# [Shigeru] counter rule Armisael naik
iptables -L -nv | grep -E '10.82.4.83|MAC'
