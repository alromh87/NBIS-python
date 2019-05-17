#!/usr/bin/env python

"""
setup.py file for NBIS SWIG wrapper
"""

from setuptools import setup, find_packages, Extension

NBIS_SWIG_DIR='./pyNBIS/'
NBIS_DIR='./install_dir/'
NBIS_INCLUDE_DIR=NBIS_DIR+'include/'
NBIS_LIB_DIR=NBIS_DIR+'lib/'

wsq_module = Extension('_wsq', [NBIS_SWIG_DIR + 'wsq.i'], swig_opts=['-I'+NBIS_INCLUDE_DIR],
                      include_dirs=[NBIS_INCLUDE_DIR],
                      library_dirs=[NBIS_LIB_DIR],
                      libraries=['wsq', 'ioutil', 'fet', 'jpegl', 'util'],
                      )
nfiq_module = Extension('_nfiq', [NBIS_SWIG_DIR + 'nfiq.i'], swig_opts=['-I'+NBIS_INCLUDE_DIR],
                      include_dirs=[NBIS_INCLUDE_DIR],
                      library_dirs=[NBIS_LIB_DIR],
                      libraries=['nfiq', 'mindtct', 'mlp', 'cblas', 'ioutil', 'util'],
                      )
lfs_module = Extension('_lfs', [NBIS_SWIG_DIR + 'lfs.i'], swig_opts=['-I'+NBIS_INCLUDE_DIR],
                      include_dirs=[NBIS_INCLUDE_DIR],
                      library_dirs=[NBIS_LIB_DIR],
                      libraries=['mindtct', 'mlp', 'cblas', 'ioutil', 'util', 'an2k', 'ioutil', 'image', 'util', 'bozorth3'],
                      )
bozorth_module = Extension('_bozorth', [NBIS_SWIG_DIR + 'bozorth.i'], swig_opts=['-I'+NBIS_INCLUDE_DIR],
                      include_dirs=[NBIS_INCLUDE_DIR],
                      library_dirs=[NBIS_LIB_DIR],
                      libraries=['bozorth3', 'mindtct', 'mlp', 'cblas', 'ioutil', 'util'],
                      )
setup (name = "pyNBIS",
       use_scm_version=True,
       setup_requires=['setuptools_scm'],
#       version		= '0.1',
       author		= "Alejandro Romero <alromh87@gmail.com>",
       author_email	= "alromh87@gmail.com",
       description	= """SIWG based Python wrapper for NBIS""",
       packages		= ["pyNBIS"],
       # package_dir = {'pyNBIS': 'src'},
       # packages=find_packages(where="src"),
       ext_modules	= [wsq_module, nfiq_module, lfs_module, bozorth_module],
       py_modules	= ["wsq", "nfiq", "lfs", "bozorth"],
       )
