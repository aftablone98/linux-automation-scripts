#!/bin/bash

# ==========================================
# Linux Server Health Check
# ==========================================

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

echo "=================================================="
echo "              LINUX SERVER HEALTH CHECK"
echo "=================================================="

echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo "Kernel   : $(uname -r)"

echo ""
echo "--------------------------------------------------"
echo "SYSTEM INFORMATION"
echo "--------------------------------------------------"

echo "CPU Cores : $(nproc)"
echo "Uptime    : $(uptime -p)"

# ==========================================
# CPU CHECK
# ==========================================

echo ""
echo "--------------------------------------------------"
echo "CPU HEALTH"
echo "--------------------------------------------------"

CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)

echo "CPU Usage : ${CPU_USAGE}%"

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    echo "CPU Status: WARNING"
else
    echo "CPU Status: OK"
fi

# ==========================================
# MEMORY CHECK
# ==========================================

echo ""
echo "--------------------------------------------------"
echo "MEMORY HEALTH"
echo "--------------------------------------------------"

MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

echo "Memory Usage : ${MEMORY_USAGE}%"

if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
    echo "Memory Status: WARNING"
else
    echo "Memory Status: OK"
fi

# ==========================================
# DISK CHECK
# ==========================================

echo ""
echo "--------------------------------------------------"
echo "DISK HEALTH"
echo "--------------------------------------------------"

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Disk Usage : ${DISK_USAGE}%"

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    echo "Disk Status: WARNING"
else
    echo "Disk Status: OK"
fi

# ==========================================
# NETWORK CHECK
# ==========================================

echo ""
echo "--------------------------------------------------"
echo "NETWORK HEALTH"
echo "--------------------------------------------------"

if ping -c 2 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo "Internet Connectivity: OK"
else
    echo "Internet Connectivity: FAILED"
fi

# ==========================================
# PROCESS CHECK
# ==========================================

echo ""
echo "--------------------------------------------------"
echo "PROCESS HEALTH"
echo "--------------------------------------------------"

PROCESS_COUNT=$(ps -e --no-headers | wc -l)

echo "Running Processes : $PROCESS_COUNT"

# ==========================================
# SERVICE CHECK
# ==========================================

echo ""
echo "--------------------------------------------------"
echo "SERVICE HEALTH"
echo "--------------------------------------------------"

SERVICES=("docker" "cron" "ssh")

for SERVICE in "${SERVICES[@]}"; do

    if command -v systemctl > /dev/null 2>&1; then

        STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)

        if [ "$STATUS" = "active" ]; then
            echo "$SERVICE : RUNNING"
        elif [ "$STATUS" = "inactive" ]; then
            echo "$SERVICE : STOPPED"
        else
            echo "$SERVICE : NOT FOUND"
        fi

    else
        echo "$SERVICE : systemctl unavailable"
    fi

done

# ==========================================
# FINAL HEALTH STATUS
# ==========================================

echo ""
echo "=================================================="
echo "              OVERALL SERVER HEALTH"
echo "=================================================="

HEALTH_STATUS="HEALTHY"

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    HEALTH_STATUS="WARNING"
fi

if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
    HEALTH_STATUS="WARNING"
fi

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    HEALTH_STATUS="WARNING"
fi

if ! ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    HEALTH_STATUS="CRITICAL"
fi

echo ""
echo "Server Status : $HEALTH_STATUS"
echo ""

if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
    echo "All major health checks passed."
elif [ "$HEALTH_STATUS" = "WARNING" ]; then
    echo "Server requires attention."
else
    echo "Critical issue detected."
fi

echo ""
echo "=================================================="
echo "             HEALTH CHECK COMPLETED"
echo "=================================================="

