#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import hashlib
import os
from subprocess import call
from unittest import TestCase

from pyNBIS.wsq import wsq_encode_mem, wsq_decode_mem


def _md5sum(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


class WsqTest(TestCase):
    BASE_DIR = os.path.dirname(os.path.realpath(__file__))
    INSTALL_DIR = os.path.dirname(os.path.realpath(__file__)) + '/../install_dir/'
    huella = os.path.join(BASE_DIR, "nistFinger_500_500")
    rawSize = [500, 500]

    def test_wsq_encode_mem(self):
        rawSize = [500, 500]
        bitrate = 2.25
        depth = 8
        ppi = 500
        with open(self.huella + ".raw", "rb") as raw_file:
            raw_file = raw_file.read()
        result = wsq_encode_mem(bitrate, raw_file, rawSize[0], rawSize[1], depth, ppi, b"")
        with open(self.huella + ".py.wsq", "wb") as wsq_file:
            wsq_file.write(result[2])

        call([
            self.INSTALL_DIR + "bin/cwsq", "%f" % bitrate, "cwsq.wsq", self.huella + ".raw", "-raw_in",
            "%d,%d,%d,%d" % (rawSize[0], rawSize[1], depth, ppi), "/dev/null"])

        self.assertEqual(_md5sum(self.huella + ".cwsq.wsq"), _md5sum(self.huella + '.py.wsq'))

    def test_wsq_decode(self):
        with open(self.huella + '.wsq', "rb") as wsq_file:
            wsq_file.seek(0, os.SEEK_END)
            size = wsq_file.tell()
            wsq_file.seek(0, os.SEEK_SET)
            result = wsq_decode_mem(wsq_file.read(), size)
            wsq = {
                'odata': result[6],
                'ow': result[5],
                'oh': result[4],
                'od': result[3],
                'oppi': result[2],
                'loosyflag': result[1],
                'wsq_decode_mem': result[0],
            }
        self.assertEqual(500, wsq['ow'])
        self.assertEqual(500, wsq['oh'])
        self.assertEqual(500, wsq['oppi'])
        self.assertEqual(1, wsq['loosyflag'])

        with open(self.huella + ".py.raw", "wb") as raw_file:
            raw_file.write(wsq['odata'])

        call([self.INSTALL_DIR + "bin/dwsq", "dwsq.raw", self.huella + '.wsq', "-raw_out"])

        self.assertEqual(_md5sum(self.huella + ".py.raw"), _md5sum(self.huella + '.dwsq.raw'))
