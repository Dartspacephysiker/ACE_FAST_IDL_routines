;2016/01/28 Now it's time to do all the delays. We want the data, baby!
PRO JOURNAL__20160213__PLOTS_OF_PROBOCCURRENCE__DAWNDUSKALL__LOOP_OVER_DELAYS__FASTLOC_INTERVALS4

  nonstorm                       = 0

  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 55
  ;; maxILAT                        = 85
  ;; binILAT                        = 2.5

  hemi                           = 'SOUTH'
  minILAT                        = -85
  maxILAT                        = -55
  binILAT                        = 2.5

  nEventsPlotRange               = [4e1,4e3]        ; North   ;for chare 4-300eV
  nEventsPlotRange               = [1e1,1e3]        ; North   ;for chare 300-4000eV

  ;; hemi                           = 'SOUTH'
  ;; maxILAT                        = -55
  ;; minILAT                        = -85
  ;; binILAT                        = 2.5
  ;; nEventsPlotRange               = [2e1,2e3]   ; South

  binMLT                         = 1.0
  shiftMLT                       = 0.5

  byMin                          = 3
  do_abs_bymin                   = 1
  bzMax                          = 0
  ;; smoothWindow                   = 5
  delayArr=[ $ ;0,60,120,180,240, $
            ;300,360,420,480,540, $
            ;600,660, $
           720,780,840, $
            900,960,1020,1080,1140, $
            1200,1260,1320,1380,1440, $
            1500,1560,1620,1680,1740, $
            1800]

  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]


  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]   ;;Seemed to work well when byMin=3, hemi='SOUTH', and anglelims=[45,135]
  probOccurrenceRange            = [2e-3,2e-1]

  do_despun                      = 1

  FOR i = 0, N_ELEMENTS(delayArr)-1 DO BEGIN
     PRINT,'*******************************************'
     PRINT,FORMAT='("*************DELAY=",I04,"s*******************")',delayArr[i]
     PRINT,'*******************************************'
     PRINT,''
     PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSKALL, $
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
        /NPLOTS, $
        ;; /ENUMFLPLOTS, $
        ;; /EPLOTS, $
        ;; /IONPLOTS, $
        ;; /PPLOTS, $
        /PROBOCCURRENCEPLOT, $
        /LOGNEVENTSPLOT, $
        ;; LOGIFPLOT=logIFPlot, $
        ;; LOGPFPLOT=logPFPlot, $
        ;; LOGENUMFLPLOT=logENumFlPlot, $
        ;; LOGEFPLOT=logEFPlot, $
        /LOGPROBOCCURRENCE, $
        ;; NEVENTSPLOTRANGE=nEventsPlotRange, $
        ;; EPLOTRANGE=ePlotRange, $
        ;; ENUMFLPLOTRANGE=eNumFlRange, $
        ;; IPLOTRANGE=iPlotRange, $
        ;; PPLOTRANGE=pPlotRange, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        ;; ENUMFLPLOTTYPE=eNumFlPlotType, $
        ;; IFLUXPLOTTYPE=iFluxPlotType, $
        /CB_FORCE_OOBHIGH, $
        /CB_FORCE_OOBLOW, $
        /COMBINE_PLOTS, $
        /SAVE_COMBINED_WINDOW, $
        /COMBINED_TO_BUFFER

  ENDFOR     
END