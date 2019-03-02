/* lfs.i */
%module lfs

%apply int *OUTPUT { int * };
%apply float *OUTPUT { float * };
%apply char* {unsigned char*};

%typemap(in) unsigned char* = char*;

%typemap(in) MINUTIAE *{
  printf("Generate back minutiae");
//  $1 = (MINUTIAE *)PyString_AsString($input);
  $1 = (MINUTIAE *)$input;
  printf("\nLoading %d minutia using %d adress space...\n", (*$1).num, (*$1).alloc);

  FILE *fp;
  if((fp = fopen("out/minutiaeAfter.bin", "wb")) == (FILE *)NULL){
     fprintf(stderr, "ERROR : write_minutiae_XYTQ : fopen : \n");
  }
  fwrite($1, 1, $1->alloc, fp);
  fclose(fp);

  int i;
  MINUTIA *minutia;
  for(i = 0; i < $1->num; i++){
    minutia = $1->list[i];
    printf("Minutia %d, %4d%4d%4d%4f\n", i, minutia->x, minutia->y, minutia->direction, minutia->reliability);
  }
  printf("\nGo\n\n");
}
%typemap(argout) MINUTIAE * {
  printf("\nDone\n\n");
//  free_minutiae($1);
}

%typemap(in,numinputs=0) MINUTIAE ** (MINUTIAE *minutiae){
  $1 = &minutiae;
}
%typemap(argout) MINUTIAE ** {
  printf("\nReturning %d minutia using %d adress space...\n%d\n", (**$1).num, (**$1).alloc, (**$1).num*sizeof(MINUTIAE));
  $result = SWIG_Python_AppendOutput(resultobj, (*$1));
//  $result = SWIG_Python_AppendOutput(resultobj, PyString_FromStringAndSize((const char*)(*$1), (**$1).alloc));

  FILE *fp;
  if((fp = fopen("out/minutiaeBefore.bin", "wb")) == (FILE *)NULL){
     fprintf(stderr, "ERROR : write_minutiae_XYTQ : fopen : \n");
  }
  fwrite((*$1), 1, (**$1).alloc, fp);
  fclose(fp);

  int i;
  MINUTIA *minutia;
  for(i = 0; i < (*$1)->num; i++){
    minutia = (*$1)->list[i];
    printf("Minutia %d, %4d%4d%4d%4f\n", i, minutia->x, minutia->y, minutia->direction, minutia->reliability);
  }

//  free_minutiae(*$1);
 printf ("Returning minutiae end");
}

%typemap(out) (struct xyt_struct *){
  $result = PyList_New((Py_ssize_t)$1->nrows);

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
    PyList_SetItem($result, (Py_ssize_t)i, o);
  }
}


%typemap(in,numinputs=0) int ** (int *oIntP){
  $1 = &oIntP;
}
%typemap(argout) (int **){
//  $result = SWIG_Python_AppendOutput(resultobj, PyString_FromStringAndSize((const char*)(*$1), *$2));
}
%typemap(in,numinputs=0) int * (int oInt){
  $1 = &oInt;
}
%typemap(argout) (int *){
  $result = SWIG_Python_AppendOutput(resultobj, SWIG_From_int(*$1));
}
%typemap(in,numinputs=0) unsigned char ** (unsigned char *oCharP){
  $1 = &oCharP;
}
%typemap(argout) (unsigned char **){
  printf("Returning char **");
//  $result = SWIG_Python_AppendOutput(resultobj, PyString_FromStringAndSize((const char*)(*$1), *$2));
}

%typemap(in,numinputs=0) LFSPARMS *{
  LFSPARMS lfsparms_V2 = {
   /* Image Controls */
   PAD_VALUE,
   JOIN_LINE_RADIUS,

   /* Map Controls */
   MAP_BLOCKSIZE_V2,
   MAP_WINDOWSIZE_V2,
   MAP_WINDOWOFFSET_V2,
   NUM_DIRECTIONS,
   START_DIR_ANGLE,
   RMV_VALID_NBR_MIN,
   DIR_STRENGTH_MIN,
   DIR_DISTANCE_MAX,
   SMTH_VALID_NBR_MIN,
   VORT_VALID_NBR_MIN,
   HIGHCURV_VORTICITY_MIN,
   HIGHCURV_CURVATURE_MIN,
   MIN_INTERPOLATE_NBRS,
   PERCENTILE_MIN_MAX,
   MIN_CONTRAST_DELTA,

   /* DFT Controls */
   NUM_DFT_WAVES,
   POWMAX_MIN,
   POWNORM_MIN,
   POWMAX_MAX,
   FORK_INTERVAL,
   FORK_PCT_POWMAX,
   FORK_PCT_POWNORM,

   /* Binarization Controls */
   DIRBIN_GRID_W,
   DIRBIN_GRID_H,
   UNUSED_INT,          /* isobin_grid_dim */
   NUM_FILL_HOLES,

   /* Minutiae Detection Controls */
   MAX_MINUTIA_DELTA,
   MAX_HIGH_CURVE_THETA,
   HIGH_CURVE_HALF_CONTOUR,
   MIN_LOOP_LEN,
   MIN_LOOP_ASPECT_DIST,
   MIN_LOOP_ASPECT_RATIO,

   /* Minutiae Link Controls */
   UNUSED_INT,          /* link_table_dim     */
   UNUSED_INT,          /* max_link_dist      */
   UNUSED_INT,          /* min_theta_dist     */
   MAXTRANS,            /* used for removing overlaps as well */
   UNUSED_DBL,          /* score_theta_norm   */
   UNUSED_DBL,          /* score_dist_norm    */
   UNUSED_DBL,          /* score_dist_weight  */
   UNUSED_DBL,          /* score_numerator    */

   /* False Minutiae Removal Controls */
   MAX_RMTEST_DIST_V2,
   MAX_HOOK_LEN_V2,
   MAX_HALF_LOOP_V2,
   TRANS_DIR_PIX_V2,
   SMALL_LOOP_LEN,
   SIDE_HALF_CONTOUR,
   INV_BLOCK_MARGIN_V2,
   RM_VALID_NBR_MIN,
   MAX_OVERLAP_DIST,
   MAX_OVERLAP_JOIN_DIST,
   MALFORMATION_STEPS_1,
   MALFORMATION_STEPS_2,
   MIN_MALFORMATION_RATIO,
   MAX_MALFORMATION_DIST,
   PORES_TRANS_R,
   PORES_PERP_STEPS,
   PORES_STEPS_FWD,
   PORES_STEPS_BWD,
   PORES_MIN_DIST2,
   PORES_MAX_RATIO,

   /* Ridge Counting Controls */
   MAX_NBRS,
   MAX_RIDGE_STEPS
  };
  $1 = &lfsparms_V2;
//TODO: enhance                  const LFSPARMS *lfsparms)                         &lfsparms_V2)))
}
%typemap(argout) (LFSPARMS *){
  printf("Returning LFSPARMS\n");
//  $result = SWIG_Python_AppendOutput(resultobj, PyString_FromStringAndSize((const char*)(*$1), *$2));
}

