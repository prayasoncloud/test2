#!/bin/bash

echo "Starting OOM watcher"

# Get initial OOM kill count
prev=$(grep oom_kill /proc/vmstat | awk '{print $2}')

while true; do
    curr=$(grep oom_kill /proc/vmstat | awk '{print $2}')

    if [ "$curr" -gt "$prev" ]; then
        killed=$((curr - prev))
        echo "OOM DETECTED bro: Kernel killed $killed procs"

	killed_proc=$(dmesg | grep -i "Killed process")

	echo $killed_proc
        
        prev=$curr
    fi

    sleep 2
done
