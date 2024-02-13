import os
import uuid


depth = 2
num_dirs = 2


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
        return root.name

    paths = []
    for child in root.children:
        child_paths = generate_paths(child)
        # TODO: Stopped here
        if type(child_paths) == str:
        for path in child_paths:
            paths.append(f"{root.name}/{path}")

    return paths


paths = generate_paths(root)
