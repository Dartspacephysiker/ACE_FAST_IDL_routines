FUNCTION GET_OMNI_TIME_I,mag_UTC, $
                         IMF_STRUCT=IMF_struct, $
                         LUN=lun

  COMPILE_OPT idl2

  CASE 1 OF
     ;; KEYWORD_SET(restrict_to_alfvendb_times): BEGIN
     ;;    ;; maxTime                     = STR_TO_TIME('1999-11-03/03:21:00.000')

     ;;    PRINT,"OMNI: Only looking from Oct 1996 to May 1999!"
     ;;    maxTime                     = STR_TO_TIME('1999-05-16/00:00:00.0')
     ;;    ;; maxTime                  = STR_TO_TIME('2000-10-06/00:08:46.938')
     ;;    minTime                     = STR_TO_TIME('1996-10-06/16:26:02.0')
     ;;    time_i                      = WHERE(mag_UTC LE maxTime AND mag_UTC GE minTime,n_time, $
     ;;                                        /NULL,NCOMPLEMENT=nNotAlfvenDB)
     ;;    USE_COMBINED_INDS           = 1
     ;;    PRINTF,lun,"Losing " + STRCOMPRESS(nNotAlfvenDB,/REMOVE_ALL) + $
     ;;           " OMNI entries because they don't happen during Alfven stuff"
     ;; END
     KEYWORD_SET(use_julDay_not_UTC): BEGIN
        n_time       = N_ELEMENTS(mag_UTC)
        time_i       = LINDGEN(N_ELEMENTS(mag_UTC))

        IF TAG_EXIST(IMF_struct,'earliest_julDay') THEN BEGIN
           early_i   = WHERE(UTC_TO_JULDAY(mag_UTC) GE IMF_struct.earliest_julDay,n_early)
           WHERECHECK,early_i

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early julDay",' + $
                                              'T30,":",T35,I0)',n_time-n_early

           time_i   = CGSETINTERSECTION(time_i,early_i,COUNT=n_time)
        ENDIF

        IF TAG_EXIST(IMF_struct,'latest_julDay') THEN BEGIN
           late_i   = WHERE(UTC_TO_JULDAY(mag_UTC) LE IMF_struct.latest_julDay,n_late)
           WHERECHECK,late_i

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest julDay",' + $
                                              'T30,":",T35,I0)',n_time-n_late

           time_i   = CGSETINTERSECTION(time_i,late_i,COUNT=n_time)
        ENDIF
     END
     ELSE: BEGIN
        n_time       = N_ELEMENTS(mag_UTC)
        time_i       = LINDGEN(N_ELEMENTS(mag_UTC))

        IF TAG_EXIST(IMF_struct,'earliest_UTC') THEN BEGIN
           early_i   = WHERE(mag_UTC GE IMF_struct.earliest_UTC,n_early)
           WHERECHECK,early_i

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early julDay",' + $
                                              'T30,":",T35,I0)',n_time-n_early

           time_i   = CGSETINTERSECTION(time_i,early_i,COUNT=n_time)
        ENDIF

        IF TAG_EXIST(IMF_struct,'latest_UTC') THEN BEGIN
           late_i    = WHERE(mag_UTC LE IMF_struct.latest_UTC,n_late)
           WHERECHECK,late_i

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest julDay",' + $
                                              'T30,":",T35,I0)',n_time-n_late

           time_i   = CGSETINTERSECTION(time_i,late_i,COUNT=n_time)
        ENDIF
     END
     ELSE: BEGIN
        time_i         = LINDGEN(N_ELEMENTS(mag_UTC))
     END
  ENDCASE

  RETURN,time_i
END