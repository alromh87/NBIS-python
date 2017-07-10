/* nfiq.i */
%module nfiq
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

