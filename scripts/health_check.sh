#!/bin/bash

# ==========================================
# Linux Server Health Check
# ==========================================

# ==========================================
# Default Thresholds
# ==========================================

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# ==========================================
# Threshold Validation
# ==========================================

validate_threshold() {
    local NAME="$1"
    local VALUE="$2"

    if ! [[ "$VALUE" =~ ^[0-9]+$ ]]; then
        echo "ERROR: $NAME threshold must be a number."
        exit 1
    fi

    if [ "$VALUE" -lt 0 ] || [ "$VALUE" -gt 100 ]; then
        echo "ERROR: $NAME threshold must be between 0 and 100."
        exit 1
    fi
}

# ==========================================
# Help Function
# ==========================================

show_help() {
    echo "Usage: ./health_check.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --cpu NUMBER       Set CPU warning threshold"
    echo "  --memory NUMBER    Set memory warning threshold"
    echo "  --disk NUMBER      Set disk warning threshold"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./health_check.sh"
    echo "  ./health_check.sh --cpu 90"
    echo "  ./health_check.sh --memory 85 --disk 75"
    echo "  ./health_check.sh --cpu 90 --memory 85 --disk 75"
}

# ==========================================
# Command-Line Arguments
# ==========================================

while [[ $# -gt 0 ]]; do

    case "$1" in

        --cpu)
            if [ -z "$2" ]; then
                echo "ERROR: --cpu requires a value."
                exit 1
            fi

            validate_threshold "CPU" "$2"
            CPU_THRESHOLD="$2"
            shift 2
            ;;

        --memory)
            if [ -z "$2" ]; then
                echo "ERROR: --memory requires a value."
                exit 1
            fi

            validate_threshold "Memory" "$2"
            MEMORY_THRESHOLD="$2"
            shift 2
            ;;

        --disk)
            if [ -z "$2" ]; then
                echo "ERROR: --disk requires a value."
                exit 1
            fi

            validate_threshold "Disk" "$2"
            DISK_THRESHOLD="$2"
            shift 2
            ;;

        --help)
            show_help
            exit 0
            ;;

        *)
            echo "ERROR: Unknown option: $1"
            echo ""
            show_help
            exit 1
            ;;

    esac

done

# ==========================================
# Logging Configuration
# ==========================================

# ==========================================
# Logging Configuration
# ==========================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/health_check.log"

mkdir -p "$LOG_DIR"

# ==========================================
# Exit Codes
# ==========================================

EXIT_OK=0
EXIT_WARNING=1
EXIT_CRITICAL=2

HEALTH_STATUS="HEALTHY"

# ==========================================
# Logging Function
# ==========================================

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

# ==========================================
# Header
# ==========================================

echo "=================================================="
echo "              LINUX SERVER HEALTH CHECK"
echo "=================================================="

echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo "Kernel   : $(uname -r)"

log_message "Health check started"

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

log_message "CPU usage: ${CPU_USAGE}%"

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    echo "CPU Status: WARNING"
    HEALTH_STATUS="WARNING"
    log_message "WARNING: CPU usage above ${CPU_THRESHOLD}%"
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

log_message "Memory usage: ${MEMORY_USAGE}%"

if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
    echo "Memory Status: WARNING"
    HEALTH_STATUS="WARNING"
    log_message "WARNING: Memory usage above ${MEMORY_THRESHOLD}%"
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

log_message "Disk usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    echo "Disk Status: WARNING"
    HEALTH_STATUS="WARNING"
    log_message "WARNING: Disk usage above ${DISK_THRESHOLD}%"
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
    log_message "Network connectivity: OK"

else

    echo "Internet Connectivity: FAILED"
    HEALTH_STATUS="CRITICAL"
    log_message "CRITICAL: Internet connectivity failed"

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

log_message "Running processes: $PROCESS_COUNT"

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
            log_message "$SERVICE service: RUNNING"

        elif [ "$STATUS" = "inactive" ]; then

            echo "$SERVICE : STOPPED"
            log_message "WARNING: $SERVICE service is STOPPED"

            if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
                HEALTH_STATUS="WARNING"
            fi

        elif [ "$STATUS" = "failed" ]; then

            echo "$SERVICE : FAILED"
            log_message "CRITICAL: $SERVICE service FAILED"
            HEALTH_STATUS="CRITICAL"

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

echo ""
echo "Server Status : $HEALTH_STATUS"

log_message "Overall server status: $HEALTH_STATUS"

if [ "$HEALTH_STATUS" = "HEALTHY" ]; then

    echo "All major health checks passed."

    log_message "Health check completed successfully."

    echo ""
    echo "=================================================="

    exit "$EXIT_OK"

elif [ "$HEALTH_STATUS" = "WARNING" ]; then

    echo "Server requires attention."

    log_message "Health check completed with warnings."

    echo ""
    echo "=================================================="

    exit "$EXIT_WARNING"

else

    echo "Critical issue detected."

    log_message "Health check completed with critical issues."

    echo ""
    echo "=================================================="

    exit "$EXIT_CRITICAL"

fi

