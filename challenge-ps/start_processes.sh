#!/usr/bin/env bash
set -e

PIDS_FILE="/tmp/ctf16_pids.txt"
CHALLENGE_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$PIDS_FILE" ]; then
    echo "Challenge processes are already running. Run cleanup.sh first if you want to restart."
    exit 1
fi

# Start decoy processes
for name in log_monitor cache_worker sync_daemon data_collector backup_service metric_aggregator event_listener; do
    (exec -a "$name" sleep infinity) &
    echo $! >> "$PIDS_FILE"
done

# Start the target process
(exec -a "secret_monitor" sleep infinity) &
TARGET_PID=$!
echo "$TARGET_PID" >> "$PIDS_FILE"

# Write the flag hash so solution.py can validate the answer
echo -n "$TARGET_PID" | sha256sum | awk '{print $1}' > "$CHALLENGE_DIR/.hash.txt"

echo "Challenge ready. Find the process named 'secret_monitor' and submit its PID."
