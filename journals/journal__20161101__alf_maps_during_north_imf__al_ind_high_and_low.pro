;;11/01/16
PRO JOURNAL__20161101__ALF_MAPS_DURING_NORTH_IMF__AL_IND_HIGH_AND_LOW

  COMPILE_OPT IDL2

  use_ae                         = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  probOccurrencePlot             = 1
  eNumFluxPlot                   = 1
  pFluxPlot                      = 1
  nPlots                         = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;bonus
  do_despun                      = 0

  orbRange                       = [500,12670]

  divide_by_width_x              = 1

  save_alf_stormphase_indices    = 0

  fancyPresentationMode          = 0 ;Erases stormphase titles, suppresses gridlabels, and blows up plot titles. Keep it.
  ;; add_center_title               = 1
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 90
  binILAT                        = 2.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -90
  ;; maxILAT                        = -60
  ;; binILAT                        = 2.0

  binMLT                         = 1.0

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  eNumFlPlotRange                = [10^(-1.0),10^(1.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  iPlotRange                     = [10.^(6.0),10.^(9.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  ;; pPlotRange                     = [10.^(2.5),10.^(4.5)] ;for pFlux multiplied by width_x
  pPlotRange                     = [10.^(-1.0),10.^(1.0)] ;for pFlux multiplied by width_x AFTER I figured out I screwed up scaling with B
  logPFPlot                      = 1
  ;; multiply_pFlux_by_width_x      = 1
  ;; pPlotRange                     = [0,3.0] ;for pFlux multiplied by width_x AFTER I figured out I screwed up scaling with B
  ;; logPFPlot                      = 0

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  maskMin                        = 5 ;since identification is better

  ;;;;;;;;;;;;;;;;;;;;;
  ;;N events
  nEventsPlotRange               = [10,5000]
  logNEventsPlot                 = 1

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     USE_AE=use_ae, $
     USE_AU=use_au, $
     USE_AL=use_al, $
     USE_AO=use_ao, $
     HEMI=hemi, $
     ORBRANGE=orbRange, $
     DO_DESPUNDB=do_despun, $
     MASKMIN=maskMin, $
     BINMLT=binMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     IONPLOTS=ionPlots, $
     IFLUXPLOTTYPE=ifpt, $
     /NONEGIFLUX, $
     /LOGIFPLOT, $
     IPLOTRANGE=iPlotRange, $
     ENUMFLPLOTS=eNumFluxPlot, $
     ENUMFLPLOTTYPE=enumfpt, $
     /NONEGENUMFL, $            ;Because we're not interested in upflowing electrons
     /LOGENUMFLPLOT, $
     ENUMFLPLOTRANGE=eNumFlPlotRange, $
     PPLOTS=pFluxPlot, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
     MULTIPLY_BY_WIDTH_X=multiply_pFlux_by_width_x, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     NPLOTS=nPlots, $
     NEVENTSPLOTRANGE=nEventsPlotRange, $
     LOGNEVENTSPLOT=logNEventsPlot, $
     NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
     NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
     PLOTSUFFIX=plotSuff, $
     SAVE_ALF_STORMPHASE_INDICES=save_alf_stormphase_indices, $
     /LOGAVGPLOT, $
     /MIDNIGHT, $
     /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     NO_STORMPHASE_TITLES=fancyPresentationMode, $
     SUPPRESS_GRIDLABELS=fancyPresentationMode, $
     SUPPRESS_TITLES=fancyPresentationMode, $
     ADD_CENTER_TITLE__STORMPHASE_PLOTS=fancyPresentationMode, $
     LABELS_FOR_PRESENTATION=fancyPresentationMode, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END
