;;2016/04/02 Now you not despun, son
PRO JOURNAL__20160402__SCRIPT__TIME_AVERAGE_OVER_DELAYS__NOT_DESPUN

  ;; plot_dateStr         = 'Apr_2_16'
  ;; plot_dateStr         = 'Apr_3_16'
  plot_dateStr         = 'Apr_4_16'

  despun               = 0
  maskMin              = 5

  just_north           = 1

  ;; nDelArr              = [121,241]
  ;; delayDeltaSec        = 15

  nDelArr              = [11,21,31,41,51,61]
  delayDeltaSec        = 60
  ;; delay_start          = -5
  ;; delay_stop           = 20

  ;; nDelArr              = [61,121]
  ;; delayDeltaSec        = 30

  IF just_north THEN hemiArr = 'NORTH' ELSE hemiArr = ['NORTH','SOUTH']

  clockStrArr          = ['dawnward','duskward']

  ;; IMFCondStrArr        = ['__ABS_byMin5.0__bzMax0.0','__ABS_byMin5.0__bzMin0.0']
  ;; IMFCondStrArr        = '__ABS_byMin10.0'
  IMFCondStrArr        = '__ABS_byMin10.0__bzMax2.0'
  ;; IMFCondStrArr        = '__ABS_byMin10.0__bzMax0.0'
  ;; IMFCondStrArr        = '__ABS_byMin8.0__bzMax-1.0'
  ;; IMFCondStrArr        = '__ABS_byMin7.0__bzMax0.0'
  ;; IMFCondStrArr        = '__ABS_byMin7.0'
  ;; IMFCondStrArr        = '__ABS_byMin5.0__bzMax-3.0'
  ;; IMFCondStrArr        = '__ABS_byMin5.0__bzMax-1.0'
  ;; IMFCondStrArr        = '__ABS_byMin4.0__bzMax-2.0'
  ;; IMFCondStrArr        = '__ABS_byMin3.0__bzMax-3.0'
  ;; IMFCondStrArr        = ''


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;What type of averaging?
  ;; dont_logAvg_inds     = [0,1,2,3]
  ;; in_avgTypes          = 'avg'
  ;; out_avgTypes         = 'avg'

  ;; logAvg_inds       = [0,1,2,3]
  ;; in_avgTypes       = 'avg'
  ;; out_avgTypes      = 'logAvg'

  ;; timeAvg_these_inds   = [0,1,2,3,4,5]
  timeAvg_these_inds   = [0,1,2,3,4]
  ;; in_avgTypes          = 'logAvg'
  in_avgTypes          = 'avg'
  out_avgTypes         = 'timeAvg'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot on linear or log scale?
  ;; dont_logPlot_inds    = [0,1,2,3,4,5]
  dont_logPlot_inds    = [0,1,2,3,4]
  ;; dont_logPlot_inds    = [0,1,2,3]

  ;2016/04/02 For plots involving byMin10.0__bzMax2.0
  unlogPlot_lims       = [[0.0,0.3], $
                          [0.0,1.0], $
                          [0.0,1e8], $
                          ;; [0.0, 50], $   ; No nEvPerOrb plot this time 'round
                          [0.0,0.15], $
                          [0.0,800]]

  ;2016/04/02 For plots involving byMin8.0__bzMax-1.0, NOT DESPUN
  ;; unlogPlot_lims       = [[0.0,0.8], $
  ;;                         [0.0,2.0], $
  ;;                         [0.0,3e8], $
  ;;                         ;; [0.0, 50], $   ; No nEvPerOrb plot this time 'round
  ;;                         [0.0,0.25], $
  ;;                         [0.0,500]]

  ;2016/04/02 For plots involving byMin5.0__bzMin-1.0, NOT DESPUN
  ;; unlogPlot_lims       = [[0.0,1.0], $
  ;;                         [0.0,2.0], $
  ;;                         [0.0,5e8], $
  ;;                         ;; [0.0, 50], $   ; No nEvPerOrb plot this time 'round
  ;;                         [0.0,0.2], $
  ;;                         [0.0,450]]

  ;2016/03/31 For plots only involving clock angle
  ;; unlogPlot_lims       = [[0.0,0.2], $
  ;;                         [0.0,0.4], $
  ;;                         [0.0,6e7], $
  ;;                         ;; [0.0, 30], $
  ;;                         [0.0,0.06], $
  ;;                         [0.0,1000]]


  ;---->Together 2016/03/29
  ;; fileDir              = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/20160329--not_timeavgd_orbstuff/'
  ;; dont_logPlot_inds    = [3,4]
  ;; unlogPlot_lims       = [[0,1e2], $
  ;;                         [0.0,0.1]]

  ;; logPlot_inds         = [0,1,2]
  ;; logPlot_lims         = [[1e-1,1e1], $
  ;;                         [1e-1,1e1], $
  ;;                         [1e6,1e8]];, $
                          ;; [1e-1,1e2]];, $
                          ;; [1e-3,1e-1]]
  ;---->Together 2016/03/29 (END)

  ;; logPlot_lims         = [[10.^(-1.0),10.^(0.5)], $
  ;;                         [10.^(-1.0),10.^(0.5)], $
  ;;                         [10.^( 6.5),10.^( 9.5)]]

  FOR iCond=0,N_ELEMENTS(IMFCondStrArr)-1 DO BEGIN
     FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
        FOR iClock=0,N_ELEMENTS(clockStrArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN
              FOR iAvgType=0,N_ELEMENTS(in_avgTypes)-1 DO BEGIN
                 AVERAGE_H2DS_OVER_DELAYS, $
                    HEMI=hemiArr[iHemi], $
                    DESPUN=despun, $
                    MASKMIN=maskMin, $
                    CLOCKSTR=clockStrArr[iClock], $
                    NDELAYS=nDelArr[iDel], $
                    DELAYDELTASEC=delayDeltaSec, $
                    DELAY_START=delay_start, $
                    DELAY_STOP=delay_stop, $
                    IN_AVGTYPE=in_avgTypes[iAvgType], $
                    OUT_AVGTYPE=out_avgTypes[iAvgType], $
                    LOGAVG_THESE_INDS=logAvg_inds, $
                    TIMEAVG_THESE_INDS=timeAvg_these_inds, $   
                    DONT_LOGAVG_THESE_INDS=dont_logAvg_inds, $
                    LOGPLOT_THESE_INDS=logPlot_inds, $
                    DONT_LOGPLOT_THESE_INDS=dont_logPlot_inds, $
                    LIM_FOR_LOGPLOT_INDS=logPlot_lims, $
                    LIM_FOR_UNLOGPLOT_INDS=unlogPlot_lims, $
                    IMFCONDSTR=IMFCondStrArr[iCond], $
                    PLOT_DATESTR=plot_dateStr, $
                    FILEDIR=fileDir
              ENDFOR
           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR
  
END

