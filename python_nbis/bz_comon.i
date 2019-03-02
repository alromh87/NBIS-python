/* bz_comon.i */

%{
#include "bozorth.h"

int m1_xyt                  = 0;

int max_minutiae            = DEFAULT_BOZORTH_MINUTIAE;
int min_computable_minutiae = MIN_COMPUTABLE_BOZORTH_MINUTIAE;

int verbose_main      = 0;
int verbose_load      = 0;
int verbose_bozorth   = 0;
int verbose_threshold = 0;

FILE * errorfp            = FPNULL;
%}

%ignore fd_readable(int);

//%include "bozorth.h" DONT include here, it should be procesed at the end, after all typemaps
