;+
; NAME: BATCH_PLOT_ALFVEN_STATS_IMF_SCREENING
;
; PURPOSE: Run PLOT_ALFVEN_STATS_IMF_SCREENING in batches
;
; INPUTS: Anything that can be passed to alfven_stats_imf_screen can also be passed to the batch
;            version, due to the use of inheritance of keywords.
;
; MODIFICATION HISTORY:
;      
;      01/26/2014 Born in Wilder 315
;
;-
PRO BATCH_PLOT_ALFVEN_STATS_IMF_SCREENING,PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                          MASKMIN=maskMin,DIRECTIONS=directions, ALL=all, $
                                          EPLOTS=ePlots, ENUMFLPLOTS=eNumFlPlots, IONPLOTS=ionPlots, $
                                          PPLOTS=pPlots,CHAREPLOTS=charEPlots, ORBPLOTS=orbPlots, $
                                          NEVENTPERMINPLOT=nEventPerMinPlot, $
                                          _EXTRA=e
;                                          _REF_EXTRA=e

  IF KEYWORD_SET(all) AND NOT KEYWORD_SET(directions) THEN BEGIN
     directions=['dawnward', 'duskward', 'all_IMF', 'bzNorth', 'bzSouth']
  ENDIF

  IF NOT KEYWORD_SET(directions) THEN BEGIN
     directions=['dawnward', 'duskward'] ;default
  ENDIF
  PRINT,FORMAT='("IMF ORIENTATIONS: ",T30,(5(A10)))',directions

  ;plot prefix
  IF NOT KEYWORD_SET(plotDir) THEN BEGIN
     plotDir='Foolin_round_01262015/'
  ENDIF
  PRINT,"Plot directory: " + plotDir

  ;mask min
  IF N_ELEMENTS(maskMin) EQ 0 THEN BEGIN
     maskMin = 4
  ENDIF
  PRINT,"Mask min: " + strcompress(maskMin,/REMOVE_ALL)

  ;;loop over IMF orientations
  FOR i=0,N_ELEMENTS(directions)-1 DO BEGIN

     ;;electron plots
     IF KEYWORD_SET(ePlots) THEN BEGIN
;;        plot_alfven_stats_imf_screening,clockstr=directions[i],PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix,efluxplottype="Max",/logefplot,EPLOTS=ePlots,/medianplot,maskmin=maskMin,customerange=[-1,1.5],/nonegeflux, _extra=e
        plot_alfven_stats_imf_screening, clockstr=directions[i], PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                         EPLOTS=ePlots, maskmin=maskMin, _extra=e
     ENDIF
     
     ;;electron number flux plots
     IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
;;        plot_alfven_stats_imf_screening,clockstr=directions[i],PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix,efluxplottype="Max",/logefplot,EPLOTS=ePlots,/medianplot,maskmin=maskMin,customerange=[-1,1.5],/nonegeflux, _extra=e
        plot_alfven_stats_imf_screening, clockstr=directions[i], PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                         ENUMFLPLOTS=eNumFlPlots, maskmin=maskMin, _extra=e
     ENDIF

     ;;ion plots
     IF KEYWORD_SET(ionPlots) THEN BEGIN
;;        plot_alfven_stats_imf_screening,clockstr=directions[i],PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix,efluxplottype="Max",/logefplot,EPLOTS=ePlots,/medianplot,maskmin=maskMin,customerange=[-1,1.5],/nonegeflux, _extra=e
        plot_alfven_stats_imf_screening, clockstr=directions[i], PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                         IONPLOTS=ionPlots, maskmin=maskMin, _extra=e
     ENDIF
     
     ;;pflux plots
     IF KEYWORD_SET(pPlots) THEN BEGIN
;;        plot_alfven_stats_imf_screening,clockstr=directions[i],PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
;;                                        /logpfplot,PPLOTS=pPlots,/medianplot,maskmin=maskMin,customprange=[-1.3,1.7],/nonegpflux,_extra=e
        plot_alfven_stats_imf_screening, clockstr=directions[i], PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                         maskmin=maskMin, PPLOTS=pPlots, _EXTRA=e
     ENDIF
     
     IF KEYWORD_SET(charEPlots) THEN BEGIN
        plot_alfven_stats_imf_screening, clockstr=directions[i], PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                         CHAREPLOTS=charEPlots, maskmin=maskMin, _extra=e
     ENDIF
     
     ;;various orbit plots
     IF KEYWORD_SET(orbPlots) OR KEYWORD_SET(orbFreqPlot) OR KEYWORD_SET(orbTotPlot) OR KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN
        plot_alfven_stats_imf_screening,clockstr=directions[i],PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                        maskmin=maskMin, _EXTRA=e
     ENDIF
     
     ;;N event per min
     IF KEYWORD_SET(nEventPerMinPlot) THEN BEGIN
        plot_alfven_stats_imf_screening,clockstr=directions[i],PLOTDIR=plotDir,PLOTPREFIX=plotPrefix,PLOTSUFFIX=plotSuffix, $
                                        maskmin=maskMin,/NEVENTPERMINPLOT, _EXTRA=e
     ENDIF


  ENDFOR

END