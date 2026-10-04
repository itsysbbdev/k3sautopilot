#!/bin/bash
# k3sautopilot - Mock Discovery Script
cat << 'JSON'
[
  {
    "ip": "10.8.8.10",
    "lsblk": { "blockdevices": [ { "name": "nvme0n1", "size": "238.5G", "type": "disk", "mountpoint": null } ] },
    "ip_a": { "interfaces": [ { "ifname": "eno1", "operstate": "UP", "address": "AA:BB:CC:11:22:33" } ] }
  },
  {
    "ip": "10.8.8.11",
    "lsblk": { "blockdevices": [ { "name": "sda", "size": "476.9G", "type": "disk", "mountpoint": null } ] },
    "ip_a": { "interfaces": [ { "ifname": "enp3s0", "operstate": "UP", "address": "DD:EE:FF:44:55:66" } ] }
  }
]
JSON
