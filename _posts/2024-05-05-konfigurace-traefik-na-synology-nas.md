---
title: Konfigurace Traefik na Synology NAS
date: 2024-05-05 19:51:18 +0200
categories: [Homelab, Docker]
tags: [homelab, docker, opensource, synology, proxy, tutorial]     # TAG names should always be lowercase
---

Tento návod popisuje jak nakonfigurovar reverzní proxy server Traefik na NAS Synology.

# [Prereq] Instalace Docker na Synology NAS
1) Přihlas se do administrace NAS
2) Otevři **Package Center**
3) Najdi a nainstaluj balíček **Container Manager**

![Container Manager](/assets/img/2024-05-05-container-manager.png)

# Konfigurace síťového rozhraní
Ve výchozím nastavení, po nainstalování **Container Manager** sdílejí docker kontejnery stejnou IP adresu, jako samotný NAS. Problém je v kolizi portů, protože port 80 a 443 využívá NAS pro portál administrace. Řešením je vytvořit pro docker virtuální interface pomocí [MAC VLAN Driveru](https://docs.docker.com/network/drivers/macvlan/)

## Identifikace aktivního interface
```bash
  ip link
```
Aktivní interface může mít několik podob:
- ovs_ethX ... v případě, pokud se používá Virtual Machine Manager
- bond0 ... pokud je nastavený bonding skrze více interface
- ethX ... pokud se používá pouze jeden interface

V tomto příkladě je aktivní interface **bond0**
![ip link](/assets/img/2024-05-05-ip-link.png)

## Vytvoření macvlan0 interface
```bash
  sudo ip link add macvlan0 link bond0 type macvlan mode bridge
  sudo ip addr add 10.0.1.20/30 dev macvlan0
  sudo ip link set macvlan0 up
```

10.0.1.20/30 přídělí tomuto interface ip adresy v rozsahu 10.0.1.20-23, ověřit nebo navrhnout jiný rozsah je možné pomoci [IP kalkukačky](https://www.ipaddressguide.com/cidr)


## Přidání route
Route je potřeba přidat, aby kontejnery běžící v Synology věděly, kde traefik hledat
```bash
  sudo ip route add 10.0.1.20/30 dev macvlan0
```

# Automatické vytvoření interface po restartu NAS serveru
Po restartu NAS je potřeba macvlan0 interface znovu vytvořit. Ideální je k tomu **Task Scheduler**. Nejprve je potřeba vytvořit script soubor s obsahem:
## Vytvoření scriptu
```sh
  ## get interface name (ovs_eth0 below) via ip link
  ip link add macvlan0 link bond0 type macvlan mode bridge
  ##10.0.1.20/30 (20-203)
  ip addr add 10.0.1.20/30 dev macvlan0
  ip link set macvlan0 up
  ip route add 10.0.1.20/30 dev macvlan0
```
Soubor si vytvoř a pojmenuj [macvlan_setup.sh](/assets/2024-05-05/macvlan_setup.sh) nebo stáhni. Soubor nakopíruj na NAS např. do cesty /volume1/scripts a nezapomeň scriptu přidat oprávnění ke spuštění
```bash
  chmod +x /volume1/scripts/macvlan_setup.sh
```

## Vytvoření Task Scheduleru
Control Panel -> Task Scheduler -> Create -> Triggered tasks -> User-defined script
![Create task](/assets/img/2024-05-05-create-task-1.png)

**User** musí být **root** jinak script nebude mít dostatečná oprávnění
**Event** vyber **Boot**

Do user-defined command zadej příkaz:
```bash
  bash /volume1/scripts/macvlan_setup.sh
```
![Create Task](/assets/img/2024-05-05-create-task-2.png)

Po restartování NAS se macvlan0 interface znovu vytvoří a nastaví:
![Výpis interface](/assets/img/2024-05-05-macvlan-overeni.png)