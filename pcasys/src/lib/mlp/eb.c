/*******************************************************************************

License: 
This software and/or related materials was developed at the National Institute
of Standards and Technology (NIST) by employees of the Federal Government
in the course of their official duties. Pursuant to title 17 Section 105
of the United States Code, this software is not subject to copyright
protection and is in the public domain. 

This software and/or related materials have been determined to be not subject
to the EAR (see Part 734.3 of the EAR for exact details) because it is
a publicly available technology and software, and is freely distributed
to any interested party with no licensing requirements.  Therefore, it is 
permissible to distribute this software as a free download from the internet.

Disclaimer: 
This software and/or related materials was developed to promote biometric
standards and biometric technology testing for the Federal Government
in accordance with the USA PATRIOT Act and the Enhanced Border Security
and Visa Entry Reform Act. Specific hardware and software products identified
in this software were used in order to perform the software development.
In no case does such identification imply recommendation or endorsement
by the National Institute of Standards and Technology, nor does it imply that
the products and equipment identified are necessarily the best available
for the purpose.

This software and/or related materials are provided "AS-IS" without warranty
of any kind including NO WARRANTY OF PERFORMANCE, MERCHANTABILITY,
NO WARRANTY OF NON-INFRINGEMENT OF ANY 3RD PARTY INTELLECTUAL PROPERTY
or FITNESS FOR A PARTICULAR PURPOSE or for any purpose whatsoever, for the
licensed product, however used. In no event shall NIST be liable for any
damages and/or costs, including but not limited to incidental or consequential
damages of any kind, including economic damage or injury to property and lost
profits, regardless of whether NIST shall be advised, have reason to know,
or in fact shall know of the possibility.

By using this software, you agree to bear all risk relating to quality,
use and performance of the software and/or related materials.  You agree
to hold the Government harmless from any claim arising from your use
of the software.

*******************************************************************************/


/***********************************************************************
      LIBRARY: MLP - Multi-Layer Perceptron Neural Network

      FILE:    EB.C
      AUTHORS: Charles Wilson
               G. T. Candela
      DATE:    1992
      UPDATED: 03/16/2005 by MDG

      Routines for using a (hidden) error buffer, which holds a sequence
      of error messages (or they could be any strings).

      ROUTINES:
#cat: eb_cat - cats a (hidden) error buffer, which holds a sequence
#cat:          of error messages
#cat: eb_get - gets a (hidden) error buffer, which holds a sequence
#cat:          of error messages
#cat: eb_clr - clears a (hidden) error buffer, which holds a sequence
#cat:          of error messages

***********************************************************************/

#include <mlp.h>

/* How many extra bytes to allocate -- beyond the amount that is going
to be just barely sufficient -- at the initial malloc and at each
realloc: */
#define NBYTES_EXTRA 500

static char *errbuf;
static int nbytes_used;

/********************************************************************/

/* Catenates a string onto the error buffer, after checking whether
buffer is going to be large enough and if not, enlarging it. */

void eb_cat(char str[])
{
  static char first = TRUE;
  static int nbytes_allocated;

  if(first) {
    first = FALSE;
    nbytes_used = strlen(str) + 1;
    nbytes_allocated = nbytes_used + NBYTES_EXTRA;
    if((errbuf = malloc(nbytes_allocated)) == (char *)NULL)
      syserr("eb_cat (eb.c)", "malloc", "errbuf");
    strcpy(errbuf, str);
  }
  else {
    nbytes_used += strlen(str);
    if(nbytes_used > nbytes_allocated) {
      nbytes_allocated = nbytes_used + NBYTES_EXTRA;
      if((errbuf = realloc(errbuf, nbytes_allocated)) == (char *)NULL)
	syserr("eb_cat (eb.c)", "realloc", "errbuf");
    }
    strcat(errbuf, str);
  }
}

/********************************************************************/

/* Returns the error buffer. */

char *eb_get()
{
  return errbuf;
}

/********************************************************************/

/* Clears the error buffer, in effect, so that it can be filled with a
new sequence of strings.  (Does not free the buffer.) */

void eb_clr()
{
  *errbuf = (char)0;		/* changed NULL to 0 - jck 2009-02-04 */
  nbytes_used = 1;
}
  
/********************************************************************/
