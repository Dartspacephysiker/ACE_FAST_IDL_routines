PRO GET_OMNI_IND_STREAKS,mag_utc,goodmag_goodtimes_i, $
                         RECALCULATE_OMNI_IND_STREAKS=recalculate, $
                         USE_COMBINED_OMNI_IMF_INDS=use_combined_OMNI_IMF_inds, $
                         LUN=lun
  
  COMPILE_OPT idl2

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
  
  
  IF ~KEYWORD_SET(C_OMNI__DONE_FIRST_STREAK_CALC) OR KEYWORD_SET(recalculate) THEN BEGIN

     IF KEYWORD_SET(use_combined_OMNI_IMF_inds) THEN BEGIN
        PRINTF,lun,"Getting streaks of OMNI IMF inds which involve the following params: "
        PRINTF,lun,C_OMNI__paramStr
        goodmag_goodtimes_i                       = CGSETINTERSECTION(goodmag_goodtimes_i,C_OMNI__combined_i)
     ENDIF

     ;;Check if it's sorted
     CHECK_SORTED,mag_utc,is_sorted
     IF ~is_sorted THEN BEGIN
        PRINTF,lun,"mag_utc isn't sorted!!!" 
        STOP
     ENDIF

     C_OMNI__StreakDurArr                         = MAKE_ARRAY(N_ELEMENTS(mag_utc),/LONG) 

     GET_STREAKS,goodmag_goodtimes_i, $
                 START_I=C_OMNI__streakstart_ii, $
                 STOP_I=C_OMNI__streakstop_ii, $
                 OUT_STREAKLENS=C_OMNI__streakLens, $
                 SINGLE_I=C_OMNI__single_i
     C_OMNI__streakstart_i                        = goodmag_goodtimes_i[C_OMNI__streakstart_ii]
     C_OMNI__streakstop_i                         = goodmag_goodtimes_i[C_OMNI__streakstop_ii]

     C_OMNI__nStreaks                             = N_ELEMENTS(C_OMNI__streakLens)
     C_OMNI__gapLengths                           = goodmag_goodtimes_i[C_OMNI__streakstart_ii[1:-1]]-goodmag_goodtimes_i[C_OMNI__streakstop_ii[0:-2]]

     FOR streakNum=0,C_OMNI__nStreaks-1 DO BEGIN
        curLen                                    = C_OMNI__streakLens[streakNum]+1
        curStart                                  = goodmag_goodtimes_i[C_OMNI__streakstart_ii[streakNum]]
        curStop                                   = goodmag_goodtimes_i[C_OMNI__streakstop_ii[streakNum]]
        C_OMNI__StreakDurArr[curStart:curStop]    = INDGEN(curLen)
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