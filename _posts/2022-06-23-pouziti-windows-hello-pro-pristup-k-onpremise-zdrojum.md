---
title: Použití Windows Hello pro přístup k on-premise zdrojům
date: 2022-06-23 10:04:00 +0200
categories: [Azure, Bezpečnost]
tags: [aad, azure active directory, sso, windows hello, on-premise, authentikace ]     # TAG names should always be lowercase
---

Zdroj:[MS Docs | Úvod](https://docs.microsoft.com/en-us/windows/security/identity-protection/hello-for-business/hello-hybrid-aadj-sso)
[MS Docs | Konfigurace](https://docs.microsoft.com/en-us/windows/security/identity-protection/hello-for-business/hello-hybrid-aadj-sso-base)
[YouTube | Intune Training - Using Windows Hello for Business to Access On-Premises Resources](https://www.youtube.com/watch?v=GfYOyFMc8vA)

Ověřování uživatele v on-premise prostředí je možné vyřešit certifikátem a nebo key setem, tento návod se bude zabívat pouze metodou key set.

# Prerequisites
* Nakonfigurovaný Azre AD Connect
* Windows Server Schema 2016 a novější
* Nakonfigirovaná interní Certifikační Autorita
* Veřejně dostupný CRL Distribution Point (CDP)

# Konfigurace Azure AD Connect
Azure AD Connect -> Tasks -> Change User sign-in
1) Zapnout Password Hash Syncronization
2) Enable single sign-on

![Konfigurace Azure AD Connect](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-AzureADConnect.jpg)

## Přidání servisního účtu do skupiny Key Admins
1) Servisní účet např. MSOL_666b89efcb6e přidat do Security group **Key Admins**
![Key Admins](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-KeyAdmins.jpg)

### [Optional] Nalezení servisního účtu
1) Spustit Azure AD Connect - Synchronization Service -> Conectors
2) Vyber lokální doménu -> Properties -> Connect to Active Directory Forest
![Servisní účet synchronizace](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-AzureADConnectSvcAccount.jpg)

# Konfigurace Windows Hello na tenantu
endpoint.microsoft.com -> Devices -> Windows enrollment -> Windows Hello for Business

Zapnout Windows Hello

![Konfigurace Windows Hello](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-KonfiguraceWindowsHello.jpg)

# Konfigurace CRL Distribution Point
## Instalace IIS
1) Instalace se provádí standardní cestou, v Security musí být povoleno Basic Authentication, Digest Authentication, Windows Authentication
![Instalace IIS](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-crl-iis.jpg)

## Vytvoření úložiště CDP
1) Vytvoř složku např. C:\cdp
2) Nasdílej složku jako skrytou (přidat $ za jméno)
![Vytvoření sdílené složky](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-cdpSdilenaSlozka.jpg)
3) Nastav oprávnění sdílení Full Permissions pro objekt Computer, kde je nainstalováno CA
![Oprávnění sdílené složky](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-sdilenaSlozkaOpravneni.jpg)
4) Stejným způsobem nastav NTFS oprávnění

## Publikování CDP složky
1) Otevři Internet Information Services (IIS) Manager -> pravé tlačítko myši na Default Web Site -> Add Virtual Directory
![Oprávnění sdílené složky](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-publikovaniCDP.jpg)
2) Vyplň alias např. cdp a cestu ke sdílené složce

## Povolení Directory Browsing
1) Klikni na Default Web Site -> Directory Browsing (dvoj klik) -> Enable
![Povolení Directory Browsing](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-povoleniDirectoryBrowsing.jpg)
2) V IIS manažeru klikni na nový virtuální adresář cdp -> Configuration Editor -> Vyber sekci system.webServer/security/requestFiltering -> allowDoubleEscaping = True -> Apply
![Povolení dvojtých uvozovek](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-povoleniDvojtychUvozovek.jpg)
3) Funkčnost otestuj otevřením adresy [http://localhost/cdp/](http://localhost/cdp/) měl bys vidět web.config soubor

# Konfigurace Certifikační Autority
## Konfigurace KDC šablony
1) Otevři konzoli Certifikační Autority -> pravé tlačítko myši na Certificate Templates -> Manage
2) Najdi Kerberos Authentication -> pravé tlačítko myši -> Duplicate Template
![Vytvoření nové šablony certifikátu](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-DuplicateTemplate.jpg)
3) Záložka General - změň Template display name
4) Záložka Compatibility nastav Compatibility Settings na Windows Server 2012
![Konfigurace Compatibility](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-DuplicateTemplate-Compatibility.jpg)
5) Nastav Cryptography
![Konfigurace Cryptography](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-DuplicateTemplate-Cryptography.jpg)
6) Karta Superseded Templates přidej Domain Controller, Domain Controller Authentication, Kerberos Authentication
![Konfigurace Superseded Templates](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-DuplicateTemplate-SupersededTemplate.jpg)
7) Apply -> OK

