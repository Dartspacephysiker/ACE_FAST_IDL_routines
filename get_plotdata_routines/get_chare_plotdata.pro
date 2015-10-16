PRO GET_CHARE_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       CHARETYPE=charEType,CHAREPLOTRANGE=charEPlotRange, $
                       NOPOSCHARE=noPosCharE,NONEGCHARE=noNegCharE,ABSCHARE=absCharE,LOGCHAREPLOT=logCharEPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,LOGAVGPLOT=logAvgPlot,EPLOTRANGE=ePlotRange, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme

     PRINT,"Fix h2dstr stuff and data array at bottom, and make sure a template gets here!"
     STOP

     h2dCharEStr={tmplt_h2dStr}

     ;;If not allowing negative fluxes
     IF charEType EQ "lossCone" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_losscone),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegCharE) THEN BEGIN
           no_negs_i=WHERE(maximus.max_chare_losscone GE 0.0)
           print,"N elements in elec data before junking negs elecData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_negs_i,plot_i)
           print,"N elements in elec data after junking negs elecData: ",N_ELEMENTS(plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosCharE) THEN BEGIN
              no_pos_i=WHERE(maximus.max_chare_losscone LT 0.0)
              print,"N elements in elec data before junking pos elecData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
              print,"N elements in elec data after junking pos elecData: ",N_ELEMENTS(plot_i)
           ENDIF
        ENDELSE
        charEData=maximus.max_chare_losscone(plot_i) 
     ENDIF ELSE BEGIN
        IF charEType EQ "Total" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_total),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegCharE) THEN BEGIN
              no_negs_i=WHERE(maximus.max_chare_total GE 0.0)
              print,"N elements in elec data before junking neg elecData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
              print,"N elements in elec data after junking neg elecData: ",N_ELEMENTS(plot_i)
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosCharE) THEN BEGIN
                 no_pos_i=WHERE(maximus.max_chare_total LT 0.0)
                 print,"N elements in elec data before junking pos elecData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
                 print,"N elements in elec data after junking pos elecData: ",N_ELEMENTS(plot_i)
              ENDIF
           ENDELSE
           charEData=maximus.max_chare_total(plot_i)
        ENDIF
     ENDELSE

     ;get data name ready
     absCharEStr=""
     negCharEStr=""
     posCharEStr=""
     logCharEStr=""
     IF KEYWORD_SET(absCharE)THEN absCharEStr= "Abs--" 
     IF KEYWORD_SET(noNegCharE) THEN negCharEStr = "NoNegs--"
     IF KEYWORD_SET(noPosCharE) THEN posCharEStr = "NoPos--"
     IF KEYWORD_SET(logCharEPlot) THEN logCharEStr="Log "
     absnegslogCharEStr=absCharEStr + negCharEStr + posCharEStr + logCharEStr
     chareDatName = STRTRIM(absnegslogCharEStr,2)+"charE"+charEType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 
        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + chareDatName+"medhist_data.sav"

        h2dCharEStr.data=median_hist(maximus.mlt(plot_i),(KEYWORD_SET(do_lshell) ? maximus.lshell(plot_i) : maximus.ilat(plot_i)),$
                                     charEData,$
                                     MIN1=MINM,MIN2=(KEYWORD_SET(do_lshell) ? minL : minI),$
                                     MAX1=MAXM,MAX2=(KEYWORD_SET(do_lshell) ? maxL : maxI),$
                                     BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                                     OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                     ABSMED=absCharE,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + chareDatName + "medhist.txt"
        
     ENDIF ELSE BEGIN 
        charEData=(KEYWORD_SET(logAvgPlot)) ? alog10(charEData) : charEData

        h2dCharEStr.data=hist2d(maximus.mlt(plot_i), $
                                (KEYWORD_SET(do_lshell) ? maximus.lshell(plot_i) : maximus.ilat(plot_i)),$
                                charEData,$
                                MIN1=MINM,MIN2=(KEYWORD_SET(do_lshell) ? minL : minI),$
                                MAX1=MAXM,MAX2=(KEYWORD_SET(do_lshell) ? maxL : maxI),$
                                BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                                OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dCharEStr.data(where(h2dFluxN NE 0,/NULL))=h2dCharEStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
        IF KEYWORD_SET(logAvgPlot) THEN h2dCharEStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dCharEStr.data(where(h2dFluxN NE 0,/null)))        
     ENDELSE 

     ;;data mods?
     IF KEYWORD_SET(absCharE)THEN BEGIN 
        h2dCharEStr.data = ABS(h2dCharEStr.data) 
        IF keepMe THEN charEData=ABS(charEData) 
     ENDIF
     IF KEYWORD_SET(logCharEPlot) THEN BEGIN 
        h2dCharEStr.data(where(h2dCharEStr.data GT 0,/NULL))=ALOG10(h2dCharEStr.data(where(h2dCharEStr.data GT 0,/null))) 
        IF keepMe THEN charEData(where(charEData GT 0,/null))=ALOG10(charEData(where(charEData GT 0,/null))) 
     ENDIF

     ;;Do custom range for charE plots, if requested
     ;; IF  KEYWORD_SET(CharEPlotRange) THEN h2dCharEStr.lim=TEMPORARY(charEPlotRange)$
     ;;IF  KEYWORD_SET(CharEPlotRange) THEN h2dCharEStr.lim=CharEPlotRange $
     ;;ELSE h2dCharEStr.lim = [MIN(h2dCharEStr.data),MAX(h2dCharEStr.data)]
     ;;h2dCharEStr.lim = [MIN(h2dCharEStr.data),MAX(h2dCharEStr.data)]
     h2dCharEStr.lim = charEPlotRange

     h2dCharEStr.title= absnegslogCharEStr + "Characteristic Energy (eV)"
     ;; IF KEYWORD_SET(charEPlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dCharEStr)] 
     ;; IF KEYWORD_SET(charEPlots) THEN BEGIN 
     h2dStr=[h2dStr,h2dCharEStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,chareDatName] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(charEData)]
     ENDIF 
     ;; ENDIF

;;   undefine,h2dCharEStr   ;;,charEData 

END