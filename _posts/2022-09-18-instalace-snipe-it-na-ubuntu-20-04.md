---
title: Instalace Snipe-IT na Ubuntu 20.04
date: 2022-09-18 20:00:00 +0200
categories: [Applications, Asset management]
tags: [asset management, open source]     # TAG names should always be lowercase
---

## Instalace Apache serveru
```zsh
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install apache2 -y
```

Spuštění aplikace Apache a nastavení spuštění po startu serveru
```zsh
sudo systemctl start apache2 && systemctl enable apache2
```

Povolení portů ve firewall
```zsh
sudo ufw allow 'Apache Full'
sudo ufw reload
```

Povolení modulu mod_rewrite
```zsh
sudo a2enmod rewrite
sudo systemctl restart apache2
```

## Instalace PHP 7.4
```zsh
sudo apt-get install php php-bcmath php-bz2 php-intl php-gd php-mbstring php-mysql php-zip php-opcache php-pdo php-calendar php-ctype php-exif php-ffi php-fileinfo php-ftp php-iconv php-intl php-json php-mysqli php-phar php-posix php-readline php-shmop php-sockets php-sysvmsg php-sysvsem php-sysvshm php-tokenizer php-curl php-ldap -y
```

## Instalace PHP Composer
PHP Composer je nástroj na instalaci a správu závislostí PHP knihoven
```zsh
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

## Instalace MariaDB
```zsh
sudo apt-get install mariadb-server mariadb-client -y
```

Spuštění aplikace MariaDB a nastavení spuštění po startu serveru
```zsh
sudo systemctl start mariadb && systemctl enable mariadb
```

Konfigurace zabezpečení databázového serveru
```zsh
sudo mysql_secure_installation
```

```zsh
Enter current password for root (enter for none): <enter>
Set a root password? [Y/n]: y
Remove anonymous users? : y
Disallow root login remotely? : y
Remove test database and access to it? : y
Reload privilege tables now? : y
```

### Založení databáze pro Snipe-IT
Přihlášení do databázového serveru
```zsh
sudo mysql -u root -p
```

Vytvoření DB. Hodnotu ZMEN_HESLO nahraď vlastním heslem, možné je změnit i uživatelské jméno snipe_it_user
```sql
CREATE DATABASE snipe_it;
CREATE USER 'snipe_it_user'@'localhost' IDENTIFIED BY 'ZMEN_HESLO';
GRANT ALL PRIVILEGES ON snipe_it.* TO 'snipe_it_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## Instalace Snipe-IT
Otevři složku webového serveru
```zsh
cd /var/www/
```

Stažení aplikace z repozitáře
```zsh
sudo git clone https://github.com/snipe/snipe-it snipe-it
```

Otevři staženou složku, vytvoř konfigurační soubor a otevři ho pro editaci
```zsh
cd /var/www/snipe-it
sudo cp /var/www/snipe-it/.env.example /var/www/snipe-it/.env
sudo nano /var/www/snipe-it/.env
```

Uprav následující proměné
```zsh
APP_URL=snipeit.domena.cz
APP_TIMEZONE='Europe/Prague'

DB_PORT=3306
DB_DATABASE=null
DB_USERNAME=null
DB_PASSWORD=null
```

### Změna oprávnění na Snipe-IT složce
```zsh
sudo chown -R www-data:www-data /var/www/snipe-it
sudo chmod -R 755 /var/www/snipe-it
```

### Instalace Snipe-IT závislostí pomocí Composer
```zsh
composer update –no-plugins –no-scripts
composer install --no-dev --prefer-source
```

### Vygenerování APP_key
Příkaz vygeneruje APP_key a uloží ho do souboru /var/www/snipe-it/.env
```zsh
php artisan key:generate
```

### Vytvoření Virtual Host File
Zakázání výchozí konfigurace
```zsh
sudo a2dissite 000-default.conf
```

Vytvoření nového Apache config file
```zsh
sudo nano /etc/apache2/sites-available/snipe-it.conf
```

```zsh
<VirtualHost *:80>
ServerName example.com
ServerAlias www.example.com
DocumentRoot /var/www/snipe-it/public
<Directory /var/www/snipe-it/public>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
allow from all
</Directory>
</VirtualHost>
```

Povolené nové konfigurace
```zsh
sudo a2ensite snipe-it.conf
sudo systemctl restart apache2
```

Otevři URL webového serveru a dokonči instalaci v prohlížeči.


## Instalace CERTBOT a konfigurace https
```zsh
sudo apt-get install certbot python3-certbot-apache -y
```

### Získání certifikátu
```zsh
sudo certbot --apache
```

Pokračuj podle instrukcí průvodce...

### Ověření naplánování obnovy certifikátu
```zsh
sudo systemctl status certbot.timer
```

Příklad výstupu:
```zsh
Output
● certbot.timer - Run certbot twice daily
     Loaded: loaded (/lib/systemd/system/certbot.timer; enabled; vendor preset: enabled)
     Active: active (waiting) since Sun 2022-09-18 20:12:54 UTC; 15min ago
    Trigger: Mon 2022-09-19 00:33:47 UTC; 4h 5min left
   Triggers: ● certbot.service

Sep 18 20:12:54 dev-ts-snipeit-we-vm-1 systemd[1]: Started Run certbot twice daily.
```

### Otestování obovy certifikátu
```zsh
sudo certbot renew --dry-run
```