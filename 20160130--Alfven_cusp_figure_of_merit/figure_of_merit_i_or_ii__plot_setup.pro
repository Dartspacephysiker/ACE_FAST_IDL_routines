;;2016/02/02
;;Fancify
FUNCTION FIGURE_OF_MERIT_I_OR_II__PLOT_SETUP, $
   HEMI=hemi, $
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
   CELLSTR=cellStr, $
   IMFCORTSTR=IMFCortStr, $
   DATARR=datArr, $
   DELAYLIST=delayList, $
   LUN=lun
   ;; COMBFOMLIST_NORTH=combFOMList_North, $
   ;; DAWNFOMLIST_NORTH=dawnFOMList_North, $
   ;; DUSKFOMLIST_NORTH=duskFOMList_North, $
   ;; DELAYLIST_NORTH=delayList_North, $ 
   ;; COMBFOMLIST_SOUTH=combFOMList_South, $
   ;; DAWNFOMLIST_SOUTH=dawnFOMList_South, $
   ;; DUSKFOMLIST_SOUTH=duskFOMList_South, $
   ;; DELAYLIST_SOUTH=delayList_South, $
   
  ;; COMMON hemi,fom_type,cell_to_plot,nFOM_to_print

  defCell_to_plot                          = 'BOTH'
  defFOM_type                              = 2
  defHemi                                  = 'NORTH'


  IF N_ELEMENTS(lun) EQ 0       THEN lun          = -1 ;stdout

  IF ~KEYWORD_SET(cell_to_plot) THEN cell_to_plot = defCell_to_plot
  IF ~KEYWORD_SET(fom_type)     THEN fom_type     = defFOM_type
  IF ~KEYWORD_SET(hemi)         THEN hemi         = defHemi

  h2dFileDir                               = '/SPENCEdata/Research/Cusp/ACE_FAST/20160130--Alfven_cusp_figure_of_merit/data/'

  hoyDia                                   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  ;;input files
  fileDia                                  = '20160201'

  IF KEYWORD_SET(use_old_south) THEN BEGIN
     PRINTF,lun,"Using BAD Southern data!"
  ENDIF

  CASE fom_type OF
     1: BEGIN
        inFile_north                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--NORTH_figures_of_merit--delays_0-30min.sav'
        IF KEYWORD_SET(use_old_south) THEN BEGIN
           inFile_south                    = h2dFileDir+'processed/south_fom_before_setting_bad_probOccurrence_to_zero/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit--delays_0-30min.sav'
        ENDIF ELSE BEGIN
           inFile_south                    = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit--delays_0-30min.sav'
        ENDELSE
        PRINT,'Using FOM_type = 1'
        fomTypeStr                         = '(Type I)'
     END
     2: BEGIN
        inFile_north                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--NORTH_figures_of_merit_II--delays_0-30min.sav'
        IF KEYWORD_SET(use_old_south) THEN BEGIN
           inFile_south                       = h2dFileDir+'processed/south_fom_before_setting_bad_probOccurrence_to_zero/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit_II--delays_0-30min.sav'
        ENDIF ELSE BEGIN
           inFile_south                       = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit_II--delays_0-30min.sav'
        ENDELSE
        PRINT,'Using FOM_type = 2'
        fomTypeStr                         = '(Type II)'
     END
     ELSE: BEGIN
        PRINT,"FOM_type must be either 1 or 2!!"
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
        PRINT,"Must select one of 'BOTH', 'DAWN', or 'DUSK' for cell_to_plot!"
        RETURN, -1
     END
  ENDCASE
  delayList                                 = [delayList_North,delayList_South]
  
  IF KEYWORD_SET(combine_foms_for_each_IMF) THEN BEGIN
     PRINTF,lun,'Combining FOMs for each IMF'
     IF KEYWORD_SET(include_allIMF) THEN BEGIN
        PRINTF,lun,'Including all_IMF in combined FOM ...'
        datArr                       = [[datArr[0,0]+datArr[0,1]+datArr[0,2]],[datArr[1,0]+datArr[1,1]+datArr[1,2]]]
     ENDIF ELSE BEGIN
        datArr                       = [[datArr[0,0]+datArr[0,2]],[datArr[1,0]+datArr[1,2]]]
     ENDELSE
     nWindows                              = 1      ;Only one window
     plotTitle                             = cellStr + ' for combined IMF orientations'
     IMFCortStr                            = 'combined'
  ENDIF ELSE BEGIN                         
     nWindows                              = 3      ;One window for dawn, all, and dusk IMF
     IMFCortStr                            = ['Dawnward','All','Duskward']
     plotTitle                             = cellStr + ' for ' + IMFCortStr + ' IMF'
  ENDELSE
  
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