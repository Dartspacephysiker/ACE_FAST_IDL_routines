;2016/02/29 So now we see each signature; can we filter it out by killing low-energy, broadband electrons?
PRO JOURNAL__20160229__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG_18_INTEG_ION_FLUX_UP__49_PFLUXEST__PROBOCCURRENCE__TIMESPACEAVG__DAWNDUSK__CHARE_LIMITS

  nonstorm                       = 0

  ;; charERange                     = [4,300]
  ;; plotSuff                       = 'low-energy_e'

  charERange                     = [300,4000]
  plotSuff                       = 'high-energy_e'


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 61
  ;; maxILAT                        = 86
  ;; binILAT                        = 5.0

  hemi                           = 'SOUTH'
  minILAT                        = -85
  maxILAT                        = -61
  binILAT                        = 4.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 0.5
  shiftMLT                       = 0.25

  ;; binMLT                         = 1.0
  ;; shiftMLT                       = 0.5

  ;;IMF condition stuff
  ;; stableIMF                      = 20
  byMin                          = 4
  do_abs_bymin                   = 1
  bzMax                          = 1
  ;; bzMin                          = -4

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 10
  divide_by_width_x              = 1

  ;;Delay stuff
  delayArr                       = [ $ ;-1500, -1440, -1380, -1320, -1260, $
                                    ;; -1200, -1140, -1080, -1020,  -960, $
                                    ;;  -900,  -840,  -780,  -720,  -660, $
                                    ;;  -600,  -540,  -480,  -420,  -360, $
                                     ;; -300,  -240,  -180,  $
                                   -120,  -60,  $
                                        0,    60,   120,   180,   240];, $
                                     ;;  300,   360,   420,   480,   540, $
                                     ;;  600,   660,   720,   780,   840, $
                                     ;;  900,   960,  1020,  1080,  1140, $
                                     ;; 1200,  1260,  1320,  1380,  1440, $
                                     ;; 1500]

  ;;For test
  ;; delayArr                       = [ $;-1500, -1440, -1380, -1320, -1260, $
                                    ;; -1200, -1140, -1080, -1020,  -960, $
                                    ;;  -900,  -840,  -780,  -720,  -660, $
                                    ;;  -600,  -540,  -480,  -420,  -360, $
                                     ;; -300,  -240,  -180,  $
                                   ;; -120,  -60,  $
                                   ;;      0,    60,   120] ;,   $
                                   ;; 180,   240, $
                                   ;;    300,   360,   420,   480,   540, $
                                   ;;    600,   660,   720,   780,   840, $
                                   ;;    900,   960,  1020,  1080,  1140, $
                                   ;;   1200,  1260,  1320,  1380,  1440, $
                                   ;;   1500]

  ;; ;;Same array, reverse order
  ;; delayArr                       = [ 1500,   1440,   1380,   1320,   1260,   1200, $
  ;;                                    1140,   1080,   1020,    960,    900,    840, $
  ;;                                     780,    720,    660,    600,    540,    480, $
  ;;                                     420,    360,    300,    240,    180,    120, $
  ;;                                      60,      0,    -60,   -120,   -180,   -240, $
  ;;                                    -300,   -360,   -420,   -480,   -540,   -600, $
  ;;                                    -660,   -720,   -780,   -840,   -900,   -960, $
  ;;                                   -1020,  -1080,  -1140,  -1200,  -1260,  -1320, $
  ;;                                   -1380,  -1440,  -1500]
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  ;;49--pFluxEst
  pPlotRange                     = [5e-3,5e-1] ;for time-averaged
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  eNumFlRange                   = [10^(-2.5),10^(-0.5)]
  eNumFlRange                   = [10.^(-3.0),10.^(-1.0)]
  logENumFlPlot                 = 1
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  iPlotRange                     = [10.^(4.5),10.^(7.5)] ;for time-averaged plot
  logIFPlot                      = 1

  ;;;;;;;;;;;;
  ;;For high-energy (300,4000-eV) electrons
  iPlotRange                     = [10.^(2.5),10.^(6.5)] ;for high-energy electrons
  pPlotRange                     = [10.^(-4.5),10.^(-1.5)] ;for high-energy electrons
  eNumFlRange                   = [10.^(-5.5),10.^(-1.5)] ;for high-energy electrons


  ;; FOR i = 0, N_ELEMENTS(delayArr)-1 DO BEGIN
     PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSK, $
        NONSTORM=nonstorm, $
        CHARERANGE=charERange, $
        MASKMIN=maskMin, $
        HEMI=hemi, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        
        /MULTIPLE_DELAYS, $
        DELAY=delayArr, $
        DESPUNDB=despun, $
        STABLEIMF=stableIMF, $
        BYMIN=byMin, $
        DO_ABS_BYMIN=do_abs_bymin, $
        BZMAX=bzMax, $
        BZMIN=bzMin, $
        SMOOTHWINDOW=smoothWindow, $
        /LOGAVGPLOT, $
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
        PLOTSUFFIX=plotSuff, $
        /CB_FORCE_OOBHIGH, $
        /CB_FORCE_OOBLOW, $
        /COMBINE_PLOTS, $
        /SAVE_COMBINED_WINDOW, $
        /COMBINED_TO_BUFFER

  ;; ENDFOR     
END
