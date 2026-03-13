#!/bin/bash
# Test Firewall - VM 1
BLUE='\033[0;34m'; NC='\033[0m'
echo -e "${BLUE}--- ÉTAT DU SERVICE NFTABLES ---${NC}"
systemctl status nftables --no-pager
echo -e "\n${BLUE}--- RULESET ACTUEL (Configuration brute) ---${NC}"
sudo nft list ruleset
echo -e "\n${BLUE}--- DERNIERS LOGS DE SÉCURITÉ (Filtre [FW-]) ---${NC}"
sudo grep "\[FW-" /var/log/syslog | tail -n 10
