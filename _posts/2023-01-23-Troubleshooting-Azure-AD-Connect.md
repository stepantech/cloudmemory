---
title: Troubleshooting Azure AD Connect
date: 2023-01-23 18:12:00 +0200
categories: [Azure, Azure AD]
tags: [azure, azure ad, azure ad connect, troubleshooting ]     # TAG names should always be lowercase
---

Zdroj: [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-install-existing-tenant)

V případě již existujících účtů v Azure AD, po první instalace Azure AD Connect je potřeba spárovat on-prem účty a clodové účty. Spárování se nejprve provádí skrze soft-match, pokud tento způsob nezafunguje, je potřeba provést hard-mach.

## Soft-mach
Spáruje účty na základě upn a primární emailové adresy (SMTP:) v atributu proxyAddresses. V on-prem i cloudové prostředí musí být tyto hodnoty shodné. Pokud nejsou, je potřeba pomocí Atribut Editoru v AD parametry upravit.

> Pokud Soft-match nefubguje, nejprve zkontroluj, že není zakázaný na úrovni tenantu [BlockSoftMatch](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-syncservice-features#blocksoftmatch)

## Hard-match
V případě, že soft-match nezafunguje a nespáruje uživatelské identity, je možné vygenerovat **immutableid**, který slouží jako jedinečný identifikátor a pomocí PowerShell tuto hodnotu nahrát do Azure AD k identitě, která má problémy se synchronizací.

### Příkazy

Potřebné moduly jsou **AzureAD** a **ActiveDirectory**, ty v případě potřeby nainstaluj příkazy:
```powershell
Install-Module -Name AzureAD
Add-WindowsCapability –online –Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
```

Připojení do Azure AD
```powershell
Connect-AzureAD
```

Vygenerování immutableid
```powershell
$guid = (Get-ADUser -Filter 'UserPrincipalName -eq "<upn uživatele>"').ObjectGUID
$immutableid=[System.Convert]::ToBase64String($guid.tobytearray())
```

Uložení immutableid k objektu uživatele nebo mail enabled skupiny
```powershell
Set-AzureADUser -ObjectID <upn uživatele> -ImmutableId $immutableid
```

Výpis immutableid konkrétního uživatele
```powershell
Get-AzureADUser -ObjectID <upn uživatele> | Where-Object {$_.immutableid -eq $immutableid} | fl UserPrincipalName, immutableid
```

Výpis uživatele s immtableid
```powershell
Get-AzureADUser | Where-Object {$_.immutableid -eq $immutableid} | fl UserPrincipalName, immutableid
```

Vymazání immutableid hodnoty
```powershell
Get-AzureADUser -ObjectID <upn uživatele>  | Where-Object {$_.immutableid -eq $immutableid} | Set-AzureADUser -ImmutableId $null
```
