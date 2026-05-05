import time, base64 as _b, sys

print("Starting process...")
time.sleep(0.5)
print("Processing data...")
time.sleep(0.5)
print("ALMOST THERE...")
time.sleep(0.5)
if sys.stdout.isatty():
    print("(output not captured — redirect to a file to see the flag)")
else:
    print(_b.b64decode(b'ZmxhZ3tyZWRpcmVjdGVkX2FuZF9jYXB0dXJlZH0=').decode())
