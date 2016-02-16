;;2016/02/13
;;Fancify
;;This one accommodates the other FOMs--Average, log average, and median
FUNCTION FIGURE_OF_MERIT_III_IV_V__SPLIT_HEMI__PLOT_SETUP, $
   HEMI=hemi, $
   ;; DETREND_WINDOW=detrend_window, $
   ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
   ;; INCLUDE_ALLIMF=include_allIMF, $
   FILEDAY=fileDia, $
   FOM_TYPE=fom_type, $
   FOMTYPESTR=fomTypeStr, $
   COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
   CELL_TO_PLOT=cell_to_plot, $
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
   LUN=lun

  defCell_to_plot                          = 'BOTH'
  defFOM_type                              = 3
  defHemi                                  = 'NORTH'


  IF N_ELEMENTS(lun) EQ 0       THEN lun   = -1 ;stdout

  IF ~KEYWORD_SET(cell_to_plot) THEN cell_to_plot = defCell_to_plot
  IF ~KEYWORD_SET(fom_type)     THEN fom_type     = defFOM_type
  IF ~KEYWORD_SET(hemi)         THEN hemi         = defHemi

  IF ~KEYWORD_SET(h2dFileDir) THEN BEGIN
     h2dFileDir                            = '/SPENCEdata/Research/Cusp/ACE_FAST/20160216--Alfven_cusp_figure_of_merit/data/'
  ENDIF

  hoyDia                                   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  ;;input files
  IF ~KEYWORD_SET(fileDia) THEN fileDia    = '20160216'

  CASE fom_type OF
     3: BEGIN
        inFile_north                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--NORTH_figures_of_merit_III--delays_-25_25min.sav'
        inFile_south                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit_III--delays_-25_25min.sav'

        PRINT,'Using FOM_type = 3'
        fomTypeStr                         = '(Type III)'
     END
     4: BEGIN
        inFile_north                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--NORTH_figures_of_merit_IV--delays_-25_25min.sav'
        inFile_south                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit_IV--delays_-25_25min.sav'

        PRINT,'Using FOM_type = 4'
        fomTypeStr                         = '(Type IV)'
     END
     5: BEGIN
        inFile_north                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--NORTH_figures_of_merit_V--delays_-25_25min.sav'
        inFile_south                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit_V--delays_-25_25min.sav'
        PRINT,'Using FOM_type = 5'
        fomTypeStr                         = '(Type V)'
     END
     ELSE: BEGIN
        PRINT,"FOM_type must be either 3, 4, or 5!!"
        RETURN,-1
     END
  ENDCASE

  nFOM_to_print                            = 25

  restore,inFile_north
  combFOMList_North                        = combFOMList
  dawnFOMList_North                        = dawnFOMList
  duskFOMList_North                        = duskFOMList
  delayList_North                          = delayList
  
  restore,inFile_south
  combFOMList_South                        = combFOMList
  dawnFOMList_South                        = dawnFOMList
  duskFOMList_South                        = duskFOMList
  delayList_South                          = delayList

  CASE STRUPCASE(cell_to_plot) OF
     'COMBINED': BEGIN
        PRINTF,lun,'Plotting FOM from combined dawn/dusk cells'
        datArr                             = [combFOMList_North,combFOMList_South]
        cellStr                            = 'Dawn and dusk cells combined'
     END
     'DAWN': BEGIN
        datArr                             = [dawnFOMList_North,dawnFOMList_South]
        cellStr                            = 'Dawn cell'
     END
     'DUSK': BEGIN
        datArr                             = [duskFOMList_North,duskFOMList_South]
        cellStr                            = 'Dusk cell'
     END
     ELSE: BEGIN
        PRINT,"Must select one of 'COMBINED', 'DAWN', or 'DUSK' for cell_to_plot!"
        RETURN, -1
     END
  ENDCASE
  delayList                                 = [delayList_North,delayList_South]
  
  IF KEYWORD_SET(combine_foms_for_each_IMF) THEN BEGIN
     PRINTF,lun,'Combining FOMs for each IMF'
     ;; IF KEYWORD_SET(include_allIMF) THEN BEGIN
     ;;    PRINTF,lun,'Including all_IMF in combined FOM ...'
     ;;    datArr                       = [[datArr[0,0]+datArr[0,1]+datArr[0,2]],[datArr[1,0]+datArr[1,1]+datArr[1,2]]]
     ;; ENDIF ELSE BEGIN
        datArr                       = [[datArr[0,0]+datArr[0,1]],[datArr[1,0]+datArr[1,1]]]
     ;; ENDELSE
     nWindows                              = 1      ;Only one window
     plotTitle                             = cellStr + ' for combined IMF orientations'
     IMFCortStr                            = 'combined'
  ENDIF ELSE BEGIN                         
     ;; IF KEYWORD_SET(suppress_all_IMF_plots) THEN BEGIN
        nWindows                           = 2 ;One window for dawn, all, and dusk IMF
        IMFCortStr                         = ['Dawnward','Duskward']
        plotTitle                          = cellStr + ' for ' + IMFCortStr + ' IMF'
     ;; ENDIF ELSE BEGIN
     ;;    nWindows                           = 3 ;One window for dawn, all, and dusk IMF
     ;;    IMFCortStr                         = ['Dawnward','Duskward']
     ;;    plotTitle                          = cellStr + ' for ' + IMFCortStr + ' IMF'
     ;; ENDELSE
  ENDELSE
  
  IF KEYWORD_SET(scale_plots_to_1) THEN BEGIN
     plotYRange                            = [-1.D,1.D]
     IF KEYWORD_SET(auto_adjust_yRange) THEN BEGIN
        PRINT,"Can't have plots scaled to 1 and y Range auto-adjusted!"
        STOP
     ENDIF
  ENDIF

  IF ~KEYWORD_SET(plotYRange) THEN BEGIN
     plotYRange                            = [MIN((datArr[0])[0]),MAX((datArr[0])[0])]
  ENDIF

  CASE STRUPCASE(hemi) OF
     'COMBINED': BEGIN
        IF KEYWORD_SET(only_show_combined_hemi) THEN BEGIN
           plotsPerWindow                  = 1
           datArr                          = datArr[0,*]+datArr[1,*]
           datArr                          = REFORM(datArr,1,N_ELEMENTS(datArr))
           plotColor                       = 'BLACK'
           delayList                        = delayList[0]
        ENDIF ELSE BEGIN
           plotsPerWindow                  = 3
           datArr                          = [[datArr[0,*]],[datArr[1,*]],[datArr[0,*]+datArr[1,*]]]
           plotColor                       = ['RED','BLUE','BLACK']
        ENDELSE
     END
     'BOTH': BEGIN
        plotsPerWindow                     = 2
        plotHemiStr                        = ['NORTH','SOUTH']
        plotColor                          = ['RED','BLUE']
     END
     'NORTH': BEGIN
        plotsPerWindow                     = 1
        plotHemiStr                        = hemi
        plotColor                          = 'RED'
        datArr                             = datArr[0,*]
        delayList                           = delayList[0]
     END
     'SOUTH': BEGIN
        plotsPerWindow                     = 1
        plotHemiStr                        = hemi
        plotColor                          = 'BLUE'
        datArr                             = datArr[1,*]
        delayList                           = delayList[1]
     END
     ELSE: BEGIN
        PRINTF,lun,"Must select one of 'COMBINED', 'BOTH', 'NORTH', or 'SOUTH' for hemi!"
        RETURN,-1
     END
  ENDCASE  

  RETURN,0

END