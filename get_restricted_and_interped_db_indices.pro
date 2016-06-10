;2015/12/31 Added RESTRICT_WITH_THESE_I keyword so that I can do non-storm 
;2016/01/07 Added DO_DESPUNDB keyword
;2016/02/10 Added DO_NOT_CONSIDER_IMF keyword
;2016/02/20 Making restricted_and_interped_i a LIST!
FUNCTION GET_RESTRICTED_AND_INTERPED_DB_INDICES,dbStruct,satellite,delay,LUN=lun, $
   DBTIMES=dbTimes,dbfile=dbfile, $
   DO_CHASTDB=do_chastdb, $
   DO_DESPUNDB=do_despunDB, $
   HEMI=hemi, $
   ORBRANGE=orbRange, $
   ALTITUDERANGE=altitudeRange, $
   CHARERANGE=charERange, $
   POYNTRANGE=poyntRange, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   MINMLT=minM, $
   MAXMLT=maxM, $
   BINM=binM, $
   SHIFTM=shiftM, $
   MINILAT=minI, $
   MAXILAT=maxI, $
   BINI=binI, $
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
   RESET_GOOD_INDS=reset_good_inds, $
   NO_BURSTDATA=no_burstData, $
   GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i, $
   RESTRICT_WITH_THESE_I=restrict_with_these_i, $
   DO_NOT_SET_DEFAULTS=do_not_set_defaults

  
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout


  IF KEYWORD_SET(FOR_ESPEC_OR_ION_DB) THEN BEGIN
 
     ;;
     ;;
     ;;YOU'RE RIGHT HERE. YOU HAVEN'T TESTED THIS IF STATEMENT YET, OR WRITTEN IN THE FOR_ESPEC_OR_ION_DB KW FOR THIS ROUTINE.
     ;;YOU ALSO HAVEN'T YET ATTEMPTED TO GET NONALFVEN_FLUXES ANYWHERE WITHIN PLOT_ALFVEN_STATS_IMF_SCREENING.in 
    final_i = GET_ESPEC_ION_DB_IND(dbStruct,lun, $
                                    ;; DBFILE=dbfile, $
                                    ;; DBDIR=dbDir, $
                                    ORBRANGE=orbRange, $
                                    ;; ALTITUDERANGE=altitudeRange, $
                                    ;; CHARERANGE=charERange, $
                                    BOTH_HEMIS=both_hemis, $
                                    ;; NORTH=north, $
                                    ;; SOUTH=south, $
                                    HEMI=hemi, $
                                    HWMAUROVAL=HwMAurOval, $
                                    HWMKPIND=HwMKpInd, $
                                    MINMLT=minM, $
                                    MAXMLT=maxM, $
                                    BINM=binM, $
                                    MINILAT=minI, $
                                    MAXILAT=maxI, $
                                    BINILAT=binI, $
                                    ;; DO_LSHELL=do_lshell, $
                                    ;; MINLSHELL=minL, $
                                    ;; MAXLSHELL=maxL, $
                                    ;; BINLSHELL=binL, $
                                    DAYSIDE=dayside, $
                                    NIGHTSIDE=nightside, $
                                    ;; /GET_ESPEC_I_NOT_ION_I, $
                                    ;; GET_ION_I=get_ion_i, $
                                    RESET_GOOD_INDS=reset_good_inds, $
                                    DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                    ;; /DONT_LOAD_IN_MEMORY, $
                                    ;; DONT_LOAD_IN_MEMORY=nonMem, $
                                    /PRINT_PARAM_SUMMARY)

  ENDIF ELSE BEGIN
     final_i = GET_CHASTON_IND(dbStruct,satellite,lun, $
                               DBTIMES=dbTimes,dbfile=dbfile, $
                               CHASTDB=do_chastdb, HEMI=hemi, $
                               DESPUNDB=do_despunDB, $
                               ORBRANGE=orbRange, $
                               ALTITUDERANGE=altitudeRange, $
                               CHARERANGE=charERange, $
                               POYNTRANGE=poyntRange, $
                               SAMPLE_T_RESTRICTION=sample_t_restriction, $
                               MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                               MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                               DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                               MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                               HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,$
                               RESET_GOOD_INDS=reset_good_inds, $
                               DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                               NO_BURSTDATA=no_burstData, $
                               GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i)

  ENDELSE

  IF KEYWORD_SET(restrict_with_these_i) THEN BEGIN
     PRINTF,lun,'GET_RESTRICTED_AND_INTERPED_DB_INDICES: Restricting with user-provided inds instead of those generated by get_chaston_ind ...'
     n_final = N_ELEMENTS(final_i)
     final_i = CGSETINTERSECTION(restrict_with_these_i,final_i)
     n_after = N_ELEMENTS(final_i)
     PRINTF,lun,'Lost ' + STRCOMPRESS(n_final-n_after,/REMOVE_ALL) + ' events due to use-provided, restricted indices'
  ENDIF

  ;;Now handle the rest
  IF KEYWORD_SET(do_not_consider_IMF) THEN BEGIN
     PRINTF,lun,"Not considering IMF anything!"
     restricted_and_interped_i_list        = LIST(final_i)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(multiple_IMF_clockAngles) THEN BEGIN
        
        nIter=N_ELEMENTS(clockStr)
        restricted_and_interped_i_list    = LIST()
        FOR iClock=0,N_ELEMENTS(clockStr)-1 DO BEGIN
           tempClockStr                   = clockStr[iClock]
           tempList = GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS(dbTimes,final_i,delay, $
                                                                           CLOCKSTR=tempClockStr, $
                                                                           DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                                                           ANGLELIM1=angleLim1, $
                                                                           ANGLELIM2=angleLim2, $
                                                                           MULTIPLE_DELAYS=multiple_delays, $
                                                                           RESOLUTION_DELAY=delay_res, $
                                                                           BINOFFSET_DELAY=binOffset_delay, $
                                                                           STABLEIMF=stableIMF, $
                                                                           SMOOTH_IMF=smooth_IMF, $
                                                                           /RESTRICT_TO_ALFVENDB_TIMES, $
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
                                                                           /RESET_OMNI_INDS, $
                                                                           OMNI_COORDS=OMNI_coords, $
                                                                           OUT_OMNI_PARAMSTR=out_omni_paramStr, $
                                                                           LUN=lun)     

           restricted_and_interped_i_list.add,tempList[0] ;shouldn't be more than one element here
        ENDFOR
     ENDIF ELSE BEGIN
        restricted_and_interped_i_list = GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS(dbTimes,final_i,delay, $
                                                                                              CLOCKSTR=clockStr, $
                                                                                              DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                                                                              ANGLELIM1=angleLim1, $
                                                                                              ANGLELIM2=angleLim2, $
                                                                                              MULTIPLE_DELAYS=multiple_delays, $
                                                                                              RESOLUTION_DELAY=delay_res, $
                                                                                              BINOFFSET_DELAY=binOffset_delay, $
                                                                                              STABLEIMF=stableIMF, $
                                                                                              SMOOTH_IMF=smooth_IMF, $
                                                                                              /RESTRICT_TO_ALFVENDB_TIMES, $
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
                                                                                              OMNI_COORDS=OMNI_coords, $
                                                                                              OUT_OMNI_PARAMSTR=out_omni_paramStr, $
                                                                                              LUN=lun)     
        
     ENDELSE
  ENDELSE

  RETURN,restricted_and_interped_i_list
     
END