---
title: Mikrotik SSTP site-to-site vpn
date: 2022-06-18 14:25:00 +0200
categories: [Networking, Mikrotik]
tags: [mikrotik, vpn, s2s, sstp ]     # TAG names should always be lowercase
---

Zdroj:[systemzone.net](https://systemzone.net/mikrotik-site-to-site-sstp-vpn-setup-with-routeros-client/)

Konfigurace site-to-site VPN mezi dvěma Mikrotiky.

## Vytvoření TLS certifikátů pro SSTP server
Potřebuješ 2 ceritikáty:
* CA
* Server certifikat

### Vytvoření CA certifikatu
System -> Certificates -> (+)

Název certifikátu CA, vyplň všechny položky jako Country, State, Location, ...

Do **Common Name** a **Subject Alt. Name IP** zadej veřejnou IP adresu routeru.

Nezapomeň změnit platnost certifikátů.

![Konfiguace CA certifikátu](/assets/img/mikrotik-s2s-vpn-ca.jpg)

![Konfiguace CA certifikátu Key Usage](/assets/img/mikrotik-s2s-vpn-ca-key-usage.jpg)

#### Podpis CA certifikátu
Otevři nově vytvořený CA certifikát a klikni na **Sign** tlačítko. Potom vyplň veřejnou adresu do **CA CRL Host**. Certifikát se podepíše po stisknutí tlačítka **Start**.

![Podpis CA certifikátu](/assets/img/mikrotik-s2s-vpn-ca-sign.jpg)

### Vytovření Server certifikátu
>**ProTip:** CA certifikát je možné zkopírovat tlačítkem **Copy** a není potřeba vše vypisovat znovu, pouze změnit Key Usage

Název certifikátu CA, vyplň všechny položky jako Country, State, Location, ...

Do **Common Name** a **Subject Alt. Name IP** zadej veřejnou IP adresu routeru.

![Konfiguace CA certifikátu](/assets/img/mikrotik-s2s-vpn-server.jpg)

![Konfiguace CA certifikátu Key Usage](/assets/img/mikrotik-s2s-vpn-server-key-usage.jpg)

#### Podpis Server certifikátu
Otevři nově vytvořený Server certifikát a klikni na **Sign** tlačítko. Potom vyber certifikační autoritu a klikni na tlačítko **Start**.

![Podpis Server certifikátu](/assets/img/mikrotik-s2s-vpn-server-sign.jpg)

Po podpisu certifikátu zaškrtni **Trusted** a potom Apply.

Po vytvoření by certifikáty měly mít tyto atributy:
![Podpis Server certifikátu](/assets/img/mikrotik-s2s-vpn-cert-overview.jpg)

## Konfigurace SSTP serveru
PPP -> Interface -> SSTP server
![Konfigurace SSTP serveru](/assets/img/mikrotik-s2s-vpn-konfigurace-sstp-serveru.jpg)

### Vytoveření přístupových údajů
PPP -> Secret -> (+)

Routy se zapisují ve tvaru:

\< vzdálený subnet \> \< gateway pro tento subnet \> \< distance \>

192.168.1.0/24 172.16.0.2 1

![Konfigurace SSTP serveru](/assets/img/mikrotik-s2s-vpn-secret.jpg)

## Konfigurace SSTP klienta
PPP -> Interface -> (+) -> SSTP Client

![Konfigurace SSTP klienta](/assets/img/mikrotik-s2s-vpn-konfigurace-sstp-klienta.jpg)

Následně přidej routu pro vzdálené sítě

![Konfigurace SSTP klienta routy](/assets/img/mikrotik-s2s-vpn-sstp-klient-routa.jpg)

