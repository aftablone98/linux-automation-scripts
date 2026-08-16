#!/bin/bash

# ==========================================
# Linux Process Monitor
# ==========================================

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80

echo "=========================================="
echo "          LINUX PROCESS MONITOR"
echo "=========================================="

echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo ""

# Count running processes
PROCESS_COUNT=$(ps -e --no-headers | wc -l)

echo "Running Processes : $PROCESS_COUNT"
echo ""

# CPU usage
CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)

echo "CPU Usage         : ${CPU_USAGE}%"

# Memory usage
MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

echo "Memory Usage      : ${MEMORY_USAGE}%"
echo ""

# Check CPU usage
if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    echo "CPU STATUS        : WARNING"
    echo "Message           : CPU usage is above ${CPU_THRESHOLD}%!"
else
    echo "CPU STATUS        : OK"
    echo "Message           : CPU usage is within safe limits."
fi

echo ""

# Check memory usage
if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
    echo "MEMORY STATUS     : WARNING"
    echo "Message           : Memory usage is above ${MEMORY_THRESHOLD}%!"
else
    echo "MEMORY STATUS     : OK"
    echo "Message           : Memory usage is within safe limits."
fi

echo ""
echo "------------------------------------------"
echo "Top 5 Processes by CPU Usage"
echo "------------------------------------------"

ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6

echo ""
echo "=========================================="
