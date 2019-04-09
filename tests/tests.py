#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import os

from pyNBIS import wsq
from pyNBIS import nfiq
from pyNBIS import bozorth
from pyNBIS import lfs

from subprocess import call

debug = 1

BASE_DIR = os.path.dirname(os.path.realpath(__file__))
INSTALL_DIR = os.path.dirname(os.path.realpath(__file__)) + '/../install_dir/'
huella_raw = os.path.join(BASE_DIR, "nistFinger_500_500.raw")
huella2_raw = os.path.join(BASE_DIR, "nistFinger_500_500.raw")
xytq_out = os.path.join(BASE_DIR, "testMINDTCTpy.xyt")

with open(huella_raw, "rb") as image_file:
    huella = image_file.read()

# ************************+
with open(huella2_raw, "rb") as image_file2:
    huella2 = image_file2.read()
# ************************+

rawSize = [500, 500]
w = rawSize[0]
h = rawSize[1]
# img = Image.frombuffer('L', [w, h], huella, "raw", 'L', 0, 1)
# img.show()

bitrate = 2.25
depth = 8
ppi = 500

print("\n\nTesting NFIQ:")
result = nfiq.comp_nfiq(huella, w, h, depth, depth)
print("Scan quality from pyNBIS: ",  result, " vs quality from nfiq: ")
call([
    INSTALL_DIR + "bin/nfiq",
    "-d", huella_raw, "-raw", "%d,%d,%d" % (w, h, depth)])

if debug:
    print("Debug -> executing NFIQ")
    print(
        INSTALL_DIR + "bin/nfiq",
        "-d", huella_raw, "-raw", "%d,%d,%d" % (w, h, depth))


print("\n\nTesting WSQ codification:")
result = wsq.wsq_encode_mem(bitrate, huella, w, h, depth, ppi, b"")
print(result[:2])
huella_fname, _ = os.path.splitext(huella_raw)
with open(os.path.join(BASE_DIR, huella_fname + ".py.wsq"), "wb") as raw_file:
    raw_file.write(result[2])
call([
    INSTALL_DIR + "bin/cwsq",
    "%f" % bitrate, "cwsq.wsq", huella_raw,
    "-raw_in", "%d,%d,%d,%d" % (w, h, depth, ppi), "/dev/null"])
# TODO: Compare MD5 Sum and output https://stackoverflow.com/questions/3431825/generating-an-md5-checksum-of-a-file

if debug:
    print("Debug -> executing WSQ")
    print(
        INSTALL_DIR + "bin/cwsq",
        "%f" % bitrate, "cwsq.wsq", huella_raw,
        "-raw_in", "%d,%d,%d,%d" % (w, h, depth, ppi), "/dev/null")

print("\n\nTesting MINDTCT")
# Note: We don't need to use WSQ to extract minutiae!!

salida = lfs.get_minutiae(huella, w, h, depth, ppi)
print(xytq_out.encode('utf-8'))
lfs.write_minutiae_XYTQ(xytq_out.encode('utf-8'), lfs.NIST_INTERNAL_XYT_REP, salida[1], w, h)
#  lfs.free_minutiae(salida[1])
# TODO: Run OS mindtct and compare output

print("\n\nTesting BOZORTH")
xyt1 = lfs.get_XYT(lfs.NIST_INTERNAL_XYT_REP, huella, w, h, depth, ppi)
xyt2 = lfs.get_XYT(lfs.NIST_INTERNAL_XYT_REP, huella2, w, h, depth, ppi)

[match, xyt1, xyt2] = bozorth.bozorth_main(xyt1, xyt2)
# TODO: Run OS bozorth and compare output

print("Match:", match)
