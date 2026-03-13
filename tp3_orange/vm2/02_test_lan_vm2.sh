#!/bin/bash
# Test LAN - VM 2
BLUE='\033[0;34m'; NC='\033[0m'
echo -e "${BLUE}--- TEST PING INTERNET (8.8.8.8) ---${NC}"
ping -c 2 8.8.8.8
echo -e "\n${BLUE}--- TEST RÉSOLUTION DNS (google.com) ---${NC}"
host google.com
echo -e "\n${BLUE}--- TEST ACCÈS PORTAIL DMZ (HTTP) ---${NC}"
curl -I http://10.0.5.10
echo -e "\n${BLUE}--- TEST ACCÈS SSH FIREWALL (Verification port) ---${NC}"
nc -zv 192.168.50.1 22
