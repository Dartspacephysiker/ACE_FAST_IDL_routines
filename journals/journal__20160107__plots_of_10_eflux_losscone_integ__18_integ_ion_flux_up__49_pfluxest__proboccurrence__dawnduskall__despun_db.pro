;2016/01/07--Got this newfangled despun DB, and I can't help myself
PRO JOURNAL__20160107__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__49_PFLUXEST__PROBOCCURRENCE__DAWNDUSKALL__DESPUN_DB

  hemi                           = 'NORTH'
  ;; charERange                     = [0,300]

  byMin                          = 5

  charERange                     = [4,300]
  ;; charERange                     = [300,4000]

  ;;NEVENTS
  nEventsPlotRange               = [8e0,8e3]

  ;;10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                 = 'eflux_Losscone_Integ'
  ;; eNumFlRange                    = [10^(0.5),10^(5.5)]
  eNumFlRange                    = [2e1,2e3]
  logENumFlPlot                  = 1

  ;;18-INTEG_UPWARD_ION_FLUX
  iFluxPlotType                  = 'Integ_Up'
  iPlotRange                     = [10^(7.5),10^(11.5)]
  logIFPlot                      = 1
  
  ;;49--pFluxEst
  pPlotRange                     = [2e-1,2e1]
  logPFPlot                      = 1

  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-4,1e-1]

  binMLT                         = 1.5
  minILAT                        = 54

  do_despun                      = 1

  PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSKALL, $
                                  /NONSTORM, $
                                  CHARERANGE=charERange, $
                                  PLOTSUFFIX=plotSuff, $
                                  HEMI=hemi, $
                                  BINMLT=binMLT, $
                                  MINILAT=minILAT, $
                                  /MIDNIGHT, $
                                  DO_DESPUNDB=do_despun, $
                                  BYMIN=byMin, $
                                  /MEDIANPLOT, $
                                  /NPLOTS, $
                                  /ENUMFLPLOTS, $
                                  /IONPLOTS, $
                                  /PPLOTS, $
                                  /PROBOCCURRENCEPLOT, $
                                  /LOGPROBOCCURRENCE, $
                                  /LOGNEVENTSPLOT, $
                                  LOGIFPLOT=logIFPlot, $
                                  LOGPFPLOT=logPFPlot, $
                                  LOGENUMFLPLOT=logENumFlPlot, $
                                  PROBOCCURRENCERANGE=probOccurrenceRange, $
                                  NEVENTSPLOTRANGE=nEventsPlotRange, $
                                  ENUMFLPLOTRANGE=eNumFlRange, $
                                  IPLOTRANGE=iPlotRange, $
                                  PPLOTRANGE=pPlotRange, $
                                  ENUMFLPLOTTYPE=eNumFlPlotType, $
                                  IFLUXPLOTTYPE=iFluxPlotType, $
                                  /CB_FORCE_OOBHIGH, $
                                  /CB_FORCE_OOBLOW, $
                                  /COMBINE_PLOTS, $
                                  /SAVE_COMBINED_WINDOW, $
                                  /COMBINED_TO_BUFFER

END
