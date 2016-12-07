;;2016/08/18 The reason for higher alts is that we want to account for 50% dissipation on dayside and 90% dissipation on nightside
PRO JOURNAL__20161125__VANILLA_TAVG_OR_LOGAVG_PFLUX__CONTOUR__EQUAL_AREA_BINNING

  use_prev_plot_i            = 1

  do_timeAvg_fluxQuantities  = 1
  logAvgPlot                 = 0
  medianPlot                 = 0
  divide_by_width_x          = 1

  include_32Hz               = 0
  use_AACGM                  = 0

  plotH2D_contour            = 0
  plotH2D__kde               = KEYWORD_SET(plotH2D_contour)

  EA_binning                 = 0

  minMC                      = 1
  maxnegMC                   = -1

  ;;DB stuff
  despun                     = 0

  suppress_ILAT_labels       = 1

  autoscale_fluxPlots        = 0

  do_not_consider_IMF        = 1

  cb_force_oobHigh           = 0

  dont_blackball_maximus     = 1
  dont_blackball_fastloc     = 1
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots

  ;; ePlots                         = 0
  ;; eNumFlPlots                    = 0
  pPlots                         = 1
  nOrbsWithEventsPerContribOrbsPlot = 0
  ;; ionPlots                       = 0
  probOccurrencePlot             = 1
  ;; sum_electron_and_poyntingflux  = 0
  tHistDenominatorPlot           = 1

  nowepco_range                  = [0,0.5]
  nowepco_autoscale              = 0

  ;;e- energy flux
  ;; eFluxPlotType                  = 'Eflux_losscone_integ'
  ;; eFluxPlotType                  = 'Max'
  ;; ePlotRange                     = [0,1]
  ;; logEfPlot                      = 0
  ;; noNegEflux                     = 0

  ;; eNumFlPlotType                 = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  ;; noNegENumFl                    = [1,1]
  ;; logENumFlPlot               = [1,1]
  ;; ENumFlPlotRange             = [[1e-1,1e1], $
  ;;                             [1e7,1e9]]
  ;; logENumFlPlot                  = [0,0]
  ;; ENumFlPlotRange                = [[0,1], $
  ;;                             [0,2e9]]
  ;; eNumFlPlotType                 = 'ESA_Number_flux'
  ;; noNegENumFl                    = 0
  ;; logENumFlPlot                  = 0
  ;; ENumFlPlotRange                = [0,2e9]

  ;; logPfPlot                   = 1
  ;; PPlotRange                  = [0.05,50.0]
  CASE 1 OF
     KEYWORD_SET(do_timeAvg_fluxQuantities): BEGIN
        logPfPlot   = 0
        PPlotRange  = [0.00,0.20]
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

  summed_eFlux_pFluxplotRange    = [0,1.5]
  
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

  altRange                       = [[500,4300]]

  ;; altRange                    = [[300,4300], $
  ;;                                [500,4300], $
  ;;                                [1000,4300], $
  ;;                                [1500,4300], $
  ;;                                [2000,4300], $
  ;;                                [2500,4300], $
  ;;                                [3000,4300], $
  ;;                                [3500,4300], $
  ;;                                [4000,4300]]

  ;;A more involved method for getting the correct orbits ...
  ;; orbRange                       = [500,12670]

  jahr                     = '1997'
  ;; jahr                     = '1998'
  t1Str                    = jahr + '-01-01/00:00:00.000'
  t2Str                    = jahr + '-12-31/23:59:59.999'

  ;; jahr                     = '1999'
  ;; t1Str                    = jahr + '-01-01/00:00:00.000'
  ;; t2Str                    = jahr + '-11-02/23:59:59.999'

  t1                       = STR_TO_TIME(t1Str)
  t2                       = STR_TO_TIME(t2Str)

  plotPref                   = 'just_' + jahr

  @common__maximus_vars.pro
  CLEAR_M_COMMON_VARS
  LOAD_MAXIMUS_AND_CDBTIME, $
     DESPUNDB=despun, $
     USE_AACGM=use_AACGM, $
     USE_MAG=use_mag
  orbRange                 = [MIN(MAXIMUS__maximus.orbit[WHERE(MAXIMUS__times GE t1)]), $
                              MAX(MAXIMUS__maximus.orbit[WHERE(MAXIMUS__times LE t2)])]
  ;; orbRange                    = [1000,10800]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 90

  ;; hemi                        = 'SOUTH'
  ;; minILAT                     = -86
  ;; maxILAT                     = -62

  ;; binILAT                     = 2.0
  binILAT                        = 2.5

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 0.75
  shiftMLT                       = 0.0

  IF KEYWORD_SET(shiftMLT) THEN BEGIN
     ;; plotPref += '-rotFICK' ;was using this to diagnose what was wrong with rotating when doing a contour plot
     plotPref += '-rot'
  ENDIF

  ;; minMLT                      = 6
  ;; maxMLT                      = 18

  ;;Bonus
  ;; maskMin                        = 10
  ;; tHist_mask_bins_below_thresh   = 3

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange               = altRange[*,i]
     altStr                      = STRING(FORMAT='("--",I0,"-",I0)', $
                            altitudeRange[0], $
                            altitudeRange[1])

     plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        ;; CLOCKSTR=clockStrings, $
        ;; MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        INCLUDE_32HZ=include_32Hz, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
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
        HEMI=hemi, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
        NONSTORM=nonStorm, $
        RECOVERYPHASE=recoveryPhase, $
        MAINPHASE=mainPhase, $
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
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
        SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
        MEDIANPLOT=medianPlot, $
        LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots, $
        SQUAREPLOT=squarePlot, $
        POLARCONTOUR=polarContour, $ 
        ;;WHOLECAP=wholeCap, $
        DBFILE=dbfile, $
        NO_BURSTDATA=no_burstData, $
        RESET_GOOD_INDS=reset_good_inds, $
        DATADIR=dataDir, $
        DO_CHASTDB=do_chastDB, $
        DO_DESPUNDB=do_despun, $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_MAG_COORDS=use_MAG, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, RAWDIR=rawDir, $
        JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIXES=plotSuff, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        EPS_OUTPUT=eps_output, $
        SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
        OUT_TEMPFILE_LIST=out_tempFile_list, $
        OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
        OUT_PLOT_I_LIST=out_plot_i_list, $
        OUT_PARAMSTRING_LIST=out_paramString_list, $
        GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        ;; TILEPLOTSUFFS=tilePlotSuffs, $
        TILING_ORDER=tiling_order, $
        TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
        TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
        TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
        TILEPLOTTITLES=tilePlotTitle, $
        NO_COLORBAR=no_colorbar, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        PLOTH2D_CONTOUR=plotH2D_contour, $
        PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kde, $
        /MIDNIGHT, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
        _EXTRA=e
        ;; /GET_PLOT_I_LIST_LIST, $
        ;; /GET_PARAMSTR_LIST_LIST, $
        ;; PLOT_I_LIST_LIST=plot_i_list_list, $
        ;; PARAMSTR_LIST_LIST=paramStr_list_list
  
  ENDFOR

END


