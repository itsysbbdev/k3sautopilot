#!/bin/bash
export KUBECONFIG=~/.kube/config-k3sautopilot

echo "=== 1. K3s & Longhorn Klaszter Diagnosztika ==="
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
echo "--- SSH, K3s Agent és iSCSI (Longhorn előfeltétel) ellenőrzés a node-okon ---"
for ip in "${NODES[@]}"; do
    echo "> Ellenőrzés: $ip"
    ssh -o ConnectTimeout=3 -o BatchMode=yes bbadmin@"$ip" "sudo systemctl status k3s-agent --no-pager | grep -E 'Active:|Loaded:'" 2>/dev/null || echo "[HIBA] k3s-agent nem fut ezen: $ip"
    ssh -o ConnectTimeout=3 -o BatchMode=yes bbadmin@"$ip" "sudo systemctl status iscsid --no-pager | grep Active:" 2>/dev/null || echo "[HIBA] iSCSI (iscsid) nem fut ezen: $ip"
    ssh -o ConnectTimeout=3 -o BatchMode=yes bbadmin@"$ip" "lsmod | grep iscsi_tcp" >/dev/null 2>&1 && echo "  [OK] iscsi_tcp kernel modul betöltve." || echo "  [FIGYELEM] iscsi_tcp kernel modul nincs betöltve!"
done

echo ""
echo "--- Control Plane (t320s) API státusz ---"
sudo systemctl status k3s --no-pager | grep -E 'Active:|Loaded:'
sudo ss -tlpn | grep 6443

echo ""
echo "--- Longhorn Tároló Rendszer Státusz ---"
if kubectl get namespace longhorn-system >/dev/null 2>&1; then
    echo "[OK] longhorn-system namespace létezik."
    echo "Longhorn Podok:"
    kubectl get pods -n longhorn-system
    echo ""
    echo "StorageClass listája:"
    kubectl get sc
else
    echo "[FIGYELEM] A longhorn-system namespace nem található. Lehet, hogy még sincs telepítve?"
fi
