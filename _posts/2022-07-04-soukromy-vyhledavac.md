---
title: Soukromý vyhledávač
date: 2022-07-04 20:13:00 +0200
categories: [Homelab, Sites]
tags: [homelab, sites, opensource, vyhledavac, searcher, google tutorial]     # TAG names should always be lowercase
---

Popis instalce soukromého vyhledávače ala Google, Bing, DuckDuckGo, atd.

Zdroj: [Github projektu](https://github.com/searx/searx)

# Doker instalace
```yml
version: "3"

services:
  searx:
    container_name: searx
    image: searx/searx:latest
    ports:
      - "85:8080/tcp"
    environment:
      BASE_URL: 'https://s.stepan.tech'
    volumes:
      - '../../volumes/searx/searx:/etc/searx'
    restart: unless-stopped
```
