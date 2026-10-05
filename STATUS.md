# K3s Hibrid Klaszter Státusz

## Architektúra (ADR-002 kiegészítés)
A rendszer a hibrid és energiatakarékos működés érdekében a következőképpen lett stabilizálva:

### 1. Control Plane (24/7 Manager - t320s / 10.8.8.11)
- K3s szerverként funkcionál, **agent bekapcsolva**.
- **Taint:** `node-role.kubernetes.io/control-plane:NoSchedule` került beállításra. Ez megakadályozza, hogy a normál workloadok a managerre kerüljenek ütemezésre.
- **Kritikus Rendszerkomponensek:** A `CoreDNS`, `Metrics-Server`, `Local-Path-Provisioner` és a `Traefik Ingress` úgy lettek konfigurálva (NodeSelector és Tolerations), hogy **kizárólag** ezen a node-on fussanak. Így a worker node-ok kikapcsolása esetén is működőképes marad a hálózat és az API.

### 2. On-Demand Worker Node-ok (10.8.8.88, .89, .91)
- Dinamikusan ki- és bekapcsolható gépek (energiatakarékosság).
- Csak a k3s-agent fut rajtuk. A bekapcsolásuk után csatlakoznak a klaszterhez és átveszik a normál workloadok futtatását.

### 3. Longhorn Elosztott Tárolás (longhorn-system)
- Telepítve a worker node-ok közötti elosztott tároláshoz.
- Replikációs tényező: `2` (defaultReplicaCount=2), igazodva a 3 node-os on-demand struktúrához.
- Az iSCSI (iscsid) és a kernel modul (iscsi_tcp) előfeltételek minden worker node-on aktívak és ellenőrzöttek (a `cluster_repair.sh` szkript gondoskodik a hiányzó függőségek automatikus helyreállításáról a node-ok visszakapcsolásakor).
