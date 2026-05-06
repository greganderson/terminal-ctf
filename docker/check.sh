#!/bin/bash
# Placed at /usr/local/bin/check inside the container.
# Uses absolute paths internally so it works even with a restricted user PATH.

CHALLENGE=$(/usr/bin/basename "$PWD")
if [[ ! "$CHALLENGE" =~ ^challenge-[0-9]+$ ]]; then
    echo "Error: run 'check' from inside a challenge directory."
    exit 1
fi

CHALLENGES_DIR="${CHALLENGES_DIR:-/challenges}"
HASH_FILE="$CHALLENGES_DIR/$CHALLENGE/.hash.txt"
if [[ ! -f "$HASH_FILE" ]]; then
    echo "Error: no .hash.txt found for $CHALLENGE."
    exit 1
fi

stored=$(/bin/cat "$HASH_FILE")
/bin/echo -n "Enter flag: "
read -r flag
attempt=$(printf '%s' "$flag" | /usr/bin/sha256sum | /usr/bin/cut -d' ' -f1)

COMPLETED_FILE="/home/ctf/.completed_challenges"

if [[ "$attempt" == "$stored" ]]; then
    echo "Correct! Well done."
    challenge_num="${CHALLENGE#challenge-}"
    if ! /usr/bin/grep -qx "$challenge_num" "$COMPLETED_FILE" 2>/dev/null; then
        /bin/echo "$challenge_num" >> "$COMPLETED_FILE"
    fi
else
    echo "Incorrect. Keep trying!"
fi
