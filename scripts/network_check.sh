#!/bin/bash

# ==========================================
# Linux Network Health Check
# ==========================================

PING_TARGET="8.8.8.8"
DNS_TARGET="google.com"

echo "=========================================="
echo "        LINUX NETWORK HEALTH CHECK"
echo "=========================================="

echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo ""

# ------------------------------------------
# Network Interface Information
# ------------------------------------------

echo "------------------------------------------"
echo "NETWORK INTERFACES"
echo "------------------------------------------"

ip -br addr

echo ""

# ------------------------------------------
# Local IP Address
# ------------------------------------------

LOCAL_IP=$(hostname -I | awk '{print $1}')

echo "Local IP Address : $LOCAL_IP"
echo ""

# ------------------------------------------
# Default Gateway
# ------------------------------------------

GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

echo "Default Gateway  : ${GATEWAY:-Not Found}"
echo ""

# ------------------------------------------
# DNS Configuration
# ------------------------------------------

echo "------------------------------------------"
echo "DNS CONFIGURATION"
echo "------------------------------------------"

if [ -f /etc/resolv.conf ]; then
    grep "nameserver" /etc/resolv.conf
else
    echo "DNS configuration not found."
fi

echo ""

# ------------------------------------------
# Internet Connectivity
# ------------------------------------------

echo "------------------------------------------"
echo "INTERNET CONNECTIVITY"
echo "------------------------------------------"

if ping -c 2 -W 2 "$PING_TARGET" > /dev/null 2>&1; then
    echo "Internet Connectivity : OK"
    echo "Ping Target           : $PING_TARGET"
else
    echo "Internet Connectivity : FAILED"
    echo "Ping Target           : $PING_TARGET"
fi

echo ""

# ------------------------------------------
# DNS Resolution
# ------------------------------------------

echo "------------------------------------------"
echo "DNS RESOLUTION"
echo "------------------------------------------"

if getent hosts "$DNS_TARGET" > /dev/null 2>&1; then
    echo "DNS Resolution : OK"
    echo "Domain         : $DNS_TARGET"
else
    echo "DNS Resolution : FAILED"
    echo "Domain         : $DNS_TARGET"
fi

echo ""

# ------------------------------------------
# Listening Ports
# ------------------------------------------

echo "------------------------------------------"
echo "LISTENING PORTS"
echo "------------------------------------------"

if command -v ss > /dev/null 2>&1; then
    ss -tuln
else
    echo "ss command is not available."
fi

echo ""

echo "=========================================="
echo "        NETWORK CHECK COMPLETED"
echo "=========================================="
