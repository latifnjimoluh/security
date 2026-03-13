#!/bin/bash
# Configuration VM 2 - Client LAN Admin (192.168.10.10)
cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      addresses: [192.168.10.10/24]
      routes: [{to: default, via: 192.168.10.1}]
EOF
netplan apply
echo "VM 2 configurée (IP 192.168.10.10)."
