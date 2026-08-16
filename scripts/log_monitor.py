#!/usr/bin/env python3

"""
Linux Log Monitor
-----------------
Searches Linux log files for errors, warnings,
and critical messages.
"""

import os
from datetime import datetime


# Configuration
LOG_FILE = "/var/log/syslog"

KEYWORDS = {
    "ERROR": ["error", "failed", "failure"],
    "WARNING": ["warning", "warn"],
    "CRITICAL": ["critical", "fatal"],
}


def print_header():
    print("=" * 50)
    print("          LINUX LOG MONITOR")
    print("=" * 50)
    print(f"Hostname : {os.uname().nodename}")
    print(f"Date     : {datetime.now()}")
    print(f"Log File : {LOG_FILE}")
    print("=" * 50)
    print()


def check_log_file():
    if not os.path.exists(LOG_FILE):
        print(f"ERROR: Log file not found: {LOG_FILE}")
        return False

    return True


def scan_logs():
    error_count = 0
    warning_count = 0
    critical_count = 0

    print("Scanning logs...")
    print()

    try:
        with open(LOG_FILE, "r", errors="ignore") as log:
            for line in log:

                line_lower = line.lower()

                if any(word in line_lower for word in KEYWORDS["CRITICAL"]):
                    critical_count += 1
                    print(f"[CRITICAL] {line.strip()}")

                elif any(word in line_lower for word in KEYWORDS["ERROR"]):
                    error_count += 1
                    print(f"[ERROR]    {line.strip()}")

                elif any(word in line_lower for word in KEYWORDS["WARNING"]):
                    warning_count += 1
                    print(f"[WARNING]  {line.strip()}")

    except PermissionError:
        print("ERROR: Permission denied.")
        print("Try running the script with sudo.")

        return None

    return error_count, warning_count, critical_count


def print_summary(results):
    if results is None:
        return

    error_count, warning_count, critical_count = results

    print()
    print("=" * 50)
    print("              LOG SUMMARY")
    print("=" * 50)

    print(f"Errors     : {error_count}")
    print(f"Warnings   : {warning_count}")
    print(f"Critical   : {critical_count}")

    print()

    if critical_count > 0:
        print("STATUS     : CRITICAL")
    elif error_count > 0:
        print("STATUS     : WARNING")
    else:
        print("STATUS     : OK")

    print("=" * 50)


def main():
    print_header()

    if not check_log_file():
        return

    results = scan_logs()

    print_summary(results)


if __name__ == "__main__":
    main()

