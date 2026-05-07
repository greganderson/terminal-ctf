import random
import string
import base64

FILES = 1000

def _rand_line(n):
    pool = string.ascii_letters + string.digits + "   "
    return "".join(random.choice(pool) for _ in range(n))

_enc = "SGVyZSBpcyB5b3VyIHByaXplOiBmbGFne25lZWRsZV9pbl90aGVfaGF5c3RhY2t9"
_msg = base64.b64decode(_enc).decode()
_n = random.randint(1, FILES)

for i in range(1, FILES + 1):
    with open(f"file_{i:02d}.txt", "w") as f:
        if i == _n:
            f.write(_msg)
        else:
            f.write("\n".join(_rand_line(random.randint(30, 80)) for _ in range(random.randint(5, 10))))
