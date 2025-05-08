# Troubleshooting Guide

This guide provides solutions to common issues you might encounter when setting up and using Ops Agent for monitoring Apache on Google Cloud Compute Engine.

## Apache Web Server Issues

### Apache fails to install

**Issue**: The Apache installation command fails.

**Solution**:
1. Make sure your VM has internet access
2. Try updating package lists first:
   ```bash
   sudo apt-get update
   ```
3. If PHP 7.0 isn't available, try installing the default PHP version:
   ```bash
   sudo apt-get install apache2 php
   ```

### Apache is installed but not running

**Issue**: Apache is installed but the service is not running.

**Solution**:
1. Start the Apache service:
   ```bash
   sudo systemctl start apache2
   ```
2. Enable Apache to start on boot:
   ```bash
   sudo systemctl enable apache2
   ```
3. Check for errors:
   ```bash
   sudo systemctl status apache2
   sudo journalctl -u apache2
   ```

### Can't access Apache from browser

**Issue**: Apache is running but you can't access it from your browser.

**Solution**:
1. Verify Apache is running:
   ```bash
   sudo systemctl status apache2
   ```
2. Check if the firewall is properly configured:
   ```bash
   gcloud compute firewall-rules list
   ```
3. Ensure HTTP traffic is allowed in the GCP firewall rules
4. Try accessing using the internal IP from the VM:
   ```bash
   curl localhost
   ```

## Ops Agent Issues

### Ops Agent fails to install

**Issue**: The Ops Agent installation script fails.

**Solution**:
1. Make sure your VM has internet access
2. Check if the VM is running on a supported OS:
   ```bash
   cat /etc/os-release
   ```
3. Try installing manually:
   ```bash
   sudo apt-get update
   sudo apt-get install -y google-cloud-ops-agent
   ```

### Ops Agent is not collecting Apache metrics

**Issue**: Apache metrics are not appearing in the dashboard.

**Solution**:
1. Verify the Ops Agent configuration:
   ```bash
   cat /etc/google-cloud-ops-agent/config.yaml
   ```
2. Restart the Ops Agent:
   ```bash
   sudo service google-cloud-ops-agent restart
   ```
3. Check Ops Agent logs:
   ```bash
   sudo journalctl -u google-cloud-ops-agent
   ```
4. Verify Apache status module is enabled:
   ```bash
   sudo a2enmod status
   sudo systemctl restart apache2
   ```
5. Try accessing the Apache status page:
   ```bash
   curl http://localhost/server-status?auto
   ```

## Alerting Issues

### Not receiving alert emails

**Issue**: Traffic is being generated but no alert emails are received.

**Solution**:
1. Verify the email notification channel was created correctly
2. Check if the alerting policy was created successfully:
   ```bash
   gcloud alpha monitoring policies list
   ```
3. Make sure the generated traffic is high enough to trigger the alert (above 4 KiB/s)
4. Check the spam folder in your email
5. Allow up to 5 minutes for the alert system to detect the condition and send notifications

### Alert triggering too frequently

**Issue**: Receiving too many alert emails.

**Solution**:
1. Increase the threshold value in the alerting policy
2. Increase the duration window to reduce sensitivity to short spikes
3. Add an alert suppression duration to limit how often notifications are sent

## Dashboard Issues

### Apache dashboard not showing up

**Issue**: The Apache dashboard is not appearing in the Monitoring Dashboards list.

**Solution**:
1. Make sure the Ops Agent is properly installed and running
2. Verify the Apache integration is properly configured
3. Generate some traffic to the Apache server:
   ```bash
   bash scripts/generate_traffic.sh
   ```
4. Wait for up to 5 minutes for the dashboard to be created automatically
5. If the dashboard still doesn't appear, try creating a custom dashboard

### Dashboard shows no data

**Issue**: The Apache dashboard appears but shows no metrics data.

**Solution**:
1. Verify Apache is running and serving requests
2. Check if the Ops Agent configuration for Apache is correct
3. Make sure the status module is enabled:
   ```bash
   sudo a2enmod status
   sudo systemctl restart apache2
   ```
4. Generate traffic to the Apache server:
   ```bash
   bash scripts/generate_traffic.sh
   ```
5. Wait a few minutes for metrics to be collected and displayed

## Permission Issues

### Permission denied errors

**Issue**: Getting "Permission denied" errors when running scripts.

**Solution**:
1. Make the scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```
2. Run the scripts with sudo if needed:
   ```bash
   sudo bash scripts/install_apache.sh
   ```

## Help and Support

If you continue to experience issues after trying these troubleshooting steps, consider the following resources:

1. [Google Cloud Ops Agent Documentation](https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent)
2. [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
3. [Google Cloud Monitoring Documentation](https://cloud.google.com/monitoring/docs)
4. [Google Cloud Support](https://cloud.google.com/support)

For bugs or feature requests related to this project, please open an issue on GitHub.
