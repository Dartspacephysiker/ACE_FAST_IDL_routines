;2016/03/21 Can you show me what it's all about?
PRO JOURNAL__20160322__SMOOTH_THE_SMOOTHED_NEV_PER_ORB_DATA__THEN_PLOT

  nSmooths          = 16
  nSmoothPoints     = 32
  ;; hemi              = 'NORTH'
  hemi              = 'SOUTH'
  omniParamStr      = 'OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00--bzMax_-1.00.sav'
  ;; omniParamStr      = 'OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00.sav'

  inDir             = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/journals/journal__20160322__nev_per_orb_and_crosscorrelation_savefiles'
  inFile            = 'journal__20160322__CrossCorr_nev_per_orb_vs_delay--'+hemi+'--n_delays__4001--' + $
                      omniParamStr

  smoothStr       = STRCOMPRESS(nSmooths,/REMOVE_ALL) + "_smooths--"
  smoothNiceStr   = STRCOMPRESS(nSmooths,/REMOVE_ALL) + " Smooths ("+hemi+")"
  smoothedNEvList = LIST()

  RESTORE,inDir+'/'+inFile

  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(clockStr), $
                      NPLOTROWS=N_ELEMENTS(cell), $
                      COLUMN_NAMES=clockStr, $
                      ROW_NAMES=cell, $
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
  outPlot = "journal__20160322__plot_nev_per_orb_vs_delay--"+smoothStr $
            + hemi + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL)+"--" + omni_paramStr+'.png'
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
  duskward_ccor = C_CORRELATE(smoothedNEvList[2],smoothedNEvList[3],lags)

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


     outPlot_CC="journal__20160322__CrossCorr_nev_per_orb_vs_delay--" + smoothStr $
                + hemi + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL)+"--" + omni_paramStr + '.png'
     PRINT,'saving ' + outPlot_CC
     window_cc.save,plotDir+outPlot_CC


END
