;2016/01/26 Crikey, we knew something had to be wrong. Now we're ready to write the other paper!
; There was a serious issue of my own making with the OMNI DB. Check out this journal for more info:
; ACE_FAST/journals/../SW_IMF_data_parsing_routines/check_space_between_omnidata_20150221.pro
PRO JOURNAL__20160127__PLOTS_OF_08_ELEC_ENERGY_FLUX__10_EFLUX_LOSSCONE_INTEG__16_ION_FLUX_UP__18_INTEG_ION_FLUX_UP_49_PFLUXEST__PROBOCCURRENCE__DAWNDUSKALL__BZNORTH

  nonstorm                       = 0

  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 55
  ;; maxILAT                        = 85
  ;; binILAT                        = 2.5
  ;; nEventsPlotRange               = [5e1,5e3]        ; North   ;for chare 4-300eV
  ;; nEventsPlotRange               = [1e1,1e3]        ; North   ;for chare 300-4000eV

  hemi                           = 'SOUTH'
  maxILAT                        = -55
  minILAT                        = -85
  binILAT                        = 2.5
  nEventsPlotRange               = [1e1,1e3]   ; South

  binMLT                         = 1.0
  shiftMLT                       = 0.5

  byMin                          = 3
  do_abs_bymin                   = 1
  bzMin                          = 0
  ;; smoothWindow                   = 5
  ;; delay                          = 420
  ;; delay                          = 480
  ;; delay                          = 540
  ;; delay                          = 600
  delay                          = 660
  ;; delay                          = 720
  ;; delay                          = 780
  ;; delay                          = 840
  ;; delay                          = 900

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
  probOccurrenceRange            = [1e-2,1e0]

  do_despun                      = 1

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
     
     DELAY=delay, $
     DESPUNDB=despun, $
     BYMIN=byMin, $
     DO_ABS_BYMIN=do_abs_bymin, $
     BZMIN=bzMin, $
     SMOOTHWINDOW=smoothWindow, $
     ;; /MEDIANPLOT, $
     /LOGAVGPLOT, $
     /NPLOTS, $
     /ENUMFLPLOTS, $
     /EPLOTS, $
     /IONPLOTS, $
     /PPLOTS, $
     /LOGNEVENTSPLOT, $
     LOGIFPLOT=logIFPlot, $
     LOGPFPLOT=logPFPlot, $
     LOGENUMFLPLOT=logENumFlPlot, $
     LOGEFPLOT=logEFPlot, $
     NEVENTSPLOTRANGE=nEventsPlotRange, $
     EPLOTRANGE=ePlotRange, $
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
  
  ;;prob occurrence last because it takes so long
  ;; 18-INTEG_UPWARD_ION_FLUX
  iFluxPlotType                  = 'Integ_Up'
  iPlotRange                     = [10^(8.0),10^(12.0)]
  logIFPlot                      = 1
  
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
     
     DELAY=delay, $
     DESPUNDB=despun, $
     BYMIN=byMin, $
     DO_ABS_BYMIN=do_abs_bymin, $
     BZMIN=bzMin, $
     SMOOTHWINDOW=smoothWindow, $
     /LOGAVGPLOT, $
     /PROBOCCURRENCEPLOT, $
     /LOGPROBOCCURRENCE, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     /IONPLOTS, $
     IFLUXPLOTTYPE=iFluxPlotType, $
     IPLOTRANGE=iPlotRange, $
     /LOGIFPLOT, $
     ;; /CB_FORCE_OOBHIGH, $
     /CB_FORCE_OOBLOW, $
     /COMBINE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER
  


END