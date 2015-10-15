;2015
;2015/10/15 This may now have some serious problems as of this date; be sure to check it!
PRO GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                   DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                   ORBFREQRANGE=orbFreqRange,DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                   H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                   DATANAME=dataName,DATARAWPTR=dataRawPtr

  PRINT,'2015/10/15 This may now have some serious problems as of this date; be sure to check it!'
  WAIT,2

  ;;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
  ;;This makes h2dStr(1) the mask histo.
  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  h2dStr.data=h2dFluxN
  h2dNonzeroNEv_i=WHERE(h2dFluxN NE 0,/NULL)
  IF KEYWORD_SET(divNEvByApplicable) THEN BEGIN
     divisor = h2dOrbStr.data(h2dNevPerOrb_i) ;Only divide by number of orbits that occurred during specified IMF conditions
  ENDIF ELSE BEGIN
     divisor = h2dTotOrbStr.data(h2dNonzeroNEv_i) ;Divide by all orbits passing through relevant bin
     ENDELSE
  h2dStr.data[h2dNonzeroNEv_i]=h2dStr.data[h2dNonzeroNEv_i]/divisor
  
  logNEvStr=""
  nEvByAppStr=""
  IF KEYWORD_SET(logNEventPerOrb) THEN logNEvStr="Log "
  IF KEYWORD_SET(divNEvByApplicable) THEN nEvByAppStr="Applicable_"
  h2dStr.title= logNEvStr + 'Number of Events per ' + nEvByAppStr + 'Orbit'
  
  IF N_ELEMENTS(nEventPerOrbRange) EQ 0 OR N_ELEMENTS(nEventPerOrbRange) NE 2 THEN BEGIN
     IF N_ELEMENTS(logNEventPerOrb) EQ 0 THEN h2dStr.lim=[0,7] ELSE h2dStr.lim=[-2,1]
  ENDIF ELSE h2dStr.lim=nEventPerOrbRange
  
  IF KEYWORD_SET(logNEventPerOrb) THEN BEGIN 
     h2dStr.data[where(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data GT 0,/null)])
  ENDIF
  
  dataName = logNEvStr + "nEventPerOrb_" +nEvByAppStr
  
END