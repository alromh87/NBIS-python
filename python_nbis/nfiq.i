/* nfiq.i */
%module nfiq
%begin %{
#define SWIG_PYTHON_STRICT_BYTE_CHAR
%}
%include "typemaps.i"

%apply int *OUTPUT { int * };
%apply float *OUTPUT { float * };
%apply char* {unsigned char*};

%typemap(in) unsigned char* = char*;

%{
#include "nfiq.h"
//int debug=0;
%}

%include "nfiq.h"

