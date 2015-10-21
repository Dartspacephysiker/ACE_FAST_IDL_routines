PRO fastloc_intervals__use_raw_to_reduce_2d_histos

  rawFile='rawsaves/fluxplots_North_avg_duskward--1stable--OMNI_GSM_byMin_5.0_Apr_20_15.dat'
  
  restore,rawfile

  ;; i_nEvents = -1
  ;; FOR i=0,N_ELEMENTS(dataName)-1 DO BEGIN
  ;;    IF dataName[i] EQ 'nEvents_' THEN i_nEvents = i
  ;; ENDFOR

  ;; nEvents = 

  ;check
  ;; print,(indgen((maxm-minm)/binm+1)*bini +minm)
  ;; print,(indgen((maxi-mini)/bini+1)*bini +mini)

  nEventsMLTHisto=TOTAL(h2dFluxN,2)
  nEventsILATHisto=TOTAL(h2dFluxN,1)

  

END