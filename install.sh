#!/bin/bash

#install docker
sudo apt update -y
sudo apt-get upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
sudo apt install docker-ce -y

#install Apache2
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt install apache2 -y
sudo ufw allow in "Apache"

#install docker-compose
sudo apt install docker-compose -y

#Setup Apache config file
mv ./prestawebsite.conf /etc/apache2/sites-available/
sudo ln -s /etc/apache2/sites-available/prestawebsite.conf /etc/apache2/sites-enabled/prestawebsite.conf

sudo systemctl restart apache2

#install PHP
sudo apt install php libapache2-mod-php php-mysql -y
sudo apt-get install php-cli php-common php-mbstring php-gd php-intl php-xml php-mysql php-zip php-curl php-xmlrpc -y
sudo systemctl restart apache2

sudo apt-get install unzip -y

#enable mod_rewrite
sudo a2enmod rewrite
sudo a2ensite prestawebsite


#download prestashop
cd /var/www/html
rm index.html
sudo wget https://assets.prestashop3.com/dst/edition/corporate/8.1.4/prestashop_edition_classic_version_8.1.4.zip
sudo unzip prestashop_edition_classic_version_8.1.4.zip

cd 

sudo chown www-data: /var/www/html/
sudo chmod -R 755 /var/www/html/

#initiate docker for mysql
cd presta-lazy-install-ubuntu
docker-compose -f docker-compose.yml up --build -d

# # mysql docker config
# docker exec -ti diyverse-cms_mysql_1 bash
# chown -R mysql:mysql /var/lib/mysql
# mysql -u root -p 
