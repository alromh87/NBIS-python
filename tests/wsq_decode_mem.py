#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import os
from pyNBIS import wsq

# from PIL import Image

from subprocess import call

BASE_DIR = os.path.dirname(os.path.realpath(__file__))
INSTALL_DIR = os.path.dirname(os.path.realpath(__file__)) + '/../install_dir/'
huella = os.path.join(BASE_DIR, "nistFinger_500_500")

with open(huella + '.wsq', "rb") as wsq_file:
    print("\n\nTesting WSQ decodification:")
    
    wsq_file.seek(0, os.SEEK_END)
    size = wsq_file.tell()
    wsq_file.seek(0, os.SEEK_SET)
    result = wsq.wsq_decode_mem(wsq_file.read(), size)
    wsq = {
        'odata': result[6],
        'ow': result[5],
        'oh': result[4],
        'od': result[3],
        'oppi': result[2],
        'loosyflag': result[1],
        'wsq_decode_mem': result[0],
    }
    # print(wsq)
    
    with open(huella + ".py.raw", "wb") as raw_file:
        raw_file.write(wsq['odata'])

    # call(["../install_dir/bin/cwsq", "2.25", "wsq", huella + ".dwsq_py.raw", "-raw_in", "%d,%d,%d,%d"%(wsq['ow'], wsq['oh'], wsq['od'], wsq['oppi']), "/dev/null"])

    call([INSTALL_DIR + "bin/dwsq", "dwsq.raw", huella + '.wsq', "-raw_out"])
    # img = Image.frombuffer('L', [wsq['ow'], wsq['oh']], wsq['odata'], "raw", 'L', 0, 1)
    # img.show()

    # TODO: Compare MD5 Sum and output https://stackoverflow.com/questions/3431825/generating-an-md5-checksum-of-a-file
