;;2017/05/22 More 'nothers
PRO JOURNAL__20170527__VANILLA_1997__CHECKOUT_STRANGEWAY_DB

  use_prev_plot_i           = 1
  remake_prev_plot_file     = 1
  
  ;; do_timeAvg_fluxQuantities = 1
  ;; logAvgPlot                = 0
  medianPlot                = 1
  ;; divide_by_width_x         = 1

  ;; use_Lng                   = 1
  ;; use_AACGM                 = 0
  ;; use_GEI                   = 0
  ;; use_GEO                   = 1
  ;; use_MAG                   = 0

  ;; minMC                     = 1
  ;; maxnegMC                  = -1

  ;;DB stuff
  ;; do_despun                 = 0

  suppress_ILAT_labels      = 1
  autoscale_fluxPlots       = 0
  do_not_consider_IMF       = 1
  cb_force_oobHigh          = 0

  ;; dont_blackball_maximus    = 1
  ;; dont_blackball_fastloc    = 1

  show_integrals            = 1
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots

  ;; write_obsArr_textFile     = 1

  sWay_use_8Hz_DB           = 1
  ;; sWay_maxMagFlag           = 0

  ;; sWay_plotType             = ['pflux.b.DC' ,'pflux.b.AC' , $
  ;;                              'db.p.DC'    ,'db.p.AC'    , $
  ;;                              'db.v.DC'    ,'db.v.AC'    , $
  ;;                              'e.alongV.DC','e.alongV.AC']

  ;; log_swayPlot              = [0,0, $
  ;;                              0,0, $
  ;;                              0,0, $
  ;;                              0,0]

  swayPlotRange             = [[0,100],[0,4.0], $
                               [0,200],[0,3.5], $
                               [0,400],[0,3.5], $
                               [0,400],[0,3.5]]

  ;; sWay_plotType             = ['pflux.b.DC' ,'pflux.b.AC' ,'pflux.b.ACHigh', $
  ;;                              'db.p.DC'    ,'db.p.AC'    ,'db.p.ACHigh'   , $
  ;;                              'db.v.DC'    ,'db.v.AC'    ,'db.v.ACHigh'   , $
  ;;                              'e.alongV.DC','e.alongV.AC','e.alongV.ACHigh']

  ;; log_swayPlot              = [0,0, $
  ;;                              0,0, $
  ;;                              0,0, $
  ;;                              0,0]

  ;; swayPlotRange             = [[0,100],[0,4.0], $
  ;;                              [0,200],[0,3.5], $
  ;;                              [0,400],[0,3.5], $
  ;;                              [0,400],[0,3.5]]

  FOR_PFLUX = 0
  FOR_DB    = 1

  CASE 1 OF
     KEYWORD_SET(FOR_PFLUX): BEGIN
        sWay_plotType             = ['pflux.b.DC' ,'pflux.b.AC' ,'pflux.b.ACHigh','pFlux.B.ACBoth']

        log_swayPlot              = [0,0,0]

        swayPlotRange             = [[0,100],[0,4.0],[0,4.0]]
        ;; [0,200],[0,3.5], $
        ;; [0,400],[0,3.5], $
        ;; [0,400],[0,3.5]]
        CASE 1 OF
           KEYWORD_SET(medianPlot) AND ((WHERE(log_swayPlot EQ 1))[0] EQ -1): BEGIN

              swayPlotRange       = [[0,4.3],[0,0.1],[0,0.1]] ; $
              ;; [0,70],[0,1.7], $
              ;; [0,70],[0,1.7], $
              ;; [0,31],[0,10.5]]

           END
           ELSE:
        ENDCASE

     END
     KEYWORD_SET(FOR_DB): BEGIN
        sWay_plotType             = ['dB.p.DC' ,'dB.p.AC' ,'dB.p.ACHigh','dB.p.ACBoth', $
                                     'dB.v.DC' ,'dB.v.AC' ,'dB.v.ACHigh','dB.v.ACBoth']

        log_swayPlot              = [0,0,0, $
                                     0,0,0]

        swayPlotRange             = [[0,55],[0,1.8],[0,0.7],  $
                                     [0,65],[0,1.4],[0,0.55]]


     END
  ENDCASE

  ;;loggers
  ;; log_swayPlot              = [1,1, $
  ;;                              1,0, $
  ;;                              1,0]
  ;; log_swayPlot              = REPLICATE(1,6)

  ;; swayPlotRange             = [[1D0,1D3],[1D-2,1D1], $
  ;;                              ;; [1D0,1D3],[1D-2,1D1], $
  ;;                              ;; [1D0,1D3],[1D-2,1D1]]
  ;;                              [1D0,1D3],[0,3.5], $
  ;;                              [1D0,1D3],[0,3.5]]

  ;; noNeg_sWay                = 1
  abs_sWay                  = 1
  ;; noPos_sWay                = 1

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

  altRange                       = [[750,4300]]

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

  @common__strangeway_bands.pro
  IF N_ELEMENTS(SWAY__DB) EQ 0 THEN BEGIN
     LOAD_STRANGEWAY_BANDS_PFLUX_DB, $
        USE_8HZ_DB=sWay_use_8Hz_DB, $
        ;; GOOD_I=good_i, $
        ;; DBDir=DBDir, $
        ;; DBFile=DBFile, $
        ;; CORRECT_FLUXES=correct_fluxes, $
        ;; DO_NOT_MAP_PFLUX=do_not_map_pflux, $
        ;; DO_NOT_MAP_IONFLUX=do_not_map_ionflux, $
        ;; DO_NOT_MAP_ANYTHING=no_mapping, $
        ;; COORDINATE_SYSTEM=coordinate_system, $
        ;; USE_LNG=use_lng, $
        ;; USE_AACGM_COORDS=use_AACGM, $
        ;; USE_GEI_COORDS=use_GEI, $
        ;; USE_GEO_COORDS=use_GEO, $
        ;; USE_MAG_COORDS=use_MAG, $
        ;; USE_SDT_COORDS=use_SDT, $
        ;; CHECK_DB=check_DB, $
        LUN=lun
  ENDIF
  orbRange     = [MIN(SWAY__DB.orbit[WHERE(SWAY__DB.time GE t1)]), $
                  MAX(SWAY__DB.orbit[WHERE(SWAY__DB.time LE t2)])]
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
  ;; maskMin                        = 10
  ;; tHist_mask_bins_below_thresh   = 5

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange            = altRange[*,i]
     altStr                   = STRING(FORMAT='("--",I0,"-",I0)', $
                                       altitudeRange[0], $
                                       altitudeRange[1])

     plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

     PLOT_ALFVEN_STATS__SETUP, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
        FOR_ION_DBS=for_ion_DBs, $
        FOR_SWAY_DB=for_sWay_DB, $
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
        ABS_SWAY=abs_sWay, $
        NONEGCHARE=noNegCharE, $
        NONEGCHARIE=noNegCharie, $
        NONEGEFLUX=noNegEflux, $
        NONEGENUMFL=noNegENumFl, $
        NONEGIFLUX=noNegIflux, $
        NONEGMAGC=noNegMagC, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NONEGPFLUX=noNegPflux, $
        NONEG_SWAY=noNeg_sWay, $
        NOPOSCHARE=noPosCharE, $
        NOPOSCHARIE=noPosCharie, $
        NOPOSEFLUX=noPosEFlux, $
        NOPOSENUMFL=noPosENumFl, $
        NOPOSIFLUX=noPosIflux, $
        NOPOSMAGC=noPosMagC, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        NOPOSPFLUX=noPosPflux, $
        NOPOS_SWAY=noPos_sWay, $
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
        SWAY_PLOTTYPE=sWay_plotType, $
        LOG_SWAYPLOT=log_swayPlot, $
        SWAYPLOT_AUTOSCALE=swayPlot_autoScale, $
        SWAYPLOTRANGE=swayPlotRange, $
        SWAY_MAXMAGFLAG=sWay_maxMagFlag, $
        SWAY_USE_8HZ_DB=sWay_use_8Hz_DB, $
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


