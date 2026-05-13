#!/bin/bash
# Placed at /usr/local/bin/cmds inside the container.
# Uses absolute paths internally so it works even with a restricted user PATH.

/bin/echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
/bin/echo "  Available commands"
/bin/echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ -n "${CTF_BINS_PATH:-}" && -f "$CTF_BINS_PATH/.visible" ]]; then
    while IFS= read -r cmd; do
        [[ -n "$cmd" ]] && /bin/echo "  $cmd"
    done < "$CTF_BINS_PATH/.visible"
else
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
fi
