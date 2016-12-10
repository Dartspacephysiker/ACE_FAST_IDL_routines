;;2016/07/16 As part of my response to Bill Lotko's concerns, I said I'd try a few other measures of Poynting flux. Here's one.
;;I'm also only going over the time (all of 1997) that Keiling et al. [2003] gave for Poynting flux averages derived from Polar
PRO JOURNAL__20160716__VANILLA_MEDIAN_PFLUX__ALFIMFPAPE

  do_timeAvg_fluxQuantities      = 1
  logAvgPlot                     = 0
  medianPlot                     = 0
  divide_by_width_x              = 1

  ;;DB stuff
  do_despun                      = 1

  plotPref                       = 'just_1997'

  autoscale_fluxPlots            = 0

  do_not_consider_IMF            = 1

  cb_force_oobHigh               = 0
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots

  ;; ePlots                         = 0
  ;; eNumFlPlots                    = 0
  pPlots                         = 1
  nOrbsWithEventsPerContribOrbsPlot = 0
  ;; ionPlots                       = 0
  probOccurrencePlot             = 0
  ;; sum_electron_and_poyntingflux  = 0
  ;; tHistDenominatorPlot           = 0

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
  logPfPlot                      = 0
  PPlotRange                     = [0.00,2.0]

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

  altRange                       = [[340,4180]]

  ;;A more involved method for getting the correct orbits ...
  ;; orbRange                       = [500,12670]

  t1Str                    = '1997-01-01/00:00:00.000'
  t2Str                    = '1997-12-31/23:59:59.999'
  t1                       = STR_TO_TIME(t1Str)
  t2                       = STR_TO_TIME(t2Str)


  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DO_DESPUNDB=do_despun
  orbRange                 = [MIN(maximus.orbit[WHERE(cdbTime GE t1)]),MAX(maximus.orbit[WHERE(cdbTime LE t2)])]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 85

  ;; hemi                        = 'SOUTH'
  ;; minILAT                     = -86
  ;; maxILAT                     = -62

  ;; binILAT                     = 2.0
  binILAT                        = 2.5

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  shiftMLT                       = 0.5

  ;; minMLT                      = 6
  ;; maxMLT                      = 18

  ;;Bonus
  ;; maskMin                        = 10
  ;; tHist_mask_bins_below_thresh   = 5

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
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, SAVEDIR=saveDir, $
        JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIXES=plotSuff, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        EPS_OUTPUT=eps_output, $
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
        TILEPLOTTITLE=tilePlotTitle, $
        NO_COLORBAR=no_colorbar, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        /MIDNIGHT, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        _EXTRA=e
        ;; /GET_PLOT_I_LIST_LIST, $
        ;; /GET_PARAMSTR_LIST_LIST, $
        ;; PLOT_I_LIST_LIST=plot_i_list_list, $
        ;; PARAMSTR_LIST_LIST=paramStr_list_list
  
  ENDFOR

END

