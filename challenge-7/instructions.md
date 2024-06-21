# man pages

This challenge uses a customized `touch` command. While you are in the challenge-7 directory, any `touch X` will be redirected to the custom binary. 
Navigate out of the current challenge folder to use your system command.

You will need to use the help command (`touch --help`) and read the man page to figure out how to get the flag.

## Setup

Run setup.py to start getting things set up. Once that is complete, you will need to source your .zshrc file (`source ~/.zshrc`).

## Takedown

Run `unfunction touch` to remove the function from your shell environment. Edit your .zshrc file and remove all the function text within the asterisk sections (**********CTF SETUP**********)
Source your .zshrc file again and you should be back to the state you were in before the challenge.

## Hint
There is a flag option that generates the flag when given the correct input.
