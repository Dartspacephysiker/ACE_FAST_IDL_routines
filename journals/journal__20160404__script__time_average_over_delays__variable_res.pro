;;2016/04/04
PRO JOURNAL__20160404__SCRIPT__TIME_AVERAGE_OVER_DELAYS__VARIABLE_RES

  ;; plot_dateStr         = 'Apr_2_16'
  ;; plot_dateStr         = 'Apr_3_16'
  plot_dateStr         = 'Apr_6_16'

  despun               = 1
  maskMin              = 5
  minAvgs_for_noMask   = 1

  just_north           = 0
  just_south           = 0

  ;; nDelArr              = [121,241]
  ;; delayDeltaSec        = 15

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;delay stuff
  totMinToDisplay                = 120

  ;; delayDeltaSec                  = 900
  ;; delay_res                      = 900
  ;; binOffset_delay                = 0

  ;; delayDeltaSec                  = 600
  ;; delay_res                      = 600
  ;; binOffset_delay                = 0
  ;; nDelArr              = [1,3,5,7,9,11,13]

  ;; delayDeltaSec                  = 1200
  ;; delay_res                      = 1200
  ;; binOffset_delay                = 0
  ;; nDelArr              = [1,3,5]

  delayDeltaSec                  = 1800
  delay_res                      = 1800
  binOffset_delay                = 0
  nDelArr              = [1,3,5]

  ;; delayDeltaSec                  = 1200
  ;; delay_res                      = 1200
  ;; binOffset_delay                = 600

  ;; delayDeltaSec                  = 1800
  ;; delay_res                      = 1800
  ;; binOffset_delay                = 0

  ;; totMinToDisplay                = 180
  ;; delayDeltaSec                  = 3600
  ;; delay_res                      = 3600
  ;; binOffset_delay                = 0
  ;; nDelArr              = [1,3]

  CASE 1 OF
     just_north: hemiArr = 'NORTH'
     just_south: hemiArr = 'SOUTH'
     ELSE: hemiArr = ['NORTH','SOUTH']
  ENDCASE

  clockStrArr          = ['dawnward','duskward']

  ;; IMFCondStrArr        = ['__ABS_byMin5.0__bzMax0.0','__ABS_byMin5.0__bzMin0.0']
  ;; IMFCondStrArr        = '__ABS_byMin10.0'
  ;; IMFCondStrArr        = '__ABS_byMin10.0__bzMax2.0'
  ;; IMFCondStrArr        = '__ABS_byMin10.0__bzMax0.0'
  ;; IMFCondStrArr        = '__ABS_byMin9.0__bzMax-3.0'
  ;; IMFCondStrArr        = '__ABS_byMin8.0__bzMax-1.0'
  ;; IMFCondStrArr        = '__ABS_byMin8.0__bzMax-4.0'
  ;; IMFCondStrArr        = '__ABS_byMin7.0__bzMax0.0'
  ;; IMFCondStrArr        = '__ABS_byMin7.0'
  IMFCondStrArr        = '__ABS_byMin5.0__bzMax-5.0'
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
  unlogPlot_lims       = [[0.0,1.0], $
                          [0.0,1.0], $
                          [0.0,1e8], $
                          ;; [0.0, 50], $   ; No nEvPerOrb plot this time 'round
                          [0.0,0.15], $
                          [0.0,700]]

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
  ;; fileDir              = '/SPENCEdata/Research/Cusp/ACE_FAST/temp/20160329--not_timeavgd_orbstuff/'
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
                    MINAVGS_FOR_NOMASK=minAvgs_for_noMask, $
                    CLOCKSTR=clockStrArr[iClock], $
                    NDELAYS=nDelArr[iDel], $
                    DELAYDELTASEC=delayDeltaSec, $
                    RESOLUTION_DELAY=delay_res, $
                    BINOFFSET_DELAY=binOffset_delay, $
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

