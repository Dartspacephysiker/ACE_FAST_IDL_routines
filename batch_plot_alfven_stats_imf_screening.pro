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
PRO BATCH_PLOT_ALFVEN_STATS_IMF_SCREENING,PLOTPREFIX=plotPrefix,MASKMIN=maskMin,DIRECTIONS=directions, ALL=all, $
                                          EPLOTS=ePlots,PPLOTS=pPlots,ORBPLOTS=orbPlots, $
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
  IF NOT KEYWORD_SET(plotPrefix) THEN BEGIN
     plotPrefix='Foolin_round_01262015/Jan262015_DB'
  ENDIF
  PRINT,"Plot prefix: " + plotPrefix

  ;mask min
  IF N_ELEMENTS(maskMin) EQ 0 THEN BEGIN
     maskMin = 4
  ENDIF
  PRINT,"Mask min: " + strcompress(maskMin,/REMOVE_ALL)

  ;;loop over IMF orientations
  FOR i=0,N_ELEMENTS(directions)-1 DO BEGIN

     ;;electron plots
     IF KEYWORD_SET(ePlots) THEN BEGIN
;;        plot_alfven_stats_imf_screening,clockstr=directions[i],plotprefix=plotPrefix,efluxplottype="Max",/logefplot,EPLOTS=ePlots,/medianplot,maskmin=maskMin,customerange=[-1,1.5],/nonegeflux, _extra=e
        plot_alfven_stats_imf_screening, clockstr=directions[i], plotprefix=plotPrefix, EPLOTS=ePlots, maskmin=maskMin, _extra=e
     ENDIF

     ;;pflux plots
     IF KEYWORD_SET(pPlots) THEN BEGIN
;;        plot_alfven_stats_imf_screening,clockstr=directions[i],plotprefix=plotPrefix,/logpfplot,PPLOTS=pPlots,/medianplot,maskmin=maskMin,customprange=[-1.3,1.7],/nonegpflux,_extra=e
        plot_alfven_stats_imf_screening, clockstr=directions[i], plotprefix=plotPrefix, maskmin=maskMin, PPLOTS=pPlots, _EXTRA=e
     ENDIF

     ;;various orbit plots
     IF KEYWORD_SET(orbPlots) OR KEYWORD_SET(orbPlot) OR KEYWORD_SET(orbFreqPlot) OR KEYWORD_SET(orbTotPlot) OR KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN
        plot_alfven_stats_imf_screening,clockstr=directions[i],plotprefix=plotPrefix,maskmin=maskMin,customprange=[-1.3,1.7], _EXTRA=e
     ENDIF
     


  ENDFOR

END