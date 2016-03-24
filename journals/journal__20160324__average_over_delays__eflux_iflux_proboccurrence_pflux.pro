PRO JOURNAL__20160324__AVERAGE_OVER_DELAYS__EFLUX_IFLUX_PROBOCCURRENCE_PFLUX,HEMI=hemi,CLOCKSTR=clockStr,NDELAYS=nDelays

  ;; hemi                = 'SOUTH'
  IF ~KEYWORD_SET(hemi) THEN hemi = 'NORTH'
  
  ;; clockStr            = 'duskward'
  IF ~KEYWORD_SET(clockStr) THEN clockStr = 'dawnward'

  date                = '20160324'
  date_alt            = 'Mar_24_16'

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''
  fileDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/temp/'
  outDir              = '/SPENCEdata/Research/Cusp/ACE_FAST/processed/'

  ;;Delay stuff (nDelays = 61 will average over delays between -30 and 30 min, inclusive)
  IF ~KEYWORD_SET(nDelays) THEN nDelays = 31

  delayArr            = (INDGEN(nDelays,/LONG)-nDelays/2)*60
  delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 

  ;; paramStr            = 'Feb_26_16--'+hemi+'--despun--logAvg--maskMin10--OMNI--GSM--duskward__0stable' + delayStr + '__byMin3.0--'
  ;; paramStr            = 'Feb_26_16--'+hemi+'--despun--logAvg--maskMin10--OMNI--GSM--duskward__0stable' + delayStr + '__byMin3.0__bzMin-4.0__bzMax4.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin10'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin10'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0__bzMax-1.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin5'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0__bzMax-3.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin5'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin6.0--'
  paramPref           = 'polarplots_' + date_alt+'--' + hemi + '--despun--logAvg--maskMin5'
  omniPref            = '--OMNI--GSM--'+clockStr+'__0stable'
  IMFCondStr          = '__byMin5.0__bzMax-1.0.dat'
  avgString           = STRING(FORMAT='("__averaged_over_",F0.2,"-",F0.2,"minDelays")',delayArr[0]/60.,delayArr[-1]/60.)

  outFile             = paramPref + bonusSuff + omniPref + avgString + IMFCondStr

  paramStrArr         = paramPref + bonusSuff + omniPref + delayStr + IMFCondStr

  ;;get N plots in these files, initialize average
  RESTORE,fileDir+paramStrArr[0]

  nPlots              = N_ELEMENTS(h2dStrArr)
  FOR plot_i=0,nPlots-1 DO BEGIN
     notMasked_i      = WHERE(h2dStrarr[4].data LT 250,COMPLEMENT=masked_i)
     IF h2dStrArr[plot_i].is_logged THEN BEGIN
        h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
        h2dStrArr[plot_i].data[masked_i]    = 0
        h2dStrArr[plot_i].lim               = 10.^(h2dStrArr[plot_i].lim)
        h2dStrArr[plot_i].lim[0]            = 0.0
        h2dStrArr[plot_i].is_logged         = 0
        h2dStrArr[plot_i].force_oobLow      = 0
        ENDIF
     ENDFOR

  averagedh2ds        = h2dStrArr
  dataNames           = !NULL
  FOR i=0,nPlots-1 DO BEGIN
     dataNames        = [dataNames,h2dStrArr[i].title]
  ENDFOR

  ;;Now combine
  FOR i=1,N_ELEMENTS(delayArr)-1 DO BEGIN
     RESTORE,fileDir+paramStrArr[i]

     FOR plot_i=0,nPlots-1 DO BEGIN
        notMasked_i   = WHERE(h2dStrarr[4].data LT 250,COMPLEMENT=masked_i)
        IF h2dStrArr[plot_i].is_logged THEN BEGIN
           h2dStrArr[plot_i].data[notMasked_i] = 10.^(h2dStrArr[plot_i].data[notMasked_i])
           h2dStrArr[plot_i].data[masked_i]    = 0
        ENDIF
        averagedH2ds[plot_i].data[notMasked_i] += h2dStrArr[plot_i].data[notMasked_i]
     ENDFOR

  ENDFOR

  FOR plot_i=0,nPlots-1 DO BEGIN
     averagedH2ds[plot_i].data = averagedH2ds[plot_i].data/nDelays
  ENDFOR

  h2dStrArr = averagedH2ds

  h2dStrArr[0].lim[1] = 0.5
  h2dstrarr[1].lim[1] = 0.5
  h2dstrarr[2].lim[1] = 1e8

  PRINT,'Saving averaged h2ds to ' + outFile + '...'
  SAVE_ALFVENDB_TEMPDATA,TEMPFILE=outDir+outFile, $
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
