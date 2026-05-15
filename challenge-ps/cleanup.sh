#!/usr/bin/env bash

PIDS_FILE="/tmp/ctf16_pids.txt"

if [ ! -f "$PIDS_FILE" ]; then
    echo "No challenge processes found. Nothing to clean up."
    exit 0
fi

killed=0
while IFS= read -r pid; do
    if kill "$pid" 2>/dev/null; then
        killed=$((killed + 1))
    fi
done < "$PIDS_FILE"

rm -f "$PIDS_FILE"
echo "Stopped $killed challenge process(es)."
