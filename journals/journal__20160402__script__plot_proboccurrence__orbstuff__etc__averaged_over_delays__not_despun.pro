PRO JOURNAL__20160402__SCRIPT__PLOT_PROBOCCURRENCE__ORBSTUFF__ETC__AVERAGED_OVER_DELAYS__NOT_DESPUN

  create_plots         = 1
  combine_plots        = 1
  save_combined_window = 1
  combined_to_buffer   = 1

  no_overwrite_existing = 0

  maskMin              = 5
  despun               = 0

  just_north           = 1

  ;; quants_to_plot       = [3]
  ;; quants_to_plot       = [0,1,2,3]
  quants_to_plot       = [0,1,2,3,4]
  ;; quants_to_plot       = [0,1,2,3,4,5]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Delay stuff
  ;; nDelArr              = [121,241]
  ;; delayDeltaSec        = [15,15]
  
  ;; nDelArr              = [61,121]
  ;; delayDeltaSec        = [30,30]

  nDelArr              = [11,21,31,41,51,61]
  delayDeltaSec        = [60,60,60,60,60,60]

  ;; nDelArr              = [31,61]
  ;; delayDeltaSec        = [60,60]

  ;; delay_start          = -5
  ;; delay_stop           = 20

  ;; nDelArr              = [31,61,61,121]
  ;; delayDeltaSec        = [60,60,30,30]

  IF just_north THEN hemiArr = 'NORTH' ELSE hemiArr = ['NORTH','SOUTH']

  clockStrArr          = ['dawnward','duskward']

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Avg types?
  ;; in_avgTypes             = ['avg','avg']
  ;; out_avgTypes            = ['avg','logAvg']
  
  ;; in_avgTypes             = ['avg']
  ;; out_avgTypes            = ['avg']

  ;; in_avgTypes             = ['avg']
  ;; out_avgTypes            = ['logAvg']

  ;; in_avgTypes             = ['logAvg']
  in_avgTypes             = ['avg']
  out_avgTypes            = ['timeAvg']

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF Conds
  ;; plot_dateStr         = 'Apr_3_16'
  plot_dateStr         = 'Apr_4_16'
  IMFCondStrArr        = '__ABS_byMin10.0__bzMax2.0'
  ;; IMFCondStrArr        = '__ABS_byMin10.0__bzMax0.0'
  ;; IMFCondStrArr        = '__ABS_byMin10.0'
  ;; IMFCondStrArr        = '__ABS_byMin8.0__bzMax-1.0'
  ;; IMFCondStrArr        = '__ABS_byMin7.0'
  ;; IMFCondStrArr        = '__ABS_byMin7.0__bzMax0.0'
  ;; IMFCondStrArr        = '__ABS_byMin5.0__bzMax-3.0'
  ;; IMFCondStrArr        = '__ABS_byMin5.0__bzMax-1.0'
  ;; IMFCondStrArr        = '__ABS_byMin4.0__bzMax-2.0'
  ;; IMFCondStrArr        = '__ABS_byMin3.0__bzMax-1.0'
  ;; IMFCondStrArr        = ''

  ;; plotDirSuff          = 'not_despun'

  fileDir              = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/processed/'
  fileList             = LIST()

  FOR iAvgType=0,N_ELEMENTS(in_avgTypes)-1 DO BEGIN
     FOR iCond=0,N_ELEMENTS(IMFCondStrArr)-1 DO BEGIN
        FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN

              fileArr = !NULL
              FOR iClock=0,N_ELEMENTS(clockStrArr)-1 DO BEGIN

                 ;;First make the plots
                 PLOT_QUANTITIES_AVERAGED_OVER_DELAYS, $
                    HEMI=hemiArr[iHemi], $
                    DESPUN=despun, $
                    MASKMIN=maskMin, $
                    CLOCKSTR=clockStrArr[iClock], $
                    NDELAYS=nDelArr[iDel], $
                    DELAYDELTASEC=delayDeltaSec[iDel], $
                    DELAY_START=delay_start, $
                    DELAY_STOP=delay_stop, $
                    IN_AVGTYPE=in_avgTypes[iAvgType], $
                    OUT_AVGTYPE=out_avgTypes[iAvgType], $
                    IMFCONDSTR=IMFCondStrArr[iCond], $
                    PLOT_DATESTR=plot_dateStr, $
                    ADDITIONAL_PLOTDIRSUFF=plotDirSuff, $
                    OUT_PLOTNAMEPREF=out_plotNamePref, $
                    OUT_PLOTDIR=plotDir, $
                    JUST_OUTPUT_NAMES=~KEYWORD_SET(create_plots), $
                    QUANTS_TO_PLOT=quants_to_plot;, $
                    ;; DONT_OVERWRITE_EXISTING=dont_overwrite_existing
                 
                 IF KEYWORD_SET(combine_plots) THEN fileArr = [fileArr,out_plotNamePref+'.dat']
              ENDFOR
              fileList.add,fileArr
           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR

  IF KEYWORD_SET(combine_plots) THEN BEGIN
     
     titles             = ['Dawnward','Duskward']
     FOR iDawnDuskSet=0,N_ELEMENTS(fileList)-1 DO BEGIN
        plotNamePrefArr           = [STRMID(fileList[iDawnDuskSet,0],0,STRLEN(fileList[iDawnDuskSet,0])-4), $
                                     STRMID(fileList[iDawnDuskSet,1],0,STRLEN(fileList[iDawnDuskSet,1])-4)]
        outTempFiles              = fileDir+[fileList[iDawnDuskSet,0],fileList[iDawnDuskSet,1]]
        COMBINE_ALFVEN_STATS_PLOTS,titles, $
                                   N_TO_COMBINE=n_to_combine, $
                                   TEMPFILES=outTempFiles, $
                                   COMBINED_TO_BUFFER=combined_to_buffer, $
                                   SAVE_COMBINED_WINDOW=save_combined_window, $
                                   SAVE_COMBINED_NAME=save_combined_name, $
                                   PLOTSUFFIX=plotSuffix, $
                                   PLOTDIR=plotDir, $
                                   PLOTNAMEPREFARR=plotNamePrefArr, $
                                   /DELETE_PLOTS_WHEN_FINISHED, $
                                   DONT_OVERWRITE_EXISTING=no_overwrite_existing
     ENDFOR
  ENDIF

END

