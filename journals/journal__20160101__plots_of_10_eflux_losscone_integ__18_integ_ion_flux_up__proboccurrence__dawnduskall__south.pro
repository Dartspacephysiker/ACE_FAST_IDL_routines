;2016/01/01
PRO JOURNAL__20160101__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__PROBOCCURRENCE__DAWNDUSKALL__SOUTH

  hemi                           = 'SOUTH'
  ;; charERange                     = [0,300]

  byMin                          = 5
  binMLT                         = 1.5
  maxILAT                        = -54
  minILAT                        = -86

  ;;NEVENTS
  nEventsPlotRange               = [2e0,2e3]

  ;;10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                 = 'eflux_Losscone_Integ'
  ;; eNumFlRange                    = [10^(0.5),10^(5.5)]
  eNumFlRange                    = [1e2,5e3]
  logENumFlPlot                  = 1

  ;;18-INTEG_UPWARD_ION_FLUX
  iFluxPlotType                  = 'Integ_Up'
  iPlotRange                     = [1e8,1e12]
  logIFPlot                      = 1
  
  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-4,1e0]

  PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSKALL, $
                                  /NONSTORM, $
                                  PLOTSUFFIX=plotSuff, $
                                  HEMI=hemi, $
                                  BINMLT=binMLT, $
                                  MAXILAT=maxILAT, $
                                  MINILAT=minILAT, $
                                  /MIDNIGHT, $
                                  CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  /MEDIANPLOT, $
                                  /NPLOTS, $
                                  /LOGPROBOCCURRENCE, $
                                  /PROBOCCURRENCEPLOT, $
                                  PROBOCCURRENCERANGE=probOccurrenceRange, $
                                  /ENUMFLPLOTS, $
                                  /IONPLOTS, $
                                  NEVENTSPLOTRANGE=nEventsPlotRange, $
                                  /LOGNEVENTSPLOT, $
                                  ENUMFLPLOTTYPE=eNumFlPlotType, $
                                  ENUMFLPLOTRANGE=eNumFlRange, $
                                  LOGENUMFLPLOT=logENumFlPlot, $
                                  IFLUXPLOTTYPE=iFluxPlotType, $
                                  IPLOTRANGE=iPlotRange, $
                                  LOGIFPLOT=logIFPlot, $
                                  /CB_FORCE_OOBHIGH, $
                                  /CB_FORCE_OOBLOW, $
                                  /COMBINE_PLOTS, $
                                  /SAVE_COMBINED_WINDOW, $
                                  /COMBINED_TO_BUFFER



  ;;11-TOTAL_EFLUX_INTEG
  ;; maxInd    = 11
  ;; enumfpt   = 'total_eflux_integ'

  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /ENUMFLPLOTS, $
  ;;                                      ENUMFLPLOTTYPE=enumfpt, $
  ;;                                      /NONEGENUMFL, $     ;Because we're not interested in upflowing electrons
  ;;                                      /LOGENUMFLPLOT, $
  ;;                                      ;; ENUMFLPLOTRANGE=[0,6], $
  ;;                                      ENUMFLPLOTRANGE=[1.5e1,5e4], $
  ;;                                      /LOGAVGPLOT, $
  ;;                                      BINMLT=1.5, $
  ;;                                      ;; /DO_LSHELL, $
  ;;                                      ;; /REVERSE_LSHELL, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      ;; SAVE_COMBINED_NAME=plotName, $
  ;;                                      /COMBINED_TO_BUFFER

END