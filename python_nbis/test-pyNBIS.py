#!/usr/bin/env python
# -*- coding: utf-8 -*-

import array
import wsq
import nfiq

from PIL import Image

from subprocess import call

huella_raw ="fingerprint.raw"
with open(huella_raw, "rb") as image_file:
  huella = image_file.read()
  w = 256
  h = 400
#  img = Image.frombuffer('L', [w, h], huella, "raw", 'L', 0, 1)
#  img.show()

  bitrate = 2.25
  depth = 8
  ppi = 500
  result =  nfiq.comp_nfiq(huella,  w,  h, depth, depth)
  print "Scan quality from pyNBIS: ",  result, " vs quality from nfiq: "
  call(["../install_dir/bin/nfiq", "-d", huella_raw, "-raw", "%d,%d,%d"%(w, h,depth)])
  result =  wsq.wsq_encode_mem(bitrate, huella,  w,  h, depth, ppi, "")
  print result[:2]
  with open(huella_raw+"_py", 'wb') as raw_file:
    raw_file.write(result[2])
  call(["../install_dir/bin/cwsq", "%d"%bitrate, "wsq", huella_raw, "-raw_in", "%d,%d,%d,%d"%(w, h, depth, ppi)])

