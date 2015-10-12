PRO GET_NEVENTPERMIN_PLOTDATA,THISTDENOMINATOR=tHistDenominator, $
                              LOGNEVENTPERMIN=logNEventPerMin,NEVENTPERMINRANGE=nEventPerMinRange, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                              DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme
  
     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.
     h2dNEvPerMinStr={tmplt_h2dStr}
     h2dNEvPerMinStr.data=h2dStr[0].data
     h2dNonzeroNEv_i=WHERE(h2dStr[0].data NE 0,/NULL)

     ;output from get_timehist_denominator is in seconds, but we'll do minutes
     tHistDenominator = tHistDenominator[h2dNonzeroNEv_i]/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
     h2dNEvPerMinStr.data[h2dNonzeroNEv_i]=h2dNEvPerMinStr.data[h2dNonzeroNEv_i]/tHistDenominator

     ;2015/04/09 TEMPORARILY skip the lines above because our fastLoc file currently only includes orbits 500-11000.
     ; This means that, according to fastLoc and maximus, there are events where FAST has never been!
     ; So we have to do some trickery
     ;; tHistDenominator_nonZero_i = WHERE(tHistDenominator GT 0.0)
     ;; h2dNonzeroNEv_i = cgsetintersection(tHistDenominator_nonZero_i,h2dNonzeroNEv_i)
     ;; tHistDenominator = tHistDenominator(h2dNonzeroNEv_i)/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
     ;; h2dNEvPerMinStr.data(h2dNonzeroNEv_i)=h2dNEvPerMinStr.data(h2dNonzeroNEv_i)/tHistDenominator

     logNEvStr=""
     IF KEYWORD_SET(logNEventPerMin) THEN logNEvStr="Log "
     h2dNEvPerMinStr.title= logNEvStr + 'N Events per minute'

     h2dNEvPerMinStr.lim=nEventPerMinRange
     
     IF KEYWORD_SET(logNEventPerMin) THEN BEGIN 
        h2dNEvPerMinStr.data(where(h2dNEvPerMinStr.data GT 0,/NULL))=ALOG10(h2dNEvPerMinStr.data(where(h2dNEvPerMinStr.data GT 0,/null))) 
     ENDIF

     h2dStr=[h2dStr,h2dNEvPerMinStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,logNEvStr + "nEventPerMin"] 

END


