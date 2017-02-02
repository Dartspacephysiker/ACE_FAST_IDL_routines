;;12/07/16
PRO CLEAR_PASIS_VARS,INDS_RESET=inds_reset, $
                     PLOTS_RESET=plots_reset, $
                     DBS_RESET=DBs_reset

  COMPILE_OPT IDL2

  @common__pasis_lists.pro

  IF KEYWORD_SET(inds_reset) THEN BEGIN
     PRINT,'Clearing PASIS ind vars ...'
     PASIS__paramString_list       = !NULL
     PASIS__paramString            = !NULL
     PASIS__plot_i_list            = !NULL
     PASIS__fastLocInterped_i_list = !NULL
     PASIS__indices__eSpec_list    = !NULL
     PASIS__indices__ion_list      = !NULL
  ENDIF

  IF KEYWORD_SET(plots_reset) OR KEYWORD_SET(DBs_reset) THEN BEGIN
     ;; PRINT,'Clearing PASIS plot vars ...'
     ;; PASIS__eFlux_eSpec_data       = !NULL   
     ;; PASIS__eNumFlux_eSpec_data    = !NULL
     ;; PASIS__iFlux_eSpec_data       = !NULL   
     ;; PASIS__iNumFlux_eSpec_data    = !NULL
  ENDIF

  IF KEYWORD_SET(DBs_reset) THEN BEGIN
     ;; PRINT,'Clearing PASIS DB vars ...'
     ;; PASIS__eSpec_delta_t       = !NULL
     ;; PASIS__eSpec__MLTs            = !NULL        
     ;; PASIS__eSpec__ILATs           = !NULL       
     ;; PASIS__ion_delta_t            = !NULL
     ;; PASIS__ion__MLTs              = !NULL        
     ;; PASIS__ion__ILATs             = !NULL
  ENDIF
   ;; PASIS__alfDB_plot_struct      = 
   ;; PASIS__IMF_struct             = 
   ;; PASIS__MIMC_struct            = 

END
