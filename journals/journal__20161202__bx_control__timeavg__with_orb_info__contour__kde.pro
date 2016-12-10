;;2016/12/02 The updated version, all the bells and whistles
PRO JOURNAL__20161202__BX_CONTROL__TIMEAVG__WITH_ORB_INFO__CONTOUR__KDE

  COMPILE_OPT IDL2


  do_what_everyone_does              = 0
  KDE_for_Bx                         = 0

  ;;NOTE: Bx-specific stuff on other side of IF
  IF KEYWORD_SET(do_what_everyone_does) THEN BEGIN
     @journal__20161202__zhang_2014__params_for_every_child.pro
  ENDIF ELSE BEGIN

     restore_last_session               = 0

     nonstorm                           = 1
     DSTcutoff                          = -50
     smooth_dst                         = 5
     use_mostRecent_Dst_files           = 1

     @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

     include_32Hz                       = 0

     plotH2D_contour                    = 0
     plotH2D__kde                       = 0

     EA_binning                         = 0

     minMC                              = 1
     maxNegMC                           = -1

     do_timeAvg_fluxQuantities          = 1
     logAvgPlot                         = 0
     medianPlot                         = 0
     divide_by_width_x                  = 1
     org_plots_by_folder                = 1

     dont_blackball_maximus             = 1
     dont_blackball_fastloc             = 1

     ;;DB stuff
     do_despun                          = 0
     use_AACGM                          = 1
     use_MAG                            = 0

     autoscale_fluxPlots                = 0
     fluxPlots__remove_outliers         = 0
     fluxPlots__remove_log_outliers     = 0
     fluxPlots__Newell_the_cusp         = 0

     
     write_obsArr_textFile              = 1
     write_obsArr__inc_IMF              = 1
     write_obsArr__orb_avg_obs          = 1
     justData                           = 0

     ;;bonus
     make_OMNI_stuff                    = 0
     print_avg_imf_components           = KEYWORD_SET(make_OMNI_stuff)
     print_master_OMNI_file             = KEYWORD_SET(make_OMNI_stuff)
     save_master_OMNI_inds              = KEYWORD_SET(make_OMNI_stuff)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Tiled plot options

     ;; altRange                    = [[340,1180], $
     ;;                             [1180,2180], $
     ;;                             [2180,3180], $
     ;;                             [3180,4180]]

     altRange                       = [[300,4300]]

     orbRange                       = [1000,10800]

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;IMF condition stuff--run the ring!

     ;;Delay stuff
     nDelays                        = 1
     delayDeltaSec                  = 1800
     binOffset_delay                = 0
     delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

     stableIMF                      = 4
     smoothWindow                   = 9

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;ILAT stuff
     ;; hemi                           = 'NORTH'
     ;; minILAT                        = 60
     ;; maxILAT                        = 90
     ;; maskMin                        = 5
     ;; tHist_mask_bins_below_thresh   = 1
     ;; numOrbLim                      = 5

     ;; hemi                           = 'SOUTH'
     ;; minILAT                        = -90
     ;; maxILAT                        = -60
     ;; southern_hemi_plotScales          = 1
     ;; IF KEYWORD_SET(southern_hemi_plotScales) THEN BEGIN
     ;;    probOccurrenceRange            = [0,0.1]
     ;; ENDIF
     ;; maskMin                        =  1
     ;; tHist_mask_bins_below_thresh   = 10

     ;; numOrbLim                      = 10

     ;; binILAT                     = 2.0
     binILAT                        = 2.0

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;MLT stuff
     binMLT                         = 1.0
     shiftMLT                       = 0.0

  ENDELSE

  plotH2D__kde                       = KDE_for_Bx

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Bx-specific

  ;; btMinArr                       = 3.5
  ;; btMinArr                       = [0.5,1.0,1.5,2.0,2.5,3.0,3.5]
  ;; btMinArr                       = [1.0,1.5,2.0]
  clockStr                       = 'bzSouth'
  btMinArr                       = [0.0]
  ;; btMinArr                       = [1.5,2.0]
  ;; btMax                       = 5

  bxMagnitude                    = 0.0
  bx_over_by_ratio_min           = 0.5

  angleLim1                      = 0.
  angleLim2                      = 180.

  ;;But what about the middle range? If you're interested ...
  ;; bxMax                          = 2.0
  ;; abs_bxMax                      = 1

  reset_good_inds                    = 1
  reset_omni_inds                    = 1
     
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots
  ePlots                             = 1
  eNumFlPlots                        = 1
  pPlots                             = 1
  ionPlots                           = 1
  probOccurrencePlot                 = 1
  sum_electron_and_poyntingflux      = 1
  nOrbsWithEventsPerContribOrbsPlot  = 0

  nowepco_range                  = [0,0.64]

  ;;e- energy flux
  ;; eFluxPlotType                  = 'Eflux_losscone_integ'
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [0.0,0.25]
  logEfPlot                      = 0
  noNegEflux                     = 0

  eNumFlPlotType                 = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  noNegENumFl                    = [1,0]
  ;; logENumFlPlot               = [1,1]
  ;; ENumFlPlotRange             = [[1e-1,1e1], $
  ;;                             [1e7,1e9]]
  logENumFlPlot                  = [0,0]
  ENumFlPlotRange                = [[0,0.25], $
                                    [0,5.0e8]]
  ;; eNumFlPlotType                 = 'ESA_Number_flux'
  ;; noNegENumFl                    = 0
  ;; logENumFlPlot                  = 0
  ;; ENumFlPlotRange                = [0,2e9]

  ;; logPfPlot                   = 1
  ;; PPlotRange                  = [1e-1,1e1]
  logPfPlot                      = 0
  PPlotRange                     = [0,0.15]

  ifluxPlotType                  = 'Integ_Up'
  noNegIflux                     = 1
  ;; logIfPlot                   = 1
  ;; IPlotRange                  = [1e6,1e8]
  logIfPlot                      = 0
  IPlotRange                     = [0,5.0e7]
  
  logProbOccurrence              = 0
  probOccurrenceRange            = [0,0.1]

  summed_eFlux_pFluxplotRange    = [0,0.5]
  
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

  FOR bx_i=0,3 DO BEGIN

     CASE 1 OF
        bx_i LE 1: BEGIN
           hemi                           = 'NORTH'
           minILAT                        = 60
           maxILAT                        = 90
        END
        ELSE: BEGIN
           hemi                           = 'SOUTH'
           minILAT                        = -90
           maxILAT                        = -60
        END
     ENDCASE

     CASE 1 OF
        ((bx_i MOD 2) EQ 0): BEGIN
           bxMin                          = bxMagnitude
           bxMax                          = !NULL
        END
        ELSE: BEGIN
           bxMin                          = !NULL
           bxMax                          = (-1.)*bxMagnitude
        END
     ENDCASE

     FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN

        altitudeRange               = altRange[*,i]
        altStr                      = STRING(FORMAT='(I0,"-",I0,"_km--orbs_",I0,"-",I0)', $
                                             altitudeRange[0], $
                                             altitudeRange[1], $
                                             orbRange[0], $
                                             orbRange[1])

        FOR jow=0,N_ELEMENTS(btMinArr)-1 DO BEGIN

           btMin      = btMinArr[jow]
           ;; btMinStr   = STRING(FORMAT='("/btMin_",F0.1)',btMin)
           btMinSuff  = STRING(FORMAT='("btMin_",F0.1)',btMin)
           ;; IF KEYWORD_SET(nonstorm) THEN BEGIN
           ;;    btMinStr   = btMinStr + STRING(FORMAT='("/DstMin_",I0)',DstCutoff)
           ;; ENDIF

           ;; IF KEYWORD_SET(numOrbLim) THEN BEGIN
           ;;    btMinStr += STRING(FORMAT='("/numOrbLim_",I0)',numOrbLim)
           ;; ENDIF

           SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY;,ADD_SUFF=btMinStr

           plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

           ;; IF KEYWORD_SET(grossRate_info_file_pref) THEN BEGIN
           ;;    CASE 1 OF
           ;;       N_ELEMENTS(bxMin) GT 0: BEGIN
           ;;          grossRate_infos          = STRING(FORMAT='("-bxMin",F0.1)',bxMin)
           ;;       END
           ;;       N_ELEMENTS(bxMax) GT 0: BEGIN
           ;;          grossRate_infos          = STRING(FORMAT='("-bxMax",F0.1)',bxMax)
           ;;       END
           ;;       ELSE: BEGIN
           ;;          grossRate_infos          = ''
           ;;       END
           ;;    ENDCASE

           ;;    grossRate_infos                += '_' +btMinSuff + '--' + hemi 
           ;;    grossRate_info_file            = grossRate_info_file_pref + grossRate_infos + $
           ;;                                     grossRate_info_file_suff + '.txt'
           ;; ENDIF

           PLOT_ALFVEN_STATS_IMF_SCREENING, $
              CLOCKSTR=clockStr, $
              MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
              SAMPLE_T_RESTRICTION=sample_t_restriction, $
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
              BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
              BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
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
              DSTCUTOFF=DstCutoff, $
              SMOOTH_DST=smooth_dst, $
              USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
              NPLOTS=nPlots, $
              EPLOTS=ePlots, $
              EPLOTRANGE=ePlotRange, $                                       
              EFLUXPLOTTYPE=eFluxPlotType, $
              LOGEFPLOT=logEfPlot, $
              ABSEFLUX=abseflux, $
              NOPOSEFLUX=noPosEFlux, $
              NONEGEFLUX=noNegEflux, $
              ENUMFLPLOTS=eNumFlPlots, $
              ENUMFLPLOTTYPE=eNumFlPlotType, $
              LOGENUMFLPLOT=logENumFlPlot, $
              ABSENUMFL=absENumFl, $
              NONEGENUMFL=noNegENumFl, $
              NOPOSENUMFL=noPosENumFl, $
              ENUMFLPLOTRANGE=ENumFlPlotRange, $
              PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
              NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
              IONPLOTS=ionPlots, $
              IFLUXPLOTTYPE=ifluxPlotType, $
              LOGIFPLOT=logIfPlot, $
              ABSIFLUX=absIflux, $
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
              WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
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
              PLOTSUFFIXES=plotSuff, $
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
              
              FANCY_PLOTNAMES=fancy_plotNames, $
              SHOW_INTEGRALS=show_integrals, $
              MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
              MAKE_INTEGRAL_SAVFILES=make_integral_savfiles, $
              
              _EXTRA=e
           ;; /GET_PLOT_I_LIST_LIST, $
           ;; /GET_PARAMSTR_LIST_LIST, $
           ;; PLOT_I_LIST_LIST=plot_i_list_list, $
           ;; PARAMSTR_LIST_LIST=paramStr_list_list
           
        ENDFOR
     ENDFOR

  ENDFOR

END


