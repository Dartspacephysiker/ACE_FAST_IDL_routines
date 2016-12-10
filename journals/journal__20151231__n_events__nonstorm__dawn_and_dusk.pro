;2015/12/31 Time to check it out
PRO JOURNAL__20151231__N_EVENTS__NONSTORM__DAWN_AND_DUSK

  clockStr                       = 'duskward'
  hemi                           = 'NORTH'
  ;; charERange                     = [0,300]

  byMin                          = 5

  nEventsPlotRange               = [5e0,5e2]

  eNumFlPlotType                 = 'Eflux_Losscone_Integ'
  ;; eNumFlRange                    = [10^(0.5),10^(5.5)]
  eNumFlRange                    = [1e2,1e4]
  logENumFlPlot                  = 1

  iFluxPlotType                  = 'Integ_Up'
  iPlotRange                     = [1e8,1e12]
  logIFPlot                      = 1
  
  binMLT                         = 1.5

  minILAT                        = 54

  ;; plotSuff                       = STRING(FORMAT='("--chare_",I0,"-",I0,"--")', $
  ;;                                         charERange[0],charERange[1])

  PLOT_ALFVEN_STATS_IMF_SCREENING,CLOCKSTR=clockstr, $
                                  PLOTSUFFIX=plotSuff, $
                                  HEMI=hemi, $
                                  /NONSTORM, $
                                  CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  /MEDIANPLOT, $
                                  /NPLOTS, $
                                  ;; /PROBOCCURRENCEPLOT,
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
                                  BINMLT=binMLT, $
                                  MINILAT=minILAT, $
                                  
                                  /CB_FORCE_OOBHIGH, $
                                  /CB_FORCE_OOBLOW
                                
  clockStr                       = 'dawnward'

  PLOT_ALFVEN_STATS_IMF_SCREENING,CLOCKSTR=clockstr, $
                                  HEMI=hemi, $
                                  /NONSTORM, $
                                  CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  /MEDIANPLOT, $
                                  /NPLOTS, $
                                  ;; /PROBOCCURRENCEPLOT,
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
                                  BINMLT=binMLT, $
                                  MINILAT=minILAT, $
                                  
                                  /CB_FORCE_OOBHIGH, $
                                  /CB_FORCE_OOBLOW

END