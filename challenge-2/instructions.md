# Binary

Convert "flag" into hexadecimal and give the address where it is found.

Example, converting "abcd" into hexadecimal gives you 0x61, 0x62, 0x63, 0x64.
That becomes 0x61626364, which we break into two parts like this: 6162 6364.
Using only the commands available, I would look for that in the binary file.

The binary file looks like this:

```txt
0000000 0000 0d00 4849 5244 0000 0c07 0000 7d03
0000010 0208 0000 0100 1aba 00ca 0000 7301 4752
0000020 0042 ceae e91c 0000 0400 4167 414d 0000
0000030 8fb1 fc0b 0561 0d00 2cf9 4449 5441 da78
0000040 7dec 7879 555d feb9 76bb c64e 6926 4e9a
```

The first column is an address, the rest of the columns are the binary data.
Say we were looking for 0561 0d00. The flag you'd give is 0000030.

## Allowed commands


