PRO JOURNAL__20160328__PLOT_EFLUX_IFLUX_PROBOCCURRENCE_PFLUX__AVERAGED_OVER_DELAYS, $
   HEMI=hemi, $
   CLOCKSTR=clockStr, $
   NDELAYS=nDelays, $
   DELAYDELTASEC=delayDeltaSec, $
   AVGTYPE=avgType, $
   IMFCONDSTR=IMFCondStr, $
   PLOT_DATESTR=plot_dateStr, $
   OUT_PLOTNAMEPREF=out_plotNamePref, $
   OUT_PLOTDIR=out_plotDir, $
   QUANTS_TO_PLOT=quants_to_plot


  ;; hemi                = 'SOUTH'
  IF ~KEYWORD_SET(hemi) THEN hemi = 'NORTH'
  
  ;; clockStr            = 'duskward'
  IF ~KEYWORD_SET(clockStr) THEN clockStr = 'dawnward'

  ;; IF ~KEYWORD_SET(avgType) THEN avgType   = 'logAvg'

  ;;Delay stuff (nDelays = 61 will average over delays between -30 and 30 min, inclusive)
  IF ~KEYWORD_SET(nDelays)            THEN nDelays            = 31
  IF ~KEYWORD_SET(delayDeltaSec)      THEN delayDeltaSec      = 15

  IF ~KEYWORD_SET(IMFCondStr)         THEN IMFCondStr         = '__ABS_byMin5.0__bzMax-1.0'

  date                = '20160328'
  IF ~KEYWORD_SET(plot_dateStr)       THEN plot_dateStr       = 'Mar_28_16'

  IF ~KEYWORD_SET(quants_to_plot)     THEN quants_to_plot     = [0,1,2,3]

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''
  fileDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/processed/'

  delayArr            = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 
  avgString           = STRING(FORMAT='("__averaged_over_",F0.2,"-",F0.2,"minDelays--delay_delta_",I0,"sec")',delayArr[0]/60.,delayArr[-1]/60.,delayDeltaSec)

  paramPref           = 'polarplots_' + plot_dateStr+'--' + hemi + '--despun--'+avgType+'--maskMin5'
  omniPref            = '--OMNI--GSM--'+clockStr+'__0stable'

  inFile              = paramPref + bonusSuff + omniPref + avgString + IMFCondStr + '.dat'

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  PLOT_2DHISTO_FILE,fileDir+inFile, $
                    /MIDNIGHT, $
                    PLOTDIR=plotDir, $
                    PLOTNAMEPREF=paramPref+omniPref+avgString+IMFCondStr, $
                    QUANTS_TO_PLOT=quants_to_plot
                    
  out_plotNamePref    = paramPref+omniPref+avgString+IMFCondStr
  out_plotDir         = plotDir

END
