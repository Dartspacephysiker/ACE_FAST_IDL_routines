;;2017/02/02 More 'nothers
PRO JOURNAL__20170202__VANILLA_TAVG_OR_LOGAVG_PFLUX__TEST_GEI_GEO_MAG_COORDS

  use_prev_plot_i           = 1
  remake_prev_plot_file     = 0
  
  do_timeAvg_fluxQuantities = 1
  logAvgPlot                = 0
  medianPlot                = 0
  divide_by_width_x         = 1

  include_32Hz              = 0
  use_Lng                   = 0
  use_AACGM                 = 1
  use_GEI                   = 0
  use_GEO                   = 0
  use_MAG                   = 0

  minMC                     = 1
  maxnegMC                  = -1

  ;;DB stuff
  do_despun                 = 0

  suppress_ILAT_labels      = 1
  fancyPresentationMode     = 1

  autoscale_fluxPlots       = 0

  do_not_consider_IMF       = 1

  cb_force_oobHigh          = 0

  dont_blackball_maximus    = 1
  dont_blackball_fastloc    = 1

  show_integrals            = 0
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots

  ;; ePlots                         = 0
  eNumFlPlots                    = 1
  pPlots                         = 1
  nOrbsWithEventsPerContribOrbsPlot = 0
  ;; ionPlots                       = 0
  probOccurrencePlot             = 0
  sum_electron_and_poyntingflux  = 1
  ;; tHistDenominatorPlot           = 0

  nowepco_range                  = [0,0.5]
  nowepco_autoscale              = 0

  ;;e- energy flux
  ;; eFluxPlotType                  = 'Eflux_losscone_integ'
  ;; eFluxPlotType                  = 'Max'
  ;; ePlotRange                     = [0,1]
  ;; logEfPlot                      = 0
  ;; noNegEflux                     = 0

  eNumFlPlotType                 = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  noNegENumFl                    = [1,1]
  ;; logENumFlPlot                  = [1,1]
  ;; ENumFlPlotRange                = [[1e-1,1e1], $
  ;;                                   [1e7,1e9]]
  logENumFlPlot                  = [0,0]
  ENumFlPlotRange                = [[0,0.25], $
                                    [0,1e9]]
  ;; eNumFlPlotType                 = 'ESA_Number_flux'
  ;; noNegENumFl                    = 0
  ;; logENumFlPlot                  = 0
  ;; ENumFlPlotRange                = [0,2e9]

  ;; logPfPlot                   = 1
  ;; PPlotRange                  = [0.05,50.0]
  CASE 1 OF
     KEYWORD_SET(do_timeAvg_fluxQuantities): BEGIN
        logPfPlot   = 0
        PPlotRange  = [0.00,0.15]
     END
     KEYWORD_SET(logAvgPlot): BEGIN
        logPfPlot   = 0
        PPlotRange  = [0.00,1.1]
     END
     ELSE: BEGIN
     END
  ENDCASE

  ifluxPlotType                  = 'Integ_Up'
  noNegIflux                     = 1
  ;; logIfPlot                   = 1
  ;; IPlotRange                  = [1e6,1e8]
  logIfPlot                      = 0
  IPlotRange                     = [0,3e8]
  
  ;; logProbOccurrence              = 1
  ;; probOccurrenceRange            = [0.001,0.1]
  logProbOccurrence              = 0
  probOccurrenceRange            = [0.0,0.5]

  summed_eFlux_pFluxplotRange    = [0,0.4]
  
  ;; tHistDenomPlotRange            = 
  ;; tHistDenomPlotNormalize        = 
  tHistDenomPlotAutoscale        = 1
  tHistDenomPlot_noMask          = 1

  ;;Otros
  reset_good_inds                = 1
  reset_omni_inds                = 1

  ;; altRange                    = [[340,1180], $
  ;;                             [1180,2180], $
  ;;                             [2180,3180], $
  ;;                             [3180,4180]]

  ;; altRange                       = [[340,4180]]

  ;; altRange                       = [[500,4300], $
  ;;                                   [600,4300], $
  ;;                                   [700,4300], $
  ;;                                   [800,4300], $
  ;;                                   [900,4300], $
  ;;                                   [1000,4300]]

  altRange                       = [[300,4300]]

  ;;A more involved method for getting the correct orbits ...
  ;; orbRange                       = [500,12670]

  jahr         = '1997'
  ;; jahr      = '1998'
  t1Str        = jahr + '-01-01/00:00:00.000'
  t2Str        = jahr + '-12-31/23:59:59.999'

  ;; jahr      = '1999'
  ;; t1Str     = jahr + '-01-01/00:00:00.000'
  ;; t2Str     = jahr + '-11-02/23:59:59.999'

  t1           = STR_TO_TIME(t1Str)
  t2           = STR_TO_TIME(t2Str)

  plotPref     = 'just_' + jahr

  @common__maximus_vars.pro
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME, $
        DESPUNDB=despun, $
        USE_LNG=use_lng, $
        USE_AACGM=use_AACGM, $
        USE_GEI=use_GEI, $
        USE_GEO=use_GEO, $
        USE_MAG=use_MAG;; , $
        ;; /NO_MEMORY_LOAD
  ENDIF
  orbRange     = [MIN(MAXIMUS__maximus.orbit[WHERE(MAXIMUS__times GE t1)]), $
                  MAX(MAXIMUS__maximus.orbit[WHERE(MAXIMUS__times LE t2)])]
  ;; maximus      = !NULL
  ;; cdbTime      = !NULL
  ;; orbRange  = [1000,10800]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                        = 'NORTH'
  minI                        = 60
  maxI                        = 90

  ;; hemi                        = 'GLOBE'
  ;; minI                        = -90
  ;; maxI                        = 90
  ;; map_projection              = 'ROBINSON'

  ;; hemi                        = 'SOUTH'
  ;; minILAT                     = -90
  ;; maxILAT                     = -60

  ;; binILAT                     = 2.0
  binI                        = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binM                         = 0.75
  shiftM                       = 0.0

  ;; minMLT                      = 6
  ;; maxMLT                      = 18

  ;;Bonus
  ;; maskMin                        = 8
  ;; tHist_mask_bins_below_thresh   = 5

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange               = altRange[*,i]
     altStr                      = STRING(FORMAT='("--",I0,"-",I0)', $
                            altitudeRange[0], $
                            altitudeRange[1])

     plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

     PLOT_ALFVEN_STATS__SETUP, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
        FOR_ION_DBS=for_ion_DBs, $
        NEED_FASTLOC_I=need_fastLoc_i, $
        USE_STORM_STUFF=use_storm_stuff, $
        AE_STUFF=ae_stuff, $    
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        IMF_STRUCT=IMF_struct, $
        MIMC_STRUCT=MIMC_struct, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        CHARE__NEWELL_THE_CUSP=charE__Newell_the_cusp, $
        POYNTRANGE=poyntRange, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        INCLUDE_32HZ=include_32Hz, $
        DISREGARD_SAMPLE_T=disregard_sample_t, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
        DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
        DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
        MINMLT=minM,MAXMLT=maxM, $
        BINMLT=binM, $
        SHIFTMLT=shiftM, $
        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
        EQUAL_AREA_BINNING=EA_binning, $
        DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
        REVERSE_LSHELL=reverse_lShell, $
        MIN_MAGCURRENT=minMC, $
        MAX_NEGMAGCURRENT=maxNegMC, $
        HWMAUROVAL=HwMAurOval, $
        HWMKPIND=HwMKpInd, $
        MASKMIN=maskMin, $
        THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
        DESPUNDB=despunDB, $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_LNG=use_Lng, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_GEI_COORDS=use_GEI, $
        USE_GEO_COORDS=use_GEO, $
        USE_MAG_COORDS=use_MAG, $
        LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
        LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
        LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
        HEMI=hemi, $
        NORTH=north, $
        SOUTH=south, $
        BOTH_HEMIS=both_hemis, $
        GLOBE=globe, $
        MAP_PROJECTION=map_projection, $
        DAYSIDE=dayside, $
        NIGHTSIDE=nightside, $
        NPLOTS=nPlots, $
        EPLOTS=ePlots, $
        EFLUXPLOTTYPE=eFluxPlotType, $
        ENUMFLPLOTS=eNumFlPlots, $
        ENUMFLPLOTTYPE=eNumFlPlotType, $
        PPLOTS=pPlots, $
        IONPLOTS=ionPlots, $
        IFLUXPLOTTYPE=ifluxPlotType, $
        CHAREPLOTS=charEPlots, $
        CHARETYPE=charEType, $
        CHARIEPLOTS=chariEPlots, $
        MAGCPLOTS=magCPlots, $
        ABSCHARE=absCharE, $
        ABSCHARIE=absCharie, $
        ABSEFLUX=abseflux, $
        ABSENUMFL=absENumFl, $
        ABSIFLUX=absIflux, $
        ABSMAGC=absMagC, $
        ABSOXYFLUX=absOxyFlux, $
        ABSPFLUX=absPflux, $
        NONEGCHARE=noNegCharE, $
        NONEGCHARIE=noNegCharie, $
        NONEGEFLUX=noNegEflux, $
        NONEGENUMFL=noNegENumFl, $
        NONEGIFLUX=noNegIflux, $
        NONEGMAGC=noNegMagC, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NONEGPFLUX=noNegPflux, $
        NOPOSCHARE=noPosCharE, $
        NOPOSCHARIE=noPosCharie, $
        NOPOSEFLUX=noPosEFlux, $
        NOPOSENUMFL=noPosENumFl, $
        NOPOSIFLUX=noPosIflux, $
        NOPOSMAGC=noPosMagC, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        NOPOSPFLUX=noPosPflux, $
        LOGCHAREPLOT=logCharEPlot, $
        LOGCHARIEPLOT=logChariePlot, $
        LOGEFPLOT=logEfPlot, $
        LOGENUMFLPLOT=logENumFlPlot, $
        LOGIFPLOT=logIfPlot, $
        LOGMAGCPLOT=logMagCPlot, $
        LOGNEVENTPERMIN=logNEventPerMin, $
        LOGNEVENTPERORB=logNEventPerOrb, $
        LOGNEVENTSPLOT=logNEventsPlot, $
        LOGORBCONTRIBPLOT=logOrbContribPlot, $
        LOGOXYFPLOT=logOxyfPlot, $
        LOGPFPLOT=logPFPlot, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
        LOG_NEWELLPLOT=log_newellPlot, $
        LOG_NOWEPCOPLOT=log_nowepcoPlot, $
        FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
        FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
        FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
        FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
        ORBCONTRIBPLOT=orbContribPlot, $
        ORBTOTPLOT=orbTotPlot, $
        ORBFREQPLOT=orbFreqPlot, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        THISTDENOMINATORPLOT=tHistDenominatorPlot, $
        SQUAREPLOT=squarePlot, $
        POLARCONTOUR=polarContour, $ 
        MEDIANPLOT=medianPlot, $
        MAXPLOT=maxPlot, $
        MINPLOT=minPlot, $
        LOGAVGPLOT=logAvgPlot, $
        PLOTMEDORAVG=plotMedOrAvg, $
        DATADIR=dataDir, $
        NO_BURSTDATA=no_burstData, $
        WRITEASCII=writeASCII, $
        WRITEHDF5=writeHDF5, $
        WRITEPROCESSEDH2D=writeProcessedH2D, $
        SAVERAW=saveRaw, $
        SAVEDIR=saveDir, $
        JUSTDATA=justData, $
        JUSTINDS_THENQUIT=justInds, $
        JUSTINDS_SAVETOFILE=justInds_saveToFile, $
        SHOWPLOTSNOSAVE=showPlotsNoSave, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        KEEPME=keepMe, $
        PARAMSTRING=paramString, $
        PARAMSTRPREFIX=plotPrefix, $
        PARAMSTRSUFFIX=plotSuffix,$
        PLOTH2D_CONTOUR=plotH2D_contour, $
        PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
        HOYDIA=hoyDia, $
        LUN=lun, $
        NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
        NEWELL__COMBINE_ACCELERATED=Newell__combine_accelerated, $
        USE_MOSTRECENT_AE_FILES=use_mostRecent_AE_files, $
        CLOCKSTR=clockStr, $
        DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
        OMNIPARAMSTR=OMNIparamStr, $
        OMNI_PARAMSTR_LIST=OMNIparamStr_list, $
        SATELLITE=satellite, $
        OMNI_COORDS=omni_Coords, $
        DELAY=delay, $
        MULTIPLE_DELAYS=multiple_delays, $
        MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
        OUT_EXECUTING_MULTIPLES=executing_multiples, $
        OUT_MULTIPLES=multiples, $
        OUT_MULTISTRING=multiString, $
        RESOLUTION_DELAY=delay_res, $
        BINOFFSET_DELAY=binOffset_delay, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        EARLIEST_UTC=earliest_UTC, $
        LATEST_UTC=latest_UTC, $
        EARLIEST_JULDAY=earliest_julDay, $
        LATEST_JULDAY=latest_julDay, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
        ALL_LOGPLOTS=all_logPlots,$
        CHAREPLOTRANGE=charePlotRange, $
        CHARIEPLOTRANGE=chariEPlotRange, $
        EPLOTRANGE=EPlotRange, $
        ENUMFLPLOTRANGE=ENumFlPlotRange, $
        PPLOTRANGE=PPlotRange, $
        MAGCPLOTRANGE=magCPlotRange, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        _REF_EXTRA=e, $
        RESET_STRUCT=reset

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
        NEED_FASTLOC_I=need_fastLoc_i, $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        IMF_STRUCT=IMF_struct, $
        MIMC_STRUCT=MIMC_struct, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        MASKMIN=maskMin, $
        THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
        RESET_OMNI_INDS=reset_omni_inds, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
        NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
        NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
        DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
        DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
        ORBCONTRIBPLOT=orbContribPlot, $
        LOGORBCONTRIBPLOT=logOrbContribPlot, $
        WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
        WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
        WRITE_ORB_AND_OBS__INC_IMF=write_obsArr__inc_IMF, $
        WRITE_ORB_AND_OBS__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
        ADD_VARIANCE_PLOTS=add_variance_plots, $
        ONLY_VARIANCE_PLOTS=only_variance_plots, $
        VAR__PLOTRANGE=var__plotRange, $
        VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
        VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
        VAR__AUTOSCALE=var__autoscale, $
        SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
        SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
        SUMMED_EFLUX_PFLUX_LOGPLOT=summed_eFlux_pFlux_logPlot, $
        MEDIANPLOT=medianPlot, $
        LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots, $
        SQUAREPLOT=squarePlot, $
        POLARCONTOUR=polarContour, $
        DBFILE=dbfile, $
        RESET_GOOD_INDS=reset_good_inds, $
        NO_BURSTDATA=no_burstData, $
        DATADIR=dataDir, $
        COORDINATE_SYSTEM=coordinate_system, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        PLOTPREFIX=plotPrefix, $
        SUFFIX_TXTDIR=suffix_txtDir, $
        ;; SUPPRESS_THICKGRID=fancyPresentationMode, $
        SUPPRESS_GRIDLABELS=fancyPresentationMode, $
        SUPPRESS_MLT_LABELS=fancyPresentationMode, $
        SUPPRESS_ILAT_LABELS=fancyPresentationMode, $
        SUPPRESS_MLT_NAME=suppress_MLT_name, $
        SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
        SUPPRESS_TITLES=fancyPresentationMode, $
        LABELS_FOR_PRESENTATION=fancyPresentationMode, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        TILING_ORDER=tiling_order, $
        TILE__FAVOR_ROWS=tile__favor_rows, $
        TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
        TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
        TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
        GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
        SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
        TILEPLOTSUFF=tilePlotSuff, $
        TILEPLOTTITLE=tilePlotTitle, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
        REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_file

  
  ENDFOR

END


