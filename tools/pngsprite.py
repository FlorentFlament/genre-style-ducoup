#!/usr/bin/env python3
from os.path import basename
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
    fnames = argv[1:]
    for fname in fnames:
        data = list(reversed(parse_sprite(fname)))
        print("sprite_{}:".format(basename(fname).split(".")[0].replace("-","_")))
        print("{}".format(lst2asm(data)))

main()
