;;2017/07/07 Because Jim and I have been talking about it.
PRO JOURNAL__20170707__ZHANG_2014__NEWELLDB__JIMANDI

  COMPILE_OPT IDL2,STRICTARRSUBS

  plotPref = 'NWO-'

  minM_c    = [ 6,12]
  maxM_c    = [12,18]
  minI_c    = [70,70]
  maxI_c    = [90,90]
  plotPref += '-upto90-'
  
  labels_for_presentation        = 1

  use_prev_plot_i                = 1
  remake_prev_plot_file          = 1
  ;; prev_plot_i__limit_to_these    = [0] ;bzNorth
  ;; prev_plot_i__limit_to_these    = [3,4] ;dusk-south and bzSouth
  
  nonstorm                       = 1
  DSTcutoff                      = -25
  smooth_dst                     = 0
  use_mostRecent_Dst_files       = 1

  @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

  paramPref                      = plotPref
  ;; include_32Hz                   = 
  ;; sample_t_restriction           = 10
  disregard_sample_t             = 1

  show_integrals                 = 1

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
  ;; divide_by_width_x              = 1

  write_obsArr_textFile          = 0
  write_obsArr__inc_IMF          = 1
  write_obsArr__orb_avg_obs      = 1
  justData                       = 0
  
  saveDir                        = '/home/spencerh/Desktop/'
  justInds                       = 0
  justInds_saveToFilePref        = 'newellZhang2014--'

  ;;DB stuff
  do_despun                      = 0
  use_AACGM                      = 1
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

  ;; plotPref += '-notRot_pFlux-t'

  ;; overplot_file                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20161213/pFlux.dat'

  ;; overplot_arr                   = [['*enumflux_espec*broad*','*timeavgd_pflux*'], $
  ;;                                   ['*enumflux_espec*mono*' ,'*timeavgd_pflux*'], $
  ;;                                   ['*enumflux_espec*accel*','*timeavgd_pflux*']]
  ;; ;; op_contour__levels             = [20,50,80]
  ;; op_contour__levels             = [10,40,70]
  ;; plotPref                      += STRING(FORMAT='("-op_",20(I0,:,"_"))',op_contour__levels)
  ;; op_contour__percent            = 1
  ;; op_plotRange                   = [0.00,0.10]


  tile__include_IMF_arrows       = KEYWORD_SET(plotH2D_contour) ? 0 : 0
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

  ;; ePlots                         = KEYWORD_SET(justData) ? 0 : 1
  ePlots                         = 1
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
        CASE 1 OF
           KEYWORD_SET(logEfPlot): BEGIN
              ePlotRange         = [[1e-2,1e1],[1e-2,1e1],[1e-2,1e1],[1e-2,1e1]]
           END
           ELSE: BEGIN
              ePlotRange         = [[0,1.0],[0,1.0],[0,1.0],[0,0.5]]
           END
        ENDCASE
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
        CASE 1 OF
           KEYWORD_SET(logENumFlPlot): BEGIN
              ENumFlPlotRange    = [[1.0e8,1.0e10],[1.0e8,1.0e10],[1.0e8,1.0e10],[1.0e8,1.0e10]]
           END
           ELSE: BEGIN
              ENumFlPlotRange    = [[0,1.2e9],[0,2.5e9],[0,1.0e9],[0,8.0e8]]
              cbENumFlDivFac     = [1e9,1e9,1e8,1e8]          
           END
        ENDCASE
     END
  ENDCASE
  ;; eNumFlPlotType                 = 'ESA_Number_flux'
  ;; noNegENumFl                    = 0
  ;; logENumFlPlot                  = 0
  ;; ENumFlPlotRange                = [0,2e9]


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  altRange                       = [[300,4300]]

  IF KEYWORD_SET(eSpec__use_2000km_file) THEN BEGIN
     altRange                    = [300,2000]
  ENDIF

  orbRange                       = [500,12670]

  ;; latest_UTC                     = STR_TO_TIME('1999-05-16/03:20:59.853')

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 1.0

  smoothWindow                   = 0

  stableIMF                      = 19

  ;;Delay stuff
  ;; nDelays                        = 1
  ;; delayDeltaSec                  = 1800
  ;; binOffset_delay                = 0
  ;; delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  ;; delayArr                       = (INDGEN(25)*5*60)[1:-1]
  ;; delayArr                       = (INDGEN(12)*5*60)[5:-1]
  delayArr                       = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90]*60
  ;; delayArr                       = [0]*60
  ;; add_night_delay                = 45*60

  ;; fixed_night_delay           = 70*60

  nDelays                        = N_ELEMENTS(delayArr)

  reset_omni_inds                = 1
  reset_good_inds                = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                        = 'NORTH'
  minI                        = 60
  maxI                        = 90
  ;; maskMin                        = 100
  ;; tHist_mask_bins_below_thresh   = 1
  ;; numOrbLim                      = 5

  ;; hemi                           = 'SOUTH'
  ;; minI                        = -90
  ;; maxI                        = -60
  ;; maskMin                        =  1
  ;; tHist_mask_bins_below_thresh   = 2

  ;; numOrbLim                      = 10

  ;; binI                     = 2.0
  binI                        = 2.0

  IF KEYWORD_SET(justInds_saveToFilePref) THEN BEGIN
     justInds_saveToFile = justInds_saveToFilePref + hemi + '_inds.sav'
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  ;; binM                         = KEYWORD_SET(plotH2D_contour) ? 1.0 : 0.75
  ;; shiftM                       = KEYWORD_SET(plotH2D_contour) ? 0.5 : 0.0
  binM                         = 1.0
  shiftM                       = 0.5

  IF shiftM GT 0. THEN BEGIN
     plotPref += '-rot'
  ENDIF

  IF KEYWORD_SET(plotH2D_contour) THEN BEGIN
     plotPref += '-cont'
  ENDIF
  IF KEYWORD_SET(plotH2D__kde) THEN BEGIN
     plotPref += '-kde'
  ENDIF
  ;; minM                      = 6
  ;; maxM                      = 18

  ;;Bonus

  nDelays = N_ELEMENTS(delayArr)
  FOR k=0,nDelays-1 DO BEGIN

     delay = delayArr[k]

     PRINT,FORMAT='("Doing delay = ",I0," min")',delay/60.

     FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
        altitudeRange               = altRange[*,i]
        altStr                      = STRING(FORMAT='(I0,"-",I0,"_km--orbs_",I0,"-",I0)', $
                                             altitudeRange[0], $
                                             altitudeRange[1], $
                                             orbRange[0], $
                                             orbRange[1])
        paramStrPrefix = (KEYWORD_SET(paramPref) ? paramPref : '') + altStr
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
           CHARE__NEWELL_THE_CUSP=charE__Newell_the_cusp, $
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
           NPLOTS=nPlots, $
           EPLOTS=ePlots, $
           EFLUXPLOTTYPE=eFluxPlotType, $
           EPLOTRANGE=ePlotRange, $
           ENUMFLPLOTS=eNumFlPlots, $
           ENUMFLPLOTTYPE=eNumFlPlotType, $
           ENUMFLPLOTRANGE=eNumFlPlotRange, $
           NONEGENUMFL=noNegENumFl, $
           NOPOSENUMFL=noPosENumFl, $
           PPLOTS=pPlots, $
           IONPLOTS=ionPlots, $
           IFLUXPLOTTYPE=ifluxPlotType, $
           CHAREPLOTS=charEPlots, $
           CHARETYPE=charEType, $
           CHARIEPLOTS=chariEPlots, $
           AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
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
           WRITEPROCESSEDH2D=writeProcessedH2d, $
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
           PARAMSTRPREFIX=paramStrPrefix, $
           ;; PARAMSTRPREFIX=plotPrefix, $
           ;; PARAMSTRSUFFIX=plotSuffix,$
           PLOTH2D_CONTOUR=plotH2D_contour, $
           CUSTOM_INTEGRAL_STRUCT=custom_integral_struct, $
           PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kde, $
           HOYDIA=hoyDia, $
           LUN=lun, $
           NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
           NEWELL__COMBINE_ACCELERATED=Newell__comb_accelerated, $
           ESPEC__NO_MAXIMUS=no_maximus, $
           ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
           ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
           ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
           ;; CBEFDIVFAC=cbEFDivFac, $
           CBENUMFLDIVFAC=cbENumFlDivFac, $
           ;; CBPFDIVFAC=CBPFDivFac, $
           ;; CBIFDIVFAC=cbIFDivFac, $
           ;; CBCHAREDIVFAC=cbCharEDivFac, $
           ;; CBMAGCDIVFAC=CBMagCDivFac, $
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
           DELAY=delay, $
           MULTIPLE_DELAYS=multiple_delays, $
           ADD_NIGHT_DELAY=add_night_delay, $
           FIXED_NIGHT_DELAY=fixed_night_delay, $
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
           ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
           ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
           ESPEC__T_PROBOCCURRENCE=eSpec__t_ProbOccurrence, $
           ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
           CONTOUR__LEVELS=contour__levels, $
           CONTOUR__PERCENT=contour__percent, $
           OVERPLOT_FILE=overplot_file, $
           OVERPLOT_ARR=overplot_arr, $
           OVERPLOT_CONTOUR__LEVELS=op_contour__levels, $
           OVERPLOT_CONTOUR__PERCENT=op_contour__percent, $
           OVERPLOT_PLOTRANGE=op_plotRange, $        
           SHOW_INTEGRALS=show_integrals, $
           RESET_STRUCT=reset


        PLOT_ALFVEN_STATS_IMF_SCREENING, $
           FOR_ESPEC_DBS=for_eSpec_DBs, $
           NEED_FASTLOC_I=need_fastLoc_i, $
           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
           ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
           IMF_STRUCT=IMF_struct, $
           MIMC_STRUCT=MIMC_struct, $
           MASKMIN=maskMin, $
           THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
           RESET_OMNI_INDS=reset_omni_inds, $
           PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
           PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
           SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
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
           FANCY_PLOTNAMES=fancy_plotNames, $        
           USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
           REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_file, $
           PREV_PLOT_I__LIMIT_TO_THESE=prev_plot_i__limit_to_these
        
     ENDFOR

  ENDFOR

END


