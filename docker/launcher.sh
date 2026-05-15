#!/bin/bash
set -euo pipefail

CHALLENGES_DIR="${CHALLENGES_DIR:-/challenges}"
BINS_DIR="${BINS_DIR:-/bins}"
COMPLETED_FILE="/home/ctf/.completed_challenges"

# Build ordered list of challenge directories from challenge_order.json + .id files
mapfile -t challenge_dirs < <(python3 -c "
import json, os, sys
challenges_dir = os.environ.get('CHALLENGES_DIR', '/challenges')
order_file = os.path.join(challenges_dir, 'challenge_order.json')
try:
    with open(order_file) as f:
        order = json.load(f)['order']
    uuid_map = {}
    for entry in os.scandir(challenges_dir):
        if entry.is_dir() and entry.name.startswith('challenge-'):
            id_file = os.path.join(entry.path, '.id')
            if os.path.exists(id_file):
                with open(id_file) as f2:
                    uuid_map[f2.read().strip()] = entry.path
    for uid in order:
        if uid in uuid_map:
            print(uuid_map[uid])
except Exception as e:
    print(str(e), file=sys.stderr)
")

if [[ ${#challenge_dirs[@]} -eq 0 ]]; then
    echo "Error: no challenges found in $CHALLENGES_DIR"
    exit 1
fi
n_challenges=${#challenge_dirs[@]}

show_banner() {
    clear
    cat <<'BANNER'
  _____ ____ _____
 / ____|_  _|  ___|
| |     | | | |_
| |     | | |  _|
| |____| |_|| |
 \_____|___|_|    Terminal CTF

BANNER
}

while true; do
    show_banner

    echo "Select a challenge (1-$n_challenges), or 0 to exit:"
    echo ""
    for i in $(seq 1 "$n_challenges"); do
        mark=""
        challenge_name="$(basename "${challenge_dirs[$((i-1))]}")"
        [[ -f "$COMPLETED_FILE" ]] && /usr/bin/grep -Fxq "$challenge_name" "$COMPLETED_FILE" && mark=" ✓"
        echo "  $i. Challenge $i$mark"
    done
    echo "  0. Exit"
    echo ""
    read -rp "=> " choice || exit 0

    if [[ "$choice" == "0" ]]; then
        exit 0
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > n_challenges )); then
        echo ""
        echo "Please enter a number between 0 and $n_challenges."
        read -rp "Press Enter to continue..." _ || true
        continue
    fi

    CHALLENGE_DIR="${challenge_dirs[$((choice-1))]}"
    challenge_name="$(basename "$CHALLENGE_DIR")"
    BINS_PATH="$BINS_DIR/challenge-$choice"

    clear
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Challenge $choice"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    cat "$CHALLENGE_DIR/instructions.md"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Type 'cmds' to see available commands."
    echo "  Type 'check' when you have the flag."
    echo "  Press Ctrl+D to return to the menu."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    SESSION_ENV=(
        HOME="$CHALLENGE_DIR"
        XDG_CACHE_HOME="/home/ctf/.cache"
        PATH="/usr/local/bin:$BINS_DIR/base:$BINS_PATH"
        CTF_BINS_PATH="$BINS_PATH"
        CHALLENGES_DIR="$CHALLENGES_DIR"
        MANPATH="/usr/share/man:/usr/local/share/man"
    )
    [[ "$challenge_name" == "challenge-man" ]] && SESSION_ENV+=( MANPATH="$CHALLENGE_DIR/.tools:/usr/share/man:/usr/local/share/man" )
    [[ -L "$BINS_PATH/vim" ]] && SESSION_ENV+=( VIMINIT="source /etc/vim/restricted_vimrc" )

    # Drop into a restricted bash session; return here when user types 'exit'.
    # --norc / --noprofile prevent startup files from adding extra commands.
    (cd "$CHALLENGE_DIR" && env "${SESSION_ENV[@]}" /bin/bash --norc --noprofile) || true
done
