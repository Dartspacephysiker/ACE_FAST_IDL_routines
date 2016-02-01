;2016/02/01
;Let's take a look at this figure of merit stuff for EITHER hemi. Deprecate those other guys.

;Each file contains the following data products:
;; 0 *Max L.C. e!U-!N Flux (mW/m!U2!N), at ionos.
;; 1 *Integ. L.C. e!U-!N Flux (mW/m), at ionos.
;; 2 *Max Poynting Flux (mW/m!U2!N), at ionos.
;; 3 *Log Max Upward Ion Flux (#/cm!U2!N-s), at ionos.
;; 4 *Log Probability of occurrence
;; 5 *Log Number of events
;; 6 *Histogram mask
PRO JOURNAL__20160201__FIGURE_OF_MERIT_FOR_CUSP_SPLITTING__NORTH_OR_SOUTH__FOMII,HEMI=hemi,LUN=lun

  printemall                               = 1

  IF NOT KEYWORD_SET(hemi) THEN $
  hemi                                     = 'NORTH' ;need this for defaults
  ;; hemi                                     = 'SOUTH' ;need this for defaults

  hoyDia                                   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  @journal__20160201__figure_of_merit_ii_defaults


  ;;Now, let's get a specified number of maxima: loop through files, let us know if any don't exist
  h2dFNameFmt                              = '("raw/polarplots_"' + $
     ',A0,"--"' + $
     ',A0,"--logAvg--"' + $
     ',A0,"--0stable--OMNI_GSM_"' + $
     ',I0,"mindelay_byMin_",F3.1,".dat")'
  h2dFile                                  = STRING(FORMAT=h2dFNameFmt, $
                                                    fileDay,hemi,clockStrArr[0],delayArr[0],byMin)

  RESTORE,h2dFileDir+h2dFile
  PRINTF,lun,"Starting the action for a dawn/dusk figure of merit for: " + h2dStrArr[h2d_i].title
  PRINTF,lun,''
  IF KEYWORD_SET(printemall) THEN BEGIN
     PRINTF,lun,FORMAT='("Delay (m)",T20,"IMF",T30,"Comb. FOM",T45,"Dawn FOM",T60,"Dusk FOM",T75,"Center FOM")' ;header
     fmtString                             = '(I-4,T20,A9,T30,F0.3,T45,F0.3,T60,F0.3,T75,F0.3)'
  ENDIF

  FOR k=0,nClock-1 DO BEGIN
     h2dFileArr                            = !NULL
     combfomArr                            = !NULL
     dawnfomArr                            = !NULL
     duskfomArr                            = !NULL
     centerfomArr                          = !NULL

     PRINTF,lun,'****'+STRUPCASE(clockStrArr[k])+'****'
     FOR i=0,nDelay-1 DO BEGIN
        dawnExceed_ii                      = !NULL
        dawnExceedVals                     = !NULL
        dawnExceedN                        = !NULL

        duskExceed_ii                      = !NULL
        duskExceedVals                     = !NULL
        duskExceedN                        = !NULL

        centerExceed_ii                    = !NULL
        centerExceedVals                   = !NULL
        centerExceedN                      = !NULL

        h2dFile                            = STRING(FORMAT=h2dFNameFmt, $
                                                    fileDay,hemi,clockStrArr[k],delayArr[i],byMin)
        
        IF FILE_TEST(h2dFileDir+h2dFile) THEN BEGIN    ;Got 'im!

           restore,h2dFileDir+h2dFile
           
           ;handle the masked cells
           masked_i                        = WHERE(h2dStrArr[-1].data GT 250)
           h2dStrArr[h2d_i].data[masked_i] = -10

           dawn_data                       = h2dStrArr[h2d_i].data[dawn_i]
           dawn_maxima                     = 10.0^(GET_N_MAXIMA_IN_ARRAY(dawn_data,N=n_maxima,OUT_I=dawnMaxima_ii, $
                                                                         THRESHOLD=threshold_max, $
                                                                         OUT_EXCEEDED_THRESHOLD_VALS=dawnExceedVals, $
                                                                         OUT_EXCEEDED_THRESHOLD_I=dawnExceed_ii, $
                                                                         OUT_EXCEEDED_THRESHOLD_N=dawnExceedN))
           dawn_max_ilats                  = centersILAT[dawn_i[dawnMaxima_ii]]
           dawn_max_mlts                   = centersMLT[dawn_i[dawnMaxima_ii]]

           dusk_data                       = h2dStrArr[h2d_i].data[dusk_i]
           dusk_maxima                     = 10.0^(GET_N_MAXIMA_IN_ARRAY(dusk_data,N=n_maxima,OUT_I=duskMaxima_ii, $
                                                                         THRESHOLD=threshold_max, $
                                                                         OUT_EXCEEDED_THRESHOLD_VALS=duskExceedVals, $
                                                                         OUT_EXCEEDED_THRESHOLD_I=duskExceed_ii, $
                                                                         OUT_EXCEEDED_THRESHOLD_N=duskExceedN))
           dusk_max_ilats                  = centersILAT[dusk_i[duskMaxima_ii]]
           dusk_max_mlts                   = centersMLT[dusk_i[duskMaxima_ii]]
           
           center_data                     = h2dStrArr[h2d_i].data[center_i]
           center_maxima                   = 10.0^(GET_N_MAXIMA_IN_ARRAY(center_data,N=n_center_maxima,OUT_I=centerMaxima_ii, $
                                                                         THRESHOLD=threshold_max, $
                                                                         OUT_EXCEEDED_THRESHOLD_VALS=centerExceedVals, $
                                                                         OUT_EXCEEDED_THRESHOLD_I=centerExceed_ii, $
                                                                         OUT_EXCEEDED_THRESHOLD_N=centerExceedN))
           center_max_ilats                = centersILAT[center_i[centerMaxima_ii]]
           center_max_mlts                 = centersMLT[center_i[centerMaxima_ii]]
           
           ;;Show any bogus vals
           dawn_bogus_ilats                = centersILAT[dawn_i[dawnExceed_ii]]
           dawn_bogus_mlts                 = centersMLT[dawn_i[dawnExceed_ii]]

           dusk_bogus_ilats                = centersILAT[dusk_i[duskExceed_ii]]
           dusk_bogus_mlts                 = centersMLT[dusk_i[duskExceed_ii]]

           center_bogus_ilats                = centersILAT[center_i[centerExceed_ii]]
           center_bogus_mlts                 = centersMLT[center_i[centerExceed_ii]]

           IF dawnExceedN GT 0 OR duskExceedN GT 0 OR centerExceedN GT 0 THEN BEGIN
              PRINTF,lun,FORMAT='("Delay",T10,"Bogus val",T25,"Bogus ILAT",T40,"Bogus MLT")'

           IF dawnExceedN GT 0 THEN BEGIN
              PRINTF,lun,"Bogus dawnward vals"
              FOR l=0,dawnExceedN-1 DO BEGIN
                 PRINTF,lun,FORMAT=bogusFmt,delayArr[i],10.0^dawnExceedVals[l],dawn_bogus_ilats[l],dawn_bogus_mlts[l]
              ENDFOR
           END
           
           IF duskExceedN GT 0 THEN BEGIN
              PRINTF,lun,"Bogus duskward vals"
              FOR l=0,duskExceedN-1 DO BEGIN
                 PRINTF,lun,FORMAT=bogusFmt,delayArr[i],10.0^duskExceedVals[l],dusk_bogus_ilats[l],dusk_bogus_mlts[l]
              ENDFOR
           END

           IF centerExceedN GT 0 THEN BEGIN
              PRINTF,lun,"Bogus center vals"
              FOR l=0,centerExceedN-1 DO BEGIN
                 PRINTF,lun,FORMAT=bogusFmt,delayArr[i],10.0^centerExceedVals[l],center_bogus_ilats[l],center_bogus_mlts[l]
              ENDFOR
           END

        ENDIF           

           ;;calculate figures of merit
           dawn_fom                        = MEAN(dawn_maxima)
           dusk_fom                        = MEAN(dusk_maxima)
           center_fom                      = -2.*MEAN(center_maxima)
           comb_fom                        = dawn_fom+dusk_fom+center_fom

           ;;want to see?
           IF KEYWORD_SET(printemall) THEN BEGIN
              PRINTF,lun,FORMAT=fmtString,delayArr[i],clockStrArr[k],comb_fom,dawn_fom,dusk_fom,center_fom
           ENDIF
           
           combfomArr                      = [combfomArr,comb_fom]
           dawnfomArr                      = [dawnfomArr,dawn_fom]
           duskfomArr                      = [duskfomArr,dusk_fom]
           centerfomArr                    = [centerfomArr,center_fom]
           h2dFileArr                      = [h2dFileArr,h2dFile]

        ENDIF ELSE BEGIN
           PRINTF,lun,""
           PRINTF,lun,"File doesn't exist: " + h2dFile
           PRINTF,lun,""
        ENDELSE

     ENDFOR

     ;;Now lets see which figures of merit are most awesome
     combFOM_awesome                       = GET_N_MAXIMA_IN_ARRAY(combfomArr,N=nFOM_to_print,OUT_I=combFOM_i)
     dawnFOM_awesome                       = dawnfomArr[combFOM_i]
     duskFOM_awesome                       = duskfomArr[combFOM_i]
     centerFOM_awesome                     = centerfomArr[combFOM_i]
     delay_awesome                         = delayArr[combFOM_i]

     PRINTF,lun,"************THE RESULTS************"
     PRINTF,lun,""
     PRINTF,lun,FORMAT='("Rank",T10,"Delay (m)",T20,"Comb. FOM",T35,"Dawn FOM",T50,"Dusk FOM",T65,"Center FOM")' ;header
     fomFmtString                          = '(I-2,T10,I-4,T20,F0.3,T35,F0.3,T50,F0.3,T65,F0.3)'
     
     PRINTF,lun,'******'+STRUPCASE(clockStrArr[k])+'******'
     FOR i                                 =0,nFOM_to_print-1 DO BEGIN
        PRINTF,lun,FORMAT=fomFmtString,i+1,delay_awesome[i],combFOM_awesome[i],dawnFOM_awesome[i],duskFOM_awesome[i],centerFOM_awesome[i]
     ENDFOR
     PRINTF,lun,''
     PRINTF,lun,''
     
     IMFPredomList.add,clockStrArr[k]
     ;; combFOMList.add,combFOM_awesome
     ;; dawnFOMList.add,dawnFOM_awesome
     ;; duskFOMList.add,duskFOM_awesome
     ;; delayList.add,delay_awesome

     combFOMList.add,combfomArr
     dawnFOMList.add,dawnfomArr
     duskFOMList.add,duskfomArr
     centerFOMList.add,centerfomArr
     delayList.add,delayArr

  ENDFOR
  nFiles                                   = N_ELEMENTS(h2dFileArr)

  IMFPredomList.remove,0
  combFOMList.remove,0
  dawnFOMList.remove,0
  duskFOMList.remove,0
  centerFOMList.remove,0
  delayList.remove,0

  ;;Now combine stuff from each IMF predominance
  ;; FOR i=0,nDelay-1 DO BEGIN
  combDawnDusk                          = combFOMList[0]+combFOMList[1]+combFOMList[2]
  ;; ENDFOR
  
  combDawnDusk_awesome                  = GET_N_MAXIMA_IN_ARRAY(combDawnDusk,N=nFOM_to_print,OUT_I=combDawnDusk_i)
  delayDawnDusk_awesome                 = delayArr[combDawnDusk_i]
  PRINTF,lun,"************RESULTS FROM COMBINATION OF DAWNWARD AND DUSKWARD IMF STUFF************"
  PRINTF,lun,""
  PRINTF,lun,FORMAT='(T47,"DAWNWARD IMF",T77,"DUSKWARD IMF")'
  PRINTF,lun,FORMAT='("Rank",T10,"Delay (m)",T20,"Combined FOM |",T40,"Dawn cell",T55,"Dusk cell  |",T70,"Dawn cell",T85,"Dusk cell")' ;header
  fomUltimateFmtString                  = '(I-2,T10,I-4,T20,F0.3,"        |",T40,F0.3,T55,F0.3,"      |",T70,F0.3,T85,F0.3)'
  
  FOR i=0,nFOM_to_print-1 DO BEGIN
     list_i                             = combDawnDusk_i[i]
     ;; PRINTF,lun,FORMAT=fomUltimateFmtString,i+1,delayDawnDusk_awesome[i],combDawnDusk_awesome[i],dawnFOMList[0,i],duskFOMList[0,i],dawnFOMList[2,i],duskFOMList[2,i]
     PRINTF,lun,FORMAT=fomUltimateFmtString,i+1,delayDawnDusk_awesome[i],combDawnDusk_awesome[i],dawnFOMList[0,list_i],duskFOMList[0,list_i],dawnFOMList[2,list_i],duskFOMList[2,list_i]
  ENDFOR
  
  PRINTF,lun,'Saving lists to ' + outFile
  save,IMFPredomList,combFOMList,dawnFOMList,duskFOMList,delayList,FILENAME=outFile

END