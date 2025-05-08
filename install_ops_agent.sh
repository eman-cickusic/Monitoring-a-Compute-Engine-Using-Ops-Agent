#!/bin/bash
# Script to install Google Cloud Ops Agent

# Exit on any error
set -e

echo "Downloading Ops Agent installation script..."
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh

echo "Installing Ops Agent..."
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# Verify installation success
if systemctl is-active --quiet google-cloud-ops-agent; then
    echo "Google Cloud Ops Agent installed and running successfully!"
else
    echo "Google Cloud Ops Agent installation completed but service is not running."
    echo "Starting Ops Agent service..."
    sudo systemctl start google-cloud-ops-agent
    echo "Ops Agent service started."
fi

# Clean up installation script
echo "Cleaning up..."
rm add-google-cloud-ops-agent-repo.sh

echo "Installation complete!"
echo "Next step: Configure the Ops Agent for Apache monitoring."
