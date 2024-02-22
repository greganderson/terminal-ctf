import hashlib
import os


def check_solution(flag: str) -> str:
    bytestr = flag.encode("utf-8")
    hashed = hashlib.sha256(bytestr).hexdigest()
    return hashed

def get_challenge_input() -> int:
    """ Helper function for finding out which challenge the user is testing their flag against """

    # Get the number of challenges. If we decide to change how challenge folders are named, this will need to change as well.
    files = os.listdir(".")
    number_of_challenges = len([file for file in files if os.path.isdir(file) and file.startswith("challenge-")])

    while True:
        print("Which challenge are you checking:")
        print()
        for i in range(1, number_of_challenges+1):
            print(f"{i}. Challenge {i}")
        print()

        try:
            challenge = int(input("=> "))
            if challenge > 0 and challenge <= number_of_challenges:
                return challenge
        except ValueError as e:
            print(f"Invalid input, please enter a number between 1-{number_of_challenges}")

def main() -> None:
    target_challenge = get_challenge_input()

    solution_hash_file_path = f"./challenge-{target_challenge}/.hash.txt"
    with open(solution_hash_file_path, "r") as f:
        solution = f.read().strip()

    input_flag = input("Enter the flag: ")
    attempt = check_solution(input_flag)

    if solution == attempt:
        print("Correct! You found the right flag.")
    else:
        print("Incorrect. Please try again.")

if __name__ == "__main__":
    main()
