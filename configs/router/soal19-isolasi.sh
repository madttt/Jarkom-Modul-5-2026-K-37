#!/bin/sh
set -eu

role=${1:?Gunakan shigeru atau zeruel}
mac=${2:?MAC aktif Armisael diperlukan}
case "$role" in
    shigeru|zeruel) ;;
    *) printf '%s\n' 'Jalankan skrip pada Shigeru atau Zeruel.' >&2; exit 1 ;;
esac
printf '%s\n' "$mac" | grep -Eiq '^([0-9a-f]{2}:){5}[0-9a-f]{2}$'
test "$(hostname | tr '[:upper:]' '[:lower:]')" = "$role"

armisael=10.82.4.83/32
tag=soal19-armisael

deny() {
    chain=$1
    shift
    set -- "$@" -m comment --comment "$tag" -j DROP
    if ! iptables -w 5 -C "$chain" "$@" 2>/dev/null; then
        iptables -w 5 -I "$chain" 1 "$@"
    fi
}

deny INPUT -s "$armisael"
deny INPUT -m mac --mac-source "$mac"
deny OUTPUT -d "$armisael"

if [ "$role" = shigeru ]; then
    # Aturan isolasi harus diperiksa sebelum chain gerbang Soal 18.
    deny FORWARD -s "$armisael"
    deny FORWARD -d "$armisael"
    deny FORWARD -m mac --mac-source "$mac"
fi
