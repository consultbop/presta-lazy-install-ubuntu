# Installation
Use install.sh for installation on Ubuntu 24.04 LTS (or Ubuntu 22.04 LTS).
This script has been updated for modern Ubuntu versions and Docker installation practices.

## Prerequisites
- Ubuntu 24.04 LTS (recommended) or Ubuntu 22.04 LTS
- Root or sudo access
- Internet connection

## Usage
1. Clone this repository
2. Run the setup script: `chmod +x setup.sh && ./setup.sh`
3. Follow the prompts to configure MySQL credentials
4. Run the installation: `chmod +x install.sh && sudo ./install.sh`
5. After installation, you may need to log out and back in for Docker group permissions to take effect
6. Access PrestaShop at: `http://your-server-ip` or `http://localhost`

### Manual Configuration (Alternative)
If you prefer to configure manually:
1. Edit `docker-compose.yml` and replace `<your-password>` and `<your-db-name>` with your desired values
2. Run: `chmod +x install.sh && sudo ./install.sh`

# Architecture
_LAMP Stack_
- Linux : Ubuntu 24.04 LTS
- Apache : Apache2
- MySQL : Version 8.0 (via Docker)
- PHP : PHP 8.4 (recommended for PrestaShop 9)

# Prestashop Version
Currently using PrestaShop 9.0.0 - the latest major release with modern architecture.
This version includes Symfony 6.4 LTS, new Admin API, and the Hummingbird theme.

# Changes for Ubuntu 24 Compatibility
- Updated Docker installation method (removed deprecated `apt-key`)
- Updated to use Docker Compose plugin instead of standalone docker-compose
- Installed PHP 8.4 with all required extensions for PrestaShop 9
- Updated to MySQL 8.0 with proper authentication plugin
- Fixed file permissions and ownership commands
- Updated PrestaShop to version 9.0.0
- Added ondrej/php PPA for PHP 8.4 support on Ubuntu 24 LTS