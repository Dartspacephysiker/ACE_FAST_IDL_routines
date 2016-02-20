FUNCTION GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS,dbTimes,db_i,delay, $
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
  
  ;;This and GET_STABLE_IMF_INDS should be the only two routines that have a full definition of this block
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

  ;;First, get all the OMNI inds that qualify
  stable_OMNI_i       = GET_STABLE_IMF_INDS(MAG_UTC=mag_utc, $
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
                                            LUN=lun)
  
  
  ;;Now line up the databases (either fastLoc or maximus, as the case may be)
  aligned_db_ii       = VALUE_LOCATE(C_OMNI__mag_UTC[stable_omni_i]+delay,dbTimes[db_i])

  mag_utc_muffed      = C_OMNI__mag_UTC[stable_omni_i[aligned_db_ii]]+delay
  mag_utc_muffedAft   = C_OMNI__mag_UTC[stable_omni_i[aligned_db_ii]+1]+delay

  beforeTimes         = mag_utc_muffed-dbTimes[db_i]
  afterTimes          = mag_utc_muffedAft-dbTimes[db_i]

  before_timeOK       = ABS(beforeTimes) LE 90
  after_timeOK        = ABS(afterTimes) LE 90

  ;;So which are the winners?
  qualifying_db_ii    = WHERE(before_timeOK OR after_timeOK)

  qualifying_db_i     = db_i[qualifying_db_ii]

  PRINT,"N qualifying db i: " + STRCOMPRESS(N_ELEMENTS(qualifying_db_i),/REMOVE_ALL)

  RETURN,qualifying_db_i

END