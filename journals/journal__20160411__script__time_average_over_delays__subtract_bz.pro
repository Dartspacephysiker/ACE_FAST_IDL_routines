;;2016/04/04
PRO JOURNAL__20160411__SCRIPT__TIME_AVERAGE_OVER_DELAYS__SUBTRACT_BZ,JUST_NORTH=just_north,JUST_SOUTH=just_south

  plot_dateStr                   = 'Apr_11_16'

  despun                         = 1
  maskMin                        = 10
  minAvgs_for_noMask             = 1

  IF ~KEYWORD_SET(just_north) THEN just_north = 0
  IF ~KEYWORD_SET(just_south) THEN just_south = 0

  do_subtract_file               = 1

  ;; nDelArr              = [121,241]
  ;; delayDeltaSec        = 15

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;delay stuff
  ;; totMinToDisplay                = 120

  totMinToDisplay                = 120
  delayDeltaSec                  = 1800
  delay_res                      = 1800
  binOffset_delay                = 0
  nDelArr                        = [1,3,5]

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
     KEYWORD_SET(just_north): hemiArr         = 'NORTH'
     KEYWORD_SET(just_south): hemiArr         = 'SOUTH'
     ELSE: hemiArr               = ['NORTH','SOUTH']
  ENDCASE                        
                                 
  clockStrArr                    = ['dawnward','duskward']
  IMFCondStrArr                  = '__ABS_byMin5.0__bzMax-5.0'
  IMFCondStrArr                  = '__ABS_byMin5.0__bzMax-3.0'
  ;; IMFCondStrArr                  = '__ABS_byMin5.0__bzMax-1.0'
                                 
  subtract__clockStrArr          = ['','']
  subtract__IMFCondStrArr        = '__bzMax-3.0'

  subtract__newDataLims          = [[-0.3,0.3], $
                                    [-0.5,0.5], $
                                    [-5e7,5e7], $
                                    [-0.05,0.05], $
                                    [-3000,0]]

  ;; subtract__newTitles            = ['Difference']
  subtract__newDataNameArr       = ['timeSpace_avg--subtract--EFLUX_LOSSCONE_INTEG', $
                                    'timeSpace_avg--subtract--LogpFlux', $
                                    'timeSpace_avg--subtract--Logiflux_INTEG_UP', $
                                    'timeSpace_avg--subtract--probOccurrence', $
                                    'subtract--nEvents']

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;What type of averaging?
  ;; dont_logAvg_inds     = [0,1,2,3]
  ;; in_avgTypes          = 'avg'
  ;; out_avgTypes         = 'avg'

  ;; logAvg_inds       = [0,1,2,3]
  ;; in_avgTypes       = 'avg'
  ;; out_avgTypes      = 'logAvg'

  ;; timeAvg_these_inds   = [0,1,2,3,4,5]
  timeAvg_these_inds             = [0,1,2,3,4]
  ;; in_avgTypes                       = 'logAvg'
  in_avgTypes                    = 'avg'
  out_avgTypes                   = 'timeAvg'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot on linear or log scale?
  ;; dont_logPlot_inds    = [0,1,2,3,4,5]
  dont_logPlot_inds              = [0,1,2,3,4]
  ;; dont_logPlot_inds    = [0,1,2,3]

  unlogPlot_lims                 = [[0.0,1.0], $
                                    [0.0,1.0], $
                                    [0.0,1e8], $
                                    [0.0,0.15], $
                                    [0.0,700]]


  H2D_AVERAGE_OVER_DELAYS, $
     IMFCONDSTRARR=IMFCondStrArr, $
     HEMIARR=hemiArr, $
     CLOCKSTRARR=clockStrArr, $
     NDELARR=nDelArr, $
     IN_AVGTYPES=in_avgTypes, $
     OUT_AVGTYPES=out_avgTypes, $
     DESPUN=despun, $
     MASKMIN=maskMin, $
     MINAVGS_FOR_NOMASK=minAvgs_for_noMask, $
     DELAYDELTASEC=delayDeltaSec, $
     RESOLUTION_DELAY=delay_res, $
     BINOFFSET_DELAY=binOffset_delay, $
     DELAY_START=delay_start, $
     DELAY_STOP=delay_stop, $
     LOGAVG_THESE_INDS=logAvg_inds, $
     TIMEAVG_THESE_INDS=timeAvg_these_inds, $   
     DONT_LOGAVG_THESE_INDS=dont_logAvg_inds, $
     LOGPLOT_THESE_INDS=logPlot_inds, $
     DONT_LOGPLOT_THESE_INDS=dont_logPlot_inds, $
     LIM_FOR_LOGPLOT_INDS=logPlot_lims, $
     LIM_FOR_UNLOGPLOT_INDS=unlogPlot_lims, $
     PLOT_DATESTR=plot_dateStr, $
     DO_SUBTRACT_FILE=do_subtract_file, $
     SUBTRACT__IMFCONDSTRARR=subtract__IMFCondStrArr, $
     SUBTRACT__CLOCKSTRARR=subtract__clockStrArr, $
     SUBTRACT__NEWDATANAMEARR=subtract__newDataNameArr, $
     SUBTRACT__NEWTITLES=subtract__newTitles, $
     SUBTRACT__NEWDATALIMS=subtract__newDataLims, $
     FILEDIR=fileDir
  
END

