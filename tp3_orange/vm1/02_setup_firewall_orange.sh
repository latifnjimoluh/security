#!/bin/bash
# Configuration ULTIME du Pare-feu Orange Cameroun
if [[ $EUID -ne 0 ]]; then echo "Lancer avec sudo."; exit 1; fi

cat << 'EOF' > /etc/nftables.conf
flush ruleset

# --- DÉFINITIONS ---
define WAN = ens33
define LAN = ens37
define DMZ = ens38
define LAN_NET = 192.168.50.0/24
define IP_DMZ_WEB = 10.0.5.10

table inet firewall {
    set blackhole { type ipv4_addr; flags dynamic, timeout; timeout 2m; }

    chain input {
        type filter hook input priority 0; policy drop;
        iif lo accept
        ct state established,related accept
        
        # 1. Protection Brute-force (Priorité haute)
        ip saddr @blackhole log prefix "[FW-BANNED] " drop
        tcp dport 22 ct state new limit rate over 3/minute log prefix "[FW-BRUTEFORCE] " add @blackhole { ip saddr }
        
        # 2. Autorisations
        iif $LAN ip saddr $LAN_NET tcp dport 22 accept
        ip protocol icmp limit rate 2/second accept
        log prefix "[FW-DROP-INPUT] "
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
        
        # Isolation stricte : bloquer accès direct DMZ depuis WAN
        iif $WAN oif $DMZ ip daddr $IP_DMZ_WEB tcp dport != { 80, 443 } log prefix "[FW-UNAUTHORIZED-DMZ] " drop
        iif $WAN oif $DMZ ip daddr $IP_DMZ_WEB ip protocol icmp log prefix "[FW-PING-BLOCKED] " drop

        ct state established,related accept
        udp dport 53 accept
        tcp dport 53 accept

        # Flux autorisés
        iif $LAN oif $WAN ip saddr $LAN_NET accept
        iif $LAN oif $DMZ ip saddr $LAN_NET ip daddr $IP_DMZ_WEB tcp dport { 80, 443 } accept
        iif $WAN oif $DMZ ip daddr $IP_DMZ_WEB tcp dport { 80, 443 } ct state new accept
        
        log prefix "[FW-DROP-FORWARD] "
    }
}

table ip nat {
    chain prerouting {
        type nat hook prerouting priority -100; policy accept;
        iif "ens33" tcp dport { 80, 443 } dnat to 10.0.5.10
    }
    chain postrouting {
        type nat hook postrouting priority 100; policy accept;
        oif "ens33" masquerade
    }
}
EOF

nft -f /etc/nftables.conf && systemctl restart nftables
echo "Pare-feu Orange opérationnel avec NAT et DNAT."
