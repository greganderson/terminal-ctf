import hashlib
import sys

def check_solution(flag: str) -> bool:
    bytestr = flag.encode("utf-8")
    hashed = hashlib.sha256(bytestr).hexdigest()
    return hashed

def main():
    flag = sys.argv[1]
    hashed = check_solution(flag)
    flags = [
        "486ea46224d1bb4fb680f34f7c9ad96a8f24ec88be73ea8e5a6c65260e9cb8a7",
        "4239f9001d16108ff224bcf0d0ec8f458234a5c7c2d6838150c3a203e21fa035",
        "7de8c4055cab88cc1111d6b101e8e17f2d2d2edaa96f961ffc131489eeb6d690",
    ]
    if hashed in flags:
        print("Correct!")
    else:
        print("Incorrect!")
        print(hashed)

if __name__ == "__main__":
    main()