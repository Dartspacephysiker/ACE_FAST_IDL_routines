PRO GET_NEVENTS_AND_MASK,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                         DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                         NEVENTSPLOTRANGE=nEventsPlotRange, $
                         H2DSTR=h2dStr,H2DMASKSTR=h2dMaskStr,H2DFLUXN=h2dFluxN,MASKMIN=maskMin, $
                         TMPLT_H2DSTR=tmplt_h2dStr, $
                         DATANAME=dataName,DATARAWPTR=dataRawPtr

  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  h2dFluxN=hist_2d(maximus.mlt(plot_i),$
                   (KEYWORD_SET(do_lshell) ? maximus.lshell : maximus.ilat)(plot_i),$
                   BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                   MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                   MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))

  h2dFluxNTitle="Number of events"
  dataName="nEvents_"
  dataRawPtr=PTR_NEW(h2dFluxN) 


  ;; tmplt_h2dStr={tmplt_h2dStr, data: DBLARR(n_elements(h2dFluxN[*,1]),n_elements(h2dFluxN[1,*])), $
  ;;         title : "Number of events", $
  ;;         lim : DOUBLE((KEYWORD_SET(nEventsPlotRange) AND N_ELEMENTS(nEventsPlotRange) EQ 2) ? nEventsPlotRange : [MIN(h2dFluxN),MAX(h2dFluxN)]) }
  tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                             MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                             MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))

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

END