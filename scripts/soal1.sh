#!/bin/bash
# Soal 1 - VLSM. Tidak ada yang dijalankan di node, cukup hitung prefix.
# Pakai: bash soal1.sh <kebutuhan IP>   contoh: bash soal1.sh 27  ->  /27 (30 usable)
n=${1:?kebutuhan IP (host + 1 gateway)}
p=32; while (( (1 << (32 - p)) - 2 < n )); do ((p--)); done
echo "butuh $n IP -> /$p ($(( (1 << (32 - p)) - 2 )) usable, sisa $(( (1 << (32 - p)) - 2 - n )))"
