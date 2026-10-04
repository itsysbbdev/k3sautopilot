workspace "k3sautopilot" "Zero-to-hero automatizált K3s bare-metal cluster telepítés" {
    model {
        admin = person "IT Architect" "A folyamatot vezérlő mérnök (Karmester)."
        
        k3sSystem = softwareSystem "K3s Autopilot Rendszer" "Hybrid AI/IaC architektúra bare-metal K3s telepítéshez." {
            orchestrator = container "AI Orchestrator" "Acer Swift 3 (VS Code + AI)" "Vezérli a felderítést és generálja az IaC konfigurációkat."
            discovery = container "Felderítő Szkript" "Bash / SSH" "Dinamikusan lekérdezi a node-ok hardveradatait (IP, lsblk, ip a)."
            ansible = container "Ansible Playbookok" "YAML / Ansible" "Végrehajtja az OS hardeninget és a K3s (HA) telepítést."
            nodes = container "Bare-metal Node-ok" "HP 840 G6" "A dedikált K3s szerver (10.8.8.91)."
        }

        admin -> orchestrator "Kezdeményezi a telepítést"
        orchestrator -> discovery "Futtatja a felderítést"
        discovery -> nodes "Lekérdezi a hardver adatokat (SSH)"
        orchestrator -> ansible "Generálja az inventory-t és a változókat (host_vars)"
        ansible -> nodes "Konfigurálja az operációs rendszert és telepíti a K3s-t (SSH)"
    }

    views {
        systemContext k3sSystem "Context" { include *; autoLayout }
        container k3sSystem "Containers" { include *; autoLayout }
        theme default
    }
}
