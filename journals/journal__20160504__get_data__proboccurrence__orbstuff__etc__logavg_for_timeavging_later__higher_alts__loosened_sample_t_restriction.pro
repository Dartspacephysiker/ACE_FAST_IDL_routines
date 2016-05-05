;2016/05/04 The deal now is that we know the biggest pFlux events change location 
PRO JOURNAL__20160504__GET_DATA__PROBOCCURRENCE__ORBSTUFF__ETC__LOGAVG_FOR_TIMEAVGING_LATER__HIGHER_ALTS__LOOSENED_SAMPLE_T_RESTRICTION

  nonstorm                       = 0
  ;; dstCutoff                      = -30
  justData                       = 0

  ;; sample_t_restriction           = 0.1

  altitudeRange                  = [1000,4180]
  altString                      = STRING(FORMAT='("--",I0,"-",I0,"km")',altitudeRange[0],altitudeRange[1])

  keep_colorbar                  = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Which plots?
  eNumFlPlots                    = 1
  pPlots                         = 1
  ionPlots                       = 1
  nEventPerOrbPlot               = 1
  nEventPerMinPlot               = 1
  tHistDenominatorPlot           = 1
  orbContribPlot                 = 1
  probOccurrencePlot             = 1
  nPlots                         = 1
  nOrbsWithEventsPerContribOrbsPlot = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Bonus
  do_timeAvg_fluxQuantities      = 0
  div_fluxPlots_by_applicable_orbs = 0
  logAvgs                        = 1
  maskMin                        = 5
  divide_by_width_x              = 1


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 84

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -61

  ;; binILAT                        = 4.0        ;2016/03/{23,31}
  ;; binILAT                        = 2.0        ;2016/03/24
  ;; binILAT                        = 5.0        ;2016/03/29
  ;; binILAT                        = 2.5        ;2016/03/30
  ;; binILAT                        = 3.0        ;2016/03/31
  binILAT                        = 6.0        ;2016/03/31

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  ;; binMLT                         = 0.75        ;2016/03/2{3,9}
  ;; shiftMLT                       = 0.375       ;2016/03/2{3,9}

  binMLT                         = 1.5       ;2016/03/24
  shiftMLT                       = 0.75       ;2016/03/24

  ;; binMLT                         = 1.5       ;2016/03/31
  ;; shiftMLT                       = 0.75      ;2016/03/31

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff
  stableIMF                      = 0
  byMin                          = 3
  do_abs_bymin                   = 1
  bzMax                          = -3
  ;; bzMin                          = 3

  ;;DB stuff
  do_despun                      = 1

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1800
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  ;; binOffset_delay                = delayDeltaSec/2
  
  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;;orbcontribplot
  orbContribRange                = !NULL
  orbContribAutoscale            = 1  

  ;;NOWEPCO
  log_nowepcoPlot                = 0
  nowepco_range                  = !NULL
  nowepco_autoscale              = 1

  ;;tHistDenominatorPlot
  tHistDenomPlotRange            = !NULL
  tHistDenomPlotAutoscale        = 1
  tHistDenomPlot_noMask          = 1

  ;; ;;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1
  probOccurrenceRange            = [0,0.05]
  logProbOccurrence              = 0

  ;; Events per orb
  nEventPerOrbRange              = [1,30]
  logNEventPerOrb                = 0

  ;;nEvents
  nEventsPlotRange               = [0,1500]
  logNEventsPlot                 = 0

  ;;nevpermin
  nEventPerMinRange              = [0,20]
  logNEventPerMin                = 0

  ;;49--pFluxEst
  ;; pPlotRange                     = [0,1] ;for time-averaged
  pPlotRange                     = [1e-1,1e1] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = ['Eflux_Losscone_Integ','ESA_Number_flux']
  eNumFlRange                   = [[0,1], $
                                   [0,1e9]]
  logENumFlPlot                 = [0,0]
  eNumFlRange                   = [[10.^(-1.0),10.^(1.0)], $
                                   [5e7,5e9]]
  logENumFlPlot                 = [1,1]
  noNegeNumFl                   = [1,1]

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [0,1e8] ;for time-averaged plot
  iPlotRange                     = [10^(7.0),10^(9.0)]  ;for time-averaged plot
  logIFPlot                      = 1
  noNegIFlux                     = 1  

  PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSK, $
     JUSTDATA=justData, $
     NONSTORM=nonstorm, $
     DSTCUTOFF=dstCutoff, $
     CHARERANGE=charERange, $
     ALTITUDERANGE=altitudeRange, $
     SAMPLE_T_RESTRICTION=sample_t_restriction, $
     MASKMIN=maskMin, $
     HEMI=hemi, $
     BINMLT=binMLT, $
     SHIFTMLT=shiftMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     /MIDNIGHT, $
     /MULTIPLE_DELAYS, $
     RESOLUTION_DELAY=delayDeltaSec, $
     BINOFFSET_DELAY=binOffset_delay, $
     DELAY=delayArr, $
     DO_DESPUNDB=do_despun, $
     STABLEIMF=stableIMF, $
     BYMIN=byMin, $
     DO_ABS_BYMIN=do_abs_bymin, $
     BZMAX=bzMax, $
     BZMIN=bzMin, $
     SMOOTHWINDOW=smoothWindow, $
     LOGAVGPLOT=logAvgs, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
     DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     THISTDENOMINATORPLOT=tHistDenominatorPlot, $
     THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
     THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
     THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
     THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
     NEVENTPERORBPLOT=nEventPerOrbPlot, $
     NPLOTS=nPlots, $
     NEVENTPERORBRANGE=nEventPerOrbRange, $
     LOGNEVENTPERORB=logNEventPerOrb, $
     NEVENTPERMINPLOT=nEventPerMinPlot, $
     NEVENTPERMINRANGE=nEventPerMinRange, $
     LOGNEVENTPERMIN=logNEventPerMin, $
     NEVENTSPLOTRANGE=nEventsPlotRange, $
     LOGNEVENTSPLOT=logNEventsPlot, $
     ORBCONTRIBPLOT=orbContribPlot, $
     ORBCONTRIBRANGE=orbContribRange, $
     ORBCONTRIBAUTOSCALE=orbContribAutoscale, $  
     NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
     LOG_NOWEPCOPLOT=log_nowepcoPlot, $
     NOWEPCO_RANGE=nowepco_range, $
     NOWEPCO_AUTOSCALE=nowepco_autoscale, $
     PPLOTS=pPlots, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
     ENUMFLPLOTS=eNumFlPlots, $
     ENUMFLPLOTTYPE=eNumFlPlotType, $
     ENUMFLPLOTRANGE=eNumFlRange, $
     LOGENUMFLPLOT=logENumFlPlot, $
     NONEGENUMFL=noNegENumFl, $
     IONPLOTS=ionPlots, $
     IFLUXPLOTTYPE=iFluxPlotType, $
     IPLOTRANGE=iPlotRange, $
     LOGIFPLOT=logIFPlot, $
     NONEGIFLUX=noNegIFlux, $
     /CB_FORCE_OOBHIGH, $
     /CB_FORCE_OOBLOW, $
     ;; COMBINE_PLOTS=~KEYWORD_SET(justData), $
     /COMBINE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     PLOTSUFFIX=altString, $
     KEEP_COLORBAR=keep_colorbar,$
     /COMBINED_TO_BUFFER

END

