#!/bin/bash
echo "=== 2. K3s & Longhorn Előfeltételek Automatikus Javítása ==="

echo "--- 1. Control Plane (t320s) k3s service ellenőrzése és indítása ---"
ssh bbadmin@10.8.8.11 "if ! systemctl list-unit-files | grep -q k3s.service; then \
    echo 'K3s service hiányzik, újraregisztrálás...'; \
    curl -sfL https://get.k3s.io | sh -s - server --disable-agent --tls-san 10.8.8.11 --node-ip 10.8.8.11 --bind-address 10.8.8.11; \
else \
    sudo systemctl enable --now k3s; \
fi"
echo "[OK] t320s k3s service rendben."

NODES=("10.8.8.88" "10.8.8.89" "10.8.8.91")

for ip in "${NODES[@]}"; do
    echo "--- Előfeltételek javítása ezen a node-on: $ip ---"
    if ping -c 1 -w 2 "$ip" > /dev/null 2>&1; then
        # open-iscsi, nfs-common biztosítása, modul betöltése és automatizálása boot-ra
        ssh bbadmin@"$ip" "sudo apt-get update && sudo apt-get install -y open-iscsi nfs-common && \
            echo 'iscsi_tcp' | sudo tee /etc/modules-load.d/iscsi-tcp.conf && \
            sudo modprobe iscsi_tcp && \
            sudo systemctl enable --now iscsid && \
            sudo systemctl enable --now k3s-agent"
        echo "[OK] $ip node iSCSI, modulok és k3s-agent beállítva."
    else
        echo "[FIGYELEM] $ip nem érhető el."
    fi
done

echo "--- Javítás kész ---"
