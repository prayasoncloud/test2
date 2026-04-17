#!/bin/bash

CGROUP="/sys/fs/cgroup/mygroup"

HIGH_MEM=$((100 * 1024 * 1024))   
LOW_MEM=$((50 * 1024 * 1024))  

HIGH_CPU="80000 100000" 
LOW_CPU="20000 100000" 

while true; do
    MEM=$(cat "$CGROUP/memory.current")

    if [ "$MEM" -gt "$HIGH_MEM" ]; then
	
        echo "[THROTTLE] Memory high: $MEM bytes"
		
        echo "$LOW_CPU" > "$CGROUP/cpu.max"
		
        echo "$HIGH_MEM" > "$CGROUP/memory.max"

    elif [ "$MEM" -lt "$LOW_MEM" ]; then
	
        echo "[RELAX] Memory normal: $MEM bytes"
		
        echo "max 100000" > "$CGROUP/cpu.max"
        echo "max" > "$CGROUP/memory.max"
    fi

    sleep 2
done
