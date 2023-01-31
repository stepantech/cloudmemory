---
title: Vyčištění DNS cache na macOS
date: 2022-06-23 16:07:00 +0200
categories: [Stanice, Tools]
tags: [macos, osx, terminal, dns, cache]     # TAG names should always be lowercase
---

```zsh
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```