import random
import os

alphabet = ".,?! \t\n\rabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

def c(n, r):
    x = 1
    for i in range(n - r + 1, n + 1):
        x *= i
    for i in range(1, r + 1):
        x //= i
    return x

def mt(x, b):
    t = x - 1
    s = 0
    while t % 2 == 0:
        t //= 2
        s += 1
    if pow(b, t, x) == 1:
        return True
    for i in range(s):
        if pow(b, t, x) == x - 1:
            return True
        t *= 2
    return False

def mn(x, y, z):
    return min(min(x, y), z)

def tb10(n, alph):
    prd = 0
    for c in n:
        ps = alph.find(c)
        if ps >= 0:
            prd *= len(alph)
            prd += ps
    return prd

def fb10(n, alph):
    tmp = c(random.randint(1, len(alph)), random.randint(0, len(alph) // 2))
    if tmp == -1:
        return
    ans = ""
    b = len(alph)
    q = n
    while q != 0:
        r = q % b
        ans += alph[r]
        q = q // b
    return ans[::-1]

def dec(i, o):
    enc = i
    encd = enc.decode("utf-8")
    bks = encd.split("$")
    del bks[-1]

    n = 1203137733860666270936510052213705613205779038808925798972076338164370114752341835084003150273460796565964025729038626690711562805513698697937104046973969006333079680951240345786583624926101668007101556291504481653343819909516724832044008455987859556372758285587041009712178073246155063192093024988082752351435699705138687975903000700682286511141750251805775604834657353623548260410583374302861252263
    d = 952300269326981038996850367247700112194963055801259542539971401709856705919522150878463057625309085205654091321930416523775677173317260683964054788325942164601280458437678600357882662653996932195537006798745626869276568516649587155390466159193380060281449098618991997405494580756081595099634495029265105492887638723475295936082083457278381354009464399479158790078901649870848319254954467888694697841

    b10bks = []
    for i in bks:
        b10bks.append(tb10(i, alphabet))

    decbks = []
    for i in b10bks:
        decbks.append(pow(i, d, n))

    tbks = []
    for i in decbks:
        tbks.append(fb10(i, alphabet))

    t = ""
    for i in tbks:
        t += i

    return t.encode("utf-8").strip()

def main():
    zsh = b',s3kaFi6qFyaiH7cMGpsd7izKt EWmBO0STv\r!sIRkpO3y1e1\npeBoQP 9e\nZlEa\tZ4\t.\n1I6WROJGp3dXHn4m?Jb5KiC\nE8ftAT\t!R?\rL,2CfnU5ryriETak,b,SM\twFWp68cjSi6u1Mi\r.HL8P.3,c3nGLWVvEi,D,GM\nrVmrDf6ep 7GRIXmq0rin8zbn0384,!O X\ruQeNkeCmdyrwm$'

    tty = []
    for i in zsh:
        temp = mt(0xA6, int(i))
        temp *= random.randint(0, 1)
        tty.append(temp)

    r = dec(zsh, 0xD00D2BAD)
    z = "flag{" + str(r, "utf-8") + "}"
    print(type(z))
    ft = open("flag.txt", "w")
    ft.write(z)
    ft.close()
    os.chmod("flag.txt", 0)

if __name__ == "__main__":
    main()
