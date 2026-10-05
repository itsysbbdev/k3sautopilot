#!/bin/bash
echo "=== K3s & Longhorn Teljes Körű Javítás ==="

echo "--- 1. Control Plane (t320s) K3s Server Kényszerített Újraindítása ---"
ssh bbadmin@10.8.8.11 "curl -sfL https://get.k3s.io | sh -s - server \
    --tls-san 10.8.8.11 \
    --node-ip 10.8.8.11 \
    --bind-address 10.8.8.11 \
    --node-taint node-role.kubernetes.io/control-plane:NoSchedule"
echo "[OK] t320s Control Plane service telepítve/frissítve."

NODES=("10.8.8.88" "10.8.8.89" "10.8.8.91")

for ip in "${NODES[@]}"; do
    echo "--- Worker node ellenőrzése: $ip ---"
    if ping -c 1 -w 2 "$ip" > /dev/null 2>&1; then
        ssh bbadmin@"$ip" "sudo modprobe iscsi_tcp && \
            sudo systemctl enable --now iscsid && \
            sudo systemctl enable --now k3s-agent"
        echo "[OK] $ip worker node rendben."
    else
        echo "[FIGYELEM] $ip nem érhető el."
    fi
done

echo "--- Javítás kész ---"
