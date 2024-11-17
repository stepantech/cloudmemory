---
title: Instalace a konfigurace reverzní proxy Traefik na RockyLinux
date: 2024-11-16 21:35:00 +0200
categories: [Homelab, Docker]
tags: [homelab, docker, opensource, rockylinux, proxy, tutorial]     # TAG names should always be lowercase
---

# [Prereq] Vytvoření docker network
```bash
# Výpis aktuálních sítí
docker network ls

# Vytovření sítě frontend
docker network create frontend
```

# Instalace a konfigurace
docker-compose.yaml
```bash 
---
services:
  traefik:
    image: traefik:v3.1.7
    container_name: traefik
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config/traefik.yml:/etc/traefik/traefik.yml:ro 
    networks:
      - frontend
    restart: unless-stopped
networks:
  frontend:
    external: true
```

Ve stejné složce jako je **docker-compose.yaml** vytvoř složku **config** a vní soubor **traefik.yml**
```bash
mkdir config
```

traefik.yml
```bash
global:
  checkNewVersion: false
  sendAnonymousUsage: false
log:
  level: DEBUG
api:
  dashboard: true
  insecure: true
entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
```

# Ověření funkčnosti
[http://ip-adresa-serveru:8080](http://<server-ip>:8080)

# Konfigurace HTTPS & TLS (Let's Encrypt)
Přidám volume, kam se budou certifikáty ukládat
>!!! Je nezbytné vytvořit složku **data** i podsložku **certs** jinak se Traefik spustí s chybou HTTP challenge is not enabled 

docker-compose.yaml
```bash
---
services:
  traefik:
    image: traefik:v3.1.7
    container_name: traefik
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config/traefik.yml:/etc/traefik/traefik.yml:ro
      - ./data/certs/:/var/traefik/certs/:rw
    networks:
      - frontend
    restart: unless-stopped
networks:
  frontend:
    external: true
```

Do konfiguračního souboru přídej konfiguraci **certificatesResolvers**

traefik.yml
```bash
global:
  checkNewVersion: false
  sendAnonymousUsage: false
log:
  level: DEBUG
api:
  dashboard: true
  insecure: true
entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"
certificatesResolvers:
  letsencrypt:
    acme:
      email: petr@stepan.tech
      storage: /var/traefik/certs/acme-prod.json
      httpChallenge:
        entryPoint: web
  staging:
    acme:
      email: petr@stepan.tech
      storage: /var/traefik/certs/acme-staging.json
      caServer: https://acme-staging-v02.api.letsencrypt.org/directory
      httpChallenge:
        entryPoint: web
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
```

Staging je vhodný na testování a prvotní konfiguraci, vystaví nevěrohodný certifikát ale neaplikuje se limit na počet vystavených certifikátů za den.

## Ověření funkčnosti
Vytvoř si testovací kontejner
docker-compose.yaml
```bash
---
services:
  ngnix-demo:
    image: nginx:latest
    container_name: ngnix-demo
    labels:
      - traefik.enable=true
      - traefik.http.routers.ngnix-http.rule=Host(`ngnix-demo.stepan.tech`)
      - traefik.http.routers.ngnix-http.entrypoints=web
      - traefik.http.routers.ngnix-https.tls=true
      #- traefik.http.routers.ngnix-https.tls.certresolver=letsencrypt
      - traefik.http.routers.ngnix-https.tls.certresolver=staging
      - traefik.http.routers.ngnix-https.entrypoints=websecure
      - traefik.http.routers.ngnix-https.rule=Host(`ngnix-demo.stepan.tech`)
    networks:
      - frontend
    restart: unless-stopped
networks:
  frontend:
    external: true
```

# Přesměrování z http na https
Uprav sekci **entryPoints**
traefik.yaml
```bash
entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
```