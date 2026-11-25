# Soal 6 - IP statis permanen. Isi /etc/network/interfaces tiap host dari configs/host/<Host>.interfaces
# (GNS3: klik kanan host -> Edit network configuration), contoh Unit-01:
#   auto eth0
#   iface eth0 inet static
#       address 10.82.4.66
#       netmask 255.255.255.248
#       gateway 10.82.4.65
#       up echo nameserver 192.168.122.1 > /etc/resolv.conf

# Restart host di GNS3 (stop -> start), lalu di [Unit-01]:
ps -o etime= -p 1        # container baru menyala
ip -br a
ip route
ping -c 2 10.82.4.65
