PRO JOURNAL__20160324__AVERAGE_OVER_DELAYS__EFLUX_IFLUX_PROBOCCURRENCE_PFLUX, $
   HEMI=hemi, $
   CLOCKSTR=clockStr, $
   NDELAYS=nDelays, $
   AVGTYPE=avgType, $
   LOGAVG_THESE_INDS=logAvg_these_inds, $
   LIM_FOR_LOGAVG_INDS=lim_for_logAvg_inds, $
   IMFCONDSTR=IMFCondStr

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;defaults
  ;; hemi                = 'SOUTH'
  IF ~KEYWORD_SET(hemi) THEN hemi = 'NORTH'
  
  ;; clockStr            = 'duskward'
  IF ~KEYWORD_SET(clockStr) THEN clockStr = 'dawnward'

  IF ~KEYWORD_SET(avgType) THEN avgType   = 'logAvg'

  IF ~KEYWORD_SET(IMFCondStr) THEN IMFCondStr = '__ABS_byMin5.0__bzMax-1.0'

  minAvgs_for_noMask  = 10

  date                = '20160325'
  date_alt            = 'Mar_25_16'

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''
  fileDir             = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  outDir              = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/processed/'

  ;;Delay stuff (nDelays = 61 will average over delays between -30 and 30 min, inclusive)
  IF ~KEYWORD_SET(nDelays) THEN nDelays = 31

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now calculate
  delayArr            = (INDGEN(nDelays,/LONG)-nDelays/2)*60
  delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 

  ;; paramStr            = 'Feb_26_16--'+hemi+'--despun--logAvg--maskMin10--OMNI--GSM--duskward__0stable' + delayStr + '__byMin3.0--'
  ;; paramStr            = 'Feb_26_16--'+hemi+'--despun--logAvg--maskMin10--OMNI--GSM--duskward__0stable' + delayStr + '__byMin3.0__bzMin-4.0__bzMax4.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin10'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin10'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0__bzMax-1.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin5'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0__bzMax-3.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin5'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin6.0--'
  paramPref           = 'polarplots_' + date_alt+'--' + hemi + '--despun--' + avgType + '--maskMin5'
  omniPref            = '--OMNI--GSM--'+clockStr+'__0stable'
  avgString           = STRING(FORMAT='("__averaged_over_",F0.2,"-",F0.2,"minDelays")',delayArr[0]/60.,delayArr[-1]/60.)

  outFile             = paramPref + bonusSuff + omniPref + avgString + IMFCondStr

  paramStrArr         = paramPref + bonusSuff + omniPref + delayStr + IMFCondStr

  ;;get N plots in these files, initialize average
  RESTORE,fileDir+paramStrArr[0]+'.dat'

  nAvgH2dArr          = h2dStrArr

  haveNEvents         = (STRMATCH(h2dStrArr[-1].title,'nevents',/FOLD_CASE) OR $
                         STRMATCH(h2dStrArr[-2].title,'nevents',/FOLD_CASE))
  nPlots              = N_ELEMENTS(h2dStrArr)-1+haveNevents
  FOR plot_i=0,nPlots-1 DO BEGIN
     nAvgH2DArr[plot_i].data[*,*] = 0 ;set these to zero

     notMasked_i      = WHERE(h2dStrarr[4].data LT 250,COMPLEMENT=masked_i)
     nAvgH2dArr[plot_i].data[notMasked_i]  += 1 ;initial update
     IF h2dStrArr[plot_i].is_logged AND STRMATCH(dataNameArr[plot_i],"*timeAvgd*",/FOLD_CASE) THEN BEGIN
        h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
        h2dStrArr[plot_i].data[masked_i]    = 0
        h2dStrArr[plot_i].lim               = 10.^(h2dStrArr[plot_i].lim)
        h2dStrArr[plot_i].lim[0]            = 0.0
        h2dStrArr[plot_i].is_logged         = 0
        h2dStrArr[plot_i].force_oobLow      = 0
     ENDIF
     IF KEYWORD_SET(logAvg_these_inds) THEN BEGIN
        logMe = WHERE(plot_i EQ logAvg_these_inds)
        IF logMe[0] NE -1 THEN BEGIN
           IF ~h2dStrArr[plot_i].is_logged THEN BEGIN
              h2dStrArr[plot_i].data[notMasked_i] = ALOG10(h2dStrArr[plot_i].data[notMasked_i])
              h2dStrArr[plot_i].is_logged   = 1
              h2dStrArr[plot_i].lim         = ALOG10(lim_for_logAvg_inds[*,logMe])
           ENDIF
        ENDIF
     ENDIF
  ENDFOR

  averagedh2ds        = h2dStrArr
  dataNames           = !NULL
  FOR i=0,nPlots-1 DO BEGIN
     dataNames        = [dataNames,h2dStrArr[i].title]
  ENDFOR

  ;;Now combine
  FOR i=1,N_ELEMENTS(delayArr)-1 DO BEGIN
     RESTORE,fileDir+paramStrArr[i]+'.dat'

     FOR plot_i=0,nPlots-1 DO BEGIN
        notMasked_i   = WHERE(h2dStrarr[4].data LT 250,COMPLEMENT=masked_i)
        nAvgH2dArr[plot_i].data[notMasked_i] += 1

        IF h2dStrArr[plot_i].is_logged AND STRMATCH(dataNameArr[plot_i],"*timeAvgd*",/FOLD_CASE) THEN BEGIN
           h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
           h2dStrArr[plot_i].data[masked_i]    = 0
        ENDIF
        IF KEYWORD_SET(logAvg_these_inds) THEN BEGIN
           logMe = WHERE(plot_i EQ logAvg_these_inds)
           IF logMe[0] NE -1 THEN BEGIN
              IF ~h2dStrArr[plot_i].is_logged THEN BEGIN
                 h2dStrArr[plot_i].data[notMasked_i] = ALOG10(h2dStrArr[plot_i].data[notMasked_i])
                 h2dStrArr[plot_i].is_logged   = 1
                 h2dStrArr[plot_i].lim         = ALOG10(lim_for_logAvg_inds[*,logMe])
              ENDIF
           ENDIF
        ENDIF
        averagedH2ds[plot_i].data[notMasked_i] += h2dStrArr[plot_i].data[notMasked_i]
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

  IF ~h2dStrArr[0].is_logged THEN h2dStrArr[0].lim[1] = 0.5
  IF ~h2dStrArr[1].is_logged THEN h2dstrarr[1].lim[1] = 0.5
  IF ~h2dStrArr[2].is_logged THEN h2dstrarr[2].lim[1] = 1e8

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
                         SAVEDIR=saveDir,PARAMSTR=paramStr,$
                         CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg, $
                         STABLEIMF=stableIMF,HOYDIA=hoyDia,HEMI=hemi, $
                         /QUIET, $
                         LUN=lun
  
END
