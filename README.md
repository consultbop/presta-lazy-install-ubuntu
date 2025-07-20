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
- PHP : PHP 8.1

# Prestashop Version
Currently using PrestaShop 8.1.7 for the latest stable release.
Make sure the theme and module versions are compatible with 8.1.x.
If you need to change the PrestaShop version, update the download URL in the install.sh script.

# Changes for Ubuntu 24 Compatibility
- Updated Docker installation method (removed deprecated `apt-key`)
- Updated to use Docker Compose plugin instead of standalone docker-compose
- Specified PHP 8.1 for better compatibility
- Updated to MySQL 8.0 with proper authentication plugin
- Fixed file permissions and ownership commands
- Updated PrestaShop to latest stable version (8.1.7)