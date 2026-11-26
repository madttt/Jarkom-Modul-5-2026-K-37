#!/bin/sh
set -eu

case ${0##*/} in
    magi-casper.sh|magi-melchior.sh) ports=5000 ;;
    magi-balthasar.sh) ports='5000 5001' ;;
    *) printf '%s\n' 'Simpan skrip dengan nama node MAGI.' >&2; exit 1 ;;
esac

if ! command -v iptables >/dev/null || ! command -v nc.openbsd >/dev/null; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get -o Acquire::Retries=0 -o Acquire::http::Timeout=15 update
    apt-get -o Acquire::Retries=0 -o Acquire::http::Timeout=15 \
        install -y --no-install-recommends iptables netcat-openbsd
fi

netcat=$(command -v nc.openbsd)
for port in $ports; do
    pidfile=/run/magi-$port.pid
    log=/var/log/magi-$port.log
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
                    continue
                fi
                ;;
        esac
    fi

    if [ -n "$(ss -H -ltn "sport = :$port")" ]; then
        printf 'TCP %s sudah dipakai proses lain.\n' "$port" >&2
        exit 1
    fi

    # Tetap terima koneksi berikutnya setelah pengirim menutup sesi TCP.
    nohup "$netcat" -d -k -l "$port" </dev/null >> "$log" 2>&1 &
    pid=$!
    printf '%s\n' "$pid" > "$pidfile"
    sleep 1
    if ! kill -0 "$pid" 2>/dev/null || [ -z "$(ss -H -ltn "sport = :$port")" ]; then
        printf 'Listener TCP %s gagal dibuka. Cek %s.\n' "$port" "$log" >&2
        exit 1
    fi
    printf 'Listener TCP %s aktif. Log: %s\n' "$port" "$log"
done
