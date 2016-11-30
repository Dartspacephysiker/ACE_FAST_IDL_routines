;2015/12/31 Added RESTRICT_WITH_THESE_I keyword so that I can do non-storm 
;2016/01/07 Added DO_DESPUNDB keyword
;2016/02/10 Added DO_NOT_CONSIDER_IMF keyword
;2016/02/20 Making restricted_and_interped_i a LIST!
FUNCTION GET_RESTRICTED_AND_INTERPED_DB_INDICES,dbStruct,satellite,delay, $
   LUN=lun, $
   DBTIMES=dbTimes, $
   DBFILE=dbfile, $
   DO_CHASTDB=do_chastdb, $
   DO_DESPUNDB=do_despunDB, $
   COORDINATE_SYSTEM=coordinate_system, $
   USE_AACGM_COORDS=use_aacgm, $
   USE_MAG_COORDS=use_mag, $
   HEMI=hemi, $
   ORBRANGE=orbRange, $
   ALTITUDERANGE=altitudeRange, $
   CHARERANGE=charERange, $
   CHARIERANGE=charIERange, $ ;Only for non-Alfvén ions
   POYNTRANGE=poyntRange, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   INCLUDE_32HZ=include_32Hz, $
   DISREGARD_SAMPLE_T=disregard_sample_t, $
   DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
   DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
   MINMLT=minM, $
   MAXMLT=maxM, $
   BINM=binM, $
   SHIFTM=shiftM, $
   MINILAT=minI, $
   MAXILAT=maxI, $
   BINI=binI, $
   EQUAL_AREA_BINNING=equal_area_binning, $
   DO_LSHELL=do_lshell, $
   MINLSHELL=minL, $
   MAXLSHELL=maxL, $
   BINL=binL, $
   MIN_MAGCURRENT=minMC, $
   MAX_NEGMAGCURRENT=maxNegMC, $
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
   RESET_OMNI_INDS=reset_omni_inds, $
   CLOCKSTR=clockStr, $
   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
   ANGLELIM1=angleLim1, $
   ANGLELIM2=angleLim2, $
   DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
   BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
   STABLEIMF=stableIMF, $
   SMOOTH_IMF=smooth_IMF, $
   MULTIPLE_DELAYS=multiple_delays, $
   RESOLUTION_DELAY=delay_res, $
   BINOFFSET_DELAY=binOffset_delay, $
   MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
   OMNI_COORDS=omni_Coords, $
   OUT_OMNI_PARAMSTR=out_omni_paramStr, $
   HWMAUROVAL=HwMAurOval, $
   HWMKPIND=HwMKpInd, $
   PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
   PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
   PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
   SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
   MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
   OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
   CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
   RESET_GOOD_INDS=reset_good_inds, $
   NO_BURSTDATA=no_burstData, $
   GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i, $
   FOR_ESPEC_OR_ION_DB=for_eSpec_or_ion_db, $
   ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
   ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
   ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
   RESTRICT_WITH_THESE_I=restrict_with_these_i, $
   RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
   DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
   GET_TIME_FOR_ESPEC_DBS=for_eSpec_DBs, $   ;NOTE: DON'T CONFUSE THIS WITH FOR_ESPEC_OR_ION_DB
   EARLIEST_UTC=earliest_UTC, $
   LATEST_UTC=latest_UTC, $
   USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
   EARLIEST_JULDAY=earliest_julDay, $
   LATEST_JULDAY=latest_julDay, $
   DONT_LOAD_IN_MEMORY=nonMem, $
   TXTOUTPUTDIR=txtOutputDir

  
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN BEGIN
     lun                                = -1 ;stdout
  ENDIF

  IF KEYWORD_SET(for_eSpec_or_ion_db) THEN BEGIN
     
     PRINT,'Getting eSpec/ion DB indices for specified IMF conditions ...'

     good_i  = GET_ESPEC_ION_DB_IND(dbStruct,lun, $
                                    FOR_ALFVEN_DB=for_alfven_db, $
                                    ;; COORDINATE_SYSTEM=coordinate_system, $
                                    ;; USE_AACGM_COORDS=use_aacgm, $
                                    ;; USE_MAG_COORDS=use_mag, $
                                    ;; DBFILE=dbfile, $
                                    ;; DBDIR=dbDir, $
                                    ORBRANGE=orbRange, $
                                    ALTITUDERANGE=altitudeRange, $
                                    CHARERANGE=charERange, $
                                    CHARIERANGE=charIERange, $
                                    BOTH_HEMIS=both_hemis, $
                                    HEMI=hemi, $
                                    HWMAUROVAL=HwMAurOval, $
                                    HWMKPIND=HwMKpInd, $
                                    MINMLT=minM, $
                                    MAXMLT=maxM, $
                                    BINM=binM, $
                                    MINILAT=minI, $
                                    MAXILAT=maxI, $
                                    BINILAT=binI, $
                                    EQUAL_AREA_BINNING=equal_area_binning, $
                                    ;; DO_LSHELL=do_lshell, $
                                    ;; MINLSHELL=minL, $
                                    ;; MAXLSHELL=maxL, $
                                    ;; BINLSHELL=binL, $
                                    ;; DAYSIDE=dayside, $
                                    ;; NIGHTSIDE=nightside, $
                                    ;; /GET_ESPEC_I_NOT_ION_I, $
                                    ;; GET_ION_I=get_ion_i, $
                                    RESET_GOOD_INDS=reset_good_inds, $
                                    DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                    ;; /DONT_LOAD_IN_MEMORY, $
                                    DONT_LOAD_IN_MEMORY=nonMem, $
                                    ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
                                    ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
                                    ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
                                    /PRINT_PARAM_SUMMARY)
     
  ENDIF ELSE BEGIN
     good_i  = GET_CHASTON_IND(dbStruct,satellite,lun, $
                               DBTIMES=dbTimes, $
                               DBFILE=dbfile, $
                               CHASTDB=do_chastdb, $
                               HEMI=hemi, $
                               DESPUNDB=do_despunDB, $
                               COORDINATE_SYSTEM=coordinate_system, $
                               USE_AACGM_COORDS=use_aacgm, $
                               USE_MAG_COORDS=use_mag, $
                               ORBRANGE=orbRange, $
                               ALTITUDERANGE=altitudeRange, $
                               CHARERANGE=charERange, $
                               POYNTRANGE=poyntRange, $
                               SAMPLE_T_RESTRICTION=sample_t_restriction, $
                               INCLUDE_32HZ=include_32Hz, $
                               DISREGARD_SAMPLE_T=disregard_sample_t, $
                               DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
                               DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
                               MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                               MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                               EQUAL_AREA_BINNING=EA_binning, $
                               DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                               MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                               HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,$
                               RESET_GOOD_INDS=reset_good_inds, $
                               DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                               NO_BURSTDATA=no_burstData, $
                               GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i, $
                               FOR_ESPEC_DBS=for_eSpec_DBs, $
                               DONT_LOAD_IN_MEMORY=nonMem)

  ENDELSE

  IF KEYWORD_SET(restrict_with_these_i) THEN BEGIN
     PRINTF,lun,'GET_RESTRICTED_AND_INTERPED_DB_INDICES: Restricting with user-provided inds instead of those generated by get_chaston_ind ...'
     n_final                            = N_ELEMENTS(good_i)
     good_i                            = CGSETINTERSECTION(restrict_with_these_i,good_i)
     n_after                            = N_ELEMENTS(good_i)
     PRINTF,lun,'Lost ' + STRCOMPRESS(n_final-n_after,/REMOVE_ALL) + ' events due to use-provided, restricted indices'
  ENDIF

  ;;Now handle the rest
  IF KEYWORD_SET(do_not_consider_IMF) THEN BEGIN
     PRINTF,lun,"Not considering IMF anything!"
     restricted_and_interped_i_list     = LIST(good_i)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(multiple_IMF_clockAngles) THEN BEGIN
        
        nIter=N_ELEMENTS(clockStr)
        restricted_and_interped_i_list  = LIST()
        FOR iClock=0,N_ELEMENTS(clockStr)-1 DO BEGIN
           tempClockStr  = clockStr[iClock]
           tempList      = GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS( $
                           KEYWORD_SET(for_eSpec_or_ion_db) ? $
                           dbStruct.x : $
                           dbTimes,good_i,delay, $
                           CLOCKSTR=tempClockStr, $
                           DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                           ANGLELIM1=angleLim1, $
                           ANGLELIM2=angleLim2, $
                           MULTIPLE_DELAYS=multiple_delays, $
                           RESOLUTION_DELAY=delay_res, $
                           BINOFFSET_DELAY=binOffset_delay, $
                           STABLEIMF=stableIMF, $
                           SMOOTH_IMF=smooth_IMF, $
                           ;; /RESTRICT_TO_ALFVENDB_TIMES, $
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
                           /RESET_OMNI_INDS, $
                           OMNI_COORDS=OMNI_coords, $
                           OUT_OMNI_PARAMSTR=out_omni_paramStr, $
                           PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                           PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                           PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                           SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                           MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
                           OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
                           CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                           LUN=lun, $
                           TXTOUTPUTDIR=txtOutputDir)

           restricted_and_interped_i_list.add,tempList[0] ;shouldn't be more than one element here
        ENDFOR
     ENDIF ELSE BEGIN
        restricted_and_interped_i_list  = GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS($
                                          KEYWORD_SET(for_eSpec_or_ion_db) ? $
                                          dbStruct.x : $
                                          dbTimes, $
                                          good_i,delay, $
                                          CLOCKSTR=clockStr, $
                                          DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                          ANGLELIM1=angleLim1, $
                                          ANGLELIM2=angleLim2, $
                                          MULTIPLE_DELAYS=multiple_delays, $
                                          RESOLUTION_DELAY=delay_res, $
                                          BINOFFSET_DELAY=binOffset_delay, $
                                          STABLEIMF=stableIMF, $
                                          SMOOTH_IMF=smooth_IMF, $
                                          ;; /RESTRICT_TO_ALFVENDB_TIMES, $
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
                                          PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                                          SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                                          MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
                                          OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
                                          CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                                          LUN=lun, $
                                          TXTOUTPUTDIR=txtOutputDir)
        
     ENDELSE
  ENDELSE

  RETURN,restricted_and_interped_i_list
  
END