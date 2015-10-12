PRO GET_PFLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       PPLOTRANGE=PPlotRange, $
                       NOPOSPFLUX=noPosPflux,NONEGPFLUX=noNegPflux,ABSPFLUX=absPflux,LOGPFPLOT=logPfPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT, $
                       WRITEHDF5=writeHDF5,WRITEASCII=writeASCII,SQUAREPLOT=squarePlot,SAVERAW=saveRaw
  
  h2dPStr={tmplt_h2dStr}

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

     h2dPstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                              maximus.pFluxEst(plot_i),$
                              MIN1=MINM,MIN2=MINI,$
                              MAX1=MAXM,MAX2=MAXI,$
                              BINSIZE1=binM,BINSIZE2=binI,$
                              OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT,$
                              ABSMED=absPflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

     IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + pfDatName + "medhist.txt"

  ENDIF ELSE BEGIN 
     IF KEYWORD_SET(logAvgPlot) THEN BEGIN
        maximus.pFluxEst[where(maximus.pFluxEst NE 0,/null)] = ALOG10(maximus.pFluxEst[where(maximus.pFluxEst NE 0,/null)])
     ENDIF

     h2dPStr.data=hist2d(maximus.mlt(plot_i),$
                         maximus.ilat(plot_i),$
                         maximus.pFluxEst(plot_i),$
                         MIN1=MINM,MIN2=MINI,$
                         MAX1=MAXM,MAX2=MAXI,$
                         BINSIZE1=binM,BINSIZE2=binI) 
     h2dPStr.data(where(h2dFluxN NE 0,/null))=h2dPStr.data(where(h2dFluxN NE 0,/null))/h2dFluxN(where(h2dFluxN NE 0,/null)) 
     IF KEYWORD_SET(logAvgPlot) THEN h2dPStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dPStr.data(where(h2dFluxN NE 0,/null)))
  ENDELSE

  IF KEYWORD_SET(writeHDF5) or KEYWORD_SET(writeASCII) OR NOT KEYWORD_SET(squarePlot) OR KEYWORD_SET(saveRaw) THEN pData=maximus.pFluxEst(plot_i)

  ;;data mods?
  IF KEYWORD_SET(absPflux) THEN BEGIN 
     h2dPStr.data = ABS(h2dPStr.data) 
     IF keepMe THEN pData=ABS(pData) 
  ENDIF

  IF KEYWORD_SET(logPfPlot) THEN BEGIN 
     h2dPStr.data(where(h2dPStr.data GT 0,/null))=ALOG10(h2dPStr.data(where(h2dPStr.data GT 0,/NULL))) 
     IF keepMe THEN pData[where(pData GT 0,/NULL)]=ALOG10(pData[where(pData GT 0,/NULL)])
  ENDIF

  h2dPStr.title= absnegslogPstr + "Poynting Flux (mW/m!U2!N)"

  ;;Do custom range for Pflux plots, if requested
  ;; IF KEYWORD_SET(PPlotRange) THEN h2dPStr.lim=PPlotRange $
  ;; ELSE h2dPStr.lim = [MIN(h2dPstr.data),MAX(h2dPstr.data)]
  h2dPStr.lim = PPlotRange

  h2dStr=[h2dStr,h2dPStr] 
  IF keepMe THEN BEGIN 
     dataNameArr=[dataNameArr,pfDatName] 
     dataRawPtrArr=[dataRawPtrArr,PTR_NEW(pData)] 
  ENDIF  

END