# GUIDE DE DÉPLOIEMENT CISCO PACKET TRACER — TP 2
## Architecture Sécurisée & Segmentation (LAN / DMZ / WAN)
**Contexte :** Orange Cameroun (Préparation à l'implémentation Linux du TP 3)

---

## 1. Topologie Matérielle (À recréer dans Packet Tracer)
Placez les équipements suivants dans votre espace de travail :

*   **R1 (Routeur)** : 1x Routeur Cisco 1941 ou 2911 (Sera le Pare-feu de bordure).
*   **SW1 (Commutateur LAN)** : 1x Switch Cisco 2960.
*   **SW2 (Commutateur DMZ)** : 1x Switch Cisco 2960.
*   **PC1 (Employé LAN)** : 1x PC.
*   **SRV1 (Serveur Web DMZ)** : 1x Serveur.
*   **ISP (Nuage Internet)** : 1x Serveur représentant Internet (8.8.8.8).

### Câblage :
1.  **R1 (G0/0)** ────── câble droit ────── **SW1 (Fa0/1)** ──(Fa0/2)── **PC1**
2.  **R1 (G0/1)** ────── câble droit ────── **SW2 (Fa0/1)** ──(Fa0/2)── **SRV1**
3.  **R1 (S0/0/0 ou G0/2)** ── câble croisé ── **ISP (Serveur Internet)**

---

## 2. Tableau d'Adressage IP

| Équipement | Interface | IP / Masque | Rôle / Zone |
| :--- | :--- | :--- | :--- |
| **R1** | G0/0 | `192.168.50.1 /24` | Passerelle LAN (Employés) |
| **R1** | G0/1 | `10.0.5.1 /24` | Passerelle DMZ (Portail) |
| **R1** | G0/2 | `200.1.1.2 /30` | Interface WAN (Publique) |
| **PC1** | NIC | `192.168.50.10 /24` | Client LAN (Passerelle: `192.168.50.1`) |
| **SRV1** | NIC | `10.0.5.10 /24` | Serveur Web (Passerelle: `10.0.5.1`) |
| **ISP** | NIC | `200.1.1.1 /30` | Internet / DNS (Passerelle: `200.1.1.2`) |

---

## 3. Configuration des Équipements (Commandes Cisco IOS)

### 💻 3.1 Configuration de Base et Interfaces du Routeur (R1)
*Ouvrez la CLI du Routeur R1 et collez ces commandes :*

```text
enable
configure terminal
hostname R1-FIREWALL

! Configuration LAN
interface GigabitEthernet0/0
 description *** CONNEXION LAN EMPLOYES ***
 ip address 192.168.50.1 255.255.255.0
 no shutdown
 exit

! Configuration DMZ
interface GigabitEthernet0/1
 description *** CONNEXION DMZ SERVEURS ***
 ip address 10.0.5.1 255.255.255.0
 no shutdown
 exit

! Configuration WAN
interface GigabitEthernet0/2
 description *** LIAISON FAI (INTERNET) ***
 ip address 200.1.1.2 255.255.255.252
 no shutdown
 exit

! Route par defaut vers Internet
ip route 0.0.0.0 0.0.0.0 200.1.1.1
```

### 💻 3.2 Configuration du NAT et du DNAT (R1)
*Pour que le LAN puisse naviguer et que la DMZ soit accessible depuis Internet :*

```text
! Definition des zones NAT
interface GigabitEthernet0/0
 ip nat inside
 exit
 
interface GigabitEthernet0/1
 ip nat inside
 exit
 
interface GigabitEthernet0/2
 ip nat outside
 exit

! ACL pour autoriser le LAN a sortir sur Internet (Masquerade)
access-list 1 permit 192.168.50.0 0.0.0.255
ip nat inside source list 1 interface GigabitEthernet0/2 overload

! DNAT (Port Forwarding) pour le serveur Web Orange
ip nat inside source static tcp 10.0.5.10 80 200.1.1.2 80
```

### 💻 3.3 Sécurisation de Base (ACLs) sur R1
*Blocage de l'accès depuis Internet vers le LAN (Isolation).*

```text
! ACL pour bloquer Internet vers le LAN mais autoriser le retour
ip access-list extended SECURE-WAN
 permit tcp any host 200.1.1.2 eq 80
 deny ip any 192.168.50.0 0.0.0.255
 permit ip any any

interface GigabitEthernet0/2
 ip access-group SECURE-WAN in
 exit
```

---

## 4. Configuration des Machines Finales (Via l'interface graphique de Packet Tracer)

### 🖥️ PC 1 (LAN) :
*   **IP Address** : `192.168.50.10`
*   **Subnet Mask** : `255.255.255.0`
*   **Default Gateway** : `192.168.50.1`

### 🖥️ Serveur SRV 1 (DMZ) :
*   **IP Address** : `10.0.5.10`
*   **Subnet Mask** : `255.255.255.0`
*   **Default Gateway** : `10.0.5.1`
*   **Services > HTTP** : Assurez-vous que HTTP est sur "ON" et modifiez `index.html` pour afficher "PORTAIL ORANGE CAMEROUN".

### 🖥️ Serveur ISP (Internet) :
*   **IP Address** : `200.1.1.1`
*   **Subnet Mask** : `255.255.255.252`
*   **Default Gateway** : `200.1.1.2`

---

## 5. Tests de Validation (Scénarios)

1.  **Sur le PC1 (LAN)**, ouvrez le "Command Prompt" :
    *   `ping 10.0.5.10` (Succès : Le LAN accède à la DMZ).
    *   `ping 200.1.1.1` (Succès : Le LAN accède à Internet).
2.  **Sur le Serveur ISP (Internet)**, ouvrez le navigateur Web :
    *   Tapez l'adresse IP publique : `200.1.1.2` (Le portail Web s'affiche grâce au DNAT).
3.  **Sur le Serveur ISP**, ouvrez le "Command Prompt" :
    *   `ping 192.168.50.10` (Échec : L'ACL bloque l'intrusion vers le LAN).

---
**FIN DU TP 2**. Sauvegardez votre fichier `.pkt`. Cette architecture Cisco est la version matérielle exacte de ce qui sera virtualisé sous Linux dans le TP 3.
