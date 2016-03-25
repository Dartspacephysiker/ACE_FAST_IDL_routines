PRO JOURNAL__20160324__PLOT_EFLUX_IFLUX_PROBOCCURRENCE_PFLUX__AVERAGED_OVER_DELAYS, $
   HEMI=hemi, $
   CLOCKSTR=clockStr, $
   NDELAYS=nDelays, $
   AVGTYPE=avgType, $
   IMFCONDSTR=IMFCondStr, $
   OUT_PLOTNAMEPREF=out_plotNamePref, $
   OUT_PLOTDIR=out_plotDir


  ;; hemi                = 'SOUTH'
  IF ~KEYWORD_SET(hemi) THEN hemi = 'NORTH'
  
  ;; clockStr            = 'duskward'
  IF ~KEYWORD_SET(clockStr) THEN clockStr = 'dawnward'

  IF ~KEYWORD_SET(avgType) THEN avgType   = 'logAvg'

  date                = '20160325'
  date_alt            = 'Mar_25_16'

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''
  fileDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/processed/'

  ;;Delay stuff (nDelays = 61 will average over delays between -30 and 30 min, inclusive)
  IF ~KEYWORD_SET(nDelays) THEN nDelays = 31
  delayArr            = (INDGEN(nDelays,/LONG)-nDelays/2)*60
  delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 


  paramPref           = 'polarplots_' + date_alt+'--' + hemi + '--despun--'+avgType+'--maskMin5'
  omniPref            = '--OMNI--GSM--'+clockStr+'__0stable'
  IMFCondStr          = KEYWORD_SET(IMFCondStr) ? IMFCondStr : '__ABS_byMin5.0__bzMax-1.0'
  avgString           = STRING(FORMAT='("__averaged_over_",F0.2,"-",F0.2,"minDelays")',delayArr[0]/60.,delayArr[-1]/60.)

  inFile              = paramPref + bonusSuff + omniPref + avgString + IMFCondStr + '.dat'

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  PLOT_2DHISTO_FILE,fileDir+inFile, $
                    /MIDNIGHT, $
                    PLOTDIR=plotDir, $
                    PLOTNAMEPREF=paramPref+omniPref+avgString+IMFCondStr, $
                    QUANTS_TO_PLOT=[0,1,2,3]
                    
  out_plotNamePref    = paramPref+omniPref+avgString+IMFCondStr
  out_plotDir         = plotDir

END
