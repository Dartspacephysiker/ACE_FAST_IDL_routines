;;2016/07/02 Trying to make a column for Table 1 in this Alfvén IMF paper that shows stuff
PRO JOURNAL__20160702__HOW_LONG_DID_WE_HAVE_OMNI_OBS_IN_TOTAL__PRE_NOV_1999__ALFIMFPAPE

  ;;restore OMNI db with good mag data
  dataDir   = '/SPENCEdata/Research/database/OMNI/'
  RESTORE,dataDir + "culled_OMNI_magdata.dat"

  ;;Start and stop times for despun DB before orbit 12670
  ;;Start time: 1996-10-06/16:26:02.417
  ;;Stop time: 1999-11-03/03:20:59.853

  t1 = STR_TO_TIME('1996-10-06/16:26:02.417')
  t2 = STR_TO_TIME('1999-11-03/03:20:59.853')

  
  ;; minForEach   = [161350.0, $ ;Northward
  ;;                 179305.0, $ ;Southward
  ;;                 211311.0, $ ;Dawn-north
  ;;                 242538.0, $ ;Dawn-south
  ;;                 298855.0, $ ;Dawnward
  ;;                 244958.0, $ ;Dusk-north
  ;;                 260000.0, $ ;Dusk-south
  ;;                 344111.0]   ;Duskward

  ;;Without limit on B_T
  ;; minForEach   = [120070.0, $ ;Northward
  ;;                 136524.0, $ ;Southward
  ;;                 160952.0, $ ;Dawn-north
  ;;                 189128.0, $ ;Dawn-south
  ;;                 235341.0, $ ;Dawnward
  ;;                 186372.0, $ ;Dusk-north
  ;;                 201421.0, $ ;Dusk-south
  ;;                 266960.0]   ;Duskward

  minForEach   = [42368.0, $ ;Northward
                  51384.0, $ ;Southward
                  61712.0, $ ;Dawn-north
                  76356.0, $ ;Dawn-south
                  95737.0, $   ;Dawnward
                  70568.0, $ ;Dusk-north
                  77990.0, $ ;Dusk-south
                  106156.0]   ;Duskward

  names        = ['Northward', $
                  'Southward', $
                  'Dawn-north', $
                  'Dawn-south', $
                  'Dawnward', $
                  'Dusk-north', $
                  'Dusk-south', $
                  'Duskward']


  ;;Get the number of minutes total in this period
  used_i    = WHERE((mag_utc GE t1) AND (mag_utc LE t2),nUsed)

  total     = 0.0
  FOR k=0,7 DO BEGIN
     tmpNum = minForEach[k]/nUsed
     PRINT,FORMAT='(A0,T20,F0.5)',names[k],tmpNum
     total += tmpNum
  ENDFOR
  PRINT,'Total : ',total

  HELP,UNIQ(diff,SORT(diff))
  ;;Just one element!
END

