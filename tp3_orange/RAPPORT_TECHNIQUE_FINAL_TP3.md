# RAPPORT TECHNIQUE FINAL — TP 3
## Sécurisation d'Infrastructures Multi-Zones avec nftables
**Projet :** Déploiement du Portail Client Orange Cameroun
**Date :** 13 Mars 2026
**Auteur :** [Votre Nom]
**Cours :** Sécurité des Architectures Filaires (Keyce IA)

---

## 1. Contexte et Objectifs
Dans le cadre du déploiement d'un nouveau portail Web pour Orange Cameroun, ce TP visait à implémenter une politique de sécurité périmétrique rigoureuse. L'architecture repose sur un pare-feu Linux central (VM 1) isolant trois zones distinctes :
*   **WAN (Internet)** : Zone publique non fiable.
*   **LAN (Employés)** : Zone interne de confiance.
*   **DMZ (Démilitarisée)** : Zone hébergeant les serveurs exposés.

---

## 2. Architecture Réseau et Adressage
| Zone | Interface | Réseau / IP | Rôle |
| :--- | :--- | :--- | :--- |
| **WAN** | ens33 | DHCP (192.168.24.x) | Sortie vers Internet |
| **LAN** | ens37 | 192.168.50.0 /24 | Postes administratifs |
| **DMZ** | ens38 | 10.0.5.0 /24 | Serveur Web Orange (10.0.5.10) |

---

## 3. Implémentation de la Politique de Sécurité
Nous avons utilisé le framework **nftables** pour appliquer les règles suivantes :

### 3.1 Filtrage et Routage
*   **Politique par défaut : DROP** sur les chaînes INPUT et FORWARD.
*   **DNAT (Port Forwarding) :** Redirection du port 80/443 de l'IP WAN vers l'IP DMZ pour rendre le site accessible sans exposer l'adresse privée.
*   **NAT (Masquerade) :** Permet au LAN de naviguer sur Internet via l'IP publique du pare-feu.

### 3.2 Hardening et Protection Anti-Intrusion
*   **Administration SSH :** Limitée strictement au réseau LAN sur le port 22.
*   **Anti-Brute Force :** Mise en œuvre d'un `set` dynamique nommé `@blackhole`. Toute IP tentant plus de 3 connexions SSH par minute est bannie automatiquement pendant 2 minutes.
*   **Isolation DMZ :** Blocage et journalisation de toute tentative d'accès direct vers l'IP privée 10.0.5.10 depuis le WAN.

---

## 4. Tests de Validation et Résultats Système
Les scripts de test ont retourné les résultats bruts suivants :

1.  **Test LAN (VM 2)** :
    *   `ping 8.8.8.8` : **SUCCÈS** (Routage + NAT actifs).
    *   `curl 10.0.5.10` : **SUCCÈS** (Portail accessible depuis le LAN).
2.  **Test DMZ (VM 3)** :
    *   `ping 192.168.50.10` : **ÉCHEC** (Isolation du LAN confirmée).
    *   `ping 8.8.8.8` : **ÉCHEC** (Navigation interdite depuis la DMZ).
3.  **Simulation d'Attaque (VM 2)** :
    *   À la 4ème tentative SSH : **TIMEOUT**.
    *   Commande `nft list set inet firewall blackhole` : Présence de l'IP de l'attaquant confirmée.

---

## 5. Conclusion
Le pare-feu nftables déployé assure une protection optimale du portail Orange Cameroun. L'utilisation du **DNAT** garantit l'anonymat des adresses privées (IP Hiding), tandis que les mécanismes de **Rate Limiting** protègent les services d'administration contre les attaques par force brute. L'infrastructure est conforme aux exigences de sécurité industrielles.
