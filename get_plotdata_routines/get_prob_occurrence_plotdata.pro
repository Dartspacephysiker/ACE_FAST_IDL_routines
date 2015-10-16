;;2015/10/12 Created
;;The DO_WIDTH_X keyword allows one to use spatial width of the current filaments instead of temporal, if so desired
PRO GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                 LOGPROBOCCURRENCE=logProbOccurrence, PROBOCCURRENCERANGE=probOccurrenceRange,DO_WIDTH_X=do_width_x, $
                                 MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                 DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                 OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                 H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                                 DATANAME=dataName,DATARAWPTR=dataRawPtr

  COMPILE_OPT idl2
  
  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  
  logProbStr = ''
  IF KEYWORD_SET(logProbOccurrence) THEN logProbStr = 'Log '
  
  h2dStr.lim = probOccurrenceRange
  h2dStr.title= logProbStr + "Probability of occurrence"

  ;; IF KEYWORD_SET(do_lshell) THEN BEGIN
     

  IF KEYWORD_SET(do_width_x) THEN BEGIN
     widthData = maximus.width_x[plot_i]
     probDatName = "prob--width_time"
  ENDIF ELSE BEGIN
     widthData = maximus.width_time[plot_i]
     probDatName = "prob--width_x"
  ENDELSE

  h2dStr.data=hist2d(maximus.mlt[plot_i], $
                      (KEYWORD_SET(do_lshell) ? maximus.lshell[plot_i] : maximus.ilat[plot_i]),$
                      widthData,$
                      MIN1=MINM,MIN2=(KEYWORD_SET(do_lshell) ? minL : minI),$
                      MAX1=MAXM,MAX2=(KEYWORD_SET(do_lshell) ? maxL : maxI),$
                      BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                      OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
  
  ;;make sure this makes any sense
  this = WHERE( h2dstr.data EQ 0 )
  that = WHERE( thistdenominator EQ 0 )
  nBad = 0
  FOR i=0,N_ELEMENTS(that)-1 DO BEGIN
     test = WHERE( that[i] EQ this )
     IF test[0] EQ -1 THEN nBad++        

  ENDFOR
  IF nBad GT 0 THEN BEGIN
     PRINT,STRCOMPRESS(nBad,/REMOVE_ALL) + " instances in the widthData histo where there are supposedly events, but the ephemeris data reports fast was never there!"
     PRINT,"Absurdity"
     STOP
  ENDIF

  h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]/tHistDenominator[WHERE(h2dstr.data GT 0)]

  IF KEYWORD_SET(logProbOccurrence) THEN BEGIN 
     h2dStr.data[where(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data GT 0,/null)]) 
     widthData[where(widthData GT 0,/null)]=ALOG10(widthData[where(widthData GT 0,/null)]) 
  ENDIF

  dataName = "probOccurrence"
  dataRawPtr = PTR_NEW(widthData)
  
END