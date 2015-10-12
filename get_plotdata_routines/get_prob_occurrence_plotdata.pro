;;2015/10/12 Created
;;The DO_WIDTH_X keyword allows one to use spatial width of the current filaments instead of temporal, if so desired
PRO GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                 LOGPROBOCCURRENCE=logProbOccurrence, PROBOCCURRENCERANGE=probOccurrenceRange, DO_WIDTH_X=do_width_x, $
                                 MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                 H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                                 DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme

  COMPILE_OPT idl2
  
  h2dProbStr={tmplt_h2dStr}
  
  logProbStr = ''
  IF KEYWORD_SET(logProbOccurrence) THEN logProbStr = 'Log '
  
  h2dProbStr.lim = probOccurrenceRange
  h2dProbStr.title= logProbStr + "Probability of occurrence"

  IF KEYWORD_SET(DO_WIDTH_X) THEN BEGIN
     widthData = maximus.width_x 
     probDatName = "prob--width_time"
  ENDIF ELSE BEGIN
     widthData = maximus.width_time
     probDatName = "prob--width_x"
  ENDELSE

  h2dProbStr.data=hist2d(maximus.mlt(plot_i), $
                      maximus.ilat(plot_i),$
                      widthData,$
                      MIN1=MINM,MIN2=MINI,$
                      MAX1=MAXM,MAX2=MAXI,$
                      BINSIZE1=binM,BINSIZE2=binI,$
                      OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
  
  h2dProbStr.data = h2dProbStr.data/tHistDenominator


  IF KEYWORD_SET(logProbOccurrence) THEN BEGIN 
     h2dProbStr.data[where(h2dProbStr.data GT 0,/NULL)]=ALOG10(h2dProbStr.data[where(h2dProbStr.data GT 0,/null)]) 
     IF keepMe THEN widthData[where(widthData GT 0,/null)]=ALOG10(widthData[where(widthData GT 0,/null)]) 
  ENDIF

  h2dStr=[h2dStr,h2dProbStr] 
  IF keepMe THEN BEGIN 
     dataNameArr=[dataNameArr,efDatName] 
     dataRawPtrArr=[dataRawPtrArr,PTR_NEW(widthData)] 
  ENDIF 
  

END