;2017/07/19
PRO JOURNAL__20170722__AVG_OVER_DELAYS__CUSTOM_NIGHTTIME_DELAY

  COMPILE_OPT IDL2,STRICTARRSUBS

  eSpeckers       = 0
  eSpeck_numFl    = 1
  eSpeck_eFlux    = 1
  eSpeck_rot      = 0

  kill_contour    = 1

  use_nEvents_not_nDelay_for_denom = 1
  
  orbRange        = [500,12670]
  altitudeRange   = [300,4300]

  save_coolFiles  = 1
  makePlots       = 1

  DstCutoff    = -25
  stableIMF    = '14'

  btMin        = 1.0

  minMC        = 1
  maxNegMC     = -1

  use_AACGM    = 1
  
  stepEvery1      = 1B
  startDel        = 0
  stopDel         = 60
  add_nightDelay  = 30
  dels            = [startDel:stopDel:(KEYWORD_SET(stepEvery1) ? 1 : 5)]*60

  ;; dels            = [5:35]*60

  nDelay          = N_ELEMENTS(dels)

  fileDir         = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'

  superSuff = ''
  IF KEYWORD_SET(use_nEvents_not_nDelay_for_denom) THEN BEGIN
     superSuff += '-nEvDiv'
  ENDIF     

  hemi         = 'NORTH'
  IF KEYWORD_SET(use_AACGM) THEN hemi += '_AACGM'

  IF KEYWORD_SET(DstCutoff) THEN BEGIN
     DstString    = (N_ELEMENTS(plotPref) GT 0 ? plotPref : '' ) + $
                 'Dst_' + STRCOMPRESS(DSTcutoff,/REMOVE_ALL)
     avgString    = 'avgnStorm'
  ENDIF ELSE BEGIN
     DstString    = ''
     avgString    = 'avg'
  ENDELSE

  IF KEYWORD_SET(add_nightDelay) THEN BEGIN
     add_nightDelay *= 60
     addNightStr  = STRING(FORMAT='("_",F0.1,"ntDel")',add_nightDelay/60.) 
  ENDIF ELSE BEGIN
     addNightStr  = ''
  ENDELSE

  IF KEYWORD_SET(fixed_night_delay) THEN BEGIN
     addNightStr  = STRING(FORMAT='("_",F0.1,"ntDel_fix")',fixed_night_delay/60.) 
  ENDIF ELSE BEGIN
     addNightStr  = N_ELEMENTS(addNightStr) GT 0 ? addNightStr : ''
  ENDELSE

  ;; custom_addNightStr    = ''
  ;; IF KEYWORD_SET(add_nightDelay) THEN BEGIN
  ;;    custom_addNightStr = STRING(FORMAT='("_",F0.1,"ntDel_cstm")',add_nightDelay/60.) 
  ;; ENDIF

  finalDelStr  = STRING(FORMAT='("_",I0,"-",I0,A0)', $
                        dels[0]/60.,dels[-1]/60.,(dels[1]-dels[0] EQ 60 ? "superDels" : "Dels")) + $
                 addNightStr

  btMinStr     = ''
  IF N_ELEMENTS(btMin) GT 0 THEN BEGIN
     btMinStr  = '_' + (KEYWORD_SET(abs_btMin) ? 'ABS' : '') $
                 + 'btMin' + STRING(btMin,FORMAT='(D0.1)')
  ENDIF
  
  orbPref = "-orb_"
  kmPref = "km"
  CASE 1 OF
     KEYWORD_SET(eSpeckers): BEGIN
        rawQuants = ['broad','diff','mono']

        quants = !NULL
        IF KEYWORD_SET(eSpeck_eFlux) THEN BEGIN
           quants = [quants,'_tAvgd_eFlux-all_fluxes_eSpec-2009_' + rawQuants]
        ENDIF
        IF KEYWORD_SET(eSpeck_numFl) THEN BEGIN
           quants = [quants,'_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_' + rawQuants]
        ENDIF
        dbStr  = 'eSpec-w_t-'
        prefPref = 'NWO-upto90-' + DstString + (KEYWORD_SET(eSpeck_rot) ? '-rot' : '')
        ancillaryStr = '0sampT-'
     END
     ELSE: BEGIN

        quants = '_tAvgd_' + ['NoN-eNumFl','pF_pF','sptAvg_NoN-eNumFl_eF_LC_intg']
        dbStr  = 'alfDB-w_t-'
        prefPref = DstString + '--upto90ILAT'
        ancillaryStr = (minMC NE 10) OR (maxNegMC NE -10) ? STRING(FORMAT='("cur_",I0,"-",I0,"-")',maxNegMC,minMC) : ''
        ;; orbPref = "-orb_"
        ;; kmPref = "km"
     END
  ENDCASE

  orbStr          = STRING(FORMAT='(A0,I0,"-",I0)',orbPref,orbRange[0],orbRange[1])
  altStr          = STRING(FORMAT='(I0,"-",I0,A0)',altitudeRange[0],altitudeRange[1],kmPref)

  configFilePref = 'multi_PASIS_vars-' + dbStr + prefPref + $
                    altStr +  orbStr + '-' + hemi + '-' + $
                   ancillaryStr + avgString + $
                   '_' + stableIMF + 'stable'
  filePref     = 'polarplots_' + prefPref +  $
                 altStr +  orbStr + '-' + hemi + '-' + $
                 ancillaryStr + avgString + $
                 '_' + stableIMF + 'stable'
  fileSuff     = btMinStr + '-Ring'
  ;; plotPref     = DstString + '--' + altStr +  orbStr + '-NORTH_AACGM-cur_-1-1-' + avgString + $
  ;;                '_' + stableIMF + 'stable_' finalDelStr + btMinStr + '-'
  

  clockStrings = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  nIMFOrient   = N_ELEMENTS(clockStrings)

  ;;Get configfile to make template array thing
  tmpDelayStr = STRING(FORMAT='("_",F0.1,"Del")',dels[0]/60.)

  configFile = configFilePref + tmpDelayStr + fileSuff + '.sav'
  IF FILE_TEST(fileDir+configFile) THEN BEGIN
     RESTORE,fileDir+configFile
  ENDIF ELSE STOP

  GET_H2D_BIN_AREAS,h2dAreas, $
                    CENTERS1=centersMLT, $
                    CENTERS2=centersILAT, $
                    BINSIZE1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.binLng : PASIS__MIMC_struct.binM*15.), $
                    BINSIZE2=PASIS__MIMC_struct.binI, $
                    MAX1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.maxLng : PASIS__MIMC_struct.maxM*15.), $
                    MAX2=PASIS__MIMC_struct.maxI, $
                    MIN1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.minLng : PASIS__MIMC_struct.minM*15.), $
                    MIN2=PASIS__MIMC_struct.minI, $
                    SHIFT1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.shiftLng : PASIS__MIMC_struct.shiftM*15.), $
                    SHIFT2=shiftI, $
                    EQUAL_AREA_BINNING=PASIS__alfDB_plot_struct.EA_binning
  centersMLT /= 15.

  dayH2DInds     = WHERE(centersMLT GE 6  AND centersMLT LT 18, $
                      nDayH2DInds, $
                      COMPLEMENT=nightH2DInds,NCOMPLEMENT=nNightH2DInds)

  ;;Get dayfile (and possibly custom nightfile),


  H2DAvgArr_list  = LIST()
  H2DAvgMaskArr_list = LIST()
  DataNameArr_list = LIST()
  FOREACH quant,quants,iQuant DO BEGIN

     FOREACH delay,dels,iDel DO BEGIN

        IF KEYWORD_SET(add_nightDelay) THEN BEGIN

           dayDelayStr = STRING(FORMAT='("_",F0.1,"Del")',delay/60.)
           nitDelayStr = STRING(FORMAT='("_",F0.1,"Del")',(delay+add_nightDelay)/60.)
           dayFile     = filePref + dayDelayStr + fileSuff
           nitFile     = filePref + nitDelayStr + fileSuff

           ;;Need these later
           delayStr    = dayDelayStr ;need this later
           fileName    = dayFile

           IF FILE_TEST(fileDir+dayFile+quant + '.dat') THEN BEGIN
              RESTORE,fileDir+dayFile+quant + '.dat'
           ENDIF ELSE STOP

           dayH2DStrArr  = TEMPORARY(H2DStrArr)
           dayH2DMaskArr = TEMPORARY(H2DMaskArr)

           IF FILE_TEST(fileDir+nitFile+quant + '.dat') THEN BEGIN
              RESTORE,fileDir+nitFile+quant + '.dat'
           ENDIF ELSE STOP

           IF N_ELEMENTS(dayH2DStrArr) NE N_ELEMENTS(H2DStrArr) OR $
              N_ELEMENTS(dayH2DStrArr[0].data) NE N_ELEMENTS(H2DStrArr[0].data) THEN STOP

           nDay       = N_ELEMENTS(dayH2DStrArr[0].data)
           nNit       = N_ELEMENTS(H2DStrArr[0].data)

           ;; PRINT,FORMAT='(A0,T20,"(",I04," elem):",A0)',"Day file",nDay,dayFile + quant
           ;; PRINT,FORMAT='(A0,T20,"(",I04," elem):",A0)',"Nit file",nNit,nitFile + quant

           FOR k=0,N_ELEMENTS(H2DStrArr)-1 DO BEGIN
              H2DStrArr[k].data[dayH2DInds]     = dayH2DStrArr[k].data[dayH2DInds]
              H2DMaskArr[k].data[dayH2DInds]    = dayH2DMaskArr[k].data[dayH2DInds]

              H2DStrArr[k].grossIntegrals.day   = dayH2DStrArr[k].grossIntegrals.day
              H2DStrArr[k].grossIntegrals.total = H2DStrArr[k].grossIntegrals.day + H2DStrArr[k].grossIntegrals.night
           ENDFOR

        ENDIF ELSE BEGIN

           delayStr = STRING(FORMAT='("_",F0.1,"Del")',delay/60.) + addNightStr
           fileName = filePref + delayStr + fileSuff
           PRINT,fileName + quant
           
           IF FILE_TEST(fileDir+fileName+quant + '.dat') THEN BEGIN
              RESTORE,fileDir+fileName+quant + '.dat'
           ENDIF ELSE STOP

        ENDELSE
        
        IF N_ELEMENTS(H2DStrArr[0].data) NE N_ELEMENTS(h2dAreas) THEN STOP

        IF iDel EQ 0 THEN BEGIN
           H2DAvgArr     = H2DStrArr
           H2DAvgMaskArr = H2DMaskArr

           CASE 1 OF
              KEYWORD_SET(use_nEvents_not_nDelay_for_denom): BEGIN
                 H2DDivFacArr = REPLICATE({data:LONG(H2DMaskArr[0].data*0)},N_ELEMENTS(H2DAvgMaskArr))
              END
              ELSE: BEGIN
                 H2DDivFacArr = nDelay
              END
           ENDCASE

           FOR k=0,N_ELEMENTS(H2DAvgArr)-1 DO BEGIN
              H2DAvgArr[k].data = 0
              H2DAvgArr[k].grossIntegrals.day   = 0
              H2DAvgArr[k].grossIntegrals.night = 0
              H2DAvgArr[k].grossIntegrals.total = 0
              H2DAvgArr[k].grossIntegrals.custom[0] = 0
              H2DAvgArr[k].grossIntegrals.custom[1] = 0
              H2DAvgMaskArr[k].data = 255.
           ENDFOR

        ENDIF

        FOREACH IMF,clockStrings,iIMF DO BEGIN

           ;;Where the sum actualment happens
           
           IF KEYWORD_SET(use_nEvents_not_nDelay_for_denom) THEN BEGIN

              H2DDivFacArr[iIMF].data += (H2DMaskArr[iIMF].data EQ 0.0)

              IF N_ELEMENTS(H2DStrArr[iIMF].data) NE N_ELEMENTS(H2DAvgArr[iIMF].data) THEN STOP

              H2DAvgArr[iIMF].data                 += H2DStrArr[iIMF].data
              H2DAvgArr[iIMF].grossIntegrals.day   += H2DStrArr[iIMF].grossIntegrals.day
              H2DAvgArr[iIMF].grossIntegrals.night += H2DStrArr[iIMF].grossIntegrals.night
              H2DAvgArr[iIMF].grossIntegrals.total += H2DStrArr[iIMF].grossIntegrals.total
              H2DAvgArr[iIMF].grossIntegrals.custom[0] += H2DStrArr[iIMF].grossIntegrals.custom[0]
              H2DAvgArr[iIMF].grossIntegrals.custom[1] += H2DStrArr[iIMF].grossIntegrals.custom[1]

           ENDIF ELSE BEGIN

              IF N_ELEMENTS(H2DStrArr[iIMF].data) NE N_ELEMENTS(H2DAvgArr[iIMF].data) THEN STOP
              
              H2DAvgArr[iIMF].data                 += H2DStrArr[iIMF].data/nDelay
              H2DAvgArr[iIMF].grossIntegrals.day   += H2DStrArr[iIMF].grossIntegrals.day/nDelay
              H2DAvgArr[iIMF].grossIntegrals.night += H2DStrArr[iIMF].grossIntegrals.night/nDelay
              H2DAvgArr[iIMF].grossIntegrals.total += H2DStrArr[iIMF].grossIntegrals.total/nDelay
              H2DAvgArr[iIMF].grossIntegrals.custom[0] += H2DStrArr[iIMF].grossIntegrals.custom[0]/nDelay
              H2DAvgArr[iIMF].grossIntegrals.custom[1] += H2DStrArr[iIMF].grossIntegrals.custom[1]/nDelay

           ENDELSE

           ;; H2DAvgMaskArr[iIMF].data[WHERE( ( BYTE(H2DAvgMaskArr[iIMF].data) NE 255 ) OR $
           ;;                                 ( BYTE(H2DMaskArr[iIMF].data) NE 255    ))] = 0.
           H2DAvgMaskArr[iIMF].data[WHERE( ( H2DAvgArr[iIMF].data GT 0.D )                                   OR $
                                           ( (H2DStrArr[iIMF].data GT 0.D) AND FINITE(H2DStrArr[iIMF].data)) )] = 0.

        ENDFOREACH

        ;; PRINT,H2DAvgMaskArr[4].data

     ENDFOREACH

     IF KEYWORD_SET(use_nEvents_not_nDelay_for_denom) THEN BEGIN

        FOREACH IMF,clockStrings,iIMF DO BEGIN
           
           theseInds = WHERE(H2DDivFacArr[iIMF].data NE 0.D)
           
           H2DAvgArr[iIMF].data[theseInds] /= H2DDivFacArr[iIMF].data[theseInds]

           ;; H2DAvgMaskArr[iIMF].data = 

        ENDFOREACH

     ENDIF

     IF KEYWORD_SET(save_coolFiles) THEN BEGIN
        H2DStrArr  = H2DAvgArr
        H2DMaskArr = H2DAvgMaskArr
        tempFile   = filePref + finalDelStr + fileSuff + quant + '.dat'
        PRINT,"Saving to " + tempFile + ' ...'
        IF KEYWORD_SET(use_nEvents_not_nDelay_for_denom) THEN BEGIN
           SAVE,H2DStrArr,H2DMaskArr,H2DDivFacArr,FILENAME=fileDir+tempFile
        ENDIF ELSE BEGIN
           SAVE,H2DStrArr,H2DMaskArr,FILENAME=fileDir+tempFile
        ENDELSE
     ENDIF

     H2DAvgArr_list.Add,TEMPORARY(H2DAvgArr)
     H2DAvgMaskArr_list.Add,TEMPORARY(H2DAvgMaskArr)
     DataNameArr_list.Add,TEMPORARY(dataNameArr)
  ENDFOREACH

  ;;NOW PLOTS
  IF KEYWORD_SET(makePlots) THEN BEGIN

     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF='/bonuses/'

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
   
        paramString =  filePref + finalDelStr + fileSuff + superSuff + quant
        tempFile    = fileDir + filePref + delayStr + fileSuff + quant + '.dat'
   
        PRINT,fileName + quant
        
        IF TAG_EXIST(PASIS__alfDB_plot_struct,'plotH2D_contour') AND KEYWORD_SET(kill_contour) THEN BEGIN
           PASIS__alfDB_plot_struct.plotH2D_contour = 0B
           PASIS__alfDB_plot_struct.plotH2D__kernel_density_unmask = 0B
        ENDIF

        IF ~FILE_TEST(tempFile) THEN STOP
   
        PLOT_ALFVENDB_2DHISTOS, $
           H2DSTRARR=H2DAvgArr_list[iQuant], $
           DATANAMEARR=dataNameArr_list[iQuant], $
           H2DMASKARR=H2DAvgMaskArr_list[iQuant], $
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

  ENDIF

END

