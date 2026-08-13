#!/bin/bash

echo "================================"
echo "      LINUX SYSTEM INFO"
echo "================================"

echo "Hostname:"
hostname

echo "--------------------------------"

echo "Operating System:"
cat /etc/os-release | grep PRETTY_NAME

echo "--------------------------------"

echo "Kernel:"
uname -r

echo "--------------------------------"

echo "Current User:"
whoami

echo "--------------------------------"

echo "System Uptime:"
uptime

echo "--------------------------------"

echo "Disk Usage:"
df -h /

echo "--------------------------------"

echo "Memory Usage:"
free -h

echo "================================"
