#!/bin/bash
echo "=== 2. K3s Klaszter Automatikus Javító & Boot Konfiguráció ==="

echo "--- 1. Control Plane (t320s) k3s service biztosítása ---"
sudo systemctl enable --now k3s
echo "[OK] t320s k3s service engedélyezve és indítva."

NODES=("10.8.8.88" "10.8.8.89" "10.8.8.91")

for ip in "${NODES[@]}"; do
    echo "--- Javítás ezen a node-on: $ip ---"
    if ping -c 1 -w 2 "$ip" > /dev/null 2>&1; then
        # iSCSI és k3s-agent engedélyezése és indítása bootra is
        ssh bbadmin@"$ip" "sudo systemctl enable --now iscsid && sudo systemctl enable --now k3s-agent"
        echo "[OK] $ip node iSCSI és k3s-agent service beállítva."
    else
        echo "[FIGYELEM] $ip nem érhető el, valószínűleg ki van kapcsolva. Kapcsold be (WoL-lal), majd futtasd újra!"
    fi
done

echo "--- Klaszter javítás kész ---"
