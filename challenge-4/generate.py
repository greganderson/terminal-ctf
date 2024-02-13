import os
import random
import uuid


depth = 5
num_dirs = 5


class Dir:

    def __init__(self, name: str):
        self.name = name
        self.children = []

    def add_child(self, child) -> None:
        self.children.append(child)

def create_dir(num_dirs: int, depth: int) -> Dir:
    d = "".join(str(uuid.uuid4()).split("-"))
    dirname = Dir(name=d)

    if depth == 0:
        return dirname

    for i in range(num_dirs):
        child = create_dir(num_dirs, depth-1)
        dirname.add_child(child)

    return dirname


root = create_dir(num_dirs, depth)

def generate_paths(root: Dir) -> list[str]:
    if len(root.children) == 0:
        return [root.name]

    paths = []
    for child in root.children:
        child_paths = generate_paths(child)
        for path in child_paths:
            paths.append(f"{root.name}/{path}")

    return paths


paths = generate_paths(root)

print("Creating directories...")
percent = len(paths) // 10
percent_progress = 0
for i, path in enumerate(paths):
    if i % percent == 0:
        percent_progress += 10
        print(f"{percent_progress}% complete")
    os.system(f"mkdir -p {path}")
print("Directory creation complete.")

flag_dir_depth = random.randint(3, 5)
flag_dir = random.choice(paths)

print("Generating flag...")
flag_path = "/".join(flag_dir.split("/")[:flag_dir_depth])
flag = uuid.uuid4()
flag_contents = f"flag{{{flag}}}"

os.system(f"echo {flag_contents} > {path}/flag.txt")

print("Flag generated.")

# TODO: Get hash of flag and output for the checker script