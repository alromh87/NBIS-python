/* wsq.i */
%module wsq
%include "typemaps.i"

%apply char* {unsigned char*};

%typemap(in) unsigned char* = char*;

%typemap(in,numinputs=0) (unsigned char **, int *)(unsigned char *odata, int * olen){
  $1 = &odata;
  $2 = &olen;
}
%typemap(argout) (unsigned char **, int *){
  $result = SWIG_Python_AppendOutput(resultobj, SWIG_From_int((*$2)));
  $result = SWIG_Python_AppendOutput(resultobj, PyString_FromStringAndSize((const char*)(*$1), *$2));
}

%{
#include "wsq.h"
int debug=0;
%}

%include "wsq.h"
//extern int wsq_encode_mem(unsigned char **, int *, const float, unsigned char *,
//                 const int, const int, const int, const int, char *);
