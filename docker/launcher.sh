#!/bin/bash
set -euo pipefail

CHALLENGES_DIR="${CHALLENGES_DIR:-/challenges}"
BINS_DIR="${BINS_DIR:-/bins}"

n_challenges=$(ls -d "$CHALLENGES_DIR"/challenge-* 2>/dev/null | wc -l)

clear
cat <<'BANNER'
  _____ ____ _____
 / ____|_  _|  ___|
| |     | | | |_
| |     | | |  _|
| |____| |_|| |
 \_____|___|_|    Terminal CTF

BANNER

while true; do
    echo "Select a challenge (1-$n_challenges):"
    echo ""
    for i in $(seq 1 "$n_challenges"); do
        echo "  $i. Challenge $i"
    done
    echo ""
    read -rp "=> " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= n_challenges )); then
        break
    fi
    echo ""
    echo "Please enter a number between 1 and $n_challenges."
    echo ""
done

CHALLENGE_DIR="$CHALLENGES_DIR/challenge-$choice"
BINS_PATH="$BINS_DIR/challenge-$choice"

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Challenge $choice"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
cat "$CHALLENGE_DIR/instructions.md"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Type 'info' to see available commands."
echo "  Type 'check' when you have the flag."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Build a minimal restricted PATH:
#   - /usr/local/bin  → 'check' command
#   - challenge bins  → only the allowed commands
export PATH="/usr/local/bin:$BINS_DIR/base:$BINS_PATH"
export HOME="$CHALLENGE_DIR"

# challenge-7: custom man page lives in .tools/
if [[ "$choice" == "7" ]]; then
    export MANPATH="$CHALLENGE_DIR/.tools:${MANPATH:-}"
fi

# Prevent vim shell escapes for any challenge that has vim in its bins
if [[ -L "$BINS_PATH/vim" ]]; then
    export VIMINIT="source /etc/vim/restricted_vimrc"
fi

cd "$CHALLENGE_DIR"

# Drop into a bash session with the restricted PATH.
# --norc / --noprofile prevent the user's startup files from adding more commands.
exec /bin/bash --norc --noprofile
