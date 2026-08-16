# 🐧 Linux Automation Scripts




> A collection of practical Bash scripts for automating common Linux system administration and DevOps tasks.

**Linux Automation Scripts** is a hands-on DevOps learning project focused on **Linux, Bash scripting, system administration, monitoring, automation, and reliability**.

The goal is simple: learn Linux by building useful automation instead of only memorizing commands.

---

## 🚀 Project Goals

This project is designed to build practical experience with:

* 🐧 Linux system administration
* 💻 Bash scripting
* ⚙️ Task automation
* 📊 System monitoring
* 💾 Disk and file management
* 🔐 Linux permissions and users
* 🔎 Process and log monitoring
* 🌐 Network troubleshooting
* ⏰ Cron job automation
* 🐳 DevOps fundamentals
* 🔄 CI/CD automation

---

## ✨ Features

The project will gradually include scripts for:

| Category     | Automation                            |
| ------------ | ------------------------------------- |
| 🖥️ System   | System information and resource usage |
| 💾 Storage   | Disk usage and cleanup                |
| 📁 Files     | File and directory operations         |
| 👤 Users     | User and permission management        |
| ⚙️ Processes | Process monitoring                    |
| 📋 Logs      | Log inspection and management         |
| 🌐 Network   | Connectivity and network diagnostics  |
| 💾 Backup    | Automated backups                     |
| ⏰ Scheduling | Cron-based automation                 |
| 🚀 DevOps    | Deployment and operational utilities  |

---

## 📂 Repository Structure

```text
linux-automation-scripts/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── hello.sh
│
├── scripts/
│   ├── system_info.sh
│   ├── disk_usage.sh
│   ├── process_monitor.sh
│   ├── network_check.sh
│   ├── log_monitor.sh
│   ├── backup.sh
│   └── cleanup.sh
│
└── docs/
    └── examples.md
```

The repository will grow as new automation scripts are added.

---

## 🛠️ Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/aftablone98/linux-automation-scripts.git
```

### 2. Enter the project

```bash
cd linux-automation-scripts
```

### 3. Give scripts execute permission

```bash
chmod +x hello.sh
chmod +x scripts/*.sh
```

### 4. Run a script

```bash
./hello.sh
```

Or:

```bash
./scripts/system_info.sh
```

---

## 🐧 Example: System Information

The `system_info.sh` script provides useful information about the Linux system.

Example:

```bash
./scripts/system_info.sh
```

Possible output:

```text
====================================
       LINUX SYSTEM INFORMATION
====================================

Hostname       : ubuntu
Operating System: Ubuntu 24.04
Kernel         : 6.x.x
Architecture   : x86_64
Uptime         : 2 hours
Memory Usage   : 35%
Disk Usage     : 42%
CPU Load       : 0.32
====================================
```

---

## ⚙️ Example: Disk Usage

Check filesystem usage:

```bash
./scripts/disk_usage.sh
```

This script can help identify filesystems that are running out of available space.

---

## 🔍 Example: Process Monitoring

Monitor running processes:

```bash
./scripts/process_monitor.sh
```

Useful commands used in this project include:

```bash
ps
ps -ef
top
htop
kill
```

---

## 🌐 Example: Network Check

The network utility will be used to check basic connectivity and network information.

Example:

```bash
./scripts/network_check.sh
```

It can perform checks such as:

```bash
ping
ip addr
ip route
ss
```

---

## 💾 Backup Automation

A future backup script will automate common backup operations.

Example:

```bash
./scripts/backup.sh
```

Planned capabilities:

* Create compressed backups
* Add timestamps to backup files
* Store backups in a configured directory
* Display backup status
* Handle errors

---

## ⏰ Cron Automation

Some scripts can be executed automatically using Linux Cron.

Example:

```bash
crontab -e
```

Example scheduled task:

```text
0 2 * * * /home/user/linux-automation-scripts/scripts/backup.sh
```

This can be used to run an automated backup every day at 2:00 AM.

---

## 🧠 Linux Concepts Practiced

This project provides hands-on practice with commands such as:

### Files & Directories

```bash
ls
cd
pwd
mkdir
touch
cp
mv
rm
find
```

### Text & Logs

```bash
cat
less
more
head
tail
grep
```

### Permissions

```bash
chmod
chown
ls -l
```

### Processes

```bash
ps
top
htop
kill
killall
```

### Storage

```bash
df
du
tar
```

### Networking

```bash
ping
ip
ss
curl
```

---

## 📈 DevOps Learning Roadmap

This repository will evolve as I continue learning DevOps.

* [x] Linux fundamentals
* [x] Basic Bash scripting
* [x] File and directory automation
* [x] Linux permissions
* [x] User management automation
* [x] Disk monitoring
* [x] Process monitoring
* [ ] Log monitoring
* [ ] Network diagnostics
* [ ] Automated backups
* [ ] Cron automation
* [ ] Error handling and logging
* [ ] Bash script testing
* [ ] GitHub Actions
* [ ] Docker automation
* [ ] Cloud automation
* [ ] Infrastructure automation

---

## 🔄 Future Improvements

Planned improvements include:

* Add command-line arguments to scripts
* Add proper error handling
* Add logging
* Add configuration files
* Add reusable Bash functions
* Add input validation
* Add exit codes
* Add automated testing
* Add GitHub Actions
* Improve documentation
* Add monitoring and alerting examples

---

## 🧪 Project Philosophy

The focus of this project is **learning by building**.

Instead of simply studying Linux commands individually, each script combines multiple Linux concepts into a practical automation task.

The long-term goal is to turn this repository into a small collection of reusable Linux and DevOps utilities.

---

## 📚 What I'm Learning

Through this project, I am developing practical experience with:

```text
Linux
  ↓
Bash
  ↓
Automation
  ↓
Monitoring
  ↓
Git & GitHub
  ↓
Docker
  ↓
CI/CD
  ↓
Cloud
  ↓
DevOps
```

---

## 🤝 Contributing

This is primarily a personal learning project, but suggestions and improvements are welcome.

If you find an issue or have an idea for a useful Linux automation script, feel free to open an issue or submit a pull request.

---

## 👨‍💻 Author

**Aftab Lone**

Computer Science Graduate | Software Engineer | DevOps Engineer

Building practical projects while developing skills in Linux, Python, Bash, Docker, Cloud, CI/CD, and DevOps.

---

## ⭐ Support

If you find this project useful or are also learning Linux and DevOps, consider giving the repository a ⭐.

---

### 🐧 Keep Learning. Keep Automating. Keep Building.

**Designed & coded from scratch by Aftab with ❤️**


