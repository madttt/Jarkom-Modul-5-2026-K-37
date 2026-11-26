#!/bin/sh
set -eu

case ${0##*/} in
    pen-pen.sh) port=80 ;;
    tokyo3-core.sh) port=8080 ;;
    *) printf '%s\n' 'Simpan skrip sebagai pen-pen.sh atau tokyo3-core.sh.' >&2; exit 1 ;;
esac

if ! command -v nc.openbsd >/dev/null; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get -o Acquire::Retries=0 -o Acquire::http::Timeout=15 update
    apt-get -o Acquire::Retries=0 -o Acquire::http::Timeout=15 \
        install -y --no-install-recommends netcat-openbsd
fi

netcat=$(command -v nc.openbsd)
pidfile=/run/soal8-$port.pid
log=/var/log/soal8-$port.log
expected=$(printf '%s\n' "$netcat" -d -k -l "$port")

if [ -r "$pidfile" ]; then
    read -r pid < "$pidfile" || pid=
    case $pid in
        ''|*[!0-9]*) ;;
        *)
            if [ -r "/proc/$pid/cmdline" ] &&
                [ "$(tr '\000' '\n' < "/proc/$pid/cmdline")" = "$expected" ] &&
                [ -n "$(ss -H -ltn "sport = :$port")" ]; then
                printf 'Listener TCP %s sudah berjalan.\n' "$port"
                exit 0
            fi
            ;;
    esac
fi

if [ -n "$(ss -H -ltn "sport = :$port")" ]; then
    printf 'TCP %s sudah dipakai proses lain.\n' "$port" >&2
    exit 1
fi

# Dengarkan lagi setelah pengirim menutup koneksi dan catat pesan dari setiap sesi.
nohup "$netcat" -d -k -l "$port" </dev/null >> "$log" 2>&1 &
pid=$!
printf '%s\n' "$pid" > "$pidfile"
sleep 1
if ! kill -0 "$pid" 2>/dev/null || [ -z "$(ss -H -ltn "sport = :$port")" ]; then
    printf 'Listener TCP %s gagal dibuka. Cek %s.\n' "$port" "$log" >&2
    exit 1
fi
printf 'Listener TCP %s aktif. Log %s.\n' "$port" "$log"
