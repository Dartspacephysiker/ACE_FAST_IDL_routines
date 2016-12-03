PRO SMOOTH_OMNI_IMF,goodmag_goodtimes_i, $
                    IMF_STRUCT=IMF_struct;, $
                    ;; smooth_IMF, $
                    ;;        BYMIN=byMin, $
                    ;;        BYMAX=byMax, $
                    ;;        BZMIN=bzMin, $
                    ;;        BZMAX=bzMax, $
                    ;;        BTMIN=btMin, $
                    ;;        BTMAX=btMax, $
                    ;;        BXMIN=bxMin, $
                    ;;        BXMAX=bxMax                    

  @common__omni_stability.pro
  ;; COMMON OMNI_STABILITY

  ;;max gap to allow for smoothing
  def_maxSmoothGap           = 3
  def_minStreakForSmooth     = 15 ;30 min

  C_OMNI__smoothLen          = IMF_struct.smooth_IMF

  IF ~KEYWORD_SET(C_OMNI__is_smoothed) OR KEYWORD_SET(C_OMNI__RECALCULATE) THEN BEGIN

     ;;First,get gaps in data
     ;;NOTE! goodmag_goodtimes_i is an array that is the same size as C_OMNI__B{y,z,x}, so we use level II indices for the C_OMNI__
     ;;quantities instead of the level I indices
     GET_STREAKS,goodmag_goodtimes_i, $
                 START_I=C_OMNI__streakstart_ii, $
                 STOP_I=C_OMNI__streakstop_ii, $
                 OUT_STREAKLENS=C_OMNI__streakLens, $
                 SINGLE_I=C_OMNI__single_i
     goodStreaks_iii         = WHERE(C_OMNI__streakLens GE def_minStreakForSmooth)

     C_OMNI__streakLens      = C_OMNI__streakLens[goodStreaks_iii]
     C_OMNI__nStreaks        = N_ELEMENTS(C_OMNI__streakLens)
     C_OMNI__streakstart_ii  = C_OMNI__streakstart_ii[goodStreaks_iii]
     C_OMNI__streakstop_ii   = C_OMNI__streakstop_ii[goodStreaks_iii]
     
     PRINT,"Number of good streaks for smoothing: " + STRCOMPRESS(N_ELEMENTS(C_OMNI__streakLens),/REMOVE_ALL)

     ;; C_OMNI__streakstart_i            = goodmag_goodtimes_i[C_OMNI__streakstart_ii]
     ;; C_OMNI__streakstop_i             = goodmag_goodtimes_i[C_OMNI__streakstop_ii]
     
     FOR streakNum=0,C_OMNI__nStreaks-1 DO BEGIN
        curLen                           = C_OMNI__streakLens[streakNum]+1
        ;; curStart                      = goodmag_goodtimes_i[C_OMNI__streakstart_ii[streakNum]]
        ;; curStop                       = goodmag_goodtimes_i[C_OMNI__streakstop_ii[streakNum]]
        curStart                         = C_OMNI__streakstart_ii[streakNum]
        curStop                          = C_OMNI__streakstop_ii[streakNum]
        IF TAG_EXIST(IMF_struct,'byMin') OR TAG_EXIST(IMF_struct,'byMax') THEN BEGIN 
           C_OMNI__By[curStart:curStop]  = SMOOTH(C_OMNI__By[curStart:curStop],smooth_IMF, $
                                                  /EDGE_TRUNCATE)
        ENDIF
        IF TAG_EXIST(IMF_struct,'bzMin') OR TAG_EXIST(IMF_struct,'bzMax') THEN BEGIN 
           C_OMNI__Bz[curStart:curStop]  = SMOOTH(C_OMNI__Bz[curStart:curStop],smooth_IMF, $
                                                  /EDGE_TRUNCATE)
        ENDIF
        IF TAG_EXIST(IMF_struct,'btMin') OR TAG_EXIST(IMF_struct,'btMax') THEN BEGIN 
           C_OMNI__Bt[curStart:curStop]  = SMOOTH(C_OMNI__Bt[curStart:curStop],smooth_IMF, $
                                                  /EDGE_TRUNCATE)
        ENDIF
        IF TAG_EXIST(IMF_struct,'bxMin') OR TAG_EXIST(IMF_struct,'bxMax') THEN BEGIN 
           C_OMNI__Bx[curStart:curStop]  = SMOOTH(C_OMNI__Bx[curStart:curStop],smooth_IMF, $
                                                  /EDGE_TRUNCATE)
        ENDIF
        ;; C_OMNI__StreakDurArr[curStart:curStop] = INDGEN(curLen)
     ENDFOR
     
     ;;Need to recalculate clock stuff
     C_OMNI__phiClock        = ATAN(C_OMNI__By,C_OMNI__Bz)*180/!PI
     C_OMNI__thetaCone       = ACOS(ABS(C_OMNI__Bx) / $
                                     SQRT(C_OMNI__Bx*C_OMNI__Bx+ $
                                          C_OMNI__By*C_OMNI__By+ $
                                          C_OMNI__Bz*C_OMNI__Bz))*180/!PI
     C_OMNI__Bxy_over_Bz     = SQRT(C_OMNI__Bx*C_OMNI__Bx+C_OMNI__By*C_OMNI__By)/ABS(C_OMNI__Bz)
     C_OMNI__cone_overClock  = C_OMNI__thetaCone/C_OMNI__phiClock

     C_OMNI__is_smoothed     = 1

  ENDIF

END