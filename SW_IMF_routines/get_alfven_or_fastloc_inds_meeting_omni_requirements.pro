FUNCTION GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS,dbTimes,db_i,delay, $
   RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
   RESET_OMNI_INDS=reset_omni_inds, $
   ;; OMNI_COORDS=OMNI_coords, $
   OUT_OMNI_PARAMSTR=out_omni_paramStr, $
   PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
   PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
   PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
   SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
   MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
   OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
   CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
   LUN=lun, $
   TXTOUTPUTDIR=txtOutputDir
  
  COMPILE_OPT idl2,strictarrsubs

  @common__omni_stability.pro

  ;;First, get all the OMNI inds that qualify
  stable_OMNI_i       = GET_STABLE_IMF_INDS(MAG_UTC=mag_utc, $
                                            RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                            MIMC_STRUCT=MIMC_struct, $
                                            ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                            IMF_STRUCT=IMF_struct, $
                                            RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                                            RESET_OMNI_INDS=reset_omni_inds, $
                                            OMNI_PARAMSTR=omni_paramStr, $
                                            PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                                            PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                                            PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                                            SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                                            MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
                                            OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
                                            CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                                            LUN=lun, $
                                            TXTOUTPUTDIR=txtOutputDir)
  
  
  ;;Handle delay stuff
  IF KEYWORD_SET(alfDB_plot_struct.multiple_delays) THEN BEGIN
     NIter = N_ELEMENTS(IMF_struct.delay) 
  ENDIF ELSE BEGIN
     NIter = 1
  ENDELSE

  IF IMF_struct.binOffset_delay GT IMF_struct.delay_res/2. THEN BEGIN
     PRINT,'You know that your bin offset actually places the center of the delay bin outside the bin width, right?'
     STOP
  ENDIF

  qual_db_i_list         = LIST()
  FOR iDel=0,NIter-1 DO BEGIN

     ;;Going to try some new stuff 2017/05/29
     bro = 1
     IF bro THEN BEGIN

        qualifying_db_ii = !NULL
        allowable_gap    = 3

        GET_STREAKS,stable_OMNI_i, $
                    START_I=start_OMNI_ii, $
                    STOP_I=stop_OMNI_ii, $
                    OUT_STREAKLENS=streakLens, $
                    N_STREAKS=n_streaks, $
                    SINGLE_I=single_OMNI_ii;; , $
                    ;; ALLOWABLE_GAP=allowable_gap

        IF n_streaks GT 0 THEN BEGIN

           FOR k=0,n_streaks-1 DO BEGIN
              tmpStartT = C_OMNI__mag_UTC[stable_omni_i[start_OMNI_ii[k]]]+IMF_struct.delay[iDel]-C_OMNI__stableIMF*60.
              tmpStopT  = C_OMNI__mag_UTC[stable_omni_i[stop_OMNI_ii[k] ]]+IMF_struct.delay[iDel]

              IF tmpStartT GT tmpStopT THEN STOP

              qualifying_db_iiTmp = WHERE((dbTimes[db_i] GE tmpStartT) AND (dbTimes[db_i] LE tmpStopT),nQualify)
              
              IF nQualify GT 0 THEN BEGIN
                 qualifying_db_ii = [qualifying_db_ii,TEMPORARY(qualifying_db_iiTmp)]
              ENDIF

              PRINT,FORMAT='(I0,T10,A0,"-",A0," (",F07.1," min)",T80,I0)',k,TIME_TO_STR(tmpStartT),TIME_TO_STR(tmpStopT),(tmpStopT-tmpStartT)/60.,nQualify

           ENDFOR

           nQualify = N_ELEMENTS(qualifying_db_ii)

        ENDIF

     ENDIF ELSE BEGIN
        
        ;;Now line up the databases (either fastLoc or maximus, as the case may be)
        aligned_db_ii       = VALUE_LOCATE(C_OMNI__mag_UTC[stable_omni_i]+IMF_struct.delay[iDel],dbTimes[db_i])

        mag_utc_muffed      = C_OMNI__mag_UTC[stable_omni_i[aligned_db_ii]]+IMF_struct.delay[iDel]
        mag_utc_muffedAft   = C_OMNI__mag_UTC[stable_omni_i[aligned_db_ii]+1]+IMF_struct.delay[iDel]

        beforeTimes         = mag_utc_muffed-dbTimes[db_i]
        afterTimes          = mag_utc_muffedAft-dbTimes[db_i]

        ;; before_timeOK       = ABS(beforeTimes) LE 30
        ;; after_timeOK        = ABS(afterTimes) LE 30

        before_timeOK       = ABS(beforeTimes) LE ABS(IMF_struct.delay_res/2.-IMF_struct.binOffset_delay)
        after_timeOK        = ABS(afterTimes ) LE ABS(IMF_struct.delay_res/2.+IMF_struct.binOffset_delay)

        ;;So which are the winners?
        qualifying_db_ii    = WHERE(before_timeOK OR after_timeOK,nQualify)

     ENDELSE

     IF nQualify GT 0 THEN BEGIN
        qualifying_db_i     = db_i[qualifying_db_ii]
     ENDIF ELSE BEGIN
        qualifying_db_i     = !NULL
     ENDELSE
     
     PRINT,FORMAT='("N qualifying db i for delay =",F10.2," min: ",I0)',IMF_struct.delay[iDel]/60.,nQualify
     qual_db_i_list.add,qualifying_db_i
  ENDFOR
  
  ;; IF ~KEYWORD_SET(IMF_struct.multiple_delays) THEN qual_db_i_list = qual_db_i_list.ToArray

  out_OMNI_paramStr      = OMNI_paramStr

  RETURN,qual_db_i_list

END
