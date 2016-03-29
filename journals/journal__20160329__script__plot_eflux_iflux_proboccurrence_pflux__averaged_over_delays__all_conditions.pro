PRO JOURNAL__20160329__SCRIPT__PLOT_EFLUX_IFLUX_PROBOCCURRENCE_PFLUX__AVERAGED_OVER_DELAYS__ALL_CONDITIONS

  create_plots         = 1
  combine_plots        = 1
  save_combined_window = 1
  combined_to_buffer   = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Delay stuff
  nDelArr              = [121,241]
  delayDeltaSec        = [15,15]
  
  ;; nDelArr              = [61,121]
  ;; delayDeltaSec        = [30,30]

  ;; nDelArr              = [31,61]
  ;; delayDeltaSec        = [60,60]

  ;; nDelArr              = [31,61,61,121]
  ;; delayDeltaSec        = [60,60,30,30]

  hemiArr              = ['NORTH','SOUTH']
  clockStrArr          = ['dawnward','duskward']

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Avg types?
  ;; in_avgTypes             = ['avg','avg']
  ;; out_avgTypes            = ['avg','logAvg']
  
  ;; in_avgTypes             = ['avg']
  ;; out_avgTypes            = ['avg']

  ;; in_avgTypes             = ['avg']
  ;; out_avgTypes            = ['logAvg']

  in_avgTypes             = ['avg']
  out_avgTypes            = ['timeAvg']

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF Conds
  ;; plot_dateStr         = 'Mar_29_16'
  ;; IMFCondStrArr        = '__ABS_byMin5.0__bzMax-1.0'
  ;; IMFCondStrArr        = ['__ABS_byMin5.0__bzMax0.0','__ABS_byMin5.0__bzMin0.0']

  plot_dateStr         = 'Mar_28_16'
  IMFCondStrArr        = '__ABS_byMin5.0__bzMax-1.0'

  fileDir              = '/SPENCEdata/Research/Cusp/ACE_FAST/processed/'
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
                    CLOCKSTR=clockStrArr[iClock], $
                    NDELAYS=nDelArr[iDel], $
                    DELAYDELTASEC=delayDeltaSec[iDel], $
                    IN_AVGTYPE=in_avgTypes[iAvgType], $
                    OUT_AVGTYPE=out_avgTypes[iAvgType], $
                    IMFCONDSTR=IMFCondStrArr[iCond], $
                    PLOT_DATESTR=plot_dateStr, $
                    OUT_PLOTNAMEPREF=out_plotNamePref, $
                    OUT_PLOTDIR=plotDir, $
                    JUST_OUTPUT_NAMES=~KEYWORD_SET(create_plots)
                 
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
                                   /DELETE_PLOTS_WHEN_FINISHED
     ENDFOR
  ENDIF

END
