#!/bin/bash
# Migration TP 3 - VM 3 DMZ (Version Finale)
if [[ $EUID -ne 0 ]]; then echo "Lancer avec sudo."; exit 1; fi
cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      addresses: [10.0.5.10/24]
      nameservers: {addresses: [8.8.8.8, 1.1.1.1]}
      routes: [{to: default, via: 10.0.5.1}]
EOF
chmod 600 /etc/netplan/*.yaml
netplan apply
echo "VM 3 DMZ configurée."
