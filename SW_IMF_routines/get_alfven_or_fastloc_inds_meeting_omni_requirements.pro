FUNCTION GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS,dbTimes,db_i,delay, $
   CLOCKSTR=clockStr, $
   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
   ANGLELIM1=angleLim1, $
   ANGLELIM2=angleLim2, $
   MULTIPLE_DELAYS=multiple_delays, $
   RESOLUTION_DELAY=delay_res, $
   BINOFFSET_DELAY=binOffset_delay, $
   ;; MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
   STABLEIMF=stableIMF, $
   SMOOTH_IMF=smooth_IMF, $
   ;; RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
   EARLIEST_UTC=earliest_UTC, $
   LATEST_UTC=latest_UTC, $
   USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
   EARLIEST_JULDAY=earliest_julDay, $
   LATEST_JULDAY=latest_julDay, $
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
   BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
   BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
   RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
   RESET_OMNI_INDS=reset_omni_inds, $
   OMNI_COORDS=OMNI_coords, $
   OUT_OMNI_PARAMSTR=out_omni_paramStr, $
   PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
   PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
   SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
   CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
   LUN=lun
  
  COMPILE_OPT idl2

  @common__omni_stability.pro

  ;;First, get all the OMNI inds that qualify
  stable_OMNI_i       = GET_STABLE_IMF_INDS(MAG_UTC=mag_utc, $
                                            CLOCKSTR=clockStr, $
                                            DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                            ANGLELIM1=angleLim1, $
                                            ANGLELIM2=angleLim2, $
                                            STABLEIMF=stableIMF, $
                                            SMOOTH_IMF=smooth_IMF, $
                                            ;; RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                            EARLIEST_UTC=earliest_UTC, $
                                            LATEST_UTC=latest_UTC, $
                                            USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
                                            EARLIEST_JULDAY=earliest_julDay, $
                                            LATEST_JULDAY=latest_julDay, $
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
                                            BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
                                            BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
                                            RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                                            RESET_OMNI_INDS=reset_omni_inds, $
                                            OMNI_COORDS=OMNI_coords, $
                                            OMNI_PARAMSTR=omni_paramStr, $
                                            PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                                            PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                                            SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                                            CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                                            LUN=lun)
  
  
  ;;Handle delay stuff
  IF KEYWORD_SET(multiple_delays)           THEN NIter            = N_ELEMENTS(delay)    ELSE NIter = 1
  IF ~KEYWORD_SET(delay_res)                THEN delay_res        = 120
  IF N_ELEMENTS(binOffset_delay) EQ 0       THEN binOffset_delay  = 0 

  IF binOffset_delay GT delay_res/2. THEN BEGIN
     PRINT,'You know that your bin offset actually places the center of the delay bin outside the bin width, right?'
     STOP
  ENDIF

  qual_db_i_list         = LIST()
  FOR iDel=0,NIter-1 DO BEGIN
     ;;Now line up the databases (either fastLoc or maximus, as the case may be)
     aligned_db_ii       = VALUE_LOCATE(C_OMNI__mag_UTC[stable_omni_i]+delay[iDel],dbTimes[db_i])

     mag_utc_muffed      = C_OMNI__mag_UTC[stable_omni_i[aligned_db_ii]]+delay[iDel]
     mag_utc_muffedAft   = C_OMNI__mag_UTC[stable_omni_i[aligned_db_ii]+1]+delay[iDel]

     beforeTimes         = mag_utc_muffed-dbTimes[db_i]
     afterTimes          = mag_utc_muffedAft-dbTimes[db_i]

     ;; before_timeOK       = ABS(beforeTimes) LE 30
     ;; after_timeOK        = ABS(afterTimes) LE 30

     before_timeOK       = ABS(beforeTimes) LE ABS(delay_res/2.-binOffset_delay)
     after_timeOK        = ABS(afterTimes) LE ABS(delay_res/2.+binOffset_delay)

     ;;So which are the winners?
     qualifying_db_ii    = WHERE(before_timeOK OR after_timeOK)

     qualifying_db_i     = db_i[qualifying_db_ii]

     PRINT,FORMAT='("N qualifying db i for delay =",F10.2," min: ",I0)',delay[iDel]/60.,N_ELEMENTS(qualifying_db_i)

     qual_db_i_list.add,qualifying_db_i
  ENDFOR
     
  ;; IF ~KEYWORD_SET(multiple_delays) THEN qual_db_i_list = qual_db_i_list.ToArray

  out_omni_paramStr      = omni_paramStr

  RETURN,qual_db_i_list

END