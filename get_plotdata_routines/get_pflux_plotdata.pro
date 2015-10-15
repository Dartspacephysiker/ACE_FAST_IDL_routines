PRO GET_PFLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PPLOTRANGE=PPlotRange, $
                       NOPOSPFLUX=noPosPflux,NONEGPFLUX=noNegPflux,ABSPFLUX=absPflux,LOGPFPLOT=logPfPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot, $
                       WRITEHDF5=writeHDF5,WRITEASCII=writeASCII,SQUAREPLOT=squarePlot,SAVERAW=saveRaw
  
  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}

  ;;check for NaNs
  goodPF_i = WHERE(FINITE(maximus.pFluxEst),NCOMPLEMENT=lostNans)
  IF goodPF_i[0] NE -1 THEN BEGIN
     print,"Found some NaNs in Poynting flux! Losing another " + strcompress(lostNans,/REMOVE_ALL) + " events..."
     plot_i = cgsetintersection(plot_i,goodPF_i)
  ENDIF
  
  IF KEYWORD_SET(noNegPflux) THEN BEGIN
     no_negs_i=WHERE(maximus.pFluxEst GE 0.0)
     plot_i=cgsetintersection(no_negs_i,plot_i)
  ENDIF

  IF KEYWORD_SET(noPosPflux) THEN BEGIN
     no_pos_i=WHERE(maximus.pFluxEst LE 0.0)
     plot_i=cgsetintersection(no_pos_i,plot_i)
  ENDIF

  ;;Log plots desired?
  absPstr=""
  negPstr=""
  posPstr=""
  logPstr=""
  IF KEYWORD_SET(absPflux) THEN absPstr= "Abs"
  IF KEYWORD_SET(noNegPflux) THEN negPstr = "NoNegs--"
  IF KEYWORD_SET(noPosPflux) THEN posPstr = "NoPos--"
  IF KEYWORD_SET(logPfPlot) THEN logPstr="Log "
  absnegslogPstr=absPstr + negPstr + posPstr + logPstr
  pfDatName = STRTRIM(absnegslogPstr,2)+"pFlux_"

  IF KEYWORD_SET(medianplot) THEN BEGIN 

     IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + pfDatName+"medhist_data.sav"

     h2dStr.data=median_hist(maximus.mlt[plot_i],(KEYWORD_SET(do_lShell) ? maximus.lShell : maximus.ILAT)[plot_i],$
                              maximus.pFluxEst[plot_i],$
                              MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                              MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI),$
                              BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                              OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT,$
                              ABSMED=absPflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

     IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + pfDatName + "medhist.txt"

  ENDIF ELSE BEGIN 
     IF KEYWORD_SET(logAvgPlot) THEN BEGIN
        maximus.pFluxEst[where(maximus.pFluxEst NE 0,/null)] = ALOG10(maximus.pFluxEst[where(maximus.pFluxEst NE 0,/null)])
     ENDIF

     h2dStr.data=hist2d(maximus.mlt[plot_i],$
                         (KEYWORD_SET(do_lShell) ? maximus.lShell : maximus.ILAT)[plot_i],$
                         maximus.pFluxEst(plot_i),$
                         MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                         MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI),$
                         BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lShell) ? binL : binI)) 
     h2dStr.data(where(h2dFluxN NE 0,/null))=h2dStr.data(where(h2dFluxN NE 0,/null))/h2dFluxN(where(h2dFluxN NE 0,/null)) 
     IF KEYWORD_SET(logAvgPlot) THEN h2dStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dStr.data(where(h2dFluxN NE 0,/null)))
  ENDELSE

  IF KEYWORD_SET(writeHDF5) or KEYWORD_SET(writeASCII) OR NOT KEYWORD_SET(squarePlot) OR KEYWORD_SET(saveRaw) THEN pData=maximus.pFluxEst(plot_i)

  ;;data mods?
  IF KEYWORD_SET(absPflux) THEN BEGIN 
     h2dStr.data = ABS(h2dStr.data) 
     pData=ABS(pData) 
  ENDIF

  IF KEYWORD_SET(logPfPlot) THEN BEGIN 
     h2dStr.data(where(h2dStr.data GT 0,/null))=ALOG10(h2dStr.data(where(h2dStr.data GT 0,/NULL))) 
     pData[where(pData GT 0,/NULL)]=ALOG10(pData[where(pData GT 0,/NULL)])
  ENDIF

  h2dStr.title= absnegslogPstr + "Poynting Flux (mW/m!U2!N)"

  ;;Do custom range for Pflux plots, if requested
  ;; IF KEYWORD_SET(PPlotRange) THEN h2dStr.lim=PPlotRange $
  ;; ELSE h2dStr.lim = [MIN(h2dStr.data),MAX(h2dStr.data)]
  h2dStr.lim = PPlotRange

  dataRawPtr=PTR_NEW(pData)


END