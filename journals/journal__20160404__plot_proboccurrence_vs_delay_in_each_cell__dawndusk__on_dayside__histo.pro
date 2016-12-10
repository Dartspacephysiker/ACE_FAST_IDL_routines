;2016/04/04 Some new approaches
PRO JOURNAL__20160404__PLOT_PROBOCCURRENCE_VS_DELAY_IN_EACH_CELL__DAWNDUSK__ON_DAYSIDE__HISTO
  date                           = '20160406'

  crossCorr_pref                 = 'journal__' + date + '__CrossCorr_probOccurrence_vs_delay--all_alts--'
  outPlot_pref                   = 'journal__' + date + '__plot_probOccurrence_vs_delay--all_alts--'
  outFile_dir                    = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/journals/journal__' + date + '__probOccurrence_and_crosscorrelation_savefiles/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Storm stuff?
  ;; mainPhase                      = 0
  ;; recoveryPhase                  = 0
  ;; nonstorm                       = 0
  ;; dstCutoff                      = -50

  do_center_cell                 = 1

  minNEvents                     = 20

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;delay stuff
  totMinToDisplay                = 6000

  ;; delayDeltaSec                  = 900
  ;; delay_res                      = 900
  ;; binOffset_delay                = 0

  ;; delayDeltaSec                  = 600
  ;; delay_res                      = 600
  ;; binOffset_delay                = 300

  ;; delayDeltaSec                  = 1200
  ;; delay_res                      = 1200
  ;; binOffset_delay                = 600

  ;; delayDeltaSec                  = 1800
  ;; delay_res                      = 1800
  ;; binOffset_delay                = 900

  ;;2016/04/06 Based on the latest, K?
  delayDeltaSec                  = 1800
  delay_res                      = 1800
  binOffset_delay                = 0

  ;; nDelays                        = 401
  nDelays                        = FIX(FLOAT(totMinToDisplay)/delayDeltaSec*60)
  IF (nDelays MOD 2) EQ 0 THEN nDelays++

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff

  ;; ;;For Dawn/dusk stuff
  clockStr                       = ['dawnward','duskward'] ;2016/04/06 for negAngle posAngle 60 120
  byMin                          = 5
  do_abs_byMin                   = 1
  bzMax                          = -5
  ;; bzMin                          = 1

  ;; clockStr                       = ['dawnward','duskward']
  ;; byMin                          = 8
  ;; do_abs_byMin                   = 1
  ;; bzMax                          = -4
  ;; bzMin                          = 1

  ;; ;;For bzNorth/South stuff
  ;; clockStr                       = ['bzNorth','bzSouth']
  ;; byMax                          = 5
  ;; do_abs_byMax                   = 1
  ;; bzMin                          = 5
  ;; do_abs_bzMin                   = 1


  ;;DB stuff
  do_despun                      = 1
  altitudeRange                  = [0000,4175]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Customize 'em!
  hemi                           = 'NORTH'
  minILAT                        = [ 65, 65, 65, 65, 65, 65]
  ;; maxILAT                        = [ 79, 79, 79, 79, 79, 79]
  maxILAT                        = [ 73, 73, 73, 73, 73, 73]
  centerMLT__dawn                = 12.0
  centerMLT__dusk                = 12.0

  ;; Looks like Southern Hemi cells split around 11.25, and the important stuff is below -71 
  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -[ 79, 79, 79, 79, 79, 79]
  ;; maxILAT                        = -[ 66, 66, 66, 66, 66, 66]
  ;; centerMLT__dawn                = 12.0
  ;; centerMLT__dusk                = 12.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  nBinsMLT                       = 3.0

  cell                           = ['Dawn cell','Dusk cell','Center cell']
  minMLT                         = [ centerMLT__dawn-binMLT*0.5-nBinsMLT*binMLT, centerMLT__dawn+binMLT*0.5                , $ ;;dawnward IMF
                                     centerMLT__dawn-nBinsMLT*binMLT*0.5       ,                                             $ ;;;(center cell)
                                     centerMLT__dusk-binMLT*0.5-nBinsMLT*binMLT, centerMLT__dusk+binMLT*0.5                , $ ;;duskward IMF
                                     centerMLT__dusk-nBinsMLT*binMLT*0.5                                                   ]   ;;;(center cell)

  maxMLT                         = [ centerMLT__dawn-binMLT*0.5                , centerMLT__dawn+binMLT*0.5+nBinsMLT*binMLT, $ ;;dawnward IMF
                                     centerMLT__dawn+nBinsMLT*binMLT*0.5       ,                                             $ ;;;(center cell)
                                     centerMLT__dusk-binMLT*0.5                , centerMLT__dusk+binMLT*0.5+nBinsMLT*binMLT, $ ;;duskward IMF
                                     centerMLT__dusk+nBinsMLT*binMLT*0.5                                                   ]   ;;;(center cell)


  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;storm stuff
  IF KEYWORD_SET(nonstorm) OR KEYWORD_SET(mainPhase) OR KEYWORD_SET(recoveryPhase) THEN BEGIN
     GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
        NONSTORM_I=ns_i, $
        MAINPHASE_I=mp_i, $
        RECOVERYPHASE_I=rp_i, $
        DSTCUTOFF=dstCutoff, $
        STORM_DST_I=s_dst_i, $
        NONSTORM_DST_I=ns_dst_i, $
        MAINPHASE_DST_I=mp_dst_i, $
        RECOVERYPHASE_DST_I=rp_dst_i, $
        N_STORM=n_s, $
        N_NONSTORM=n_ns, $
        N_MAINPHASE=n_mp, $
        N_RECOVERYPHASE=n_rp, $
        NONSTORM_T1=ns_t1,MAINPHASE_T1=mp_t1,RECOVERYPHASE_T1=rp_t1, $
        NONSTORM_T2=ns_t2,MAINPHASE_T2=mp_t2,RECOVERYPHASE_T2=rp_t2, $
        DO_DESPUN=do_despun, $
        LUN=lun
  ENDIF
     
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; plot_i_list_list               = LIST()
  ;; fastloc_i_list_list            = LIST()
  title_list                     = LIST()
  probOccList                     = LIST()
  nCells                         = N_ELEMENTS(cell)
  ;;loop over clockstrings, then cells
  FOR clock_i=0,N_ELEMENTS(clockStr)-1 DO BEGIN
     FOR mlt_i=0,N_ELEMENTS(cell)-2+KEYWORD_SET(do_center_cell) DO BEGIN
        
        SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                   MINMLT=minMLT[mlt_i+nCells*clock_i],MAXMLT=maxMLT[mlt_i+nCells*clock_i], $
                                   BINMLT=binMLT, $
                                   SHIFTMLT=shiftMLT, $
                                   MINILAT=minILAT[mlt_i+nCells*clock_i],MAXILAT=maxILAT[mlt_i+nCells*clock_i],BINILAT=binILAT, $
                                   MIN_MAGCURRENT=minMC, $
                                   MAX_NEGMAGCURRENT=maxNegMC, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   DESPUNDB=despun, $
                                   HEMI=hemi, $
                                   BOTH_HEMIS=both_hemis, $
                                   DATADIR=dataDir, $
                                   PARAMSTRING=paramString, $
                                   PARAMSTRPREFIX=plotPrefix, $
                                   PARAMSTRSUFFIX=plotSuffix,$
                                   /DONT_CORRECT_ILATS, $
                                   HOYDIA=hoyDia,LUN=lun,_EXTRA=e
        
        SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr[clock_i], $
                                        ANGLELIM1=angleLim1, $
                                        ANGLELIM2=angleLim2, $
                                        ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                        BYMIN=byMin, $
                                        BZMIN=bzMin, $
                                        BYMAX=byMax, $
                                        BZMAX=bzMax, $
                                        DO_ABS_BYMIN=do_abs_byMin, $
                                        DO_ABS_BYMAX=do_abs_byMax, $
                                        DO_ABS_BZMIN=do_abs_bzMin, $
                                        DO_ABS_BZMAX=do_abs_bzMax, $
                                        BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                        PARAMSTRING=paramString, $
                                        PARAMSTR_LIST=paramString_list, $
                                        SATELLITE=satellite, $
                                        OMNI_COORDS=omni_Coords, $
                                        DELAY=delayArr, $
                                        /MULTIPLE_DELAYS, $
                                        RESOLUTION_DELAY=delay_res, $
                                        BINOFFSET_DELAY=binOffset_delay, $
                                        STABLEIMF=stableIMF, $
                                        SMOOTHWINDOW=smoothWindow, $
                                        INCLUDENOCONSECDATA=includeNoConsecData, $
                                        LUN=lun
        
        plot_i_list                    = GET_RESTRICTED_AND_INTERPED_DB_INDICES(maximus,satellite,delayArr,LUN=lun, $
                                                                                DBTIMES=cdbTime,dbfile=dbfile, $
                                                                                DESPUNDB=despun, $
                                                                                HEMI=hemi, $
                                                                                ORBRANGE=orbRange, $
                                                                                ALTITUDERANGE=altitudeRange, $
                                                                                CHARERANGE=charERange, $
                                                                                POYNTRANGE=poyntRange, $
                                                                                MINMLT=minMLT[mlt_i+nCells*clock_i],MAXMLT=maxMLT[mlt_i+nCells*clock_i], $
                                                                                BINM=binMLT, $
                                                                                SHIFTM=shiftMLT, $
                                                                                MINILAT=minILAT[mlt_i+nCells*clock_i], $
                                                                                MAXILAT=maxILAT[mlt_i+nCells*clock_i], $
                                                                                BINI=binILAT, $
                                                                                DO_LSHELL=do_lshell, $
                                                                                MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                                                SMOOTHWINDOW=smoothWindow, $
                                                                                BYMIN=byMin,BZMIN=bzMin, $
                                                                                BYMAX=byMax,BZMAX=bzMax, $
                                                                                DO_ABS_BYMIN=do_abs_byMin, $
                                                                                DO_ABS_BYMAX=do_abs_byMax, $
                                                                                DO_ABS_BZMIN=do_abs_bzMin, $
                                                                                DO_ABS_BZMAX=do_abs_bzMax, $
                                                                                CLOCKSTR=clockStr[clock_i], $
                                                                                RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                                                                BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                                /MULTIPLE_DELAYS, $
                                                                                RESOLUTION_DELAY=delay_res, $
                                                                                BINOFFSET_DELAY=binOffset_delay, $
                                                                                STABLEIMF=stableIMF, $
                                                                                DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                                                                OMNI_COORDS=omni_Coords, $
                                                                                OUT_OMNI_PARAMSTR=omni_paramStr, $
                                                                                ANGLELIM1=angleLim1, $
                                                                                ANGLELIM2=angleLim2, $
                                                                                HWMAUROVAL=HwMAurOval, $
                                                                                HWMKPIND=HwMKpInd, $
                                                                                NO_BURSTDATA=no_burstData)


        GET_FASTLOC_INDS_IMF_CONDS_V2,fastLocInterped_i_list,CLOCKSTR=clockStr[clock_i], ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                      ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                      BYMIN=byMin, $
                                      BYMAX=byMax, $
                                      BZMIN=bzMin, $
                                      BZMAX=bzMax, $
                                      DO_ABS_BYMIN=abs_byMin, $
                                      DO_ABS_BYMAX=abs_byMax, $
                                      DO_ABS_BZMIN=abs_bzMin, $
                                      DO_ABS_BZMAX=abs_bzMax, $
                                      MINMLT=minMLT[mlt_i+nCells*clock_i],MAXMLT=maxMLT[mlt_i+nCells*clock_i], $
                                      BINM=binMLT, $
                                      SHIFTM=shiftMLT, $
                                      MINILAT=minILAT[mlt_i+nCells*clock_i], $
                                      MAXILAT=maxILAT[mlt_i+nCells*clock_i], $
                                      BINI=binILAT, $
                                      SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                      HEMI=hemi, $
                                      DELAY=delayArr, $
                                      /MULTIPLE_DELAYS, $
                                      RESOLUTION_DELAY=delay_res, $
                                      BINOFFSET_DELAY=binOffset_delay, $
                                      STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                      HWMAUROVAL=0,HWMKPIND=!NULL, $
                                      ;; MAKE_OUTINDSFILE=1, $
                                      OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                      ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                      ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                      FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                      BURSTDATA_EXCLUDED=burstData_excluded, $
                                      GET_FASTLOC_STRUCT=(N_ELEMENTS(fastLoc) EQ 0), $
                                      GET_FASTLOC_DELTA_T=(N_ELEMENTS(fastLoc_delta_t) EQ 0), $
                                      OUT_FASTLOC_STRUCT=fastLoc, $
                                      OUT_FASTLOC_DELTA_T=fastLoc_delta_t
        
        
        
        ;; plot_i_list_list.add,plot_i_list
        ;; fastLocInterped_i_list_list.add,fastLocInterped_i_list
        title_list.add,clockStr[clock_i]+'--minM_maxM__'+STRCOMPRESS(minMLT[mlt_i+nCells*clock_i],/REMOVE_ALL)+'_'+STRCOMPRESS(maxMLT[mlt_i+nCells*clock_i],/REMOVE_ALL)
        
        CASE 1 OF
           KEYWORD_SET(nonstorm): BEGIN
              bonus_i = ns_i
           END
           KEYWORD_SET(mainPhase): BEGIN
              bonus_i = mp_i
           END
           KEYWORD_SET(recoveryPhase) : BEGIN
              bonus_i = rp_i
           END
           ELSE: BEGIN
           END
        ENDCASE

        IF KEYWORD_SET(nonstorm) OR KEYWORD_SET(mainPhase) OR KEYWORD_SET(recoveryPhase) THEN BEGIN
           FOR i=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN 
              plot_i_list[i] = CGSETINTERSECTION(plot_i_list[i],bonus_i,SUCCESS=success)
              IF ~success THEN BEGIN
                 plot_i_list[i] = -1
                 PRINT,'Lost delay = ' + STRCOMPRESS(delayArr[i],/REMOVE_ALL) + "min to storm restriction ..."
              ENDIF
           ENDFOR
        ENDIF

        probOcc=!NULL
        FOR i=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN 
           IF plot_i_list[i,0] EQ -1 OR N_ELEMENTS(plot_i_list[i]) LT minNEvents THEN BEGIN
              numerator = 0 
              PRINT,'No data for delay = ' + STRCOMPRESS(delayArr[i],/REMOVE_ALL) + '...'
           ENDIF ELSE BEGIN
              numerator = TOTAL(maximus.width_time[plot_i_list[i]])
           ENDELSE
           denominator = TOTAL(fastLoc_delta_t[fastLocInterped_i_list[i]])
           probOcc     = [probOcc,numerator/denominator]
        ENDFOR
        probOccList.add,probOcc
     ENDFOR
  ENDFOR

  xRange    = [delayArr[0],delayArr[-1]]/60.
  yRangeMin = MIN(LIST_TO_1DARRAY(probOccList,/SKIP_NEG1_ELEMENTS,/WARN),MAX=yRangeMax)

  IF KEYWORD_SET(byMin) THEN BEGIN
     byMinStr       = (KEYWORD_SET(do_abs_byMin) ? "|" : "") + "B!Dy!N min" + (KEYWORD_SET(do_abs_byMin) ? "|" : "") $
                      + ": " + STRCOMPRESS(byMin,/REMOVE_ALL) + " nT" $
                      + (KEYWORD_SET(byMax) OR KEYWORD_SET(bzMin) OR KEYWORD_SET(bzMax) ? ", " : "")
  ENDIF ELSE byMinStr = ""

  IF KEYWORD_SET(byMax) THEN BEGIN
     byMaxStr       = " " + (KEYWORD_SET(do_abs_byMax) ? "|" : "") + "B!Dy!N max" + (KEYWORD_SET(do_abs_byMax) ? "|" : "") $
                      + ": " + STRCOMPRESS(byMax,/REMOVE_ALL) + " nT" $
                      + (KEYWORD_SET(bzMin) OR KEYWORD_SET(bzMax) ? ", " : "")
  ENDIF ELSE byMaxStr = ""

  IF KEYWORD_SET(bzMin) THEN BEGIN
     bzMinStr       = " " + (KEYWORD_SET(do_abs_bzMin) ? "|" : "") + "B!Dy!N min" + (KEYWORD_SET(do_abs_bzMin) ? "|" : "") $
                      + ": " + STRCOMPRESS(bzMin,/REMOVE_ALL) + " nT" $
                      + (KEYWORD_SET(bzMax) ? ", " : "")
  ENDIF ELSE bzMinStr = ""

  IF KEYWORD_SET(bzMax) THEN BEGIN
     bzMaxStr       = " " + (KEYWORD_SET(do_abs_bzMax) ? "|" : "") + "B!Dy!N max" + (KEYWORD_SET(do_abs_bzMax) ? "|" : "") $
                      + ": " + STRCOMPRESS(bzMax,/REMOVE_ALL) + " nT"
  ENDIF ELSE bzMaxStr = ""

  winTitle = byMinStr + byMaxStr + bzMinStr + bzMaxStr

  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(clockStr), $
                      NPLOTROWS=N_ELEMENTS(cell)-1+KEYWORD_SET(do_center_cell), $
                      COLUMN_NAMES=clockStr, $
                      ROW_NAMES=cell[0:1+KEYWORD_SET(do_center_cell)], $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.04, $
                      SPACE_FOR_ROW_NAMES=0.05, $
                      SPACE_FOR_COLUMN_NAMES=0.05, $
                      WINDOW_TITLE=winTitle, $
                      XTITLE='Delay (min)', $
                      YTITLE='Probability of Occurrence', $
                      CURRENT_WINDOW=window,/MAKE_NEW
  
  FOR i=0,N_ELEMENTS(probOccList)-1 DO BEGIN
     delPoints = (delayArr-delayDeltaSec/2.+binOffset_delay)/60.
     plot      = PLOT(delPoints,probOccList[i], $
                      ;; TITLE=title_list[i], $
                      XRANGE=xRange, $
                      YRANGE=[yRangeMin,yRangeMax], $
                      /HISTOGRAM, $
                      CURRENT=window, $
                      POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))
  ENDFOR

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY

  delayStr = "--n_delays__"+STRCOMPRESS(nDelays,/REMOVE_ALL) + "--delay_delta_" + STRCOMPRESS(delayDeltaSec,/REMOVE_ALL) + "sec"
  IF N_ELEMENTS(delay_res) GT 0 THEN delayResStr = STRING(FORMAT='("__",F0.2,"Res")',delay_res/60.) ELSE delayResStr = ""
  IF N_ELEMENTS(binOffset_delay) GT 0 THEN delBinOffStr = STRING(FORMAT='("__",F0.2,"binOffset")',binOffset_delay/60.) ELSE delBinOffStr = ""
  delayStr = delayStr + delayResStr + delBinOffStr

  stormStr = (KEYWORD_SET(nonstorm) ? "--nonstorm" : "") + $
             (KEYWORD_SET(mainPhase) ? "--mainPhase" : "") + $
             (KEYWORD_SET(recoveryPhase) ? "--recoveryPhase" : "")
  IF KEYWORD_SET(nonstorm) OR KEYWORD_SET(mainPhase) OR KEYWORD_SET(recoveryPhase) THEN BEGIN
     stormStr = stormStr + "__dstCutoff_" + STRCOMPRESS(dstCutoff,/REMOVE_ALL) + "nT"
  ENDIF

  outPlot = outPlot_pref + hemi + stormStr + delayStr+"--" + omni_paramStr + '.png'
  PRINT,'saving ' + outPlot
  window.save,plotDir+outPlot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now cross-correlation analysis
  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(clockStr), $
                      NPLOTROWS=1, $
                      COLUMN_NAMES=clockStr, $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.04, $
                      SPACE_FOR_ROW_NAMES=0.05, $
                      SPACE_FOR_COLUMN_NAMES=0.05, $
                      XTITLE='N Lags ($\Delta$Lag = ' + STRCOMPRESS((delayArr[1]-delayArr[0])/60.,/REMOVE_ALL) + ' min)', $
                      YTITLE='Cross correlation', $
                      CURRENT_WINDOW=window_cc, $
                      /MAKE_NEW

  lags          = INDGEN(nDelays-2)-(nDelays-2)/2
  dawnward_ccor = C_CORRELATE(probOccList[0],probOccList[1],lags)
  duskward_ccor = C_CORRELATE(probOccList[2+KEYWORD_SET(do_center_cell)],probOccList[3+KEYWORD_SET(do_center_cell)],lags)

     plot  = PLOT(lags,dawnward_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([dawnward_ccor,duskward_ccor]),MAX([dawnward_ccor,duskward_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))
  
     plot  = PLOT(lags,duskward_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([dawnward_ccor,duskward_ccor]),MAX([dawnward_ccor,duskward_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))


     outPlot_CC= crossCorr_pref +hemi+delayStr+"--"+omni_paramStr+'.png'
     PRINT,'saving ' + outPlot_CC
     window_cc.save,plotDir+outPlot_CC

     outFile_dat = crossCorr_pref+hemi+delayStr+"--"+omni_paramStr+'.sav'

     IF ~FILE_TEST(outFile_dir) THEN SPAWN,'mkdir ' + outFile_dir
     save,probOccList,delayArr,nDelays,delayDeltaSec, $
          title_list, $
          lags,duskward_ccor,dawnward_ccor, $
          omni_paramStr,clockStr, $
          cell, $
          do_center_cell, $
          hemi,minMLT,maxMLT,minILAT,maxILAT, $
          FILENAME=outFile_dir+outFile_dat

END

