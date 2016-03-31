;;Standardize
PRO AVERAGE_H2DS_OVER_DELAYS, $
   HEMI=hemi, $
   CLOCKSTR=clockStr, $
   NDELAYS=nDelays, $
   DELAYDELTASEC=delayDeltaSec, $
   DELAY_START=delay_start, $
   DELAY_STOP=delay_stop, $
   ;; DELAYARR=delayArr, $
   IN_AVGTYPE=in_avgType, $
   OUT_AVGTYPE=out_avgType, $
   LOGAVG_THESE_INDS=logAvg_these_inds, $
   DONT_LOGAVG_THESE_INDS=dont_logAvg_these_inds, $
   TIMEAVG_THESE_INDS=timeAvg_these_inds, $   
   LOGPLOT_THESE_INDS=logPlot_these_inds, $
   DONT_LOGPLOT_THESE_INDS=dont_logPlot_these_inds, $
   LIM_FOR_LOGPLOT_INDS=lim_for_logPlot_inds, $
   LIM_FOR_UNLOGPLOT_INDS=lim_for_unlogPlot_inds, $
   MINAVGS_FOR_NOMASK=minAvgs_for_noMask, $
   IMFCONDSTR=IMFCondStr, $
   PLOT_DATESTR=plot_dateStr, $
   FILEDIR=fileDir

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;defaults
  ;; hemi                                                     = 'SOUTH'
  IF ~KEYWORD_SET(hemi)               THEN hemi               = 'NORTH'
  
  ;; clockStr                                                 = 'duskward'
  IF ~KEYWORD_SET(clockStr)           THEN clockStr           = 'dawnward'

  IF ~KEYWORD_SET(in_avgType)         THEN in_avgType         = 'logAvg'
  IF ~KEYWORD_SET(out_avgType)        THEN out_avgType        = 'logAvg'

  IF ~KEYWORD_SET(IMFCondStr)         THEN IMFCondStr         = ''

  IF ~KEYWORD_SET(minAvgs_for_noMask) THEN minAvgs_for_noMask = 10

  ;; IF ~KEYWORD_SET(date)               THEN date               = '20160328'
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
  IF N_ELEMENTS(delay_start) GT 0 THEN BEGIN
     delayArr = (INDGEN(FIX((delay_stop-delay_start)*60./delayDeltaSec)+1,/LONG)+delay_start)*delayDeltaSec
  ENDIF ELSE BEGIN
     delayArr = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  ENDELSE

  delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 
  avgString           = GET_DELAY_AVG_STRING(in_avgType,delayArr,delayDeltaSec)
  out_avgString       = GET_DELAY_AVG_STRING(out_avgType,delayArr,delayDeltaSec)

  paramPref           = 'polarplots_' + plot_dateStr+'--' + hemi + '--despun--' + in_avgType + '--maskMin5'

  IF ~KEYWORD_SET(omniPref) THEN omniPref = '--OMNI--GSM--'+clockStr+'__0stable'

  outFile             = paramPref + bonusSuff + omniPref + out_avgString + IMFCondStr
  paramStrArr         = paramPref + bonusSuff + omniPref + delayStr + IMFCondStr

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;get N plots in these files, initialize average
  RESTORE,fileDir+paramStrArr[0]+'.dat'

  nAvgH2dArr          = h2dStrArr
  haveNEvents         = (STRMATCH(h2dStrArr[-1].title,'nevents',/FOLD_CASE) OR $
                         STRMATCH(h2dStrArr[-2].title,'nevents',/FOLD_CASE))
  nPlots              = N_ELEMENTS(h2dStrArr)-1+haveNevents
  FOR plot_i=0,nPlots-1 DO BEGIN

     ;;Handle requests for which types of plots de skal bli
     IF KEYWORD_SET(dont_logPlot_these_inds) THEN BEGIN
        unlogMe = WHERE(plot_i EQ dont_logPlot_these_inds)
        IF unlogMe[0] NE -1 THEN BEGIN
           h2dStrArr[plot_i].lim               = KEYWORD_SET(lim_for_unlogPlot_inds) ? lim_for_unlogPlot_inds[*,unlogMe] : $
                                                 (KEYWORD_SET(h2dStrArr[plot_i].is_logged) ? 10.^(h2dStrArr[plot_i].lim) : h2dStrArr[plot_i].lim)
           h2dStrArr[plot_i].lim[0]            = 0.0
           h2dStrArr[plot_i].force_oobLow      = 0
        ENDIF
     ENDIF
     IF KEYWORD_SET(logPlot_these_inds) THEN BEGIN
        logMe = WHERE(plot_i EQ logPlot_these_inds)
        IF logMe[0] NE -1 THEN BEGIN
           h2dStrArr[plot_i].lim               = KEYWORD_SET(lim_for_logPlot_inds) ? ALOG10(lim_for_logPlot_inds[*,logMe]) : $
                                                 (KEYWORD_SET(h2dStrArr[plot_i].is_logged) ? h2dStrArr[plot_i].lim : ALOG10(h2dStrArr[plot_i].lim))
           h2dStrArr[plot_i].force_oobLow      = 1
        ENDIF
     ENDIF 


     mask_str_i       = WHERE(STRMATCH(h2dStrArr.title,'Histogram mask',/FOLD_CASE))
     notMasked_i      = WHERE(h2dStrarr[mask_str_i].data LT 250,COMPLEMENT=masked_i)

     IF KEYWORD_SET(dont_logAvg_these_inds) THEN BEGIN ;Don't logAvg me?
        unlogMe = WHERE(plot_i EQ dont_logAvg_these_inds)
        IF unlogMe[0] NE -1 THEN BEGIN
           PRINT,FORMAT='("This plot will be avgd      :",T35,I0,T40,A0)',plot_i,h2dStrArr[plot_i].title
           IF h2dStrArr[plot_i].is_logged THEN BEGIN
              h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
              h2dStrArr[plot_i].is_logged         = 0
           ENDIF
           h2dStrArr[plot_i].data[masked_i]       = 0
        ENDIF
     ENDIF 

     IF KEYWORD_SET(logAvg_these_inds) THEN BEGIN ;Do logAvg me?
           logMe = WHERE(plot_i EQ logAvg_these_inds)
           IF logMe[0] NE -1 THEN BEGIN
              PRINT,FORMAT='("This plot will be log avged :",T35,I0,T40,A0)',plot_i,h2dStrArr[plot_i].title
              IF ~h2dStrArr[plot_i].is_logged THEN BEGIN
                 h2dStrArr[plot_i].data[notMasked_i] = ALOG10(h2dStrArr[plot_i].data[notMasked_i])
                 h2dStrArr[plot_i].is_logged         = 1
              ENDIF
           ENDIF
        END

     IF KEYWORD_SET(timeAvg_these_inds) THEN BEGIN ;Don't logAvg me?
        timeMe = WHERE(plot_i EQ timeAvg_these_inds)
        IF timeMe[0] NE -1 THEN BEGIN 
           IF h2dStrArr[plot_i].is_logged THEN BEGIN
              h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
              h2dStrArr[plot_i].data[masked_i]    = 0
              h2dStrArr[plot_i].is_logged         = 0
           ENDIF
           h2dStrArr[plot_i].data[notMasked_i]    = h2dStrArr[plot_i].data[notMasked_i]*delayDeltaSec
           PRINT,FORMAT='("This plot will be time avgd :",T35,I0,T40,A0)',plot_i,h2dStrArr[plot_i].title
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

     mask_str_i    = WHERE(STRMATCH(h2dStrArr.title,'Histogram mask',/FOLD_CASE))
     notMasked_i   = WHERE(h2dStrarr[mask_str_i].data LT 250,COMPLEMENT=masked_i)

     FOR plot_i=0,nPlots-1 DO BEGIN
        CASE 1 OF
           KEYWORD_SET(dont_logAvg_these_inds) AND h2dStrArr[plot_i].is_logged: BEGIN
              unlogMe = WHERE(plot_i EQ dont_logAvg_these_inds)
              IF unlogMe[0] NE -1 THEN BEGIN
                 h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
                 h2dStrArr[plot_i].data[masked_i]    = 0
              ENDIF
           END
           KEYWORD_SET(logAvg_these_inds) AND ~h2dStrArr[plot_i].is_logged: BEGIN
              logMe = WHERE(plot_i EQ logAvg_these_inds)
              IF logMe[0] NE -1 THEN BEGIN
                 h2dStrArr[plot_i].data[notMasked_i] = ALOG10(h2dStrArr[plot_i].data[notMasked_i])
              ENDIF
           END
           KEYWORD_SET(timeAvg_these_inds): BEGIN
              timeMe = WHERE(plot_i EQ timeAvg_these_inds)
              IF timeMe[0] NE -1 THEN BEGIN 
                 IF h2dStrArr[plot_i].is_logged THEN BEGIN
                    h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
                    h2dStrArr[plot_i].data[masked_i]    = 0
                 ENDIF
                 h2dStrArr[plot_i].data[notMasked_i]    = h2dStrArr[plot_i].data[notMasked_i]*delayDeltaSec
              ENDIF
           END
        ENDCASE

        averagedH2ds[plot_i].data[notMasked_i]   += h2dStrArr[plot_i].data[notMasked_i]

        ;;update nAvg arrays
        nAvgH2dArr[plot_i].data[notMasked_i]     += 1

     ENDFOR
  ENDFOR

  PRINT,'looped over delays! Averaging...'

  finalNotMask                       = nAvgH2dArr[0].data GE minAvgs_for_noMask
  FOR plot_i=0,nPlots-1 DO BEGIN
     IF KEYWORD_SET(timeAvg_these_inds) THEN BEGIN
        timeMe = WHERE(plot_i EQ timeAvg_these_inds)
        IF timeMe[0] NE -1 THEN BEGIN 
           averagedH2ds[plot_i].data = averagedH2ds[plot_i].data/(delayArr[-1]-delayArr[0])
        ENDIF ELSE BEGIN
           averagedH2ds[plot_i].data = averagedH2ds[plot_i].data/nDelays
        ENDELSE
     ENDIF ELSE BEGIN
        averagedH2ds[plot_i].data    = averagedH2ds[plot_i].data/nDelays
     ENDELSE
     finalNotMask                    = finalNotMask AND (nAvgH2dArr[plot_i].data GE minAvgs_for_noMask) ;;Update all thos places
  ENDFOR

  h2dFinArr                          = averagedH2ds

  ;;correct my error from this day
  IF plot_dateStr EQ 'Mar_28_16' THEN BEGIN
     dataNameArr                     = SHIFT(dataNameArr,1)
  ENDIF

  ;;now do mask
  mask_i                             = WHERE(STRMATCH(h2dFinArr.title,'Histogram mask',/FOLD_CASE))
  IF mask_i EQ N_ELEMENTS(h2dFinArr) THEN BEGIN
     print,'Old v of GET_ALFVENDB_2DHISTOS used; correcting for absence of nEvents...'
     mask_i--
  ENDIF

  h2dFinArr[mask_i].data             = (~finalNotMask)*255
  not_masked                         = finalNotMask

  ;; not_masked                   = h2dFinArr[mask_i].data LT 250

  good_i                             = WHERE(not_masked)
  FOR plot_i=0,nPlots-1 DO BEGIN
     CASE 1 OF
        KEYWORD_SET(dont_logPlot_these_inds) AND h2dFinArr[plot_i].is_logged: BEGIN
           unlogMe = WHERE(plot_i EQ dont_logPlot_these_inds)
           IF unlogMe[0] NE -1 THEN BEGIN
              IF good_i[0] NE -1 THEN BEGIN
                 h2dFinArr[plot_i].data[good_i]   = 10.^(h2dFinArr[plot_i].data[good_i])
                 h2dFinArr[plot_i].is_logged      = 0
              ENDIF ELSE BEGIN
                 PRINT,'Bad! All the data are bad!'
                 STOP
              ENDELSE
           ENDIF
        END
        KEYWORD_SET(logPlot_these_inds) AND ~h2dFinArr[plot_i].is_logged: BEGIN
           logMe = WHERE(plot_i EQ logPlot_these_inds)
           IF logMe[0] NE -1 THEN BEGIN
              IF good_i[0] NE -1 THEN BEGIN
                 h2dFinArr[plot_i].data[good_i]   = ALOG10(h2dFinArr[plot_i].data[good_i])
                 h2dFinArr[plot_i].is_logged      = 1
              ENDIF ELSE BEGIN
                 PRINT,'Bad! All the data are bad!'
                 STOP
              ENDELSE
           ENDIF
        END
        ELSE: BEGIN
        ENDELSE
     ENDCASE

     IF KEYWORD_SET(h2dFinArr[plot_i].is_logged) THEN BEGIN
        PRINT,FORMAT='("This plot will be on a log scale       :",T40,I0,T45,A0)',plot_i,h2dFinArr[plot_i].title
        PRINT,FORMAT='("Min, max lim    : ",T20,F13.3,T35,F13.3)',h2dFinArr[plot_i].lim[0],h2dFinArr[plot_i].lim[1]
        PRINT,FORMAT='("Min, max data   : ",T20,F13.3,T35,F13.3)',MIN(h2dFinArr[plot_i].data[good_i]),MAX(h2dFinArr[plot_i].data[good_i])
     ENDIF ELSE BEGIN
        PRINT,FORMAT='("This plot will be on a linear scale    :",T40,I0,T45,A0)',plot_i,h2dFinArr[plot_i].title
        PRINT,FORMAT='("Min, max lim    : ",T20,G13.3,T35,G13.3)',h2dFinArr[plot_i].lim[0],h2dFinArr[plot_i].lim[1]
        PRINT,FORMAT='("Min, max data   : ",T20,G13.3,T35,G13.3)',MIN(h2dFinArr[plot_i].data[good_i]),MAX(h2dFinArr[plot_i].data[good_i])
     ENDELSE
     PRINT,''

  ENDFOR


  PRINT,'Saving averaged h2ds to ' + outFile + '.dat...'
  SAVE_ALFVENDB_TEMPDATA,TEMPFILE=outDir+outFile+'.dat', $
                         H2DSTRARR=h2dFinArr,DATANAMEARR=dataNameArr,$
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
