#!/bin/bash
# Attaque Brute-Force SSH - VM 2
BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'
echo -e "${BLUE}--- DÉBUT DE LA SIMULATION D'ATTAQUE (6 tentatives) ---${NC}"
for i in {1..6}; do
    echo -n "Tentative $i : "
    timeout 3 ssh -o BatchMode=yes -o ConnectTimeout=2 root@192.168.50.1 exit 2>/dev/null
    if [ $? -eq 124 ]; then echo -e "${RED}TIMEOUT (IP BANNIE !)${NC}"; else echo "Réponse reçue."; fi
    sleep 0.2
done
