PRO GET_OMNI_IND_STREAKS,mag_utc,goodmag_goodtimes_i, $
                         RECALCULATE_OMNI_IND_STREAKS=recalculate, $
                         USE_COMBINED_OMNI_IMF_INDS=use_combined_OMNI_IMF_inds, $
                         LUN=lun
  
  COMPILE_OPT idl2,strictarrsubs

  ;;Vars for OMNI stability
  @common__omni_stability.pro
  ;; COMMON OMNI_STABILITY

  IF N_ELEMENTS(lun) EQ 0 THEN lun             = -1

  ;; SAVE_IF_RECALC_SET                           = 1

  ;; outDir                                       = '/SPENCEdata/Research/database/sw_omnidata/'
  ;; outFile                                      = 'OMNI_ind_streaks.dat'

  ;; IF N_ELEMENTS(C_OMNI__StreakDurArr) EQ 0 OR KEYWORD_SET(recalculate) THEN BEGIN
  ;;    IF KEYWORD_SET(recalculate) THEN BEGIN
  ;;       PRINTF,lun,'Recalculating time streaks in OMNI DB ...'
  ;;       ;; saveStreakFile                         = SAVE_IF_RECALC_SET
  ;;    ENDIF ELSE BEGIN
  ;;       IF FILE_TEST(outDir+outFile) THEN BEGIN
  ;;          RESTORE,outDir+outFile

  ;;          IF N_ELEMENTS(C_OMNI__StreakDurArr) EQ 0 THEN BEGIN
  ;;             PRINTF,lun,"This OMNI timestreaks file has no C_OMNI__StreakDurArr!"
  ;;             STOP
  ;;          ENDIF 

  ;;          IF N_ELEMENTS(C_OMNI__StreakDurArr) GT N_ELEMENTS(mag_utc) OR C_OMNI__StreakDurArr[-1] GE N_ELEMENTS(mag_utc) THEN BEGIN
  ;;             PRINTF,lun,"C_OMNI__StreakDurArr is incompatible with mag_utc! C_OMNI__StreakDurArr refers to nonexistent mag_utc data ..."
  ;;             STOP
  ;;          ENDIF

  ;;          RETURN
  ;;       ENDIF ELSE BEGIN
  ;;          saveStreakFile                      = 1
  ;;       ENDELSE
  ;;    ENDELSE
  ;; ENDIF
  
  
  IF (~KEYWORD_SET(C_OMNI__DONE_FIRST_STREAK_CALC) OR KEYWORD_SET(recalculate)) THEN BEGIN


     C_OMNI__StreakDurArr    = MAKE_ARRAY(MAX(goodmag_goodtimes_i)+1,/LONG) 

     IF KEYWORD_SET(use_combined_OMNI_IMF_inds) THEN BEGIN
        PRINTF,lun,"Getting streaks of OMNI IMF inds which involve the following params: "
        PRINTF,lun,C_OMNI__paramStr
        ;; goodmag_goodtimes_i   = CGSETINTERSECTION(goodmag_goodtimes_i,C_OMNI__combined_i)
        ;; goodmag_combined_i   = CGSETINTERSECTION(goodmag_goodtimes_i,C_OMNI__combined_i)
     ENDIF ELSE BEGIN
        STOP
     ENDELSE

     ;;Check if it's sorted
     CHECK_SORTED,mag_utc,is_sorted,/QUIET
     IF ~is_sorted THEN BEGIN
        PRINTF,lun,"mag_utc isn't sorted!!!" 
        STOP
     ENDIF

     ;; C_OMNI__StreakDurArr  = MAKE_ARRAY(N_ELEMENTS(mag_utc),/LONG) 

     GET_STREAKS,goodmag_goodtimes_i[C_OMNI__combined_i], $
                 START_I=C_OMNI__TOTDB_streakstart_ii, $
                 STOP_I=C_OMNI__TOTDB_streakstop_ii, $
                 N_STREAKS=n_streaks, $
                 OUT_STREAKLENS=C_OMNI__streakLens, $
                 SINGLE_I=C_OMNI__single_i;; , $
                 ;; ALLOWABLE_GAP=FIX(C_OMNI__allowable_gap/60.)
     ;; C_OMNI__streakstart_i    = goodmag_goodtimes_i[C_OMNI__streakstart_ii]
     ;; C_OMNI__streakstop_i     = goodmag_goodtimes_i[C_OMNI__streakstop_ii]
     C_OMNI__TOTDB_streakstart_i    = goodmag_goodtimes_i[C_OMNI__combined_i[C_OMNI__TOTDB_streakstart_ii]]
     C_OMNI__TOTDB_streakstop_i     = goodmag_goodtimes_i[C_OMNI__combined_i[C_OMNI__TOTDB_streakstop_ii]]
     C_OMNI__nStreaks               = N_ELEMENTS(C_OMNI__streakLens)
     C_OMNI__gapLengths             = goodmag_goodtimes_i[C_OMNI__combined_i[C_OMNI__TOTDB_streakstart_ii[1:-1]]] - $
                                      goodmag_goodtimes_i[C_OMNI__combined_i[C_OMNI__TOTDB_streakstop_ii[0:-2]]]

     IF (C_OMNI__nStreaks GT 0) AND C_OMNI__allowable_gap GT 0. THEN BEGIN

        allowable_gap = FIX(C_OMNI__allowable_gap/60.)
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'Allowable gap between start and stop: ' + STRCOMPRESS(allowable_gap,/REMOVE_ALL)

        stitchTheseGaps_ii = WHERE(C_OMNI__gapLengths LE allowable_gap,nGapsToStitch)
        IF nGapsToStitch GT 0 THEN BEGIN

           start_i   = TEMPORARY(C_OMNI__TOTDB_streakstart_i)
           stop_i    = TEMPORARY(C_OMNI__TOTDB_streakstop_i)

           streakInd = 1
           nStreaks  = N_ELEMENTS(start_i)

           newStart_i = start_i[0]
           newStop_i  = stop_i[0]
           newNStreaks = 1
           WHILE streakInd LT nStreaks DO BEGIN
              
              ;; tmpStop_i     = stop_i[streakInd-1]
              ;;Check the start_i ahead of where we are, see if it is within allowable_gap of the last stop_i
              keepStreaking = (start_i[streakInd] - stop_i[streakInd-1]) LE allowable_gap
              IF keepStreaking THEN BEGIN
                 ;;If the start_i ahead of current position is within allowable gap, just adjust newStop_i
                 newStop_i[-1] = stop_i[streakInd]
              ENDIF ELSE BEGIN
                 ;;In this case we need to add a new start_i and a new stop_i since the gap was too large
                 newStart_i    = [newStart_i,start_i[streakInd]]
                 newStop_i     = [newStop_i,stop_i[streakInd]]
                 ;; tmpStart_i    = start_i[streakInd]
                 newNStreaks++
              ENDELSE

              streakInd++
              
           ENDWHILE



           start_i = TEMPORARY(newStart_i)
           stop_i  = TEMPORARY(newStop_i)

           C_OMNI__TOTDB_streakstart_i = TEMPORARY(start_i)
           C_OMNI__TOTDB_streakstop_i  = TEMPORARY(stop_i)

           C_OMNI__streakLens          = C_OMNI__TOTDB_streakstop_i-C_OMNI__TOTDB_streakstart_i
           C_OMNI__nStreaks            = N_ELEMENTS(C_OMNI__streakLens)
           C_OMNI__gapLengths          = C_OMNI__TOTDB_streakstart_i[1:-1] - C_OMNI__TOTDB_streakstop_i[0:-2]

        ENDIF ELSE BEGIN

        ENDELSE

     ENDIF

     FOR streakNum=0,C_OMNI__nStreaks-1 DO BEGIN
        curLen             = C_OMNI__streakLens[streakNum]+1
        ;; curStart           = goodmag_goodtimes_i[C_OMNI__combined_i[C_OMNI__TOTDB_streakstart_ii[streakNum]]]
        ;; curStop            = goodmag_goodtimes_i[C_OMNI__combined_i[C_OMNI__TOTDB_streakstop_ii[streakNum]]]
        curStart           = C_OMNI__TOTDB_streakstart_i[streakNum]
        curStop            = C_OMNI__TOTDB_streakstop_i[streakNum]
        ;; curStart              = C_OMNI__streakstart_ii[streakNum]
        ;; curStop               = C_OMNI__streakstop_ii[streakNum]
        C_OMNI__StreakDurArr[curStart:curStop]  = INDGEN(curLen)
     ENDFOR
     
     ;; IF KEYWORD_SET(saveStreakFile) THEN BEGIN
     ;;    PRINT,'Saving OMNI streak file to ' + outDir + outFile + '...'
     ;;    save,C_OMNI__StreakDurArr,C_OMNI__streakstart_ii,C_OMNI__streakstop_ii,C_OMNI__streakLens, $
     ;;         C_OMNI__single_i,C_OMNI__gapLengths,C_OMNI__nStreaks, $
     ;;         FILENAME=outDir+outFile
     ;; ENDIF

     C_OMNI__DONE_FIRST_STREAK_CALC               = 1

  ENDIF

END
