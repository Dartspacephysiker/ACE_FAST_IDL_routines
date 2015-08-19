
;2015/08/19
;The fast and reasonable way to get info on a given maximus DB quantity

PRO HISTOS_AND_LIMS_FOR_MAXIMUS_QUANTITY,maximus,maxInd,maxIndName, $
                                         LOGLOWLIM=logLowLim,LOGHIGHLIM=logHighLim,LOWLIM=lowLim,highLim=highLim, $
                                         LUN=lun,DO_OUTPUT=do_output

  defLogLowLim  = -3
  defLogHighLim =  5
  defLowLim     =  0.0
  defHighLim    =  1.0e3

  defDo_output = 0

  maxTags=TAG_NAMES(maximus)

  IF N_ELEMENTS(maxInd) EQ 0 THEN BEGIN

     PRINT,'No provided maxInd! Here are the names of them for you: '
     FOR i=0,N_ELEMENTS(maxTags)-1 DO PRINTF,LUN,FORMAT='(I0,T8,A0)',i,maxTags(i)

     RETURN
  ENDIF

  IF N_ELEMENTS(maxIndName) EQ 0 THEN maxIndName = maxTags(maxInd)

  IF N_ELEMENTS(logLowLim) EQ 0 THEN logLowLim = deflogLowLim
  IF N_ELEMENTS(logHighLim) EQ 0 THEN logHighLim = deflogHighLim
  IF N_ELEMENTS(lowLim) EQ 0 THEN lowLim = deflowLim
  IF N_ELEMENTS(highLim) EQ 0 THEN highLim = defhighLim

  IF N_ELEMENTS(do_output) EQ 0 THEN do_output = defDo_output

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  negInd = WHERE(maximus.(maxInd) LT 0,nNeg,/NULL)
  posInd = WHERE(maximus.(maxInd) GT 0,nPos,/NULL)

  nPlots = (nPos GT 0) + (nNeg GT 0) + 1

  ;;************************************************************
  ;;Now the printing

  PRINTF,lun,''
  PRINTF,lun,'==LIMITS=='
  PRINTF,lun,FORMAT='("logLowLim",T12,": ",I0)',logLowLim
  PRINTF,lun,FORMAT='("logHighLim",T12,": ",I0)',logHighLim
  PRINTF,lun,FORMAT='("lowLim",T12,": ",I0)',lowLim
  PRINTF,lun,FORMAT='("highLim",T12,": ",I0)',highLim
  PRINTF,lun,''

  ;;a window
  cgwindow,wxsize=1000,wysize=700;,waspect=1.0

  ;;all inds
  cghistoplot,ALOG10(ABS(maximus.(maxInd))),title=maxIndName, $
              output= do_output ? 'maxHistos--' + date + '--'+maxIndName+'.png' : !NULL, $
              WINDOW=do_output ? !NULL : 1,LAYOUT=do_output ? !NULL : [1,nPlots,1]

  PRINTF,lun,FORMAT='("Out of range: ",I0)',N_ELEMENTS(WHERE(maximus.(maxInd) GT highLim OR maximus.(maxInd) LT lowLim,/NULL ))
  PRINTF,lun,FORMAT='("In range: ",I0)',N_ELEMENTS(WHERE(maximus.(maxInd) LE highLim AND maximus.(maxInd) GE lowLim,/NULL ))
  PRINTF,lun,''
  PRINTF,lun,FORMAT='("Out of range (log): ",I0)',N_ELEMENTS(WHERE(ALOG10(ABS(maximus.(maxInd))) GT logHighLim OR ALOG10(ABS(maximus.(maxInd))) LT logLowLim ,/NULL))
  PRINTF,lun,FORMAT='("In range (log): ",I0)',N_ELEMENTS(WHERE(ALOG10(ABS(maximus.(maxInd))) LE logHighLim AND ALOG10(ABS(maximus.(maxInd))) GE logLowLim,/NULL ))
  PRINTF,lun,''

  ;;just pos
  IF nPos GT 0 THEN BEGIN
     cghistoplot,ALOG10(ABS((maximus.(maxInd))(posInd))),title=maxIndName + ' GT 0', $
                 output= do_output ? 'maxHistos--' + date + '--'+maxIndName+'--LOG_GT_0.png' : !NULL, $
                 WINDOW=do_output ? !NULL : 1,LAYOUT=do_output ? !NULL : [1,nPlots,2],ADDCMD=do_output ? !NULL : 1

     PRINTF,lun,FORMAT='("Num pos: ",I0)',nPos
     PRINTF,lun,FORMAT='("Above logHighLim (log, GT 0): ",I0)',N_ELEMENTS(WHERE(ALOG10(ABS((maximus.(maxInd))(posInd))) GT logHighLim,/NULL))
     PRINTF,lun,FORMAT='("Below logHighLim (log, GT 0): ",I0)',N_ELEMENTS(WHERE(ALOG10(ABS((maximus.(maxInd))(posInd))) LE logHighLim,/NULL))
     PRINTF,lun,''

  ENDIF

  ;;just neg
  IF nNeg GT 0 THEN BEGIN
     cghistoplot,ALOG10(ABS((maximus.(maxInd))(negInd))),title=maxIndName + ' LT 0', $
                 output= do_output ? 'maxHistos--' + date + '--'+maxIndName+'--LOG_LT_0.png' : !NULL, $
                 WINDOW=do_output ? !NULL : 1,LAYOUT=do_output ? !NULL : [1,nPlots,nPlots],ADDCMD=do_output ? !NULL : 1
     
     PRINTF,lun,FORMAT='("Num neg: ",I0)',nNeg
     PRINTF,lun,FORMAT='("Above logHighLim (log, LT 0): ",I0)',N_ELEMENTS(WHERE(ALOG10(ABS((maximus.(maxInd))(negInd))) GT logHighLim,/NULL))
     PRINTF,lun,FORMAT='("Below logHighLim (log, LT 0): ",I0)',N_ELEMENTS(WHERE(ALOG10(ABS((maximus.(maxInd))(negInd))) LE logHighLim,/NULL))
     PRINTF,lun,''
  ENDIF

END