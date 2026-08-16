#!/usr/bin/env python3

"""
Linux Service Monitor
---------------------
Checks the status of important Linux services.
"""

import subprocess
from datetime import datetime


# Services to monitor
SERVICES = [
    "ssh",
    "cron",
    "docker",
]


def print_header():
    print("=" * 60)
    print("              LINUX SERVICE MONITOR")
    print("=" * 60)
    print(f"Date : {datetime.now()}")
    print("=" * 60)
    print()


def check_service(service):
    """
    Check the status of a Linux service using systemctl.
    """

    try:
        result = subprocess.run(
            ["systemctl", "is-active", service],
            capture_output=True,
            text=True
        )

        status = result.stdout.strip()

        if status == "active":
            return "RUNNING"

        elif status == "inactive":
            return "STOPPED"

        elif status == "failed":
            return "FAILED"

        else:
            return "NOT FOUND"

    except FileNotFoundError:
        return "systemctl unavailable"


def monitor_services():
    print("Service Status:")
    print()

    results = {}

    for service in SERVICES:

        status = check_service(service)

        results[service] = status

        print(f"{service:<15} : {status}")

    return results


def print_summary(results):
    print()
    print("=" * 60)
    print("                  SUMMARY")
    print("=" * 60)

    running = sum(
        1 for status in results.values()
        if status == "RUNNING"
    )

    stopped = sum(
        1 for status in results.values()
        if status == "STOPPED"
    )

    failed = sum(
        1 for status in results.values()
        if status == "FAILED"
    )

    not_found = sum(
        1 for status in results.values()
        if status == "NOT FOUND"
    )

    print(f"Running    : {running}")
    print(f"Stopped    : {stopped}")
    print(f"Failed     : {failed}")
    print(f"Not Found  : {not_found}")

    print()

    if failed > 0:
        print("OVERALL STATUS : CRITICAL")

    elif stopped > 0:
        print("OVERALL STATUS : WARNING")

    else:
        print("OVERALL STATUS : OK")

    print("=" * 60)


def main():
    print_header()

    results = monitor_services()

    print_summary(results)


if __name__ == "__main__":
    main()

    