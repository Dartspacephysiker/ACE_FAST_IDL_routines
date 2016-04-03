;+
; NAME:                     PLOT_FIGURE_OF_MERIT_I_OR_II__DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_OR_SOUTHERN_HEMI
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
PRO PLOT_FIGURE_OF_MERIT_I_OR_II__DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_OR_SOUTHERN_HEMI, $
   HEMI=hemi, $
   USE_OLD_SOUTH_DATA=use_old_south, $
   ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
   INCLUDE_ALLIMF=include_allIMF, $
   FOM_TYPE=fom_type, $
   COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
   CELL_TO_PLOT=cell_to_plot, $
   SAVEPLOTS=savePlots, $
   SPNAME=spName, $
   LUN=lun

  retVal = FIGURE_OF_MERIT_I_OR_II__PLOT_SETUP(HEMI=hemi, $
                                               USE_OLD_SOUTH_DATA=use_old_south, $
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
                                               PLOTCOLOR=plotColor, $
                                               IMFCORTSTR=IMFCortStr, $
                                               DATARR=datArr, $
                                               DELAYLIST=delayList, $
                                               LUN=lun)

  IF retVal EQ -1 THEN BEGIN
     PRINT,"Couldn't set up FOM plot! Exiting ..."
     RETURN
  ENDIF

  ;; PRINTF,lun,"****FIGURE OF MERIT FROM COMBINING HEMISPHERES****"
  ;; PRINTF,lun,FORMAT='("Rank",T10,"Delay (m)",T25,"N/S FOM",T35,"N FOM",T45,"S FOM")'
  ;; statFmt                                  = '(I0,T10,F0.1,T25,F0.3,T35,F0.3,T45,F0.3)'
  
  ;; FOR i=0,nFOM_to_print-1 DO BEGIN
  ;;    list_i                                = combNorthSouth_i[i]
  ;;    ;; PRINTF,lun,FORMAT=fomUltimateFmtString,i+1,delayNorthSouth_awesome[i],combNorthSouth_awesome[i],dawnFOMList[0,i],duskFOMList[0,i],dawnFOMList[2,i],duskFOMList[2,i]
  ;;    ;; print,i
  ;;    ;; print,i+1
  ;;    PRINTF,lun,FORMAT=statFmt,i+1,delayNorthSouth_awesome[i],combNorthSouth_awesome[i], $
  ;;           combNorth[list_i],combSouth[list_i]
  ;; ENDFOR
  
  ;PLOT STUFF
  winArr                                   = MAKE_ARRAY(nWindows,/OBJ)
  legendArr                                = MAKE_ARRAY(nWindows,/OBJ)
  plotArr                                  = MAKE_ARRAY(nWindows,plotsPerWindow,/OBJ)

  ;;i indexes IMF direction
  ;;j indexes hemisphere
  FOR i=0,nWindows-1 DO BEGIN
     winArr[i]                             = WINDOW(WINDOW_TITLE='Figure of merit ' + FOMTypeStr + ': ' + plotTitle[i], $
                                                    DIMENSIONS=[1200,800])
     winArr[i].setCurrent

     FOR j=0,plotsPerWindow-1 DO BEGIN
        plotArr[i,j]                       = PLOT((delayList[j])[i],(datArr[j])[i], $
                                                  TITLE=(j GT 0) ? !NULL : 'Figure of merit ' + FOMTypeStr + ': ' + plotTitle[i], $
                                                  XTITLE='Delay between magnetopause and cusp observation (min)', $
                                                  YRANGE=[0,0.8], $
                                                  YTITLE="Figure of merit", $
                                                  NAME=plotHemiStr[j], $
                                                  OVERPLOT=(j GT 0), $
                                                  COLOR=plotColor[j], $
                                                  THICK=3.0, $
                                                  TRANSPARENCY=50, $
                                                  /CURRENT)
        
     ENDFOR
     legendArr[i]                          = LEGEND(TARGET=plotArr[i,*], $
                                                    /NORMAL, $
                                                    POSITION=[0.85,0.82], $
                                                    FONT_SIZE=18, $
                                                    HORIZONTAL_ALIGNMENT=0.5, $
                                                    VERTICAL_SPACING=0.01, $
                                                    /AUTO_TEXT_COLOR)
     
     IF KEYWORD_SET(savePlots) THEN BEGIN
        SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/VERBOSE,/ADD_TODAY
        ;; IF ~KEYWORD_SET(spName) THEN BEGIN
           plotExt                        = '.png'
           spNFmt                         = '(A0,"--figure_of_merit_type",I1,"--",A0,A0)'
           spName                         = STRING(FORMAT=spNFmt,GET_TODAY_STRING(/DO_YYYYMMDD_FMT),fom_type,IMFCortStr[i],plotExt) 
        ;; ENDIF
        PRINTF,lun,'Saving FOM plot to ' + spName + '...'
        winArr[i].save,plotDir+spName,RESOLUTION=defRes
      ENDIF

  ENDFOR

END