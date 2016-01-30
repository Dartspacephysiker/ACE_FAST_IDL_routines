;2016/01/30
;Let's take a look at this figure of merit stuff. I've got all the data, anyway.

;Each file contains the following data products:
;; 0 *Max L.C. e!U-!N Flux (mW/m!U2!N), at ionos.
;; 1 *Integ. L.C. e!U-!N Flux (mW/m), at ionos.
;; 2 *Max Poynting Flux (mW/m!U2!N), at ionos.
;; 3 *Log Max Upward Ion Flux (#/cm!U2!N-s), at ionos.
;; 4 *Log Probability of occurrence
;; 5 *Log Number of events
;; 6 *Histogram mask
PRO JOURNAL__20160130__FIGURE_OF_MERIT_FOR_CUSP_SPLITTING

  h2dFileDir              = '/SPENCEdata/Research/Cusp/ACE_FAST/20160130--Alfven_cusp_figure_of_merit/data/'

  hoyDia                  = 'Jan_28_16'

  minI                    = 55.0000
  maxI                    = 85.0000
  binI                    = 2.5

  minM                    = 0.00000
  maxM                    = 24.0000
  binM                    = 1.0
  shiftM                  = 0.5

  h2d_i                   = 4            ; The one for probability of occurrence
  n_maxima                = 2            ; How many maxima are we getting?

  ;;Boundaries for figure of merit
  dusk_minM               = 12.5
  dusk_maxM               = 15.5
  dusk_minI               = 60
  dusk_maxI               = 75

  dawn_minM               = 8.5
  dawn_maxM               = 11.5
  dawn_minI               = 60
  dawn_maxI               = 75

  ;;Get the ILAT and MLT bin centers
  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                               CENTERS1=centersMLT,CENTERS2=centersILAT, $
                               BINSIZE1=binM, BINSIZE2=binI, $
                               MAX1=maxM, MAX2=maxI, $
                               MIN1=minM, MIN2=minI, $
                               SHIFT1=shiftM, SHIFT2=shiftI

  ;;Determine where to get the figure of merit stuff
  dawn_MLT_i              = WHERE(centersMLT GE dawn_minM AND centersMLT LE dawn_maxM)
  dawn_ILAT_i             = WHERE(centersILAT GE dawn_minI AND centersILAT LE dawn_maxI)
  dawn_i                  = cgsetintersection(dawn_MLT_i,dawn_ILAT_i)

  dusk_MLT_i              = WHERE(centersMLT GE dusk_minM AND centersMLT LE dusk_maxM)
  dusk_ILAT_i             = WHERE(centersILAT GE dusk_minI AND centersILAT LE dusk_maxI)
  dusk_i                  = cgsetintersection(dusk_MLT_i,dusk_ILAT_i)

  ;;parameters for files to be looped over
  hemi                    = 'NORTH'
  clockStrArr             = ['dawnward','all_IMF','duskward']
  byMin                   = 3.0

  delayArr                = [300,360,420,480,540, $
                             600,660,720,780,840, $
                             900,960,1020,1080,1140, $
                             1200,1260,1320,1380,1440, $
                             1500,1560,1620,1680,1740, $
                             1800]/60

  ;;Now, let's get a specified number of maxima: loop through files, let us know if any don't exist

  PRINT,"Starting the action for a dawn/dusk figure of merit for: " + h2dStr[h2d_i].title
  PRINT,''
  PRINT,FORMAT='("Delay (m)",T20,"IMF",T30,"Dawn Fig. of Merit","Dusk Fig. of Merit")' ;header
  fmtString               = '(I-4,T20,A9,T30,F0.2,T50,F0.2)'

  nDelay                  = N_ELEMENTS(delayArr)
  nClock                  = N_ELEMENTS(clockStrArr)
  h2dFileArr              = !NULL
  fomArr                  = !NULL
  FOR i=0,nDelay-1 DO BEGIN
     FOR k=0,nClock-1 DO BEGIN
        h2dFile           = STRING(FORMAT='("polarplots_"' + $
                                   ',A0,"--"' + $
                                   ',A0,"--logAvg--"' + $
                                   ',A0,"--0stable--OMNI_GSM_"' + $
                                   ',I0,"mindelay_byMin_",F3.1,".dat")', $
                                   hoyDia,hemi,clockStrArr[k],delayArr[i],byMin)

        IF FILE_TEST(h2dFileDir+h2dFile) THEN BEGIN    ;Got 'im!


           restore,h2dFileDir+h2dFileArr[i]
           
           dawn_data      = h2dStrArr[h2d_i].data[dawn_i]
           dawn_maxima    = GET_N_MAXIMA_IN_ARRAY(dawn_data,N=n_maxima,OUT_I=dawnMaxima_ii)
           dawn_max_ilats = centersILAT[dawn_i[dawnMaxima_ii]]
           dawn_max_mlts  = centersMLT[dawn_i[dawnMaxima_ii]]

           dusk_data      = h2dStrArr[h2d_i].data[dusk_i]
           dusk_maxima    = GET_N_MAXIMA_IN_ARRAY(dusk_data,N=n_maxima,OUT_I=duskMaxima_ii)
           dusk_max_ilats = centersILAT[dusk_i[duskMaxima_ii]]
           dusk_max_mlts  = centersMLT[dusk_i[duskMaxima_ii]]
           
           dawn_fom       = MEAN(dawn_maxima)
           dusk_fom       = MEAN(dusk_maxima)

           PRINT,FORMAT=fmtString,delayArr[i/nClock]/60,clockStrArr[k],fom
           
           fomArr         = [fomArr,[dawn_fom,dusk_fom]]
           h2dFileArr     = [h2dFileArr,h2dFile]

        ENDIF ELSE BEGIN
           PRINT,""
           PRINT,"File doesn't exist: " + h2dFile
           PRINT,""
        ENDELSE

     ENDFOR
  ENDFOR
  nFiles                  = N_ELEMENTS(h2dFileArr)

  STOP

END