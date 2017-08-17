;;02/04/17
PRO JOURNAL__20170204__ZHANG2014__HOW_MANY_ALFS_BROAD_DIFFUSE_MONO_IN_CUSP

  COMPILE_OPT IDL2,STRICTARRSUBS

  PRINT,"This journal is not as helpful as it might appear to be! It's not immediately going to get you anything—rather, it only takes you as far as VALUE_CLOSEST2 with NEWELL__eSpec and MAXIMUS__maximus (or something like that)."
  PRINT,"What you really want is JOURNAL__20170209__ALIGN_ALFDB_WITH_CLOSEST_ESPEC_DB_TO_GET_PRECIP_TYPE in the Alfven_db_routines repo"

  magc10files   = 0

  ;; dir       = '/home/spencerh/Desktop/Spence_paper_drafts/2017/Alfvens_IMF/dataFiles/'
  dir          = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170129/'
  statsFile    = 'OMNI_stats--Alfvens_dodat_20170127.sav'
  reg10File    = 'Alfvens_IMF-inds--10magc--north_hemi-20170129.sav'
  NC10File     = 'Alfvens_IMF-inds--10magc--NC-north_hemi-20170129.sav'
  invNC10File  = 'Alfvens_IMF-inds--10magc--invNC-north_hemi-20170129.sav'
  regFile      = 'Alfvens_IMF-inds--north_hemi-20170129.sav'
  NCFile       = 'Alfvens_IMF-inds-NC-north_hemi-20170129.sav'
  invNCFile    = 'Alfvens_IMF-inds-invNC-north_hemi-20170129.sav'
  northGoodFil = 'alfdb_good_i_above_60_ILAT__NORTH--20170126.sav'

  RESTORE,dir+northGoodFil

  @common__newell_espec.pro
  IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
     LOAD_NEWELL_ESPEC_DB
  ENDIF
  eSpecTimes   = (TEMPORARY(NEWELL__eSpec)).x

  @common__maximus_vars.pro
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  ;;First sort out things with the good inds, the cusp, etc.
  nGood                = N_ELEMENTS(good_i)

  mlt_i                = WHERE(MAXIMUS__maximus.mlt GE  9.5 AND $
                               MAXIMUS__maximus.mlt LE 14.5,nMLT)

  ;; mc10_i               = WHERE(ABS(MAXIMUS__maximus.mag_current       ) GE  10,nMC10  )
  mc10_i               = GET_MAGC_INDS(MAXIMUS__maximus,10,-10, $
                                       /UNMAP_IF_MAPPED, $
                                       N_INSIDE_MAGC=n_magc_inside_range, $
                                       /QUIET)
  
  cGE300_i             = WHERE(ABS(MAXIMUS__maximus.max_chare_losscone) GE 300,nCGE300)

  MLTMC10_i            = CGSETINTERSECTION( mlt_i,mc10_i,COUNT=nMLTMC10   )

  goodMLT_i            = CGSETINTERSECTION( mlt_i,good_i,COUNT=nGoodMLT   )
  goodMC10_i           = CGSETINTERSECTION(mc10_i,good_i,COUNT=nGoodMC10  )
  goodCGE300_i         = CGSETINTERSECTION(mc10_i,good_i,COUNT=nGoodCGE300)

  goodMLTCGE300_i      = CGSETINTERSECTION(    goodMLT_i,cGE300_i,COUNT=nGoodMLTCGE300    )
  goodMLTMC10_i        = CGSETINTERSECTION(    goodMLT_i,  mc10_i,COUNT=nGoodMLTMC10      )
  goodMLTMC10CGE300_i  = CGSETINTERSECTION(goodMLTMC10_i,cGE300_i,COUNT=nGoodMLTMC10CGE300)

  ;;Now find them
  especs_whereAlf_i    = VALUE_CLOSEST2(eSpecTimes,MAXIMUS__times)


END
