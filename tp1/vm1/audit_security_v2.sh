#!/bin/bash
# Script d'Audit v2.0 - Interactif
GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
REPORT="/var/log/audit_report.txt"; LOG_FILE="/var/log/network-security.log"
echo -e "${BLUE}=== AUDIT DE SECURITE ===${NC}"
ss -tulnp | tee $REPORT
chmod 600 /etc/netplan/*.yaml /etc/ssh/sshd_config
chown syslog:adm $LOG_FILE; chmod 660 $LOG_FILE
ls -l /etc/netplan/*.yaml /etc/ssh/sshd_config $LOG_FILE | tee -a $REPORT
echo -e "${GREEN}Audit terminé. Rapport dans $REPORT${NC}"
timeout 10s tcpdump -i ens37 icmp -n | tee -a $REPORT
