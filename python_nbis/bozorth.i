/* bozorth.i */
%module bozorth
%include "typemaps.i"
%include "bz_comon.i"

%apply int *OUTPUT { int * };
%apply float *OUTPUT { float * };
%apply char* {unsigned char*};

%typemap(in) unsigned char* = char*;

%typemap(in) (struct xyt_struct *)(struct xyt_struct xyt_s){  //WARNING: Define intermediate objects here, so SWIG know they have to be different objects in case there are multiple mappings in a single function
  if(PyList_CheckExact($input)){
    xyt_s.nrows = (int)PyList_Size($input);

    PyObject* dict;
    PyObject * llaveX  = PyString_FromString("x");
    PyObject * llaveY  = PyString_FromString("y");
    PyObject * llaveT  = PyString_FromString("t");

    int i;
    for(i = 0; i < xyt_s.nrows; i++){
      dict = PyList_GetItem($input, (Py_ssize_t)i);
      xyt_s.xcol[i]	= PyDict_Contains(dict, llaveX) ? (int)PyInt_AS_LONG(PyDict_GetItem(dict, llaveX)) : 0;
      xyt_s.ycol[i]	= PyDict_Contains(dict, llaveX) ? (int)PyInt_AS_LONG(PyDict_GetItem(dict, llaveY)) : 0;
      xyt_s.thetacol[i]	= PyDict_Contains(dict, llaveX) ? (int)PyInt_AS_LONG(PyDict_GetItem(dict, llaveT)) : 0;
    }
  }else{
    printf("Bozorth: Received invalid object to build xyt_struct");
    //TODO: raise exception
  }
  $1 = &xyt_s;
}

%typemap(argout) (struct xyt_struct *)(PyObject* list){
  list = PyList_New((Py_ssize_t)$1->nrows);

  PyObject* o;
  PyObject * llaveX  = PyString_FromString("x");
  PyObject * llaveY  = PyString_FromString("y");
  PyObject * llaveT  = PyString_FromString("t");

  int i;
  for(i = 0; i < $1->nrows; i++){
    o = PyDict_New();
    PyDict_SetItem(o, llaveX, PyInt_FromLong($1->xcol[i]));
    PyDict_SetItem(o, llaveY, PyInt_FromLong($1->ycol[i]));
    PyDict_SetItem(o, llaveT, PyInt_FromLong($1->thetacol[i]));
    PyList_SetItem(list, (Py_ssize_t)i, o);
  }
  $result = SWIG_Python_AppendOutput(resultobj, list);
}

%include "bozorth.h"
