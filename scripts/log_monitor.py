#!/usr/bin/env python3

"""
Linux Log Monitor
-----------------
Scans Linux logs and reports errors, warnings,
and critical messages.
"""

import os
import re
from datetime import datetime


LOG_FILE = "/var/log/syslog"

MAX_DISPLAY = 10

KEYWORDS = {
    "CRITICAL": [
        "critical",
        "fatal",
        "panic",
    ],
    "ERROR": [
        "error",
        "failed",
        "failure",
    ],
    "WARNING": [
        "warning",
        "warn",
    ],
}


def print_header():
    print("=" * 60)
    print("              LINUX LOG MONITOR")
    print("=" * 60)
    print(f"Hostname : {os.uname().nodename}")
    print(f"Date     : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Log File : {LOG_FILE}")
    print("=" * 60)
    print()


def check_log_file():
    if not os.path.exists(LOG_FILE):
        print(f"ERROR: Log file not found: {LOG_FILE}")
        return False

    if not os.access(LOG_FILE, os.R_OK):
        print(f"ERROR: Permission denied: {LOG_FILE}")
        return False

    return True


def classify_log(line):
    """
    Identify the severity of a log message.
    """

    line_lower = line.lower()

    for severity in ["CRITICAL", "ERROR", "WARNING"]:
        for keyword in KEYWORDS[severity]:
            if re.search(rf"\b{re.escape(keyword)}\b", line_lower):
                return severity

    return None


def scan_logs():
    counts = {
        "CRITICAL": 0,
        "ERROR": 0,
        "WARNING": 0,
    }

    messages = {
        "CRITICAL": [],
        "ERROR": [],
        "WARNING": [],
    }

    print("Scanning logs...")
    print()

    try:
        with open(LOG_FILE, "r", errors="ignore") as log:

            for line in log:

                severity = classify_log(line)

                if severity:
                    counts[severity] += 1

                    if len(messages[severity]) < MAX_DISPLAY:
                        messages[severity].append(line.strip())

    except PermissionError:
        print("ERROR: Permission denied while reading the log.")
        return None, None

    return counts, messages


def print_messages(messages):
    for severity in ["CRITICAL", "ERROR", "WARNING"]:

        if not messages[severity]:
            continue

        print("-" * 60)
        print(f"{severity} MESSAGES")
        print("-" * 60)

        for message in messages[severity]:
            print(f"[{severity}] {message}")

        print()


def print_summary(counts):

    print("=" * 60)
    print("                 LOG SUMMARY")
    print("=" * 60)

    print(f"Critical Messages : {counts['CRITICAL']}")
    print(f"Error Messages    : {counts['ERROR']}")
    print(f"Warning Messages  : {counts['WARNING']}")

    print()

    if counts["CRITICAL"] > 0:
        status = "CRITICAL"
    elif counts["ERROR"] > 0:
        status = "WARNING"
    elif counts["WARNING"] > 0:
        status = "ATTENTION"
    else:
        status = "OK"

    print(f"Overall Status     : {status}")

    print("=" * 60)


def main():

    print_header()

    if not check_log_file():
        return

    counts, messages = scan_logs()

    if counts is None:
        return

    print_messages(messages)

    print_summary(counts)


if __name__ == "__main__":
    main()