;;2016/03/23 Too painful to keep doing all of this manually
PRO JOURNAL__20160323__SCRIPT__AVERAGE_OVER_DELAYS__ALL_CONDITIONS

  nDelArr        = [31,61]
  hemiArr        = ['NORTH','SOUTH']
  clockStrArr    = ['dawnward','duskward']

     FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
        FOR iClock=0,N_ELEMENTS(clockStrArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN
           JOURNAL__20160323__AVERAGE_OVER_DELAYS__EFLUX_IFLUX_PROBOCCURRENCE_PFLUX, $
              HEMI=hemiArr[iHemi], $
              CLOCKSTR=clockStrArr[iClock], $
              NDELAYS=nDelArr[iDel]
          ENDFOR
     ENDFOR
  ENDFOR

END
