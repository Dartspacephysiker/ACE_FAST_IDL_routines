PRO GET_IFLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       IFLUXPLOTTYPE=iFluxPlotType,iPLOTRANGE=iPlotRange, $
                       NOPOSIFLUX=noPosIflux,NONEGIFLUX=noNegIflux,ABSIFLUX=absIflux,LOGIFPLOT=logIfPlot, $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                       DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dIStr={tmplt_h2dStr}

     ;;If not allowing negative fluxes
     IF iFluxPlotType EQ "Integ" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegIflux) THEN BEGIN
           no_negs_i=WHERE(maximus.integ_ion_flux GE 0.0)
           print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_negs_i,plot_i)
           print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosIflux) THEN BEGIN
              no_pos_i=WHERE(maximus.integ_ion_flux LE 0.0)
              print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
              print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
           ENDIF
        ENDELSE
     ionData=maximus.integ_ion_flux[plot_i]
     ENDIF ELSE BEGIN
        IF ifluxPlotType EQ "Max" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegIflux) THEN BEGIN
              no_negs_i=WHERE(maximus.ion_flux GE 0.0)
              print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
              print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosIflux) THEN BEGIN
                 no_pos_i=WHERE(maximus.ion_flux LE 0.0)
                 print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
                 print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
              ENDIF
           ENDELSE
           ionData=maximus.ion_flux[plot_i]
        ENDIF ELSE BEGIN
           IF ifluxPlotType EQ "Max_Up" THEN BEGIN
              plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
              print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
              IF KEYWORD_SET(noNegIflux) THEN BEGIN
                 no_negs_i=WHERE(maximus.ion_flux_up GE 0.0)
                 print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_negs_i,plot_i)        
                 print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
              ENDIF ELSE BEGIN
                 IF KEYWORD_SET(noPosIflux) THEN BEGIN
                    no_pos_i=WHERE(maximus.ion_flux_up LE 0.0)
                    print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                    plot_i=cgsetintersection(no_pos_i,plot_i)        
                    print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
                 ENDIF
              ENDELSE
              ionData=maximus.ion_flux_up[plot_i]
           ENDIF ELSE BEGIN
              IF ifluxPlotType EQ "Integ_Up" THEN BEGIN
                 plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
                 print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                 IF KEYWORD_SET(noNegIflux) THEN BEGIN
                    no_negs_i=WHERE(maximus.integ_ion_flux_up GE 0.0)
                    print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
                    plot_i=cgsetintersection(no_negs_i,plot_i)        
                    print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
                 ENDIF ELSE BEGIN
                    IF KEYWORD_SET(noPosIflux) THEN BEGIN
                       no_pos_i=WHERE(maximus.integ_ion_flux_up LE 0.0)
                       print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                       plot_i=cgsetintersection(no_pos_i,plot_i)        
                       print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
                    ENDIF
                 ENDELSE
                 ionData=maximus.integ_ion_flux_up[plot_i]
              ENDIF ELSE BEGIN
                 IF ifluxPlotType EQ "Energy" THEN BEGIN
                    plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
                    print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                    IF KEYWORD_SET(noNegIflux) THEN BEGIN
                       no_negs_i=WHERE(maximus.ion_energy_flux GE 0.0)
                       print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
                       plot_i=cgsetintersection(no_negs_i,plot_i)        
                       print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
                    ENDIF ELSE BEGIN
                       IF KEYWORD_SET(noPosIflux) THEN BEGIN
                          no_pos_i=WHERE(maximus.ion_energy_flux LE 0.0)
                          print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                          plot_i=cgsetintersection(no_pos_i,plot_i)        
                          print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
                       ENDIF
                    ENDELSE
                    ionData=maximus.ion_energy_flux[plot_i]
                 ENDIF
              ENDELSE
           ENDELSE
        ENDELSE
     ENDELSE

     ;;Log plots desired?
     absIonStr=""
     negIonStr=""
     posIonStr=""
     logIonStr=""
     IF KEYWORD_SET(absIflux)THEN BEGIN
        absIonStr= "Abs--" 
        print,"N pos elements in ion data: ",N_ELEMENTS(where(ionData GT 0.))
        print,"N neg elements in ion data: ",N_ELEMENTS(where(ionData LT 0.))
        ionData = ABS(ionData)
     ENDIF
     IF KEYWORD_SET(noNegIflux) THEN BEGIN
        negIonStr = "NoNegs--"
        ionData = ionData(where(ionData GT 0.))
        print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(ionData)
     ENDIF
     IF KEYWORD_SET(noPosIflux) THEN BEGIN
        posIonStr = "NoPos--"
        print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(ionData)
        ionData = ionData(where(ionData LT 0.))
        print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(ionData)
        ionData = ABS(ionData)
     ENDIF
     IF KEYWORD_SET(logIfPlot) THEN logIonStr="Log "
     absnegslogIonStr=absIonStr + negIonStr + posIonStr + logIonStr
     ifDatName = STRTRIM(absnegslogIonStr,2)+"iflux"+ifluxPlotType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + ifDatName+"medhist_data.sav"

        h2dIStr.data=median_hist(maximus.mlt[plot_i],maximus.ILAT[plot_i],$
                                 ionData,$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT,$
                                 ABSMED=absIflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + ifDatName + "medhist.txt"

     ENDIF ELSE BEGIN 
        ionData=(KEYWORD_SET(logAvgPlot)) ? alog10(ionData) : ionData
        h2dIStr.data=hist2d(maximus.mlt[plot_i], $
                            maximus.ilat[plot_i],$
                            ionData,$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI,$
                            OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
        h2dIStr.data(where(h2dFluxN NE 0,/NULL))=h2dIStr.data[where(h2dFluxN NE 0,/NULL)]/h2dFluxN[where(h2dFluxN NE 0,/NULL)]
        IF KEYWORD_SET(logAvgPlot) THEN h2dIStr.data[where(h2dFluxN NE 0,/null)] = 10^(h2dIStr.data[where(h2dFluxN NE 0,/null)])
     ENDELSE 

     ;;data mods?
     IF KEYWORD_SET(absIflux)THEN BEGIN 
        h2dIStr.data = ABS(h2dIStr.data) 
        IF keepMe THEN ionData=ABS(ionData) 
     ENDIF
     IF KEYWORD_SET(logIfPlot) THEN BEGIN 
        h2dIStr.data(where(h2dIStr.data GT 0,/NULL))=ALOG10(h2dIStr.data[where(h2dIStr.data GT 0,/null)]) 
        IF keepMe THEN ionData[where(ionData GT 0,/null)]=ALOG10(ionData[where(ionData GT 0,/null)])
     ENDIF

     ;;Do custom range for Iflux plots, if requested
     IF  KEYWORD_SET(iPlotRange) THEN h2dIStr.lim=iPlotRange $
     ELSE h2dIStr.lim = [MIN(h2dIStr.data),MAX(h2dIStr.data)]

     h2dIStr.title= absnegslogIonStr + "Ion Flux (ergs/cm!U2!N-s)"

     h2dStr=[h2dStr,h2dIStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,STRTRIM(absnegslogIonStr,2)+"iflux"+ifluxPlotType+"_"] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(ionData)] 
     ENDIF 


END