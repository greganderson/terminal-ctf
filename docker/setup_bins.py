#!/usr/bin/env python3
"""
Parses each challenge's instructions.md to find allowed commands,
then creates /bins/challenge-N/ with symlinks to those binaries only.
Run once at image build time.
"""
import re
import subprocess
from pathlib import Path

import os
CHALLENGES_DIR = Path(os.environ.get("CHALLENGES_DIR", "/challenges"))
BINS_DIR = Path(os.environ.get("BINS_DIR", "/bins"))

# Some challenges say "python" but the binary is python3
COMMAND_ALIASES = {
    "python": "python3",
}

# Shell operators / builtins — not real binaries, always available in bash
SKIP = {">", "<", ">>", "|", "&", "source", "echo", "cd"}

# Always available regardless of challenge restrictions
BASE_COMMANDS = ["ls", "pwd", "man", "clear", "whoami", "id", "python", "mkdir", "chmod",
                 "nroff", "tbl", "groff", "grotty", "troff"]

# challenge-7 has no "Allowed commands" section; define them manually
MANUAL_COMMANDS = {
    "7": ["touch", "man", "ls", "cat"],
}


def which(cmd: str) -> str | None:
    result = subprocess.run(["which", cmd], capture_output=True, text=True)
    return result.stdout.strip() if result.returncode == 0 else None


def parse_allowed_commands(path: Path) -> list[str]:
    """Extract command names from the Allowed Commands section."""
    text = path.read_text()
    commands: list[str] = []
    in_section = False
    for line in text.splitlines():
        if re.search(r"allowed commands", line, re.IGNORECASE):
            in_section = True
            continue
        if in_section:
            m = re.match(r"\s*[*\-]\s+(.+)", line)
            if m:
                for token in re.split(r"[,\s]+", m.group(1)):
                    token = token.strip().strip(",")
                    if token:
                        commands.append(token)
            elif re.match(r"^#+\s", line):
                break
    return commands


base_path = BINS_DIR / "base"
base_path.mkdir(parents=True, exist_ok=True)
for cmd in BASE_COMMANDS:
    resolved_cmd = COMMAND_ALIASES.get(cmd, cmd)
    binary = which(resolved_cmd)
    if binary:
        link = base_path / cmd
        if not link.exists():
            link.symlink_to(binary)
        print(f"base: {cmd} -> {binary}")
    else:
        print(f"WARNING: base command '{cmd}' not found in PATH, skipping")

for challenge_dir in sorted(CHALLENGES_DIR.glob("challenge-*")):
    instructions = challenge_dir / "instructions.md"
    if not instructions.exists():
        continue

    n = challenge_dir.name.split("-")[1]
    bins_path = BINS_DIR / f"challenge-{n}"
    bins_path.mkdir(parents=True, exist_ok=True)

    commands = MANUAL_COMMANDS.get(n) or parse_allowed_commands(instructions)
    print(f"challenge-{n}: {commands}")

    for cmd in commands:
        if cmd in SKIP:
            continue

        # challenge-7 touch uses the local custom binary
        if cmd == "touch" and n == "7":
            custom = challenge_dir / ".tools" / "touch"
            if custom.exists():
                link = bins_path / "touch"
                if not link.exists():
                    link.symlink_to(custom)
                    print(f"  touch -> {custom} (custom)")
            continue

        resolved_cmd = COMMAND_ALIASES.get(cmd, cmd)
        binary = which(resolved_cmd)
        if binary:
            link = bins_path / cmd
            if not link.exists():
                link.symlink_to(binary)
            print(f"  {cmd} -> {binary}")
        else:
            print(f"  WARNING: '{cmd}' not found in PATH, skipping")

print("\nBin directories created successfully.")
