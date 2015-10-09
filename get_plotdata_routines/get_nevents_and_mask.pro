PRO GET_NEVENTS_AND_MASK,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI,H2DSTR=h2dStr,H2DMASKSTR=h2dMaskStr,TMPLT_h2dStr=tmplt_h2dStr,DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme
  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  h2dFluxN=hist_2d(maximus.mlt(plot_i),$
                   maximus.ilat(plot_i),$
                   BIN1=binM,BIN2=binI,$
                   MIN1=MINM,MIN2=MINI,$
                   MAX1=MAXM,MAX2=MAXI)

  h2dFluxNTitle="Number of events"
  IF keepMe THEN BEGIN 
     dataNameArr="nEvents_" 
     dataRawPtrArr=PTR_NEW(h2dFluxN) 
  ENDIF

  ;; h2dStr={h2dStr, data: DOUBLE(h2dFluxN), $
  ;;         title : "Number of events", $
  ;;         lim : (KEYWORD_SET(nEventsPlotRange) AND N_ELEMENTS(nEventsPlotRange) EQ 2) ? DOUBLE(nEventsPlotRange) : DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) }
  tmplt_h2dStr={tmplt_h2dStr, data: DBLARR(n_elements(h2dFluxN(*,1)),n_elements(h2dFluxN(1,*))), $
          title : "Number of events", $
          lim : DOUBLE((KEYWORD_SET(nEventsPlotRange) AND N_ELEMENTS(nEventsPlotRange) EQ 2) ? nEventsPlotRange : [MIN(h2dFluxN),MAX(h2dFluxN)]) }

  h2dStr={tmplt_h2dStr}
  h2dStr.data=h2dFluxN
  h2dStr.title="Number of events"
  h2dStr.lim=(KEYWORD_SET(nEventsPlotRange) AND N_ELEMENTS(nEventsPlotRange) EQ 2) ? DOUBLE(nEventsPlotRange) : DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) 

  ;;Make a mask for plots so that we can show where no data exists
  h2dMaskStr={tmplt_h2dStr}
  h2dMaskStr.data=h2dFluxN
  h2dMaskStr.data(where(h2dStr.data LT maskMin,/NULL))=255
  h2dMaskStr.data(where(h2dStr.data GE maskMin,/NULL))=0
  h2dMaskStr.title="Histogram mask"

  IF keepMe THEN BEGIN 
     dataNameArr=[dataNameArr,"histoMask_"] 
     dataRawPtrArr=[dataRawPtrArr,PTR_NEW(h2dMaskStr.data)] 
  ENDIF

  IF KEYWORD_SET(do_nPlots) THEN h2dStr=[h2dStr,h2dMaskStr] ELSE h2dStr = h2dMaskStr

END