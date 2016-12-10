;2016/12/08
;The whole point of this journal is to see what happens if we change the magnitude of the current threshold, in steps of 1 to some other number
PRO JOURNAL__20161208__ZHANG_2014__TAKE_A_GOOD_LOOK_AT_THE_EFFECT_OF_CHANGING_CURRENT_THRESHOLDS

  COMPILE_OPT IDL2

  do_what_everyone_does          = 1
  IF KEYWORD_SET(do_what_everyone_does) THEN BEGIN
     @journal__20161202__zhang_2014__params_for_every_child.pro
  ENDIF

  plotPref += '-curTest'

  ;;Run ABS(current) from  1 to 10
  minMCArr                       = INDGEN(10)+1
  maxNegMCArr                    = (-1)*minMCArr

  ;;Run ABS(current) from 11 to 20
  ;; minMCArr                       = INDGEN(10)+11
  ;; maxNegMCArr                    = (-1)*minMCArr

  charE__Newell_the_cusp         = 0

  use_prev_plot_i                = 0

  group_like_plots_for_tiling    = 1
  scale_like_plots_for_tiling    = 0
  adj_upper_plotlim_thresh       = 3    ;;Check third maxima
  adj_lower_plotlim_thresh       = 2    ;;Check minima

  tile__include_IMF_arrows       = 0
  tile__cb_in_center_panel       = 1
  cb_force_oobHigh               = 1

  suppress_gridLabels            = [0,1,1, $
                                    1,1,1, $
                                    1,1,1]

  IF shiftMLT GT 0. THEN BEGIN
     plotPref += '-rotated'
  ENDIF

  ;;In any case
  reset_good_inds                 = 1
  reset_OMNI_inds                 = 1
     
  ;;bonus
  make_OMNI_stuff                 = 0
  print_avg_imf_components        = KEYWORD_SET(make_OMNI_stuff)
  print_master_OMNI_file          = KEYWORD_SET(make_OMNI_stuff)
  save_master_OMNI_inds           = KEYWORD_SET(make_OMNI_stuff)
  calc_KL_sw_coupling_func        = 1
  make_integral_savfiles          = 0

  show_integrals                  = 1
  write_obsArr_textFile           = 0
  write_obsArr__inc_IMF           = 1
  write_obsArr__orb_avg_obs       = 1
  justData                        = 0
  justInds                        = 0
  justInds_saveToFile             = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots
  ePlots                             = 1
  eNumFlPlots                        = 1
  pPlots                             = 1
  ionPlots                           = 1
  probOccurrencePlot                 = 1
  tHistDenominatorPlot               = 1
  sum_electron_and_poyntingflux      = 0
  nOrbsWithEventsPerContribOrbsPlot  = 1

  nowepco_range                  = [0,1.0]

  ;;e- energy flux
  ;; eFluxPlotType                  = 'Eflux_losscone_integ'
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [0,0.25]
  logEfPlot                      = 0
  noNegEflux                     = 0

  eNumFlPlotType                 = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  noNegENumFl                    = [1,1]
  ;; logENumFlPlot               = [1,1]
  ;; ENumFlPlotRange             = [[1e-1,1e1], $
  ;;                             [1e7,1e9]]
  logENumFlPlot                  = [0,0]
  ENumFlPlotRange                = [[0,0.25], $
                                    [0,1.0e9]]
  ;; eNumFlPlotType                 = 'ESA_Number_flux'
  ;; noNegENumFl                    = 0
  ;; logENumFlPlot                  = 0
  ;; ENumFlPlotRange                = [0,2e9]

  ;; logPfPlot                   = 1
  ;; PPlotRange                  = [1e-1,1e1]
  logPfPlot                      = 0
  PPlotRange                     = [0,0.20]

  ifluxPlotType                  = 'Integ_Up'
  noNegIflux                     = 1
  ;; logIfPlot                   = 1
  ;; IPlotRange                  = [1e6,1e8]
  logIfPlot                      = 0
  IPlotRange                     = [0,5.0e7]
  
  logProbOccurrence              = 0
  probOccurrenceRange            = [0,0.15]

  summed_eFlux_pFluxplotRange    = [0,0.1]

  tHistDenomPlotRange            = [5,80]
  ;; tHistDenomPlotNormalize        = 
  ;; tHistDenomPlotAutoscale        =      
  tHistDenomPlot_noMask          = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Southern hemi ranges
  ;; ePlotRange                     = [0,0.25]

  ;; noNegENumFl                    = [1,1]
  ;; logENumFlPlot                  = [0,0]
  ;; ENumFlPlotRange                = [[0,0.25], $
  ;;                                   [0,8.0e8]]

  ;; PPlotRange                     = [0,0.25]

  ;; IPlotRange                     = [0,7.0e7]

  ;; summed_eFlux_pFluxplotRange    = [0,0.8]

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
                                /AND_TILING_OPTIONS, $
                                GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
                                TILE_IMAGES=tile_images, $
                                TILING_ORDER=tiling_order, $
                                N_TILE_COLUMNS=n_tile_columns, $
                                N_TILE_ROWS=n_tile_rows, $
                                TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
                                TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
                                TILEPLOTSUFF=plotSuff

  FOR l=0,N_ELEMENTS(minMCArr)-1 DO BEGIN

     minMC    = minMCArr[l]
     maxNegMC = maxNegMCArr[l]
     PRINT,'******************************'
     PRINT,'Og da: ' + STRCOMPRESS(minMC,/REMOVE_ALL) + ' microA/m^2'
     PRINT,'******************************'

     FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
        altitudeRange               = altRange[*,i]
        altStr                      = STRING(FORMAT='("-",I0,"-",I0,"km-orb_",I0,"-",I0)', $
                                             altitudeRange[0], $
                                             altitudeRange[1], $
                                             orbRange[0], $
                                             orbRange[1])
        plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

        PLOT_ALFVEN_STATS_IMF_SCREENING, $
           CLOCKSTR=clockStrings, $
           MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
           SAMPLE_T_RESTRICTION=sample_t_restriction, $
           INCLUDE_32HZ=include_32Hz, $
           RESTRICT_WITH_THESE_I=restrict_with_these_i, $
           ORBRANGE=orbRange, $
           ALTITUDERANGE=altitudeRange, $
           CHARERANGE=charERange, $
           CHARE__NEWELL_THE_CUSP=charE__Newell_the_cusp, $
           POYNTRANGE=poyntRange, $
           DELAY=delayArr, $
           ;; /MULTIPLE_DELAYS, $
           RESOLUTION_DELAY=delayDeltaSec, $
           BINOFFSET_DELAY=binOffset_delay, $
           NUMORBLIM=numOrbLim, $
           MINMLT=minMLT, $
           MAXMLT=maxMLT, $
           BINMLT=binMLT, $
           SHIFTMLT=shiftMLT, $
           MINILAT=minILAT, $
           MAXILAT=maxILAT, $
           BINILAT=binILAT, $
           EQUAL_AREA_BINNING=EA_binning, $
           MIN_MAGCURRENT=minMC, $
           MAX_NEGMAGCURRENT=maxNegMC, $
           HWMAUROVAL=HwMAurOval, $
           HWMKPIND=HwMKpInd, $
           MASKMIN=maskMin, $
           THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
           ANGLELIM1=angleLim1, $
           ANGLELIM2=angleLim2, $
           BYMIN=byMin, $
           BYMAX=byMax, $
           BZMIN=bzMin, $
           BZMAX=bzMax, $
           BTMIN=btMin, $
           BTMAX=btMax, $
           BXMIN=bxMin, $
           BXMAX=bxMax, $
           DO_ABS_BYMIN=abs_byMin, $
           DO_ABS_BYMAX=abs_byMax, $
           DO_ABS_BZMIN=abs_bzMin, $
           DO_ABS_BZMAX=abs_bzMax, $
           DO_ABS_BTMIN=abs_btMin, $
           DO_ABS_BTMAX=abs_btMax, $
           DO_ABS_BXMIN=abs_bxMin, $
           DO_ABS_BXMAX=abs_bxMax, $
           ;; RUN_AROUND_THE_RING_OF_CLOCK_ANGLES=run_the_clockAngle_ring, $
           RESET_OMNI_INDS=reset_omni_inds, $
           SATELLITE=satellite, $
           OMNI_COORDS=omni_Coords, $
           PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
           PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
           SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
           MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
           CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
           HEMI=hemi, $
           STABLEIMF=stableIMF, $
           SMOOTHWINDOW=smoothWindow, $
           INCLUDENOCONSECDATA=includeNoConsecData, $
           ;; /DO_NOT_CONSIDER_IMF, $
           NONSTORM=nonStorm, $
           RECOVERYPHASE=recoveryPhase, $
           MAINPHASE=mainPhase, $
           DSTCUTOFF=dstCutoff, $
           SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
           NPLOTS=nPlots, $
           EPLOTS=ePlots, $
           EPLOTRANGE=ePlotRange, $                                       
           EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
           ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
           ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
           NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
           PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
           NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
           IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
           NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
           OXYPLOTS=oxyPlots, $
           OXYFLUXPLOTTYPE=oxyFluxPlotType, $
           LOGOXYFPLOT=logOxyfPlot, $
           ABSOXYFLUX=absOxyFlux, $
           NONEGOXYFLUX=noNegOxyFlux, $
           NOPOSOXYFLUX=noPosOxyFlux, $
           OXYPLOTRANGE=oxyPlotRange, $
           CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
           NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
           CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
           NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
           AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
           FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
           FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
           FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
           DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
           DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
           ORBCONTRIBPLOT=orbContribPlot, $
           LOGORBCONTRIBPLOT=logOrbContribPlot, $
           ORBCONTRIBRANGE=orbContribRange, $
           ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
           ORBCONTRIB_NOMASK=orbContrib_noMask, $
           ORBTOTPLOT=orbTotPlot, $
           ORBFREQPLOT=orbFreqPlot, $
           ORBTOTRANGE=orbTotRange, $
           ORBFREQRANGE=orbFreqRange, $
           NEVENTPERORBPLOT=nEventPerOrbPlot, $
           LOGNEVENTPERORB=logNEventPerOrb, $
           NEVENTPERORBRANGE=nEventPerOrbRange, $
           NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
           DIVNEVBYTOTAL=divNEvByTotal, $
           NEVENTPERMINPLOT=nEventPerMinPlot, $
           NEVENTPERMINRANGE=nEventPerMinRange, $
           LOGNEVENTPERMIN=logNEventPerMin, $
           NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
           NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
           NOWEPCO_RANGE=nowepco_range, $
           NOWEPCO_AUTOSCALE=nowepco_autoscale, $
           PROBOCCURRENCEPLOT=probOccurrencePlot, $
           PROBOCCURRENCERANGE=probOccurrenceRange, $
           LOGPROBOCCURRENCE=logProbOccurrence, $
           THISTDENOMINATORPLOT=tHistDenominatorPlot, $
           THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
           THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
           THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
           THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
           TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
           TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
           LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
           TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
           TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
           LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
           DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
           DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
           DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
           WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
           WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
           WRITE_ORB_AND_OBS__INC_IMF=write_obsArr__inc_IMF, $
           WRITE_ORB_AND_OBS__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
           DIVIDE_BY_WIDTH_X=divide_by_width_x, $
           MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
           SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
           SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
           MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
           ALL_LOGPLOTS=all_logPlots, $
           SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
           DBFILE=dbfile, $
           NO_BURSTDATA=no_burstData, $
           RESET_GOOD_INDS=reset_good_inds, $
           DATADIR=dataDir, $
           DO_CHASTDB=do_chastDB, $
           DO_DESPUNDB=do_despun, $
           COORDINATE_SYSTEM=coordinate_system, $
           USE_AACGM_COORDS=use_AACGM, $
           USE_MAG_COORDS=use_MAG, $
           NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
           NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
           NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
           WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
           SAVERAW=saveRaw, $
           SAVEDIR=saveDir, $
           JUSTDATA=justData, $
           JUSTINDS_THENQUIT=justInds, $
           JUSTINDS_SAVETOFILE=justInds_saveToFile, $
           SHOWPLOTSNOSAVE=showPlotsNoSave, $
           PLOTDIR=plotDir, $
           PLOTPREFIX=plotPrefix, $
           PLOTSUFFIX=plotSuff, $
           ORG_PLOTS_BY_FOLDER=org_plots_by_folder, $
           MEDHISTOUTDATA=medHistOutData, $
           MEDHISTOUTTXT=medHistOutTxt, $
           OUTPUTPLOTSUMMARY=outputPlotSummary, $
           DEL_PS=del_PS, $
           EPS_OUTPUT=eps_output, $
           SUPPRESS_THICKGRID=suppress_thickGrid, $
           SUPPRESS_GRIDLABELS=suppress_gridLabels, $
           SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
           SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
           SUPPRESS_MLT_NAME=suppress_MLT_name, $
           SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
           SUPPRESS_TITLES=suppress_titles, $
           OUT_TEMPFILE_LIST=out_tempFile_list, $
           OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
           OUT_PLOT_I_LIST=out_plot_i_list, $
           OUT_PARAMSTRING_LIST=out_paramString_list, $
           USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
           GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
           SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
           ADJ_UPPER_PLOTLIM=adj_upper_plotlim_thresh, $
           ADJ_LOWER_PLOTLIM=adj_lower_plotlim_thresh, $
           TILE_IMAGES=tile_images, $
           N_TILE_ROWS=n_tile_rows, $
           N_TILE_COLUMNS=n_tile_columns, $
           ;; TILEPLOTSUFFS=tilePlotSuffs, $
           TILING_ORDER=tiling_order, $
           TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
           TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
           TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
           TILEPLOTTITLE=tilePlotTitle, $
           NO_COLORBAR=no_colorbar, $
           CB_FORCE_OOBHIGH=cb_force_oobHigh, $
           CB_FORCE_OOBLOW=cb_force_oobLow, $
           PLOTH2D_CONTOUR=plotH2D_contour, $
           PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kde, $
           /MIDNIGHT, $
           FANCY_PLOTNAMES=fancy_plotNames, $
           SHOW_INTEGRALS=show_integrals, $
           MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
           MAKE_INTEGRAL_SAVFILES=make_integral_savfiles, $
           RESTORE_LAST_SESSION=restore_last_session, $
           _EXTRA=e
        ;; /GET_PLOT_I_LIST_LIST, $
        ;; /GET_PARAMSTR_LIST_LIST, $
        ;; PLOT_I_LIST_LIST=plot_i_list_list, $
        ;; PARAMSTR_LIST_LIST=paramStr_list_list
        
     ENDFOR
  ENDFOR

END


