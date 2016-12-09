;;12/07/16
PRO CHECK_PASIS_VARS, $
   INDS_RESET=inds_reset, $
   PLOTS_RESET=plots_reset, $
   DBS_RESET=DBs_reset, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   GET_PLOT_I=get_plot_i, $
   GET_FASTLOC_I=get_fastLoc_i, $
   GET_ESPEC_I=get_eSpec_i, $
   GET_ION_I=get_ion_i, $
   PLOT_I_LIST=plot_i_list, $
   INDICES__ESPEC_LIST=indices__eSpec_list, $
   INDICES__ION_LIST=indices_ion_list, $
   GET_PARAMSTRING=get_paramString, $
   GET_PARMSTRINGLIST=get_paramString_list, $
   COMPARE_ALFDB_PLOT_STRUCT=compare_alfDB_plot_struct, $
   COMPARE_MIMC_STRUCT=compare_MIMC_struct, $
   COMPARE_IMF_STRUCT=compare_IMF_struct

  COMPILE_OPT IDL2

  @common__pasis_lists.pro

  ;; IF KEYWORD_SET(PASIS__alfDB_plot_struct) THEN BEGIN
  compare_alfDB_plot_struct = KEYWORD_SET(PASIS__alfDB_plot_struct)
  ;; ENDIF

  ;; IF KEYWORD_SET(PASIS__MIMC_struct) THEN BEGIN
  compare_MIMC_struct       = KEYWORD_SET(PASIS__MIMC_struct)
  ;; ENDIF

  ;; IF KEYWORD_SET(PASIS__IMF_struct) THEN BEGIN
  compare_IMF_struct        = KEYWORD_SET(PASIS__IMF_struct)
  ;; ENDIF

  inds_reset = 0B
  IF compare_alfDB_plot_struct THEN BEGIN
     COMPARE_ALFDB_PLOT_STRUCT,PASIS__alfDB_plot_struct,alfDB_plot_struct,INDS_RESET=inds_resetTmp
     inds_reset += TEMPORARY(inds_resetTmp)
  ENDIF;; ELSE BEGIN
     ;; PASIS__alfDB_plot_struct = TEMPORARY(alfDB_plot_struct)
  ;; ENDELSE

  IF compare_IMF_struct THEN BEGIN
     ;; IF (COMPARE_STRUCT(PASIS__IMF_struct,IMF_struct,EXCEPT=['clock_i'])).nDiff GT 0 THEN inds_resetTmp = 1 ELSE inds_resetTmp = 0
     ;; inds_reset += TEMPORARY(inds_resetTmp)

     comp =  COMPARE_STRUCT(PASIS__IMF_struct,IMF_struct,EXCEPT=['clock_i'])
     IF comp.nDiff GT 0 THEN BEGIN

        STOP

     ENDIF
  ENDIF;; ELSE BEGIN
     ;; PASIS__IMF_struct = TEMPORARY(IMF_struct)
  ;; ENDELSE

  IF compare_MIMC_struct THEN BEGIN
     COMPARE_MIMC_STRUCT,PASIS__MIMC_struct,MIMC_struct,INDS_RESET=inds_resetTmp
     
     inds_reset += TEMPORARY(inds_resetTmp)
     ;; PASIS__MIMC_struct = MIMC_struct
  ENDIF;; ELSE BEGIN
  ;; ENDELSE

  CLEAR_PASIS_VARS,INDS_RESET=inds_reset, $
                   PLOTS_RESET=plots_reset, $
                   DBS_RESET=DBs_reset

  IF N_ELEMENTS(PASIS__plot_i_list) GT 0 THEN BEGIN
     ;; plot_i_list             = PASIS__plot_i_list
     get_plot_i              = 0
  ENDIF ELSE BEGIN
     get_plot_i              = 1
  ENDELSE

  IF (N_ELEMENTS(PASIS__indices__eSpec_list) GT 0) THEN BEGIN
     ;; indices__eSpec_list     = PASIS__indices__eSpec_list
     get_eSpec_i             = 0
  ENDIF ELSE BEGIN
     get_eSpec_i             = 1
  ENDELSE

  IF (N_ELEMENTS(PASIS__indices__ion_list) GT 0) THEN BEGIN
     ;; indices__ion_list     = PASIS__indices__ion_list
     get_ion_i             = 0
  ENDIF ELSE BEGIN
     get_ion_i             = 1
  ENDELSE

  IF N_ELEMENTS(PASIS__fastLocInterped_i_list) GT 0 THEN BEGIN
     ;; fastLocInterped_i_list  = PASIS__fastLocInterped_i_list
     get_fastLoc_i           = 0
  ENDIF ELSE BEGIN
     get_fastLoc_i           = 1
  ENDELSE

  IF KEYWORD_SET(PASIS__paramString_list) THEN BEGIN
     ;; paramString_list        = PASIS__paramString_list
     get_paramString_list    = 0
  ENDIF

  IF KEYWORD_SET(PASIS__paramString) THEN BEGIN
     ;; paramString             = PASIS__paramString
     get_paramString         = 0
  ENDIF

END
