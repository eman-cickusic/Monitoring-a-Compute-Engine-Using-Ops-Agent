#!/bin/bash
# Script to configure Ops Agent for Apache Web Server monitoring

# Exit on any error
set -e

echo "Creating backup of existing Ops Agent configuration..."
# Create a backup of the existing file so existing configurations are not lost
sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak

echo "Configuring Ops Agent for Apache monitoring..."
# Configure the Ops Agent
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
metrics:
  receivers:
    apache:
      type: apache
  service:
    pipelines:
      apache:
        receivers:
          - apache
logging:
  receivers:
    apache_access:
      type: apache_access
    apache_error:
      type: apache_error
  service:
    pipelines:
      apache:
        receivers:
          - apache_access
          - apache_error
EOF

echo "Restarting Ops Agent to apply configuration..."
sudo service google-cloud-ops-agent restart

echo "Waiting for configuration to take effect..."
sleep 60

echo "Configuration complete!"
echo "Next step: Generate traffic on your Apache server to verify monitoring is working."

# Verify Ops Agent is running with the new configuration
if systemctl is-active --quiet google-cloud-ops-agent; then
    echo "Ops Agent is running with the new configuration."
else
    echo "Warning: Ops Agent service is not running after configuration."
    echo "Starting Ops Agent service..."
    sudo systemctl start google-cloud-ops-agent
    echo "Ops Agent service started."
fi
