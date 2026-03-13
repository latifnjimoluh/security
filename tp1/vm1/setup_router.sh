#!/bin/bash
# Configuration du routeur (VM 1)
if [[ $EUID -ne 0 ]]; then echo "Lancer avec sudo."; exit 1; fi
cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33: {dhcp4: true}
    ens37: {addresses: [192.168.10.1/24]}
    ens38: {addresses: [10.10.10.1/24]}
EOF
netplan apply
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
