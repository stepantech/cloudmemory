---
title: Zrození CloudMemory
date: 2022-06-09 21:54:36 +0200
categories: [Homelab, Sites]
tags: [homelab, sites, opensource, jekyll, static page, tutorial]     # TAG names should always be lowercase
---

CloudMemory je stránka postavená na opensource projektu [Jekyll](https://jekyllrb.com/). Jekyll je generátor statických webových stránek z markdown souborů, které mohou být hostovány kdekoliv, včetně GitHub.

# [Prereq] Instalace Ruby a RubyGems
Zdroj: [Jekyll | Installation](https://jekyllrb.com/docs/installation/)

## macOS
Instalace Homebrew
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Instalace chruby a ruby-install
```zsh
brew install chruby ruby-install
```

Instalace poslední stable verze Ruby
```zsh
ruby-install ruby
```

Konfigurace shellu, aby automaticky používal chruby
```zsh
echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby ruby-3.1.1" >> ~/.zshrc
```

Instalace Jekyll
```zsh
gem install jekyll
```

# Instalace šablony Chirpy pro Jekyll
Zdroj: [Chirpy Jekyll Theme](https://github.com/cotes2020/jekyll-theme-chirpy)

## Vytvoření nové stránky
Nejprve vytvoř nové repository na Github, spuštěním [Chirpy starteru](https://github.com/cotes2020/chirpy-starter/generate)

## Naklonování repozitáře do počítače
```zsh
git clone https://github.com/<username>/<repo_name>.git
```

## Instalace závislosti
Před prvním spuštěním projektu je potřeba nejprve nainstalovat závislosti, v rootu projektu spusť příkaz:
```zsh
bundle
```

## Konfigurace stránky
Konfigurace se provádí vyplněním hodnot v souboru **_config.yml**

## Spuštění lokální verze
### a) Lokální počítač
V rootu projektu spustit příkaz
```zsh
bundle exec jekyll s
```

### b) Docker verze
```zsh
docker run -it --rm \
    --volume="$PWD:/srv/jekyll" \
    -p 4000:4000 jekyll/jekyll \
    jekyll serve
```
Následně otevři stránku [http://localhost:4000](http://localhost:4000)


# Customizace stránky
## Změna Favicon
Zdroj: [Chirpy | Docu](https://chirpy.cotes.page/posts/customize-the-favicon/)

Připrav si PNG, JPG nebo SVG obrázek o rozměrech minimálně 512 x 512 pixelů. 

Bež na webou stránku [Real Favicon Generator](https://realfavicongenerator.net/)

Klikněte na tlačítko <kbd>Select your Favicon image</kbd>, není potřeba měnit žádné nastavení. Ve spodní části stránky klikni na <kbd>Generate your Favicons and HTML code</kbd> a stáhni ZIP soubor.

Rozbal ZIP soubor a odmaž tyto soubory:
* browserconfig.xml
* site.webmanifest

Zbylé souboru nakopíruj do projektu do složky **assets/img/favicons/**. Pokud složky ještě neexistují, je potřeba je nejprve vytvořit.

# Publikování stránky
## Azure Static App

1. Přihlaš se do [Azure Portalu](https://portal.azure.com)
2. Marketplace -> Static Web App
3. Vyplnit název, resource group, plan type, region, přihlásit se do GitHub
4. Vybrat Build detail: Custom
5. App location: /
6. Api location: nechat prázdné
7. Output location: _site

![img-description](/assets/img/zrozeni-cloudmemory-1.jpg)
![img-description](/assets/img/zrozeni-cloudmemory-2.jpg)
_Vytvoření statické stránky_

# První příspěvek
Návod, jak napsat první příspěvek [Writing a New Post](https://chirpy.cotes.page/posts/write-a-new-post/)
