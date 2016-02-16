;2016/02/16 Both North and South journals use these; NONSTORM-style

  IF N_ELEMENTS(lun) EQ 0 THEN lun         = -1 ;stdout

  printemall                               = 0

  h2dFileDir                               = '/SPENCEdata/Research/Cusp/ACE_FAST/20160216--Alfven_cusp_figure_of_merit/data/'
  outFile                                  = h2dFileDir+'processed/'+hoyDia+'--Cusp_splitting--'+STRUPCASE(hemi)+'_figures_of_merit_' + FOMString + '--delays_-25_25min.sav'

  ;;same for everyone
  binI                                     = 3

  minM                                     = 0.00000
  maxM                                     = 24.0000
  binM                                     = 1.0
  shiftM                                   = 0.5

  h2d_i                                    = 0            ; The one for probability of occurrence
  n_maxima                                 = 2            ; How many maxima are we getting?
  n_center_maxima                          = 1
  threshold_max                            = ALOG10(1.2)  ; Value shouldn't be more than 10% above 100% occurrence
  nFOM_to_print                            = 25

  ;;Boundaries for figure of merit
  dusk_minM                                = 12.5
  dusk_maxM                                = 14.5
  dawn_minM                                = 9.5
  dawn_maxM                                = 11.5
  center_minM                              = 11.5
  center_maxM                              = 12.5

  IF STRUPCASE(hemi) EQ 'SOUTH' THEN BEGIN

     fileDay                                  = 'Feb_16_16'

     minI                                     = -83.0000
     maxI                                     = -56.0000
     
     ;; ;;ILAT Boundaries for figure of merit
     dusk_minI                                = -83
     dusk_maxI                                = -56
     
     dawn_minI                                = -83
     dawn_maxI                                = -56

     center_minI                              = -83
     center_maxI                              = -56
     
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ 'NORTH' THEN BEGIN
        fileDay                               = 'Feb_16_16'

        minI                                  = 56.0000
        maxI                                  = 83.0000
        
        ;;ILAT Boundaries for figure of merit
        dusk_minI                             = 56
        dusk_maxI                             = 83
        
        dawn_minI                             = 56
        dawn_maxI                             = 83
        
        center_minI                           = 56
        center_maxI                           = 83
     ENDIF
  ENDELSE

  ;;Get the ILAT and MLT bin centers
  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                               CENTERS1=centersMLT,CENTERS2=centersILAT, $
                               BINSIZE1=binM, BINSIZE2=binI, $
                               MAX1=maxM, MAX2=maxI, $
                               MIN1=minM, MIN2=minI, $
                               SHIFT1=shiftM, SHIFT2=shiftI

  ;;Determine where to get the figure of merit stuff
  dawn_MLT_i                               = WHERE(centersMLT GE dawn_minM AND centersMLT LE dawn_maxM)
  dawn_ILAT_i                              = WHERE(centersILAT GE dawn_minI AND centersILAT LE dawn_maxI)
  dawn_i                                   = cgsetintersection(dawn_MLT_i,dawn_ILAT_i)

  dusk_MLT_i                               = WHERE(centersMLT GE dusk_minM AND centersMLT LE dusk_maxM)
  dusk_ILAT_i                              = WHERE(centersILAT GE dusk_minI AND centersILAT LE dusk_maxI)
  dusk_i                                   = cgsetintersection(dusk_MLT_i,dusk_ILAT_i)

  center_MLT_i                             = WHERE(centersMLT GE center_minM AND centersMLT LE center_maxM)
  center_ILAT_i                            = WHERE(centersILAT GE center_minI AND centersILAT LE center_maxI)
  center_i                                 = cgsetintersection(center_MLT_i,center_ILAT_i)

  ;;parameters for files to be looped over


  clockStrArr                              = ['dawnward','duskward']
  byMin                                    = 3.0

  delayArr                       = [-1500, -1440, -1380, -1320, -1260, $
                                    -1200, -1140, -1080, -1020,  -960, $
                                     -900,  -840,  -780,  -720,  -660, $
                                     -600,  -540,  -480,  -420,  -360, $
                                     -300,  -240,  -180,  -120,  -60,  $
                                        0,    60,   120,   180,   240, $
                                      300,   360,   420,   480,   540, $
                                      600,   660,   720,   780,   840, $
                                      900,   960,  1020,  1080,  1140, $
                                     1200,  1260,  1320,  1380,  1440, $
                                     1500]/60.


  bogusFmt                                 = '(I0,T10,F0.3,T25,F0.3,T40,F0.3)' ;for bogus vals

  IMFPredomList                            = LIST(!NULL)
  combFOMList                              = LIST(!NULL)
  dawnFOMList                              = LIST(!NULL)
  duskFOMList                              = LIST(!NULL)
  centerFOMList                            = LIST(!NULL)
  delayList                                = LIST(!NULL)
  nDelay                                   = N_ELEMENTS(delayArr)
  nClock                                   = N_ELEMENTS(clockStrArr)
