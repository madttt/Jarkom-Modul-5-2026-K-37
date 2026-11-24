#!/bin/bash
# Catat state jaringan node ke file (default /root/baseline.txt) untuk dibandingkan
# sebelum dan sesudah sabotase. Pemakaian: bash /root/snapshot.sh /root/after.txt
OUT=${1:-/root/baseline.txt}
{
echo "## ip -br link";        ip -br link
echo "## ip -br addr";        ip -br addr
echo "## ip route (semua tabel, tanpa local/broadcast)"
ip route show table all | grep -vE '^(local|broadcast|multicast)|fe80|ff00|::1'
echo "## ip rule";            ip rule
echo "## sysctl";             sysctl -a 2>/dev/null | grep -E 'net\.ipv4\.(ip_forward|conf\.(all|default|eth[0-9])\.(rp_filter|forwarding|arp_ignore|arp_filter|proxy_arp|accept_local|send_redirects|accept_redirects|disable_xfrm|log_martians))' | sort
echo "## tc qdisc";           tc qdisc show 2>/dev/null
for t in raw mangle nat filter; do echo "## iptables -t $t -S"; iptables -t $t -S; done
echo "## nft list ruleset";   nft list ruleset 2>/dev/null | grep -v '^\s*#'
echo "## ip neigh";           ip neigh show
} > "$OUT" 2>&1
echo "snapshot -> $OUT ($(wc -l < "$OUT") baris)"
