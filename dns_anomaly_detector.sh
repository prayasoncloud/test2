#!/bin/bash

INTERVAL=60
INTERFACE="any"

NX_THRESH=0.3

TOTAL_NX_THRESHOLD=50

while true; do

    START_TIME=$(date +%s)

    OUTPUT=$(timeout ${INTERVAL}s tcpdump -nn -l -i "$INTERFACE" port 53 2>/dev/null)

    DNS_LINES=$(echo "$OUTPUT" | grep -E "A\?|AAAA\?")

    TOTAL=$(echo "$DNS_LINES" | wc -l)

    NX_DNS=$(echo "$OUTPUT" | grep -i "NXDomain")

    NX=$(echo "$NX_DNS" | wc -l)

    DOMAINS=$(echo "$NX_DNS" | sed -n 's/.* \(.*\)\. A\?.*/\1/p; s/.* \(.*\)\. AAAA\?.*/\1/p')

    TOTAL_UNIQ_NX=$(echo "$DOMAINS" | sort -u | wc -l)

    if [ "$TOTAL" -gt 0 ]; then
        NX_RATIO=$(awk "BEGIN {printf \"%.4f\", $NX/$TOTAL}")
    else
        NX_RATIO=0
    fi


    if awk "BEGIN {exit !($NX_RATIO > $NX_THRESH)}" && [ "$TOTAL_UNIQ_NX" -gt "$TOTAL_NX_THRESHOLD" ]; then
        echo "[ALERT !!] NX crossing the threshold"
        echo "Domains:"
        echo "$DOMAINS" | sort | uniq -c | sort -nr | head -10
    fi

    END_TIME=$(date +%s)

    SCRIPT_TIME=$((END_TIME - START_TIME))

    if [ "$SCRIPT_TIME" -lt "$INTERVAL" ]; then
        sleep $((INTERVAL - SCRIPT_TIME))
    fi

done