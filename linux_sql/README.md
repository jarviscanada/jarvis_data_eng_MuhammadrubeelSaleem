
# Linux Cluster Monitoring Agent

## Introduction
This project simulates a lightweight **Linux cluster monitoring system** for tracking server hardware and resource utilization across multiple nodes.  
The system automatically collects **hardware specifications** and **real-time usage metrics** (CPU, memory, and disk) from Linux hosts and stores them in a centralized **PostgreSQL database** running in a **Docker container**.

The collected data enables **Linux Cluster Administrators (LCA)** to analyze system performance and make informed decisions about resource scaling.  
The project leverages **Bash scripting**, **Docker**, **PostgreSQL**, **Git**, and **crontab** to demonstrate real-world DevOps automation and data engineering workflows.

## Quick Start
```bash
# 1 Start a PostgreSQL instance in Docker
./scripts/psql_docker.sh start

# 2 Create database tables
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# 3 Insert hardware specs into DB
./scripts/host_info.sh localhost 5432 host_agent postgres password

# 4 Insert host usage data
./scripts/host_usage.sh localhost 5432 host_agent postgres password
```
---

# Implementation

### Architecture
Each host runs two Bash agents:
- `host_info.sh`: collects static hardware information once.
- `host_usage.sh`: collects live resource data every minute.

All hosts connect to a central PostgreSQL database inside a Docker container.  
The architecture diagram (below) illustrates the cluster setup with **three hosts** sending data to one database node.

---

### Scripts Overview

#### `psql_docker.sh`
Automates the **creation and management** of the PostgreSQL Docker container.
```bash
# Usage:
./scripts/psql_docker.sh start|stop|create
```
- `create`: Pulls the image and initializes the DB container.
- `start` / `stop`: Manages container lifecycle.

---

#### `host_info.sh`
Collects and inserts **hardware information** into the `host_info` table.
```bash
# Usage:
./scripts/host_info.sh <psql_host> <psql_port> <db_name> <user> <password>
```
Runs once per host during setup to record CPU, memory, and architecture details.

---

#### `host_usage.sh`
Collects **real-time resource usage** (CPU idle, memory free, disk space) and inserts it into `host_usage` every minute.
```bash
# Usage:
./scripts/host_usage.sh <psql_host> <psql_port> <db_name> <user> <password>
```

---

####  `crontab`
Automates periodic execution of `host_usage.sh` for continuous monitoring.
```bash
# Example:
* * * * * bash ~/linux_sql/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
```

---

#### `queries.sql`
Contains SQL queries for cluster analytics, such as:
- Average CPU usage per host
- Memory usage trends over time
- Available disk space analysis

These help administrators with capacity planning and performance optimization.
##  Database Modeling

### `host_info`
| Column | Type | Description |
|---------|------|-------------|
| id | SERIAL | Unique host ID |
| hostname | VARCHAR | Fully qualified host name |
| cpu_number | SMALLINT | Number of CPU cores |
| cpu_architecture | VARCHAR | CPU architecture (e.g., x86_64) |
| cpu_model | VARCHAR | CPU model name |
| cpu_mhz | FLOAT | CPU clock speed |
| l2_cache | INTEGER | L2 cache size in KB |
| total_mem | INTEGER | Total memory in KB |
| timestamp | TIMESTAMP | Record creation time (UTC) |

---

### `host_usage`
| Column | Type | Description |
|---------|------|-------------|
| timestamp | TIMESTAMP | Data collection time |
| host_id | INTEGER | References host_info(id) |
| memory_free | INTEGER | Free memory (MB) |
| cpu_idle | SMALLINT | CPU idle percentage |
| cpu_kernel | SMALLINT | CPU kernel usage (%) |
| disk_io | INTEGER | Disk I/O count |
| disk_available | INTEGER | Available disk space (MB) |

---

## Test
All Bash scripts were tested manually on a Rocky Linux VM connected to a PostgreSQL container.
- Verified successful insertion of static and dynamic data into the DB.
- Confirmed cron executes `host_usage.sh` every minute without overlap.
- Validated that analytical SQL queries return accurate metrics.  
  All tests passed successfully, confirming correct functionality and data flow.

---

## Deployment
- PostgreSQL instance deployed in **Docker** (`postgres:9.6-alpine`)
- Scripts version-controlled on **GitHub**
- **Crontab** used for periodic automation
- Tested on **Rocky Linux 9** host environment

---

## Improvements
1. Add **alert notifications** for high CPU/memory usage.
2. Support **dynamic hardware updates** when system configuration changes.
3. Build a **visual dashboard** using Grafana or Power BI for real-time insights.
