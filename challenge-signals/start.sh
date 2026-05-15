#!/usr/bin/env bash
set -e

PIDS_FILE="/tmp/ctf16_signal_pid.txt"
CHALLENGE_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$PIDS_FILE" ]; then
    echo "Daemon is already running. Run ./cleanup.sh first to restart."
    exit 1
fi

python3 "$CHALLENGE_DIR/daemon.py" &
DAEMON_PID=$!
echo "$DAEMON_PID" > "$PIDS_FILE"

sleep 0.3

echo "Signal daemon started."
