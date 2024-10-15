#!/bin/bash

# Configuration - thresholds and log file
CPU_THRESHOLD=90
MEM_THRESHOLD=80
DISK_THRESHOLD=85
FD_THRESHOLD=1000  # File descriptor threshold

LOG_FILE="/var/log/resource_monitor.log"
PID_FILE="/var/run/resource_monitor.pid"
INTERVAL=10  # Monitoring interval in seconds

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        log_message "WARNING: CPU usage is above $CPU_THRESHOLD% - Current: $CPU_USAGE%"
    fi
}

# Function to check memory usage
check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
        log_message "WARNING: Memory usage is above $MEM_THRESHOLD% - Current: $MEM_USAGE%"
    fi
}

# Function to check disk space usage
check_disk() {
    DISK_USAGE=$(df -h / | grep / | awk '{print $5}' | sed 's/%//')
    if (( DISK_USAGE > DISK_THRESHOLD )); then
        log_message "WARNING: Disk usage is above $DISK_THRESHOLD% - Current: $DISK_USAGE%"
    fi
}

# Function to check open file descriptors
check_file_descriptors() {
    FD_COUNT=$(lsof | wc -l)
    if (( FD_COUNT > FD_THRESHOLD )); then
        log_message "WARNING: Number of open file descriptors is above $FD_THRESHOLD - Current: $FD_COUNT"
    fi
}

# Function to stop the script by killing the process
stop_script() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null; then
            echo "Stopping resource monitor (PID: $PID)..."
            kill $PID
            rm -f "$PID_FILE"
            echo "Stopped."
        else
            echo "No running process found with PID: $PID. Cleaning up PID file."
            rm -f "$PID_FILE"
        fi
    else
        echo "No PID file found. Is the script running?"
    fi
}

# Function to start the script
start_script() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null; then
            echo "Resource monitor is already running (PID: $PID)."
            exit 1
        else
            echo "Stale PID file found. Starting new process and cleaning up..."
            rm -f "$PID_FILE"
        fi
    fi

    # Start the monitoring in the background
    echo "Starting resource monitor..."
    log_message "Starting resource monitor..."
    while true; do
        log_message "Starting resource check..."
        check_cpu
        check_memory
        check_disk
        check_file_descriptors
        log_message "Resource check complete."
        sleep $INTERVAL
    done &

    # Save the PID of the background process
    echo $! > "$PID_FILE"
    echo "Resource monitor started (PID: $!)."
}

# Function to restart the script
restart_script() {
    echo "Restarting resource monitor..."
    stop_script
    start_script
}

# Parse the command line arguments
case "$1" in
    start)
        start_script
        ;;
    stop)
        stop_script
        ;;
    restart)
        restart_script
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
