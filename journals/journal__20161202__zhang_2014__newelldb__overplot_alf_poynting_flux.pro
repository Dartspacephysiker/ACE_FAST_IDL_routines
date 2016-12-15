;;2016/12/02 Overplot broadband number flux with Alfvénic Poynting flux
PRO JOURNAL__20161202__ZHANG_2014__NEWELLDB__OVERPLOT_ALF_POYNTING_FLUX
  COMPILE_OPT IDL2

  ;; plotPref = '-atest_teste-MAPPE-cb' 
  ;; plotPref = 'rightnow-' 
  plotPref = 'NO_OP-'
  ;; plotPref = 'NO_OP_2_NC-'
  plotPref = 'MAITRE-'

  labels_for_presentation        = 1

  restore_last_session           = 0
  use_prev_plot_i                = 1

  nonstorm                       = 1
  DSTcutoff                      = -40
  smooth_dst                     = 0
  use_mostRecent_Dst_files       = 1

  @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

  ;; include_32Hz                   = 
  ;; sample_t_restriction           = 10
  disregard_sample_t             = 1

  show_integrals                 = 0

  EA_binning                     = 0
  plotH2D_contour                = 1
  plotH2D__kde                   = KEYWORD_SET(plotH2D_contour)

  ;; contour__levels                = [20,40,60,80,95]
  ;; contour__levels                = [1,30,60,90]
  ;; contour__levels                = [0,20,50,80]
  ;; contour__levels                = [0,20,40,60,80,95]

  ;; contour__levels                = [10,30,40,60,70,90]
  ;; contour__levels                = [20,30,50,60,80,90]
  contour__levels                = KEYWORD_SET(plotH2D_contour) ? [20,30,50,60,80,90,100] : !NULL
  ;; contour__levels                = KEYWORD_SET(plotH2D_contour) ? [0,20,40,60,80,100] : !NULL
  ;; plotPref += STRING(FORMAT='("-",20(I0,:,"_"))',contour__levels)
  contour__percent               = KEYWORD_SET(plotH2D_contour) ? 1 : !NULL

  ;; minMC                          = 5
  ;; maxNegMC                       = -5

  do_timeAvg_fluxQuantities      = 1
  logAvgPlot                     = 0
  medianPlot                     = 0
  divide_by_width_x              = 1

  ;; write_obsArr_textFile          = 1
  ;; write_obsArr__inc_IMF          = 1
  ;; write_obsArr__orb_avg_obs      = 1
  ;; justData                       = 1

  ;;DB stuff
  do_despun                      = 0
  use_AACGM                      = 0
  use_MAG                        = 0

  autoscale_fluxPlots            = 0
  fluxPlots__remove_outliers     = 0
  fluxPlots__remove_log_outliers = 0
  
  ;; dont_blackball_maximus         = 
  ;; dont_blackball_fastloc         = 0

  group_like_plots_for_tiling    = 1
  scale_like_plots_for_tiling    = 0
  adj_upper_plotlim_thresh       = 3 ;;Check third maxima
  adj_lower_plotlim_thresh       = 2 ;;Check minima

  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161202/Alfvenic_pFlux--overplot_data.dat'
  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161203/Dst_-40sm-300-4300km-NC-avg-cont30.0Res_0.0Offset_btMin0.5--Ring_timeAvgd_pFlux.dat'
  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161203/Dst_-50300-4300km-0rb_1000_10600-NORTH-cur_-1-1-NC-avg--4stable_20Res_btMin1.0--pFlux.dat'
  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161205/pFlux_rotated.dat'
  ;; plotPref += '-rot_pFlux-t'
  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161206/pFlux-mappedAll-rot.dat'
  ;; plotPref += '-allMapped'

  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161207/rightnow.dat'
  ;; plotPref += '-allMapped'
  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161205/pFlux.dat'
  ;; plotPref += '-notRot_pFlux-t'

  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161210/Dst_-40customKill_8276-500-4300km-orb_1000-10600-NORTH-cur_-1-1-NC__pFlux.dat'

  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161212/pFlux_stuffSunday.dat'

  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161212/pFlux_stuffSunday2.dat'

  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161212/pFlux_stuffSunday2_NC.dat'

  overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161213/pFlux.dat'

  overplot_arr                   = [['*enumflux_espec*broad*','*timeavgd_pflux*'], $
                                    ['*enumflux_espec*mono*' ,'*timeavgd_pflux*'], $
                                    ['*enumflux_espec*accel*','*timeavgd_pflux*']]
  ;; op_contour__levels             = [20,50,80]
  op_contour__levels             = [10,40,70]
  plotPref                      += STRING(FORMAT='("-op_",20(I0,:,"_"))',op_contour__levels)
  op_contour__percent            = 1
  op_plotRange                   = [0.00,0.10]


  tile__include_IMF_arrows       = KEYWORD_SET(plotH2D_contour) ? 0 : 1
  tile__cb_in_center_panel       = 1
  cb_force_oobHigh               = 1

  suppress_gridLabels            = [0,1,1, $
                                    1,1,1, $
                                    1,1,1]

  ;;bonus
  print_avg_imf_components       = 0
  print_master_OMNI_file         = 0
  save_master_OMNI_inds          = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots
  no_maximus                     = 1
  eSpec_flux_plots               = 1
  Newell_analyze_eFlux           = 1
  eSpec__all_fluxes              = 1
  Newell__comb_accelerated       = 0

  eSpec__Newell_2009_interp      = 1
  eSpec__use_2000km_file         = 0
  eSpec__remove_outliers         = 0
  ;; eSpec__noMap                   = 1

  ePlots                         = 0
  eNumFlPlots                    = 1

  tHistDenominatorPlot           = 0
   tHistDenomPlotRange           = [0.,150.]
  ;; tHistDenomPlotNormalize        = 0
  ;; tHistDenomPlotAutoscale        = 1
  tHistDenomPlot_noMask          = 1

  espec__newellPlot_probOccurrence = 0
  espec__newell_plotRange    = [[0.00,0.15],[0.60,1.00],[0.00,0.25],[0.00,0.30]]

  eSpec__t_ProbOccurrence    = 0
  eSpec__t_probOcc_plotRange = [[0.00,0.15],[0.60,1.00],[0.00,0.25],[0.00,0.30]]


  eFluxPlotType                  = 'Max'
  CASE 1 OF
     KEYWORD_SET(eSpec_noMap): BEGIN
        ePlotRange               = [[0,0.08],[0,0.50],[0,0.15],[0,0.20]]
     END
     ELSE: BEGIN
        ePlotRange               = [[0,0.2],[0,1.0],[0,0.30],[0,0.5]]
     END
  ENDCASE
  logEfPlot                      = 0
  noNegEflux                     = 1
  ;; ePlotRange                     = [1e-3,1e1]
  ;; logEfPlot                      = 1
  noNegEflux                     = 1

  eNumFlPlotType                 = ['ESA_Number_flux']
  noNegENumFl                    = 1
  ;; ENumFlPlotRange                = [[0,2.5e8],[0,6.0e8],[0,3.0e8],[0,3.5e8]]
  CASE 1 OF
     KEYWORD_SET(eSpec_noMap): BEGIN
        ENumFlPlotRange          = [[0,2.0e8],[0,6.0e8],[0,1.5e8],[0,3.0e8]]
     END
     ELSE: BEGIN
        ENumFlPlotRange          = [[0,5.0e8],[0,1.2e9],[0,6.0e8],[0,8.0e8]]
     END
  ENDCASE
  ;; eNumFlPlotType                 = 'ESA_Number_flux'
  ;; noNegENumFl                    = 0
  ;; logENumFlPlot                  = 0
  ;; ENumFlPlotRange                = [0,2e9]


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  altRange                       = [[800,4300]]

  IF KEYWORD_SET(eSpec__use_2000km_file) THEN BEGIN
     altRange                    = [300,2000]
  ENDIF

  orbRange                       = [1000,10600]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 1.0

  smoothWindow                   = 0

  stableIMF                      = 4

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1200
  binOffset_delay                = 0
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  reset_omni_inds                = 1
  reset_good_inds                = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 90
  ;; maskMin                        = 100
  ;; tHist_mask_bins_below_thresh   = 1
  ;; numOrbLim                      = 5

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -90
  ;; maxILAT                        = -60
  ;; maskMin                        =  1
  ;; tHist_mask_bins_below_thresh   = 2

  ;; numOrbLim                      = 10

  ;; binILAT                     = 2.0
  binILAT                        = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = KEYWORD_SET(plotH2D_contour) ? 1.0 : 0.75
  shiftMLT                       = KEYWORD_SET(plotH2D_contour) ? 0.5 : 0.0

  IF shiftMLT GT 0. THEN BEGIN
     plotPref += '-rot'
  ENDIF

  ;; minMLT                      = 6
  ;; maxMLT                      = 18

  ;;Bonus

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange               = altRange[*,i]
     altStr                      = STRING(FORMAT='(I0,"-",I0,"_km--orbs_",I0,"-",I0)', $
                                          altitudeRange[0], $
                                          altitudeRange[1], $
                                          orbRange[0], $
                                          orbRange[1])
     plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

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


     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        CLOCKSTR=clockStrings, $
        MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        INCLUDE_32HZ=include_32Hz, $
        DISREGARD_SAMPLE_T=disregard_sample_t, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        POYNTRANGE=poyntRange, $
        DELAY=delayArr, $
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
        ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
        LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
        NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
        NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
        NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
        NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
        NEWELL__COMBINE_ACCELERATED=Newell__comb_accelerated, $
        ESPEC__NO_MAXIMUS=no_maximus, $
        ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
        ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
        ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
        ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
        ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
        ESPEC__NOMAPTO100KM=eSpec__noMap, $
        ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
        ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
        ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
        ESPEC__T_PROBOCCURRENCE=eSpec__t_ProbOccurrence, $
        ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
        PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
        NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
        IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, $
        LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
        NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
        OXYPLOTS=oxyPlots, $
        OXYFLUXPLOTTYPE=oxyFluxPlotType, $
        LOGOXYFPLOT=logOxyfPlot, $
        ABSOXYFLUX=absOxyFlux, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        OXYPLOTRANGE=oxyPlotRange, $
        CHAREPLOTS=charEPlots, CHARETYPE=charEType, $
        LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
        NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
        CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
        NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
        FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
        FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
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
        NEWELLPLOTS=newellPlots, $
        NEWELL_PLOTRANGE=newell_plotRange, $
        LOG_NEWELLPLOT=log_newellPlot, $
        NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
        NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
        NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
        TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
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
        CHASTDB=chastDB, $
        DESPUNDB=despun, $
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
        SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIX=plotSuff, $
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
        CONTOUR__LEVELS=contour__levels, $
        CONTOUR__PERCENT=contour__percent, $
        PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kde, $
        OVERPLOT_FILE=overplot_file, $
        OVERPLOT_ARR=overplot_arr, $
        OVERPLOT_CONTOUR__LEVELS=op_contour__levels, $
        OVERPLOT_CONTOUR__PERCENT=op_contour__percent, $
        OVERPLOT_PLOTRANGE=op_plotRange, $
        
        FANCY_PLOTNAMES=fancy_plotNames, $
        SHOW_INTEGRALS=show_integrals, $
        
        USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i
        ;; _EXTRA=e
     ;; /GET_PLOT_I_LIST_LIST, $
     ;; /GET_PARAMSTR_LIST_LIST, $
     ;; PLOT_I_LIST_LIST=plot_i_list_list, $
     ;; PARAMSTR_LIST_LIST=paramStr_list_list
     
  ENDFOR

END

