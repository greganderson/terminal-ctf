#!/bin/bash
set -euo pipefail

CHALLENGES_DIR="${CHALLENGES_DIR:-/challenges}"
BINS_DIR="${BINS_DIR:-/bins}"
COMPLETED_FILE="/home/ctf/.completed_challenges"

challenge_dirs=( "$CHALLENGES_DIR"/challenge-* )
if [[ ! -d "${challenge_dirs[0]}" ]]; then
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

    completed=()
    [[ -f "$COMPLETED_FILE" ]] && mapfile -t completed < "$COMPLETED_FILE"

    echo "Select a challenge (1-$n_challenges), or 0 to exit:"
    echo ""
    for i in $(seq 1 "$n_challenges"); do
        mark=""
        for c in "${completed[@]}"; do
            [[ "$c" == "$i" ]] && mark=" ✓" && break
        done
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
    echo "  Type 'cmds' to see available commands."
    echo "  Type 'check' when you have the flag."
    echo "  Press Ctrl+D to return to the menu."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    SESSION_ENV=(
        HOME="$CHALLENGE_DIR"
        PATH="/usr/local/bin:$BINS_DIR/base:$BINS_PATH"
        CHALLENGES_DIR="$CHALLENGES_DIR"
    )
    [[ "$choice" == "7" ]] && SESSION_ENV+=( MANPATH="$CHALLENGE_DIR/.tools" )
    [[ -L "$BINS_PATH/vim" ]] && SESSION_ENV+=( VIMINIT="source /etc/vim/restricted_vimrc" )

    # Drop into a restricted bash session; return here when user types 'exit'.
    # --norc / --noprofile prevent startup files from adding extra commands.
    (cd "$CHALLENGE_DIR" && env "${SESSION_ENV[@]}" /bin/bash --norc --noprofile) || true
done
