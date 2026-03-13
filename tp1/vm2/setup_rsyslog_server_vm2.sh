#!/bin/bash
# Configuration du SERVEUR de Logs - VM 2
sudo sed -i 's/^#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf
cat <<EOF | sudo tee /etc/rsyslog.d/remote-logs.conf
\$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
& stop
EOF
mkdir -p /var/log/remote; chown -R syslog:adm /var/log/remote; chmod -R 755 /var/log/remote
systemctl restart rsyslog
echo "Serveur de logs prêt sur UDP/514."
