PRO JOURNAL__20170123__ZHANG_2014__TIMEAVG__ALFS_IMF__FINISH_HIM

  COMPILE_OPT IDL2

  use_prev_plot_i                = 1
  remake_prev_plot_file          = 0

  do_what_everyone_does    = 1

  plotH2D_contour          = 1
  ;; plotH2D__kde          = 1
  plotH2D__kde             = KEYWORD_SET(plotH2D_contour)
  contour__levels          = KEYWORD_SET(plotH2D_contour) ? [0,20,40,60,80,100] : !NULL
  contour__percent         = KEYWORD_SET(plotH2D_contour)

  IF KEYWORD_SET(do_what_everyone_does) THEN BEGIN
     @journal__20170123__zhang_2014__params_for_finishing_him.pro
  ENDIF

  ;; latest_UTC            = STR_TO_TIME('1999-05-16/03:20:59.853')

  labels_for_presentation  = 1

  plotPref += '--upto90ILAT'
  ;; plotPref += ''

  minM_c    = [ 6,12]
  maxM_c    = [12,18]
  minI_c    = [70,70]
  maxI_c    = [90,90]

  include_32Hz                   = 0
  EA_binning                     = 0
  use_AACGM                      = 0


  fluxPlots__invert_Newell_the_cusp = 0
  fluxPlots__Newell_the_cusp     = 1
  fluxPlots__broadband_everywhar = 0
  fluxPlots__diffuse_everywhar   = 0

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

  IF shiftM GT 0. THEN BEGIN
     plotPref += 'rotated-'
  ENDIF

  ;;In any case
  reset_good_inds                 = 1
  reset_OMNI_inds                 = 1
     
  ;;bonus
  make_OMNI_stuff                 = 0
  ;; print_avg_imf_components        = KEYWORD_SET(make_OMNI_stuff)
  ;; print_master_OMNI_file          = KEYWORD_SET(make_OMNI_stuff)
  save_master_OMNI_inds           = KEYWORD_SET(make_OMNI_stuff)
  make_OMNI_stats_savFile         = KEYWORD_SET(make_OMNI_stuff)
  OMNI_statsSavFilePref           = 'Alfvens_dodat_'+GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  calc_KL_sw_coupling_func        = 1
  make_integral_savfiles          = 0

  show_integrals                  = 1
  write_obsArr_textFile           = 0
  write_obsArr__inc_IMF           = 1
  write_obsArr__orb_avg_obs       = 1
  justData                        = 0
  justInds                        = 0
  indsPref                        = ''
  CASE 1 OF
     KEYWORD_SET(fluxPlots__invert_Newell_the_cusp): BEGIN
        indsPref = 'invNC'
     END
     KEYWORD_SET(fluxPlots__Newell_the_cusp       ): BEGIN  
        indsPref = 'NC'
     END
     KEYWORD_SET(fluxPlots__broadband_everywhar   ): BEGIN  
        indsPref = 'broadEvry'
     END
     KEYWORD_SET(fluxPlots__diffuse_everywhar     ): BEGIN 
        indsPref = 'diffEvry'
     END
     ELSE: BEGIN
        indsPref = ''
     END
  ENDCASE

  justInds_saveToFile             = 'Alfvens_IMF-inds-' + indsPref + '-' + $
                                    STRLOWCASE(hemi) + '_hemi-' + $
                                    GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + $
                                    '.sav'
                                    ;; '_hemi--20161224.sav'
  saveDir                         = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170209/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots
  besides_pFlux                      = 1
  ePlots                             = besides_pFlux
  eNumFlPlots                        = besides_pFlux
  pPlots                             = 1
  ionPlots                           = besides_pFlux
  ;; probOccurrencePlot                 = besides_pFlux
  tHistDenominatorPlot               = 1 ;besides_pFlux
  sum_electron_and_poyntingflux      = 0
  nOrbsWithEventsPerContribOrbsPlot  = 0

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
  ;; PPlotRange                     = [0,0.20]
  PPlotRange                     = KEYWORD_SET(plotH2D_contour) ? [0,0.20] : [0,0.20]

  ifluxPlotType                  = 'Integ_Up'
  noNegIflux                     = 1
  ;; logIfPlot                   = 1
  ;; IPlotRange                  = [1e6,1e8]
  logIfPlot                      = 0
  IPlotRange                     = [0,5.0e7]
  
  logProbOccurrence              = 0
  probOccurrenceRange            = [0,0.15]

  summed_eFlux_pFluxplotRange    = [0,0.5]

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

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange               = altRange[*,i]
     altStr                      = STRING(FORMAT='(I0,"-",I0,"km-orb_",I0,"-",I0)', $
                                          altitudeRange[0], $
                                          altitudeRange[1], $
                                          orbRange[0], $
                                          orbRange[1])
     plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

     IF KEYWORD_SET(grossRate_info_file_pref) THEN BEGIN
        CASE 1 OF
           N_ELEMENTS(btMin) GT 0: BEGIN
              IF btMin GT 0 THEN BEGIN
                 grossRate_infos  = STRING(FORMAT='("-btMin",F0.1)',btMin)
              ENDIF
           END
           N_ELEMENTS(btMax) GT 0: BEGIN
              grossRate_infos  = STRING(FORMAT='("-btMax",F0.1)',btMax)
           END
           ELSE: BEGIN
              grossRate_infos  = ''
           END
        ENDCASE

        grossRate_infos       += '_' + hemi 
        grossRate_info_file    = grossRate_info_file_pref + grossRate_infos + $
                                 grossRate_info_file_suff + '.txt'
     ENDIF

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


     PLOT_ALFVEN_STATS__SETUP, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
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
        POYNTRANGE=poyntRange, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        INCLUDE_32HZ=include_32Hz, $
        DISREGARD_SAMPLE_T=disregard_sample_t, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
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
        USE_AACGM_COORDS=use_AACGM, $
        USE_MAG_COORDS=use_MAG, $
        LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
        LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
        LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
        HEMI=hemi, $
        NORTH=north, $
        SOUTH=south, $
        BOTH_HEMIS=both_hemis, $
        DAYSIDE=dayside, $
        NIGHTSIDE=nightside, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
        FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
        FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
        FLUXPLOTS__INVERT_NEWELL_THE_CUSP=fluxPlots__invert_Newell_the_cusp, $
        FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
        FLUXPLOTS__BROADBAND_EVERYWHAR=fluxPlots__broadband_everywhar, $
        FLUXPLOTS__DIFFUSE_EVERYWHAR=fluxPlots__diffuse_everywhar, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
        ORBCONTRIBPLOT=orbContribPlot, $
        ORBTOTPLOT=orbTotPlot, $
        ORBFREQPLOT=orbFreqPlot, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        SQUAREPLOT=squarePlot, $
        POLARCONTOUR=polarContour, $ 
        MEDIANPLOT=medianPlot, $
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
        CUSTOM_INTEGRAL_STRUCT=custom_integral_struct, $
        CONTOUR__LEVELS=contour__levels, $
        CONTOUR__PERCENT=contour__percent, $
        PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kde, $
        HOYDIA=hoyDia, $
        LUN=lun, $
        NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
        ESPEC__NO_MAXIMUS=no_maximus, $
        ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
        ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
        ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
        ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
        ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
        ESPEC__NOMAPTO100KM=eSpec__noMap, $
        ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
        ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
        ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
        NONSTORM=nonStorm, $
        RECOVERYPHASE=recoveryPhase, $
        MAINPHASE=mainPhase, $
        ALL_STORM_PHASES=all_storm_phases, $
        DSTCUTOFF=dstCutoff, $
        SMOOTH_DST=smooth_dst, $
        USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
        USE_AE=use_ae, $
        USE_AU=use_au, $
        USE_AL=use_al, $
        USE_AO=use_ao, $
        AECUTOFF=AEcutoff, $
        SMOOTH_AE=smooth_AE, $
        AE_HIGH=AE_high, $
        AE_LOW=AE_low, $
        AE_BOTH=AE_both, $
        USE_MOSTRECENT_AE_FILES=use_mostRecent_AE_files, $
        CLOCKSTR=clockStrings, $
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
        BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
        BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
        BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
        DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
        OMNIPARAMSTR=OMNIparamStr, $
        OMNI_PARAMSTR_LIST=OMNIparamStr_list, $
        SATELLITE=satellite, $
        OMNI_COORDS=omni_Coords, $
        DELAY=delayArr, $
        MULTIPLE_DELAYS=multiple_delays, $
        MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
        OUT_EXECUTING_MULTIPLES=executing_multiples, $
        OUT_MULTIPLES=multiples, $
        OUT_MULTISTRING=multiString, $
        RESOLUTION_DELAY=delayDeltaSec, $
        BINOFFSET_DELAY=binOffset_delay, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        EARLIEST_UTC=earliest_UTC, $
        LATEST_UTC=latest_UTC, $
        EARLIEST_JULDAY=earliest_julDay, $
        LATEST_JULDAY=latest_julDay, $
        SHOW_INTEGRALS=show_integrals, $
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
        CHAREPLOTRANGE=charePlotRange, $
        CHARIEPLOTRANGE=chariEPlotRange, $
        EPLOTRANGE=EPlotRange, $
        ENUMFLPLOTRANGE=ENumFlPlotRange, $
        ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
        ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
        IPLOTRANGE=IPlotRange, $
        MAGCPLOTRANGE=magCPlotRange, $
        NEVENTPERMINRANGE=nEventPerMinRange, $
        NEVENTPERORBRANGE=nEventPerOrbRange, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        NEWELL_PLOTRANGE=newell_plotRange, $
        NOWEPCO_RANGE=nowepco_range, $
        ORBCONTRIBRANGE=orbContribRange, $
        ORBFREQRANGE=orbFreqRange, $
        ORBTOTRANGE=orbTotRange, $
        OXYPLOTRANGE=oxyPlotRange, $
        PPLOTRANGE=PPlotRange, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
        RESET_STRUCT=reset

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
        NEED_FASTLOC_I=need_fastLoc_i, $
        USE_STORM_STUFF=use_storm_stuff, $
        AE_STUFF=ae_stuff, $    
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        IMF_STRUCT=IMF_struct, $
        MIMC_STRUCT=MIMC_struct, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        RESET_OMNI_INDS=reset_omni_inds, $
        PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
        PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
        SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
        MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
        OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
        CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
        FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
        FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
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
        COORDINATE_SYSTEM=coordinate_system, $
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, $
        SAVEDIR=saveDir, $
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
        LABELS_FOR_PRESENTATION=labels_for_presentation, $
        OUT_TEMPFILE_LIST=out_tempFile_list, $
        OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
        OUT_PLOT_I_LIST=out_plot_i_list, $
        OUT_PARAMSTRING_LIST=out_paramString_list, $
        USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
        REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_file, $
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
        FANCY_PLOTNAMES=fancy_plotNames
        ;; MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
        ;; MAKE_INTEGRAL_SAVFILES=make_integral_savfiles

     ;; /GET_PLOT_I_LIST_LIST, $
     ;; /GET_PARAMSTR_LIST_LIST, $
     ;; PLOT_I_LIST_LIST=plot_i_list_list, $
     ;; PARAMSTR_LIST_LIST=paramStr_list_list
     
  ENDFOR

END


