;2015/12/28
;This needs to be redone since I'm not sure what haas changed with this plot after fixing
; basic_dbcleaner.
PRO JOURNAL__20151228__PLOTS_OF_PROBOCCURRENCE_DURING_STORMPHASES_WITH_ILATS__COMBINED

  dstCutoff = -20

  plotSuff  = '--inside_extremeVals'
  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PROBOCCURRENCEPLOT, $
                                       /LOGPROBOCCURRENCE, $
                                       ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
                                       PROBOCCURRENCERANGE=[1e-4,1e0], $
                                       PLOTSUFFIX=plotSuff, $
                                       
                                       HEMI='NORTH', $
                                       BINMLT=1.5, $
                                       MINILAT=54, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER
  
  ;; plotSuff  = '--outside_extremeVals'
  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /PROBOCCURRENCEPLOT, $
  ;;                                      /LOGPROBOCCURRENCE, $
  ;;                                      ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
  ;;                                      PROBOCCURRENCERANGE=[10^(-3.2),10^(-1.0)], $
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER

  ;; plotSuff  = '--above_all_lowVals'
  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /PROBOCCURRENCEPLOT, $
  ;;                                      /LOGPROBOCCURRENCE, $
  ;;                                      ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
  ;;                                      PROBOCCURRENCERANGE=[10^(-3.2),10^(-0.2)], $
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER


END