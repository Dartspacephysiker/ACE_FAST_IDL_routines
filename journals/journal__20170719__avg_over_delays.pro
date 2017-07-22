;2017/07/19
PRO JOURNAL__20170719__AVG_OVER_DELAYS

  COMPILE_OPT IDL2,STRICTARRSUBS

  doDawnDuskPlots = 0
  doRegPlots      = 1

  include_ions    = 1

  ;; DstCutoff    = -75
  ;; stableIMF    = '29'

  ;; DstCutoff    = -40
  ;; stableIMF    = '19'
  ;; add_night_delay = 45*60

  ;; DstCutoff    = -20
  ;; stableIMF    = '19'

  ;; DstCutoff    = -40
  ;; stableIMF    = '14'
  ;; fixed_night_delay = 70.*60

  ;; DstCutoff    = -30
  ;; stableIMF    = '9'
  ;; dels         = [0:45:5]*60

  ;; DstCutoff    = -30
  ;; stableIMF    = '19'
  ;; add_night_delay = 50*60
  ;; dels         = [0:30:5]*60

  ;; DstCutoff    = -40
  ;; stableIMF    = '19'
  ;; add_night_delay = 45*60
  ;; dels         = [0:30:5]*60

  ;; DstCutoff    = -25
  stableIMF    = '19'
  add_night_delay = 45*60
  dels         = [0:45:5]*60

  nDelay          = N_ELEMENTS(dels)

  fileDir         = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'

  IF KEYWORD_SET(DstCutoff) THEN BEGIN
     DstString = (N_ELEMENTS(plotPref) GT 0 ? plotPref : '' ) + $
                 'Dst_' + STRCOMPRESS(DSTcutoff,/REMOVE_ALL)
     avgString = 'avgnStorm'
  ENDIF ELSE BEGIN
     DstString = ''
     avgString = 'avg'
  ENDELSE

  IF KEYWORD_SET(add_night_delay) THEN BEGIN
     addNightStr             = STRING(FORMAT='("_",F0.1,"ntDel")',add_night_delay/60.) 
  ENDIF ELSE BEGIN
     addNightStr             = ''
  ENDELSE

  IF KEYWORD_SET(fixed_night_delay) THEN BEGIN
     addNightStr             = STRING(FORMAT='("_",F0.1,"ntDel_fix")',fixed_night_delay/60.) 
  ENDIF ELSE BEGIN
     addNightStr             = N_ELEMENTS(addNightStr) GT 0 ? addNightStr : ''
  ENDELSE

  finalDelStr     = STRING(FORMAT='("_",I0,"-",I0,"Dels")',dels[0]/60.,dels[-1]/60.) + addNightStr

  btMin        = 1.0
  btMinStr     = '_' + (KEYWORD_SET(abs_btMin) ? 'ABS' : '') $
                 + 'btMin' + STRING(btMin,FORMAT='(D0.1)')

  filePref     = 'polarplots_' + DstString + '--upto90ILAT300-4300km-orb_500-12670-NORTH_AACGM-cur_-1-1-' + avgString + $
                 '_' + stableIMF + 'stable'
  fileSuff     = btMinStr + '-Ring'
  plotPref     = DstString + '--300-4300km-orb_500-12670-NORTH_AACGM-cur_-1-1-' + avgString + $
                 '_' + stableIMF + 'stable_45.0ntDel' + btMinStr + '-'
  
  configFilePref = 'multi_PASIS_vars-alfDB-w_t-' + DstString + '--upto90ILAT300-4300km-orb_500-12670-NORTH_AACGM-cur_-1-1-' + avgString + $
                   '_' + stableIMF + 'stable'

  quants       = '_tAvgd_' + ['NoN-eNumFl','pF_pF','sptAvg_NoN-eNumFl_eF_LC_intg']

  clockStrings = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  nIMFOrient   = N_ELEMENTS(clockStrings)

  H2DAvgArr_list  = LIST()
  H2DAvgMaskArr_list = LIST()
  DataNameArr_list = LIST()
  FOREACH quant,quants,iQuant DO BEGIN

     FOREACH delay,dels,iDel DO BEGIN

        delayStr = STRING(FORMAT='("_",F0.1,"Del")',delay/60.) + addNightStr

        fileName = filePref + delayStr + fileSuff

        PRINT,fileName + quant
        
        IF FILE_TEST(fileDir+fileName+quant + '.dat') THEN BEGIN
           RESTORE,fileDir+fileName+quant + '.dat'
        ENDIF ELSE STOP

        IF iDel EQ 0 THEN BEGIN
           H2DAvgArr = H2DStrArr
           H2DAvgMaskArr = H2DMaskArr
           FOR k=0,N_ELEMENTS(H2DAvgArr)-1 DO BEGIN
              H2DAvgArr[k].data = 0
              H2DAvgArr[k].grossIntegrals.day   = 0
              H2DAvgArr[k].grossIntegrals.night = 0
              H2DAvgArr[k].grossIntegrals.total = 0
              H2DAvgArr[k].grossIntegrals.custom[0] = 0
              H2DAvgArr[k].grossIntegrals.custom[1] = 0
              H2DAvgMaskArr[k].data = 255
           ENDFOR

        ENDIF

        FOREACH IMF,clockStrings,iIMF DO BEGIN

           H2DAvgArr[iIMF].data += H2DStrArr[iIMF].data/nDelay
           H2DAvgArr[iIMF].grossIntegrals.day   += H2DStrArr[iIMF].grossIntegrals.day/nDelay
           H2DAvgArr[iIMF].grossIntegrals.night += H2DStrArr[iIMF].grossIntegrals.night/nDelay
           H2DAvgArr[iIMF].grossIntegrals.total += H2DStrArr[iIMF].grossIntegrals.total/nDelay
           H2DAvgArr[iIMF].grossIntegrals.custom[0] += H2DStrArr[iIMF].grossIntegrals.custom[0]/nDelay
           H2DAvgArr[iIMF].grossIntegrals.custom[1] += H2DStrArr[iIMF].grossIntegrals.custom[1]/nDelay

           H2DAvgMaskArr[iIMF].data = H2DAvgMaskArr[iIMF].data AND H2DMaskArr[iIMF].data

        ENDFOREACH

     ENDFOREACH

     H2DAvgArr_list.Add,TEMPORARY(H2DAvgArr)
     H2DAvgMaskArr_list.Add,TEMPORARY(H2DAvgMaskArr)
     DataNameArr_list.Add,TEMPORARY(dataNameArr)
  ENDFOREACH

  ;;NOW PLOTS
  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF='/bonuses/'

  configFile = configFilePref + delayStr + fileSuff + '.sav'
  IF FILE_TEST(fileDir+configFile) THEN BEGIN
     RESTORE,fileDir+configFile
  ENDIF ELSE STOP

  group_like_plots_for_tiling    = 1
  scale_like_plots_for_tiling    = 0
  adj_upper_plotlim_thresh       = 3    ;;Check third maxima
  adj_lower_plotlim_thresh       = 2    ;;Check minima

  tile__include_IMF_arrows = 0
  tile__cb_in_center_panel = 1
  cb_force_oobHigh         = 1
  labels_for_presentation  = 1
  suppress_gridLabels      = [0,1,1, $
                              1,1,1, $
                              1,1,1]

  SETUP_TO_RUN_ALL_CLOCK_ANGLES,multiple_IMF_clockAngles,clockStrings, $
                                angleLim1,angleLim2, $
                                IMFStr,IMFTitle, $
                                BYMIN=byMin, $
                                BYMAX=byMax, $
                                BZMIN=bzMin, $
                                BZMAX=bzMax, $
                                BTMIN=btMin, $
                                BTMAX=btMax, $
                                BXMIN=bxMin, $
                                BXMAX=bxMax, $
                                CUSTOM_INTEGRAL_STRUCT=custom_integral_struct, $
                                CUSTOM_INTEG_MINM=minM_c, $
                                CUSTOM_INTEG_MAXM=maxM_c, $
                                CUSTOM_INTEG_MINI=minI_c, $
                                CUSTOM_INTEG_MAXI=maxI_c, $
                                /AND_TILING_OPTIONS, $
                                GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
                                TILE_IMAGES=tile_images, $
                                TILING_ORDER=tiling_order, $
                                N_TILE_COLUMNS=n_tile_columns, $
                                N_TILE_ROWS=n_tile_rows, $
                                TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
                                TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
                                TILEPLOTSUFF=plotSuff


  FOREACH quant,quants,iQuant DO BEGIN

     paramString =  filePref + finalDelStr + fileSuff + quant

     tempFile = fileDir + filePref + delayStr + fileSuff + quant + '.dat'

     PRINT,fileName + quant
     
     IF ~FILE_TEST(tempFile) THEN STOP

     PLOT_ALFVENDB_2DHISTOS, $
        H2DSTRARR=h2dAvgArr_list[iQuant], $
        DATANAMEARR=dataNameArr_list[iQuant], $
        H2DMASKARR=h2dAvgMaskArr_list[iQuant], $
        TEMPFILE=tempFile, $
        ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
        MIMC_STRUCT=PASIS__MIMC_struct, $
        PLOTDIR=plotDir, $
        PARAMSTR=paramString, $
        ORG_PLOTS_BY_FOLDER=org_plots_by_folder, $
        HEMI=PASIS__MIMC_struct.hemi, $
        CLOCKSTR=clockStr, $
        GRIDCOLOR=gridColor, $
        SUPPRESS_THICKGRID=suppress_thickGrid, $
        SUPPRESS_THINGRID=suppress_thinGrid, $
        SUPPRESS_GRIDLABELS=suppress_gridLabels, $
        SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
        SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
        SUPPRESS_MLT_NAME=suppress_MLT_name, $
        SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
        SUPPRESS_TITLES=suppress_titles, $
        LABELS_FOR_PRESENTATION=labels_for_presentation, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        TILING_ORDER=tiling_order, $
        TILE__FAVOR_ROWS=tile__favor_rows, $
        TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
        TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
        TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
        TILEPLOTSUFF=tilePlotSuff, $
        TILEPLOTTITLE=tilePlotTitle, $
        NO_COLORBAR=no_colorbar, $
        EPS_OUTPUT=eps_output, $
        OVERPLOTSTR=KEYWORD_SET(sendit), $
        OVERPLOT_CONTOUR__LEVELS=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__levels') ? PASIS__alfDB_plot_struct.op_contour__levels : !NULL, $
        OVERPLOT_CONTOUR__PERCENT=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__percent') ? PASIS__alfDB_plot_struct.op_contour__percent : !NULL, $
        OVERPLOT_CONTOUR__NCOLORS=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__nColors') ? PASIS__alfDB_plot_struct.op_contour__nColors : !NULL, $
        OVERPLOT_CONTOUR__CTINDEX=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__CTIndex') ? PASIS__alfDB_plot_struct.op_contour__CTIndex : !NULL, $
        OVERPLOT_CONTOUR__CTBOTTOM=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__CTBottom') ? PASIS__alfDB_plot_struct.op_contour__CTBottom : !NULL, $
        OVERPLOT_PLOTRANGE=TAG_EXIST(PASIS__alfDB_plot_struct,'op_plotRange') ? PASIS__alfDB_plot_struct.op_plotRange : !NULL, $
        CENTERS_MLT=centersMLT, $
        CENTERS_ILAT=centersILAT, $
        PREV_PLOT_I__LIMIT_TO_THESE=prev_plot_i__limit_to_these, $
        TXTOUTPUTDIR=txtOutputDir, $
        _EXTRA=PASIS__alfDB_plot_struct

  ENDFOREACH

END
