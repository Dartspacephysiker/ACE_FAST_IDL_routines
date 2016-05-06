;;2016/02/18 This thing has to be overhauled. I don't know exactly what the old one was doing.
;; This function either creates or loads the properfile to get IMF stability
;; "Stable" is defined here as a period of time over which the specified conditions/params remain met
FUNCTION GET_STABLE_IMF_INDS, $
   MAG_UTC=mag_utc, $
   CLOCKSTR=clockStr, $
   ANGLELIM1=angleLim1, $
   ANGLELIM2=angleLim2, $
   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
   STABLEIMF=stableIMF, $
   SMOOTH_IMF=smooth_IMF, $
   RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
   BYMIN=byMin, $
   BYMAX=byMax, $
   BZMIN=bzMin, $
   BZMAX=bzMax, $
   BTMIN=btMin, $
   BTMAX=btMax, $
   BXMIN=bxMin, $
   BXMAX=bxMax, $
   DO_ABS_BYMIN=abs_byMin, $
   DO_ABS_BYMAX=abs_byMax, $
   DO_ABS_BZMIN=abs_bzMin, $
   DO_ABS_BZMAX=abs_bzMax, $
   DO_ABS_BTMIN=abs_btMin, $
   DO_ABS_BTMAX=abs_btMax, $
   DO_ABS_BXMIN=abs_bxMin, $
   DO_ABS_BXMAX=abs_bxMax, $
   RESET_OMNI_INDS=reset_omni_inds, $
   GET_BX=get_Bx, $
   GET_BY=get_By, $
   GET_BZ=get_Bz, $
   GET_BT=get_Bt, $
   GET_THETACONE=get_thetaCone, $
   GET_CLOCKANGLE=get_clockAngle, $
   GET_CONE_OVERCLOCK=get_cone_overClock, $
   GET_BXY_OVER_BZ=get_Bxy_over_Bz, $
   BX_OUT=bx_out,$
   BY_OUT=by_out,$
   BZ_OUT=bz_out,$
   BT_OUT=bt_out,$
   THETACONE_OUT=thetaCone_out, $
   CLOCKANGLE_OUT=clockAngle_out, $
   CONE_OVERCLOCK_OUT=cone_overClock_out, $
   BXY_OVER_BZ_OUT=Bxy_over_Bz_out, $
   OMNI_COORDS=OMNI_coords, $
   OMNI_PARAMSTR=omni_paramStr, $
   LUN=lun
  
  ;; COMMON MAXIMUS,MAXIMUS,MAXIMUS__good_i,MAXIMUS__cleaned_i
  ;; COMMON FASTLOC,FASTLOC,FASTLOC__good_i,FASTLOC__cleaned_i

  ;;This and GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS should be the only two routines that have a full definition of this block
  COMMON OMNI_STABILITY,C_OMNI__mag_UTC, $
     C_OMNI__Bx, $
     C_OMNI__By, $
     C_OMNI__Bz, $
     C_OMNI__Bt, $
     C_OMNI__thetaCone, $
     C_OMNI__phiClock, $
     C_OMNI__cone_overClock, $
     C_OMNI__Bxy_over_Bz, $
     C_OMNI__RECALCULATE, $
     C_OMNI__stable_i,C_OMNI__stableIMF,C_OMNI__HAVE_STABLE_INDS, $
     C_OMNI__magCoords, $
     C_OMNI__combined_i,C_OMNI__time_i, $
     C_OMNI__phiIMF_i,C_OMNI__negAngle,C_OMNI__posAngle,C_OMNI__clockStr, $
     C_OMNI__noClockAngles, $
     C_OMNI__treat_angles_like_bz_south, $
     C_OMNI__byMin_i,C_OMNI__byMin,C_OMNI__abs_byMin, $
     C_OMNI__byMax_i,C_OMNI__byMax,C_OMNI__abs_byMax, $
     C_OMNI__bzMin_i,C_OMNI__bzMin,C_OMNI__abs_bzMin, $
     C_OMNI__bzMax_i,C_OMNI__bzMax,C_OMNI__abs_bzMax, $
     C_OMNI__btMin_i,C_OMNI__btMin,C_OMNI__abs_btMin, $
     C_OMNI__btMax_i,C_OMNI__btMax,C_OMNI__abs_btMax, $
     C_OMNI__bxMin_i,C_OMNI__bxMin,C_OMNI__abs_bxMin, $
     C_OMNI__bxMax_i,C_OMNI__bxMax,C_OMNI__abs_bxMax, $
     C_OMNI__stableStr, $
     C_OMNI__paramStr, $
     C_OMNI__DONE_FIRST_STREAK_CALC,C_OMNI__StreakDurArr, $
     C_OMNI__is_smoothed, C_OMNI__smoothLen

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

        IF KEYWORD_SET(reset_omni_inds) THEN BEGIN
           PRINT,"Resetting OMNI inds..."
           RESET_OMNI_INDS
        ENDIF
  IF N_ELEMENTS(C_OMNI__HAVE_STABLE_INDS) GT 0 THEN BEGIN
     IF ~C_OMNI__HAVE_STABLE_INDS THEN BEGIN
        calculate = 1 
        C_OMNI__HAVE_STABLE_INDS = 0
        C_OMNI__STABLE_I         = !NULL
     ENDIF ELSE BEGIN

        ;;Do we need to recalculate anyway?
        CHECK_FOR_NEW_OMNI_CONDS,MAG_UTC=mag_utc, $
                                 CLOCKSTR=clockStr, $
                                 ANGLELIM1=angleLim1, $
                                 ANGLELIM2=angleLim2, $
                                 DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                 STABLEIMF=stableIMF, $
                                 RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                 BYMIN=byMin, $
                                 BYMAX=byMax, $
                                 BZMIN=bzMin, $
                                 BZMAX=bzMax, $
                                 BTMIN=btMin, $
                                 BTMAX=btMax, $
                                 BXMIN=bxMin, $
                                 BXMAX=bxMax, $
                                 DO_ABS_BYMIN=abs_byMin, $
                                 DO_ABS_BYMAX=abs_byMax, $
                                 DO_ABS_BZMIN=abs_bzMin, $
                                 DO_ABS_BZMAX=abs_bzMax, $
                                 DO_ABS_BTMIN=abs_btMin, $
                                 DO_ABS_BTMAX=abs_btMax, $
                                 DO_ABS_BXMIN=abs_bxMin, $
                                 DO_ABS_BXMAX=abs_bxMax, $
                                 OMNI_COORDS=OMNI_coords, $
                                 LUN=lun
                                    
        calculate = C_OMNI__RECALCULATE
        IF N_ELEMENTS(C_OMNI__stable_i) EQ 0 THEN BEGIN
           PRINTF,lun,"Impossible! You said this was calculated ..."
           STOP
        ENDIF
     ENDELSE
  ENDIF ELSE BEGIN
     calculate                                 = 1
  ENDELSE

  IF calculate THEN BEGIN
     printf,lun,"****BEGIN GET_STABLE_IMF_INDS****"
     PRINTF,lun,"Calculating stable IMF inds for this run..."
     C_OMNI__paramStr                          = 'OMNI_params'
     C_OMNI__stableStr                         = 'OMNI_stability'
     
     ;;********************************************************
     ;;Restore ACE/OMNI data
     ;; IF N_ELEMENTS(mag_utc) EQ 0 THEN BEGIN
     PRINTF,lun,'Restoring culled OMNI data to get mag_utc ...'
     dataDir                                = "/SPENCEdata/Research/Cusp/database/"
     restore,dataDir + "/processed/culled_OMNI_magdata.dat"
     ;; ENDIF

     C_OMNI__mag_UTC                           = TEMPORARY(mag_UTC)

     IF KEYWORD_SET(OMNI_coords) THEN BEGIN
        C_OMNI__magCoords                      = OMNI_coords 
     ENDIF ELSE BEGIN
        PRINTF,lun,'No OMNI coordinate type selected! Defaulting to GSE ...'
        C_OMNI__magCoords                      = 'GSE'
     ENDELSE

     ;;No need to pick up Bx with magcoords, since it's the same either way
     C_OMNI__Bx                                = TEMPORARY(Bx)
     CASE C_OMNI__magCoords OF 
        "GSE": BEGIN
           C_OMNI__By                          = TEMPORARY(By_GSE)
           C_OMNI__Bz                          = TEMPORARY(Bz_GSE)
           C_OMNI__Bt                          = TEMPORARY(Bt_GSE)
           C_OMNI__thetaCone                   = TEMPORARY(thetaCone_GSE)
           C_OMNI__phiClock                    = TEMPORARY(phiClock_GSE)
           C_OMNI__cone_overClock              = TEMPORARY(cone_overClock_GSE)
           C_OMNI__Bxy_over_Bz                 = TEMPORARY(Bxy_over_Bz_GSE)
        END
        "GSM": BEGIN
           C_OMNI__By                          = TEMPORARY(By_GSM)
           C_OMNI__Bz                          = TEMPORARY(Bz_GSM)
           C_OMNI__Bt                          = TEMPORARY(Bt_GSM)
           C_OMNI__thetaCone                   = TEMPORARY(thetaCone_GSM)
           C_OMNI__phiClock                    = TEMPORARY(phiClock_GSM)
           C_OMNI__cone_overClock              = TEMPORARY(cone_overClock_GSM)
           C_OMNI__Bxy_over_Bz                 = TEMPORARY(Bxy_over_Bz_GSM)
        END
        ELSE: BEGIN
           print,"Invalid/no coordinates chosen for OMNI data! Defaulting to GSM..."
           WAIT,1.0
           C_OMNI__By                          = TEMPORARY(By_GSM)
           C_OMNI__Bz                          = TEMPORARY(Bz_GSM)
           C_OMNI__Bt                          = TEMPORARY(Bt_GSM)
           C_OMNI__thetaCone                   = TEMPORARY(thetaCone_GSM)
           C_OMNI__phiClock                    = TEMPORARY(phiClock_GSM)
           C_OMNI__cone_overClock              = TEMPORARY(cone_overClock_GSM)
           C_OMNI__Bxy_over_Bz                 = TEMPORARY(Bxy_over_Bz_GSM)
        END
     ENDCASE
     C_OMNI__thetaCone                         = C_OMNI__thetaCone*180/!PI
     C_OMNI__phiClock                          = C_OMNI__phiClock*180/!PI

     ;;Any smoothing to be done?
     IF KEYWORD_SET(smooth_IMF) THEN BEGIN
        SMOOTH_OMNI_IMF,goodmag_goodtimes_i,smooth_IMF, $
                           BYMIN=byMin, $
                           BYMAX=byMax, $
                           BZMIN=bzMin, $
                           BZMAX=bzMax, $
                           BTMIN=btMin, $
                           BTMAX=btMax, $
                           BXMIN=bxMin, $
                           BXMAX=bxMax
     ENDIF

     IF KEYWORD_SET(restrict_to_alfvendb_times) THEN BEGIN
        maxTime                                = STR_TO_TIME('2000-10-06/00:08:46.938')
        minTime                                = STR_TO_TIME('1996-10-06/20:54:32.622')
        C_OMNI__time_i                         = WHERE(C_OMNI__mag_UTC LE maxTime AND C_OMNI__mag_UTC GE minTime,/NULL,NCOMPLEMENT=nNotAlfvenDB)
        USE_COMBINED_INDS                      = 1
        PRINTF,lun,"Losing " + STRCOMPRESS(nNotAlfvenDB,/REMOVE_ALL) + " OMNI entries because they don't happen during Alfven stuff"
     ENDIF ELSE BEGIN
        C_OMNI__time_i                         = INDGEN(N_ELEMENTS(C_OMNI__phiClock),/LONG)
     ENDELSE

     IF KEYWORD_SET(clockStr) THEN BEGIN
        SET_IMF_CLOCK_ANGLE,CLOCKSTR=clockStr,IN_ANGLE1=angleLim1,IN_ANGLE2=AngleLim2, $
                            DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles

        GET_IMF_CLOCKANGLE_INDS,C_OMNI__phiClock, $
                                CLOCKSTR=clockStr, $
                                ANGLELIM1=angleLim1, $
                                ANGLELIM2=angleLim2, $
                                LUN=lun
        USE_COMBINED_INDS                      = 1
     ENDIF

     IF N_ELEMENTS(byMin) GT 0 OR N_ELEMENTS(byMax) GT 0 $
        OR N_ELEMENTS(bzMin) GT 0 OR N_ELEMENTS(bzMax) GT 0 $
        OR N_ELEMENTS(btMin) GT 0 OR N_ELEMENTS(btMax) GT 0 $
        OR N_ELEMENTS(bxMin) GT 0 OR N_ELEMENTS(bxMax) GT 0 THEN BEGIN
        GET_IMF_BY_BZ_LIM_INDS,C_OMNI__By,C_OMNI__Bz,byMin,byMax,bzMin,bzMax,btMin,btMax,bxMin,bxMax, $
                               DO_ABS_BYMIN=abs_byMin, $
                               DO_ABS_BYMAX=abs_byMax, $
                               DO_ABS_BZMIN=abs_bzMin, $
                               DO_ABS_BZMAX=abs_bzMax, $
                               DO_ABS_BTMIN=abs_btMin, $
                               DO_ABS_BTMAX=abs_btMax, $
                               DO_ABS_BXMIN=abs_bxMin, $
                               DO_ABS_BXMAX=abs_bxMax, $
                               LUN=lun
        USE_COMBINED_INDS                      = 1
     END

     ;;Now combine all of these
     COMBINE_OMNI_IMF_INDS

     IF KEYWORD_SET(stableIMF) THEN BEGIN
        C_OMNI__stableIMF                      = stableIMF
        C_OMNI__paramStr                      += STRING(FORMAT='("--",I0,"_stable")',C_OMNI__stableIMF)

        GET_OMNI_IND_STREAKS,C_OMNI__mag_UTC,goodmag_goodtimes_i, $                        ; Get streaks in the database first of all
                             USE_COMBINED_OMNI_IMF_INDS=USE_COMBINED_INDS, $
                             RECALCULATE_OMNI_IND_STREAKS=calculate                
        C_OMNI__stable_i                       = WHERE(C_OMNI__StreakDurArr GE C_OMNI__stableIMF) ;This works because the gap between OMNI data is 1 minute

     ENDIF ELSE BEGIN
        GET_OMNI_IND_STREAKS,C_OMNI__mag_UTC,goodmag_goodtimes_i,USE_COMBINED_OMNI_IMF_INDS=USE_COMBINED_INDS ; Get streaks in the database first of all
        IF KEYWORD_SET(USE_COMBINED_INDS) THEN BEGIN
           ;; C_OMNI__stable_i        = INDGEN(N_ELEMENTS(C_OMNI__StreakDurArr))
           C_OMNI__stable_i                    = C_OMNI__combined_i
        ENDIF ELSE BEGIN
           C_OMNI__stable_i                    = INDGEN(N_ELEMENTS(C_OMNI__mag_UTC),/LONG)
           PRINTF,lun,"Wait, how did you get here? You have no restrictions whatsoever on IMF?"
           STOP
        ENDELSE
     ENDELSE

     ;;******************************
     ;;Day may come when we only require stability of certain conditions
     ;;CODE HERE IF THAT DAY EVER COMES

     ;; IF KEYWORD_SET(stable_clockAngles) OR KEYWORD_SET(stable_IMF_By) OR KEYWORD_SET(stable_IMF_Bz) THEN BEGIN
     ;;    GET_OMNI_IND_STREAKS,C_OMNI__mag_UTC
     ;; ENDIF

     ;; IF KEYWORD_SET(stable_clockAngles) THEN BEGIN
     ;;    C_OMNI__stableStr                           += STRING(FORMAT='("--stable_",A0,"--negAngle_",I0,"__posAngle_",I0,)', $
     ;;                                                          C_OMNI__clockStr,C_OMNI__negAngle,C_OMNI__posAngle)

     ;; ENDIF

     ;; IF KEYWORD_SET(stable_IMF_By) THEN BEGIN

     ;; ENDIF

     ;; IF KEYWORD_SET(stable_IMF_Bz) THEN BEGIN

     ;; ENDIF


     printf,lun,"****END text from GET_STABLE_IMF_INDS****"
     printf,lun,""


     C_OMNI__HAVE_STABLE_INDS  = 1

  ENDIF

  stable_OMNI_inds             = C_OMNI__stable_i
  mag_utc                      = C_OMNI__mag_utc

  PRINTF,lun,C_OMNI__paramStr

  omni_paramStr                = C_OMNI__paramStr

  IF KEYWORD_SET(get_Bx) THEN BEGIN
     Bx_out                    = C_OMNI__Bx
  ENDIF
  IF KEYWORD_SET(get_By) THEN BEGIN
     By_out                    = C_OMNI__By
  ENDIF
  IF KEYWORD_SET(get_Bz) THEN BEGIN
     Bz_out                    = C_OMNI__Bz
  ENDIF
  IF KEYWORD_SET(get_Bt) THEN BEGIN
     Bt_out                    = C_OMNI__Bt
  ENDIF
  IF KEYWORD_SET(get_thetaCone) THEN BEGIN
     thetaCone_out             = C_OMNI__thetaCone
  ENDIF
  IF KEYWORD_SET(get_clockAngle) THEN BEGIN
     clockAngle_out            = C_OMNI__phiClock
  ENDIF
  IF KEYWORD_SET(get_cone_overClock) THEN BEGIN
     cone_overClock_out        = C_OMNI__cone_overClock
  ENDIF
  IF KEYWORD_SET(get_Bxy_Over_Bz) THEN BEGIN
     Bxy_over_Bz_out           = C_OMNI__Bxy_over_Bz
  ENDIF
  RETURN,stable_OMNI_inds

END