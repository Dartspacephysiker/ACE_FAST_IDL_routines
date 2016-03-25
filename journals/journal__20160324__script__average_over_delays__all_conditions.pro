;;2016/03/23 Too painful to keep doing all of this manually
PRO JOURNAL__20160324__SCRIPT__AVERAGE_OVER_DELAYS__ALL_CONDITIONS

  nDelArr              = [31,61]
  hemiArr              = ['NORTH','SOUTH']
  clockStrArr          = ['dawnward','duskward']
  avgTypes             = ['logAvg', 'avg']
  IMFCondStrArr        = ['__ABS_byMin5.0__bzMax-1.0','__ABS_byMin5.0__bzMin1.0']

  FOR iCond=0,N_ELEMENTS(IMFCondStrArr)-1 DO BEGIN
     FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
        FOR iClock=0,N_ELEMENTS(clockStrArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN
              FOR iAvgType=0,N_ELEMENTS(avgTypes)-1 DO BEGIN
                 JOURNAL__20160324__AVERAGE_OVER_DELAYS__EFLUX_IFLUX_PROBOCCURRENCE_PFLUX, $
                    HEMI=hemiArr[iHemi], $
                    CLOCKSTR=clockStrArr[iClock], $
                    NDELAYS=nDelArr[iDel], $
                    AVGTYPE=avgTypes[iAvgType], $
                    IMFCONDSTR=IMFCondStrArr[iCond]
              ENDFOR
           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR
  
END
