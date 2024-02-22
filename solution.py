import argparse
import hashlib
import sys

def check_solution(flag: str) -> str:
    bytestr = flag.encode("utf-8")
    hashed = hashlib.sha256(bytestr).hexdigest()
    return hashed

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("flag", help = "The flag you want to test")
    parser.add_argument("-c", "--challenge", help = "The challenge you want to check the solution for")

    flag_hashes = {
        '1': "486ea46224d1bb4fb680f34f7c9ad96a8f24ec88be73ea8e5a6c65260e9cb8a7",
        '2': "4239f9001d16108ff224bcf0d0ec8f458234a5c7c2d6838150c3a203e21fa035",
        '3': "7de8c4055cab88cc1111d6b101e8e17f2d2d2edaa96f961ffc131489eeb6d690",
        '4': "./challenge-4/.hash.txt"
    }

    args = parser.parse_args()
    if len(sys.argv) == 1:
        parser.print_help()
        return

    solution = None
    attempt = check_solution(args.flag)
    if flag_hashes[args.challenge].startswith("./"):
        fobj = open(flag_hashes[args.challenge])
        solution = fobj.readlines()[0].strip()
    else:
        solution = flag_hashes[args.challenge]

    if solution == attempt:
        print("Correct! You found the right flag.")
    else:
        print("Incorrect. Please try again.")

if __name__ == "__main__":
    main()
