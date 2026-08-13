#!/bin/bash

echo "================================"
echo "       DISK USAGE MONITOR"
echo "================================"

echo "Checking disk usage..."
echo

df -h /

echo
echo "--------------------------------"

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

echo "Disk Usage: $DISK_USAGE%"

if [ "$DISK_USAGE" -ge 80 ]; then
    echo "WARNING: Disk usage is above 80%!"
else
    echo "OK: Disk usage is under 80%."
fi

echo "================================"