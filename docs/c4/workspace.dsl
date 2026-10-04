workspace "k3sautopilot" "Zero-to-hero automatizált K3s bare-metal cluster telepítés" {
    model {
        admin = person "IT Architect" "A folyamatot vezérlő mérnök (Karmester)."
        
        k3sSystem = softwareSystem "K3s Autopilot Rendszer" "Hybrid AI/IaC architektúra bare-metal K3s telepítéshez." {
            orchestrator = container "AI Orchestrator" "Acer Swift 3 (VS Code + AI)" "Vezérli a felderítést és az IaC futtatást."
            
            cpNode = container "Control Plane Node (24/7)" "t320s (10.8.8.11)" "Natív K3s API szerver agent nélkül. Itt fut a Docker alapú Rancher is."
            workerNodes = container "Worker & Storage Node-ok (On-Demand)" "Asus, Dell, HP" "Longhorn elosztott tároló és workload futtatás (10.8.8.88, .89, .91)."
            ansible = container "Ansible Playbookok" "YAML / Ansible" "Automatizálja az OS hardeninget és a szerepköralapú K3s telepítést."
        }

        admin -> orchestrator "Kezdeményezi a telepítést"
        orchestrator -> ansible "Generálja a konfigurációkat"
        ansible -> cpNode "Telepíti a Control Plane-t (API, etcd/sqlite)"
        ansible -> workerNodes "Csatlakoztatja a workereket és a Longhornt"
        cpNode -> workerNodes "Kezeli és ütemezi a workloadokat"
    }

    views {
        systemContext k3sSystem "Context" { include *; autoLayout }
        container k3sSystem "Containers" { include *; autoLayout }
        theme default
    }
}
