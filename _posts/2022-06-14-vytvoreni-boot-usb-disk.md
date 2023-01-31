---
title: Vytvoření bootovacího USB disku
date: 2022-06-14 13:35:00 +0200
categories: [Tools, Utils]
tags: [usb disk, boot, rufus, iso, terminal, macos ]     # TAG names should always be lowercase
---

Postup jak vytořit bootovací USB disk z ISO souboru.

## Vylistování dostupnných disků
Identifikuj a poznamenej si číslo USB disku např. /dev/disk4
```zsh
diskutil list
```

## Unmount USB disku (příkaz je case-sensitive)
```zsh
diskutil umountDisk <označení disku>

diskutil unmountDisk /dev/disk4
```

## Vytvoření bootovacího disku z ISO
*vytvoření disku může trvat i několik desítek minut*
```zsh
sudo dd if=<cesta k ISO souboru> of=<označení disku> bs=1m

sudo dd if=/Users/petrs/Downloads/Windows10_21H2.iso of=/div/disk4 bs=1m
```

## Odpojení USB disku
```zsh
diskutil eject <označení disku>
```