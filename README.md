# Monitoring a Compute Engine Using Ops Agent

This repository contains a step-by-step guide on how to create and configure a Google Cloud Compute Engine VM instance with Ops Agent to monitor an Apache Web Server. The project demonstrates how to setup monitoring, view metrics on a predefined dashboard, and create alerting policies.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Step 1: Create a Compute Engine VM Instance](#step-1-create-a-compute-engine-vm-instance)
- [Step 2: Install Apache Web Server](#step-2-install-apache-web-server)
- [Step 3: Install and Configure Ops Agent](#step-3-install-and-configure-ops-agent)
- [Step 4: Generate Traffic and View Metrics](#step-4-generate-traffic-and-view-metrics)
- [Step 5: Create an Alerting Policy](#step-5-create-an-alerting-policy)
- [Step 6: Test the Alerting Policy](#step-6-test-the-alerting-policy)
- [Conclusion](#conclusion)

## Overview

In this project, we create a Compute Engine VM instance, install an Apache Web Server, and then configure the Ops Agent to monitor the server. We also set up alerting policies to notify us when traffic exceeds a certain threshold.

## Prerequisites

To complete this project, you need:
- A Google Cloud Platform account
- Basic knowledge of Linux commands
- Access to Google Cloud Console

## Video

https://youtu.be/_zUFpHJJhdc


## Project Structure

```
.
├── README.md                  # Project documentation
├── scripts/
│   ├── install_apache.sh      # Script to install Apache Web Server
│   ├── install_ops_agent.sh   # Script to install Ops Agent
│   ├── configure_ops_agent.sh # Script to configure Ops Agent for Apache
│   └── generate_traffic.sh    # Script to generate traffic for testing
└── config/
    └── ops_agent_config.yaml  # Ops Agent configuration file for Apache
```

## Step 1: Create a Compute Engine VM Instance

1. In the Google Cloud console, navigate to **Compute Engine > VM instances**
2. Click **Create instance**
3. Configure the VM with the following settings:
   - Name: `quickstart-vm`
   - Machine type: `e2-small`
   - Boot disk: Debian GNU/Linux 12 (bookworm)
   - Firewall: Allow HTTP and HTTPS traffic

```bash
# You can also use gcloud command to create the VM:
gcloud compute instances create quickstart-vm \
    --machine-type=e2-small \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --tags=http-server,https-server \
    --zone=YOUR_ZONE
```

## Step 2: Install Apache Web Server

Connect to your VM instance via SSH and run the following commands:

```bash
sudo apt-get update
sudo apt-get install apache2 php7.0
```

If the above command fails, try:

```bash
sudo apt-get install apache2 php
```

Verify the installation by navigating to `http://EXTERNAL_IP` in your browser, where `EXTERNAL_IP` is the external IP address of your VM.

## Step 3: Install and Configure Ops Agent

### Install Ops Agent

```bash
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
```

### Configure Ops Agent for Apache

Create a configuration file at `/etc/google-cloud-ops-agent/config.yaml` with the following content:

```yaml
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
```

Restart the Ops Agent to apply the configuration:

```bash
sudo service google-cloud-ops-agent restart
```

## Step 4: Generate Traffic and View Metrics

Generate traffic on your Apache Web Server using the following command:

```bash
timeout 120 bash -c -- 'while true; do curl localhost; sleep $((RANDOM % 4)) ; done'
```

View metrics on the Apache GCE Overview dashboard:
1. Navigate to **Monitoring** in the Google Cloud Console
2. Select **Dashboards** in the navigation pane
3. Choose the **Apache Overview** dashboard

## Step 5: Create an Alerting Policy

### Setup Email Notification Channel

1. In Google Cloud Console, navigate to **Monitoring > Alerting**
2. Click **Edit notification channels**
3. Add a new email notification channel with your email address

### Configure Alerting Policy

1. In **Monitoring > Alerting**, click **Create policy**
2. Select metric: **Apache > workload/apache.traffic**
3. Configure alert trigger:
   - Rolling window: 1 min
   - Rolling window function: rate
   - Threshold: Above 4000
4. Configure notifications:
   - Notification channel: Your email address
   - Incident autoclose duration: 30 min
   - Alert policy name: Apache traffic above threshold

## Step 6: Test the Alerting Policy

Generate traffic to trigger the alert:

```bash
timeout 120 bash -c -- 'while true; do curl localhost; sleep $((RANDOM % 4)) ; done'
```

Once the traffic exceeds the threshold (4 KiB/s), you should receive an email notification.

## Conclusion

By following these steps, you have successfully set up a Compute Engine VM with Apache Web Server, configured the Ops Agent for monitoring, and established an alerting policy to notify you when traffic exceeds a threshold. This setup provides a foundation for monitoring and maintaining the health of your web applications in Google Cloud.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
