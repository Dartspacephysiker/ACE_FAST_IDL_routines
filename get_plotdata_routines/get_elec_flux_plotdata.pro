PRO GET_ELEC_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                           DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                           OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                           EFLUXPLOTTYPE=eFluxPlotType,EPLOTRANGE=ePlotRange, $
                           NOPOS_EFLUX=noPos_eFlux,NONEG_EFLUX=noNeg_eFlux,ABS_EFLUX=abs_eFlux,LOGEFPLOT=logEfPlot, $
                           H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                           DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme, $
                           MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                           LOGAVGPLOT=logAvgPlot, $
                           WRITEHDF5=writeHDF5,WRITEASCII=writeASCII,SQUAREPLOT=squarePlot,SAVERAW=saveRaw
  
  COMPILE_OPT idl2

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}

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
     elecData= maximus.integ_elec_energy_flux[plot_i] 
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
        elecData = maximus.elec_energy_flux[plot_i]
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
  dataName = STRTRIM(absnegslogEstr,2)+"eFlux"+eFluxPlotType+"_"

  IF KEYWORD_SET(medianplot) THEN BEGIN 

     IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + dataName+"medhist_data.sav"

     h2dEstr.data=median_hist(maximus.mlt[plot_i],(KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                              elecData,$
                              MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                              MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                              BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                              OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT,$
                              ABSMED=abs_eFlux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

     IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + dataName + "medhist.txt"

  ENDIF ELSE BEGIN 

     elecData=(KEYWORD_SET(logAvgPlot)) ? alog10(elecData) : elecData

     h2dStr.data=hist2d(maximus.mlt[plot_i], $
                         (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                         elecData,$
                         MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                         MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                         BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                         OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
     h2dStr.data[where(h2dFluxN NE 0,/NULL)]=h2dStr.data[where(h2dFluxN NE 0,/NULL)]/h2dFluxN[where(h2dFluxN NE 0,/NULL)] 
     IF KEYWORD_SET(logAvgPlot) THEN h2dStr.data[where(h2dFluxN NE 0,/null)] = 10^(h2dStr.data[where(h2dFluxN NE 0,/null)])

  ENDELSE

                                ;data mods?
  IF KEYWORD_SET(abs_eFlux)THEN BEGIN 
     h2dStr.data = ABS(h2dStr.data) 
     elecData=ABS(elecData) 
  ENDIF
  IF KEYWORD_SET(logEfPlot) THEN BEGIN 
     h2dStr.data[where(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data GT 0,/null)]) 
     elecData[where(elecData GT 0,/null)]=ALOG10(elecData[where(elecData GT 0,/null)]) 
  ENDIF

     ;;Do custom range for Eflux plots, if requested
     ;; IF  KEYWORD_SET(EPlotRange) THEN h2dStr.lim=EPlotRange $
     ;; ELSE h2dStr.lim = [MIN(h2dEstr.data),MAX(h2dEstr.data)]
     h2dStr.lim = EPlotRange

     h2dStr.title= absnegslogEstr + "Electron Flux (ergs/cm!U2!N-s)"

     dataRawPtr = PTR_NEW(elecData)

END