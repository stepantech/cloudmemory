---
title: Nastavení a používání FIDO2 tokenu pro SSH ověření
date: 2025-04-13 17:50:00 +0200
categories: [Personal, Authentication]
tags: [ssh, auth, authentication, macos, linux, tutorial]     # TAG names should always be lowercase
---

Zdroj: [About Using FIDO2 Security Keys for SSH](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)

# [Prereq] Vytvoření NFS share na Synology NAS
- OpenSSH 8.3 nebo novější
- FIDO2 bezpečnostní klíč
- YubiKey Manager (pro nastavení FIDO2 PINu)

# Proč používat FIDO2?
- **Zvýšená bezpečnost**: Soukromý klíč je bezpečně generován a uložen na YubiKey a nelze jej exportovat.
- **Ověření uživatele a přítomnosti**: Poskytuje ověření uživatele pomocí PINu a přítomnosti uživatele prostřednictvím fyzického dotyku.
- **Uživatelské preference nebo politika**: Rozšiřuje stávající použití FIDO2, když je bezpečnostní klíč používán také pro přihlašování do webových aplikací a na desktopu.
  
# Konfigurace SSH klienta
## macOS
```bash
brew install openssh
source ~/.profile

sudo ssh-keygen -t ed25519-sk -O resident -O verify-required -C "Your Comment"
```

## Windows 10/11
Ověř, že je OpenSSH nainstalovaný - [Get started with OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)

Otevří Powershell (jako administrator)
```powershell
ssh-keygen -t ed25519-sk -O resident -O verify-required -C "Your Comment"
```

# Použití existujících klíčů na novém počítači
Připoj FIDO2 token
```bash
cd ~/.ssh
ssh-keygen -K
```

# Importování SSH klíčů 
Zdroj: [ssh-import-id](https://manpages.ubuntu.com/manpages/plucky/en/man1/ssh-import-id.1.html)
Pro jednoduchý import SSH klíčů ze služeb jako Launchpad nebo Github
- Prefix **lp:** znamená, že klíče budou načteny z Launchpadu.
- Alternativně prefix **gh:** způsobí, že nástroj načte klíče z GitHubu.

```bash
ssh-import-id <username-on-remote-service>
```

API dotazy:
```
Launchpad: https://launchpad.net/~%s/+sshkeys
GitHub: https://api.github.com/users/%s/keys
```
