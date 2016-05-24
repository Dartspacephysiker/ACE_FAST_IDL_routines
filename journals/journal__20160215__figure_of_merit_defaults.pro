;2016/02/15 Both North and South journals use these

  IF N_ELEMENTS(lun) EQ 0 THEN lun         = -1 ;stdout

  printemall                               = 0

  h2dFileDir                               = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/20160215--Alfven_cusp_figure_of_merit/data/'
  outFile                                  = h2dFileDir+'processed/'+hoyDia+'--Cusp_splitting--'+STRUPCASE(hemi)+'_figures_of_merit_' + FOMString + '--delays_0-30min.sav'

  ;;same for everyone
  binI                                     = 4

  ;; minM                                     = 0.00000
  ;; maxM                                     = 24.0000
  minM                                     = 8.5
  maxM                                     = 15.5
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

     fileDay                                  = 'Feb_15_16'

     minI                                     = -75.0000
     maxI                                     = -67.0000
     
     ;; ;;ILAT Boundaries for figure of merit
     dusk_minI                                = -75
     dusk_maxI                                = -67
     
     dawn_minI                                = -75
     dawn_maxI                                = -67

     center_minI                              = -75
     center_maxI                              = -67
     
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ 'NORTH' THEN BEGIN
        fileDay                               = 'Feb_15_16'

        minI                                  = 67.0000
        maxI                                  = 75.0000
        
        ;;ILAT Boundaries for figure of merit
        dusk_minI                             = 67
        dusk_maxI                             = 75
        
        dawn_minI                             = 67
        dawn_maxI                             = 75
        
        center_minI                           = 67
        center_maxI                           = 75
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


  clockStrArr                              = ['dawnward','all_IMF','duskward']
  byMin                                    = 3.0


  delayArr                                 = [ -300, -270,  -240,  -210,  -180,  -120, $
                                               -90,   -60,   -30,     0,    30,    60, $
                                               90, $
                                               120,   150,   180,   210,   240,   270, $  
                                               300,   330,   360,   390,   420,   450, $  
                                               480,   510,   540,   570,   600,   630, $  
                                               660,   690,   720,   750,   780,   810, $  
                                               840,   870,   900,   930,   960,  1020, $
                                               1050,  1080, $
                                               1110,  1140,  1170,  1200]/60.

  ;; delayArr                                 = [-300,  -240,  -180,  -120,   -60, $
  ;;                                                0,    60,   120,   180,   240, $
  ;;                                              300,   360,   420,   480,   540, $
  ;;                                              600,   660,   720,   780,   840, $
  ;;                                              900,   960,  1020,  1080,  1140, $
  ;;                                             1200,  1260,  1320,  1380,  1440, $
  ;;                                             1500]/60


  bogusFmt                                 = '(I0,T10,F0.3,T25,F0.3,T40,F0.3)' ;for bogus vals

  IMFPredomList                            = LIST(!NULL)
  combFOMList                              = LIST(!NULL)
  dawnFOMList                              = LIST(!NULL)
  duskFOMList                              = LIST(!NULL)
  centerFOMList                            = LIST(!NULL)
  delayList                                = LIST(!NULL)
  nDelay                                   = N_ELEMENTS(delayArr)
  nClock                                   = N_ELEMENTS(clockStrArr)
