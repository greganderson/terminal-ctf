import uvicorn
from fastapi import FastAPI

alphabet = ".,?! \t\n\rabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

app = FastAPI()

def tobase10(n, alph):
    prod = 0
    for c in n:
        pos = alph.find(c)
        if pos >= 0:
            prod *= len(alph)
            prod += pos
    return prod

def frombase10(n, alph):
    ans = ""
    b = len(alphabet)
    q = n
    while q != 0:
        r = q % b
        ans += alph[r]
        q = q // b
    return ans[::-1]

def decrypt():
    encrypted = b'?K\nWczX\t05pEUVr7 yjPYM4q OeYyNt,xx J\tO\tL3yOrCQNqP17NE!pHfqiItYiWZMv3v1oDuMovtXG\ti3V,fRdAoDCOVeB7sEvrFh .Iyge?Jj3AmYi53vDK\nd?3V01OsN \t9oA9ya0D7wz?ucaFX9sD0CpYiCgP1FJY\rKyEm08e jreGkOw.\nEH6wNo\nhFpwu\n2sFEyA\t8ox3mU2M ZMOF4$'
    decoded = encrypted.decode("utf-8")
    blocks = decoded.split("$")
    del blocks[-1]

    n = 1203137733860666270936510052213705613205779038808925798972076338164370114752341835084003150273460796565964025729038626690711562805513698697937104046973969006333079680951240345786583624926101668007101556291504481653343819909516724832044008455987859556372758285587041009712178073246155063192093024988082752351435699705138687975903000700682286511141750251805775604834657353623548260410583374302861252263
    d = 952300269326981038996850367247700112194963055801259542539971401709856705919522150878463057625309085205654091321930416523775677173317260683964054788325942164601280458437678600357882662653996932195537006798745626869276568516649587155390466159193380060281449098618991997405494580756081595099634495029265105492887638723475295936082083457278381354009464399479158790078901649870848319254954467888694697841

    base10_blocks = []
    for i in blocks:
        base10_blocks.append(tobase10(i, alphabet))

    decrypted_blocks = []
    for i in base10_blocks:
        decrypted_blocks.append(pow(i, d, n))

    text_blocks = []
    for i in decrypted_blocks:
        text_blocks.append(frombase10(i, alphabet))

    text = "".join(text_blocks)
    return text.strip()

@app.get("/")
async def root():
    return {"message": "I'm root path"}

@app.get("/flag")
async def flag():
    return {"message": "I'm not going to make it that easy"}

@app.get("/classes")
async def classes():
    classes = ["Full Stack Development", "Digital Design", "IT", "Drafting & Design", "Culinary", "EMT", "Phlebotomy", "App Development", "Welding"]
    return {"count": len(classes), "classes": classes}

@app.get("/languages")
async def languages():
    seed = 42
    a = 1128735
    c = 110222938
    m = 2 ** 32
    psuedo = (a * seed + c) % m
    f = decrypt()
    return {"status": 418, "gpt": psuedo, "status": "online", "lang": ["Python", "Swift", "Kotlin", "arm64", "C", "Rust", "Go", "COBOL", "Haskell"], "flag": f, "distros": {"Ubuntu": 42, "Kubuntu": 16, "Mint": 7, "Kali": 1337, "Parrot": 9, "openSUSE": 2, "Arch": 1}}

if __name__ == "__main__":
    uvicorn.run(app, host = "localhost", port = 8080)
