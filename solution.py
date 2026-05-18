import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).parent
ORDER_FILE = ROOT / "challenge_order.json"


def check_solution(flag: str) -> str:
    return hashlib.sha256(flag.encode("utf-8")).hexdigest()


def load_uuid_map() -> dict[str, Path]:
    mapping = {}
    for d in ROOT.glob("challenge-*"):
        if d.is_dir():
            id_file = d / ".id"
            if id_file.exists():
                data = json.loads(id_file.read_text())
                mapping[data["uuid"]] = d
    return mapping


def load_ordered_challenges() -> list[tuple[int, Path]]:
    order = json.loads(ORDER_FILE.read_text())["order"]
    uuid_map = load_uuid_map()
    result = []
    for i, uid in enumerate(order, 1):
        if uid in uuid_map:
            result.append((i, uuid_map[uid]))
    return result


def get_challenge_input(challenges: list[tuple[int, Path]]) -> Path:
    while True:
        print("Which challenge are you checking:\n")
        for num, path in challenges:
            print(f"{num}. {path.name}")
        print()
        try:
            choice = int(input("=> "))
            if 1 <= choice <= len(challenges):
                return challenges[choice - 1][1]
        except ValueError:
            pass
        print(f"Invalid input, please enter a number between 1-{len(challenges)}")


def main() -> None:
    challenges = load_ordered_challenges()
    if not challenges:
        print("No challenges found.")
        return

    challenge_path = get_challenge_input(challenges)

    with open(challenge_path / ".hash.txt") as f:
        solution = f.read().strip()

    input_flag = input("Enter the flag: ")
    attempt = check_solution(input_flag)

    if solution == attempt:
        print("Correct! You found the right flag.")
    else:
        print("Incorrect. Please try again.")


if __name__ == "__main__":
    main()
