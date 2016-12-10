;2016/02/05 So fastLoc_intervals3 had some problems ...
PRO JOURNAL__20160205__PROBOCCURRENCE__DAWNDUSK__LOOP_OVER_DELAYS__FASTLOCINTERVALS4

  nonstorm                       = 0

  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 55
  ;; maxILAT                        = 85

  hemi                           = 'SOUTH'
  minILAT                        = -85
  maxILAT                        = -55

  nEventsPlotRange               = [4e1,4e3]        ; North   ;for chare 4-300eV
  ;; nEventsPlotRange               = [1e1,1e3]        ; North   ;for chare 300-4000eV

  binILAT                        = 2.5
  binMLT                         = 1.0
  shiftMLT                       = 0.5

  byMin                          = 3
  do_abs_bymin                   = 1
  bzMax                          = 0

  delayArr                       = [0,10,20,30,40,50, $
                                    60,70,80,90,100, $
                                    110,120,130,140,150, $
                                    160,170,180,190,200, $
                                    210,220,230,240,250, $
                                    260,270,280,290,300, $
                                    310,320,330,340,350, $
                                    360,390,420,480,540, $
                                    600,660,720,780,840, $
                                    900,960,1020,1080,1140, $
                                    1200,1260,1320,1380,1440, $
                                    1500,1560,1620,1680,1740, $
                                    1800,1860,1920,1980,2040, $
                                    2100]

  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

   ;;10-EFLUX_LOSSCONE_INTEG
   eNumFlPlotType                 = 'eflux_Losscone_Integ'
   ;; eNumFlRange                    = [10^(0.5),10^(5.5)]
   eNumFlRange                    = [1e2,1e4]
   logENumFlPlot                  = 1

  ;;08--ELEC_ENERGY_FLUX
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [1e-1,1e1]
  logEFPlot                      = 1

  ;;16--ION_FLUX_UP
  iFluxPlotType                  = 'Max_Up'
  iPlotRange                     = [10^(7.0),10^(9.0)]
  logIFPlot                      = 1
  
  ;;49--pFluxEst
  pPlotRange                     = [1e-1,1e1]
  logPFPlot                      = 1

  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]   ;;Seemed to work well when byMin=3, hemi='SOUTH', and anglelims=[45,135]
  probOccurrenceRange            = [0.005,0.5]

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
        
        DELAY=delayArr[i], $
        DESPUNDB=despun, $
        BYMIN=byMin, $
        DO_ABS_BYMIN=do_abs_bymin, $
        BZMAX=bzMax, $
        SMOOTHWINDOW=smoothWindow, $
        ;; /MEDIANPLOT, $
        /LOGAVGPLOT, $
        /NPLOTS, $
        /ENUMFLPLOTS, $
        /EPLOTS, $
        /IONPLOTS, $
        /PPLOTS, $
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