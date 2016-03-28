;2016/03/28 Maybe final, based on my best estimates of what's happening in each cell
PRO JOURNAL__20160328__SMOOTH_AND_PLOT_NEV_PER_ORB_DATA

  nSmooths          = 16
  nSmoothPoints     = 16

  nDelays           = 4001
  delayDeltaSec     = 15

  ;; hemi              = 'NORTH'
  hemi              = 'SOUTH'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;BzNorth/South
  ;; omniParamStr      = '--OMNI_params--bzSouth--negAngle_-135__posAngle_135--ABS_byMax_5.00--ABS_bzMin_5.00.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;duskward/dawnward
  ;; omniParamStr      = '--OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00--bzMin_1.00.sav'
  omniParamStr      = '--OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00--bzMax_-1.00.sav'
  ;; omniParamStr      = '--OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00.sav'

  crossCorrStr      = "journal__20160328__CrossCorr_nev_per_orb_vs_delay--"
  plotPrefStr       = "journal__20160328__plot_nev_per_orb_vs_delay--"
  delayStr          = "--n_delays__"+STRCOMPRESS(nDelays,/REMOVE_ALL) + "--delay_delta_" + STRCOMPRESS(delayDeltaSec,/REMOVE_ALL) + "sec"

  inDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/journals/journal__20160328__nev_per_orb_and_crosscorrelation_savefiles'
  inFile            = crossCorrStr + hemi + delayStr + omniParamStr

  smoothStr       = STRCOMPRESS(nSmooths,/REMOVE_ALL) + "_" + STRCOMPRESS(nSmoothPoints,/REMOVE_ALL) + "-point_smooths--"
  smoothNiceStr   = STRCOMPRESS(nSmooths,/REMOVE_ALL) + " " + STRCOMPRESS(nSmoothPoints,/REMOVE_ALL) + "-point Smooths ("+hemi+")"
  smoothedNEvList = LIST()

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
                      YTITLE='N Events', $
                      WINDOW_TITLE=smoothNiceStr, $
                      CURRENT_WINDOW=window
  
  FOR i=0,N_ELEMENTS(nEvArrList)-1 DO BEGIN
     smoothedNEvList.add,nEvArrList[i]

     smooths      = 0
     WHILE smooths LE nSmooths-1 DO BEGIN
        smoothedNEvList[i] = SMOOTH(smoothedNEvList[i],nSmoothPoints,/EDGE_TRUNCATE)
        smooths++
     ENDWHILE
  ENDFOR

  xRange           = [delayArr[0],delayArr[-1]]/60.
  yRangeMin        = MIN(LIST_TO_1DARRAY(smoothedNEvList,/SKIP_NEG1_ELEMENTS,/WARN),MAX=yRangeMax)

  FOR i=0,N_ELEMENTS(nEvArrList)-1 DO BEGIN
     plot          = PLOT(delayArr/60.,smoothedNEvList[i], $
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
  outPlot = plotPrefStr + smoothStr + hemi + delayStr + omni_paramStr+'.png'
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
                      WINDOW_TITLE=smoothNiceStr, $
                      CURRENT_WINDOW=window_cc, $
                      /MAKE_NEW

  lags          = INDGEN(nDelays-2)-(nDelays-2)/2
  dawnward_ccor = C_CORRELATE(smoothedNEvList[0],smoothedNEvList[1],lags)
  duskward_ccor = C_CORRELATE(smoothedNEvList[2+KEYWORD_SET(do_center_cell)],smoothedNEvList[3+KEYWORD_SET(do_center_cell)],lags)

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


     outPlot_CC = crossCorrStr + smoothStr $
                + hemi + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL) + omni_paramStr + '.png'
     PRINT,'saving ' + outPlot_CC
     window_cc.save,plotDir+outPlot_CC


END
