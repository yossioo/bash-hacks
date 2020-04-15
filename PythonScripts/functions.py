import os
import sys

def find_ports():
    a = os.exec(dmesg -T | sed -n "s/^.*tty\s*\(\S*\):.*$/\1/p")
    print(a)