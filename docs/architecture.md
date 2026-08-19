# 🏗️ Project Architecture

## Linux Automation Scripts

```text
                  Linux Automation Scripts
                            │
             ┌──────────────┴──────────────┐
             │                             │
          Bash                          Python
             │                             │
     ┌───────┼────────┐             ┌──────┼──────┐
     │       │        │             │      │      │
   System   Disk    Network       Logs  Cleanup  Backup
   Monitor Monitor  Check
     │       │        │
     └───────┴────────┘
             │
       Health Check
             │
             ▼
       GitHub Actions
             │
       ┌─────┴─────┐
       │           │
   ShellCheck   Bash Tests
       │           │
       └─────┬─────┘
             ▼
          CI PASS


🔧 Components
Bash Automation

Handles Linux system administration tasks:

System information
Disk monitoring
Process monitoring
Network diagnostics
Server health checks
User management
Python Automation

Handles:

Log monitoring
Backup automation
File cleanup
Service monitoring
GitHub Actions

Automatically:

Checks out the repository
Runs ShellCheck
Validates Bash syntax
Runs health checks
Tests command-line functionality


Developer
    │
    ▼
Git Push
    │
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    ├── ShellCheck
    ├── Bash Syntax Check
    └── Health Check
    │
    ▼
  CI PASS ✅

