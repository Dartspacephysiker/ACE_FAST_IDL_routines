;2015/12/31 Added RESTRICT_WITH_THESE_I keyword so that I can do non-storm 
;2016/01/07 Added DESPUNDB keyword
;2016/02/10 Added DO_NOT_CONSIDER_IMF keyword
;2016/02/20 Making restricted_and_interped_i a LIST!
FUNCTION GET_RESTRICTED_AND_INTERPED_DB_INDICES,dbStruct, $
   LUN=lun, $
   DBTIMES=dbTimes, $
   DBFILE=dbfile, $
   CHARIERANGE=charIERange, $ ;Only for non-Alfvén ions
   MIMC_STRUCT=MIMC_struct, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   RESET_OMNI_INDS=reset_omni_inds, $
   OUT_OMNI_PARAMSTR=out_omni_paramStr, $
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
   FOR_SWAY_DB=for_sWay_DB, $
   RESTRICT_WITH_THESE_I=restrict_with_these_i, $
   RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
   DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
   GET_TIME_FOR_ESPEC_DBS=for_eSpec_DBs, $   ;NOTE: DON'T CONFUSE THIS WITH FOR_ESPEC_OR_ION_DB
   DONT_LOAD_IN_MEMORY=nonMem, $
   TXTOUTPUTDIR=txtOutputDir

  
  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN BEGIN
     lun                                = -1 ;stdout
  ENDIF

  IF KEYWORD_SET(for_eSpec_or_ion_db) THEN BEGIN
     
     PRINT,'Getting eSpec/ion DB indices for specified IMF conditions ...'

     good_i  = GET_ESPEC_ION_DB_IND(dbStruct,lun, $
                                    FOR_ALFVEN_DB=for_alfven_db, $
                                    CHARIERANGE=charIERange, $
                                    ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                    IMF_STRUCT=IMF_struct, $
                                    MIMC_STRUCT=MIMC_struct, $
                                    RESET_GOOD_INDS=reset_good_inds, $
                                    DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                    DONT_LOAD_IN_MEMORY=nonMem);, $
                                    ;; /PRINT_PARAM_SUMMARY)
     
  ENDIF ELSE BEGIN

     good_i  = GET_CHASTON_IND(dbStruct,lun, $
                               DBTIMES=dbTimes, $
                               DBFILE=dbfile, $
                               RESET_GOOD_INDS=reset_good_inds, $
                               DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                               GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i, $
                               GET_SWAY_I_NOT_ALFVENDB_I=for_sWay_DB, $
                               FOR_ESPEC_DBS=for_eSpec_DBs, $
                               ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                               IMF_STRUCT=IMF_struct, $
                               MIMC_STRUCT=MIMC_struct, $
                               DONT_LOAD_IN_MEMORY=nonMem)

  ENDELSE

  IF KEYWORD_SET(restrict_with_these_i) AND $
     ~KEYWORD_SET(alfDB_plot_struct.executing_multiples) $
  THEN BEGIN
     PRINTF,lun,'GET_RESTRICTED_AND_INTERPED_DB_INDICES: Restricting with user-provided inds instead of those generated by get_chaston_ind ...'
     n_final                            = N_ELEMENTS(good_i)
     good_i                            = CGSETINTERSECTION(restrict_with_these_i,good_i)
     n_after                            = N_ELEMENTS(good_i)
     PRINTF,lun,'Lost ' + STRCOMPRESS(n_final-n_after,/REMOVE_ALL) + ' events due to use-provided, restricted indices'
  ENDIF

  ;; IF KEYWORD_SET(alfDB_plot_struct.executing_multiples) THEN BEGIN
     restricted_and_interped_i_list = LIST()
  ;; ENDIF

  ;;Now handle the rest
  IF KEYWORD_SET(IMF_struct.do_not_consider_IMF) THEN BEGIN
     PRINTF,lun,"Not considering IMF anything!"
     CASE 1 OF
        TAG_EXIST(alfDB_plot_struct,'storm_opt'): BEGIN ;storm stuff
           CASE 1 OF
              KEYWORD_SET(alfDB_plot_struct.storm_opt.all_storm_phases): BEGIN
                 nIter = N_ELEMENTS(alfDB_plot_struct.multiples)-1
                 FOR k=0,nIter DO BEGIN
                    restricted_and_interped_i_list.Add, $
                       CGSETINTERSECTION(restrict_with_these_i[k],good_i,COUNT=count)
                    PRINT,"N " + alfDB_plot_struct.multiples[k] + ' inds: ' + $
                          STRCOMPRESS(count,/REMOVE_ALL)
                 ENDFOR
              END
              ELSE: BEGIN
                 IF ~(KEYWORD_SET(alfDB_plot_struct.storm_opt.nonStorm     ) OR $
                      KEYWORD_SET(alfDB_plot_struct.storm_opt.mainPhase    ) OR $
                      KEYWORD_SET(alfDB_plot_struct.storm_opt.recoveryPhase))   $
                 THEN BEGIN
                    PRINT,"This should have been handled at the beginning of the routine, since you're not doing multiples"
                    STOP
                 ENDIF ELSE BEGIN
                    restricted_and_interped_i_list = CGSETINTERSECTION( $
                                                     restrict_with_these_i[0], $
                                                     good_i, $
                                                     COUNT=count)
                    PRINT,"N " + alfDB_plot_struct.paramString[0] + ' inds: ' + $
                          STRCOMPRESS(count,/REMOVE_ALL)
                 ENDELSE
              END
        ENDCASE
        END
        TAG_EXIST(alfDB_plot_struct,'ae_opt'): BEGIN ;storm stuff
           CASE 1 OF
              KEYWORD_SET(alfDB_plot_struct.ae_opt.AE_both): BEGIN
                 nIter = N_ELEMENTS(alfDB_plot_struct.multiples)-1
                 FOR k=0,nIter DO BEGIN
                    restricted_and_interped_i_list.Add, $
                       CGSETINTERSECTION(restrict_with_these_i[k],good_i,COUNT=count)
                    PRINT,"N " + alfDB_plot_struct.multiple[k] + ' inds: ' + $
                          STRCOMPRESS(count,/REMOVE_ALL)
                 ENDFOR
              END
              ELSE: BEGIN
                 PRINT,"This should have been handled at the beginning of the routine, since you're not doing multiples"
                 STOP
              END
        ENDCASE
        END
        ELSE: restricted_and_interped_i_list.Add,good_i
     ENDCASE

  ENDIF ELSE BEGIN
     IF KEYWORD_SET(alfDB_plot_struct.multiple_IMF_clockAngles) THEN BEGIN
        
        nIter = N_ELEMENTS(IMF_struct.clockStr)-1
        ;; restricted_and_interped_i_list  = LIST()
        FOR iClock=0,nIter DO BEGIN
           ;; tempClockStr  = IMF_struct.clockStr[iClock]
           IMF_struct.clock_i = iClock
           tempList      = GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS( $
                           (KEYWORD_SET(for_eSpec_or_ion_db) OR KEYWORD_SET(for_sWay_DB)) ? $
                           dbStruct.(0) : $
                           dbTimes,good_i,delay, $
                           IMF_STRUCT=IMF_struct, $
                           MIMC_STRUCT=MIMC_struct, $
                           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                           RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                           /RESET_OMNI_INDS, $
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
        IMF_struct.clock_i = 0
        restricted_and_interped_i_list  = GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS($
                                          (KEYWORD_SET(for_eSpec_or_ion_db) OR KEYWORD_SET(for_sWay_DB)) ? $
                                          dbStruct.(0) : $
                                          dbTimes, $
                                          good_i,delay, $
                                          /RESTRICT_TO_ALFVENDB_TIMES, $
                                          MIMC_STRUCT=MIMC_struct, $
                                          ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                          IMF_STRUCT=IMF_struct, $
                                          RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                                          RESET_OMNI_INDS=reset_omni_inds, $
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