#!/usr/bin/env python3
from sys import argv
from PIL import Image

from asmlib import lst2asm
from imglib import *

def parse_sprite(fname):
    im = Image.open(fname).convert('1')
    raw = list(im.getdata())
    sprite = [raw[x:x+8] for x in range(0, len(raw), 8)]
    return [lbool2int((e!=0 for e in l)) for l in sprite]

def main():
    fname = argv[1]
    data = list(reversed(parse_sprite(fname)))
    print("sprite:")
    print("{}".format(lst2asm(data)))

main()
