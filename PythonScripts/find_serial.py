#!/usr/bin/python3
# import subprocess library
import subprocess
import os
import sys
import re

dmesg_cmd = 'dmesg -T | sed -n "s/^.*tty\s*\(\S*\):.*$/\\1/p"'
ls_cmd = 'ls /dev/tty*'


def main(args):
    dmesg_process = subprocess.Popen(['dmesg'],
                             stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT)
    ls_process = subprocess.Popen(['ls', '/dev/'],
                          stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT)
    stdout, stderr = dmesg_process.communicate()
    dmesg_output = stdout.decode('utf-8').split("\n")
    stdout, stderr = ls_process.communicate()
    ls_output = stdout.decode('utf-8').split("\n")

    active_devices = " ".join(ls_output)
    raw_found_ports = []
    found_ports_dmesg = []
    for l in dmesg_output:
        if "tty" in l:
            g = re.findall(".*(tty.*):", l)
            if len(g) > 0:
                raw_found_ports.append(g)
    for p in raw_found_ports:
        found_ports_dmesg.append(p[0].split(":")[0])
    found_ports_dmesg = set(found_ports_dmesg)
    
    # print("Found dmesg ports:")
    # print(found_ports_dmesg)
    # print("Active devices:")
    # print(active_devices)
    connected_ports = []
    for p in found_ports_dmesg:
        if p in active_devices:
            connected_ports.append("/dev/{}".format(p))
    print("Found the following ports:")
    print(connected_ports)


if __name__ == "__main__":
    try:
        main(sys.argv)
    except:
        pass
