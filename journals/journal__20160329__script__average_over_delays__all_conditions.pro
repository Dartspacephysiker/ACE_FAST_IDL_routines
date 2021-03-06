;;2016/03/29 Change Bz requirements a little
PRO JOURNAL__20160329__SCRIPT__AVERAGE_OVER_DELAYS__ALL_CONDITIONS

  plot_dateStr         = 'Mar_29_16'

  ;; nDelArr              = [121,241]
  ;; delayDeltaSec        = 15

  nDelArr              = [31,61]
  delayDeltaSec        = 60

  hemiArr              = ['NORTH','SOUTH']
  clockStrArr          = ['dawnward','duskward']

  IMFCondStrArr        = ['__ABS_byMin5.0__bzMax0.0','__ABS_byMin5.0__bzMin0.0']
  ;; IMFCondStrArr        = '__ABS_byMin5.0__bzMax0.0'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;What type of averaging?
  dont_logAvg_inds     = [0,1,2,3]
  in_avgTypes             = 'avg'
  out_avgTypes            = 'avg'

  ;; logAvg_inds          = [0,1,2,3]
  ;; in_avgTypes          = 'avg'
  ;; out_avgTypes         = 'logAvg'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot on linear or log scale?
  dont_logPlot_inds    = [0,1,2,3]
  unlogPlot_lims       = [[0.0,0.6], $
                          [0.0,0.6], $
                          [0.0,1e8], $
                          [0.0,0.1]]

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
                    CLOCKSTR=clockStrArr[iClock], $
                    NDELAYS=nDelArr[iDel], $
                    DELAYDELTASEC=delayDeltaSec, $
                    IN_AVGTYPE=in_avgTypes[iAvgType], $
                    OUT_AVGTYPE=out_avgTypes[iAvgType], $
                    LOGAVG_THESE_INDS=logAvg_inds, $
                    DONT_LOGAVG_THESE_INDS=dont_logAvg_inds, $
                    DONT_LOGPLOT_THESE_INDS=dont_logPlot_inds, $
                    LIM_FOR_LOGPLOT_INDS=logPlot_lims, $
                    LIM_FOR_UNLOGPLOT_INDS=unlogPlot_lims, $
                    IMFCONDSTR=IMFCondStrArr[iCond], $
                    PLOT_DATESTR=plot_dateStr
              ENDFOR
           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR
  
END
