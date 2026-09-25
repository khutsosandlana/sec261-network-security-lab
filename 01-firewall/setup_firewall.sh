#!/usr/bin/env bash
# Stateful iptables Perimeter Defense Script
set -euo pipefail

IFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)

if [ -z "$IFACE" ]; then
    echo "[-] Error: Unable to detect default network interface."
    exit 1
fi

echo "[*] Applying stateful firewall rules on interface: ${IFACE}"

iptables -F
iptables -X
iptables -Z

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp -i "$IFACE" --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp -i "$IFACE" --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 4 -j ACCEPT

iptables -N LOG_AND_DROP
iptables -A LOG_AND_DROP -m limit --limit 5/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
iptables -A LOG_AND_DROP -j DROP

iptables -A INPUT -j LOG_AND_DROP

echo "[+] Stateful firewall baseline applied successfully."
iptables -L -v -n --line-numbers
