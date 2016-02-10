PRO JOURNAL__20160210__OUTRIGHT_PROBOCCURRENCE_TO_COMPARE_WITH_CHASTON_2007

  hemi                           = 'NORTH'
  ;; minILAT                        = 55
  ;; maxILAT                        = 85

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -55

  nEventsPlotRange               = [7e1,7e3]        ; North   ;for chare 4-300eV

  ;; binILAT                        = 2.5
  ;; binMLT                         = 1.0
  ;; shiftMLT                       = 0.5

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
  iPlotRange                     = [10^(7.0),10^(10.0)]
  logIFPlot                      = 1
  
  ;;49--pFluxEst
  pPlotRange                     = [1e-1,1e1]
  logPFPlot                      = 1

  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]   ;;Seemed to work well when byMin=3, hemi='SOUTH', and anglelims=[45,135]
  probOccurrenceRange            = [1e-4,1e0]

  ;;Chare
  charEPlotRange                 = [4,4e3]
  logCharEPlot                   = 1

  do_despun                      = 1

  PLOT_ALFVEN_STATS_IMF_SCREENING,maximus, $
                                  /DO_NOT_CONSIDER_IMF, $                                  
                                  CHARERANGE=charERange, $
                                  PLOTSUFFIX=plotSuff, $
                                  HEMI=hemi, $
                                  BINMLT=binMLT, $
                                  SHIFTMLT=shiftMLT, $
                                  MINILAT=minILAT, $
                                  MAXILAT=maxILAT, $
                                  BINILAT=binILAT, $
                                  /MIDNIGHT, $
                                  DO_DESPUNDB=do_despun, $
                                  ;; /MEDIANPLOT, $
                                  /LOGAVGPLOT, $
                                  /NPLOTS, $
                                  /CHAREPLOTS, $
                                  CHAREPLOTRANGE=charEPlotRange, $
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
                                  LOGCHAREPLOT=logCharEPlot, $
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
                                  /CB_FORCE_OOBLOW  
END