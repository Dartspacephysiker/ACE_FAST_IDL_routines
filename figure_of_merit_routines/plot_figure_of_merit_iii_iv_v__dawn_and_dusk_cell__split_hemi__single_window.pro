;+
; NAME:                     PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_AND_DUSK_CELL__SPLIT_HEMI__SINGLE_WINDOW
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
; MODIFICATION HISTORY:     2016/02/16 Barnebarn, Jim's behest
;
;-
PRO PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_AND_DUSK_CELL__SPLIT_HEMI__SINGLE_WINDOW, $
   HEMI=hemi, $
   ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
   ;; INCLUDE_ALLIMF=include_allIMF, $
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
  plotArr                                  = MAKE_ARRAY(2,2,2,/OBJ)

  topMargin                                = [0.12,0.01,0.03,0.12]
  bottomMargin                             = [0.12,0.14,0.03,0.01]
  margins                                  = [[topMargin],[bottomMargin]]

  cellArr=['DAWN','DUSK']

  ;;i indexes IMF direction
  ;;hemi_j indexes hemisphere
  ;;cell_k indexes cell
  FOR cell_k=0,1 DO BEGIN

     retVal = FIGURE_OF_MERIT_III_IV_V__SPLIT_HEMI__PLOT_SETUP(HEMI=hemi, $
                                                   ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
                                                   ;; INCLUDE_ALLIMF=include_allIMF, $
                                                   ;; DETREND_WINDOW=detrend_window, $
                                                   FILEDAY=fileDia, $
                                                   FOM_TYPE=fom_type, $
                                                   FOMTYPESTR=fomTypeStr, $
                                                   COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
                                                   CELL_TO_PLOT=cellArr[cell_k], $
                                                   H2DFILEDIR=h2dFileDir, $
                                                   NWINDOWS=nWindows, $
                                                   PLOTSPERWINDOW=plotsPerPanel, $
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
     
     xRange                                   = [MIN((delayList[0])[0]),MAX((delayList[0])[0])]
     FOR hemi_j=0,nWindows-1 DO BEGIN
        
        IF KEYWORD_SET(auto_adjust_yRange) THEN BEGIN
           yMin                               = !NULL
           yMax                               = !NULL
           FOR IMF_i=0,plotsPerPanel-1 DO BEGIN
              tempMin                         = MIN((datArr[hemi_j])[IMF_i])
              IF N_ELEMENTS(yMin) EQ 0 THEN BEGIN
                 yMin                         = tempMin
              ENDIF ELSE BEGIN
                 yMin                         = yMin < tempMin
              ENDELSE

              tempMax                         = MAX((datArr[hemi_j])[IMF_i])
              IF N_ELEMENTS(yMax) EQ 0 THEN BEGIN
                 yMax                         = tempMax
              ENDIF ELSE BEGIN
                 yMax                         = yMax > tempMax
              ENDELSE
           ENDFOR
           plotYRange                         = [yMin,yMax]
        ENDIF

        ;; plotLayout                            = [2,nWindows,IMF_i*2+cell_k+1]
        plotLayout                            = [2,nWindows,hemi_j*2+cell_k+1]
        FOR IMF_i=0,plotsPerPanel-1 DO BEGIN
           delays                             = (delayList[hemi_j])[IMF_i]

           maxDat                             = MAX((datArr[hemi_j])[IMF_i],MIN=minDat)
           
           PRINTF,lun,FORMAT='("Max, min (",A0,", ",A0,")",T40,G0.4,T55,G0.4)', $
                  IMFCortStr[IMF_i],plotHemiStr[hemi_j],maxDat,minDat

           xShowLabel                         = (hemi_j EQ nWindows-1)

        IF KEYWORD_SET(detrend_window) THEN BEGIN
           delays                          = (delayList[hemi_j])[IMF_i]
           delays_trimmed                  = !NULL
           data_trend                      = RUNNING_AVERAGE(delays,(datArr[hemi_j])[IMF_i],detrend_window, $
                                                             BIN_CENTERS=delays_trimmed, $
                                                             /DROP_EDGES)
           delays                          = delays_trimmed
           data_detrended                  = (datArr[hemi_j])[IMF_i] - data_trend
        ENDIF ELSE BEGIN
           delays                          = (delayList[hemi_j])[IMF_i]
           data_detrended                  = (datArr[hemi_j])[IMF_i]
        ENDELSE

           IF KEYWORD_SET(scale_plots_to_1) THEN BEGIN
              ;; minData                            = MIN((datArr[hemi_j])[IMF_i],MAX=maxData)
              ;; dataRange                          = maxData-minData
              ;; dataMid                            = (maxData+minData)/2.D
              ;; dataMid                            = MEAN((datArr[hemi_j])[IMF_i])
              ;; data                               = ((datArr[hemi_j])[IMF_i]-dataMid)/dataRange*2.D
              
           IF ~KEYWORD_SET(detrend_window) THEN BEGIN
              dataMid                            = MEAN((datArr[hemi_j])[IMF_i])
              data                               = (datArr[hemi_j])[IMF_i]-dataMid
              minData                            = MIN((datArr[hemi_j])[IMF_i],MAX=maxData)
              dataRange                          = maxData-minData
              dataMid                            = (maxData+minData)/2.D
              data                               = ((datArr[hemi_j])[IMF_i]-dataMid)/dataRange*2.D
           ENDIF ELSE BEGIN
              ;; dataMid                            = MEAN(data_detrended)
              ;; data                               = data_detrended-dataMid
              minData                            = MIN(data_detrended,MAX=maxData)
              dataRange                          = maxData-minData
              dataMid                            = (maxData+minData)/2.D
              data                               = (data_detrended-dataMid)/dataRange*2.D
           ENDELSE

           ENDIF ELSE BEGIN
              data                               = (datArr[hemi_j])[IMF_i]
           ENDELSE
           
           plotArr[cell_k,IMF_i,hemi_j]          = PLOT(delays,data, $
                                                        TITLE=(hemi_j GT 0) ? !NULL : 'Figure of merit ' + FOMTypeStr + ': ' + cellStr, $ ; plotTitle[0], $
                                                        XSHOWTEXT=xShowLabel, $
                                                        ;; AXIS_STYLE=(i EQ nWindows-1) ? 1 : !NULL, $
                                                        XTITLE=(hemi_j EQ nWindows-1) ? 'Delay between magnetopause and cusp observation (min)' : !NULL, $
                                                        XRANGE=xRange, $
                                                        YRANGE=plotYRange, $
                                                        YTITLE=(cell_k GT 0 ? !NULL : plotHemiStr[hemi_j] + " FOM"), $
                                                        NAME=IMFCortStr[IMF_i], $
                                                        OVERPLOT=(IMF_i GT 0 ), $
                                                        COLOR=plotColor[IMF_i], $
                                                        ;; TITLE=(IMF_i GT 0) ? !NULL : 'Figure of merit ' + FOMTypeStr + ': ' + cellStr, $ ; plotTitle[0], $
                                                        ;; XTITLE=(IMF_i EQ nWindows-1) ? 'Delay between magnetopause and cusp observation (min)' : !NULL, $
                                                        ;; YTITLE=IMFCortStr[IMF_i] + " FOM", $
                                                        ;; YTITLE=IMFCortStr[IMF_i] + " FOM", $
                                                        ;; NAME=plotHemiStr[hemi_j], $
                                                        ;; OVERPLOT=(hemi_j GT 0 ), $
                                                        ;; COLOR=plotColor[hemi_j], $
                                                        ;; MARGIN=margins[*,IMF_i], $
                                                        MARGIN=margins[*,hemi_j], $
                                                        LAYOUT=plotLayout, $
                                                        THICK=3.0, $
                                                        TRANSPARENCY=50, $
                                                        /CURRENT)
           
           
           IF xShowLabel THEN BEGIN
              ax                = plotArr[cell_k,IMF_i,hemi_j].axes
              IF N_ELEMENTS(ax) GT 2 THEN BEGIN
                 ax[2].showText = 0
              ENDIF
           ENDIF
           
        ENDFOR
     ENDFOR
     
     IF cell_k EQ 0 THEN BEGIN
        legendArr[0]                       = LEGEND(TARGET=plotArr[cell_k,*,0], $
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