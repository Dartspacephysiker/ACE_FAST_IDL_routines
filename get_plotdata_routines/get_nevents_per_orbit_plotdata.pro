;2015
;2015/10/15 This may now have some serious problems as of this date; be sure to check it!
PRO GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                   DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                   ORBFREQRANGE=orbFreqRange, $
                                   DIVNEVBYAPPLICABLE=divNEvByApplicable,H2D_NONZERO_NEV_I=h2d_Nonzero_nEv_i, $
                                   H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                                   H2DCONTRIBORBSTR=h2dContribOrbStr, H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i,$
                                   H2DTOTORBSTR=h2dTotOrbStr, H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                                   DATANAME=dataName,DATARAWPTR=dataRawPtr

  PRINT,'2015/10/15 This may now have some serious problems as of this date; be sure to check it!'
  WAIT,2

  ;;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
  ;;This makes h2dStr(1) the mask histo.
  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr = {tmplt_h2dStr}
  h2dStr.data[*,*] = 0
  h2dStr.lim=nEventPerOrbRange
  
  nEvByAppStr=""
  IF KEYWORD_SET(divNEvByApplicable) THEN nEvByAppStr="Applicable_"
  h2dStr.title= 'Number of Events per ' + nEvByAppStr + 'Orbit'
  dataName = "nEventPerOrb_" +nEvByAppStr

  h2d_nonzero_nEv_i=WHERE(h2dFluxN GT 0,/NULL)
  IF KEYWORD_SET(divNEvByApplicable) THEN BEGIN
     div_i = CGSETINTERSECTION(h2d_nonzero_contriborbs_i,h2d_nonzero_nEv_i)
     divisor = h2dContribOrbStr.data[div_i] ;Only divide by number of orbits that occurred during specified IMF conditions
  ENDIF ELSE BEGIN
     div_i = CGSETINTERSECTION(h2d_nonZero_allOrb_i,h2d_nonzero_nEv_i)
     divisor = h2dTotOrbStr.data[div_i] ;Divide by all orbits passing through relevant bin
     ENDELSE
  h2dStr.data[div_i] = h2dFluxN[div_i]/divisor
  
  IF KEYWORD_SET(logNEventPerOrb) THEN BEGIN
     h2dStr.data[where(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data GT 0,/NULL)])
     h2dStr.is_logged = 1
     dataName = "log" + dataName
     h2dStr.title = "Log " + h2dStr.title
  ENDIF
  
END