## Přidání šablony na vystavení nového typu certifikátu
1) Certification Autority console -> pravé tlačítko myši na Certificate Templates -> New -> Certificate Template to Issue
2) Vyber nově vytvořený teplate např. "Kerberos Authentication KeySet" -> OK

## Smazání původních verzí šablon certifikátů
1) Certification Autority console -> Certificate Templates -> označit Domain Controller, Domain Controller Authentication, Kerberos Authentication -> Smazat
![CA odmazání původních šablon](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-DuplicateTemplate-OdmazaniSablon.jpg)

## Konfigurace Extensions
1) Certification Autority console -> pravé tlačítko myši na název CA -> Properties -> Záložka Extensions
2) Select extension: CRL Distribution Point -> Add...
3) Location: http://cdp.azure.tslab.cz/cdp/\<CaName>\<CRLNameSuffix>\<DeltaCRLAllowed>.crl -> OK
4) Vyber nově přidanou lokaci a zaškrtni **Include in CRLs** ... a **Include in the CDP** ...
![Konfigurace CRL cesty](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-crlLocation.jpg)
5) Location: \\\dc01\cdp$\\<CaName>\<CRLNameSuffix>\<DeltaCRLAllowed>.crl -> OK
6) Vyber nově přidanou lokaci a zaškrtni **Publish CRLs** ... a **Publish Delta CRLs** ...
![Konfigurace CRL cesty](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-crlLocation2.jpg)
7) Apply -> Restart Active Directory Certificate Services -> Yes

## Zveřejnění CLR listu
1) Certification Autority console -> pravé tlačítko myši na název Revoked Certificates -> All Tasks -> Publish
2) New CRL -> OK
![Publikování CRL](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-publishCRL.jpg)

# Přegenerování certifikátů pro doménové kontrolery
1) Přihlaš se na DC server a spusť Správce certifikátů pro Lokální počítač (certlt.msc)
2) Personal -> Certificates -> smaž certifikát vystavený pro DC server - např. Issued To: DC01.test.local
3) pravé tlačítko myši na Personal - Certificates -> All Tasks -> Request New Certificate
4) Next -> Active Directory Enrollemt Policy - Next -> zaškrtnout šablonu pro Kerberos certifikát s KeySet atributem -> Enroll
![Vystavení certifikátu pro DC](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-dcEnrollCert.jpg)
5) Vystavený certifikát musí obsahovat Key Usage - KDC Authentication a správnou cestu k CRL Distribution Points
![Ověření certifikátu](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-dcCertOvereni.jpg)
![Ověření certifikátu CDP](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-dcCertOvereniCDP.jpg)




# Distribuce CA certifikátu na stanice
## Export CA certifikátu
1) na DC serveru spusť certlm.msc (Cert Manager Local Machine) -> Personal -> Certificates -> Najdi certifikát DC serveru a v Certification Path vyber certifikát CA ->  View Certificate
![Export CA certifikátu](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-CAexportCert.jpg)
2) Záložka Details -> Copy to File ...
3) Vybrat formát certifikátu DER encoded binary X.509
4) Vyplnit název certifikátu

## Vytvoření Intune politiky pro import certifikátů do stanic
1) endpoint.microsoft.com -> Devices -> Configuration profiles -> Create profile
![Vytvoření Configuračního profilu pro inport CA certifikátu](/assets/img/pouziti-windows-hello-pro-pristup-k-onpremise-zdrojum-CA-import-policy.jpg)

2) Vyplň jméno a popis
3) Vyber vyexportovaný certifikát a Desrtination store: Computer certificate store - Root
4) Na záložce Assigments vyber skupinu zařízení, kterým bude profil přiřazený

