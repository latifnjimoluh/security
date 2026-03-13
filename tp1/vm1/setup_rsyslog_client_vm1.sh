#!/bin/bash
# Configuration de l'ENVOI de Logs - VM 1 (Client)
SERVER_IP="192.168.10.10"
echo "*.* @${SERVER_IP}:514" | sudo tee /etc/rsyslog.d/forward-logs.conf
systemctl restart rsyslog
echo "Logs redirigés vers $SERVER_IP."
logger "TEST_CENTRALISATION : Envoi depuis VM 1"
