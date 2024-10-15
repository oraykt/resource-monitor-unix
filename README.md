# Resource Monitor Script

A bash script to monitor system resource usage (CPU, memory, disk space, and open file descriptors) in real-time on a Unix server. The script supports starting, stopping, and restarting, making it suitable for long-term monitoring during debugging sessions or for production system health checks.

## Features
- Monitors system resource usage:
  - **CPU usage**
  - **Memory usage**
  - **Disk space usage**
  - **Open file descriptors (FD)**
- Logs warnings if resource usage exceeds user-defined thresholds.
- Supports process management:
  - Start, stop, and restart operations.
- Customizable thresholds for all monitored resources.
- Logs are saved to a configurable log file.

## Requirements
- Unix-based system (e.g., RHEL, CentOS, Ubuntu).
- Bash shell.
- Basic knowledge of Unix commands.
- Sudo or root privileges are not required for normal usage, but they may be necessary for certain environments (e.g., accessing system resources like file descriptors).

## Configuration

### Default Configuration:
The script includes configurable thresholds for resource monitoring and file locations. The defaults can be modified by editing the script variables.

- **CPU Threshold:** 90% (`CPU_THRESHOLD`)
- **Memory Threshold:** 80% (`MEM_THRESHOLD`)
- **Disk Usage Threshold:** 85% (`DISK_THRESHOLD`)
- **Open File Descriptors Threshold:** 1000 (`FD_THRESHOLD`)
- **Monitoring Interval:** 10 seconds (`INTERVAL`)
- **Log File Location:** `/var/log/resource_monitor.log` (`LOG_FILE`)
- **PID File Location:** `/var/run/resource_monitor.pid` (`PID_FILE`)

### Customizing the Script:
To modify any of these settings, edit the corresponding variables at the top of the script:

```bash
CPU_THRESHOLD=90
MEM_THRESHOLD=80
DISK_THRESHOLD=85
FD_THRESHOLD=1000
LOG_FILE="/var/log/resource_monitor.log"
INTERVAL=10
PID_FILE="/var/run/resource_monitor.pid"
```

- Adjust thresholds to suit your application's needs.
- Change the log file location if required.
- Modify the PID file path if /var/run/ isn't writable by the user.

## Installation 

1. Clone or download the script to your unix server

2. Make the script executable

```bash
chmod +x resource_monitor.sh
```

## Usage

The script supports three modes of operation: `start`, `stop`, and `restart`.

### Starting the Resource Monitor

To start monitoring system resources, use the start flag:

```bash
./resource_monitor.sh start
```

This will:

- Start the resource monitoring in the background.
- Save the process ID (PID) in /var/run/resource_monitor.pid.
- Begin logging resource metrics and threshold breaches to /var/log/resource_monitor.log.

### Stopping the Resource Monitor

To stop the monitoring process, use the stop flag:

```bash
./resource_monitor.sh stop
```

This will:

- Kill the running process based on the PID stored in /var/run/resource_monitor.pid.
- Remove the PID file once the process is stopped.

### Restarting the Resource Monitor

To restart the monitoring process, use the restart flag:

```bash
./resource_monitor.sh restart
```

This will:

- Stop the currently running resource monitor (if any).
- Start a new instance of the resource monitor.

### Checking the Resource Monitor Status

To check the status of the monitoring process, use the `ps` command:

```bash
ps -p $(cat /var/run/resource_monitor.pid)
```

This will display the status of the monitoring process, including CPU usage, memory usage, disk space usage, and open file descriptors.

### Checking Logs

Logs are saved to the file defined in the LOG_FILE variable (default: `/var/log/resource_monitor.log`). You can monitor the logs for any warnings or threshold breaches:

```bash
tail -f /var/log/resource_monitor.log
```

### Script Usage Summary

```bash
Usage: ./resource_monitor.sh {start|stop|restart}
```

- `start`: Starts the resource monitor if it's not already running.
- `stop`: Stops the resource monitor if it's running.
- `restart`: Stops the monitor (if running) and starts it again.

# Example Scenarios

## Scenario 1: Monitor CPU and Memory Usage on a Web Server

You have a web server running on RHEL 7, and you suspect that high CPU and memory usage are causing performance issues. You want to monitor these metrics continuously and log warnings if thresholds are exceeded.

1. Open the script and adjust the thresholds for CPU and memory usage:

```bash
CPU_THRESHOLD=85  # Warn if CPU usage exceeds 85%
MEM_THRESHOLD=75  # Warn if memory usage exceeds 75%
```
2. Start the resource monitor:

```bash
./resource_monitor.sh start
```

3. Periodically check the log file for any warnings about resource overuse:

```bash
tail -f /var/log/resource_monitor.log
```

## Scenario 2: Detect Disk Space Issues on an Application Server

You're running a database-heavy application, and you want to ensure that disk space usage doesn't exceed a certain limit, potentially causing the application to fail.

Edit the script to set the disk space threshold:

```bash
DISK_THRESHOLD=90  # Warn if disk space usage exceeds 90%
Start the resource monitor:
```

```bash
./resource_monitor.sh start
When disk space usage exceeds 90%, a warning will be logged in /var/log/resource_monitor.log. Use the following command to monitor:
```

```bash
tail -f /var/log/resource_monitor.log
```

### Example Log Output

Here is an example of the output that will be written to the log file when the resource monitor detects high resource usage:

```
2024-10-15 15:12:10 - Starting resource check...
2024-10-15 15:12:11 - WARNING: CPU usage is above 90% - Current: 92.3%
2024-10-15 15:12:11 - WARNING: Memory usage is above 80% - Current: 85.6%
2024-10-15 15:12:11 - Resource check complete.
```

# Troubleshooting

## Problem: The script won't start.

- **Solution**: Ensure the script is executable:

```bash
chmod +x resource_monitor.sh
```

## Problem: The script won't stop.

- **Solution**: Make sure the script is running by checking the process ID file:

```bash
cat /var/run/resource_monitor.pid
```

If the PID is stale (no such process is running), delete the PID file and try stopping again:

```bash
rm -f /var/run/resource_monitor.pid
./resource_monitor.sh stop
```

## Problem: I can't access the /var/run/ directory.

- **Solution**: You can change the location of the PID file to a user-writable directory:

```bash
PID_FILE="/path/to/your/pidfile.pid"
```
# License

This script is licensed under the MIT License. You are free to use, modify, and distribute it as needed.

# Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to enhance the functionality of this resource monitor script.

# Contact

For any questions or issues, feel free to reach out to me 