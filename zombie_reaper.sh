#!/bin/bash

echo "starting zombie reaper"

while true; do
    for pid in $(ls /proc | grep -E '^[0-9]+$'); do

        if [ -f "/proc/$pid/status" ]; then
            pid_state=$(grep "^State:" /proc/$pid/status | awk '{print $2}')
            if [ "$pid_state" = "Z" ]; then
                ppid=$(grep "^PPid:" /proc/$pid/status | awk '{print $2}')
                echo "[zombie found] PID:$pid n PPID:$ppid"
                kill -SIGCHLD "$ppid" 2>/dev/null
            fi

        fi
    done

    sleep 30
done
