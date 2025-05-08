#!/bin/bash
# Script to install Apache Web Server on Debian-based systems

# Exit on any error
set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing Apache and PHP..."
# Try to install apache2 with php7.0
if ! sudo apt-get install -y apache2 php7.0; then
    echo "Falling back to default PHP version..."
    # If the previous command failed, try with the default PHP version
    sudo apt-get install -y apache2 php
fi

# Verify Apache is running
echo "Verifying Apache installation..."
if systemctl is-active --quiet apache2; then
    echo "Apache installed and running successfully!"
    echo "Access your web server at: http://$(curl -s http://checkip.amazonaws.com)"
else
    echo "Apache installation completed but service is not running."
    echo "Starting Apache service..."
    sudo systemctl start apache2
    echo "Apache service started. Access your web server at: http://$(curl -s http://checkip.amazonaws.com)"
fi
