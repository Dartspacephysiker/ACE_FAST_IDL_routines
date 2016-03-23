;2016/03/23 Using those "informed" cell locations
PRO JOURNAL__20160323__CROSS_CORRELATE_CONJUGATE_CELLS_IN_EACH_HEMISPHERE

  nSmooths          = 4
  nSmoothPoints     = 16
  hemiArr           = ['NORTH','SOUTH']

  omniParamStr      = 'OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00--bzMax_-1.00.sav'
  ;; omniParamStr      = 'OMNI_params--duskward--negAngle_45__posAngle_135--ABS_byMin_5.00.sav'

  inDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/journals/journal__20160323__nev_per_orb_and_crosscorrelation_savefiles'
  inFile            = 'journal__20160323__CrossCorr_nev_per_orb_vs_delay--'+hemiArr+'--n_delays__4001--' + $
                      omniParamStr

  smoothStr         = STRCOMPRESS(nSmooths,/REMOVE_ALL) + "_" + STRCOMPRESS(nSmoothPoints,/REMOVE_ALL) + "-point_smooths--"
  smoothNiceStr     = STRCOMPRESS(nSmooths,/REMOVE_ALL) + " " + STRCOMPRESS(nSmoothPoints,/REMOVE_ALL) + "-point Smooths ("+hemi+")"

  nEvArrList_hemis     = LIST()
  smoothNEvList_hemis  = LIST()
  delayArrList_hemis   = LIST()
  lagList_hemis        = LIST()
  clockStrList         = LIST()
  hemiList             = LIST()
  omni_paramStrList    = LIST()
  title_list_hemis     = LIST()
  nDelayArr            = !NULL
  FOR i=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
     RESTORE,inDir+'/'+inFile[i]

     smoothedNEvList   = LIST()
     FOR nEv_i=0,N_ELEMENTS(nEvArrList)-1 DO BEGIN
        smoothedNEvList.add,nEvArrList[nEv_i]
        
        smooths      = 0
        WHILE smooths LE nSmooths-1 DO BEGIN
           smoothedNEvList[nEv_i] = SMOOTH(smoothedNEvList[nEv_i],nSmoothPoints,/EDGE_TRUNCATE)
           smooths++
        ENDWHILE
     ENDFOR

     nEvArrList_hemis.add,nEvArrList
     smoothNEvList_hemis.add,smoothedNEvList
     delayArrList_hemis.add,delayArr
     lagList_hemis.add,lags
     clockStrList.add,clockStr
     hemiList.add,hemi
     omni_paramStrList.add,omniParamStr
     title_list_hemis.add,title_list
     nDelayArr         = [nDelayArr,nDelays]
  ENDFOR

  IF nDelayArr[0] NE nDelayArr[1] THEN BEGIN
     PRINT,'nDelayArr elems not equal!'
     STOP
  ENDIF

  IF ~ARRAY_EQUAL(lagList_hemis[0],lagList_hemis[1]) THEN BEGIN
     PRINT,'Lag lists not equal!'
     STOP
  ENDIF

  ;;index 1: hemi (0=NORTH, 1=SOUTH)
  ;;index 2: IMF orientation and cell [0=(dawnward, dawn cell), 1=(dawnward, dusk cell), 
  ;;                                   2=(duskward, dawn cell), 3=(duskward, dusk cell)]
  dawnward_alfvenic_list   = LIST(smoothNEvList_hemis[0,1],smoothNEvList_hemis[1,0])
  dawnward_particle_list   = LIST(smoothNEvList_hemis[0,0],smoothNEvList_hemis[1,1])

  duskward_alfvenic_list   = LIST(smoothNEvList_hemis[0,2+KEYWORD_SET(do_center_cell)],smoothNEvList_hemis[1,3+KEYWORD_SET(do_center_cell)])
  duskward_particle_list   = LIST(smoothNEvList_hemis[0,3+KEYWORD_SET(do_center_cell)],smoothNEvList_hemis[1,2+KEYWORD_SET(do_center_cell)])

  ;;titles to make sure we're not screwing up
  dawnward_alfvenic_titles = [title_list_hemis[0,1],title_list_hemis[1,0]]
  dawnward_particle_titles = [title_list_hemis[0,0],title_list_hemis[1,1]]

  duskward_alfvenic_titles = [title_list_hemis[0,2+KEYWORD_SET(do_center_cell)],title_list_hemis[1,3+KEYWORD_SET(do_center_cell)]]
  duskward_particle_titles = [title_list_hemis[0,3+KEYWORD_SET(do_center_cell)],title_list_hemis[1,2+KEYWORD_SET(do_center_cell)]]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DAWNWARD IMF STUFF
  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(cell), $
                      NPLOTROWS=N_ELEMENTS(hemiArr), $
                      COLUMN_NAMES=['Alfvenic','Particle'], $
                      ROW_NAMES=hemiArr, $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.06, $
                      SPACE_FOR_ROW_NAMES=0.03, $
                      SPACE_FOR_COLUMN_NAMES=0.07, $
                      XTITLE='Delay (min)', $
                      YTITLE='N Events per Orbit', $
                      WINDOW_TITLE='Dawnward IMF, ' + smoothNiceStr, $
                      CURRENT_WINDOW=window


  xRange           = [delayArr[0],delayArr[-1]]/60.
  yRangeMin        = MIN([LIST_TO_1DARRAY(dawnward_alfvenic_list,/SKIP_NEG1_ELEMENTS,/WARN), $
                          LIST_TO_1DARRAY(dawnward_particle_list,/SKIP_NEG1_ELEMENTS,/WARN)],MAX=yRangeMax)

  FOR i=0,N_ELEMENTS(dawnward_alfvenic_list)-1 DO BEGIN
     plot          = PLOT(delayArr/60.,dawnward_alfvenic_list[i], $
                          TITLE=dawnward_alfvenic_titles[i], $
                          XRANGE=xRange, $
                          YRANGE=[yRangeMin,yRangeMax], $
                          CURRENT=window, $
                          POSITION=WINDOW_CUSTOM_NEXT_POS())

     plot          = PLOT(delayArr/60.,dawnward_particle_list[i], $
                          TITLE=dawnward_particle_titles[i], $
                          XRANGE=xRange, $
                          YRANGE=[yRangeMin,yRangeMax], $
                          CURRENT=window, $
                          POSITION=WINDOW_CUSTOM_NEXT_POS())
  ENDFOR

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  outPlot = "journal__20160323--DAWNWARD_IMF--Alfvenic_and_particle--"+smoothStr $
            + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL)+"--" + omni_paramStr+'.png'
  PRINT,'saving ' + outPlot
  window.save,plotDir+outPlot


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DUSKWARD IMF STUFF
  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(cell), $
                      NPLOTROWS=N_ELEMENTS(hemiArr), $
                      COLUMN_NAMES=['Alfvenic','Particle'], $
                      ROW_NAMES=hemiArr, $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.06, $
                      SPACE_FOR_ROW_NAMES=0.03, $
                      SPACE_FOR_COLUMN_NAMES=0.07, $
                      XTITLE='Delay (min)', $
                      YTITLE='N Events per Orbit', $
                      WINDOW_TITLE='Duskward IMF, ' + smoothNiceStr, $
                      CURRENT_WINDOW=window


  xRange           = [delayArr[0],delayArr[-1]]/60.
  yRangeMin        = MIN([LIST_TO_1DARRAY(duskward_alfvenic_list,/SKIP_NEG1_ELEMENTS,/WARN), $
                          LIST_TO_1DARRAY(duskward_particle_list,/SKIP_NEG1_ELEMENTS,/WARN)],MAX=yRangeMax)

  FOR i=0,N_ELEMENTS(duskward_alfvenic_list)-1 DO BEGIN
     plot          = PLOT(delayArr/60.,duskward_alfvenic_list[i], $
                          TITLE=duskward_alfvenic_titles[i], $
                          XRANGE=xRange, $
                          YRANGE=[yRangeMin,yRangeMax], $
                          CURRENT=window, $
                          POSITION=WINDOW_CUSTOM_NEXT_POS())

     plot          = PLOT(delayArr/60.,duskward_particle_list[i], $
                          TITLE=duskward_particle_titles[i], $
                          XRANGE=xRange, $
                          YRANGE=[yRangeMin,yRangeMax], $
                          CURRENT=window, $
                          POSITION=WINDOW_CUSTOM_NEXT_POS())
  ENDFOR

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  outPlot = "journal__20160323--DUSKWARD_IMF--Alfvenic_and_particle--"+smoothStr $
            + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL)+"--" + omni_paramStr+'.png'
  PRINT,'saving ' + outPlot
  window.save,plotDir+outPlot



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now cross-correlation analysis
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DAWNWARD CROSS-CORR
  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(cell), $
                      COLUMN_NAMES=['Alfvenic','Particle'], $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.06, $
                      SPACE_FOR_ROW_NAMES=0.03, $
                      SPACE_FOR_COLUMN_NAMES=0.07, $
                      XTITLE='N Lags ($\Delta$Lag = ' + STRCOMPRESS((delayArr[1]-delayArr[0])/60.,/REMOVE_ALL) + ' min)', $
                      YTITLE='Cross correlation', $
                      WINDOW_TITLE='Dawnward IMF, ' + smoothNiceStr, $
                      CURRENT_WINDOW=window_cc, $
                      /MAKE_NEW

  lags                   = INDGEN(nDelays-2)-(nDelays-2)/2
  dawnward_alfvenic_ccor = C_CORRELATE(dawnward_alfvenic_list[0],dawnward_alfvenic_list[1],lags)
  dawnward_particle_ccor = C_CORRELATE(dawnward_particle_list[0],dawnward_particle_list[1],lags)

     plot  = PLOT(lags,dawnward_alfvenic_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([dawnward_alfvenic_ccor,dawnward_particle_ccor]),MAX([dawnward_alfvenic_ccor,dawnward_particle_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS())
  
     plot  = PLOT(lags,dawnward_particle_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([dawnward_alfvenic_ccor,dawnward_particle_ccor]),MAX([dawnward_alfvenic_ccor,dawnward_particle_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS())


     outPlot_CC="journal__20160323--DAWNWARD_IMF--Alfvenic_and_particle_hemi_CrossCor--" + smoothStr $
                + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL)+"--" + omni_paramStr + '.png'
     PRINT,'saving ' + outPlot_CC
     window_cc.save,plotDir+outPlot_CC

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DUSKWARD CROSS-CORR
  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(cell), $
                      COLUMN_NAMES=['Alfvenic','Particle'], $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.06, $
                      SPACE_FOR_ROW_NAMES=0.03, $
                      SPACE_FOR_COLUMN_NAMES=0.07, $
                      XTITLE='N Lags ($\Delta$Lag = ' + STRCOMPRESS((delayArr[1]-delayArr[0])/60.,/REMOVE_ALL) + ' min)', $
                      YTITLE='Cross correlation', $
                      WINDOW_TITLE='Duskward IMF, ' + smoothNiceStr, $
                      CURRENT_WINDOW=window_cc, $
                      /MAKE_NEW

  lags                   = INDGEN(nDelays-2)-(nDelays-2)/2
  duskward_alfvenic_ccor = C_CORRELATE(duskward_alfvenic_list[0],duskward_alfvenic_list[1],lags)
  duskward_particle_ccor = C_CORRELATE(duskward_particle_list[0],duskward_particle_list[1],lags)

     plot  = PLOT(lags,duskward_alfvenic_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([duskward_alfvenic_ccor,duskward_particle_ccor]),MAX([duskward_alfvenic_ccor,duskward_particle_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS())
  
     plot  = PLOT(lags,duskward_particle_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([duskward_alfvenic_ccor,duskward_particle_ccor]),MAX([duskward_alfvenic_ccor,duskward_particle_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS())


     outPlot_CC="journal__20160323--DUSKWARD_IMF--Alfvenic_and_particle_hemi_CrossCor--" + smoothStr $
                + "--n_delays__" + STRCOMPRESS(nDelays,/REMOVE_ALL)+"--" + omni_paramStr + '.png'
     PRINT,'saving ' + outPlot_CC
     window_cc.save,plotDir+outPlot_CC

END
