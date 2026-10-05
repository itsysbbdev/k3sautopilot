#!/bin/bash
echo "=== 2. K3s Klaszter Automatikus Javító & Boot Konfiguráció ==="

echo "--- 1. Control Plane (t320s) k3s service ellenőrzése és indítása ---"
ssh bbadmin@10.8.8.11 "if ! systemctl list-unit-files | grep -q k3s.service; then \
    echo 'K3s service hiányzik, újratelepítés/újraregisztrálás...'; \
    curl -sfL https://get.k3s.io | sh -s - server --disable-agent --tls-san 10.8.8.11 --node-ip 10.8.8.11 --bind-address 10.8.8.11; \
else \
    sudo systemctl enable --now k3s; \
fi"
echo "[OK] t320s k3s service fut és engedélyezve van."

NODES=("10.8.8.88" "10.8.8.89" "10.8.8.91")

for ip in "${NODES[@]}"; do
    echo "--- Javítás ezen a node-on: $ip ---"
    if ping -c 1 -w 2 "$ip" > /dev/null 2>&1; then
        ssh bbadmin@"$ip" "sudo systemctl enable --now iscsid && sudo systemctl enable --now k3s-agent"
        echo "[OK] $ip node iSCSI és k3s-agent service beállítva."
    else
        echo "[FIGYELEM] $ip nem érhető el, valószínűleg ki van kapcsolva."
    fi
done

echo "--- Klaszter javítás kész ---"
