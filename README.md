# k3sautopilot

Zero-to-hero automatizált K3s bare-metal cluster telepítés.

## Architektúra: Hybrid AI/IaC
Hagyományos, merev IaC helyett ezt a modellt alkalmazzuk a maximális hordozhatóság (homelab, publikus demók) érdekében:
1. **Felderítés**: Dinamikus felderítő szkript lekérdezi a bare-metal gépek fizikai paramétereit (IP, lsblk, hálózati interfészek).
2. **AI Híd**: Az AI Orchestrator (Acer Swift 3) a felderített JSON kimenetből dinamikusan legenerálja az Ansible `inventory` és `host_vars` fájlokat.
3. **Végrehajtás**: Determinisztikus, idempotens Ansible playbookok elvégzik az OS szintű hardeninget és a K3s telepítését a HP 840 G6 node-on.

## Projekt Struktúra
* `docs/adr/`: Architektúra döntések (Architecture Decision Records)
* `docs/c4/`: Structurizr C4 modellek (Documentation-as-Code)
* `scripts/`: Hardver felderítő és JSON generáló szkriptek
* `ansible/`: Ansible playbookok, dinamikus inventory és szerepkörök
