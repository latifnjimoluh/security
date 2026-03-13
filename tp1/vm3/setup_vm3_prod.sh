#!/bin/bash
# Configuration VM 3 - Client Production (10.10.10.10)
cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      addresses: [10.10.10.10/24]
      routes: [{to: default, via: 10.10.10.1}]
EOF
netplan apply
echo "VM 3 configurée (IP 10.10.10.10)."
ping -c 3 10.10.10.1
