---
title: Seznam používaných aplikací, nástrojů a nastavení v MacOS
date: 2022-11-26 19:26:00 +0200
categories: [Personal, MacOS]
tags: [macos, apps, aplikace, apple]     # TAG names should always be lowercase
---

# Seznam aplikací

| Název | Popis |
| ------- | ------- |
| [Alfred](https://www.alfredapp.com/) | Náhrada za Spotlight, spoštění aplikací, vyhledávání souborů, automatizace skrze Workflows,... |
| [AltTab](https://alt-tab-macos.netlify.app/) | Rychlé přepínání aplikací pomocí klávesové zkratky Alt+Tab s náhledy |
| [balenaEtcher](https://www.balena.io/etcher/) | Flashování SD karet a USB disků |
| [Bitwarden](https://bitwarden.com/) | Správce hesel |
| [CrossOver](https://www.codeweavers.com/crossover) | Virtualizace Windows aplikací na MacOS. Funguje i s aplikací Winbox od Microsoft |
| [DeepL](https://www.deepl.com/translator) | Překladač podobný Google Translator, založený na AI |
| [DisplayLink](https://www.synaptics.com/products/displaylink-graphics/downloads/macos) | Aplikace nutná pro fungování dokovací stanice od i-tec |
| [Docker](https://www.docker.com/) | Spouštění kontejnerových aplikací |
| [Dropzone](https://aptonic.com/) | Nástroj na kopírování a nahrávání souborů do různých úložišť |
| [FileZilla](https://filezilla-project.org/) | FTP klient |
| [IINA](https://iina.io/) | Video přehrávač |
| [KeepassXC](https://keepassxc.org/) | Správce hesel |
| [Microsoft Edge](https://www.microsoft.com/cs-cz/edge/)| Webový prohlížeč |
| [Microsoft Remote Deskotop](https://apps.apple.com/us/app/microsoft-remote-desktop/) | Připojení na vzdálenou plochu, funkční s Azure Virtual Desktop |
| [Microsoft To Do](https://todo.microsoft.com/tasks/) | Jednoduchý správce úkolů |
| [Moom](https://apps.apple.com/us/app/moom/id419330170?mt=12) | Správce oken |
| [Permute 3](https://software.charliemonroe.net/permute/) | Video a audio konvertor |
| [Raspberry Pi Imager](https://www.raspberrypi.com/software/) | Flashování SD karet připravenými image pro Raspberry Pi |
| [Remote Desktop Manager](https://devolutions.net/remote-desktop-manager/) | Správce připojení na vzdálenou plochu, SSH, VNC, ... |
| [Shottr](https://shottr.cc/) | Nástroj na vytváření a úpravu screenshotů |
| [Spotify](https://www.spotify.com/us/download/android/) | Přehrávač streamované hudby a hudební knihovna |
| [Stream Deck](https://www.elgato.com/en/stream-deck) | Aplikace na konfiguraci programovatelné klávesnice od Elgato |
| [TeamViewer](https://www.teamviewer.com) | Vzdálená správa klientských počítačů |
| [Visual Studio Code](https://code.visualstudio.com/) | Editor kódu pro spoutu programovacích jazyků |
| [Warp](https://www.warp.dev/) | Terminal s pokročilejšími funkcemi |


# Seznam Alfred Workflow

| Název                                                                     | Popis                                                     |
|---------------------------------------------------------------------------|-----------------------------------------------------------|
| [CIDR Calculator](https://gilbertsanchez.com/cidr-calculator-for-alfred/) | Výpočet masky sítě, počtu hostů, první a poslední IP, ... |
| [EDGE Fix](https://github.com/stepantech/terminal/blob/main/Alfred%20Workflows/Edge%20-%20Fix%20Cert.alfredworkflow) | Vloží příkaz do EDGE konzole pro potlačení nedůvěryhodného certifikátu |
| [Visual Studio Code Workspace](https://github.com/stepantech/terminal/blob/main/Alfred%20Workflows/Visual%20Studio%20Code%20Workspace.alfredworkflow) | Nabídne seznam všech projektů a nabídne je k rychlému otevření |


# PowerShell
## PowerShell PROFILE
[Stažení profilového souboru](https://github.com/stepantech/terminal/tree/main/PowerShell/)

## PowerShell moduly
### Az Predictor
[Doku](https://learn.microsoft.com/en-us/powershell/azure/az-predictor?view=azps-9.3.0)

## Oh-my-posh Theme
Theme pro PowerShell prompt [Oh-my-posh](https://ohmyposh.dev/)
[Stažení šablony](https://github.com/stepantech/terminal/tree/main/PowerShell/Theme)

# ZSH profil a funkce

[Stáhnout soubory](https://github.com/stepantech/cloudmemory/tree/main/assets/others/zsh)

# Konfigurace Terminálu
## Ověřování v terminálu pomocí TouchID
Edituj soubor **/etc/pam.d/sudo** a pod řádek 

```zsh
#sudo: auth account password seassoin
```
přidej řádek:
``` zsh
auth    sufficient pam_tid.so
```