#!/bin/bash

MEM_THRESHOLD=80
CPU_THRESHOLD=70
LIMITS=3


STATE_FILE=/tmp/watchdog_state.txt
touch $STATE_FILE

while true; do
    > $STATE_FILE.new

    ps -eo pid,%cpu,%mem,comm --no-header | while read pid cpu mem cmd; do

        if [ "$pid" -lt 1000 ]; then
            continue
        fi

        cpu_int=${cpu%.*}
        mem_int=${mem%.*}
        
        if [ "$cpu_int" -gt "$CPU_THRESHOLD" ] || [ "$mem_int" -gt "$MEMO_THRESHOLD" ]; then
            
            prev_count=(grep "$pid" "$STATE_FILE"| awk "{print $2}")
            [ -z "$prev_count" ] && prev_count=0

            count=$((prev_count + 1))

            echo "$pid" "$count" >> $STATE_FILE.new

            if [ $count -ge $LIMITS ]; then
                echo  "ALert!!! PID:$pid Cmd=$cmd Cpu=$cpu% Mem=$mem%"
            fi
        fi
    done
    mv $STATE_FILE.new $STATE_FILE
    sleep 2
done

            




