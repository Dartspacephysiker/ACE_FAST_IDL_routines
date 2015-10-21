PRO GET_DB_PLOTDATA,maximus,plot_i, H2DSTRARR=h2dStrArr, $
                    KEEPME=keepMe, DATARAWPTRARR=dataRawPtrArr,DATANAMEARR=dataName, $
                    MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                    DO_LSHELL=do_lShell,MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                    ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                    MASKMIN=maskMin, $
                    SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                    HEMI=hemi, $
                    CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                    BYMIN=byMin, BZMIN=bzMin, $
                    BYMAX=byMax, BZMAX=bzMax, $
                    DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                    NPLOTS=nPlots, NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                    EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                    ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                    ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                    NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                    PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                    NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                    IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                    NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                    CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                    NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                    ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                    ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                    NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                    DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                    NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
                    PROBOCCURRENCEPLOT=probOccurrencePlot,PROBOCCURRENCERANGE=probOccurrenceRange,LOGPROBOCCURRENCE=logProbOccurrence, $
                    MEDIANPLOT=medianPlot, MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                    LOGAVGPLOT=logAvgPlot, $
                    ALL_LOGPLOTS=all_logPlots
                    

  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  GET_NEVENTS_AND_MASK,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                         DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                         NEVENTSPLOTRANGE=nEventsPlotRange, $
                         TMPLT_H2DSTR=tmplt_h2dStr, $
                         H2DSTR=h2dStr,H2DMASKSTR=h2dMaskStr, $
                         H2DFLUXN=h2dFluxN,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                         MASKMIN=maskMin, $
                         DATANAME=dataName,DATARAWPTR=dataRawPtr

  IF keepMe THEN BEGIN 
     dataRawPtrArr=dataRawPtr
     dataNameArr=[dataName,"histoMask_"] 
     dataRawPtrArr=[dataRawPtrArr,PTR_NEW(h2dMaskStr.data)] 
  ENDIF
  IF KEYWORD_SET(nPlots) THEN h2dStrArr=[h2dStr,h2dMaskStr] ELSE h2dStrArr = h2dMaskStr
  
  ;;#####FLUX QUANTITIES#########
  ;;########ELECTRON FLUX########
  IF KEYWORD_SET(eplots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_EFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=eFluxPlotType,PLOTRANGE=ePlotRange, $
                       NOPOSFLUX=noPoseflux,NONEGFLUX=noNegeflux,ABSFLUX=abseflux,LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logEfPlot)), $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF 
  ENDIF

  ;;########ELECTRON NUMBER FLUX########
  IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_ENUMFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=eNumFlPlotType,PLOTRANGE=ePlotRange, $
                       NOPOSFLUX=noPosENumFl,NONEGFLUX=noNegENumFl,ABSFLUX=absENumFl,LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logEfPlot)), $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF 

  ENDIF

  ;;########Poynting Flux########
  IF KEYWORD_SET(pplots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_PFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=PPlotRange, $
                       NOPOSFLUX=noPosPflux,NONEGFLUX=noNegPflux,ABSFLUX=absPflux,LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPfPlot)), $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot
     
     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF

  ;;########ION FLUX########
  IF KEYWORD_SET(ionPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_IFLUX,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=iFluxPlotType,PLOTRANGE=iPlotRange, $
                       NOPOSFLUX=noPosIflux,NONEGFLUX=noNegIflux,ABSFLUX=absIflux,LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logIfPlot)), $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF

  ;;########CHARACTERISTIC ELECTRON ENERGY########
  IF KEYWORD_SET(chareEPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_CHAREE,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=charEType,PLOTRANGE=charEPlotRange, $
                       NOPOSFLUX=noPosCharE,NONEGFLUX=noNegCharE,ABSFLUX=absCharE,LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logCharEPlot)), $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF

  ;;########CHARACTERISTIC ION ENERGY########
  IF KEYWORD_SET(chariEPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_CHARIE,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=chariEPlotRange, $
                       NOPOSFLUX=noPosChariE,NONEGFLUX=noNegChariE,ABSFLUX=absChariE,LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logChariEPlot)), $
                       H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, H2DFLUXN=h2dFluxN, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF  
     
  ENDIF


  ;;########Orbits########
  ;;Now do orbit data to show how many orbits contributed to each thingy.
  ;;A little extra tomfoolery is in order to get this right
  ;;h2dOrbN is a 2d histo just like the others
  ;;orbArr, on the other hand, is a 3D array, where the
  ;;2D array pointed to is indexed by MLTbin and ILATbin. The contents of
  ;;the 3D array are of the format [UniqueOrbs_ii index,MLT,ILAT]

  ;;The following two lines shouldn't be necessary; the data are being corrupted somewhere when I run this with clockstr="dawnward"
  uniqueOrbs_ii=UNIQ(maximus.orbit[plot_i],SORT(maximus.orbit[plot_i]))
  uniqueOrbs_i=plot_i[uniqueOrbs_ii]
  nOrbs=N_ELEMENTS(uniqueOrbs_i)
  
  IF KEYWORD_SET(orbContribPlot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) OR KEYWORD_SET(numOrbLim) THEN BEGIN

     GET_CONTRIBUTING_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                      DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                                      ORBCONTRIBRANGE=orbContribRange, $
                                      UNIQUEORBS_I=uniqueOrbs_i,H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                      H2DSTR=h2dContribOrbStr,TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
                                      DATANAME=dataName

     IF KEYWORD_SET(orbContribPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dContribOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF

     ;;Mask all bins that don't have requisite number of orbits passing through
     IF KEYWORD_SET(numOrbLim) THEN BEGIN 
        h2dStrArr[KEYWORD_SET(nPlots)].data[WHERE(h2dContribOrbStr.data LT numOrbLim)] = 255 ;mask 'em!

        ;;little check to see how many more elements are getting masked
        ;;exc_orb_i = where(h2dContribOrbStr.data LT numOrbLim)
        ;;masked_i = where(h2dStr(1).data EQ 255)
        ;;print,n_elements(exc_orb_i) - n_elements(cgsetintersection(exc_orb_i,masked_i))
        ;;8
     ENDIF
     
  ENDIF

  ;;########TOTAL Orbits########
  IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) THEN BEGIN
     GET_TOTAL_ORBITS_PLOTDATA,maximus,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                              DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                              ORBTOTRANGE=orbTotRange, $
                              H2DSTR=h2dTotOrbStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                              DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme, $
                              UNIQUEORBS_I=uniqueOrbs_i,H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                              LUN=lun

     IF KEYWORD_SET(orbTotPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dTotOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF
  ENDIF

  ;;########Orbit FREQUENCY########
  IF KEYWORD_SET(orbfreqplot) THEN BEGIN
     GET_ORBIT_FREQUENCY_PLOTDATA,maximus,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                 ORBFREQRANGE=orbFreqRange, $
                                 H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DCONTRIBORBSTR=h2dContribOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                 H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i,H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                 DATANAME=dataName

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     
  ENDIF
     
  ;;########NEvents/orbit########
  IF KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN 
     GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                    DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                    ORBFREQRANGE=orbFreqRange,DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                    H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                    H2DCONTRIBORBSTR=h2dContribOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                    DATANAME=dataName,DATARAWPTR=dataRawPtr

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,dataName]
  ENDIF

  IF KEYWORD_SET(nEventPerMinPlot) OR KEYWORD_SET(probOccurrencePlot) THEN BEGIN 
     tHistDenominator = GET_TIMEHIST_DENOMINATOR(CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                                 ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                                 BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                                 HEMI=hemi, $
                                                 DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                                 MINM=minM,MAXM=maxM,BINM=binM, $
                                                 MINI=minI,MAXI=maxI,BINI=binI, $
                                                 DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                                 FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                                 FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                                 BURSTDATA_EXCLUDED=burstData_excluded, $
                                                 DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme)
     
     ;;########NEvents/minute########
     IF KEYWORD_SET(nEventPerMinPlot) THEN BEGIN
        GET_NEVENTPERMIN_PLOTDATA,THISTDENOMINATOR=tHistDenominator, $
                                  MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  LOGNEVENTPERMIN=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logNEventPerMin)),NEVENTPERMINRANGE=nEventPerMinRange, $
                                  H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                                  DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
     ENDIF

     ;;########Event probability########
     IF KEYWORD_SET(probOccurrencePlot) THEN BEGIN
        GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                     LOGPROBOCCURRENCE=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logProbOccurrence)), PROBOCCURRENCERANGE=probOccurrenceRange, DO_WIDTH_X=do_width_x, $
                                     MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                     DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                     OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                     H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                                     DATANAME=dataName,DATARAWPTR=dataRawPtr

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
     ENDIF
  ENDIF

  ;;********************************************************
  ;;If something screwy goes on, better take stock of it and alert user
  FOR i = 2, N_ELEMENTS(h2dStrArr)-1 DO BEGIN 
     IF n_elements(where(h2dStrArr[i].data EQ 0,/NULL)) LT $
        n_elements(where(h2dStrArr[0].data EQ 0,/NULL)) THEN BEGIN 
        printf,lun,"h2dStrArr."+h2dStrArr[i].title + " has ", strtrim(n_elements(where(h2dStrArr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_elements(where(h2dStrArr[0].data EQ 0)),2),"." 
     printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
  ENDFOR

  ;;Now that we're done using nplots, let's log it, if requested:
  IF KEYWORD_SET(nPlots) AND ( KEYWORD_SET(logNEventsPlot) OR KEYWORD_SET(all_logPlots) ) THEN BEGIN
     dataNameArr[0] = 'log_' + dataNameArr[0]
     h2dStrArr[0].data(where(h2dStrArr.data GT 0)) = ALOG10(h2dStrArr[0].data(where(h2dStrArr.data GT 0)))
     h2dStrArr[0].lim = [(h2dStrArr[0].lim[0] LT 1) ? 0 : ALOG10(h2dStrArr[0].lim[0]),ALOG10(h2dStrArr[0].lim[1])] ;lower bound must be one
     h2dStrArr[0].title = 'Log ' + h2dStrArr[0].title
  ENDIF


END