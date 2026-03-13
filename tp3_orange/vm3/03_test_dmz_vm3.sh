#!/bin/bash
# Test DMZ - VM 3
BLUE='\033[0;34m'; NC='\033[0m'
echo -e "${BLUE}--- TEST ISOLATION LAN (192.168.50.10) ---${NC}"
echo "Ce ping DOIT échouer (Packet loss 100%) :"
ping -c 2 -W 2 192.168.50.10
echo -e "\n${BLUE}--- TEST ÉTAT SERVEUR WEB LOCAL ---${NC}"
systemctl status nginx --no-pager
echo -e "\n${BLUE}--- TEST ACCÈS INTERNET DIRECT ---${NC}"
echo "Ce ping DOIT échouer (Isolation stricte) :"
ping -c 2 -W 2 8.8.8.8
