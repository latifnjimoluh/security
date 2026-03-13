#!/bin/bash
# Migration TP 3 - VM 1 Orange Firewall (Version Finale)
if [[ $EUID -ne 0 ]]; then echo "Lancer avec sudo."; exit 1; fi
cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33: {dhcp4: true}
    ens37: {addresses: [192.168.50.1/24]}
    ens38: {addresses: [10.0.5.1/24]}
EOF
chmod 600 /etc/netplan/*.yaml
netplan apply
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-ipforward.conf
sysctl -p /etc/sysctl.d/99-ipforward.conf
echo "IPs migrées et Forwarding actif."
