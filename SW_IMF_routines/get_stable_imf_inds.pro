;;2016/02/18 This thing has to be overhauled. I don't know exactly what the old one was doing.
;; This function either creates or loads the properfile to get IMF stability
;; "Stable" is defined here as a period of time over which the specified conditions/params remain met
FUNCTION GET_STABLE_IMF_INDS, $
   MAG_UTC=mag_utc, $
   CLOCKSTR=clockStr, $
   ANGLELIM1=angleLim1, $
   ANGLELIM2=angleLim2, $
   STABLEIMF=stableIMF, $
   RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
   BYMIN=byMin, $
   BZMIN=bzMin, $
   BYMAX=byMax, $
   BZMAX=bzMax, $
   DO_ABS_BYMIN=abs_byMin, $
   DO_ABS_BYMAX=abs_byMax, $
   DO_ABS_BZMIN=abs_bzMin, $
   DO_ABS_BZMAX=abs_bzMax, $
   OMNI_COORDS=OMNI_coords, $
   LUN=lun
  
  ;; COMMON MAXIMUS,MAXIMUS,MAXIMUS__good_i,MAXIMUS__cleaned_i
  ;; COMMON FASTLOC,FASTLOC,FASTLOC__good_i,FASTLOC__cleaned_i

  ;;This and GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS should be the only two routines that have a full definition of this block
  COMMON OMNI_STABILITY,C_OMNI__mag_UTC, $
     C_OMNI__RECALCULATE, $
     C_OMNI__stable_i,C_OMNI__stableIMF,C_OMNI__HAVE_STABLE_INDS, $
     C_OMNI__magCoords, $
     C_OMNI__combined_i,C_OMNI__time_i, $
     C_OMNI__phiIMF_i,C_OMNI__negAngle,C_OMNI__posAngle,C_OMNI__clockStr, $
     C_OMNI__byMin_i,C_OMNI__byMin,C_OMNI__abs_byMin, $
     C_OMNI__byMax_i,C_OMNI__byMax,C_OMNI__abs_byMax, $
     C_OMNI__bzMin_i,C_OMNI__bzMin,C_OMNI__abs_bzMin, $
     C_OMNI__bzMax_i,C_OMNI__bzMax,C_OMNI__abs_bzMax, $
     C_OMNI__stableStr, $
     C_OMNI__paramStr, $
     C_OMNI__DONE_FIRST_STREAK_CALC,C_OMNI__StreakDurArr

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(C_OMNI__HAVE_STABLE_INDS) GT 0 THEN BEGIN
     IF ~C_OMNI__HAVE_STABLE_INDS THEN BEGIN
        calculate = 1 
     ENDIF ELSE BEGIN

        ;;Do we need to recalculate anyway?
        CHECK_FOR_NEW_OMNI_CONDS,MAG_UTC=mag_utc, $
                                 CLOCKSTR=clockStr, $
                                 ANGLELIM1=angleLim1, $
                                 ANGLELIM2=angleLim2, $
                                 STABLEIMF=stableIMF, $
                                 RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                 BYMIN=byMin, $
                                 BZMIN=bzMin, $
                                 BYMAX=byMax, $
                                 BZMAX=bzMax, $
                                 DO_ABS_BYMIN=abs_byMin, $
                                 DO_ABS_BYMAX=abs_byMax, $
                                 DO_ABS_BZMIN=abs_bzMin, $
                                 DO_ABS_BZMAX=abs_bzMax, $
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

     IF KEYWORD_SET(OMNI_coords) THEN BEGIN
        C_OMNI__magCoords                      = OMNI_coords 
     ENDIF ELSE BEGIN
        PRINTF,lun,'No OMNI coordinate type selected! Defaulting to GSE ...'
        C_OMNI__magCoords                      = 'GSE'
     ENDELSE

     CASE C_OMNI__magCoords OF 
        "GSE": BEGIN
           By                                  = By_GSE
           Bz                                  = Bz_GSE
           thetaCone                           = thetaCone_GSE
           phiClock                            = phiClock_GSE
        END
        "GSM": BEGIN
           By                                  = By_GSM
           Bz                                  = Bz_GSM
           thetaCone                           = thetaCone_GSM
           phiClock                            = phiClock_GSM
        END
        ELSE: BEGIN
           print,"Invalid/no coordinates chosen for OMNI data! Defaulting to GSE..."
           WAIT,1.0
           By                                  = By_GSE
           Bz                                  = Bz_GSE
           thetaCone                           = thetaCone_GSE
           phiClock                            = phiClock_GSE
        END
     ENDCASE
     thetaCone                                 = thetaCone*180/!PI
     phiClock                                  = phiClock*180/!PI

     IF KEYWORD_SET(restrict_to_alfvendb_times) THEN BEGIN
        maxTime                 = STR_TO_TIME('2000-10-06/00:08:46.938')
        minTime                 = STR_TO_TIME('1996-10-06/20:54:32.622')
        C_OMNI__time_i          = WHERE(mag_UTC LE maxTime AND mag_UTC GE minTime,/NULL,NCOMPLEMENT=nNotAlfvenDB)
        USE_COMBINED_INDS       = 1
        PRINTF,lun,"Losing " + STRCOMPRESS(nNotAlfvenDB,/REMOVE_ALL) + " OMNI entries because they don't happen during Alfven stuff"
     ENDIF ELSE BEGIN
        C_OMNI__time_i          = INDGEN(N_ELEMENTS(phiClock),/LONG)
     ENDELSE

     IF KEYWORD_SET(clockStr) THEN BEGIN
        SET_IMF_CLOCK_ANGLE,CLOCKSTR=clockStr,IN_ANGLE1=angleLim1,IN_ANGLE2=AngleLim2
        GET_IMF_CLOCKANGLE_INDS,phiClock, $
                                CLOCKSTR=clockStr, $
                                ANGLELIM1=angleLim1, $
                                ANGLELIM2=angleLim2, $
                                LUN=lun
        USE_COMBINED_INDS       = 1
     ENDIF

     IF N_ELEMENTS(byMin) GT 0 OR N_ELEMENTS(byMax) GT 0 OR N_ELEMENTS(bzMin) GT 0 OR N_ELEMENTS(bzMax) GT 0 THEN BEGIN
        GET_IMF_BY_BZ_LIM_INDS,By,Bz,byMin,byMax,bzMin,bzMax, $
                               DO_ABS_BYMIN=abs_byMin, $
                               DO_ABS_BYMAX=abs_byMax, $
                               DO_ABS_BZMIN=abs_bzMin, $
                               DO_ABS_BZMAX=abs_bzMax, $
                               LUN=lun
        USE_COMBINED_INDS       = 1
     END

     ;;Now combine all of these
     COMBINE_OMNI_IMF_INDS

     IF KEYWORD_SET(stableIMF) THEN BEGIN
        C_OMNI__stableIMF       = stableIMF
        C_OMNI__paramStr       += STRING(FORMAT='("--",I0,"_stable")',C_OMNI__stableIMF)

        GET_OMNI_IND_STREAKS,mag_utc,goodmag_goodtimes_i,USE_COMBINED_OMNI_IMF_INDS=USE_COMBINED_INDS ; Get streaks in the database first of all
        C_OMNI__stable_i        = WHERE(C_OMNI__StreakDurArr GE C_OMNI__stableIMF) ;This works because the gap between OMNI data is 1 minute

     ENDIF ELSE BEGIN
        GET_OMNI_IND_STREAKS,mag_utc,goodmag_goodtimes_i,USE_COMBINED_OMNI_IMF_INDS=USE_COMBINED_INDS ; Get streaks in the database first of all
        IF KEYWORD_SET(USE_COMBINED_INDS) THEN BEGIN
           ;; C_OMNI__stable_i        = INDGEN(N_ELEMENTS(C_OMNI__StreakDurArr))
           C_OMNI__stable_i        = INDGEN(N_ELEMENTS(C_OMNI__combined_i),/LONG)
        ENDIF ELSE BEGIN
           C_OMNI__stable_i        = INDGEN(N_ELEMENTS(mag_utc),/LONG)
           PRINTF,lun,"Wait, how did you get here? You have no restrictions whatsoever on IMF?"
        ENDELSE
     ENDELSE

     ;;******************************
     ;;Day may come when we only require stability of certain conditions
     ;;CODE HERE IF THAT DAY EVER COMES

     ;; IF KEYWORD_SET(stable_clockAngles) OR KEYWORD_SET(stable_IMF_By) OR KEYWORD_SET(stable_IMF_Bz) THEN BEGIN
     ;;    GET_OMNI_IND_STREAKS,mag_utc
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


     C_OMNI__mag_UTC           = mag_UTC
     C_OMNI__HAVE_STABLE_INDS  = 1

  ENDIF

  stable_OMNI_inds             = C_OMNI__stable_i
  mag_utc                      = C_OMNI__mag_utc

  PRINTF,lun,C_OMNI__paramStr

  RETURN,stable_OMNI_inds

END