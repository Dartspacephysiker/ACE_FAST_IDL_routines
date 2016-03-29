;2016/03/28 Finer smoothing
PRO JOURNAL__20160328__GET_DATA__10_EFLUX_LOSSCONE_INTEG_18_INTEG_ION_FLUX_UP__49_PFLUXEST__PROBOCCURRENCE__TIMESPACEAVG__DAWNDUSK__FINER_DELAY_SPACING

  nonstorm                       = 0
  justData                       = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 61
  ;; maxILAT                        = 85
  ;; ;;binILAT                        = 4.0        ;2016/03/23
  ;; binILAT                        = 2.0        ;2016/03/24

  hemi                           = 'SOUTH'
  minILAT                        = -85
  maxILAT                        = -61
  ;; binILAT                        = 4.0        ;2016/03/23
  binILAT                        = 2.0        ;2016/03/24

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  ;; binMLT                         = 0.75        ;2016/03/23
  ;; shiftMLT                       = 0.375       ;2016/03/23

  binMLT                         = 1.0       ;2016/03/24
  shiftMLT                       = 0.5       ;2016/03/24

  ;;IMF condition stuff
  ;; stableIMF                      = 20
  byMin                          = 5
  do_abs_bymin                   = 1
  ;; bzMax                          = 0
  bzMin                          = 0

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 5
  divide_by_width_x              = 1

  ;;Delay stuff
  nDelays                        = 121
  delayDeltaSec                  = 30

  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  ;; delayArr                       = 15*60
  
  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  probOccurrenceRange            = [0,1e-1]
  logProbOccurrence              = 1

  ;;49--pFluxEst
  pPlotRange                     = [0,1] ;for time-averaged
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  eNumFlRange                   = [0,1]
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)]
  logENumFlPlot                 = 1
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  iPlotRange                     = [0,1e8] ;for time-averaged plot
  logIFPlot                      = 1
  noNegIFlux                     = 1  

  ;; FOR i = 0, N_ELEMENTS(delayArr)-1 DO BEGIN
     PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSK, $
        JUSTDATA=justData, $
        NONSTORM=nonstorm, $
        CHARERANGE=charERange, $
        MASKMIN=maskMin, $
        HEMI=hemi, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        /MIDNIGHT, $
        /MULTIPLE_DELAYS, $
        DELAY=delayArr, $
        DO_DESPUNDB=do_despun, $
        STABLEIMF=stableIMF, $
        BYMIN=byMin, $
        DO_ABS_BYMIN=do_abs_bymin, $
        BZMAX=bzMax, $
        BZMIN=bzMin, $
        SMOOTHWINDOW=smoothWindow, $
        ;; /LOGAVGPLOT, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        /DO_TIMEAVG_FLUXQUANTITIES, $
        /PROBOCCURRENCEPLOT, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        /PPLOTS, $
        LOGPFPLOT=logPFPlot, $
        PPLOTRANGE=pPlotRange, $
        /ENUMFLPLOTS, $
        ENUMFLPLOTTYPE=eNumFlPlotType, $
        ENUMFLPLOTRANGE=eNumFlRange, $
        LOGENUMFLPLOT=logENumFlPlot, $
        NONEGENUMFL=noNegENumFl, $
        /IONPLOTS, $
        IFLUXPLOTTYPE=iFluxPlotType, $
        IPLOTRANGE=iPlotRange, $
        LOGIFPLOT=logIFPlot, $
        NONEGIFLUX=noNegIFlux, $
        /CB_FORCE_OOBHIGH, $
        /CB_FORCE_OOBLOW, $
        COMBINE_PLOTS=~KEYWORD_SET(justData), $
        /SAVE_COMBINED_WINDOW, $
        /COMBINED_TO_BUFFER

  ;; ENDFOR     
END

