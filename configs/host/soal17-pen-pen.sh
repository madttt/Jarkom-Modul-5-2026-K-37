#!/bin/sh
set -eu

netcat=$(command -v nc.openbsd)
pidfile=/run/soal17-9000.pid
log=/var/log/soal17-9000.log
expected=$(printf '%s\n' "$netcat" -d -k -l 9000)
if [ -r "$pidfile" ]; then
    read -r pid < "$pidfile" || pid=
    case $pid in
        ''|*[!0-9]*) ;;
        *)
            if [ -r "/proc/$pid/cmdline" ] &&
                [ "$(tr '\000' '\n' < "/proc/$pid/cmdline")" = "$expected" ] &&
                [ -n "$(ss -H -ltn 'sport = :9000')" ]; then
                exit 0
            fi
            ;;
    esac
fi

if [ -n "$(ss -H -ltn 'sport = :9000')" ]; then
    printf '%s\n' 'TCP 9000 sudah dipakai proses lain.' >&2
    exit 1
fi
nohup "$netcat" -d -k -l 9000 </dev/null >> "$log" 2>&1 &
printf '%s\n' "$!" > "$pidfile"
sleep 1
test -n "$(ss -H -ltn 'sport = :9000')"
