---
title: Stahování videí z YouTube
date: 2022-06-13 17:03:00 +0200
categories: [Tools, Multimedia]
tags: [youtube, video, downloader, tool, yt-dl, youtube-dl]     # TAG names should always be lowercase
---

Nástroj na stahování videí v různé kvalitě nebo celých playlistů z YouTube. Nástroj se jmenuje **YouTube-dl** a je možné ho stáhnout na GizHub stránce projektu (YouTube-dl)[https://github.com/ytdl-org/youtube-dl]
YouTube Download 

## Příklady příkazů
Stažení videa v nejlepší kvalitě obrazu i zvuku
```zsh
youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' <url>
```