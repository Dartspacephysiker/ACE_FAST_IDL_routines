FUNCTION GET_ELEC_NUMFLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                   DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                   ENUMFLPLOTTYPE=eNumFlPlotType,EPLOTRANGE=ePlotRange, $
                                   NOPOSENUMFL=noPosENumFl,NONEGENUMFL=noNegENumFl,ABSENUMFL=absENumFl,LOGEFPLOT=logEfPlot, $
                                   H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                                   DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                                   OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                   MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                                   LOGAVGPLOT=logAvgPlot

                                   

  h2dENumStr={tmplt_h2dStr}
  
  ;;If not allowing negative fluxes
  IF STRLOWCASE(eNumFlPlotType) EQ STRLOWCASE("Total_Eflux_Integ") THEN BEGIN
     plot_i=cgsetintersection(WHERE(FINITE(maximus.total_eflux_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
     print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
     IF KEYWORD_SET(noNegENumFl) THEN BEGIN
        no_negs_i=WHERE(maximus.total_eflux_integ GE 0.0)
        print,"N elements in elec #flux data before junking neg elecNumFData: ",N_ELEMENTS(plot_i)
        plot_i=cgsetintersection(no_negs_i,plot_i)
        print,"N elements in elec #flux data after junking neg elecNumFData: ",N_ELEMENTS(plot_i)
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(noPosENumFl) THEN BEGIN
           no_pos_i=WHERE(maximus.total_eflux_integ LT 0.0)
           print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_pos_i,plot_i)        
           print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(plot_i)
        ENDIF
     ENDELSE
     elecNumFData= maximus.total_eflux_integ[plot_i] 
  ENDIF ELSE BEGIN
     IF STRLOWCASE(eNumFlPlotType) EQ STRLOWCASE("Eflux_Losscone_Integ") THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.eflux_losscone_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegENumFl) THEN BEGIN
           no_negs_i=WHERE(maximus.eflux_losscone_integ GE 0.0)
           print,"N elements in elec data before junking neg elecNumFData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_negs_i,plot_i)        
           print,"N elements in elec data after junking neg elecNumFData: ",N_ELEMENTS(plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosENumFl) THEN BEGIN
              no_pos_i=WHERE(maximus.eflux_losscone_integ LT 0.0)
              print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
              print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(plot_i)
           ENDIF
        ENDELSE
        elecNumFData = maximus.eflux_losscone_integ[plot_i]
     ENDIF ELSE BEGIN
        IF STRLOWCASE(eNumFlPlotType) EQ STRLOWCASE("ESA_Number_flux") THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.esa_current),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegENumFl) THEN BEGIN
              no_negs_i=WHERE(maximus.esa_current GE 0.0)
              print,"N elements in elec #flux data before junking neg elecNumFData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_negs_i,plot_i)
              print,"N elements in elec #flux data after junking neg elecNumFData: ",N_ELEMENTS(plot_i)
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosENumFl) THEN BEGIN
                 no_pos_i=WHERE(maximus.esa_current LT 0.0)
                 print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
                 print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(plot_i)
              ENDIF
           ENDELSE
        ENDIF
        ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
        elecNumFData= maximus.esa_current[plot_i] * 1. / 1.6e-9
     ENDELSE
  ENDELSE

  ;;Handle name of data
  ;;Log plots desired?
  absEFStr=""
  negEFStr=""
  posEFStr=""
  logEFStr=""
  IF KEYWORD_SET(absENumFl)THEN BEGIN
     absEFStr= "Abs--" 
     print,"N pos elements in elec data: ",N_ELEMENTS(where(elecNumFData GT 0.))
     print,"N neg elements in elec data: ",N_ELEMENTS(where(elecNumFData LT 0.))
     elecNumFData = ABS(elecNumFData)
  ENDIF
  IF KEYWORD_SET(noNegENumFl) THEN BEGIN
     negEStr = "NoNegs--"
     print,"N elements in elec data before junking neg elecNumFData: ",N_ELEMENTS(elecNumFData)
     elecNumFData = elecNumFData(where(elecNumFData GT 0.))
     print,"N elements in elec data after junking neg elecNumFData: ",N_ELEMENTS(elecNumFData)
  ENDIF
  IF KEYWORD_SET(noPosENumFl) THEN BEGIN
     posEStr = "NoPos--"
     print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(elecNumFData)
     elecNumFData = elecNumFData(where(elecNumFData LT 0.))
     print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(elecNumFData)
     elecNumFData = ABS(elecNumFData)
  ENDIF
  IF KEYWORD_SET(logENumFlPlot) THEN logEFStr="Log "
  absnegslogEFStr=absEFStr + negEFStr + posEFStr + logEFStr
  efDatName = STRTRIM(absnegslogEFStr,2)+"eNumFl"+eNumFlPlotType+"_"

  IF KEYWORD_SET(medianplot) THEN BEGIN 

     IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + efDatName+"medhist_data.sav"

     h2dENumStr.data=median_hist(maximus.mlt[plot_i],(KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                                 elecNumFData,$
                                 MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                 MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                                 BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                                 OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT,$
                                 ABSMED=absENumFl,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

     IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + efDatName + "medhist.txt"

  ENDIF ELSE BEGIN 

     elecNumFData=(KEYWORD_SET(logAvgPlot)) ? alog10(elecNumFData) : elecNumFData

     h2dENumStr.data=hist2d(maximus.mlt[plot_i], $
                            (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                            elecNumFData,$
                            MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                            MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                            BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                            OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
     h2dENumStr.data[where(h2dFluxN NE 0,/NULL)]=h2dENumStr.data[where(h2dFluxN NE 0,/NULL)]/h2dFluxN[where(h2dFluxN NE 0,/NULL)]
     IF KEYWORD_SET(logAvgPlot) THEN h2dENumStr.data[where(h2dFluxN NE 0,/null)] = 10^(h2dENumStr.data[where(h2dFluxN NE 0,/null)])

  ENDELSE

                                ;data mods?
  IF KEYWORD_SET(absENumFl)THEN BEGIN 
     h2dENumStr.data = ABS(h2dENumStr.data) 
     IF keepMe THEN elecNumFData=ABS(elecNumFData) 
  ENDIF
  IF KEYWORD_SET(logENumFlPlot) THEN BEGIN 
     h2dENumStr.data[where(h2dENumStr.data GT 0,/NULL)]=ALOG10(h2dENumStr.data[where(h2dENumStr.data GT 0,/null)])
     IF keepMe THEN elecNumFData[where(elecNumFData GT 0,/null)]=ALOG10(elecNumFData[where(elecNumFData GT 0,/null)])
  ENDIF

  ;;Do custom range for ENumFl plots, if requested
  IF  KEYWORD_SET(ENumFlPlotRange) THEN h2dENumStr.lim=ENumFlPlotRange $
  ELSE h2dENumStr.lim = [MIN(h2dENumStr.data),MAX(h2dENumStr.data)]

  h2dENumStr.title= absnegslogEFstr + "Electron Number Flux (#/cm!U2!N-s)"

  h2dStr=[h2dStr,h2dENumStr] 
  IF keepMe THEN BEGIN 
     dataNameArr=[dataNameArr,efDatName] 
     dataRawPtrArr=[dataRawPtrArr,PTR_NEW(elecNumFData)] 
  ENDIF 

END