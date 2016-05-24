;2016/03/31 Now do it with probOccurrence stuff
PRO JOURNAL__20160331__RESAMPLE_AND_PLOT_PROBOCCURRENCE_CELL_DATA

  do_smooth              = 1
  nSmooths               = 1
  nSmoothPoints          = 60

  nDelays                = 4001
  delayDeltaSec          = 60

  resampFactor           = 10
  newNDelays             = nDelays/resampFactor
  newRes_in_min          = delayDeltaSec*resampFactor/60.

  do_crossCorr_plots     = 0

  hemi                   = 'NORTH'
  ;; hemi              = 'SOUTH'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;BzNorth/South
  ;; omniParamStr           = '--OMNI_params--bzSouth--negAngle_135__posAngle_-135--ABS_byMax_5.00--ABS_bzMin_5.00.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;duskward/dawnward
  ;; omniParamStr      = '--OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00--bzMin_1.00.sav'
  omniParamStr      = '--OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00--bzMax_-1.00.sav'

  crossCorrStr           = "journal__20160330__CrossCorr_probOccurrence_vs_delay--all_alts--"
  plotPrefStr            = "journal__20160330__plot_probOccurrence_vs_delay--all_alts--"
  delayStr               = "--n_delays__"+STRCOMPRESS(nDelays,/REMOVE_ALL) + "--delay_delta_" + STRCOMPRESS(delayDeltaSec,/REMOVE_ALL) + "sec"
                         
  inDir                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/journals/journal__20160330__probOccurrence_and_crosscorrelation_savefiles'
  inFile                 = crossCorrStr + hemi + delayStr + omniParamStr

  ;; resampStr              = STRING(FORMAT='("factor-of-",F0.2,"_resampling")',resampFactor)
  ;; resampNiceStr          = STRING(FORMAT='("Resample factor: ",F0.2)',resampFactor)
  resampStr              = STRING(FORMAT='("resampled_to_",F0.2,"min_res")',newRes_in_min)
  resampNiceStr          = STRING(FORMAT='("Resampled resolution: ",F0.2," min")',newRes_in_min)

  IF KEYWORD_SET(do_smooth) THEN BEGIN
     IF nSmooths EQ 1 THEN singplur = 'smooth' ELSE singplur = 'smooths'
     smoothStr           = STRCOMPRESS(nSmooths,/REMOVE_ALL) + "_" + STRCOMPRESS(nSmoothPoints,/REMOVE_ALL) + "-point_"+singplur+"--"
     smoothNiceStr       = STRCOMPRESS(nSmooths,/REMOVE_ALL) + " " + STRCOMPRESS(nSmoothPoints,/REMOVE_ALL) + "-point "+singplur+" ("+hemi+")"
     
     resampStr           = smoothStr + resampStr
     resampNiceStr       = smoothNiceStr + ", " + resampNiceStr
  ENDIF

  smoothedProbOccList    = LIST()

  RESTORE,inDir+'/'+inFile

  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(clockStr), $
                      NPLOTROWS=N_ELEMENTS(cell)-1+KEYWORD_SET(do_center_cell), $
                      COLUMN_NAMES=clockStr, $
                      ROW_NAMES=cell[0:1+KEYWORD_SET(do_center_cell)], $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.04, $
                      SPACE_FOR_ROW_NAMES=0.05, $
                      SPACE_FOR_COLUMN_NAMES=0.05, $
                      XTITLE='Delay (min)', $
                      YTITLE='Probability of Occurrence', $
                      WINDOW_TITLE=resampNiceStr, $
                      CURRENT_WINDOW=window
  
  FOR i=0,N_ELEMENTS(probOccList)-1 DO BEGIN
     smoothedProbOccList.add,probOccList[i]

     IF KEYWORD_SET(do_smooth) THEN BEGIN
        smooths                = 0
        WHILE smooths LE nSmooths-1 DO BEGIN
           smoothedProbOccList[i] = SMOOTH(smoothedProbOccList[i],nSmoothPoints,/EDGE_TRUNCATE)
           smooths++
        ENDWHILE
     ENDIF

     smoothedProbOccList[i]    = CONGRID(smoothedProbOccList[i],newNDelays,/CENTER)

  ENDFOR

  delayArr             = CONGRID(delayArr,newNDelays,/CENTER)

  xRange               = [delayArr[0],delayArr[-1]]/60.
  yRangeMin            = MIN(LIST_TO_1DARRAY(smoothedProbOccList,/SKIP_NEG1_ELEMENTS,/WARN),MAX=yRangeMax)

  FOR i=0,N_ELEMENTS(probOccList)-1 DO BEGIN
     plot              = PLOT(delayArr/60.,smoothedProbOccList[i], $
                              ;; TITLE=title_list[i], $
                              XRANGE=xRange, $
                              YRANGE=[yRangeMin,yRangeMax], $
                              ;; /HISTOGRAM, $
                              ;; XSHOWTEXT=0, $
                              ;; YSHOWTEXT=0, $
                              CURRENT=window, $
                              POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))
  ENDFOR
  
  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  outPlot = plotPrefStr + resampStr + hemi + delayStr + omni_paramStr+'.png'
  PRINT,'saving ' + outPlot
  window.save,plotDir+outPlot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now cross-correlation analysis
  IF KEYWORD_SET(do_crossCorr_plots) THEN BEGIN
     WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(clockStr), $
                         NPLOTROWS=1, $
                         COLUMN_NAMES=clockStr, $
                         SPACE_HORIZ_BETWEEN_COLS=0.08, $
                         SPACE_VERT_BETWEEN_ROWS=0.04, $
                         SPACE_FOR_ROW_NAMES=0.05, $
                         SPACE_FOR_COLUMN_NAMES=0.05, $
                         XTITLE='N Lags ($\Delta$Lag = ' + STRCOMPRESS((delayArr[1]-delayArr[0])/60.,/REMOVE_ALL) + ' min)', $
                         YTITLE='Cross correlation', $
                         WINDOW_TITLE=resampNiceStr, $
                         CURRENT_WINDOW=window_cc, $
                         /MAKE_NEW

     lags          = INDGEN(nDelays-2)-(nDelays-2)/2
     dawnward_ccor = C_CORRELATE(smoothedProbOccList[0],smoothedProbOccList[1],lags)
     duskward_ccor = C_CORRELATE(smoothedProbOccList[2+KEYWORD_SET(do_center_cell)],smoothedProbOccList[3+KEYWORD_SET(do_center_cell)],lags)

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


     outPlot_CC = crossCorrStr + resampStr $
                  + hemi + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL) + omni_paramStr + '.png'
     PRINT,'saving ' + outPlot_CC
     window_cc.save,plotDir+outPlot_CC
  ENDIF

END
