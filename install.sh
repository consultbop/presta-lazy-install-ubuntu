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

#install PHP (specify PHP 8.1 for better compatibility)
sudo apt install php8.1 libapache2-mod-php8.1 php8.1-mysql -y
sudo apt-get install php8.1-cli php8.1-common php8.1-mbstring php8.1-gd php8.1-intl php8.1-xml php8.1-mysql php8.1-zip php8.1-curl php8.1-xmlrpc -y
sudo systemctl restart apache2

sudo apt-get install unzip -y

#enable mod_rewrite
sudo a2enmod rewrite
sudo a2ensite prestawebsite


#download prestashop (updated to latest stable version)
cd /var/www/html
sudo rm -f index.html
sudo wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.7/prestashop_8.1.7.zip
sudo unzip prestashop_8.1.7.zip
sudo rm prestashop_8.1.7.zip

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
echo "PrestaShop has been installed and configured."
echo "MySQL container is running in the background."
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

# # mysql docker config
# docker exec -ti prestashop-mysql bash
# chown -R mysql:mysql /var/lib/mysql
# mysql -u root -p 
