PRO GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                  ORBFREQRANGE=orbFreqRange,DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                  H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                  DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme

     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.
     h2dNEvPerOrbStr={tmplt_h2dStr}
     h2dNEvPerOrbStr.data=h2dStr[0].data
     h2dNonzeroNEv_i=WHERE(h2dStr[0].data NE 0,/NULL)
     IF KEYWORD_SET(divNEvByApplicable) THEN BEGIN
        divisor = h2dOrbStr.data(h2dNevPerOrb_i) ;Only divide by number of orbits that occurred during specified IMF conditions
     ENDIF ELSE BEGIN
        divisor = h2dTotOrbStr.data(h2dNonzeroNEv_i) ;Divide by all orbits passing through relevant bin
     ENDELSE
     h2dNEvPerOrbStr.data[h2dNonzeroNEv_i]=h2dNEvPerOrbStr.data[h2dNonzeroNEv_i]/divisor

     logNEvStr=""
     nEvByAppStr=""
     IF KEYWORD_SET(logNEventPerOrb) THEN logNEvStr="Log "
     IF KEYWORD_SET(divNEvByApplicable) THEN nEvByAppStr="Applicable_"
     h2dNEvPerOrbStr.title= logNEvStr + 'Number of Events per ' + nEvByAppStr + 'Orbit'

     IF N_ELEMENTS(nEventPerOrbRange) EQ 0 OR N_ELEMENTS(nEventPerOrbRange) NE 2 THEN BEGIN
        IF N_ELEMENTS(logNEventPerOrb) EQ 0 THEN h2dNEvPerOrbStr.lim=[0,7] ELSE h2dNEvPerOrbStr.lim=[-2,1]
     ENDIF ELSE h2dNEvPerOrbStr.lim=nEventPerOrbRange
     
     IF KEYWORD_SET(logNEventPerOrb) THEN BEGIN 
        h2dNEvPerOrbStr.data[where(h2dNEvPerOrbStr.data GT 0,/NULL)]=ALOG10(h2dNEvPerOrbStr.data[where(h2dNEvPerOrbStr.data GT 0,/null)])
     ENDIF

     h2dStr=[h2dStr,h2dNEvPerOrbStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,logNEvStr + "nEventPerOrb_" +nEvByAppStr] 

END