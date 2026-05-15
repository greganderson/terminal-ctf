#!/usr/bin/env python3
import base64
import signal
import sys
import os
import time

FLAG = base64.b64decode(
    b"ZmxhZ3tTSUdVU1IxX3VubG9ja3NfdGhlX2RhZW1vbn0=").decode()


def wrong_handler(sig, frame):
    try:
        sig_name = signal.Signals(sig).name
    except ValueError:
        sig_name = str(sig)
    responses = {
        signal.SIGTERM: "SIGTERM (15): Polite, but I'm ignoring your termination request.",
        signal.SIGHUP:  "SIGHUP (1): I'm not a terminal session, try something else.",
        signal.SIGINT:  "SIGINT (2): Ctrl+C won't save you here.",
        signal.SIGALRM: "SIGALRM (14): No alarm will wake me, try again.",
        signal.SIGUSR2: "SIGUSR2 (12): user-defined, but not the right one. So close.",
    }
    print(f"{responses.get(sig, f"{sig_name} ({sig}): wrong signal.)")}")


def win_handler(sig, frame):
    print(f"SIGUSR1 (10): Good job! Here is your flag: {FLAG}", flush=True)
    sys.exit(0)


signal.signal(signal.SIGTERM, wrong_handler)
signal.signal(signal.SIGHUP,  wrong_handler)
signal.signal(signal.SIGINT,  wrong_handler)
signal.signal(signal.SIGALRM, wrong_handler)
signal.signal(signal.SIGUSR2, wrong_handler)
signal.signal(signal.SIGUSR1, win_handler)

print(f"Signal daemon started (PID {os.getpid()}).")

while True:
    time.sleep(1)
