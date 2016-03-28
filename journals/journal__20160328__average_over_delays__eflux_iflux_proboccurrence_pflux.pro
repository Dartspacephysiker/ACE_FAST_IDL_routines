PRO JOURNAL__20160328__AVERAGE_OVER_DELAYS__EFLUX_IFLUX_PROBOCCURRENCE_PFLUX, $
   HEMI=hemi, $
   CLOCKSTR=clockStr, $
   NDELAYS=nDelays, $
   DELAYDELTASEC=delayDeltaSec, $
   AVGTYPE=avgType, $
   LOGAVG_THESE_INDS=logAvg_these_inds, $
   LIM_FOR_LOGAVG_INDS=lim_for_logAvg_inds, $
   DONT_LOGAVG_THESE_INDS=dont_logAvg_these_inds, $
   LOGPLOT_THESE_INDS=logPlot_these_inds, $
   DONT_LOGPLOT_THESE_INDS=dont_logPlot_these_inds, $
   MINAVGS_FOR_NOMASK=minAvgs_for_noMask, $
   IMFCONDSTR=IMFCondStr

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;defaults
  ;; hemi                                                     = 'SOUTH'
  IF ~KEYWORD_SET(hemi)               THEN hemi               = 'NORTH'
  
  ;; clockStr                                                 = 'duskward'
  IF ~KEYWORD_SET(clockStr)           THEN clockStr           = 'dawnward'

  IF ~KEYWORD_SET(avgType)            THEN avgType            = 'logAvg'

  IF ~KEYWORD_SET(IMFCondStr)         THEN IMFCondStr         = '__ABS_byMin5.0__bzMax-1.0'

  IF ~KEYWORD_SET(minAvgs_for_noMask) THEN minAvgs_for_noMask = 10

  IF ~KEYWORD_SET(date)               THEN date               = '20160328'
  IF ~KEYWORD_SET(plot_dateStr)       THEN plot_dateStr       = 'Mar_28_16'

  IF ~KEYWORD_SET(bonusSuff)          THEN bonusSuff          = ''
  IF ~KEYWORD_SET(fileDir)            THEN fileDir            = '/SPENCEdata/Research/Cusp/ACE_FAST/temp/'
  IF ~KEYWORD_SET(outDir)             THEN outdir             = '/SPENCEdata/Research/Cusp/ACE_FAST/processed/'

  ;;Delay stuff (nDelays                                      = 61 will average over delays between -30 and 30 min, inclusive)
  IF ~KEYWORD_SET(nDelays)            THEN nDelays            = 31
  IF ~KEYWORD_SET(delayDeltaSec)      THEN delayDeltaSec      = 15

  ;;Make sure nothing bad is going to happen
  IF KEYWORD_SET(dont_logAvg_these_inds) AND KEYWORD_SET(logAvg_these_inds) THEN BEGIN
     FOR k=0,N_ELEMENTS(dont_logAvg_these_inds)-1 DO BEGIN
        badNews       = WHERE(dont_logAvg_these_inds[k] EQ logAvg_these_inds)
        IF badNews NE -1 THEN BEGIN
           PRINT,"Getting yourself into trouble! There are indices that are supposed to be log-avged and ~log-avged!"
           STOP
        ENDIF
     ENDFOR
  ENDIF

  IF KEYWORD_SET(dont_logPlot_these_inds) AND KEYWORD_SET(logPlot_these_inds) THEN BEGIN
     FOR k=0,N_ELEMENTS(dont_logPlot_these_inds)-1 DO BEGIN
        badNews       = WHERE(dont_logPlot_these_inds[k] EQ logPlot_these_inds)
        IF badNews NE -1 THEN BEGIN
           PRINT,"Getting yourself into trouble! There are indices that are supposed to be log plots  and ~log plots!"
           STOP
        ENDIF
     ENDFOR
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now calculate
  delayArr            = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 

  paramPref           = 'polarplots_' + plot_dateStr+'--' + hemi + '--despun--' + avgType + '--maskMin5'
  IF ~KEYWORD_SET(omniPref) THEN omniPref = '--OMNI--GSM--'+clockStr+'__0stable'
  avgString           = STRING(FORMAT='("__averaged_over_",F0.2,"-",F0.2,"minDelays--delay_delta_",I0,"sec")',delayArr[0]/60.,delayArr[-1]/60.,delayDeltaSec)

  outFile             = paramPref + bonusSuff + omniPref + avgString + IMFCondStr
  paramStrArr         = paramPref + bonusSuff + omniPref + delayStr + IMFCondStr

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;get N plots in these files, initialize average
  RESTORE,fileDir+paramStrArr[0]+'.dat'

  nAvgH2dArr          = h2dStrArr
  haveNEvents         = (STRMATCH(h2dStrArr[-1].title,'nevents',/FOLD_CASE) OR $
                         STRMATCH(h2dStrArr[-2].title,'nevents',/FOLD_CASE))
  nPlots              = N_ELEMENTS(h2dStrArr)-1+haveNevents
  FOR plot_i=0,nPlots-1 DO BEGIN

     notMasked_i      = WHERE(h2dStrarr[4].data LT 250,COMPLEMENT=masked_i)

     ;;don't logAvg me?
     IF KEYWORD_SET(dont_logAvg_these_inds) AND h2dStrArr[plot_i].is_logged THEN BEGIN
        unlogMe = WHERE(plot_i EQ dont_logAvg_these_inds)
        IF unlogMe[0] NE -1 THEN BEGIN
           PRINT,FORMAT='("This plot will be avgd      :",T35,I0,T40,A0)',plot_i,h2dStrArr[plot_i].title
           h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
           h2dStrArr[plot_i].data[masked_i]    = 0
        ENDIF
     ENDIF

     ;;Do logAvg me?
     IF KEYWORD_SET(logAvg_these_inds) AND ~h2dStrArr[plot_i].is_logged THEN BEGIN
        logMe = WHERE(plot_i EQ logAvg_these_inds)
        IF logMe[0] NE -1 THEN BEGIN
           PRINT,FORMAT='("This plot will be log-avged :",T35,I0,T40,A0)',plot_i,h2dStrArr[plot_i].title
           h2dStrArr[plot_i].data[notMasked_i] = ALOG10(h2dStrArr[plot_i].data[notMasked_i])
           ;; h2dStrArr[plot_i].is_logged         = 1
           ;; h2dStrArr[plot_i].lim               = ALOG10(lim_for_logAvg_inds[*,logMe])
        ENDIF
     ENDIF

     ;;set these to zero, give initial update
     nAvgH2DArr[plot_i].data[*,*]              = 0
     nAvgH2dArr[plot_i].data[notMasked_i]     += 1 

  ENDFOR

  averagedh2ds        = h2dStrArr
  dataNames           = !NULL
  FOR i=0,nPlots-1 DO BEGIN
     dataNames        = [dataNames,h2dStrArr[i].title]
  ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now combine
  FOR i=1,N_ELEMENTS(delayArr)-1 DO BEGIN
     RESTORE,fileDir+paramStrArr[i]+'.dat'

     FOR plot_i=0,nPlots-1 DO BEGIN

        notMasked_i   = WHERE(h2dStrarr[4].data LT 250,COMPLEMENT=masked_i)

        IF KEYWORD_SET(dont_logAvg_these_inds) AND h2dStrArr[plot_i].is_logged THEN BEGIN
           unlogMe = WHERE(plot_i EQ dont_logAvg_these_inds)
           IF unlogMe[0] NE -1 THEN BEGIN
              h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
              h2dStrArr[plot_i].data[masked_i]    = 0
           ENDIF
        ENDIF

        IF KEYWORD_SET(logAvg_these_inds) AND ~h2dStrArr[plot_i].is_logged THEN BEGIN
           logMe = WHERE(plot_i EQ logAvg_these_inds)
           IF logMe[0] NE -1 THEN BEGIN
              h2dStrArr[plot_i].data[notMasked_i] = ALOG10(h2dStrArr[plot_i].data[notMasked_i])
           ENDIF
        ENDIF
        averagedH2ds[plot_i].data[notMasked_i]   += h2dStrArr[plot_i].data[notMasked_i]

        ;;update nAvg arrays
        nAvgH2dArr[plot_i].data[notMasked_i]     += 1

     ENDFOR
  ENDFOR

  PRINT,'looped over delays! Averaging...'

  finalNotMask                 = nAvgH2dArr[0].data GE minAvgs_for_noMask
  FOR plot_i=0,nPlots-1 DO BEGIN
     averagedH2ds[plot_i].data = averagedH2ds[plot_i].data/nDelays
     finalNotMask              = finalNotMask AND (nAvgH2dArr[plot_i].data GE minAvgs_for_noMask)
  ENDFOR

  h2dStrArr = averagedH2ds

  ;;now do mask
  mask_i                       = WHERE(STRMATCH(dataNameArr,'histoMask',/FOLD_CASE))
  IF mask_i EQ N_ELEMENTS(h2dStrArr) THEN BEGIN
     print,'Old v of GET_ALFVENDB_2DHISTOS used; correcting for absence of nEvents...'
     mask_i--
  ENDIF

  h2dStrArr[mask_i].data       = (~finalNotMask)*255

  ;;Now handle final requests for which types of plots de skal bli
  FOR plot_i=0,nPlots-1 DO BEGIN
     IF KEYWORD_SET(dont_logPlot_these_inds) AND h2dStrArr[plot_i].is_logged THEN BEGIN
        unlogMe = WHERE(plot_i EQ dont_logPlot_these_inds)
        IF unlogMe[0] NE -1 THEN BEGIN
           PRINT,FORMAT='("This plot will be on a linear scale    :",T35,I0,T40,A0)',plot_i,h2dStrArr[plot_i].title
           h2dStrArr[plot_i].lim               = 10.^(h2dStrArr[plot_i].lim)
           h2dStrArr[plot_i].lim[0]            = 0.0
           h2dStrArr[plot_i].is_logged         = 0
           h2dStrArr[plot_i].force_oobLow      = 0
        ENDIF
     ENDIF

     IF KEYWORD_SET(logPlot_these_inds) AND ~h2dStrArr[plot_i].is_logged THEN BEGIN
        logMe = WHERE(plot_i EQ logPlot_these_inds)
        IF logMe[0] NE -1 THEN BEGIN
           PRINT,FORMAT='("This plot will be on a log scale       :",T35,I0,T40,A0)',plot_i,h2dStrArr[plot_i].title
           h2dStrArr[plot_i].lim               = ALOG10(h2dStrArr[plot_i].lim)
           h2dStrArr[plot_i].is_logged         = 1
           h2dStrArr[plot_i].force_oobLow      = 1
        ENDIF
     ENDIF
  ENDFOR


  PRINT,'Saving averaged h2ds to ' + outFile + '.dat...'
  SAVE_ALFVENDB_TEMPDATA,TEMPFILE=outDir+outFile+'.dat', $
                         H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,$
                         MAXM=maxM,MINM=minM,MAXI=maxI,MINI=minI, $
                         BINM=binM, $
                         SHIFTM=shiftM, $
                         BINI=binI, $
                         DO_LSHELL=do_lShell, $
                         REVERSE_LSHELL=reverse_lShell, $
                         MINL=minL,MAXL=maxL,BINL=binL,$
                         RAWDIR=rawDir,PARAMSTR=paramStr,$
                         CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg, $
                         STABLEIMF=stableIMF,HOYDIA=hoyDia,HEMI=hemi, $
                         /QUIET, $
                         LUN=lun
  
END
