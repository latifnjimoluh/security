# RAPPORT TECHNIQUE FINAL — TP 1
## Sécurité des Architectures Filaires : Administration Réseau Linux
**Sujet :** Configuration et Sécurisation de la Passerelle AgroTech Cameroun SA
**Date :** 13 Mars 2026
**Auteur :** [Votre Nom]
**Institution :** Keyce Informatique & IA — Master I Cyber Sécurité

---

## 1. Introduction et Objectifs
Le présent TP porte sur la mise en place d'une architecture réseau segmentée pour l'entreprise AgroTech Cameroun SA. L'objectif principal était de transformer un serveur Linux Ubuntu 22.04 en une passerelle (routeur) sécurisée, capable de relier trois zones distinctes (Internet, LAN Admin, Production) tout en garantissant la traçabilité des événements via un serveur de logs centralisé.

---

## 2. Architecture et Configuration Réseau
### 2.1 Schéma Logique de l'Infrastructure
```text
           [ ZONE WAN / INTERNET ]
                      |
                      | (Interface : ens33 - NAT)
              +-------+-------+
              |    VM 1       | (Routeur Linux)
              |  Passerelle   | (IP Forwarding : Activé)
              +-------+-------+
               /             \
       (ens37 - VMnet1)   (ens38 - VMnet2)
              |                 |
      [ ZONE ADMIN ]        [ ZONE PROD ]
     (192.168.10.0/24)     (10.10.10.0/24)
              |                 |
          [ VM 2 ]          [ VM 3 ]
       (192.168.10.10)     (10.10.10.10)
```

### 2.2 Tableau d'Adressage IP
| Machine | Interface | Adresse IP | Passerelle | Rôle |
| :--- | :--- | :--- | :--- | :--- |
| **VM 1** | ens33 | DHCP (192.168.24.22) | 192.168.24.2 | Accès Internet |
| **VM 1** | ens37 | 192.168.10.1 /24 | - | Passerelle Admin |
| **VM 1** | ens38 | 10.10.10.1 /24 | - | Passerelle Prod |
| **VM 2** | ens33 | 192.168.10.10 /24 | 192.168.10.1 | Client Admin / Serveur Logs |
| **VM 3** | ens33 | 10.10.10.10 /24 | 10.10.10.1 | Client Production |

---

## 3. Mise en Œuvre Technique
### 3.1 Routage et Connectivité
Le routage a été activé de manière permanente sur la **VM 1** via le fichier `/etc/sysctl.conf` (`net.ipv4.ip_forward=1`).
**Validation :** Un test de ping depuis la VM 3 vers la VM 2 a retourné une valeur de **TTL=63**, confirmant que les paquets traversent bien la passerelle (VM 1).

### 3.2 Sécurisation (Hardening DAC)
Nous avons appliqué le modèle de contrôle d'accès discrétionnaire (DAC) :
*   **Netplan & SSH :** `chmod 600` sur les fichiers de configuration pour restreindre l'accès à **root** uniquement.
*   **Immuabilité :** Le fichier `/etc/resolv.conf` a été verrouillé avec l'attribut d'immuabilité (`chattr +i`).
*   **Centralisation des Logs à distance :** Une architecture `rsyslog` Client/Serveur a été déployée. La VM 1 exporte l'intégralité de ses logs vers la VM 2 (UDP/514).

---

## 4. Audit de Sécurité et Résultats
### 4.1 Analyse des Ports (Commande : `ss -tulnp`)
L'audit révèle que seul le service **SSH (port 22)** est à l'écoute sur l'interface publique (`0.0.0.0:22`).
**Risque :** Exposition aux attaques par force brute depuis l'extérieur.

### 4.2 Analyse du Mode Promiscuous
Les logs réseau (`/var/log/network-security.log`) indiquent :
`kernel: device ens37 entered promiscuous mode`
**Analyse :** Ce log confirme l'utilisation de `tcpdump` pour la capture de paquets. C'est un indicateur d'audit légitime ici, mais un signal d'alerte critique (sniffing) s'il apparaît en dehors d'une période d'audit.

---

## 5. Analyse des Risques et Recommandations
1.  **Risque d'Inter-connexion Illimitée :** Actuellement, aucun filtrage n'est actif. Un attaquant sur la VM 3 pourrait accéder librement au segment d'administration (VM 2).
2.  **Recommandation 1 (Filtrage) :** Déployer un pare-feu **nftables** sur la VM 1 pour interdire tout flux entrant de la Production vers le LAN Admin (sauf réponses aux requêtes).
3.  **Recommandation 2 (SSH Hardening) :** Restreindre l'accès SSH à l'interface `ens37` (Admin) uniquement et désactiver l'authentification par mot de passe au profit de clés SSH.
4.  **Recommandation 3 (IDS) :** Installer un système de détection d'intrusion comme **Suricata** sur la passerelle pour monitorer les flux suspects entre les segments.

---

## Conclusion
Le premier jalon du projet de sécurisation d'AgroTech SA est atteint. La segmentation réseau est fonctionnelle, la passerelle assure son rôle de routage et la centralisation des logs garantit la traçabilité des actions. La prochaine phase se concentrera sur la mise en place de politiques de filtrage granulaires (Pare-feu).
