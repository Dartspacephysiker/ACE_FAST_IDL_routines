;+
; NAME:                     PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_AND_DUSK_CELL_IN_NORTHERN_AND_SOUTHERN_HEMI__SINGLE_WINDOW
;
;
;
; PURPOSE:                  Plot those figures of merit!
;
;
;
; CATEGORY:                 ACE_FAST, IMF control of Alfvénic cusp
;
; CALLING SEQUENCE:
;
; INPUTS:
;
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:     2016/02/013 Barnebarn
;
;-
PRO PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_AND_DUSK_CELL_IN_NORTHERN_AND_SOUTHERN_HEMI__SINGLE_WINDOW, $
   HEMI=hemi, $
   ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
   INCLUDE_ALLIMF=include_allIMF, $
   FILEDAY=fileDia, $
   FOM_TYPE=fom_type, $
   H2DFILEDIR=h2dFileDir, $
   COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
   PLOTYRANGE=plotYRange, $
   AUTO_ADJUST_YRANGE=auto_adjust_yRange, $
   DETREND_WINDOW=detrend_window, $
   SCALE_PLOTS_TO_1=scale_plots_to_1, $
   SAVEPLOTS=savePlots, $
   SPNAME=spName, $
   LUN=lun

  ;PLOT STUFF
  winArr                                   = MAKE_ARRAY(1,/OBJ)
  winArr[0]                                = WINDOW(WINDOW_TITLE='Figure of merit, combined dawn and dusk', $
                                                    DIMENSIONS=[1200,800])
  legendArr                                = MAKE_ARRAY(1,/OBJ)
  plotArr                                  = MAKE_ARRAY(2,3,2,/OBJ)

  topMargin                                = [0.09,0.01,0.03,0.14]
  middleMargin                             = [0.09,0.075,0.03,0.075]
  bottomMargin                             = [0.09,0.14,0.03,0.01]
  margins                                  = [[topMargin],[middleMargin],[bottomMargin]]

  cellArr=['DAWN','DUSK']

  FOR k=0,1 DO BEGIN

     retVal = FIGURE_OF_MERIT_III_IV_V__PLOT_SETUP(HEMI=hemi, $
                                                   ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
                                                   INCLUDE_ALLIMF=include_allIMF, $
                                                   ;; DETREND_WINDOW=detrend_window, $
                                                   FILEDAY=fileDia, $
                                                   FOM_TYPE=fom_type, $
                                                   FOMTYPESTR=fomTypeStr, $
                                                   COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
                                                   CELL_TO_PLOT=cellArr[k], $
                                                   H2DFILEDIR=h2dFileDir, $
                                                   NWINDOWS=nWindows, $
                                                   PLOTSPERWINDOW=plotsPerWindow, $
                                                   PLOTTITLE=plotTitle, $
                                                   PLOTHEMISTR=plotHemiStr, $
                                                   PLOTYRANGE=plotYRange, $
                                                   AUTO_ADJUST_YRANGE=auto_adjust_yRange, $
                                                   PLOTCOLOR=plotColor, $
                                                   SCALE_PLOTS_TO_1=scale_plots_to_1, $
                                                   CELLSTR=cellStr, $
                                                   IMFCORTSTR=IMFCortStr, $
                                                   DATARR=datArr, $
                                                   DELAYLIST=delayList, $
                                                   LUN=lun)

     IF retVal EQ -1 THEN BEGIN
        PRINT,"Couldn't set up FOM plot! Exiting ..."
        RETURN
     ENDIF
     
     ;;i indexes IMF direction
     ;;j indexes hemisphere
     xRange                                   = [MIN((delayList[0])[0]),MAX((delayList[0])[0])]
     FOR i=0,nWindows-1 DO BEGIN
        
        IF KEYWORD_SET(auto_adjust_yRange) THEN BEGIN
           yMin                               = !NULL
           yMax                               = !NULL
           FOR j=0,plotsPerWindow-1 DO BEGIN
              tempMin                         = MIN((datArr[j])[i])
              IF N_ELEMENTS(yMin) EQ 0 THEN BEGIN
                 yMin                         = tempMin
              ENDIF ELSE BEGIN
                 yMin                         = yMin < tempMin
              ENDELSE

              tempMax                         = MAX((datArr[j])[i])
              IF N_ELEMENTS(yMax) EQ 0 THEN BEGIN
                 yMax                         = tempMax
              ENDIF ELSE BEGIN
                 yMax                         = yMax > tempMax
              ENDELSE
           ENDFOR
           plotYRange                         = [yMin,yMax]
        ENDIF

        plotLayout                            = [2,nWindows,i*2+k+1]
        ;; print,plotLayout
        FOR j=0,plotsPerWindow-1 DO BEGIN
           delays                             = (delayList[j])[i]

           maxDat                             = MAX((datArr[j])[i],MIN=minDat)
           
           PRINTF,lun,FORMAT='("Max, min (",A0,", ",A0,")",T40,G0.4,T55,G0.4)', $
                  IMFCortStr[i],plotHemiStr[j],maxDat,minDat

           xShowLabel                         = (i EQ nWindows-1)

        IF KEYWORD_SET(detrend_window) THEN BEGIN
           delays                          = (delayList[j])[i]
           delays_trimmed                  = !NULL
           data_trend                      = RUNNING_AVERAGE(delays,(datArr[j])[i],detrend_window, $
                                                             BIN_CENTERS=delays_trimmed, $
                                                             /DROP_EDGES)
           delays                          = delays_trimmed
           data_detrended                  = (datArr[j])[i] - data_trend
        ENDIF ELSE BEGIN
           delays                          = (delayList[j])[i]
           data_detrended                  = (datArr[j])[i]
        ENDELSE

           IF KEYWORD_SET(scale_plots_to_1) THEN BEGIN
              ;; minData                            = MIN((datArr[j])[i],MAX=maxData)
              ;; dataRange                          = maxData-minData
              ;; dataMid                            = (maxData+minData)/2.D
              ;; dataMid                            = MEAN((datArr[j])[i])
              ;; data                               = ((datArr[j])[i]-dataMid)/dataRange*2.D
              
           IF ~KEYWORD_SET(detrend_window) THEN BEGIN
              dataMid                            = MEAN((datArr[j])[i])
              data                               = (datArr[j])[i]-dataMid
              minData                            = MIN((datArr[j])[i],MAX=maxData)
              dataRange                          = maxData-minData
              dataMid                            = (maxData+minData)/2.D
              data                               = ((datArr[j])[i]-dataMid)/dataRange*2.D
           ENDIF ELSE BEGIN
              ;; dataMid                            = MEAN(data_detrended)
              ;; data                               = data_detrended-dataMid
              minData                            = MIN(data_detrended,MAX=maxData)
              dataRange                          = maxData-minData
              dataMid                            = (maxData+minData)/2.D
              data                               = (data_detrended-dataMid)/dataRange*2.D
           ENDELSE

           ENDIF ELSE BEGIN
              data                               = (datArr[j])[i]
           ENDELSE
           
           plotArr[k,i,j]                     = PLOT(delays,data, $
                                                     TITLE=(i GT 0) ? !NULL : 'Figure of merit ' + FOMTypeStr + ': ' + cellStr, $ ; plotTitle[0], $
                                                     XSHOWTEXT=xShowLabel, $
                                                     ;; AXIS_STYLE=(i EQ nWindows-1) ? 1 : !NULL, $
                                                     XTITLE=(i EQ nWindows-1) ? 'Delay between magnetopause and cusp observation (min)' : !NULL, $
                                                     XRANGE=xRange, $
                                                     YRANGE=plotYRange, $
                                                     YTITLE=IMFCortStr[i] + " FOM", $
                                                     NAME=plotHemiStr[j], $
                                                     OVERPLOT=(j GT 0), $
                                                     MARGIN=margins[*,i], $
                                                     COLOR=plotColor[j], $
                                                     LAYOUT=plotLayout, $
                                                     THICK=3.0, $
                                                     TRANSPARENCY=50, $
                                                     /CURRENT)
           
           
           IF xShowLabel THEN BEGIN
              ax                = plotArr[k,i,j].axes
              IF N_ELEMENTS(ax) GT 2 THEN BEGIN
                 ax[2].showText = 0
              ENDIF
           ENDIF
           
        ENDFOR
     ENDFOR
     
     IF k EQ 0 THEN BEGIN
        legendArr[0]                       = LEGEND(TARGET=plotArr[k,0,*], $
                                                    /NORMAL, $
                                                    POSITION=[0.9,0.6], $
                                                    FONT_SIZE=16, $
                                                    HORIZONTAL_ALIGNMENT=0.5, $
                                                    VERTICAL_SPACING=0.01, $
                                                    /AUTO_TEXT_COLOR)
     ENDIF
        

  ENDFOR
  
  IF KEYWORD_SET(savePlots) THEN BEGIN
     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/VERBOSE,/ADD_TODAY
     ;; IF ~KEYWORD_SET(spName) THEN BEGIN
     plotExt                        = '.png'
     spNFmt                         = '(A0,"--figure_of_merit_type",I1,"--",A0,A0)'
     spName                         = STRING(FORMAT=spNFmt,GET_TODAY_STRING(/DO_YYYYMMDD_FMT),fom_type, $
                                             'DAWN_AND_DUSK',plotExt) 
     ;; ENDIF
     PRINTF,lun,'Saving FOM plot to ' + spName + '...'
     winArr[0].save,plotDir+spName,RESOLUTION=defRes
  ENDIF


END