%{
#include "lfs.h"
/*Declare undeclared ext functions*/
int  sort_minutiae(MINUTIAE * minutiae, const int iw, const int ih){
  return sort_minutiae_x_y(minutiae, iw, ih);
}
int drawimap(int *imap, const int mw, const int mh, unsigned char *idata, const int iw, const int ih, const ROTGRIDS *dftgrids, const int draw_pixel){
  return drawmap(imap, mw, mh, idata, iw, ih, dftgrids, draw_pixel);
}
void drawimap2(int *imap, const int *blkoffs, const int mw, const int mh, unsigned char *pdata, const int pw, const int ph, const double start_angle, const int ndirs, const int blocksize){
  drawmap2(imap, blkoffs, mw, mh, pdata, pw, ph, start_angle, ndirs, blocksize);
}

int bresenham_line_points(int ** a, int ** b, int * c, const int d, const int e, const int f, const int g){return 0;}
%}


%include "lfs.h"
//%include "bozorth.h"

%inline %{
  //#include "lfs.h"
  #include "bozorth.h"
  int m1_xyt                  = 0;

  int max_minutiae            = DEFAULT_BOZORTH_MINUTIAE;
  int min_computable_minutiae = MIN_COMPUTABLE_BOZORTH_MINUTIAE;

  int verbose_main      = 0;
  int verbose_load      = 0;
  int verbose_bozorth   = 0;
  int verbose_threshold = 0;

  FILE * errorfp            = FPNULL;
  #undef PARALLEL_SEARCH

  struct xyt_struct * get_XYT(const int reptype, unsigned char *idata, const int iw, const int ih, const int id, const double ippmm){
    /* Get xyt from raw image by uniting get_minutiae and code from bz_load*/
    int i, ox, oy, ot, oq;
    unsigned char *bdata;
    int bw, bh, bd;
    int *direction_map, *low_contrast_map, *low_flow_map;
    int *high_curve_map, *quality_map;
    int map_w, map_h;
    MINUTIAE *minutiae;
    MINUTIA  *minutia;
    struct xyt_struct * xyt_s;
    struct xytq_struct * xytq_s;

    get_minutiae(&minutiae, &quality_map, &direction_map, &low_contrast_map, &low_flow_map, &high_curve_map, &map_w, &map_h, &bdata, &bw, &bh, &bd,
                         idata, iw, ih, id, ippmm, &lfsparms_V2);

    xytq_s = (struct xytq_struct *)malloc(sizeof(struct xytq_struct));
/*
    if ( xytq_s == XYTQ_NULL ){
      fprintf( errorfp, "%s: ERROR: malloc() failure while loading minutiae buffer failed: %s\n", get_progname(), strerror(errno));
      return XYT_NULL;
    }
*/
    xytq_s->nrows = minutiae->num;

    for(i = 0; i < minutiae->num; i++){
      minutia = minutiae->list[i];

      switch(reptype){
        case M1_XYT_REP:
          lfs2m1_minutia_XYT(&ox, &oy, &ot, minutia);
        break;
        case NIST_INTERNAL_XYT_REP:
        default:	//USE NIST XYT by default
          lfs2nist_minutia_XYT(&ox, &oy, &ot, minutia, iw, ih);
        break;
      }

      oq = sround(minutia->reliability * 100.0);

      xytq_s->xcol[i] = ox;
      xytq_s->ycol[i] = oy;
      xytq_s->thetacol[i] = ot;
      xytq_s->qualitycol[i] = oq;

      printf("%d %d %d %d\n", ox, oy, ot, oq);
    }
    xyt_s = bz_prune(xytq_s, 0);

    free_minutiae(minutiae);
    return xyt_s;
  }
%}

