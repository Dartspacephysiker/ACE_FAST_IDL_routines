;2017/07/31
PRO JOURNAL__20170731__HOW_MANY_BAD_DAYS_IN_OMNI

  COMPILE_OPT IDL2,STRICTARRSUBS

  dataDir              = '/SPENCEdata/Research/database/'

  ;;db in memory
  RESTORE,dataDir+'OMNI/sw_data.dat'

  mag_utc              = (sw_data.epoch.dat-62167219200000.0000D)/1000.0D
  earliest_UTC         = STR_TO_TIME('1996-10-01/00:00:00.0')
  latest_UTC           = STR_TO_TIME('1999-11-30/23:23:59.853')

  ;;all right, cull 'em
  ;;times
  goodtimes_i          = WHERE(ABS(sw_data.time_btwn_obs.dat) LE 10000)

  ;;mag vals
  goodmagvals_i        = WHERE((ABS(sw_data.bx_gse.dat) LE 99.9) AND (ABS(sw_data.by_gsm.dat) LE 99.9) AND $
                               (ABS(sw_data.bz_gsm.dat) LE 99.9) AND (ABS(sw_data.by_gse.dat) LE 99.9) AND $
                               (ABS(sw_data.bz_gse.dat) LE 99.9))

  goodmag_goodtimes_i  = CGSETINTERSECTION(TEMPORARY(goodmagvals_i),TEMPORARY(goodtimes_i))

  this                 = WHERE((mag_utc GE earliest_UTC) AND $
                               (mag_utc LE latest_UTC),nThis)
  thisGood             = WHERE((mag_utc[goodmag_goodtimes_i] GE earliest_UTC) AND $
                               (mag_utc[goodmag_goodtimes_i] LE latest_UTC),nThisGood)
  PRINT,nThis
  PRINT,nThisGood
  
  STOP

END
