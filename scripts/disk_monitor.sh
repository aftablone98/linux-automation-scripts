#!/bin/bash

# ==========================================
# Linux Disk Usage Monitor
# ==========================================

THRESHOLD=80

echo "=========================================="
echo "          DISK USAGE MONITOR"
echo "=========================================="

echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo ""

# Get disk information for root filesystem
DISK_INFO=$(df -h / | tail -1)

FILESYSTEM=$(echo "$DISK_INFO" | awk '{print $1}')
TOTAL=$(echo "$DISK_INFO" | awk '{print $2}')
USED=$(echo "$DISK_INFO" | awk '{print $3}')
AVAILABLE=$(echo "$DISK_INFO" | awk '{print $4}')
USAGE=$(echo "$DISK_INFO" | awk '{print $5}' | tr -d '%')

echo "Filesystem : $FILESYSTEM"
echo "Total      : $TOTAL"
echo "Used       : $USED"
echo "Available  : $AVAILABLE"
echo "Usage      : $USAGE%"
echo ""

# Check disk usage
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "STATUS     : WARNING"
    echo "Message    : Disk usage is above ${THRESHOLD}%!"
else
    echo "STATUS     : OK"
    echo "Message    : Disk usage is within safe limits."
fi

echo "=========================================="
