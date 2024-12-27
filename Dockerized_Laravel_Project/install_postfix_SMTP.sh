#!/bin/bash


# sudo ./install_postfix_SMTP.sh
# chmod +x install_postfix_SMTP.sh

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo." 
   exit 1
fi

echo "Welcome to the Postfix SMTP Server Installer!"

# Prompt for required details
read -p "Enter your domain name (e.g., example.com): " DOMAIN
read -p "Enter your mail server hostname (e.g., mail.example.com): " MAIL_HOSTNAME
read -p "Enter your email address for admin notifications: " ADMIN_EMAIL

# Update and upgrade the system
echo "Updating the system..."
apt update && apt upgrade -y

# Install Postfix
echo "Installing Postfix..."
debconf-set-selections <<< "postfix postfix/mailname string $MAIL_HOSTNAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt install postfix -y

# Install additional packages for security and spam prevention
echo "Installing additional packages..."
apt install libsasl2-modules postfix-pcre spamassassin spamc clamav clamav-daemon -y

# Configure Postfix
echo "Configuring Postfix..."
POSTFIX_MAIN_CF="/etc/postfix/main.cf"

cat > $POSTFIX_MAIN_CF <<EOL
# General configuration
myhostname = $MAIL_HOSTNAME
mydomain = $DOMAIN
myorigin = \$mydomain
inet_interfaces = all
inet_protocols = ipv4
mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain
relayhost =
mynetworks = 127.0.0.0/8
mailbox_size_limit = 0
recipient_delimiter = +

# TLS/SSL settings
smtpd_tls_cert_file=/etc/ssl/certs/$MAIL_HOSTNAME.crt
smtpd_tls_key_file=/etc/ssl/private/$MAIL_HOSTNAME.key
smtpd_use_tls=yes
smtpd_tls_auth_only=yes

# SASL authentication
smtpd_sasl_auth_enable=yes
smtpd_sasl_security_options=noanonymous
smtpd_sasl_local_domain=\$myhostname
broken_sasl_auth_clients=yes

# SPF, DKIM, and DMARC
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
EOL

# Generate self-signed certificate for testing (use Let's Encrypt for production)
echo "Generating self-signed SSL certificate for $MAIL_HOSTNAME..."
mkdir -p /etc/ssl/private
openssl req -new -x509 -days 365 -nodes -out /etc/ssl/certs/$MAIL_HOSTNAME.crt -keyout /etc/ssl/private/$MAIL_HOSTNAME.key -subj "/CN=$MAIL_HOSTNAME"

# Set permissions for the private key
chmod 600 /etc/ssl/private/$MAIL_HOSTNAME.key

# Configure DNS records (SPF, DKIM, DMARC)
echo "Configuring DNS records..."
echo "Add the following DNS records to your domain settings:"
echo "1. MX Record: $DOMAIN -> Priority: 0, Mail Server: $MAIL_HOSTNAME"
echo "2. SPF Record: v=spf1 mx ~all"
echo "3. DMARC Record: _dmarc.$DOMAIN IN TXT \"v=DMARC1; p=none; rua=mailto:$ADMIN_EMAIL\""

# Restart Postfix to apply changes
echo "Restarting Postfix..."
systemctl restart postfix

# Enable services on boot
systemctl enable postfix
systemctl enable spamassassin
systemctl enable clamav-daemon

echo "Postfix installation and configuration are complete!"
echo "Test your mail server by sending and receiving emails."
