# Suivi du TP 1 — Sécurité des Architectures Filaires

## 🎯 Objectif du TP
Configurer un serveur Linux multi-homed (passerelle) pour connecter trois segments réseau (Internet, LAN Admin, Production) et sécuriser l'architecture.

---

## 🏗️ Architecture Réseau
| Machine | Rôle | Interface (VMware) | Adresse IP | Segment |
| :--- | :--- | :--- | :--- | :--- |
| **VM 1** | Serveur / Routeur | ens33 (NAT) | DHCP (192.168.24.x) | WAN / Internet |
| **VM 1** | Serveur / Routeur | ens37 (VMnet1) | 192.168.10.1/24 | LAN Administratif |
| **VM 1** | Serveur / Routeur | ens38 (VMnet2) | 10.10.10.1/24 | Production |
| **VM 2** | Client Admin | ens33 (VMnet1) | 192.168.10.10/24 | LAN Administratif |
| **VM 3** | Client Prod | ens33 (VMnet2) | 10.10.10.10/24 | Production |

---

## ✅ État d'avancement

### **Partie A — Configuration des Interfaces**
- [x] Création des réseaux virtuels (VMnet1, VMnet2, VMnet8) dans VMware.
- [x] Identification des interfaces sur la VM 1 (`ens33`, `ens37`, `ens38`).
- [x] Configuration Netplan sur la VM 1 (Script : `setup_router.sh`).
- [x] Activation du Forwarding IPv4 sur la VM 1 (Routage permanent).
- [x] Configuration de la VM 2 Client Admin (Script : `setup_vm2_admin.sh`).
- [x] Configuration de la VM 3 Client Prod (Script : `setup_vm3_prod.sh`).
- [x] Test de connectivité (Ping inter-segments).

### **Partie B — Diagnostic et Sécurisation**
- [x] Audit des ports ouverts (`ss -tulnp`).
- [x] Analyse de trafic avec `tcpdump`.
- [x] Vérification des permissions des fichiers réseau.
- [x] Configuration de `rsyslog` pour la centralisation des logs.
- [x] Détection d'anomalies DNS (Immuabilité `/etc/resolv.conf`).

### **Partie C — Rapport Technique**
- [x] Rédaction du rapport de 2 pages (`RAPPORT_TECHNIQUE.md`).
- [x] Création du schéma d'architecture.
- [x] Analyse des risques et recommandations.

---
**ÉTAT FINAL : TP 1 TERMINÉ ET VALIDÉ** ✅
- [x] Connectivité inter-segments opérationnelle.
- [x] Centralisation des logs active sur VM 2.
- [x] Audit de sécurité et capture de trafic réussis.

---

## 📂 Liste des fichiers créés
1. `tp1.txt` : Énoncé original du TP.
2. `setup_router.sh` : Script d'installation automatique pour la VM 1.
3. `setup_vm2_admin.sh` : Script de configuration pour la VM 2 (LAN Admin).
4. `setup_vm3_prod.sh` : Script de configuration pour la VM 3 (Production).
5. `PROGRESS.md` : Ce document de suivi.
