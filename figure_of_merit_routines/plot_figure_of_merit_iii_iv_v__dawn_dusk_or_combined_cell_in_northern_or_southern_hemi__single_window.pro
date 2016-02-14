;+
; NAME:                     PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_OR_SOUTHERN_HEMI__SINGLE_WINDOW
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
; MODIFICATION HISTORY:     2016/02/02 Barnebarn
;
;-
PRO PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_OR_SOUTHERN_HEMI__SINGLE_WINDOW, $
   HEMI=hemi, $
   ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
   INCLUDE_ALLIMF=include_allIMF, $
   FOM_TYPE=fom_type, $
   COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
   CELL_TO_PLOT=cell_to_plot, $
   PLOTYRANGE=plotYRange, $
   SCALE_PLOTS_TO_1=scale_plots_to_1, $
   SAVEPLOTS=savePlots, $
   SPNAME=spName, $
   LUN=lun

  retVal = FIGURE_OF_MERIT_III_IV_V__PLOT_SETUP(HEMI=hemi, $
                                                ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
                                                INCLUDE_ALLIMF=include_allIMF, $
                                                FOM_TYPE=fom_type, $
                                                FOMTYPESTR=fomTypeStr, $
                                                COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
                                                CELL_TO_PLOT=cell_to_plot, $
                                                NWINDOWS=nWindows, $
                                                PLOTSPERWINDOW=plotsPerWindow, $
                                                PLOTTITLE=plotTitle, $
                                                PLOTHEMISTR=plotHemiStr, $
                                                PLOTYRANGE=plotYRange, $
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

  ;PLOT STUFF
  winArr                                   = MAKE_ARRAY(1,/OBJ)
  winArr[0]                                = WINDOW(WINDOW_TITLE='Figure of merit ' + FOMTypeStr + ': ' + cellStr, $; plotTitle[0], $
                                                    DIMENSIONS=[600,800])
  legendArr                                = MAKE_ARRAY(1,/OBJ)
  plotArr                                  = MAKE_ARRAY(nWindows,plotsPerWindow,/OBJ)

  topMargin                                = [0.09,0.01,0.03,0.14]
  middleMargin                             = [0.09,0.075,0.03,0.075]
  bottomMargin                             = [0.09,0.14,0.03,0.01]
  margins                                  = [[topMargin],[middleMargin],[bottomMargin]]

  xRange                                   = [MIN((delayList[0])[0]),MAX((delayList[0])[0])]
  FOR i=0,nWindows-1 DO BEGIN

     
     plotLayout                            = [1,nWindows,i+1]

     FOR j=0,plotsPerWindow-1 DO BEGIN

        IF KEYWORD_SET(scale_plots_to_1) THEN BEGIN
           ;; minData                            = MIN((datArr[j])[i],MAX=maxData)
           ;; dataRange                          = maxData-minData
           ;; dataMid                            = (maxData+minData)/2.D
           ;; dataMid                            = MEAN((datArr[j])[i])
           ;; data                               = ((datArr[j])[i]-dataMid)/dataRange*2.D

           dataMid                            = MEAN((datArr[j])[i])
           data                               = (datArr[j])[i]-dataMid
           minData                            = MIN((datArr[j])[i],MAX=maxData)
           dataRange                          = maxData-minData
           dataMid                            = (maxData+minData)/2.D
           data                               = ((datArr[j])[i]-dataMid)/dataRange*2.D

        ENDIF ELSE BEGIN
           data                               = (datArr[j])[i]
        ENDELSE

        xShowLabel                         = (i EQ nWindows-1)
        plotArr[i,j]                       = PLOT((delayList[j])[i],data, $
                                                  TITLE=(i GT 0) ? !NULL : 'Figure of merit ' + FOMTypeStr + ': ' + cellStr, $; plotTitle[0], $
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
           ax                = plotArr[i,j].axes
           IF N_ELEMENTS(ax) GT 2 THEN BEGIN
              ax[2].showText = 0
           ENDIF
        ENDIF
        
     ENDFOR
     IF i EQ 0 THEN BEGIN
        legendArr[0]                       = LEGEND(TARGET=plotArr[i,*], $
                                                    /NORMAL, $
                                                    POSITION=[0.5,0.8], $
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
                                             cell_to_plot+(KEYWORD_SET(use_old_south) ? '--oldSouth' : ''),plotExt) 
     ;; ENDIF
     PRINTF,lun,'Saving FOM plot to ' + spName + '...'
     winArr[0].save,plotDir+spName,RESOLUTION=defRes
  ENDIF


END