---
title: Vypnutí hesla pro SUDO příkaz
date: 2025-04-13 19:26:00 +0200
categories: [Linux]
tags: [linux, sudo, authorization, password, tutorial]     # TAG names should always be lowercase
---

Pro vypnutí požadavku na zadání hesla při použití SUDO příkazu pro konkrétního uživatele

```bash
sudo visudo

# na konec souboru přidat řádek, kde $USER je uživatel, pro kterého chceme heslo vypnout
$USER ALL=(ALL) NOPASSWD: ALL
```

Funkčnost můžeš ověřit příkazem
```bash
sudo -i
```
