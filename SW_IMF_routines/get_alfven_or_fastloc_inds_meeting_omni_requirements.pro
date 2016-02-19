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
  
  ;; COMMON OMNI_STABILITY

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
  
  
  mag_utc_muffed      = mag_utc[stable_omni_i]+delay
  
  ;;Now line up the databases (either fastLoc or maximus, as the case may be)
  aligned_db_ii       = VALUE_LOCATE((mag_utc_muffed),dbTimes[db_i])

  beforetimes         = mag_utc[stable_omni_i[aligned_db_ii]]+delay-dbTimes[db_i]
  aftertimes          = mag_utc[stable_omni_i[aligned_db_ii+1]]+delay

  before_timeOK       = ABS(mag_utc[stable_omni_i[aligned_db_ii]]+delay-dbTimes[db_i]) LE 90
  after_timeOK        = ABS(mag_utc[stable_omni_i[aligned_db_ii+1]]+delay-dbTimes[db_i]) LE 90

  ;;So which are the winners?
  qualifying_db_i     = WHERE(before_timeOK OR after_timeOK)

  PRINT,"N qualifying db i: " + STRCOMPRESS(N_ELEMENTS(qualifying_db_i),/REMOVE_ALL)

  RETURN,qualifying_db_i

END