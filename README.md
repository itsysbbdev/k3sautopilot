# k3sautopilot

Zero-to-hero automatizált K3s bare-metal cluster telepítés.

## Architektúra: On-Demand Lab Environment
A rendszer optimalizálása (ADR-002) alapján a K3s klaszter osztott szerepkörökkel épül fel:
1. **Control Plane (24/7):** A `10.8.8.11` hoston fut natívan (agenttel, de `NoSchedule` Taint-tel védve), garantálva a hálózat (Traefik, CoreDNS) és az API folyamatos elérését.
2. **Workers & Longhorn (On-Demand):** A dedikált vasak (`10.8.8.88`, `.89`, `.91`) kizárólag a labor üzemideje alatt aktívak, csökkentve az energiafogyasztást.

## Projekt Struktúra
* `docs/adr/`: Architektúra döntések (Architecture Decision Records)
* `docs/c4/`: Structurizr C4 modellek (Documentation-as-Code)
* `ansible/`: Ansible playbookok, dinamikus inventory és szerepkörök (CP vs Worker)
* `scripts/`: Egészségellenőrző, diagnosztikai és javító szkriptek

