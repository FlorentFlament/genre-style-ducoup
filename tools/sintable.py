#!/usr/bin/env python3
import math
from asmlib import lst2asm

VALUES_COUNT = 256
AMPLITUDE = 68

def main():
    vals = [(int(AMPLITUDE * math.sin(x*2*math.pi / VALUES_COUNT) / 2) + 256) % 256
            for x in range(VALUES_COUNT)]
    print("sin_table:")
    print(lst2asm(vals))

main()
