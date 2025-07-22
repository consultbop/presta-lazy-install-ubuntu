#!/bin/bash

echo "=== PrestaShop Ubuntu 24 Installation Script ==="
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if setup.sh exists and run it first
if [ -f "./setup.sh" ]; then
    echo "Running setup script to configure MySQL credentials..."
    chmod +x ./setup.sh
    ./setup.sh
    echo ""
    echo "Setup complete. Proceeding with installation..."
    echo ""
else
    echo "Warning: setup.sh not found. Using default MySQL configuration."
    echo "Make sure docker-compose.yml has proper MySQL credentials configured."
    echo ""
fi

#install docker (updated for Ubuntu 24)
sudo apt update -y
sudo apt-get upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common gpg -y

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#install Apache2
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt install apache2 -y
sudo ufw allow in "Apache"

# Add current user to docker group
sudo usermod -aG docker $USER

#Setup Apache config file
sudo cp "$SCRIPT_DIR/prestawebsite.conf" /etc/apache2/sites-available/
sudo ln -s /etc/apache2/sites-available/prestawebsite.conf /etc/apache2/sites-enabled/prestawebsite.conf

sudo systemctl restart apache2

#install PHP (PHP 8.4 for PrestaShop 9 compatibility - Ubuntu 24 LTS)
# Adding ondrej/php PPA to get PHP 8.4 on Ubuntu 24 LTS
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y

# Install PHP 8.4 and required extensions for PrestaShop 9
sudo apt install php8.4 libapache2-mod-php8.4 -y
sudo apt install php8.4-cli php8.4-common php8.4-curl php8.4-dom php8.4-fileinfo -y
sudo apt install php8.4-gd php8.4-iconv php8.4-intl php8.4-json php8.4-mbstring -y
sudo apt install php8.4-mysql php8.4-openssl php8.4-pdo php8.4-simplexml -y
sudo apt install php8.4-zip php8.4-xml php8.4-xmlrpc -y

# Configure PHP settings for PrestaShop
sudo sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/8.4/apache2/php.ini
sudo sed -i 's/allow_url_fopen = .*/allow_url_fopen = On/' /etc/php/8.4/apache2/php.ini
sudo sed -i 's/allow_url_include = .*/allow_url_include = Off/' /etc/php/8.4/apache2/php.ini

sudo systemctl restart apache2

sudo apt-get install unzip -y

#enable mod_rewrite
sudo a2enmod rewrite
sudo a2ensite prestawebsite


#download prestashop (PrestaShop 9.0.0 with PHP 8.4 compatibility)
cd /var/www/html
sudo rm -f index.html
echo "Downloading PrestaShop 9.0.0..."

# Try official PrestaShop download first
if sudo wget -q --spider https://assets.prestashop3.com/dst/edition/corporate/9.0.0/prestashop_edition_classic_version_9.0.0.zip; then
    echo "Downloading from official PrestaShop repository..."
    sudo wget https://assets.prestashop3.com/dst/edition/corporate/9.0.0/prestashop_edition_classic_version_9.0.0.zip -O prestashop_9.0.0.zip
else
    echo "Official download not available, downloading source from GitHub..."
    sudo wget https://api.github.com/repos/PrestaShop/PrestaShop/zipball/9.0.0 -O prestashop_9.0.0.zip
fi

sudo unzip -q prestashop_9.0.0.zip
sudo rm prestashop_9.0.0.zip

# Handle GitHub source directory structure if needed
if [ -d "PrestaShop-*" ]; then
    echo "Extracting GitHub source..."
    sudo mv PrestaShop-* prestashop_source
    sudo mv prestashop_source/* ./
    sudo mv prestashop_source/.* ./ 2>/dev/null || true
    sudo rmdir prestashop_source
fi

echo "PrestaShop 9.0.0 extracted successfully."

cd 

sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

#initiate docker for mysql (using new docker compose syntax)
cd "$SCRIPT_DIR"
sudo docker compose -f docker-compose.yml up --build -d

# Wait for MySQL to be ready
echo "Waiting for MySQL container to be ready..."
sleep 30

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "PrestaShop 9.0.0 has been installed and configured with PHP 8.4."
echo "MySQL container is running in the background."
echo ""
echo "System Configuration:"
echo "- PHP 8.4 (recommended for PrestaShop 9)"
echo "- All required PHP extensions installed"
echo "- MySQL 8.0 via Docker"
echo "- Apache 2.4 with mod_rewrite enabled"
echo ""
echo "Next steps:"
echo "1. Log out and log back in (or restart) for Docker permissions to take effect"
echo "2. Access PrestaShop setup at: http://localhost or http://your-server-ip"
echo "3. Use the MySQL credentials you configured during setup"
echo ""
echo "MySQL connection details for PrestaShop setup:"
echo "- Database server: localhost:3306"
echo "- Database name: (as configured in setup)"
echo "- Database user: prestashop"
echo "- Database password: (as configured in setup)"
echo ""
echo "🚀 PrestaShop 9.0.0 Features:"
echo "- Symfony 6.4 LTS support"
echo "- PHP 8.1-8.4 compatibility"
echo "- New Admin API with API Platform"
echo "- Modern Hummingbird theme available"
echo "- Enhanced security and performance"
echo ""

# # mysql docker config
# docker exec -ti prestashop-mysql bash
# chown -R mysql:mysql /var/lib/mysql
# mysql -u root -p 
