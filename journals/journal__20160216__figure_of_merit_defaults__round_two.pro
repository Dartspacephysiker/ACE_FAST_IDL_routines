;2016/02/16 Both North and South journals use these; NONSTORM-style

  IF N_ELEMENTS(lun) EQ 0 THEN lun         = -1 ;stdout

  printemall                               = 0

  h2dFileDir                               = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/20160216--Alfven_cusp_figure_of_merit/data/'
  outFile                                  = h2dFileDir+'processed/'+hoyDia+'--Cusp_splitting--'+STRUPCASE(hemi)+'_figures_of_merit_' + FOMString + '--delays_-25_25min.sav'

  ;;same for everyone
  binI                                     = 3

  minM                                     = 0.00000
  maxM                                     = 24.0000
  binM                                     = 0.5
  shiftM                                   = 0.25

  h2d_i                                    = 4            ; The one for probability of occurrence
  n_maxima                                 = 10           ; How many maxima are we getting?
  n_center_maxima                          = 1
  threshold_max                            = ALOG10(1.2)  ; Value shouldn't be more than 10% above 100% occurrence
  nFOM_to_print                            = 25

  ;;Boundaries for figure of merit
  ;;first entry is for dawnward IMF
  ;;second is for duskward IMF
  ;; dawn_minM                                = 9.25
  ;; dawn_maxM                                = 11.75
  ;; dusk_minM                                = 12.25
  ;; dusk_maxM                                = 14.75
  ;; center_minM                              = 11.75
  ;; center_maxM                              = 12.25

  ;;boundaries for each cusp
  particle_dawn_minM                       = 10.00
  particle_dawn_maxM                       = 11.75
  particle_dusk_minM                       = 12.25
  particle_dusk_maxM                       = 14.00
  
  alfven_dawn_minM                         =  9.50
  alfven_dawn_maxM                         = 11.75
  alfven_dusk_minM                         = 12.25
  alfven_dusk_maxM                         = 14.50

  ;;Alfven cusps
  Northern_dawnIMF_duskCell_minM           = alfven_dusk_minM
  Northern_dawnIMF_duskCell_maxM           = alfven_dusk_maxM
  Northern_duskIMF_dawnCell_minM           = alfven_dawn_minM
  Northern_duskIMF_dawnCell_maxM           = alfven_dawn_maxM

  Southern_dawnIMF_dawnCell_minM           = alfven_dawn_minM
  Southern_dawnIMF_dawnCell_maxM           = alfven_dawn_maxM
  Southern_duskIMF_duskCell_minM           = alfven_dusk_minM
  Southern_duskIMF_duskCell_maxM           = alfven_dusk_maxM

  ;;particle cusps
  Northern_dawnIMF_dawnCell_minM           = particle_dawn_minM
  Northern_dawnIMF_dawnCell_maxM           = particle_dawn_maxM
  Northern_duskIMF_duskCell_minM           = particle_dusk_minM
  Northern_duskIMF_duskCell_maxM           = particle_dusk_maxM

  Southern_dawnIMF_duskCell_minM           = particle_dusk_minM
  Southern_dawnIMF_duskCell_maxM           = particle_dusk_maxM
  Southern_duskIMF_dawnCell_minM           = particle_dawn_minM
  Southern_duskIMF_dawnCell_maxM           = particle_dawn_maxM

  center_minM                              = 11.75
  center_maxM                              = 12.25

  IF STRUPCASE(hemi) EQ 'SOUTH' THEN BEGIN

     fileDay                                  = 'Feb_16_16'

     minI                                     = -83.0000
     maxI                                     = -56.0000

     ;; ;;ILAT Boundaries for figure of merit
     dawnIMF_dawnCell_minM                    = Southern_dawnIMF_dawnCell_minM
     dawnIMF_dawnCell_maxM                    = Southern_dawnIMF_dawnCell_maxM
     duskIMF_duskCell_minM                    = Southern_duskIMF_duskCell_minM
     duskIMF_duskCell_maxM                    = Southern_duskIMF_duskCell_maxM

     dawnIMF_duskCell_minM                    = Southern_dawnIMF_duskCell_minM
     dawnIMF_duskCell_maxM                    = Southern_dawnIMF_duskCell_maxM
     duskIMF_dawnCell_minM                    = Southern_duskIMF_dawnCell_minM
     duskIMF_dawnCell_maxM                    = Southern_duskIMF_dawnCell_maxM

     dusk_minI                                = -78
     dusk_maxI                                = -65
     
     dawn_minI                                = -78
     dawn_maxI                                = -65

     center_minI                              = -78
     center_maxI                              = -65
     
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ 'NORTH' THEN BEGIN
        fileDay                               = 'Feb_16_16'

        minI                                  = 56.0000
        maxI                                  = 83.0000
        
        ;; ;;ILAT Boundaries for figure of merit
        dawnIMF_dawnCell_minM                 = Northern_dawnIMF_dawnCell_minM
        dawnIMF_dawnCell_maxM                 = Northern_dawnIMF_dawnCell_maxM
        duskIMF_duskCell_minM                 = Northern_duskIMF_duskCell_minM
        duskIMF_duskCell_maxM                 = Northern_duskIMF_duskCell_maxM
        
        dawnIMF_duskCell_minM                 = Northern_dawnIMF_duskCell_minM
        dawnIMF_duskCell_maxM                 = Northern_dawnIMF_duskCell_maxM
        duskIMF_dawnCell_minM                 = Northern_duskIMF_dawnCell_minM
        duskIMF_dawnCell_maxM                 = Northern_duskIMF_dawnCell_maxM
        
        dusk_minI                             = 65
        dusk_maxI                             = 78
        
        dawn_minI                             = 65
        dawn_maxI                             = 78
        
        center_minI                           = 65
        center_maxI                           = 78
     ENDIF
  ENDELSE

  ;;indices, assuming clockStr order is dawn then dusk
  dawn_minM                                   = [dawnIMF_dawnCell_minM,duskIMF_dawnCell_minM]
  dawn_maxM                                   = [dawnIMF_dawnCell_maxM,duskIMF_dawnCell_maxM]
  dusk_minM                                   = [dawnIMF_duskCell_minM,duskIMF_duskCell_minM]
  dusk_maxM                                   = [dawnIMF_duskCell_maxM,duskIMF_duskCell_maxM]

  ;;Get the ILAT and MLT bin centers
  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                               CENTERS1=centersMLT,CENTERS2=centersILAT, $
                               BINSIZE1=binM, BINSIZE2=binI, $
                               MAX1=maxM, MAX2=maxI, $
                               MIN1=minM, MIN2=minI, $
                               SHIFT1=shiftM, SHIFT2=shiftI

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
