#!/bin/bash

echo "======================================"
echo "       LINUX SYSTEM INFORMATION"
echo "======================================"

echo "Hostname        : $(hostname)"
echo "Operating System: $(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"
echo "Kernel          : $(uname -r)"
echo "Architecture    : $(uname -m)"
echo "Uptime          : $(uptime -p)"
echo "CPU Cores       : $(nproc)"

echo ""
echo "Memory Usage:"
free -h

echo ""
echo "Disk Usage:"
df -h /

echo "======================================"
