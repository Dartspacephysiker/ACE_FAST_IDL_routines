;2015/10/16
;Just generalize, my man
PRO GET_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                      DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                      OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                      FLUXPLOTTYPE=fluxPlotType,PLOTRANGE=plotRange, $
                      NOPOSFLUX=noPosFlux,NONEGFLUX=noNegFlux,ABSFLUX=absFlux,LOGFLUXPLOT=logFluxPlot, $
                      H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                      DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                      MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                      LOGAVGPLOT=logAvgPlot, $
                      WRITEHDF5=writeHDF5,WRITEASCII=writeASCII,SQUAREPLOT=squarePlot,SAVERAW=saveRaw, $
                      GET_EFLUX=get_eflux,GET_ENUMFLUX=get_eNumFlux,GET_PFLUX=get_pFlux,GET_IFLUX=get_iFlux, $
                      GET_CHAREE=get_ChareE,GET_CHARIE=get_chariE, $
                      LUN=lun
  
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  nDataz = 0

  IF KEYWORD_SET(get_eFlux) THEN nDataz++
  IF KEYWORD_SET(get_eNumFlux) THEN nDataz++
  IF KEYWORD_SET(get_pFlux) THEN nDataz++
  IF KEYWORD_SET(get_iFlux) THEN nDataz++
  IF KEYWORD_SET(get_ChareE) THEN nDataz++
  IF KEYWORD_SET(get_ChariE) THEN nDataz++

  IF nDataz GT 1 THEN BEGIN
     PRINTF,lun,"Multiple plots at once currently not supported, you fool!"
     STOP
  ENDIF

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}

  IF KEYWORD_SET(get_eFlux) THEN BEGIN
     h2dStr.title = "Electron Flux (ergs/cm!U2!N-s)"
     dataName = "eFlux"
     ;;If not allowing negative fluxes
     IF fluxPlotType EQ "Integ" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
        ;;    ;; no_negs_i=WHERE(maximus.integ_elec_energy_flux GE 0.0)
        ;;    ;; print,"N elements in " + dataName + " data before junking neg vals: ",N_ELEMENTS(plot_i)
        ;;    ;; plot_i=cgsetintersection(no_negs_i,plot_i)
        ;;    ;; print,"N elements in " + dataName + " data after junking neg vals: ",N_ELEMENTS(plot_i)
        ;; ENDIF ELSE BEGIN
        ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
        ;;       ;; no_pos_i=WHERE(maximus.integ_elec_energy_flux LT 0.0)
        ;;       ;; print,"N elements in " + dataName + " data before junking pos vals: ",N_ELEMENTS(plot_i)
        ;;       ;; plot_i=cgsetintersection(no_pos_i,plot_i)        
        ;;       ;; print,"N elements in " + dataName + " data after junking pos vals: ",N_ELEMENTS(plot_i)
        ;;    ENDIF
        ;; ENDELSE
        inData= maximus.integ_elec_energy_flux[plot_i] 
     ENDIF ELSE BEGIN
        IF fluxPlotType EQ "Max" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
           ;;    ;; no_negs_i=WHERE(maximus.elec_energy_flux GE 0.0)
           ;;    ;; print,"N elements in " + dataName + " data before junking neg vals: ",N_ELEMENTS(plot_i)
           ;;    ;; plot_i=cgsetintersection(no_negs_i,plot_i)        
           ;;    ;; print,"N elements in " + dataName + " data after junking neg vals: ",N_ELEMENTS(plot_i)
           ;; ENDIF ELSE BEGIN
           ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
           ;;       ;; no_pos_i=WHERE(maximus.elec_energy_flux LT 0.0)
           ;;       ;; print,"N elements in " + dataName + " data before junking pos vals: ",N_ELEMENTS(plot_i)
           ;;       ;; plot_i=cgsetintersection(no_pos_i,plot_i)        
           ;;       ;; print,"N elements in " + dataName + " data after junking pos vals: ",N_ELEMENTS(plot_i)
           ;;    ENDIF
           ;; ENDELSE
           inData = maximus.elec_energy_flux[plot_i]
        ENDIF
     ENDELSE
  ENDIF

  IF KEYWORD_SET(get_eNumFlux) THEN BEGIN
     h2dStr.title = "Electron Number Flux (#/cm!U2!N-s)"
     dataName = "eNumFl"

     IF STRLOWCASE(fluxPlotType) EQ STRLOWCASE("Total_Eflux_Integ") THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.total_eflux_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
        ;;    ;; no_negs_i=WHERE(maximus.total_eflux_integ GE 0.0)
        ;;    ;; print,"N elements in " + dataName + " data before junking neg vals: ",N_ELEMENTS(plot_i)
        ;;    ;; plot_i=cgsetintersection(no_negs_i,plot_i)
        ;;    ;; print,"N elements in " + dataName + " data after junking neg vals: ",N_ELEMENTS(plot_i)
        ;; ENDIF ELSE BEGIN
        ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
        ;;       ;; no_pos_i=WHERE(maximus.total_eflux_integ LT 0.0)
        ;;       ;; print,"N elements in " + dataName + " data before junking pos vals: ",N_ELEMENTS(plot_i)
        ;;       ;; plot_i=cgsetintersection(no_pos_i,plot_i)        
        ;;       ;; print,"N elements in " + dataName + " data after junking pos vals: ",N_ELEMENTS(plot_i)
        ;;    ENDIF
        ;; ENDELSE
        inData= maximus.total_eflux_integ[plot_i] 
     ENDIF ELSE BEGIN
        IF STRLOWCASE(fluxPlotType) EQ STRLOWCASE("Eflux_Losscone_Integ") THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.eflux_losscone_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
           ;;    ;; no_negs_i=WHERE(maximus.eflux_losscone_integ GE 0.0)
           ;;    ;; print,"N elements in " + dataName + " data before junking neg vals: ",N_ELEMENTS(plot_i)
           ;;    ;; plot_i=cgsetintersection(no_negs_i,plot_i)        
           ;;    ;; print,"N elements in " + dataName + " data after junking neg vals: ",N_ELEMENTS(plot_i)
           ;; ENDIF ELSE BEGIN
           ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
           ;;       ;; no_pos_i=WHERE(maximus.eflux_losscone_integ LT 0.0)
           ;;       ;; print,"N elements in " + dataName + " data before junking pos vals: ",N_ELEMENTS(plot_i)
           ;;       ;; plot_i=cgsetintersection(no_pos_i,plot_i)        
           ;;       ;; print,"N elements in " + dataName + " data after junking pos vals: ",N_ELEMENTS(plot_i)
           ;;    ENDIF
           ;; ENDELSE
           inData = maximus.eflux_losscone_integ[plot_i]
        ENDIF ELSE BEGIN
           IF STRLOWCASE(fluxPlotType) EQ STRLOWCASE("ESA_Number_flux") THEN BEGIN
              plot_i=cgsetintersection(WHERE(FINITE(maximus.esa_current),NCOMPLEMENT=lost),plot_i) ;;NaN check
              print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           ;;    IF KEYWORD_SET(noNegFlux) THEN BEGIN
           ;;       ;; no_negs_i=WHERE(maximus.esa_current GE 0.0)
           ;;       ;; print,"N elements in " + dataName + " data before junking neg vals: ",N_ELEMENTS(plot_i)
           ;;       ;; plot_i=cgsetintersection(no_negs_i,plot_i)
           ;;       ;; print,"N elements in " + dataName + " data after junking neg vals: ",N_ELEMENTS(plot_i)
           ;;    ENDIF ELSE BEGIN
           ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
           ;;       ;; no_pos_i=WHERE(maximus.esa_current LT 0.0)
           ;;       ;; print,"N elements in " + dataName + " data before junking pos vals: ",N_ELEMENTS(plot_i)
           ;;       ;; plot_i=cgsetintersection(no_pos_i,plot_i)        
           ;;       ;; print,"N elements in " + dataName + " data after junking pos vals: ",N_ELEMENTS(plot_i)
           ;;    ENDIF
           ;; ENDELSE
           ENDIF
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           inData = maximus.esa_current[plot_i] * 1. / 1.6e-9
        ENDELSE
     ENDELSE
  ENDIF
     
  IF KEYWORD_SET(get_pFlux) THEN BEGIN

     h2dStr.title= "Poynting Flux (mW/m!U2!N)"
     dataName = "pFlux_"

     inData = maximus.pFluxEst[plot_i]

     ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
     ;;    no_negs_i=WHERE(maximus.pFluxEst GE 0.0)
     ;;    plot_i=cgsetintersection(no_negs_i,plot_i)
     ;; ENDIF
     
     ;; IF KEYWORD_SET(noPosFlux) THEN BEGIN
     ;;    no_pos_i=WHERE(maximus.pFluxEst LE 0.0)
     ;;    plot_i=cgsetintersection(no_pos_i,plot_i)
     ;; ENDIF
     ;; IF KEYWORD_SET(absFlux) THEN BEGIN 
     ;;    h2dStr.data = ABS(h2dStr.data) 
     ;;    pData=ABS(pData) 
     ;; ENDIF

  ENDIF

  IF KEYWORD_SET(get_iFlux) THEN BEGIN
     h2dStr.title= "Ion Flux (ergs/cm!U2!N-s)"
     dataName = "iflux" 

     IF fluxPlotType EQ "Integ" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
        ;;    no_negs_i=WHERE(maximus.integ_ion_flux GE 0.0)
        ;;    print,"N elements in ion data before junking neg vals: ",N_ELEMENTS(plot_i)
        ;;    plot_i=cgsetintersection(no_negs_i,plot_i)
        ;;    print,"N elements in ion data after junking neg vals: ",N_ELEMENTS(plot_i)
        ;; ENDIF ELSE BEGIN
        ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
        ;;       no_pos_i=WHERE(maximus.integ_ion_flux LE 0.0)
        ;;       print,"N elements in ion data before junking pos vals: ",N_ELEMENTS(plot_i)
        ;;       plot_i=cgsetintersection(no_pos_i,plot_i)        
        ;;       print,"N elements in ion data after junking pos vals: ",N_ELEMENTS(plot_i)
        ;;    ENDIF
        ;; ENDELSE
     inData=maximus.integ_ion_flux[plot_i]
     ENDIF ELSE BEGIN
        IF fluxPlotType EQ "Max" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
           ;;    no_negs_i=WHERE(maximus.ion_flux GE 0.0)
           ;;    print,"N elements in ion data before junking neg vals: ",N_ELEMENTS(plot_i)
           ;;    plot_i=cgsetintersection(no_negs_i,plot_i)        
           ;;    print,"N elements in ion data after junking neg vals: ",N_ELEMENTS(plot_i)
           ;; ENDIF ELSE BEGIN
           ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
           ;;       no_pos_i=WHERE(maximus.ion_flux LE 0.0)
           ;;       print,"N elements in ion data before junking pos vals: ",N_ELEMENTS(plot_i)
           ;;       plot_i=cgsetintersection(no_pos_i,plot_i)        
           ;;       print,"N elements in ion data after junking pos vals: ",N_ELEMENTS(plot_i)
           ;;    ENDIF
           ;; ENDELSE
           inData=maximus.ion_flux[plot_i]
        ENDIF ELSE BEGIN
           IF fluxPlotType EQ "Max_Up" THEN BEGIN
              plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
              print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
              ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
              ;;    no_negs_i=WHERE(maximus.ion_flux_up GE 0.0)
              ;;    print,"N elements in ion data before junking neg vals: ",N_ELEMENTS(plot_i)
              ;;    plot_i=cgsetintersection(no_negs_i,plot_i)        
              ;;    print,"N elements in ion data after junking neg vals: ",N_ELEMENTS(plot_i)
              ;; ENDIF ELSE BEGIN
              ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
              ;;       no_pos_i=WHERE(maximus.ion_flux_up LE 0.0)
              ;;       print,"N elements in ion data before junking pos vals: ",N_ELEMENTS(plot_i)
              ;;       plot_i=cgsetintersection(no_pos_i,plot_i)        
              ;;       print,"N elements in ion data after junking pos vals: ",N_ELEMENTS(plot_i)
              ;;    ENDIF
              ;; ENDELSE
              inData=maximus.ion_flux_up[plot_i]
           ENDIF ELSE BEGIN
              IF fluxPlotType EQ "Integ_Up" THEN BEGIN
                 plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
                 print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                 ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
                 ;;    no_negs_i=WHERE(maximus.integ_ion_flux_up GE 0.0)
                 ;;    print,"N elements in ion data before junking neg vals: ",N_ELEMENTS(plot_i)
                 ;;    plot_i=cgsetintersection(no_negs_i,plot_i)        
                 ;;    print,"N elements in ion data after junking neg vals: ",N_ELEMENTS(plot_i)
                 ;; ENDIF ELSE BEGIN
                 ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
                 ;;       no_pos_i=WHERE(maximus.integ_ion_flux_up LE 0.0)
                 ;;       print,"N elements in ion data before junking pos vals: ",N_ELEMENTS(plot_i)
                 ;;       plot_i=cgsetintersection(no_pos_i,plot_i)        
                 ;;       print,"N elements in ion data after junking pos vals: ",N_ELEMENTS(plot_i)
                 ;;    ENDIF
                 ;; ENDELSE
                 inData=maximus.integ_ion_flux_up[plot_i]
              ENDIF ELSE BEGIN
                 IF fluxPlotType EQ "Energy" THEN BEGIN
                    plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
                    print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                    ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
                    ;;    no_negs_i=WHERE(maximus.ion_energy_flux GE 0.0)
                    ;;    print,"N elements in ion data before junking neg vals: ",N_ELEMENTS(plot_i)
                    ;;    plot_i=cgsetintersection(no_negs_i,plot_i)        
                    ;;    print,"N elements in ion data after junking neg vals: ",N_ELEMENTS(plot_i)
                    ;; ENDIF ELSE BEGIN
                    ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
                    ;;       no_pos_i=WHERE(maximus.ion_energy_flux LE 0.0)
                    ;;       print,"N elements in ion data before junking pos vals: ",N_ELEMENTS(plot_i)
                    ;;       plot_i=cgsetintersection(no_pos_i,plot_i)        
                    ;;       print,"N elements in ion data after junking pos vals: ",N_ELEMENTS(plot_i)
                    ;;    ENDIF
                    ;; ENDELSE
                    inData=maximus.ion_energy_flux[plot_i]
                 ENDIF
              ENDELSE
           ENDELSE
        ENDELSE
     ENDELSE
  ENDIF

  IF KEYWORD_SET(GET_CHAREE) THEN BEGIN
     h2dCharEStr.title = "Characteristic Energy (eV)"
     dataName = "charE"

     IF fluxPlotType EQ "lossCone" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_losscone),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
        ;;    no_negs_i=WHERE(maximus.max_chare_losscone GE 0.0)
        ;;    ;; print,"N elements in " + dataName + " data before junking negs elecData: ",N_ELEMENTS(plot_i)
        ;;    plot_i=cgsetintersection(no_negs_i,plot_i)
        ;;    ;; print,"N elements in " + dataName + " data after junking negs elecData: ",N_ELEMENTS(plot_i)
        ;; ENDIF ELSE BEGIN
        ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
        ;;       no_pos_i=WHERE(maximus.max_chare_losscone LT 0.0)
        ;;       ;; print,"N elements in " + dataName + " data before junking pos vals: ",N_ELEMENTS(plot_i)
        ;;       plot_i=cgsetintersection(no_pos_i,plot_i)        
        ;;       ;; print,"N elements in " + dataName + " data after junking pos vals: ",N_ELEMENTS(plot_i)
        ;;    ENDIF
        ;; ENDELSE
        inData=maximus.max_chare_losscone[plot_i] 
     ENDIF ELSE BEGIN
        IF fluxPlotType EQ "Total" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_total),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           ;; IF KEYWORD_SET(noNegFlux) THEN BEGIN
           ;;    no_negs_i=WHERE(maximus.max_chare_total GE 0.0)
           ;;    ;; print,"N elements in " + dataName + " data before junking neg vals: ",N_ELEMENTS(plot_i)
           ;;    plot_i=cgsetintersection(no_negs_i,plot_i)        
           ;;    ;; print,"N elements in " + dataName + " data after junking neg vals: ",N_ELEMENTS(plot_i)
           ;; ENDIF ELSE BEGIN
           ;;    IF KEYWORD_SET(noPosFlux) THEN BEGIN
           ;;       no_pos_i=WHERE(maximus.max_chare_total LT 0.0)
           ;;       ;; print,"N elements in " + dataName + " data before junking pos vals: ",N_ELEMENTS(plot_i)
           ;;       plot_i=cgsetintersection(no_pos_i,plot_i)        
           ;;       ;; print,"N elements in " + dataName + " data after junking pos vals: ",N_ELEMENTS(plot_i)
           ;;    ENDIF
           ;; ENDELSE
           inData=maximus.max_chare_total[plot_i]
        ENDIF
     ENDELSE
  ENDIF

  ;;Handle name of data
  ;;Log plots desired?
  absStr=""
  negStr=""
  posStr=""
  logStr=""
  IF KEYWORD_SET(absFlux)THEN BEGIN
     absEStr= "Abs--" 
     print,"N pos elements in " + dataName + " data: ",N_ELEMENTS(where(inData GT 0.))
     print,"N neg elements in " + dataName + " data: ",N_ELEMENTS(where(inData LT 0.))
     inData = ABS(inData)
  ENDIF
  IF KEYWORD_SET(noNegFlux) THEN BEGIN
     negEStr = "NoNegs--"
     print,"N elements in " + dataName + " before junking neg vals: ",N_ELEMENTS(inData)
     inData = inData[where(inData GT 0.)]
     print,"N elements in " + dataName + " after junking neg vals: ",N_ELEMENTS(inData)
  ENDIF
  IF KEYWORD_SET(noPosFlux) THEN BEGIN
     posEStr = "NoPos--"
     print,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(inData)
     inData = inData[where(inData LT 0.)]
     print,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(inData)
     inData = ABS(inData)
  ENDIF
  IF KEYWORD_SET(logFluxPlot) THEN logStr="Log "

  absnegslogStr=absStr + negStr + posStr + logStr
  dataName = STRTRIM(absnegslogStr,2)+dataName+'_'+fluxPlotType+'_'
  h2dStr.title= absnegslogStr + h2dStr.title

  IF KEYWORD_SET(medianplot) THEN BEGIN 

     IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + dataName+"medhist_data.sav"

     h2dStr.data=median_hist(maximus.mlt[plot_i],(KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                              inData,$
                              MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                              MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                              BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                              OBIN1=outH2DBinsMLT,OBIN2=(KEYWORD_SET(do_lshell) ? outH2DBinsLShell : outH2DBinsILAT),$
                              ABSMED=absFlux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

     IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + dataName + "medhist.txt"

  ENDIF ELSE BEGIN 

     inData=(KEYWORD_SET(logAvgPlot)) ? alog10(inData) : inData

     h2dStr.data=hist2d(maximus.mlt[plot_i], $
                         (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                         inData,$
                         MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                         MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                         BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                         OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
     h2dStr.data[where(h2dFluxN NE 0,/NULL)]=h2dStr.data[where(h2dFluxN NE 0,/NULL)]/h2dFluxN[where(h2dFluxN NE 0,/NULL)] 

     IF KEYWORD_SET(logAvgPlot) THEN h2dStr.data[where(h2dFluxN NE 0,/null)] = 10^(h2dStr.data[where(h2dFluxN NE 0,/null)])

  ENDELSE

  ;;data mods?
  IF KEYWORD_SET(absFlux)THEN BEGIN 
     h2dStr.data = ABS(h2dStr.data) 
     inData=ABS(inData) 
  ENDIF
  IF KEYWORD_SET(logFluxPlot) THEN BEGIN 
     h2dStr.data[where(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data GT 0,/null)]) 
     inData[where(inData GT 0,/null)]=ALOG10(inData[where(inData GT 0,/null)]) 
  ENDIF

  ;;Do custom range for flux plot, if requested
  IF  KEYWORD_SET(plotRange) THEN h2dStr.lim=plotRange $
  ELSE h2dStr.lim = [MIN(h2dStr.data),MAX(h2dStr.data)]
  ;; h2dStr.lim = plotRange
  
  dataRawPtr = PTR_NEW(inData)

END