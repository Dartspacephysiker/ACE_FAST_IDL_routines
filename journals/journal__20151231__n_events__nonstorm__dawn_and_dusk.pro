;2015/12/31 Time to check it out
PRO JOURNAL__20151231__N_EVENTS__NONSTORM__DAWN_AND_DUSK

  clockStr                       = 'duskward'
  hemi                           = 'NORTH'
  charERange                     = [0,300]

  byMin                          = 5

  eNumFlPlotType                 = 'Eflux_Losscone_Integ'
  eNumFlRange                    = [10^(0.5),10^(5.5)]
  logENumFlPlot                  = 1

  iFluxPlotType                  = 'Integ_Up'
  iPlotRange                     = [10^(6.5),10^(14.5)]
  logIFPlot                      = 1
  
  binMLT                         = 1.5

  minILAT                        = 54

  PLOT_ALFVEN_STATS_IMF_SCREENING,CLOCKSTR=clockstr, $
                                  HEMI=hemi, $
                                  /NONSTORM, $
                                  CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  /MEDIANPLOT, $
                                  /NPLOTS, $
                                  /ENUMFLPLOTS, $
                                  /IONPLOTS, $
                                  ENUMFLPLOTTYPE=eNumFlPlotType, $
                                  ENUMFLPLOTRANGE=eNumFlRange, $
                                  LOGENUMFLPLOT=logENumFlPlot, $
                                  IFLUXPLOTTYPE=iFluxPlotType, $
                                  IPLOTRANGE=iPlotRange, $
                                  LOGIFPLOT=logIFPlot, $
                                  BINMLT=binMLT, $
                                  MINILAT=minILAT, $
                                  /MIDNIGHT

                                

END