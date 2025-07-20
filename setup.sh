#!/bin/bash

# Setup script for PrestaShop installation
# This script helps configure the environment before running install.sh

echo "=== PrestaShop Ubuntu 24 Setup Script ==="
echo ""

# Check if running on Ubuntu
if [ ! -f /etc/os-release ] || ! grep -q "Ubuntu" /etc/os-release; then
    echo "Warning: This script is designed for Ubuntu. Proceeding anyway..."
fi

# Check Ubuntu version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Detected OS: $PRETTY_NAME"
    if [[ "$VERSION_ID" < "22.04" ]]; then
        echo "Warning: This script is optimized for Ubuntu 22.04+ but may work on older versions."
    fi
fi

echo ""
echo "Before running the installation, please configure your MySQL credentials:"
echo ""

# Prompt for MySQL configuration
read -p "Enter MySQL root password (or press Enter for 'prestashop123'): " mysql_root_pass
mysql_root_pass=${mysql_root_pass:-prestashop123}

read -p "Enter MySQL database name (or press Enter for 'prestashop_db'): " mysql_db_name
mysql_db_name=${mysql_db_name:-prestashop_db}

read -p "Enter MySQL user password (or press Enter for 'prestashop123'): " mysql_user_pass
mysql_user_pass=${mysql_user_pass:-prestashop123}

# Update docker-compose.yml with the provided credentials
echo "Updating docker-compose.yml with your credentials..."

sed -i "s/<your-password>/$mysql_root_pass/g" docker-compose.yml
sed -i "s/<your-db-name>/$mysql_db_name/g" docker-compose.yml
sed -i "s/MYSQL_PASSWORD: $mysql_root_pass/MYSQL_PASSWORD: $mysql_user_pass/" docker-compose.yml

echo ""
echo "✓ Docker Compose configuration updated"
echo ""
echo "Configuration Summary:"
echo "- MySQL Root Password: $mysql_root_pass"
echo "- MySQL Database: $mysql_db_name"
echo "- MySQL User: prestashop"
echo "- MySQL User Password: $mysql_user_pass"
echo ""
echo "You can now run the installation with:"
echo "chmod +x install.sh && sudo ./install.sh"
echo ""
echo "Note: After installation, you may need to log out and back in for Docker permissions to take effect."
echo "Then access PrestaShop at: http://your-server-ip or http://localhost"
