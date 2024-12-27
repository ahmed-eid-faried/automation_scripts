
#!/bin/bash

# chmod +x install_ssl_linux.sh
# sudo ./install_ssl_linux.sh


# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo." 
   exit 1
fi

echo "Welcome to the Let's Encrypt SSL Installer!"

# Prompt for domain name and email
read -p "Enter your domain name (e.g., example.com): " DOMAIN
read -p "Enter your email address for SSL notifications: " EMAIL

# Update and install dependencies
echo "Updating the system and installing required packages..."
apt update && apt upgrade -y
apt install -y software-properties-common certbot python3-certbot-apache

# Check if Apache or Nginx is installed
if systemctl is-active --quiet apache2; then
    SERVER="apache"
elif systemctl is-active --quiet nginx; then
    SERVER="nginx"
    apt install -y python3-certbot-nginx
else
    echo "No supported web server (Apache or Nginx) found. Please install one before proceeding."
    exit 1
fi

# Install SSL using Certbot
echo "Obtaining SSL certificate for $DOMAIN using Let's Encrypt..."
if [ "$SERVER" = "apache" ]; then
    certbot --apache -d "$DOMAIN" --email "$EMAIL" --agree-tos --no-eff-email
elif [ "$SERVER" = "nginx" ]; then
    certbot --nginx -d "$DOMAIN" --email "$EMAIL" --agree-tos --no-eff-email
fi

# Verify SSL installation
if [ $? -eq 0 ]; then
    echo "SSL certificate installation successful for $DOMAIN!"
    echo "Your website is now secured with HTTPS."
else
    echo "SSL certificate installation failed. Check Certbot logs for details."
    exit 1
fi

# Set up auto-renewal
echo "Setting up automatic SSL renewal..."
echo "0 3 * * * /usr/bin/certbot renew --quiet" | crontab -

echo "Let's Encrypt SSL setup is complete. Your certificates will renew automatically!"
