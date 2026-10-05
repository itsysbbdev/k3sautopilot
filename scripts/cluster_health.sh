#!/bin/bash
export KUBECONFIG=~/.kube/config-k3sautopilot

echo "=== K3s Klaszter Egészségi Állapot ==="
echo ""
echo "[1] Node-ok Kubernetes státusza:"
kubectl get nodes -o wide
echo ""
echo "[2] Rendszer-podok állapota (kube-system):"
kubectl get pods -n kube-system -o wide
echo ""
echo "[3] API Szerver válaszkészség:"
kubectl get --raw='/readyz?verbose'
echo ""
