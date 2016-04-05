PRO PLOT_QUANTITIES_AVERAGED_OVER_DELAYS, $
   HEMI=hemi, $
   DESPUN=despun, $
   MASKMIN=maskMin, $
   CLOCKSTR=clockStr, $
   NDELAYS=nDelays, $
   DELAYDELTASEC=delayDeltaSec, $
   RESOLUTION_DELAY=delay_res, $
   BINOFFSET_DELAY=binOffset_delay, $
   DELAYARR=delayArr, $
   DELAY_START=delay_start, $
   DELAY_STOP=delay_stop, $
   IN_AVGTYPE=in_avgType, $
   OUT_AVGTYPE=out_avgType, $
   IMFCONDSTR=IMFCondStr, $
   PLOT_DATESTR=plot_dateStr, $
   ADDITIONAL_PLOTDIRSUFF=additional_plotDirSuff, $
   OUT_PLOTNAMEPREF=out_plotNamePref, $
   OUT_PLOTDIR=out_plotDir, $
   QUANTS_TO_PLOT=quants_to_plot, $
   JUST_OUTPUT_NAMES=just_output_names;, $
   ;; DONT_OVERWRITE_EXISTING=dont_overwrite_existing



  ;; hemi                = 'SOUTH'
  IF ~KEYWORD_SET(hemi) THEN hemi = 'NORTH'
  
  IF KEYWORD_SET(despun)              THEN despunStr          = 'despun--' ELSE despunStr = ''

  maskStr                                                     = ''
  defMaskMin                                                  = 5
  IF N_ELEMENTS(maskMin) EQ 0 THEN maskMin = defMaskMin $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='--maskMin' + STRCOMPRESS(maskMin,/REMOVE_ALL)
     ENDIF
  ENDELSE

  ;; clockStr            = 'duskward'
  IF ~KEYWORD_SET(clockStr) THEN clockStr = 'dawnward'

  ;; IF ~KEYWORD_SET(avgType) THEN avgType   = 'logAvg'

  ;;Delay stuff (nDelays = 61 will average over delays between -30 and 30 min, inclusive)
  IF ~KEYWORD_SET(nDelays)            THEN nDelays            = 31
  IF ~KEYWORD_SET(delayDeltaSec)      THEN delayDeltaSec      = 15
  IF ~KEYWORD_SET(delay_res)          THEN delay_res          = 120
  IF N_ELEMENTS(binOffset_delay)EQ 0  THEN binOffset_delay    = 0 

  IF ~KEYWORD_SET(IMFCondStr)         THEN IMFCondStr         = ''

  IF ~KEYWORD_SET(plot_dateStr)       THEN plot_dateStr       = 'Mar_28_16'

  IF ~KEYWORD_SET(quants_to_plot)     THEN quants_to_plot     = [0,1,2,3]

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''
  fileDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/processed/'

  IF N_ELEMENTS(delay_start) GT 0 THEN BEGIN
     delayArr = (INDGEN(FIX((delay_stop-delay_start)*60./delayDeltaSec)+1,/LONG)+delay_start)*delayDeltaSec
  ENDIF ELSE BEGIN
     delayArr = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  ENDELSE
  ;; delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 
  ;; delayStr = delayStr + delayResStr + delBinOffStr
  out_avgString       = GET_DELAY_AVG_STRING(out_avgType,delayArr,delayDeltaSec,delay_res)

  paramPref           = 'polarplots_' + plot_dateStr+'--' + hemi + '--' + despunStr + in_avgType + maskStr
  omniPref            = '--OMNI--GSM--'+clockStr+'__0stable'

  inFile              = paramPref + bonusSuff + omniPref + out_avgString + IMFCondStr + '.dat'

  plotDirSuff         = IMFCondStr
  IF KEYWORD_SET(additional_plotDirSuff) THEN plotDirSuff = plotDirSuff + additional_plotDirSuff

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF=plotDirSuff

  IF ~KEYWORD_SET(just_output_names) THEN BEGIN
     PLOT_2DHISTO_FILE,fileDir+inFile, $
                       /MIDNIGHT, $
                       PLOTDIR=plotDir, $
                       PLOTNAMEPREF=paramPref+omniPref+out_avgString+IMFCondStr, $
                       QUANTS_TO_PLOT=quants_to_plot
  ENDIF

  out_plotNamePref    = paramPref+omniPref+out_avgString+IMFCondStr
  out_plotDir         = plotDir

END
