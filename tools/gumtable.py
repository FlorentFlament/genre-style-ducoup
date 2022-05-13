#!/usr/bin/env python3
import math
from asmlib import lst2asm

VALUES_COUNT = 256
AMPLITUDE = 256

def main():
    #vals = [int(AMPLITUDE * (1 - math.cos((x/VALUES_COUNT)**2 * math.pi)) / 2)
    #        for x in range(VALUES_COUNT)]
    vals = [int(AMPLITUDE * (1 - math.cos((x/VALUES_COUNT) * math.pi)) / 2)
            for x in range(VALUES_COUNT)]
    #print(vals)
    print("gum_table:")
    print(lst2asm(vals))

main()
