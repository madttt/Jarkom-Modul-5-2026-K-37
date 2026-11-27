# Jarkom-Modul-5-2026-K-37

| Nama | NRP |
|:---:|:---:|
| Azfaro Zid Ilmi | 5027251018 |
| Gede Satya Putra Aryanta | 5027251012 |

---

## Daftar Isi

- [Tabel Pembagian Interface & Alamat IP](#tabel-pembagian-interface--alamat-ip)
- [Topologi Jaringan](#topologi-jaringan)
- [Soal 1 — VLSM](#soal-1--vlsm)
- [Soal 2 — IP router dan IP forwarding](#soal-2--ip-router-dan-ip-forwarding)
- [Soal 3 — Routing statis dengan rute minimal](#soal-3--routing-statis-dengan-rute-minimal)
- [Soal 4 — NAT dan DNS](#soal-4--nat-dan-dns)
- [Soal 5 — Firewall Gendou](#soal-5--firewall-gendou)
- [Soal 6 — IP statis permanen](#soal-6--ip-statis-permanen)
- [Soal 7 — Layanan MAGI](#soal-7--layanan-magi)
- [Soal 8 — Layanan Pen-Pen dan Tokyo3-Core](#soal-8--layanan-pen-pen-dan-tokyo3-core)
- [Soal 9 — Sabotase routing di Shigeru](#soal-9--sabotase-routing-di-shigeru)
- [Soal 10 — Sabotase NAT di Misato dan Gendou](#soal-10--sabotase-nat-di-misato-dan-gendou)
- [Soal 11 — Blokir ping masuk ke Magi-Casper](#soal-11--blokir-ping-masuk-ke-magi-casper)
- [Soal 12 — Pemulihan firewall Magi-Casper](#soal-12--pemulihan-firewall-magi-casper)
- [Soal 13 — Firewall Magi-Balthasar](#soal-13--firewall-magi-balthasar)
- [Soal 14 — Jadwal akses Pen-Pen](#soal-14--jadwal-akses-pen-pen)
- [Soal 15 — Pembatasan ping Tokyo3-Core](#soal-15--pembatasan-ping-tokyo3-core)
- [Soal 16 — Log koneksi Dummy-Plug](#soal-16--log-koneksi-dummy-plug)
- [Soal 17 — DNAT Casper ke Pen-Pen](#soal-17--dnat-casper-ke-pen-pen)
- [Soal 18 — Gerbang Monolith dan Radar (Shigeru)](#soal-18--gerbang-monolith-dan-radar-shigeru)
- [Soal 19 — Isolasi Armisael](#soal-19--isolasi-armisael)
- [Soal 20 — Cadangan dan pemulihan GNS3](#soal-20--cadangan-dan-pemulihan-gns3)

---

## Tabel Pembagian Interface & Alamat IP

| Item | Nilai |
|---|---|
| Project GNS3 | `K-37-MODUL-5` |
| Base network | `10.82.0.0/16` (terpakai `10.82.0.0` – `10.82.4.171`) |
| Image | `ardhptr21/debinet:latest` |
| Router pusat | **Gendou** (`eth0` → NAT1, DHCP) |
| DNS | `192.168.122.1` (didapat Gendou dari DHCP NAT1) |

| Router | eth0 | eth1 | eth2 | eth3 | eth4–eth8 |
|:---|:---|:---|:---|:---|:---|
| Gendou | DHCP (NAT1) | 10.82.4.105/30 | 10.82.4.109/30 | 10.82.4.113/30 | .117, .121, .125, .129, .133 (/30) |
| Yui | 10.82.4.114/30 | 10.82.3.1/25 | 10.82.4.137/30 | 10.82.4.141/30 | eth4 10.82.4.145/30 |
| Fuyutsuki | 10.82.4.110/30 | 10.82.4.57/29 | 10.82.4.149/30 | 10.82.4.153/30 | |
| Asuka | 10.82.4.122/30 | 10.82.4.97/30 | 10.82.4.157/30 | 10.82.4.161/30 | |
| Hikari | 10.82.4.118/30 | 10.82.2.1/24 | 10.82.4.165/30 | | |
| Shigeru | 10.82.4.134/30 | 10.82.4.81/29 | 10.82.4.169/30 | | |
| Kaji | 10.82.4.126/30 | 10.82.4.101/30 | | | |
| Misato | 10.82.4.130/30 | 10.82.4.65/29 | | | |
| Mari | 10.82.4.138/30 | 10.82.4.33/28 | | | |
| Rei | 10.82.4.142/30 | 10.82.0.1/23 | | | |
| Shinji | 10.82.4.146/30 | 10.82.4.1/27 | | | |
| Maya | 10.82.4.150/30 | 10.82.3.193/27 | | | |
| Toji | 10.82.4.154/30 | 10.82.4.73/29 | | | |
| Kaworu | 10.82.4.166/30 | 10.82.3.225/27 | | | |
| Kensuke | 10.82.4.158/30 | 10.82.3.129/26 | | | |
| Ritsuko | 10.82.4.162/30 | 10.82.4.49/29 | | | |
| Makoto | 10.82.4.170/30 | 10.82.4.89/29 | | | |

IP host ada di [Soal 6](#soal-6--ip-statis-permanen). Skrip konfigurasi tiap node dan tahap pengujian tersimpan di folder [configs/](configs/) dan [scripts/](scripts/).

---

## Topologi Jaringan

Topologi proyek `K-37-MODUL-5` terdiri atas **60 node dan 59 link**: 1 node `NAT1`, 17 Ethernet switch (`Switch-*`), 17 router Docker (`Gendou` hingga `Makoto`), dan 25 host Docker berbasis image `ardhptr21/debinet:latest`. Router pusat `Gendou` terhubung ke `NAT1` pada `eth0` sebagai satu-satunya titik keluar ke internet, sementara cabang di bawahnya terhubung melalui link `/30` dan switch LAN masing-masing.

![Topologi GNS3](assets/topologi-gns3.png)

Arsip proyek portabel final tersedia di [K-37-MODUL-5.gns3project](K-37-MODUL-5.gns3project).

---


## Soal 1 — VLSM

Spreadsheet Kelompok 37 tersedia di [VLSM Modul 5](Kelompok%2037%20-%20VLSM%20Modul%205.xlsx).

Aturan hitung:

- kebutuhan IP = jumlah host + 1 gateway (link antar-router = 2 IP);
- prefix = prefix terkecil yang jumlah IP usable-nya (2^(32−prefix) − 2) ≥ kebutuhan;
- alokasi diurutkan dari blok terbesar; ukuran blok sama → LAN dulu, lalu link; sesama LAN ikut urutan
  tabel host, sesama link ikut urutan kabel dari Gendou ke bawah.

| No | Subnet | Kebutuhan (IP terpakai) | Prefix | Network | Gateway | Broadcast | Netmask | Sisa |
|:-:|:---|:-:|:-:|:---|:---|:---|:---|:-:|
| 1 | Switch-Quarters | 501 | /23 | 10.82.0.0 | 10.82.0.1 | 10.82.1.255 | 255.255.254.0 | 9 |
| 2 | Switch-Comm | 201 | /24 | 10.82.2.0 | 10.82.2.1 | 10.82.2.255 | 255.255.255.0 | 53 |
| 3 | Switch-Hangar | 101 | /25 | 10.82.3.0 | 10.82.3.1 | 10.82.3.127 | 255.255.255.128 | 25 |
| 4 | Switch-Bunker | 56 | /26 | 10.82.3.128 | 10.82.3.129 | 10.82.3.191 | 255.255.255.192 | 6 |
| 5 | Switch-Medic | 27 | /27 | 10.82.3.192 | 10.82.3.193 | 10.82.3.223 | 255.255.255.224 | 3 |
| 6 | Switch-Relay | 26 | /27 | 10.82.3.224 | 10.82.3.225 | 10.82.3.255 | 255.255.255.224 | 4 |
| 7 | Switch-Garden | 15 | /27 | 10.82.4.0 | 10.82.4.1 | 10.82.4.31 | 255.255.255.224 | 15 |
| 8 | Switch-Dock | 13 | /28 | 10.82.4.32 | 10.82.4.33 | 10.82.4.47 | 255.255.255.240 | 1 |
| 9 | Switch-Lab | 6 | /29 | 10.82.4.48 | 10.82.4.49 | 10.82.4.55 | 255.255.255.248 | 0 |
| 10 | Switch-Terminal | 4 | /29 | 10.82.4.56 | 10.82.4.57 | 10.82.4.63 | 255.255.255.248 | 2 |
| 11 | Switch-Cage | 4 | /29 | 10.82.4.64 | 10.82.4.65 | 10.82.4.71 | 255.255.255.248 | 2 |
| 12 | Switch-Dogma | 3 | /29 | 10.82.4.72 | 10.82.4.73 | 10.82.4.79 | 255.255.255.248 | 3 |
| 13 | Switch-Monolith | 3 | /29 | 10.82.4.80 | 10.82.4.81 | 10.82.4.87 | 255.255.255.248 | 3 |
| 14 | Switch-Radar | 5 | /29 | 10.82.4.88 | 10.82.4.89 | 10.82.4.95 | 255.255.255.248 | 1 |
| 15 | Switch-Archive | 2 | /30 | 10.82.4.96 | 10.82.4.97 | 10.82.4.99 | 255.255.255.252 | 0 |
| 16 | Switch-Intel | 2 | /30 | 10.82.4.100 | 10.82.4.101 | 10.82.4.103 | 255.255.255.252 | 0 |
| 17 | Switch-Cmd | 2 | /30 | 10.82.4.104 | 10.82.4.105 | 10.82.4.107 | 255.255.255.252 | 0 |
| L1 | Gendou–Fuyutsuki | 2 | /30 | 10.82.4.108 | .109 / .110 | 10.82.4.111 | 255.255.255.252 | 0 |
| L2 | Gendou–Yui | 2 | /30 | 10.82.4.112 | .113 / .114 | 10.82.4.115 | 255.255.255.252 | 0 |
| L3 | Gendou–Hikari | 2 | /30 | 10.82.4.116 | .117 / .118 | 10.82.4.119 | 255.255.255.252 | 0 |
| L4 | Gendou–Asuka | 2 | /30 | 10.82.4.120 | .121 / .122 | 10.82.4.123 | 255.255.255.252 | 0 |
| L5 | Gendou–Kaji | 2 | /30 | 10.82.4.124 | .125 / .126 | 10.82.4.127 | 255.255.255.252 | 0 |
| L6 | Gendou–Misato | 2 | /30 | 10.82.4.128 | .129 / .130 | 10.82.4.131 | 255.255.255.252 | 0 |
| L7 | Gendou–Shigeru | 2 | /30 | 10.82.4.132 | .133 / .134 | 10.82.4.135 | 255.255.255.252 | 0 |
| L8 | Yui–Mari | 2 | /30 | 10.82.4.136 | .137 / .138 | 10.82.4.139 | 255.255.255.252 | 0 |
| L9 | Yui–Rei | 2 | /30 | 10.82.4.140 | .141 / .142 | 10.82.4.143 | 255.255.255.252 | 0 |
| L10 | Yui–Shinji | 2 | /30 | 10.82.4.144 | .145 / .146 | 10.82.4.147 | 255.255.255.252 | 0 |
| L11 | Fuyutsuki–Maya | 2 | /30 | 10.82.4.148 | .149 / .150 | 10.82.4.151 | 255.255.255.252 | 0 |
| L12 | Fuyutsuki–Toji | 2 | /30 | 10.82.4.152 | .153 / .154 | 10.82.4.155 | 255.255.255.252 | 0 |
| L13 | Asuka–Kensuke | 2 | /30 | 10.82.4.156 | .157 / .158 | 10.82.4.159 | 255.255.255.252 | 0 |
| L14 | Asuka–Ritsuko | 2 | /30 | 10.82.4.160 | .161 / .162 | 10.82.4.163 | 255.255.255.252 | 0 |
| L15 | Hikari–Kaworu | 2 | /30 | 10.82.4.164 | .165 / .166 | 10.82.4.167 | 255.255.255.252 | 0 |
| L16 | Shigeru–Makoto | 2 | /30 | 10.82.4.168 | .169 / .170 | 10.82.4.171 | 255.255.255.252 | 0 |

Pada link, IP pertama untuk router atas (arah Gendou), IP kedua untuk router bawah.

**Contoh hitungan satu subnet — Switch-Medic (Maya):**

1. Host: Pen-Pen 1 + Medic-Bay 25 = 26 host, ditambah 1 gateway → butuh **27 IP**.
2. /28 hanya punya 16 − 2 = 14 IP usable (kurang). /27 punya 32 − 2 = **30 IP usable** (cukup) → prefix **/27**,
   netmask `255.255.255.224`.
3. Blok sebelumnya (Switch-Bunker `10.82.3.128/26`) berakhir di `10.82.3.191`, jadi network Medic mulai di
   **`10.82.3.192`**. Ukuran blok 32 → broadcast `10.82.3.192 + 31` = **`10.82.3.223`**.
4. Gateway = IP usable pertama = **`10.82.3.193`** (Maya `eth1`), host `10.82.3.194` (Pen-Pen) dan
   `10.82.3.195` (Medic-Bay).
5. Sisa = 30 − 27 = **3 IP**.

**Pohon IP** — subnet jalur Dummy-Plug ke Armisael dilingkari merah
(Switch-Lab `10.82.4.48/29` → L14 `10.82.4.160/30` → L4 `10.82.4.120/30` → L7 `10.82.4.132/30` →
Switch-Monolith `10.82.4.80/29`):

![Pohon VLSM](assets/soal1-pohon-vlsm.png)

---

## Soal 2 — IP router dan IP forwarding

Tiap router punya `/root/<router>.sh` yang memasang IP sesuai tabel, menyalakan interface, dan
`sysctl -w net.ipv4.ip_forward=1`. Pemetaan interface mengikuti kabel di kanvas, lihat
[Tabel Pembagian Interface & Alamat IP](#tabel-pembagian-interface--alamat-ip).

Hanya Gendou yang terhubung ke NAT1 dan mengambil alamat lewat DHCP. Image debinet tidak membawa
`dhclient`, jadi Gendou memakai `udhcpc` yang disediakan GNS3 di dalam container
(`/gns3/bin/busybox udhcpc -i eth0 -s /gns3/etc/udhcpc/default.script -b`). Opsi `-b` membuat udhcpc
tetap berjalan di background dan memperpanjang lease, jadi alamat ikut diperbarui kalau IP dari NAT1
berganti. Script yang sama otomatis memakai `dhclient` kalau tersedia.

Bukti `ip -br a` di tiap router, dan ping dua ujung untuk ke-16 link (dari sisi router atas ke IP router
bawah, semuanya 0% loss):

![Gendou](assets/soal2-gendou.png)

<details>
<summary>Router lain (Yui, Fuyutsuki, Asuka, Hikari, Shigeru, Kaji, Misato, Mari, Rei, Shinji, Maya, Toji, Kaworu, Kensuke, Ritsuko, Makoto)</summary>

![Yui](assets/soal2-yui.png)
![Fuyutsuki](assets/soal2-fuyutsuki.png)
![Asuka](assets/soal2-asuka.png)
![Hikari](assets/soal2-hikari.png)
![Shigeru](assets/soal2-shigeru.png)
![Kaji](assets/soal2-kaji.png)
![Misato](assets/soal2-misato.png)
![Mari](assets/soal2-mari.png)
![Rei](assets/soal2-rei.png)
![Shinji](assets/soal2-shinji.png)
![Maya](assets/soal2-maya.png)
![Toji](assets/soal2-toji.png)
![Kaworu](assets/soal2-kaworu.png)
![Kensuke](assets/soal2-kensuke.png)
![Ritsuko](assets/soal2-ritsuko.png)
![Makoto](assets/soal2-makoto.png)

</details>

---

## Soal 3 — Routing statis dengan rute minimal

Prinsipnya: router selain Gendou cukup punya **satu default route ke atas** ditambah rute ke subnet yang ada di
bawahnya lewat router lain. Router ujung (Kaji, Misato, Mari, Rei, Shinji, Maya, Toji, Kaworu, Kensuke,
Ritsuko, Makoto) hanya punya default route. Subnet yang menempel langsung di interface tidak perlu rute.

Summarization dicek per cabang Gendou. Satu-satunya cabang yang subnet-nya bisa digabung **tepat** menjadi
satu CIDR adalah Shigeru: Switch-Monolith `10.82.4.80/29` + Switch-Radar `10.82.4.88/29` = `10.82.4.80/28`
(blok /28 utuh, tidak ada alamat milik cabang lain di dalamnya). Cabang lain tidak bisa diringkas karena
bloknya tidak berdampingan; misalnya Terminal `4.56/29` dan Dogma `4.72/29` di cabang Fuyutsuki dipisah oleh
Cage `4.64/29` milik Misato.

| Router | Rute |
|:---|:---|
| Gendou | default dari DHCP NAT1; Fuyutsuki `.110`: 4.56/29, 3.192/27, 4.72/29, 4.148/30, 4.152/30; Yui `.114`: 3.0/25, 4.32/28, 0.0/23, 4.0/27, 4.136/30, 4.140/30, 4.144/30; Hikari `.118`: 2.0/24, 3.224/27, 4.164/30; Asuka `.122`: 4.96/30, 3.128/26, 4.48/29, 4.156/30, 4.160/30; Kaji `.126`: 4.100/30; Misato `.130`: 4.64/29; Shigeru `.134`: **4.80/28** (ringkasan), 4.168/30 |
| Yui | default via .113; 4.32/28 via .138; 0.0/23 via .142; 4.0/27 via .146 |
| Fuyutsuki | default via .109; 3.192/27 via .150; 4.72/29 via .154 |
| Asuka | default via .121; 3.128/26 via .158; 4.48/29 via .162 |
| Hikari | default via .117; 3.224/27 via .166 |
| Shigeru | default via .133; 4.88/29 via .170 |
| Router ujung | hanya default ke router di atasnya |

Node uji di luar cabang kiri dan atas (Armisael, Zeruel, Lilith, Magi-casper) diberi IP **sementara**
lewat `ip addr add` / `ip route replace default`, tanpa menulis file, sehingga konfigurasi permanen mereka
tetap mengikuti soal 6.

![Rute Gendou](assets/soal3-gendou-route.png)
![Rute Yui](assets/soal3-yui-route.png)
![Rute Shigeru](assets/soal3-shigeru-route.png)

Armisael berhasil ping Lilith, Sachiel, dan Comm-Net:

![Armisael ping](assets/soal3-armisael-ping.png)

---

## Soal 4 — NAT dan DNS

Di Gendou:

```bash
iptables -t nat -A POSTROUTING -s 10.82.0.0/16 -o eth0 -j MASQUERADE
```

- `MASQUERADE` memakai alamat `eth0` yang sedang aktif saat paket keluar, jadi rule tidak perlu diubah kalau
  IP dari NAT1 berganti (berbeda dengan `SNAT --to-source <ip>` yang menulis IP mati).
- `-s 10.82.0.0/16 -o eth0` membatasi agar hanya trafik dari prefix internal yang keluar lewat NAT1 yang
  diterjemahkan. Trafik antar-LAN tidak lewat `eth0`, jadi tetap membawa alamat asli pengirimnya.
- DNS memakai nameserver yang diberikan DHCP NAT1 ke Gendou (`192.168.122.1`). Semua router dan host menulis
  `nameserver 192.168.122.1` ke `/etc/resolv.conf`, sehingga node yang nanti memasang paket bisa me-resolve
  domain.

Counter MASQUERADE di-nol-kan dulu, lalu Armisael dan Lilith ping `8.8.8.8` dan `deb.debian.org`:

![Counter sebelum](assets/soal4-gendou-nat-before.png)
![Armisael](assets/soal4-armisael.png)
![Lilith](assets/soal4-lilith.png)

Counter rule NAT naik setelah pengujian:

![Counter NAT](assets/soal4-gendou-nat.png)

---

## Soal 5 — Firewall Gendou

Seluruh konfigurasi Gendou (IP, forwarding, DHCP, rute, NAT, firewall) ada di satu file
`/root/gendou.sh`. Rule izin ditulis dulu, baru policy diubah ke `DROP`, supaya sesi console tidak
terputus di tengah jalan:

```bash
iptables -A INPUT -i lo -j ACCEPT                                          # loopback
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT     # (a) balasan ke Gendou
iptables -A INPUT -i eth0 -p udp --sport 67 --dport 68 -j ACCEPT           # DHCP dari NAT1
iptables -A INPUT -s 10.82.0.0/16 -j ACCEPT                                # (d) internal ke Gendou

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT   # (a) balasan koneksi
iptables -A FORWARD -s 10.82.0.0/16 -o eth0 -j ACCEPT                      # (b) internal ke internet
iptables -A FORWARD -s 10.82.0.0/16 -d 10.82.0.0/16 -j ACCEPT              # (c) antar-LAN

iptables -P INPUT DROP
iptables -P FORWARD DROP
```

Koneksi baru dari sisi NAT1 tidak cocok dengan rule mana pun, jadi jatuh ke policy `DROP` (counter
`policy DROP` di INPUT terlihat naik). Balasan dari internet tetap lolos lewat rule `ESTABLISHED,RELATED`.

![iptables -S Gendou](assets/soal5-gendou-iptables.png)
![Armisael ping 8.8.8.8](assets/soal5-armisael-ping.png)
![Counter](assets/soal5-gendou-counter.png)

Setelah pergantian container, [skrip pemulihan firewall](configs/router/soal5-gendou.sh)
dipasang di `/root/soal5-gendou.sh`. Skrip menerapkan kembali policy `INPUT DROP` dan
`FORWARD DROP`. Izin dengan sumber jaringan internal dicocokkan pada interface selain WAN.
Aturan `MASQUERADE` yang ada cocok saat dibandingkan sebelum dan sesudah pemulihan.

| Uji ulang | Hasil yang tercatat |
|:---|:---|
| Lilith → `8.8.8.8` | 2/2 balasan ping |
| Lilith → Gendou (`10.82.4.109`) | 2/2 balasan ping |
| Lilith → Tokyo3-Core TCP `8080` | Pesan `soal5-lilith-ke-tokyo` muncul di log TCP |
| Koneksi baru dari sisi WAN dalam namespace terisolasi | Timeout untuk trafik ke Gendou dan trafik yang hendak diteruskan. Counter `DROP` masing-masing mencatat 2 paket. |

---

## Soal 6 — IP statis permanen

IP disimpan di `/etc/network/interfaces` (sama dengan *Edit network configuration* di GNS3) dan dijalankan
oleh `ifup -a` saat container start, jadi bertahan setelah restart. Contoh Unit-01:

```
auto eth0
iface eth0 inet static
	address 10.82.4.66
	netmask 255.255.255.248
	gateway 10.82.4.65
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### Cabang kiri dan atas

| Node | Switch | IP | Netmask | Gateway |
|:---|:---|:---|:---|:---|
| Quarters | Switch-Quarters | 10.82.0.2 | 255.255.254.0 | 10.82.0.1 |
| Comm-Net | Switch-Comm | 10.82.2.2 | 255.255.255.0 | 10.82.2.1 |
| Hangar-Crew | Switch-Hangar | 10.82.3.2 | 255.255.255.128 | 10.82.3.1 |
| Sachiel | Switch-Bunker | 10.82.3.130 | 255.255.255.192 | 10.82.3.129 |
| Relay-Node | Switch-Relay | 10.82.3.226 | 255.255.255.224 | 10.82.3.225 |
| Garden-Staff | Switch-Garden | 10.82.4.2 | 255.255.255.224 | 10.82.4.1 |
| Dock-Crew | Switch-Dock | 10.82.4.34 | 255.255.255.240 | 10.82.4.33 |
| Entry-Plug | Switch-Lab | 10.82.4.50 | 255.255.255.248 | 10.82.4.49 |
| Dummy-Plug | Switch-Lab | 10.82.4.51 | 255.255.255.248 | 10.82.4.49 |
| Archieve-Vault | Switch-Archive | 10.82.4.98 | 255.255.255.252 | 10.82.4.97 |
| Spy | Switch-Intel | 10.82.4.102 | 255.255.255.252 | 10.82.4.101 |
| Unit-01 | Switch-Cage | 10.82.4.66 | 255.255.255.248 | 10.82.4.65 |
| Unit-02 | Switch-Cage | 10.82.4.67 | 255.255.255.248 | 10.82.4.65 |
| Unit-00 | Switch-Cage | 10.82.4.68 | 255.255.255.248 | 10.82.4.65 |

Unit-01 di-restart (stop lalu start). `ELAPSED` PID 1 menunjukkan container baru saja menyala, tetapi IP dan
gateway tetap terpasang dan ping ke gateway berhasil:

![Unit-01 setelah restart](assets/soal6-unit01.png)

### Cabang kanan dan tengah

Koneksi `eth0` pada 11 host sudah cocok dengan topologi GNS3. Berkas di bawah disiapkan
untuk `/etc/network/interfaces` sesuai spreadsheet VLSM.

| Node | Switch | IP | Netmask | Gateway |
|:---|:---|:---|:---|:---|
| [Pen-Pen](configs/host/Pen-Pen.interfaces) | Switch-Medic | 10.82.3.194 | 255.255.255.224 | 10.82.3.193 |
| [Medic-Bay](configs/host/Medic-Bay.interfaces) | Switch-Medic | 10.82.3.195 | 255.255.255.224 | 10.82.3.193 |
| [Magi-casper](configs/host/Magi-casper.interfaces) | Switch-Terminal | 10.82.4.58 | 255.255.255.248 | 10.82.4.57 |
| [Magi-Balthasar](configs/host/Magi-Balthasar.interfaces) | Switch-Terminal | 10.82.4.59 | 255.255.255.248 | 10.82.4.57 |
| [Magi-Melchior](configs/host/Magi-Melchior.interfaces) | Switch-Terminal | 10.82.4.60 | 255.255.255.248 | 10.82.4.57 |
| [Lilith](configs/host/Lilith.interfaces) | Switch-Dogma | 10.82.4.74 | 255.255.255.248 | 10.82.4.73 |
| [Adam](configs/host/Adam.interfaces) | Switch-Dogma | 10.82.4.75 | 255.255.255.248 | 10.82.4.73 |
| [Zeruel](configs/host/Zeruel.interfaces) | Switch-Monolith | 10.82.4.82 | 255.255.255.248 | 10.82.4.81 |
| [Armisael](configs/host/Armisael.interfaces) | Switch-Monolith | 10.82.4.83 | 255.255.255.248 | 10.82.4.81 |
| [Radar-Array](configs/host/Radar-Array.interfaces) | Switch-Radar | 10.82.4.90 | 255.255.255.248 | 10.82.4.89 |
| [Tokyo3-Core](configs/host/Tokyo3-Core.interfaces) | Switch-Cmd | 10.82.4.106 | 255.255.255.252 | 10.82.4.105 |

Konfigurasi 11 host disimpan melalui klien GNS3 Desktop saat masing-masing container berhenti.
Setiap file dibaca ulang dari controller dan dicocokkan dengan konfigurasi yang disiapkan.
Saat koneksi tulis terputus, hasil pembacaan ulang digunakan untuk menentukan apakah file sudah
tersimpan sebelum melanjutkan.

**Uji nyala Pen-Pen.** Sesudah node dinyalakan, `ip -br -4 addr show dev eth0` dan
`ip -4 route show default dev eth0` menghasilkan:

```text
eth0             UNKNOWN        10.82.3.194/27
default via 10.82.3.193
```

![Pen-Pen setelah restart](assets/soal6-pen-pen.png)

Pen-Pen dikembalikan ke kondisi berhenti setelah pengujian awal. Medic-Bay sempat gagal menyala
dengan HTTP `409` dan pesan Docker `404 No such container`. Container pengganti memakai konfigurasi
semula dan disambungkan kembali ke port 2 Switch-Medic. Setelah restart, `eth0` tetap memakai
`10.82.3.195/27` dan rute default tetap melalui `10.82.3.193`. Ping dari Medic-Bay ke gateway dan
ke Lilith (`10.82.4.74`) masing-masing menerima 2/2 balasan.

---

## Soal 7 — Layanan MAGI

Soal ini menyiapkan tiga node MAGI untuk menerima pesan TCP dari Lilith. [Skrip MAGI](configs/host/magi.sh)
memeriksa `iptables` dan `netcat-openbsd`, memasang paket jika diperlukan, lalu membuka listener sesuai
nama skrip di container. Opsi `-k` mempertahankan listener setelah satu sesi selesai. Pesan masuk
dicatat di `/var/log/magi-<port>.log`.

| Node | IP | Port TCP | Nama skrip di container |
|:---|:---|:---|:---|
| Magi-casper | `10.82.4.58` | `5000` | `/root/magi-casper.sh` |
| Magi-Balthasar | `10.82.4.59` | `5000`, `5001` | `/root/magi-balthasar.sh` |
| Magi-Melchior | `10.82.4.60` | `5000` | `/root/magi-melchior.sh` |

Ketiga node semula gagal menyala dengan HTTP `409` dan pesan Docker `404 No such container`.
Setiap container pengganti diuji nyala dan konfigurasi IP-nya dicocokkan sebelum node lama
dilepas. Casper, Balthasar, dan Melchior dikembalikan ke port 1, 2, dan 3 `Switch-Terminal`.
Topologi setelah pemulihan berisi 60 node dan 59 link. Keempat listener berhasil dibuka di GNS3.

Uji awal antar-node MAGI berhasil pada keempat port. Untuk uji antarsubnet, container Lilith, Toji,
dan Fuyutsuki yang juga mengalami `404 No such container` dipulihkan ke sambungan aslinya.
Skrip [Fuyutsuki](configs/router/fuyutsuki.sh) dan [Toji](configs/router/toji.sh) yang tersimpan
dijalankan kembali. Keduanya menunjukkan `net.ipv4.ip_forward = 1`. Rute dari Toji ke Terminal
melewati `10.82.4.153`, dan rute balik dari Fuyutsuki ke Dogma melewati `10.82.4.154`.

Lilith (`10.82.4.74/29`) mengirim empat pesan lewat gateway `10.82.4.73`. GNS3 menunjukkan
status `LISTEN` pada setiap port tujuan dan pesan berikut pada log penerima.

| Pengirim | Penerima | TCP | Pesan yang terlihat di log penerima |
|:---|:---|:---|:---|
| Lilith | Magi-casper | `5000` | `soal7-lilith-casper-5000` |
| Lilith | Magi-Balthasar | `5000` | `soal7-lilith-balthasar-5000` |
| Lilith | Magi-Balthasar | `5001` | `soal7-lilith-balthasar-5001` |
| Lilith | Magi-Melchior | `5000` | `soal7-lilith-melchior-5000` |

Contoh uji di console Lilith untuk Casper.

```bash
printf '%s\n' 'soal7-lilith-casper-5000' | nc.openbsd -N -w 3 10.82.4.58 5000
```

Periksa hasilnya di console Casper.

```bash
grep -Fx 'soal7-lilith-casper-5000' /var/log/magi-5000.log
```

![Lilith mengirim ke 4 port MAGI](assets/soal7-lilith-kirim.png)
![Listener dan log Magi-Balthasar](assets/soal7-magi-listen.png)

---

## Soal 8 — Layanan Pen-Pen dan Tokyo3-Core

[Skrip listener](configs/host/soal8-listener.sh) menggunakan `netcat-openbsd` untuk menerima
pesan TCP dan mencatatnya ke `/var/log/soal8-<port>.log`. Opsi `-k` menjaga listener tetap aktif
setelah koneksi ditutup. TCP `22` diharapkan menolak koneksi karena tidak ada layanan yang
mendengarkan pada port itu.

| Node | IP | Listener TCP | Skrip di container |
|:---|:---|:---|:---|
| Pen-Pen | `10.82.3.194/27` | `80` | `/root/pen-pen.sh` |
| Tokyo3-Core | `10.82.4.106/30` | `8080` | `/root/tokyo3-core.sh` |

Tokyo3-Core, Maya, dan Gendou semula gagal menyala dengan HTTP `409` dan pesan Docker
`404 No such container`. Setiap pengganti diuji nyala sebelum sambungannya dikembalikan ke port
semula. Topologi kembali terverifikasi dengan 60 node dan 59 link. Maya memakai skrip routing
yang tersimpan, sementara rute uji di Gendou memakai `eth1` ke Switch-Cmd dan `eth2` ke Fuyutsuki.

| Asal | Tujuan | TCP | Hasil aktual di GNS3 |
|:---|:---|:---|:---|
| Lilith | Pen-Pen | `80` | `LISTEN`. Pesan `soal8-lilith-pen-pen-80` muncul di `/var/log/soal8-80.log`. |
| Lilith | Tokyo3-Core | `8080` | `LISTEN`. Pesan `soal8-lilith-tokyo3-core-8080` muncul di `/var/log/soal8-8080.log`. |
| Lilith | Pen-Pen | `22` | `Connection refused`. |
| Lilith | Tokyo3-Core | `22` | `Connection refused`. |

Jalankan uji TCP dari console Lilith.

```bash
printf '%s\n' 'soal8-lilith-pen-pen-80' | nc.openbsd -N -w 3 10.82.3.194 80
printf '%s\n' 'soal8-lilith-tokyo3-core-8080' | nc.openbsd -N -w 3 10.82.4.106 8080
nc.openbsd -zvw 3 10.82.3.194 22
nc.openbsd -zvw 3 10.82.4.106 22
```

![Uji TCP dari Lilith ke Pen-Pen dan Tokyo3-Core](assets/soal8-lilith-uji.png)
![Listener dan log Pen-Pen](assets/soal8-pen-pen.png)
![Listener dan log Tokyo3-Core](assets/soal8-tokyo3-core.png)

---

## Soal 9 — Sabotase routing di Shigeru

`break_routing.sh` dijalankan langsung oleh praktikan di console Shigeru **tanpa membaca isinya**. Diagnosis
hanya dari gejala dan perbandingan state.

### Persiapan

1. Rule soal 18–19 di Shigeru dilepas sementara (`iptables -F INPUT/FORWARD/OUTPUT`), supaya Shigeru dalam
   kondisi soal 2–6 dan uji "Lilith ping Armisael" bermakna.
2. Kondisi normal dicatat: Lilith ping Armisael berhasil.

   ![Lilith ping Armisael sebelum sabotase](assets/soal9-lilith-sebelum.png)
3. Baseline Shigeru disimpan dengan `bash /root/snapshot.sh /root/baseline.txt`. Isinya: `ip -br link/addr`,
   semua tabel rute, `ip rule`, sysctl `ip_forward` / `rp_filter` / redirect / `proxy_arp` per interface,
   `tc qdisc`, `iptables -S` untuk tabel `raw`, `mangle`, `nat`, `filter`, `nft list ruleset`, dan `ip neigh`.

### Gejala

Setelah `break_routing.sh` dijalankan, Lilith tidak bisa lagi ping Armisael (100% loss):

![Lilith gagal ping Armisael](assets/soal9-lilith-gagal.png)

### Diagnosis

```bash
bash /root/snapshot.sh /root/after.txt
diff /root/baseline.txt /root/after.txt     # tanda < = baseline, > = sesudah sabotase
```

![Diff Shigeru](assets/soal9-shigeru-diff.png)
![Detail state Shigeru](assets/soal9-shigeru-detail.png)

Ada lima perubahan, semuanya di Shigeru:

| # | Perubahan | Akibat | Arah yang putus |
|---|---|---|---|
| 1 | `ip_forward` dan `conf.*.forwarding` jadi `0` | Shigeru berhenti meneruskan paket antar-interface | pergi dan balik |
| 2 | `ip rule` pref 90: `from all iif eth1 lookup 100`, tabel 100 hanya berisi `unreachable default` | semua paket yang masuk dari Monolith (`eth1`) dijawab *unreachable*, tidak pernah sampai ke tabel `main` | balik |
| 3 | `blackhole 10.82.4.72/29` di tabel `main` | paket menuju Switch-Dogma (subnet Lilith) dibuang | balik |
| 4 | default route pindah dari `via 10.82.4.133 dev eth0` (Gendou) ke `via 10.82.4.170 dev eth2` (Makoto) | Makoto juga ber-default ke Shigeru, jadi paket ke luar zona berputar Shigeru ↔ Makoto sampai TTL habis | balik (dan semua trafik keluar zona) |
| 5 | `net.ipv4.conf.all.accept_redirects` jadi `1` | tidak memutus ping, tetapi router jadi mau mengubah rutenya karena ICMP redirect dari luar | — (celah) |

**Arah pergi vs arah balik.** Request Lilith → Armisael masuk Shigeru lewat `eth0` lalu harus diteruskan
ke `eth1`. Arah ini hanya diputus oleh perubahan #1. Reply Armisael → Lilith masuk lewat `eth1`, dan arah ini
diputus tiga kali sekaligus. Pertama rule #2 membuatnya *unreachable*. Kalau rule itu dihapus, blackhole #3
membuangnya. Kalau blackhole juga dihapus, default #4 melemparnya ke Makoto yang mengembalikannya lagi ke
Shigeru.

Karena itu, menyalakan forwarding saja **belum cukup**. Pada percobaan ini forwarding sudah `1`, jalur pergi
sudah benar, tetapi `ip route get 10.82.4.74 from 10.82.4.83 iif eth1` masih `No route to host` dan ping
tetap gagal karena balasannya tidak bisa pulang:

![Forwarding dinyalakan](assets/soal9-fix1-forward.png)
![Lilith masih gagal](assets/soal9-lilith-masih-gagal.png)

### Perbaikan

Jalur balik dibersihkan, redirect dimatikan lagi, lalu `ip route get` untuk arah balik sudah keluar lewat
`eth0` ke Gendou:

![Rute dibersihkan](assets/soal9-fix2-route.png)

Lilith kembali bisa ping Armisael:

![Lilith ping Armisael sesudah perbaikan](assets/soal9-lilith-sesudah.png)

Perbaikan dimasukkan ke `/root/shigeru.sh` ([configs/router/shigeru.sh](configs/router/shigeru.sh)),
sehingga menjalankan ulang script langsung membersihkan sabotase yang sama:

```bash
sysctl -w net.ipv4.ip_forward=1                     # sekaligus forwarding semua interface
sysctl -w net.ipv4.conf.all.accept_redirects=0
while ip rule del lookup 100 2>/dev/null; do :; done
ip route flush table 100 2>/dev/null
ip route del blackhole 10.82.4.72/29 2>/dev/null
ip route replace default via 10.82.4.133 dev eth0
```

Setelah verifikasi, `bash /root/shigeru.sh` dijalankan penuh sehingga rule soal 18–19 terpasang lagi. Rute
dan sysctl sudah sama dengan baseline, dan tabel 100 kosong. Lilith → Armisael kembali tertutup, tetapi
sekarang karena isolasi soal 19 yang memang disengaja, bukan karena sabotase.

![State akhir Shigeru](assets/soal9-shigeru-final.png)

---

## Soal 10 — Sabotase NAT di Misato dan Gendou

Kondisi normal sebelum sabotase: Unit-01 (Cage) dan Spy (Intel) sama-sama bisa ping `8.8.8.8`.

![Unit-01 sebelum](assets/soal10-unit01-sebelum.png)
![Spy sebelum](assets/soal10-spy-sebelum.png)

Baseline Misato dan Gendou disimpan di `/root/baseline.txt` masing-masing (termasuk tabel `nat`, `mangle`,
`raw`). `break_nat.sh` lalu dijalankan praktikan di kedua node tanpa membaca isinya.

### Gejala

Counter NAT dan filter di Misato dan Gendou dinolkan (`iptables -Z`). Setelah itu Unit-01 gagal ke internet,
sedangkan Spy tetap normal:

![Unit-01 gagal](assets/soal10-unit01-gagal.png)
![Spy normal](assets/soal10-spy-normal.png)

### Diagnosis

Diff Misato hanya berisi satu rule baru di `nat POSTROUTING`. `172.31.99.1` bukan alamat Misato maupun
alamat mana pun di topologi:

```
-A POSTROUTING -s 10.82.4.64/29 ! -d 10.82.0.0/16 -o eth0 -j SNAT --to-source 172.31.99.1
```

![Diagnosis Misato](assets/soal10-misato-diag.png)

Diff Gendou berisi satu rule `RETURN` yang disisipkan **di atas** MASQUERADE (selain itu hanya counter):

```
-A POSTROUTING -s 10.82.4.64/29 -o eth0 -j RETURN
```

![Diagnosis Gendou](assets/soal10-gendou-diag.png)

**Siapa yang melakukan source NAT?** Hanya **Gendou**, lewat MASQUERADE di `eth0` (NAT1). Misato adalah
router ujung untuk Switch-Cage dan seharusnya tidak melakukan NAT sama sekali, karena tabel `nat`-nya di
baseline kosong. Counter setelah dinolkan membuktikannya:

| Counter | Nilai | Artinya |
|---|---|---|
| Misato `SNAT` | 1 paket | paket pertama ping Unit-01 diganti sumbernya jadi `172.31.99.1` (paket berikutnya ikut entri conntrack) |
| Gendou `FORWARD` policy DROP | 3 paket, 252 byte | ketiga ping Unit-01 (3 × 84 byte) ditolak firewall soal 5 karena sumber `172.31.99.1` tidak cocok `-s 10.82.0.0/16` |
| Gendou `RETURN` | 0 | paket Cage tidak pernah sampai di sini, sudah dibuang di FORWARD |
| Gendou `MASQUERADE` | 1 paket | ping Spy, diterjemahkan normal oleh Gendou |

**Kenapa Cage terdampak tapi Intel tidak?** Kedua rule sabotase hanya mencocokkan `-s 10.82.4.64/29`, yaitu
Switch-Cage (Unit-00/01/02) yang ada di belakang Misato. Switch-Intel (`10.82.4.100/30`, Spy) ada di belakang
Kaji, tidak melewati Misato, dan tidak cocok dengan rule `RETURN`, jadi tetap di-MASQUERADE Gendou seperti biasa.

Kedua sabotase **berdiri sendiri** dan harus diperbaiki semua:

- Kalau hanya Misato yang diperbaiki, paket Cage sampai di Gendou dengan sumber `10.82.4.66`, tetapi rule
  `RETURN` membuatnya keluar NAT1 **tanpa** diterjemahkan. NAT1 tidak tahu rute ke `10.82.x.x`, jadi balasan
  tidak kembali.
- Kalau hanya Gendou yang diperbaiki, sumber `172.31.99.1` tetap ditolak FORWARD Gendou. Kalaupun lolos,
  balasan ke `172.31.99.1` tidak punya jalan pulang.

### Perbaikan

`/root/misato.sh` ([configs/router/misato.sh](configs/router/misato.sh)) sekarang mengosongkan
`nat POSTROUTING`, karena Misato bukan titik NAT:

```bash
iptables -t nat -F POSTROUTING
```

`/root/gendou.sh` ([configs/router/gendou.sh](configs/router/gendou.sh)) memang sudah menulis ulang tabel
`nat` dari nol (`iptables -t nat -F`) sebelum memasang satu-satunya rule MASQUERADE, sehingga `RETURN`
sisipan ikut terbuang. Komentar di script mencatat bahwa tidak boleh ada pengecualian sebelum MASQUERADE.
Rule firewall soal 5 (policy DROP, aturan INPUT/FORWARD) tetap utuh:

![Misato diperbaiki](assets/soal10-misato-fix.png)
![Gendou diperbaiki, rule soal 5 utuh](assets/soal10-gendou-fix.png)

Unit-01 dan Spy sama-sama bisa ke internet lagi. MASQUERADE Gendou (counter baru di-reset oleh script)
sekarang menghitung paket keduanya, sedangkan `nat` Misato kosong:

![Unit-01 sesudah](assets/soal10-unit01-sesudah.png)
![Spy sesudah](assets/soal10-spy-sesudah.png)
![NAT Gendou sesudah](assets/soal10-gendou-nat-sesudah.png)
![NAT Misato sesudah](assets/soal10-misato-nat-sesudah.png)

---

## Soal 11 — Blokir ping masuk ke Magi-Casper

[Skrip Soal 11](configs/host/soal11-casper.sh) disimpan sebagai `/root/soal11-casper.sh` di Magi-Casper
(`10.82.4.58`). Skrip menambahkan aturan `DROP` untuk ICMP IPv4 `echo-request` pada `INPUT`.
Balasan `echo-reply` untuk ping yang dimulai Casper dan trafik TCP `5000` tetap diproses oleh
aturan yang sudah ada. Tabel `filter` awal dicadangkan di `/root/soal11-filter.before`.
Menjalankan skrip dua kali menghasilkan satu aturan untuk Soal 11.

Misato dan Unit-00 semula gagal menyala dengan `404 No such container`. Keduanya dipulihkan
ke port semula, dan rute uji antara Switch-Cage dan Switch-Terminal diperiksa sebelum penerapan.

| Asal | Tujuan | Trafik | Sebelum | Sesudah |
|:---|:---|:---|:---|:---|
| Lilith | Magi-Casper | Ping | 2/2 balasan | 0/2 balasan |
| Unit-00 | Magi-Casper | Ping | 2/2 balasan | 0/2 balasan |
| Lilith | Magi-Casper | TCP `5000` | Pesan tercatat | Pesan tercatat |
| Unit-00 | Magi-Casper | TCP `5000` | Pesan tercatat | Pesan tercatat |

Sesudah penerapan, ping dari Casper ke Lilith (`10.82.4.74`) dan Unit-00 (`10.82.4.68`)
masing-masing menerima 2/2 balasan. Counter aturan naik dari 0 menjadi **4 paket (336 byte)**.
Listener tetap berstatus `LISTEN` dan kedua pesan uji sesudah penerapan tercatat di Casper.

Perintah pemeriksaan di console Magi-Casper.

```bash
iptables -w 5 -L INPUT -n -v -x | grep -F soal11-casper-echo-request
grep -Fx 'soal11-lilith-sesudah-5000' /var/log/magi-5000.log
grep -Fx 'soal11-unit-00-sesudah-5000' /var/log/magi-5000.log
```

![Unit-00 ping ditolak namun TCP 5000 lolos](assets/soal11-unit00-uji.png)
![Magi-Casper tetap bisa ping keluar dan mencatat log](assets/soal11-casper-keluar.png)

---

## Soal 12 — Pemulihan firewall Magi-Casper

[Skrip pemulihan](configs/host/soal12-casper.sh) menjaga policy `INPUT DROP` dan memakai
chain `SOAL12_CASPER` untuk mengizinkan loopback, balasan `ESTABLISHED,RELATED`, serta koneksi
baru pada TCP `5000`. ICMP `echo-request` masuk dibuang sebelum aturan conntrack diperiksa.

Gangguan direproduksi dalam namespace jaringan terisolasi pada Magi-Casper di GNS3. Awalnya TCP
`5000` dan ping keluar berhasil. Setelah policy `INPUT` pada salinan diubah ke `DROP`, koneksi
TCP timeout dan ping keluar kehilangan semua balasan. Skrip memulihkan keduanya, mempertahankan
policy `DROP`, dan tetap membuang ping masuk. Dua kali eksekusi menghasilkan satu jump ke chain
pemulihan. Snapshot aturan dan rute aktif di luar namespace cocok sebelum dan sesudah uji.

File `/root/break_fw.sh` belum ditemukan. Reproduksi memakai perubahan policy langsung pada
salinan terisolasi. Konfigurasi akhir proyek diterapkan lewat `/root/soal12-casper.sh` dan diuji
ulang dengan trafik antarnode.

| Verifikasi di GNS3 | Hasil |
|:---|:---|
| Policy `INPUT` Magi-Casper | `DROP`, dengan satu jump ke `SOAL12_CASPER` |
| Unit-00 → Magi-Casper, TCP `5000` | Pesan `soal12-unit-00-casper-5000` tercatat di `/var/log/magi-5000.log` |
| Unit-00 → Magi-Casper, ping | 0/2 balasan. Counter `DROP` mencatat 2 paket. |
| Magi-Casper → Unit-00, ping | 2/2 balasan |

Uji ulang setelah reproduksi di GNS3 mencatat pesan `soal12-reverify-unit-casper` pada Casper.
Ping Unit-00 ke Casper mendapat 0/1 balasan dan arah sebaliknya mendapat 1/1 balasan.

![Aturan iptables dan counter SOAL12_CASPER](assets/soal12-casper-iptables.png)

---

## Soal 13 — Firewall Magi-Balthasar

[Skrip firewall](configs/host/soal13-balthasar.sh) disimpan di `/root/soal13-balthasar.sh`.
Chain `SOAL13_BALTHASAR` menerima seluruh trafik dari Casper (`10.82.4.58/32`). Pilot terdiri
dari Unit-01, Unit-02, Unit-00 (`10.82.4.66`–`10.82.4.68`), dan Sachiel (`10.82.3.130`).
Keempat alamat Pilot hanya diizinkan ke TCP `5000` dan `5001`.
TCP dari sumber lain ditolak dengan TCP reset. Trafik masuk lainnya dibuang. Balasan untuk
koneksi yang dimulai Balthasar diterima melalui pencocokan `ESTABLISHED,RELATED` arah `REPLY`.

Unit-01 dipulihkan ke port aslinya setelah kegagalan Docker `404 No such container`.
Gendou memperoleh kembali alamat WAN dari NAT1 dan aturan `MASQUERADE` untuk `10.82.0.0/16`
di `eth0`, sehingga jalur ping keluar tersedia untuk pengujian.

| Asal → tujuan | Trafik | Hasil aktual di GNS3 |
|:---|:---|:---|
| Casper → Balthasar | Ping, TCP `5000` dan `5001` | 2/2 balasan ping. Kedua pesan muncul di log MAGI. |
| Unit-01 → Balthasar | TCP `5000` dan `5001` | Kedua pesan muncul di log MAGI. |
| Unit-02 → Balthasar | TCP `5000` dan `5001` | `soal13-unit-02-5000` dan `soal13-unit-02-5001` muncul di log MAGI. |
| Sachiel → Balthasar | TCP `5000` dan `5001` | `soal13-sachiel-5000` dan `soal13-sachiel-5001` muncul di log MAGI. |
| Lilith → Balthasar | TCP `5000` dan `5001` | `Connection refused` pada kedua port. |
| Melchior → Balthasar | TCP `5000` dan `5001` | `Connection refused` pada kedua port. |
| Balthasar → `8.8.8.8` | Ping | 2/2 balasan sebelum dan sesudah penerapan. |

`Kensuke` (`10.82.4.158/30`, gateway `Switch-Bunker` `10.82.3.129/26`) beserta `Sachiel` (`10.82.3.130/26`) dan `Unit-02` (`10.82.4.67/29`) juga dipulihkan ke port masing-masing dengan rute `10.82.3.128/26` dan `10.82.4.156/30` di `Gendou` dan `Asuka`, sehingga akses pilot lintas subnet dari `Switch-Bunker` dan `Switch-Cage` ke `Magi-Balthasar` terverifikasi langsung di GNS3.

Pemeriksaan hasil di console Balthasar.

```bash
iptables -w 5 -L SOAL13_BALTHASAR -nvx
grep -Fx 'soal13-unit-01-5000' /var/log/magi-5000.log
grep -Fx 'soal13-unit-01-5001' /var/log/magi-5001.log
```

Counter penolakan TCP mencatat **4 paket (240 byte)** dari pengujian Lilith dan Melchior.
Aturan Sachiel dikonfirmasi di atas aturan penolakan pada chain aktif.

![Sachiel (Pilot) diizinkan ke TCP 5000 dan 5001](assets/soal13-pilot-lolos.png)
![Lilith (non-Pilot) ditolak ke TCP 5000 dan 5001](assets/soal13-nonpilot-tolak.png)
![Chain dan counter SOAL13_BALTHASAR serta log MAGI](assets/soal13-balthasar-iptables.png)

---

## Soal 14 — Jadwal akses Pen-Pen

[Skrip jadwal](configs/host/soal14-pen-pen.sh) disimpan sebagai `/root/soal14-pen-pen.sh`.
Pen-Pen (`10.82.3.194`) menerapkan jadwal ke ICMP `echo-request` dan TCP `80` melalui
chain `SOAL14_PENPEN`. Batas akhir jam bersifat eksklusif. Aturan `iptables -m time` memakai UTC.

| Kelompok | Sumber | Akses dalam WIB | Rentang aturan UTC |
|:---|:---|:---|:---|
| Pilot | Unit-00, Unit-01, Unit-02, Sachiel | Senin–Jumat 08.00–16.00 | 01:00:00–08:59:59 |
| Staf Geofront | Lilith, Adam | Setiap hari 17.00–23.00 | 10:00:00–15:59:59 |
| Terduga Dummy System | Entry-Plug, Dummy-Plug, Spy | Selalu ditolak | Semua waktu |
| Lainnya | Semua sumber lainnya | Selalu diterima | Semua waktu |

Kaji dan Spy dipulihkan ke port semula untuk uji dari Switch-Intel. Saat jam Pen-Pen
menunjukkan **23:45 WIB**, hasil pengujian GNS3 adalah sebagai berikut.

| Asal → Pen-Pen | Ping | TCP `80` |
|:---|:---|:---|
| Unit-01 (23:45 WIB) | 0/1 balasan | Timeout |
| Lilith (23:45 WIB) | 0/1 balasan | Timeout |
| Adam (14:46 WIB) | 0/2 balasan | Timeout |
| Spy | 0/1 balasan | Timeout |
| Entry-Plug | 0/2 balasan | Timeout |
| Magi-Casper | 1/1 balasan | Pesan `soal14-magi-casper` tercatat di `/var/log/soal8-80.log` |

`Adam` (`10.82.4.75/29`) dan `Entry-Plug` (`10.82.4.50/29`) dipulihkan ke port aslinya dan diuji langsung saat jam container `Pen-Pen` menunjukkan `14:46:02 WIB` (`07:46:02 UTC`, di luar rentang Staf Geofront `17.00–23.00 WIB`). Baik `Adam` maupun `Entry-Plug` (selalu ditolak) menerima 0/2 balasan ping dan timeout pada TCP `80`.

Uji tambahan mencakup 240 evaluasi dari aturan yang terbaca di GNS3 pada batas jam dan hari
kerja serta akhir pekan. Uji paket Netfilter dengan jendela waktu yang digeser di namespace
terisolasi mengonfirmasi Pilot dan Staf dapat mengakses pada jam buka, Pilot ditolak pada
akhir pekan, Spy tetap ditolak, dan kelompok lainnya tetap dapat mengakses.

![Entry-Plug ditolak oleh Pen-Pen](assets/soal14-entry-plug-tolak.png)
![Magi-Casper tetap diizinkan mengakses Pen-Pen](assets/soal14-casper-lolos.png)
![Jam sistem dan counter chain SOAL14_PENPEN](assets/soal14-pen-pen-iptables.png)

---

## Soal 15 — Pembatasan ping Tokyo3-Core

[Skrip pembatasan](configs/host/soal15-tokyo3-core.sh) disimpan di `/root/soal15-tokyo3-core.sh`.
Chain `SOAL15_ICMP` menerima ICMP IPv4 `echo-request` sampai rata-rata lima paket per detik
dengan kapasitas awal satu paket. Echo-request yang melebihi batas dibuang.

| Asal → tujuan | Pengujian | Hasil aktual di GNS3 |
|:---|:---|:---|
| Lilith → Tokyo3-Core | 20 ping dengan jeda 0,1 detik | 10/20 balasan. Counter `DROP` mencatat 10 paket. |
| Lilith → Tokyo3-Core | 3 ping dengan jeda 3 detik | 3/3 balasan. Counter `DROP` tetap 10 paket. |
| Lilith → Tokyo3-Core | TCP `8080` | Pesan `soal15-lilith-8080` tercatat di `/var/log/soal8-8080.log`. |

Counter akhir di Tokyo3-Core menunjukkan **13 paket diterima dan 10 paket dibuang**.

```bash
iptables -w 5 -L SOAL15_ICMP -nvx
```

![Uji rate-limit ping dari Lilith ke Tokyo3-Core](assets/soal15-lilith-ping.png)
![Counter chain SOAL15_ICMP di Tokyo3-Core](assets/soal15-tokyo3-counter.png)

---

## Soal 16 — Log koneksi Dummy-Plug

[Skrip Tokyo3-Core](configs/host/soal16-tokyo3-core.sh) mencatat paket SYN dari Dummy-Plug
(`10.82.4.51/32`) menuju TCP `22`, `23`, atau `3306` dengan prefix `SCAN-NERV`, lalu
mengirim TCP reset. NFLOG mengirim paket ke `ulogd` melalui grup `16016`. Hasilnya disimpan di
`/var/log/soal16-scan.log`. [Dokumentasi Netfilter](https://workshop.netfilter.org/2015/wiki/images/5/51/Netfilter-logging.pdf)

Skrip disimpan di `/root/soal16-tokyo3-core.sh` dan menyiapkan listener TCP `80` untuk uji ini.
Listener TCP `8080` dari Soal 8 juga digunakan. Dummy-Plug, Asuka, dan Ritsuko dipulihkan ke
port semula sebelum rute pergi-pulang antara Switch-Lab dan Switch-Cmd diverifikasi.

| Asal → Tokyo3-Core (`10.82.4.106`) | TCP | Hasil aktual di GNS3 |
|:---|:---|:---|
| Dummy-Plug | `22`, `23`, `3306` | Ketiga koneksi ditolak. Log memuat `SCAN-NERV`, `SRC=10.82.4.51`, dan ketiga nilai `DPT`. |
| Dummy-Plug | `80` | Pesan `soal16-dummy-80` tercatat di `/var/log/soal16-80.log`. |
| Dummy-Plug | `8080` | Pesan `soal16-dummy-8080` tercatat di `/var/log/soal8-8080.log`. |

Counter mencatat masing-masing tiga paket pada aturan NFLOG dan `REJECT`.

```bash
# Console Tokyo3-Core
grep -F 'SCAN-NERV' /var/log/soal16-scan.log
iptables -w 5 -L SOAL16_SCAN -nvx
```

![Dummy-Plug uji port terblokir vs port diizinkan](assets/soal16-dummy-plug.png)
![Counter SOAL16_SCAN dan log SCAN-NERV di Tokyo3-Core](assets/soal16-tokyo3-log.png)

---

## Soal 17 — DNAT Casper ke Pen-Pen

Fuyutsuki berada di antara Switch-Terminal dan Gendou. [Skrip DNAT](configs/router/soal17-fuyutsuki.sh)
memilih TCP `9000` yang masuk di `eth1` dari Casper (`10.82.4.58`) ke Zeruel (`10.82.4.82`),
lalu mengubah tujuan menjadi Pen-Pen (`10.82.3.194:9000`). [Skrip listener](configs/host/soal17-pen-pen.sh)
menyimpan pesan di `/var/log/soal17-9000.log`. Keduanya disimpan di `/root` pada node masing-masing.
Balasan Pen-Pen kembali melalui Maya dan Fuyutsuki, lalu conntrack mengembalikan IP sumber balasan
menjadi IP Zeruel.

Shigeru dan Zeruel dipulihkan ke port semula dan jalur ICMP melalui Gendou diverifikasi sebelum uji.

| Pengujian | Hasil aktual di GNS3 |
|:---|:---|
| Ping Casper → Zeruel | 2/2 balasan. Capture pada Zeruel memuat dua ICMP echo-request. |
| TCP Casper → `10.82.4.82:9000` | Terhubung. Capture di Casper menunjukkan SYN-ACK dari `10.82.4.82:9000`. |
| Log dan capture di penerima | Pen-Pen mencatat `soal17-casper-via-zeruel`. Capture Zeruel tidak memuat TCP `9000` pada uji itu. |
| Counter DNAT di Fuyutsuki | Naik dari 0 menjadi **1 paket (60 byte)**. |

```bash
# Console Fuyutsuki
iptables -w 5 -t nat -L PREROUTING -nvx | grep -F soal17-casper-zeruel
```

![Magi-Casper mengirim TCP 9000 ke IP Zeruel](assets/soal17-casper-kirim.png)
![Counter DNAT PREROUTING di Fuyutsuki](assets/soal17-fuyutsuki-dnat.png)
![Listener dan log TCP 9000 di Pen-Pen](assets/soal17-pen-pen-log.png)

---

## Soal 18 — Gerbang Monolith dan Radar (Shigeru)

Zona sensitif berada di belakang Shigeru: Switch-Monolith (`eth1`) dan Switch-Radar (lewat `eth2` → Makoto).
Semua trafik dari luar zona pasti masuk Shigeru lewat **`eth0`** (sisi yang menghadap Gendou), jadi
penyaringan cukup berdasarkan interface masuk, tanpa menulis daftar subnet luar. Subnet baru apa pun
otomatis ikut terblokir.

```bash
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT                    # balasan untuk koneksi dari dalam zona
iptables -A FORWARD -i eth0 -s 10.82.4.56/29 -p icmp --icmp-type echo-request -j ACCEPT     # pengecualian: ping dari Terminal
iptables -A FORWARD -i eth0 -m conntrack --ctstate NEW -j DROP                             # koneksi baru dari luar ditolak
```

Koneksi yang dimulai dari dalam zona keluar lewat `eth0` (bukan masuk), jadi tidak kena rule DROP, dan
balasannya lolos lewat `ESTABLISHED,RELATED`.

Ping Casper (Terminal) ke Zeruel berhasil:

![Casper ke Zeruel](assets/soal18-casper-ping-zeruel.png)

Ping (dan TCP) Lilith ke Zeruel gagal:

![Lilith ke Zeruel](assets/soal18-lilith-ping-zeruel.png)

Dari dalam zona tetap bebas keluar:

![Zeruel keluar](assets/soal18-zeruel-keluar.png)
![iptables Shigeru](assets/soal18-shigeru-iptables.png)

Untuk pemulihan setelah penggantian container, [skrip Soal 18](configs/router/soal18-shigeru.sh)
disimpan sebagai `/root/soal18-shigeru.sh`. Chain `SOAL18_GERBANG` dipanggil untuk trafik yang
masuk dari `eth0`. Chain menerima balasan koneksi arah `REPLY`, menerima ICMP `echo-request`
dari Terminal, dan membuang trafik masuk lainnya. Makoto dan Radar-Array dipulihkan ke port semula.

| Uji ulang di GNS3 | Monolith (Zeruel) | Radar (Radar-Array) |
|:---|:---|:---|
| Casper → zona, ping | 2/2 balasan | 2/2 balasan |
| Lilith → zona, ping | 0/2 balasan | 0/2 balasan |
| Lilith → zona, TCP `9000` | Timeout | Timeout |
| Trafik dari dalam zona | Tokyo3-Core mencatat `soal18-monolith-tokyo` pada TCP `8080`. | Ping ke Lilith mendapat 2/2 balasan. |

Counter Shigeru mencatat 5 paket balasan, 4 echo-request dari Terminal, dan 8 paket dibuang.

---

## Soal 19 — Isolasi Armisael

Tidak ada satu pun rule yang dipasang di Armisael. Isolasi dikerjakan di dua titik:

1. **Shigeru** (`/root/shigeru.sh`). Semua trafik Armisael ke gateway, ke luar switch, dan ke internet
   melewati Shigeru. Rule diletakkan **paling atas**, di atas `ESTABLISHED,RELATED` dan pengecualian ping
   Terminal, supaya tidak ada celah. Pencocokan memakai IP dan MAC Armisael, jadi mengganti IP pun tetap
   terblokir.

   ```bash
   iptables -A INPUT   -s 10.82.4.83 -j DROP
   iptables -A INPUT   -m mac --mac-source 02:42:e4:de:74:00 -j DROP
   iptables -A OUTPUT  -d 10.82.4.83 -j DROP
   iptables -A FORWARD -s 10.82.4.83 -j DROP
   iptables -A FORWARD -d 10.82.4.83 -j DROP
   iptables -A FORWARD -m mac --mac-source 02:42:e4:de:74:00 -j DROP
   ```

2. **Zeruel** (`/root/zeruel.sh`). Armisael dan Zeruel berada di switch yang sama, jadi trafik di antara
   keduanya hanya lewat switch dan **tidak pernah melewati Shigeru**. Blokirnya dipasang di sisi Zeruel dan
   hanya menyasar Armisael, sehingga koneksi Zeruel ke tujuan lain tidak terganggu. Script ini tidak mem-flush
   iptables Zeruel; script hanya menghapus lalu memasang ulang rule miliknya sendiri.

   ```bash
   iptables -I INPUT 1  -s 10.82.4.83 -j DROP
   iptables -I INPUT 2  -m mac --mac-source 02:42:e4:de:74:00 -j DROP
   iptables -I OUTPUT 1 -d 10.82.4.83 -j DROP
   ```

Listener `nc -lk 9000 > /tmp/nc9000.log &` dinyalakan di Zeruel dan Lilith. Uji ke Seele memakai TCP 53.

Dari Armisael, semua ping dan nc gagal (Seele, Zeruel, Lilith, bahkan gateway `10.82.4.81`):

![Armisael terisolasi](assets/soal19-armisael.png)

Dari Zeruel, ping dan nc ke Seele dan Lilith berhasil (dan Zeruel juga tidak bisa menjangkau Armisael):

![Zeruel normal](assets/soal19-zeruel.png)

Log listener Lilith hanya menerima pesan dari Zeruel, tidak ada pesan dari Armisael:

![Log Lilith](assets/soal19-lilith-log.png)
![Counter Shigeru](assets/soal19-shigeru-counter.png)

**Pemulihan container Armisael.** Container pengganti `Armisael` memakai alamat MAC aktif `02:42:fa:6a:2a:00` pada `10.82.4.83/29`. [Skrip isolasi Soal 19](configs/router/soal19-isolasi.sh) dipasang sebagai `/root/soal19-isolasi.sh` pada `Shigeru` dan `Zeruel`, dan nilai `ARMISAEL_MAC` pada [shigeru.sh](configs/router/shigeru.sh) serta [zeruel.sh](configs/host/zeruel.sh) disinkronkan ke `02:42:fa:6a:2a:00`.

| Pengujian pasca-pemulihan | Sebelum isolasi | Sesudah isolasi |
|:---|:---|:---|
| Armisael → `10.82.4.81`, `10.82.4.82`, `10.82.4.74`, `8.8.8.8` (ping) | 1/1 balasan di keempat tujuan | 0/1 balasan di keempat tujuan (100% loss) |
| Armisael → `10.82.4.82:9000`, `10.82.4.74:9000`, `8.8.8.8:53` (TCP) | Terhubung di ketiga tujuan | Timeout di ketiga tujuan; pesan ke Lilith tidak masuk log |
| Zeruel → Lilith (`10.82.4.74`) & `8.8.8.8` | — | 2/2 balasan ping, TCP `53` terhubung, `soal19-zeruel-di-lilith` tercatat di Lilith |
| Zeruel → Armisael (`10.82.4.83`) | — | 0/1 balasan ping |
| Magi-Casper → Zeruel / Armisael | — | 1/1 balasan ke Zeruel, 0/1 balasan ke Armisael |

Counter aturan `soal19-armisael` mencatat kecocokan MAC `02:42:fa:6a:2a:00` pada `Shigeru` (`INPUT` 1 paket / 84 byte, `FORWARD` 6 paket / 408 byte, plus 1 paket / 84 byte tujuan `10.82.4.83`) dan `Zeruel` (`INPUT` 3 paket / 204 byte, `OUTPUT` 1 paket / 84 byte tujuan `10.82.4.83`).

---

## Soal 20 — Cadangan dan pemulihan GNS3

[Skrip cadangan](scripts/soal20-backup.sh) disimpan sebagai `/root/soal20-backup.sh` pada Fuyutsuki,
Pen-Pen, dan Tokyo3-Core. Direktori `/root/soal20-backup` berisi hasil `iptables-save`, tabel
rute IPv4 utama, alamat interface, status penerusan IPv4, dan checksum SHA-256.

Pengujian GNS3 memuat salinan state ke namespace jaringan terisolasi pada setiap node, mereset
aturan dan rute salinan, lalu memulihkannya dengan `iptables-restore` dan `ip route replace`.
Aturan, policy, dan rute hasil pulih dibandingkan dengan cadangan. Counter paket dikecualikan
dari perbandingan aturan. Verifikasi ulang setelah pemulihan node Soal 5–19 memastikan state aktif
ketiga node masih cocok dengan cadangan masing-masing.

| Node | Aturan dan rute sebelum reset | Sesudah reset | Sesudah pemulihan |
|:---|:---|:---|:---|
| Fuyutsuki (router) | 1 aturan, 7 rute | 0 aturan, 0 rute | 1 aturan, 7 rute, cocok dengan cadangan |
| Pen-Pen | 18 aturan, 2 rute | 0 aturan, 0 rute | 18 aturan, 2 rute, cocok dengan cadangan |
| Tokyo3-Core | 6 aturan, 2 rute | 0 aturan, 0 rute | 6 aturan, 2 rute, cocok dengan cadangan |

```bash
# Jalankan pada masing-masing node. Perintah backup membuat direktori baru.
/root/soal20-backup.sh backup /root/soal20-backup
/root/soal20-backup.sh verify /root/soal20-backup
```

![Verifikasi cadangan Soal 20 di Fuyutsuki](assets/soal20-fuyutsuki.png)
![Verifikasi cadangan Soal 20 di Pen-Pen](assets/soal20-pen-pen.png)
![Verifikasi cadangan Soal 20 di Tokyo3-Core](assets/soal20-tokyo3-core.png)

Sesudah uji namespace terisolasi awal, state aktif pada ketiga node masih cocok dengan cadangan. Pesan
`soal20-casper-pen-pen` diterima Pen-Pen pada TCP `80`, dan `soal20-lilith-tokyo` diterima Tokyo3-Core
pada TCP `8080`.

[Unduh ekspor portabel K-37-MODUL-5](K-37-MODUL-5.gns3project). Arsip final (`221.390` byte) terverifikasi
memuat **60 node, 59 link**, skrip konfigurasi persisten tiap tahap, serta ketiga cadangan Soal 20. Riwayat
shell (35 berkas `.bash_history`) dipisahkan ke arsip privat sehingga salinan untuk GitHub hanya memuat
konfigurasi yang diperlukan untuk praktikum.

Sesudah ekspor final, seluruh **29 node Docker** (11 router: Gendou, Fuyutsuki, Toji, Maya, Misato, Kaji,
Asuka, Ritsuko, Shigeru, Makoto, Kensuke; dan 18 host: Magi-casper, Magi-Balthasar, Magi-Melchior, Pen-Pen,
Tokyo3-Core, Lilith, Unit-00, Unit-01, Unit-02, Spy, Dummy-Plug, Zeruel, Medic-Bay, Radar-Array, Armisael,
Sachiel, Adam, Entry-Plug) dinyalakan kembali secara berurutan dan dicocokkan dengan checkpoint alamat,
rute, aturan firewall, sysctl, dan listener. Smoke test ujung ke ujung pasca-pemulihan lulus untuk:

- **Soal 5**: Policy `INPUT`/`FORWARD` `DROP` pada `Gendou` aktif; `Lilith → 8.8.8.8` menerima 2/2 balasan ping.
- **Soal 7–8 & 12**: `Unit-00 → Magi-casper` TCP `5000` tercatat (`final-smoke-unit-casper`) sementara ping ditolak (0/2 balasan).
- **Soal 13**: `Sachiel` dan `Unit-02` terhubung ke `Magi-Balthasar` TCP `5000` dan `5001` (`final-smoke-sachiel-*`, `final-smoke-unit02-*`), sedangkan `Lilith → Magi-Balthasar:5000` ditolak (`Connection refused`).
- **Soal 14**: `Entry-Plug → Pen-Pen` ditolak (0/2 ping, TCP `80` timeout), sedangkan `Magi-casper → Pen-Pen:80` tercatat (`final-smoke-casper-pen-pen`).
- **Soal 15–16**: `Lilith → Tokyo3-Core:8080` tercatat (`final-smoke-lilith-tokyo`); `Dummy-Plug → Tokyo3-Core:22` ditolak (`Connection refused`) dan tercatat di `/var/log/soal16-scan.log` dengan prefix `SCAN-NERV`.
- **Soal 17**: `Magi-casper → 10.82.4.82:9000` dialihkan Fuyutsuki ke `Pen-Pen` (`/var/log/soal17-9000.log` mencatat `final-smoke-casper-dnat`).
- **Soal 18–19**: `Magi-casper → Zeruel` menerima 2/2 balasan ping, `Lilith → Zeruel` menerima 0/2 balasan, `Armisael` menerima 0/1 balasan ke gateway, `Zeruel`, `Lilith`, dan `8.8.8.8`, sedangkan `Zeruel → Lilith` menerima 2/2 balasan.

```text
SHA-256  b45717c2a5248490d332a303ea2a0d34a87bfc866dfe99a09d9d1f5afb84e8e4
```
