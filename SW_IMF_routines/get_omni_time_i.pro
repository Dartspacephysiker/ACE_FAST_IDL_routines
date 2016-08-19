FUNCTION GET_OMNI_TIME_I,mag_UTC, $
                         RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                         LUN=lun

  COMPILE_OPT idl2

  IF KEYWORD_SET(restrict_to_alfvendb_times) THEN BEGIN
     ;; maxTime                     = STR_TO_TIME('1999-11-03/03:21:00.000')

     PRINT,"OMNI: Only looking from Oct 1996 to May 1999!"
     maxTime                     = STR_TO_TIME('1999-05-16/00:00:00.0')
     ;; maxTime                  = STR_TO_TIME('2000-10-06/00:08:46.938')
     minTime                     = STR_TO_TIME('1996-10-06/16:26:02.0')
     time_i                      = WHERE(mag_UTC LE maxTime AND mag_UTC GE minTime, $
                                         /NULL,NCOMPLEMENT=nNotAlfvenDB)
     USE_COMBINED_INDS           = 1
     PRINTF,lun,"Losing " + STRCOMPRESS(nNotAlfvenDB,/REMOVE_ALL) + " OMNI entries because they don't happen during Alfven stuff"
  ENDIF ELSE BEGIN
     time_i              = INDGEN(N_ELEMENTS(mag_UTC),/LONG)
  ENDELSE

  RETURN,time_i
END