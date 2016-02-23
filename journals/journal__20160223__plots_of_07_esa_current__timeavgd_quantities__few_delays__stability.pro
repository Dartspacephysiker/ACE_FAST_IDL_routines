;2016/02/23 So we're un-converting ESA current to get e- number flux. K?
PRO JOURNAL__20160223__PLOTS_OF_07_ESA_CURRENT__TIMEAVGD_QUANTITIES__FEW_DELAYS__STABILITY

  nonstorm                       = 0

  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85
  binILAT                        = 4.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -61
  ;; binILAT                        = 3.0

  ;; nEventsPlotRange               = [4e1,4e3]        ; North   ;for chare 4-300eV
  nEventsPlotRange               = [3e1,3e3]        ; North   ;for chare 300-4000eV
  maskMin                        = 5

  ;; binMLT                         = 1.0
  ;; shiftMLT                       = 0.5
  binMLT                         = 0.5
  shiftMLT                       = 0.25

  byMin                          = 3
  do_abs_bymin                   = 1
  bzMax                          = 2
  stableIMF                      = 2

  delayArr                       = [ -1500, -1440, -1380, -1320, -1260, $
                                    -1200, -1140, -1080, -1020,  -960, $
                                     -900,  -840,  -780,  -720,  -660, $
                                     -600,  -540,  -480,  -420,  -360, $
                                     -300,  -240,  -180,  -120,   -60, $
                                        0,    60,   120,   180,   240, $
                                      300,   360,   420,   480,   540, $
                                      600,   660,   720,   780,   840, $
                                      900,   960,  1020,  1080,  1140, $
                                     1200,  1260,  1320,  1380,  1440, $
                                     1500]

  delayArr                       = [-180,-120,-60,0,60,120,180]

  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

   ;; 10-EFLUX_LOSSCONE_INTEG
   eNumFlPlotType                = 'ESA_Number_flux'
   eNumFlRange                   = [10^(6.5),10^(8.5)]
   ;; eNumFlRange                    = [5e1,5e3]
   logENumFlPlot                 = 1
   noNegeNumFl                   = 1

  ;;08--ELEC_ENERGY_FLUX
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [1e-4,1e0]  ;for time-averaged plot
  ;; ePlotRange                     = [1e-1,1e1]
  logEFPlot                      = 1

  ;;16--ION_FLUX_UP
  iFluxPlotType                  = 'Max_Up'
  ;; iPlotRange                     = [10^(6.5),10^(9.5)]
  iPlotRange                     = [10^(5.0),10^(8.0)]  ;for time-averaged plot
  logIFPlot                      = 1
  
  ;;49--pFluxEst
  ;; pPlotRange                     = [1e-1,1e1]
  pPlotRange                     = [1e-3,1e1] ;for time-averaged
  logPFPlot                      = 1

  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]   ;;Seemed to work well when byMin=3, hemi='SOUTH', and anglelims=[45,135]
  probOccurrenceRange            = [1e-3,1e-1]

  ;Time-averaged pFlux
  ;; timeAvgd_pFluxPlot             = 1
  ;; timeAvgd_pFluxRange            = [1e-3,1e1]
  ;; logTimeAvgd_pFlux              = 1

  ;Time-averaged pFlux
  ;; timeAvgd_eFluxMaxPlot          = 1
  ;; timeAvgd_eFluxMaxRange         = [1e-4,1e0]
  ;; logtimeAvgd_eFluxMax           = 1

  do_despun                      = 1

  ;; FOR i = 0, N_ELEMENTS(delayArr)-1 DO BEGIN
     ;; PRINT,'********************************************'
     ;; PRINT,FORMAT='("*************DELAY=",I05,"s*******************")',delayArr[i]
     ;; PRINT,'********************************************'
     ;; PRINT,''
     PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSK, $
        NONSTORM=nonstorm, $
        CHARERANGE=charERange, $
        PLOTSUFFIX=plotSuff, $
        HEMI=hemi, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        /MIDNIGHT, $
        DELAY=delayArr, $
        /MULTIPLE_DELAYS, $
        DO_DESPUNDB=do_despun, $
        BYMIN=byMin, $
        DO_ABS_BYMIN=do_abs_bymin, $
        BZMAX=bzMax, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        ;; /MEDIANPLOT, $
        ;; /LOGAVGPLOT, $
        ;; /NPLOTS, $
        /ENUMFLPLOTS, $
        /DO_TIMEAVG_FLUXQUANTITIES, $
        /EPLOTS, $
        /IONPLOTS, $
        /PPLOTS, $
        /PROBOCCURRENCEPLOT, $
        /LOGPROBOCCURRENCE, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        ;; TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
        ;; TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        ;; LOGTIMEAVGD_PFLUX=logTimeAvgd_pFlux, $
        ;; TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
        ;; TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        ;; LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
        ;; /LOGNEVENTSPLOT, $
        LOGIFPLOT=logIFPlot, $
        LOGPFPLOT=logPFPlot, $
        LOGENUMFLPLOT=logENumFlPlot, $
        NONEGENUMFL=noNegeNumFl, $
        LOGEFPLOT=logEFPlot, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        EPLOTRANGE=ePlotRange, $
        ENUMFLPLOTRANGE=eNumFlRange, $
        IPLOTRANGE=iPlotRange, $
        PPLOTRANGE=pPlotRange, $
        ENUMFLPLOTTYPE=eNumFlPlotType, $
        IFLUXPLOTTYPE=iFluxPlotType, $
        MASKMIN=maskMin, $
        /CB_FORCE_OOBHIGH, $
        /CB_FORCE_OOBLOW, $
        /COMBINE_PLOTS, $
        /SAVE_COMBINED_WINDOW, $
        /COMBINED_TO_BUFFER

  ;; ENDFOR     
END