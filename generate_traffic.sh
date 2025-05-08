#!/bin/bash
# Script to generate traffic on Apache Web Server for testing monitoring and alerts

# Default duration: 120 seconds
DURATION=${1:-120}

echo "Generating traffic on Apache Web Server for $DURATION seconds..."
echo "Press Ctrl+C to stop before the timeout."

timeout $DURATION bash -c -- 'while true; do 
    curl -s localhost > /dev/null
    echo -n "."
    sleep $((RANDOM % 4))
done'

echo
echo "Traffic generation completed."
echo "Check your Apache monitoring dashboard to see the metrics."
echo "If traffic exceeded the threshold, you should receive an alert email shortly."
