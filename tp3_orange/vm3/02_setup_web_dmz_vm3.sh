#!/bin/bash
# Configuration Web Orange - VM 3
if [[ $EUID -ne 0 ]]; then echo "Lancer avec sudo."; exit 1; fi
apt update && apt install -y nginx
echo "<h1>PORTAIL CLIENT ORANGE CAMEROUN</h1>" > /var/www/html/index.html
systemctl restart nginx
echo "Serveur Web actif sur 10.0.5.10."
