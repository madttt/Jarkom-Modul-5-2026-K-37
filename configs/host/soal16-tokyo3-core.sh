#!/bin/sh
set -eu

if ! command -v ulogd >/dev/null; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get -o Acquire::Retries=0 -o Acquire::http::Timeout=15 update
    apt-get -o Acquire::Retries=0 -o Acquire::http::Timeout=15 install -y --no-install-recommends ulogd2
fi

conf=/root/soal16-ulogd.conf
pidfile=/run/soal16-ulogd.pid
plugin=$(find /usr/lib -name ulogd_inppkt_NFLOG.so -print -quit)
test -n "$plugin"
plugins=${plugin%/*}
umask 077
staged=$(mktemp /root/.soal16-ulogd.XXXXXX)
trap 'rm -f "$staged"' EXIT
cat > "$staged" <<EOF
[global]
logfile="/var/log/soal16-ulogd.log"
plugin="$plugins/ulogd_inppkt_NFLOG.so"
plugin="$plugins/ulogd_raw2packet_BASE.so"
plugin="$plugins/ulogd_filter_IFINDEX.so"
plugin="$plugins/ulogd_filter_IP2STR.so"
plugin="$plugins/ulogd_filter_PRINTPKT.so"
plugin="$plugins/ulogd_output_LOGEMU.so"
stack=scan:NFLOG,base:BASE,iface:IFINDEX,addr:IP2STR,pkt:PRINTPKT,file:LOGEMU

[scan]
group=16016

[file]
file="/var/log/soal16-scan.log"
sync=1
EOF
if [ -e "$conf" ]; then
    cmp "$staged" "$conf"
else
    install -m 600 "$staged" "$conf"
fi

if ! [ -s "$pidfile" ] || ! ps -p "$(cat "$pidfile")" -o args= | grep -Fq "$conf"; then
    ulogd -d -c "$conf" -p "$pidfile"
    sleep 1
    ps -p "$(cat "$pidfile")" -o args= | grep -Fq "$conf"
fi

if [ -z "$(ss -H -ltn 'sport = :80')" ]; then
    nohup nc.openbsd -d -k -l 80 </dev/null >> /var/log/soal16-80.log 2>&1 &
    sleep 1
    test -n "$(ss -H -ltn 'sport = :80')"
fi

chain=SOAL16_SCAN
if ! iptables -w 5 -S "$chain" >/dev/null 2>&1; then
    iptables -w 5 -N "$chain"
fi

ensure() {
    if ! iptables -w 5 -C "$chain" "$@" 2>/dev/null; then
        iptables -w 5 -A "$chain" "$@"
    fi
}

ensure -j NFLOG --nflog-prefix 'SCAN-NERV ' --nflog-group 16016 --nflog-threshold 1
ensure -p tcp -j REJECT --reject-with tcp-reset

set -- -s 10.82.4.51/32 -p tcp --syn -m multiport --dports 22,23,3306 -j "$chain"
if ! iptables -w 5 -C INPUT "$@" 2>/dev/null; then
    iptables -w 5 -I INPUT 1 "$@"
fi
