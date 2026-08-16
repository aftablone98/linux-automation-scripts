#!/usr/bin/env python3

"""
Linux Cleanup Automation
------------------------
Finds old temporary files and shows their size
before asking for confirmation to delete them.
"""

import os
from pathlib import Path


# Configuration
CLEANUP_DIR = Path("/tmp")
DAYS_OLD = 7


def print_header():
    print("=" * 60)
    print("              LINUX CLEANUP TOOL")
    print("=" * 60)
    print(f"Cleanup directory : {CLEANUP_DIR}")
    print(f"File age         : {DAYS_OLD}+ days")
    print("=" * 60)
    print()


def find_old_files():
    old_files = []

    current_time = os.path.getmtime(CLEANUP_DIR)

    for file in CLEANUP_DIR.rglob("*"):

        try:
            if file.is_file():

                file_age_seconds = current_time - file.stat().st_mtime
                file_age_days = file_age_seconds / (24 * 60 * 60)

                if file_age_days >= DAYS_OLD:
                    old_files.append(file)

        except (PermissionError, FileNotFoundError):
            continue

    return old_files


def calculate_size(files):
    total_size = 0

    for file in files:

        try:
            total_size += file.stat().st_size

        except (PermissionError, FileNotFoundError):
            continue

    return total_size


def display_files(files):
    print("Old files found:")
    print()

    if not files:
        print("No files older than the configured threshold were found.")
        return

    for file in files:
        print(f"  {file}")

    print()


def cleanup_files(files):
    deleted = 0

    for file in files:

        try:
            file.unlink()
            deleted += 1

        except (PermissionError, FileNotFoundError) as error:
            print(f"Could not delete {file}: {error}")

    return deleted


def main():

    print_header()

    if not CLEANUP_DIR.exists():
        print("ERROR: Cleanup directory does not exist.")
        return

    files = find_old_files()

    display_files(files)

    if not files:
        return

    total_size = calculate_size(files)

    size_mb = total_size / (1024 * 1024)

    print(f"Total cleanup size : {size_mb:.2f} MB")
    print()

    confirmation = input(
        "Delete these files? Type 'yes' to continue: "
    )

    if confirmation.lower() != "yes":
        print()
        print("Cleanup cancelled.")
        return

    deleted = cleanup_files(files)

    print()
    print("=" * 60)
    print("                 CLEANUP COMPLETE")
    print("=" * 60)
    print(f"Files deleted : {deleted}")
    print(f"Space checked : {size_mb:.2f} MB")
    print("Status        : SUCCESS")
    print("=" * 60)


if __name__ == "__main__":
    main()
    