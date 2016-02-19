;2016/02/16
;Now we've eliminated all_IMF and made the binning in MLT finer.

;; Each file contains the following data products:
;; 0 *Log Probability of occurrence
PRO JOURNAL__20160218__FIGURE_OF_MERIT_III_IV_V_FOR_CUSP_SPLITTING__NORTH_OR_SOUTH__IMFSTABILITY, $
   HEMI=hemi, $
   FOMSTRING=FOMString, $
   SUBTRACT_CENTER=subtract_center, $
   FILEDAY=fileDay, $
   STABLEIMF=stableIMF
   LUN=lun

  IF KEYWORD_SET(subtract_center) THEN BEGIN
     PRINT,'Subtracting center for combined FOM...'
     WAIT,1
  ENDIF

  IF ~KEYWORD_SET(FOMString) THEN BEGIN
     FOMString                             = 'III'
  ENDIF

  printemall                               = 1

  IF NOT KEYWORD_SET(hemi) THEN $
  hemi                                     = 'NORTH' ;need this for defaults
  ;; hemi                                     = 'SOUTH' ;need this for defaults

  hoyDia                                   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  @journal__20160218__figure_of_merit_defaults__imfstability

  ;;Now, let's get a specified number of maxima: loop through files, let us know if any don't exist
  h2dFNameFmt                              = '("raw/polarplots_"' + $
     ',A0,"--"' + $
     ',A0,"--logAvg--"' + $
     ',A0,"--",I0,"stable--OMNI_GSM_"' + $
     ',F0.2,"mindelay_byMin",F3.1,".dat")'
  h2dFile                                  = STRING(FORMAT=h2dFNameFmt, $
                                                    fileDay,hemi,clockStrArr[0],stableIMF,delayArr[0],byMin)

  RESTORE,h2dFileDir+h2dFile
  PRINTF,lun,"Starting the action for a dawn/dusk figure of merit for: " + h2dStrArr[h2d_i].title
  PRINTF,lun,''
  IF KEYWORD_SET(printemall) THEN BEGIN
     PRINTF,lun,FORMAT='("Delay (m)",T20,"IMF",T30,"Comb. FOM",T45,"Dawn FOM",T60,"Dusk FOM",T75,"Center FOM")' ;header
     fmtString                             = '(I-4,T20,A9,T30,G0.4,T45,G0.4,T60,G0.4,T75,G0.4)'
  ENDIF

  FOR k=0,nClock-1 DO BEGIN
     h2dFileArr                            = !NULL
     combfomArr                            = !NULL
     dawnfomArr                            = !NULL
     duskfomArr                            = !NULL
     centerfomArr                          = !NULL

     ;;Determine where to get the figure of merit stuff
     dawn_MLT_i                            = WHERE(centersMLT GE dawn_minM[k] AND centersMLT LE dawn_maxM[k])
     dawn_ILAT_i                           = WHERE(centersILAT GE dawn_minI AND centersILAT LE dawn_maxI)
     dawn_i                                = cgsetintersection(dawn_MLT_i,dawn_ILAT_i)
                                           
     dusk_MLT_i                            = WHERE(centersMLT GE dusk_minM[k] AND centersMLT LE dusk_maxM[k])
     dusk_ILAT_i                           = WHERE(centersILAT GE dusk_minI AND centersILAT LE dusk_maxI)
     dusk_i                                = cgsetintersection(dusk_MLT_i,dusk_ILAT_i)
                                           
     center_MLT_i                          = WHERE(centersMLT GE center_minM AND centersMLT LE center_maxM)
     center_ILAT_i                         = WHERE(centersILAT GE center_minI AND centersILAT LE center_maxI)
     center_i                              = cgsetintersection(center_MLT_i,center_ILAT_i)
     
     PRINTF,lun,'****'+STRUPCASE(clockStrArr[k])+'****'
     FOR i=0,nDelay-1 DO BEGIN
        h2dFile                            = STRING(FORMAT=h2dFNameFmt, $
                                                    fileDay,hemi,clockStrArr[k],stableIMF,delayArr[i],byMin)
        IF FILE_TEST(h2dFileDir+h2dFile) THEN BEGIN    ;Got 'im!

           restore,h2dFileDir+h2dFile
           
           ;;data logged?
           dataLogged = h2dStrArr[h2d_i].is_logged

           ;HANDLE THE MASKED CELLS
           ;; Old strategy
           ;; masked_i                        = WHERE(h2dStrArr[-1].data GT 250,COMPLEMENT=notMasked_i,NCOMPLEMENT=nNotMasked)
           ;; h2dStrArr[h2d_i].data[masked_i] = -10
           ;; dawn_i                          = CGSETINTERSECTION(dawn_i,notMasked_i)
           ;; dusk_i                          = CGSETINTERSECTION(dusk_i,notMasked_i)
           ;; center_i                        = CGSETINTERSECTION(center_i,notMasked_i)

           ;; New strategy
           masked_i                        = WHERE(h2dStrArr[-1].data GT 250,COMPLEMENT=notMasked_i,NCOMPLEMENT=nNotMasked)
           h2dStrArr[h2d_i].data[masked_i] = (dataLogged ? -6.00 : 0.00)
           ;; dawn_i                          = CGSETINTERSECTION(dawn_i,notMasked_i)
           ;; dusk_i                          = CGSETINTERSECTION(dusk_i,notMasked_i)
           ;; center_i                        = CGSETINTERSECTION(center_i,notMasked_i)

           IF dawn_i[0] EQ -1 THEN BEGIN
              PRINT,'No good dawn bins!'
              dawn_data                    = (dataLogged ? -6.00 : 0.00)
              dawn_maxes                   = (dataLogged ? -6.00 : 0.00)
           ENDIF ELSE BEGIN
              dawn_data                    = h2dStrArr[h2d_i].data[dawn_i]
              dawn_maxes                   = GET_N_MAXIMA_IN_ARRAY(dawn_data,N=n_maxima,OUT_I=dawn_maxes_i)
           ENDELSE
           IF dusk_i[0] EQ -1 THEN BEGIN
              PRINT,'No good dusk bins!'
              dusk_data                    = (dataLogged ? -6.00 : 0.00)
              dusk_maxes                   = (dataLogged ? -6.00 : 0.00)
           ENDIF ELSE BEGIN
              dusk_data                    = h2dStrArr[h2d_i].data[dusk_i]
              dusk_maxes                   = GET_N_MAXIMA_IN_ARRAY(dusk_data,N=n_maxima,OUT_I=dusk_maxes_i)
           ENDELSE
           IF center_i[0] EQ -1 AND KEYWORD_SET(subtract_center) THEN BEGIN
              PRINT,'No good center bins!'
              center_data                  = (dataLogged ? -6.00 : 0.00)
              center_maxes                 = (dataLogged ? -6.00 : 0.00)
           ENDIF ELSE BEGIN
              center_data                  = h2dStrArr[h2d_i].data[center_i]
              center_maxes                 = GET_N_MAXIMA_IN_ARRAY(center_data,N=n_maxima,OUT_I=center_maxes_i)
           ENDELSE
           
           ;;Screen out the bad stuff
           ;; CASE FOMString OF
           ;;    'III' : BEGIN ;Straight averaging
           ;;       IF dataLogged THEN BEGIN
           ;;          PRINT,'Data were logged! Unlogging for straight average...'
           ;;          dawn_data                 = 10.0D^(dawn_data)
           ;;          dusk_data                 = 10.0D^(dusk_data)
           ;;          center_data               = 10.0D^(center_data)
           ;;       ENDIF

           ;;       ;;calculate figures of merit
           ;;       dawn_fom                     = MEAN(dawn_data)
           ;;       dusk_fom                     = MEAN(dusk_data)
           ;;       center_fom                   = -2.D*MEAN(center_data)

           ;;       IF KEYWORD_SET(subtract_center) THEN BEGIN
           ;;          PRINT,'Subtracting center for each FOM...'
           ;;          ;; dawn_fom                  = dawn_fom+center_fom/2.
           ;;          ;; dusk_fom                  = dusk_fom+center_fom/2.
           ;;          dawn_fom                  = dawn_fom+center_fom
           ;;          dusk_fom                  = dusk_fom+center_fom
           ;;          comb_fom                  = dawn_fom+dusk_fom+center_fom
           ;;       ENDIF ELSE BEGIN
           ;;          comb_fom                  = dawn_fom+dusk_fom
           ;;       ENDELSE
           ;;    END
           ;;    'IV'  : BEGIN ;Log averaging
           ;;       IF ~dataLogged THEN BEGIN
           ;;          PRINT,'Data were not logged! Logging for log average...'
           ;;          dawn_data                 = ALOG10(dawn_data)
           ;;          dusk_data                 = ALOG10(dusk_data)
           ;;          center_data               = ALOG10(center_data)
           ;;       ENDIF
           ;;       dawn_fom                     = 10.0D^MEAN(dawn_data)
           ;;       dusk_fom                     = 10.0D^MEAN(dusk_data)
           ;;       center_fom                   = -2.D*10.0D^(MEAN(center_data))
           ;;       IF KEYWORD_SET(subtract_center) THEN BEGIN
           ;;          PRINT,'Subtracting center for each FOM...'
           ;;          ;; dawn_fom                  = dawn_fom+center_fom/2.
           ;;          ;; dusk_fom                  = dusk_fom+center_fom/2.
           ;;          dawn_fom                  = dawn_fom+center_fom
           ;;          dusk_fom                  = dusk_fom+center_fom
           ;;          comb_fom                  = dawn_fom+dusk_fom+center_fom
           ;;       ENDIF ELSE BEGIN
           ;;          comb_fom                  = dawn_fom+dusk_fom
           ;;       ENDELSE

           ;;    END
           ;;    'V'  : BEGIN ;Median
           ;;       IF dataLogged THEN BEGIN
           ;;          PRINT,'Data were logged! Unlogging for straight average...'
           ;;          dawn_data                 = 10.0D^(dawn_data)
           ;;          dusk_data                 = 10.0D^(dusk_data)
           ;;          center_data               = 10.0D^(center_data)
           ;;       ENDIF
           ;;       IF N_ELEMENTS(dawn_data) GT 1 THEN BEGIN
           ;;          dawn_fom                  = MEDIAN(dawn_data)
           ;;       ENDIF ELSE BEGIN
           ;;          dawn_fom                  = dawn_data
           ;;       ENDELSE
           ;;       IF N_ELEMENTS(dusk_data) GT 1 THEN BEGIN
           ;;          dusk_fom                  = MEDIAN(dusk_data)
           ;;       ENDIF ELSE BEGIN
           ;;          dusk_fom                  = dusk_data
           ;;       ENDELSE
           ;;       IF N_ELEMENTS(center_data) GT 1 THEN BEGIN
           ;;          center_fom                  = -2.D*MEDIAN(center_data)
           ;;       ENDIF ELSE BEGIN
           ;;          center_fom                  = -2.D*center_data
           ;;       ENDELSE

           ;;       IF KEYWORD_SET(subtract_center) THEN BEGIN
           ;;          PRINT,'Subtracting center for each FOM...'
           ;;          ;; dawn_fom                  = dawn_fom+center_fom/2.
           ;;          ;; dusk_fom                  = dusk_fom+center_fom/2.
           ;;          dawn_fom                  = dawn_fom+center_fom
           ;;          dusk_fom                  = dusk_fom+center_fom
           ;;          comb_fom                  = dawn_fom+dusk_fom+center_fom
           ;;       ENDIF ELSE BEGIN
           ;;          comb_fom                  = dawn_fom+dusk_fom
           ;;       ENDELSE

           ;;    END
           ;;    ELSE : BEGIN
           ;;       PRINT,'Neither III (straight avg) nor IV (log avg) nor V (median) was provided for FOMString!'
           ;;       PRINT,'What to do?'
           ;;       PRINT,'OUT'
           ;;       RETURN
           ;;    END
           ;; ENDCASE
           CASE FOMString OF
              'III' : BEGIN ;Straight averaging
                 IF dataLogged THEN BEGIN
                    PRINT,'Data were logged! Unlogging for straight average...'
                    dawn_maxes                 = 10.0D^(dawn_maxes)
                    dusk_maxes                 = 10.0D^(dusk_maxes)
                    center_maxes               = 10.0D^(center_maxes)
                 ENDIF

                 ;;calculate figures of merit
                 dawn_fom                     = MEAN(dawn_maxes)
                 dusk_fom                     = MEAN(dusk_maxes)
                 center_fom                   = -2.D*MEAN(center_maxes)

                 IF KEYWORD_SET(subtract_center) THEN BEGIN
                    PRINT,'Subtracting center for each FOM...'
                    ;; dawn_fom                  = dawn_fom+center_fom/2.
                    ;; dusk_fom                  = dusk_fom+center_fom/2.
                    dawn_fom                  = dawn_fom+center_fom
                    dusk_fom                  = dusk_fom+center_fom
                    comb_fom                  = dawn_fom+dusk_fom+center_fom
                 ENDIF ELSE BEGIN
                    comb_fom                  = dawn_fom+dusk_fom
                 ENDELSE
              END
              'IV'  : BEGIN ;Log averaging
                 IF ~dataLogged THEN BEGIN
                    PRINT,'Data were not logged! Logging for log average...'
                    dawn_maxes                 = ALOG10(dawn_maxes)
                    dusk_maxes                 = ALOG10(dusk_maxes)
                    center_maxes               = ALOG10(center_maxes)
                 ENDIF
                 dawn_fom                     = 10.0D^MEAN(dawn_maxes)
                 dusk_fom                     = 10.0D^MEAN(dusk_maxes)
                 center_fom                   = -2.D*10.0D^(MEAN(center_maxes))
                 IF KEYWORD_SET(subtract_center) THEN BEGIN
                    PRINT,'Subtracting center for each FOM...'
                    ;; dawn_fom                  = dawn_fom+center_fom/2.
                    ;; dusk_fom                  = dusk_fom+center_fom/2.
                    dawn_fom                  = dawn_fom+center_fom
                    dusk_fom                  = dusk_fom+center_fom
                    comb_fom                  = dawn_fom+dusk_fom+center_fom
                 ENDIF ELSE BEGIN
                    comb_fom                  = dawn_fom+dusk_fom
                 ENDELSE

              END
              'V'  : BEGIN ;Median
                 IF dataLogged THEN BEGIN
                    PRINT,'Data were logged! Unlogging for straight average...'
                    dawn_maxes                = 10.0D^(dawn_maxes)
                    dusk_maxes                = 10.0D^(dusk_maxes)
                    center_maxes              = 10.0D^(center_maxes)
                 ENDIF
                 IF N_ELEMENTS(dawn_maxes) GT 1 THEN BEGIN
                    dawn_fom                  = MEDIAN(dawn_maxes)
                 ENDIF ELSE BEGIN
                    dawn_fom                  = dawn_maxes
                 ENDELSE
                 IF N_ELEMENTS(dusk_maxes) GT 1 THEN BEGIN
                    dusk_fom                  = MEDIAN(dusk_maxes)
                 ENDIF ELSE BEGIN
                    dusk_fom                  = dusk_maxes
                 ENDELSE
                 IF N_ELEMENTS(center_maxes) GT 1 THEN BEGIN
                    center_fom                = -2.D*MEDIAN(center_maxes)
                 ENDIF ELSE BEGIN
                    center_fom                = -2.D*center_maxes
                 ENDELSE

                 IF KEYWORD_SET(subtract_center) THEN BEGIN
                    PRINT,'Subtracting center for each FOM...'
                    ;; dawn_fom                  = dawn_fom+center_fom/2.
                    ;; dusk_fom                  = dusk_fom+center_fom/2.
                    dawn_fom                  = dawn_fom+center_fom
                    dusk_fom                  = dusk_fom+center_fom
                    comb_fom                  = dawn_fom+dusk_fom+center_fom
                 ENDIF ELSE BEGIN
                    comb_fom                  = dawn_fom+dusk_fom
                 ENDELSE

              END
              ELSE : BEGIN
                 PRINT,'Neither III (straight avg) nor IV (log avg) nor V (median) was provided for FOMString!'
                 PRINT,'What to do?'
                 PRINT,'OUT'
                 RETURN
              END
           ENDCASE

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

     PRINTF,lun,"************THE RESULTS FOR FOM=" + FOMString + "************"
     PRINTF,lun,""
     PRINTF,lun,FORMAT='("Rank",T10,"Delay (m)",T20,"Comb. FOM",T35,"Dawn FOM",T50,"Dusk FOM",T65,"Center FOM")' ;header
     fomFmtString                          = '(I-2,T10,I-4,T20,G0.4,T35,G0.4,T50,G0.4,T65,G0.4)'
     
     PRINTF,lun,'******'+STRUPCASE(clockStrArr[k])+'******'
     FOR i                                 =0,nFOM_to_print-1 DO BEGIN
        PRINTF,lun,FORMAT=fomFmtString,i+1,delay_awesome[i],combFOM_awesome[i],dawnFOM_awesome[i],duskFOM_awesome[i],centerFOM_awesome[i]
     ENDFOR
     PRINTF,lun,''
     PRINTF,lun,''
     
     IMFPredomList.add,clockStrArr[k]

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
  combDawnDusk                          = combFOMList[0]+combFOMList[1]
  ;; ENDFOR
  
  combDawnDusk_awesome                  = GET_N_MAXIMA_IN_ARRAY(combDawnDusk,N=nFOM_to_print,OUT_I=combDawnDusk_i)
  delayDawnDusk_awesome                 = delayArr[combDawnDusk_i]
  PRINTF,lun,"************RESULTS FROM COMBINATION OF DAWNWARD AND DUSKWARD IMF STUFF************"
  PRINTF,lun,""
  PRINTF,lun,FORMAT='(T47,"DAWNWARD IMF",T77,"DUSKWARD IMF")'
  PRINTF,lun,FORMAT='("Rank",T10,"Delay (m)",T20,"Combined FOM |",T40,"Dawn cell",T55,"Dusk cell  |",T70,"Dawn cell",T85,"Dusk cell")' ;header
  fomUltimateFmtString                  = '(I-2,T10,I-4,T20,G0.4,"        |",T40,G0.4,T55,G0.4,"      |",T70,G0.4,T85,G0.4)'
  
  FOR i=0,nFOM_to_print-1 DO BEGIN
     list_i                             = combDawnDusk_i[i]
     ;; PRINTF,lun,FORMAT=fomUltimateFmtString,i+1,delayDawnDusk_awesome[i],combDawnDusk_awesome[i],dawnFOMList[0,i],duskFOMList[0,i],dawnFOMList[2,i],duskFOMList[2,i]
     PRINTF,lun,FORMAT=fomUltimateFmtString,i+1,delayDawnDusk_awesome[i],combDawnDusk_awesome[i],dawnFOMList[0,list_i],duskFOMList[0,list_i],dawnFOMList[1,list_i],duskFOMList[1,list_i]
  ENDFOR
  
  PRINTF,lun,'Saving lists to ' + outFile
  save,IMFPredomList,combFOMList,dawnFOMList,duskFOMList,delayList,FILENAME=outFile

END