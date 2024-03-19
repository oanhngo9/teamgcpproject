#!/bin/bash
set -e  # Stop the script if any command fails

# Define database connection information as environment variables
export DB_NAME="sasha-instance"
export DB_USER="sasha-username"
export DB_PASSWORD="12345678"
export DB_HOST="sasha-host"

# Set non-interactive frontend for apt-get
export DEBIAN_FRONTEND=noninteractive

# Update package repositories and install required packages
sudo apt-get update
sudo apt-get install -y apache2 unzip wget

# Start Apache web server
sudo service apache2 start

# Set ServerName directive
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/servername.conf
sudo a2enconf servername

# Restart Apache to apply changes
sudo service apache2 restart

# Download and install PHP and related extensions
sudo apt-get install -y php7.3 php7.3-mysql php-pear

# Download and install the protobuf compiler and PHP protobuf extension
sudo apt-get install -y protobuf-compiler php-protobuf

# Restart Apache to load new PHP extensions
sudo service apache2 restart

# Verify PHP version
php --version

# Download and extract WordPress
sudo rm -rf /var/www/html/*
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
sudo mv wordpress/* /var/www/html/

# Change ownership of WordPress files to Apache user
sudo chown -R www-data:www-data /var/www/html

# Cleanup unnecessary packages
sudo apt autoremove -y

# Remove wp-config.php file if it exists
sudo rm -f /var/www/html/wp-config.php

# Create a new wp-config.php file
sudo tee /var/www/html/wp-config.php > /dev/null << EOF
<?php
define('DB_NAME', '$DB_NAME');
define('DB_USER', '$DB_USER');
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', '$DB_HOST');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
EOF
