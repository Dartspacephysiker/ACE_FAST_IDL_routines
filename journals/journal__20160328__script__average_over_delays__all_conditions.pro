;;2016/03/23 Too painful to keep doing all of this manually
PRO JOURNAL__20160328__SCRIPT__AVERAGE_OVER_DELAYS__ALL_CONDITIONS

  plot_dateStr         = 'Mar_28_16'

  ;; nDelArr              = [121,241]
  ;; delayDeltaSec        = 15

  nDelArr              = [61,121]
  delayDeltaSec        = 30

  hemiArr              = ['NORTH','SOUTH']
  clockStrArr          = ['dawnward','duskward']

  ;; avgTypes             = ['logAvg', 'avg']
  avgTypes             = 'avg'

  IMFCondStrArr        = ['__ABS_byMin5.0__bzMax-1.0','__ABS_byMin5.0__bzMin1.0']
  ;; IMFCondStrArr        = '__ABS_byMin5.0__bzMax-1.0'

  ;; dont_logAvg_inds     = [0,1,2,3]
  logAvg_inds          = [0,1,2,3]

  dont_logPlot_inds    = [0,1,2,3]
  unlogPlot_lims       = [[0.0,0.8], $
                          [0.0,0.8], $
                          [0.0,1e8], $
                          [0.0,0.2]]

  ;; logPlot_lims         = [[10.^(-1.0),10.^(0.5)], $
  ;;                         [10.^(-1.0),10.^(0.5)], $
  ;;                         [10.^( 6.5),10.^( 9.5)]]
  ;; lim_for_logPlot_inds    = logPlot_lims

  

  lim_for_unlogPlot_inds  = unlogplot_lims
  ;; dont_logAvg_these_inds  = dont_logAvg_inds
  logAvg_these_inds       = logAvg_inds
  dont_logPlot_these_inds = dont_logPlot_inds

  FOR iCond=0,N_ELEMENTS(IMFCondStrArr)-1 DO BEGIN
     FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
        FOR iClock=0,N_ELEMENTS(clockStrArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN
              FOR iAvgType=0,N_ELEMENTS(avgTypes)-1 DO BEGIN
                 AVERAGE_H2DS_OVER_DELAYS, $
                    HEMI=hemiArr[iHemi], $
                    CLOCKSTR=clockStrArr[iClock], $
                    NDELAYS=nDelArr[iDel], $
                    DELAYDELTASEC=delayDeltaSec, $
                    AVGTYPE=avgTypes[iAvgType], $
                    LOGAVG_THESE_INDS=logAvg_these_inds, $
                    DONT_LOGAVG_THESE_INDS=dont_logAvg_these_inds, $
                    DONT_LOGPLOT_THESE_INDS=dont_logPlot_these_inds, $
                    LIM_FOR_LOGPLOT_INDS=lim_for_logPlot_inds, $
                    LIM_FOR_UNLOGPLOT_INDS=lim_for_unlogPlot_inds, $
                    IMFCONDSTR=IMFCondStrArr[iCond], $
                    PLOT_DATESTR=plot_dateStr
              ENDFOR
           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR
  
END
