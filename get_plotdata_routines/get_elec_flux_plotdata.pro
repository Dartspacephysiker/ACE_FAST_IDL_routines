PRO GET_ELEC_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                           EFLUXPLOTTYPE=eFluxPlotType,NOPOS_EFLUX=noPos_eFlux,NONEG_EFLUX=noNeg_eFlux,LOGEFPLOT=logEfPlot, $
                           H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                           DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                           MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,LOGAVGPLOT=logAvgPlot,EPLOTRANGE=ePlotRange

     h2dEStr={tmplt_h2dStr}

     ;;If not allowing negative fluxes
     IF eFluxPlotType EQ "Integ" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNeg_eFlux) THEN BEGIN
           no_negs_i=WHERE(maximus.integ_elec_energy_flux GE 0.0)
           print,"N elements in elec data before junking neg elecData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_negs_i,plot_i)
           print,"N elements in elec data after junking neg elecData: ",N_ELEMENTS(plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPos_eFlux) THEN BEGIN
              no_pos_i=WHERE(maximus.integ_elec_energy_flux LT 0.0)
              print,"N elements in elec data before junking pos elecData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
              print,"N elements in elec data after junking pos elecData: ",N_ELEMENTS(plot_i)
           ENDIF
        ENDELSE
        elecData= maximus.integ_elec_energy_flux(plot_i) 
     ENDIF ELSE BEGIN
        IF eFluxPlotType EQ "Max" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNeg_eFlux) THEN BEGIN
              no_negs_i=WHERE(maximus.elec_energy_flux GE 0.0)
              print,"N elements in elec data before junking neg elecData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
              print,"N elements in elec data after junking neg elecData: ",N_ELEMENTS(plot_i)
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPos_eFlux) THEN BEGIN
                 no_pos_i=WHERE(maximus.elec_energy_flux LT 0.0)
                 print,"N elements in elec data before junking pos elecData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
                 print,"N elements in elec data after junking pos elecData: ",N_ELEMENTS(plot_i)
              ENDIF
           ENDELSE
           elecData = maximus.elec_energy_flux(plot_i)
        ENDIF
     ENDELSE

     ;;Handle name of data
     ;;Log plots desired?
     absEstr=""
     negEstr=""
     posEstr=""
     logEstr=""
     IF KEYWORD_SET(abs_eFlux)THEN BEGIN
        absEStr= "Abs--" 
        print,"N pos elements in elec data: ",N_ELEMENTS(where(elecData GT 0.))
        print,"N neg elements in elec data: ",N_ELEMENTS(where(elecData LT 0.))
        elecData = ABS(elecData)
     ENDIF
     IF KEYWORD_SET(noNeg_eFlux) THEN BEGIN
        negEStr = "NoNegs--"
        print,"N elements in elec data before junking neg elecData: ",N_ELEMENTS(elecData)
        elecData = elecData(where(elecData GT 0.))
        print,"N elements in elec data after junking neg elecData: ",N_ELEMENTS(elecData)
     ENDIF
     IF KEYWORD_SET(noPos_eFlux) THEN BEGIN
        posEStr = "NoPos--"
        print,"N elements in elec data before junking pos elecData: ",N_ELEMENTS(elecData)
        elecData = elecData(where(elecData LT 0.))
        print,"N elements in elec data after junking pos elecData: ",N_ELEMENTS(elecData)
        elecData = ABS(elecData)
     ENDIF
     IF KEYWORD_SET(logEfPlot) THEN logEstr="Log "
     absnegslogEstr=absEstr + negEstr + posEstr + logEstr
     efDatName = STRTRIM(absnegslogEstr,2)+"eFlux"+eFluxPlotType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 

        medHistDataDir = 'out/medHistData/'

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + efDatName+"medhist_data.sav"

        h2dEstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                 elecData,$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                 ABSMED=abs_eFlux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + efDatName + "medhist.txt"

     ENDIF ELSE BEGIN 

        elecData=(KEYWORD_SET(logAvgPlot)) ? alog10(elecData) : elecData

        h2dEStr.data=hist2d(maximus.mlt(plot_i), $
                            maximus.ilat(plot_i),$
                            elecData,$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI,$
                            OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dEStr.data(where(h2dFluxN NE 0,/NULL))=h2dEStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
        IF KEYWORD_SET(logAvgPlot) THEN h2dEStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dEStr.data(where(h2dFluxN NE 0,/null)))        

     ENDELSE

     ;data mods?
     IF KEYWORD_SET(abs_eFlux)THEN BEGIN 
        h2dEStr.data = ABS(h2dEStr.data) 
        IF keepMe THEN elecData=ABS(elecData) 
     ENDIF
     IF KEYWORD_SET(logEfPlot) THEN BEGIN 
        h2dEStr.data(where(h2dEStr.data GT 0,/NULL))=ALOG10(h2dEStr.data(where(h2dEStr.data GT 0,/null))) 
        IF keepMe THEN elecData(where(elecData GT 0,/null))=ALOG10(elecData(where(elecData GT 0,/null))) 
     ENDIF

     ;;Do custom range for Eflux plots, if requested
     ;; IF  KEYWORD_SET(EPlotRange) THEN h2dEStr.lim=TEMPORARY(EPlotRange)$
     IF  KEYWORD_SET(EPlotRange) THEN h2dEStr.lim=EPlotRange $
     ELSE h2dEStr.lim = [MIN(h2dEstr.data),MAX(h2dEstr.data)]

     h2dEStr.title= absnegslogEstr + "Electron Flux (ergs/cm!U2!N-s)"
     ;; IF KEYWORD_SET(ePlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dEStr)] 
     ;; IF KEYWORD_SET(ePlots) THEN BEGIN 
     h2dStr=[h2dStr,h2dEStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,efDatName] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(elecData)] 
     ENDIF 
     ;; ENDIF

END