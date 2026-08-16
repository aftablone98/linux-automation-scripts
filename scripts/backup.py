#!/usr/bin/env python3

"""
Linux Backup Automation
-----------------------
Creates a compressed .tar.gz backup
of a specified directory.
"""

import os
import tarfile
from datetime import datetime


# Configuration
SOURCE_DIR = os.path.expanduser("~/linux-automation-scripts")
BACKUP_DIR = os.path.expanduser("~/linux-backups")


def print_header():
    print("=" * 55)
    print("             LINUX BACKUP AUTOMATION")
    print("=" * 55)
    print(f"Source      : {SOURCE_DIR}")
    print(f"Backup      : {BACKUP_DIR}")
    print(f"Date        : {datetime.now()}")
    print("=" * 55)
    print()


def create_backup_directory():
    os.makedirs(BACKUP_DIR, exist_ok=True)


def create_backup():
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

    backup_name = f"linux-automation-backup-{timestamp}.tar.gz"
    backup_path = os.path.join(BACKUP_DIR, backup_name)

    print("Creating backup...")
    print()

    with tarfile.open(backup_path, "w:gz") as archive:
        archive.add(
            SOURCE_DIR,
            arcname=os.path.basename(SOURCE_DIR)
        )

    return backup_path


def show_backup_info(backup_path):
    backup_size = os.path.getsize(backup_path)

    print("=" * 55)
    print("             BACKUP COMPLETED")
    print("=" * 55)
    print(f"Backup file : {backup_path}")
    print(f"Backup size : {backup_size / (1024 * 1024):.2f} MB")
    print("Status      : SUCCESS")
    print("=" * 55)


def main():
    print_header()

    if not os.path.exists(SOURCE_DIR):
        print("ERROR: Source directory does not exist.")
        return

    create_backup_directory()

    backup_path = create_backup()

    show_backup_info(backup_path)


if __name__ == "__main__":
    main()
