;;2016/06/15 Making sure we were here often enough for the time averages in the IMF/Alfvén paper to be meaningful
;;Based on my checking things out here, it looks like the way to go is a lo

PRO JOURNAL__20160615__CHECK_THIST_TIMES_FOR_EACH_IMF_COND__MAKE_SURE_SAMPLING_IS_GOOD
  
  COMPILE_OPT idl2

  do_txt                  = 1

  outputDir               = '~/Desktop/Spence_paper_drafts/2016/Alfvens_IMF/'
  output                  = 'Check_tHist_times_for_each_IMF_cond__make_sure_sampling_is_good.txt'
  IF KEYWORD_SET(do_txt) THEN BEGIN
     PRINT,'Opening ' + output + ' ...'
     OPENW,outLun,outputDir+output,/GET_LUN
  ENDIF

  IF N_ELEMENTS(outLun) EQ 0 THEN outLun = 1

  testThreshold           = 2.0 ;min

  tmpDir                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  tmpFile                 = 'polarplots_Jun_15_16--NORTH--despun--avg--a_la_Zhang_2014__0stable__0.00mindelay__30.00Res__0.00binOffset__btMin5.0--theRing_tHistDenom.dat'
  RESTORE,tmpDir + tmpFile

  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                               MAX1=24, $
                               MIN1=0, $
                               MAX2=86, $
                               MIN2=62, $
                               BINSIZE1=1.0, $
                               SHIFT1=0.5, $
                               BINSIZE2=3.0
  
  ;; PRINT,centers[1,*,0],centers[0,*,0]

  ilats                   = REFORM(centers[1,*,0])
  mlts                    = REFORM(centers[0,*,0])
  minArr                  = !NULL
  nBelowArr               = !NULL
  nBelow_wz_Arr           = !NULL

  clockStrings            = ['bzNorth','dusk-north','duskward','dusk-south', $
                             'bzSouth','dawn-south','dawnward','dawn-north']
  ;; nameArr              = ['dawn-north','dawn','dawn-south','south', $
  ;;                  'dusk-south','dusk','dusk-north','north']

  PRINTF,outLun,FORMAT='("MLT",T10,"ILAT",T20,"tHistVal")'
  FOR i=0,N_ELEMENTS(h2dStrArr)-1 DO BEGIN

     PRINTF,outLun,''
     PRINTF,outLun,'******************************'
     PRINTF,outLun,clockStrings[i]
     PRINTF,outLun,''

     ;;Get the min
     tmpH2DRow            = h2dStrArr[i].data[*,0]
     nz_i                 = WHERE(tmpH2DRow GT 0,nNZ)
     IF nNZ GT 0 THEN BEGIN
        daMin             = MIN(tmpH2DRow[nz_i])
        PRINTF,outLun,"Min for hist[" + STRCOMPRESS(i,/REMOVE_ALL) + "]"
     ENDIF ELSE BEGIN
        PRINTF,outLun,'All zero here!'
        daMin             = 9999
     ENDELSE     
     minArr            = [minArr,daMin]

     FOR k=0,N_ELEMENTS(mlts)-1 DO BEGIN
        PRINTF,outLun,FORMAT='(F6.2,T10,F6.2,T20,F7.2)',mlts[k],ilats[k],h2dStrArr[i].data[k,0]
     ENDFOR
     PRINTF,outLun,""
     belowThresh_i        = WHERE(h2dStrArr[i].data GT 0 AND $
                                  h2dStrArr[i].data LT testThreshold, $
                                  nBelowThresh)
     belowThresh_wzero_i  = WHERE(h2dStrArr[i].data LT testThreshold, $
                                  nBelowThresh_wZero)
     
     nBelowArr            = [nBelowArr,nBelowThresh]
     nBelow_wz_Arr        = [nBelow_wz_Arr,nBelowThresh_wZero]

     PRINTF,outLun,FORMAT='("N below thresh,exc zero (",I0," min)",T35,": ",I0)',testThreshold,nBelowThresh
     PRINTF,outLun,FORMAT='("N below thresh, w/ zero (",I0," min)",T35,": ",I0)',testThreshold,nBelowThresh_wZero
     PRINTF,outLun,''
  ENDFOR

  PRINTF,outLun,''
  PRINTF,outLun,''
  PRINTF,outLun,'Clockstrings:'
  PRINTF,outLun,FORMAT='(4(A0,:,", "))',clockStrings
  PRINTF,outLun,''
  PRINTF,outLun,FORMAT='("Lowest time spent in a bin (excluding zero) :")'
  PRINTF,outLun,FORMAT='(4(F6.3,:,", "))',minArr
  PRINTF,outLun,''
  PRINTF,outLun,FORMAT='("N MLT-ILAT bins below thresh and above zero:")'
  PRINTF,outLun,FORMAT='(4(F6.3,:,", "))',nBelowArr
  PRINTF,outLun,''
  PRINTF,outLun,FORMAT='("N MLT-ILAT bins below thresh, including zero:")'
  PRINTF,outLun,FORMAT='(4(F6.3,:,", "))',nBelow_wz_Arr
  PRINTF,outLun,''
  PRINTF,outLun,"Min of the mins: " + STRCOMPRESS(MIN(minArr),/REMOVE_ALL)

  IF KEYWORD_SET(do_txt) THEN BEGIN
     PRINT,'Closing ' + output + ' ...'
     CLOSE,outLun
     FREE_LUN,outLun
  ENDIF

END