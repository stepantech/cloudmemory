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
## Vytvoření Azure Static App

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

## Úprava GitHub Action Workflow
Zdroj:  (drew learns cloud)[https://www.drewlearnscloud.blog/jekyll] 
        (GitHub | aarreza)[https://github.com/aarreza/drewlearnscloudblog/blob/master/.github/workflows/azure-static-web-apps-proud-forest-0b3b9590f.yml]
1. Po vytvoření Azure Static App dojde k vytvoření yml souboru v cestě .github/workflows/
2. Otevři .yml soubor a změň:
    ```yml
    branches:
        - main
    ```

    ```yml
    app_location: "/_site"
    api_location: ""
    output_location: ""
    ```
3. Mezi řádky 
    ```yml
    - uses: actions/checkout@v2
        with:
          submodules: true
    ```
    a
    ```yml
    - name: Build And Deploy
        id: builddeploy
        uses: Azure/static-web-apps-deploy@v1
        with:
    ```

    vlož
    ```yml
    - name: Set up Ruby
        uses: actions/setup-ruby@v1
        with:
          ruby-version: 3.0
    - name: Install dependencies
        run: bundle install
    - name: Jekyll build
        run: jekyll build
    ```

### Příklad yml souboru
```yml
name: Azure Static Web Apps CI/CD

on:
  push:
    branches:
      - main
  pull_request:
    types: [opened, synchronize, reopened, closed]
    branches:
      - main

jobs:
  build_and_deploy_job:
    if: github.event_name == 'push' || (github.event_name == 'pull_request' && github.event.action != 'closed')
    runs-on: ubuntu-latest
    name: Build and Deploy Job
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true
      - name: Set up Ruby
        uses: actions/setup-ruby@v1
        with:
          ruby-version: 3.0
      - name: Install dependencies
        run: bundle install
      - name: Jekyll build
        run: jekyll build
      - name: Build And Deploy
        id: builddeploy
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN_LEMON_FOREST_065C33903 }}
          repo_token: ${{ secrets.GITHUB_TOKEN }} # Used for Github integrations (i.e. PR comments)
          action: "upload"
          ###### Repository/Build Configurations - These values can be configured to match your app requirements. ######
          # For more information regarding Static Web App workflow configurations, please visit: https://aka.ms/swaworkflowconfig
          app_location: "/_site" # App source code path
          api_location: "" # Api source code path - optional
          output_location: "" # Built app content directory - optional
          ###### End of Repository/Build Configurations ######

  close_pull_request_job:
    if: github.event_name == 'pull_request' && github.event.action == 'closed'
    runs-on: ubuntu-latest
    name: Close Pull Request Job
    steps:
      - name: Close Pull Request
        id: closepullrequest
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN_LEMON_FOREST_065C33903 }}
          action: "close"
```

# První příspěvek
Návod, jak napsat první příspěvek [Writing a New Post](https://chirpy.cotes.page/posts/write-a-new-post/)

# 