#!/bin/bash
# Placed at /usr/local/bin/help inside the container.
# Uses absolute paths internally so it works even with a restricted user PATH.

CHALLENGE=$(/usr/bin/basename "$PWD")
if [[ ! "$CHALLENGE" =~ ^challenge-[0-9]+$ ]]; then
    /bin/echo "Error: run 'help' from inside a challenge directory."
    exit 1
fi

/bin/echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
/bin/echo "  $CHALLENGE"
/bin/echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
/bin/echo ""
/bin/cat "$PWD/instructions.md"
/bin/echo ""
/bin/echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
/bin/echo "  Available commands"
/bin/echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cmds=()
IFS=: read -ra path_dirs <<< "$PATH"
for dir in "${path_dirs[@]}"; do
    [[ -d "$dir" ]] || continue
    for f in "$dir"/*; do
        [[ -x "$f" ]] && cmds+=("$(/usr/bin/basename "$f")")
    done
done

printf '%s\n' "${cmds[@]}" | /usr/bin/sort -u | while read -r cmd; do
    /bin/echo "  $cmd"
done
