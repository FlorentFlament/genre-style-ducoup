#!/usr/bin/env python3
# Based on m/tools/png2logo.py
from os.path import basename
import sys

from PIL import Image

import asmlib
from imglib import *

def sanity_check(im):
    """Checks that the image has the appropriate format:
    * width is a multiple of 8

    """
    w,h = im.size
    msg = None
    if w%8 != 0:
        msg = "Image width is not a multiple of 8: {}".format(w)
    if msg:
        raise BadImageException(msg)

def playfields(l):
    pfs = []
    pfs.append(list(reversed(l[0:4])) + 4*[False])
    pfs.append(l[4:12])
    pfs.append(list(reversed(l[12:20])))
    pfs.append(list(reversed(l[20:24])) + 4*[False])
    pfs.append(l[24:32])
    pfs.append(list(reversed(l[32:40])))
    return flatten(pfs)

def main():
    fname = sys.argv[1]
    # Convert to 1 byte in {0,255} per pixel
    im   = Image.open(fname)

    # Beware im.convert('1') seems to introduce bugs !
    # To be troubleshooted and fixed upstream !
    # In the mean time using im.convert('L') instead
    grey = im.convert('L')
    sanity_check(grey)
    arr   = bool_array(grey)
    lines = [arr[i:i+40] for i in range(0, len(arr), 40)]
    pfs   = [playfields(l) for l in lines]
    pack  = pack_bytes(flatten(pfs))
    #rev   = [~v & 0xff for v in pack]
    print("pf_{}:".format(basename(fname).split(".")[0].replace("-","_")))
    print(asmlib.lst2asm(pack, 6))

main()
