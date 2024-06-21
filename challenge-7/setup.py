import os

zshrc = os.path.expanduser("~/.zshrc")
preamble = "#****************CTF Setup****************#\n"

def set_shell_func():
    end = "#********************************#\n"
    touch_func = """
touch() {
    if [[ $PWD == */terminal-ctf/challenge-7 ]]; then
        ./.tools/touch \"$@\"
    else
        /usr/bin/touch \"$@\"
    fi
}\n
"""

    man_func = """
man() {
    if [[ $PWD == */terminal-ctf/challenge-7 ]]; then
        man ./.tools/touch.1
"""
    fobj = open(zshrc, "a")
    fobj.write("\n")
    fobj.write(preamble)
    fobj.write(touch_func)
    fobj.write(end)
    fobj.close()

def main():
    fobj = open(zshrc)
    lines = fobj.readlines()
    fobj.close()
    added = False
    for i in lines:
        if preamble in i:
            added = True
    if not added:
        set_shell_func()

    print("The shell function has been written out to .zshrc")
    print("To finish setting up the challenge, please run `source ~/.zshrc`.")

if __name__ == "__main__":
    main()
