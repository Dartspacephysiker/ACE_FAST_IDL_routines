PRO GET_NEVENTPERMIN_PLOTDATA,THISTDENOMINATOR=tHistDenominator, $
                              MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                              DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                              LOGNEVENTPERMIN=logNEventPerMin,NEVENTPERMINRANGE=nEventPerMinRange, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                              DATANAME=dataName,DATARAWPTR=dataRawPtr
  
     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.


  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  h2dStr.title = 'N Events per minute'
  dataName = "nEventPerMin"
  h2dStr.lim=nEventPerMinRange

  h2dStr.data=h2dFluxN
  h2dNonzeroNEv_i=WHERE(h2dFluxN NE 0,/NULL)
  
                                ;output from get_timehist_denominator is in seconds, but we'll do minutes
  tHistDenominator = tHistDenominator[h2dNonzeroNEv_i]/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
  h2dStr.data[h2dNonzeroNEv_i]=h2dStr.data[h2dNonzeroNEv_i]/tHistDenominator
  
                                ;2015/04/09 TEMPORARILY skip the lines above because our fastLoc file currently only includes orbits 500-11000.
                                ; This means that, according to fastLoc and maximus, there are events where FAST has never been!
                                ; So we have to do some trickery
  ;; tHistDenominator_nonZero_i = WHERE(tHistDenominator GT 0.0)
  ;; h2dNonzeroNEv_i = cgsetintersection(tHistDenominator_nonZero_i,h2dNonzeroNEv_i)
  ;; tHistDenominator = tHistDenominator(h2dNonzeroNEv_i)/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
  ;; h2dStr.data(h2dNonzeroNEv_i)=h2dStr.data(h2dNonzeroNEv_i)/tHistDenominator
  
  IF KEYWORD_SET(logNEventPerMin) THEN BEGIN
     h2dStr.is_logged = 1
     h2dStr.data(where(h2dStr.data GT 0,/NULL))=ALOG10(h2dStr.data(where(h2dStr.data GT 0,/null))) 
     h2dStr.title = "Log " + h2dStr.title
     h2dStr.lim = ALOG10(h2dStr.lim)
  ENDIF

  dataRawPtr = PTR_NEW(h2dStr.data)

END


