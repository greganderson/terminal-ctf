#!/usr/bin/env bash

PIDS_FILE="/tmp/ctf16_signal_pid.txt"
LOGFILE="/tmp/ctf16_signal.log"

if [ ! -f "$PIDS_FILE" ]; then
    echo "No daemon found. Nothing to clean up."
    exit 0
fi

killed=0
while IFS= read -r pid; do
    if kill -9 "$pid" 2>/dev/null; then
        killed=$((killed + 1))
    fi
done < "$PIDS_FILE"

rm -f "$PIDS_FILE" "$LOGFILE"
echo "Stopped $killed daemon process(es) and cleared log."
