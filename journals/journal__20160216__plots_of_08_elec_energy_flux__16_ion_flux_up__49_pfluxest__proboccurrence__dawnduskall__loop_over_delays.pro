;2016/02/16 Jim wants to see some super negative delays
PRO JOURNAL__20160216__PLOTS_OF_08_ELEC_ENERGY_FLUX__16_ION_FLUX_UP__49_PFLUXEST__PROBOCCURRENCE__DAWNDUSKALL__LOOP_OVER_DELAYS

  nonstorm                       = 0

  hemi                           = 'NORTH'
  minILAT                        = 56
  maxILAT                        = 83
  binILAT                        = 3.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -83
  ;; maxILAT                        = -56
  ;; binILAT                        = 3.0

  ;; nEventsPlotRange               = [4e1,4e3]        ; North   ;for chare 4-300eV
  nEventsPlotRange               = [3e1,3e3]        ; North   ;for chare 300-4000eV

  binMLT                         = 1.0
  shiftMLT                       = 0.5

  byMin                          = 1
  do_abs_bymin                   = 1
  ;; bzMax                          = 0
  ;; bzMax                          = 2

  ;; delayArr                          = 0

  delayArr                       = [ $ ;-1500, -1440, -1380, -1320, -1260, $
                                    ;; -1200, -1140, -1080, -1020,  -960, $
                                    ;;  -900,  -840,  -780,  -720,  -660, $
                                     ;; -600,  -540,  -480,  -420,  -360, $
                                     ;; -300,  -240,  -180,  $
                                   -120,  -60,  $
                                        0,    60,   120,   180,   240, $
                                      300,   360,   420,   480,   540, $
                                      600,   660,   720,   780,   840, $
                                      900,   960,  1020,  1080,  1140, $
                                     1200,  1260,  1320,  1380,  1440, $
                                     1500]

  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

   ;;10-EFLUX_LOSSCONE_INTEG
   eNumFlPlotType                 = 'eflux_Losscone_Integ'
   ;; eNumFlRange                    = [10^(0.5),10^(5.5)]
   eNumFlRange                    = [5e1,5e3]
   logENumFlPlot                  = 1

  ;;08--ELEC_ENERGY_FLUX
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [1e-2,1e0]
  logEFPlot                      = 1

  ;;16--ION_FLUX_UP
  iFluxPlotType                  = 'Max_Up'
  iPlotRange                     = [10^(6.5),10^(9.5)]
  logIFPlot                      = 1
  
  ;;49--pFluxEst
  pPlotRange                     = [1e-1,1e1]
  logPFPlot                      = 1

  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]   ;;Seemed to work well when byMin=3, hemi='SOUTH', and anglelims=[45,135]
  probOccurrenceRange            = [3e-4,3e-2]

  do_despun                      = 1

  FOR i = 0, N_ELEMENTS(delayArr)-1 DO BEGIN
     PRINT,'********************************************'
     PRINT,FORMAT='("*************DELAY=",I05,"s*******************")',delayArr[i]
     PRINT,'********************************************'
     PRINT,''
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
        DELAY=delayArr[i], $
        DO_DESPUNDB=do_despun, $
        BYMIN=byMin, $
        DO_ABS_BYMIN=do_abs_bymin, $
        BZMAX=bzMax, $
        SMOOTHWINDOW=smoothWindow, $
        ;; /MEDIANPLOT, $
        /LOGAVGPLOT, $
        ;; /NPLOTS, $
        ;; /ENUMFLPLOTS, $
        /EPLOTS, $
        ;; /IONPLOTS, $
        ;; /PPLOTS, $
        /PROBOCCURRENCEPLOT, $
        /LOGNEVENTSPLOT, $
        LOGIFPLOT=logIFPlot, $
        LOGPFPLOT=logPFPlot, $
        LOGENUMFLPLOT=logENumFlPlot, $
        LOGEFPLOT=logEFPlot, $
        /LOGPROBOCCURRENCE, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        EPLOTRANGE=ePlotRange, $
        ENUMFLPLOTRANGE=eNumFlRange, $
        IPLOTRANGE=iPlotRange, $
        PPLOTRANGE=pPlotRange, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        ENUMFLPLOTTYPE=eNumFlPlotType, $
        IFLUXPLOTTYPE=iFluxPlotType, $
        /CB_FORCE_OOBHIGH, $
        /CB_FORCE_OOBLOW, $
        /COMBINE_PLOTS, $
        /SAVE_COMBINED_WINDOW, $
        /COMBINED_TO_BUFFER

  ENDFOR     
END