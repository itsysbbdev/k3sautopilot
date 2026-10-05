#!/bin/bash
echo "=== 1. K3s Klaszter Diagnosztika ==="
NODES=("10.8.8.88" "10.8.8.89" "10.8.8.91")

echo "--- Ping teszt a worker node-okra ---"
for ip in "${NODES[@]}"; do
    if ping -c 1 -w 2 "$ip" > /dev/null 2>&1; then
        echo "[OK] Node $ip elérhető ping-gel."
    else
        echo "[HIBA] Node $ip NEM elérhető ping-gel! (Lehet, hogy le van kapcsolva?)"
    fi
done

echo ""
echo "--- SSH és K3s Agent Service ellenőrzés a node-okon ---"
for ip in "${NODES[@]}"; do
    echo "> Ellenőrzés: $ip"
    ssh -o ConnectTimeout=3 -o BatchMode=yes bbadmin@"$ip" "sudo systemctl status k3s-agent --no-pager | grep -E 'Active:|Loaded:'" 2>/dev/null || echo "[HIBA] Nem sikerült csatlakozni vagy futtatni a service status parancsot ezen: $ip"
    ssh -o ConnectTimeout=3 -o BatchMode=yes bbadmin@"$ip" "systemctl is-enabled k3s-agent" 2>/dev/null | xargs -I {} echo "  Auto-start (enabled): {}"
    ssh -o ConnectTimeout=3 -o BatchMode=yes bbadmin@"$ip" "sudo systemctl status iscsid --no-pager | grep Active:" 2>/dev/null || echo "[HIBA] iSCSI (iscsid) nem fut ezen: $ip"
done

echo ""
echo "--- Control Plane (t320s) API és Service státusz ---"
sudo systemctl status k3s --no-pager | grep -E 'Active:|Loaded:'
sudo ss -tlpn | grep 6443
