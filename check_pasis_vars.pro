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

  inds_reset  = 0B
  DBs_reset   = 0B
  plots_reset = 0B

  IF compare_alfDB_plot_struct THEN BEGIN
     COMPARE_ALFDB_PLOT_STRUCT,PASIS__alfDB_plot_struct,alfDB_plot_struct, $
                               INDS_RESET=inds_resetTmp, $
                               DBS_RESET=DBS_resetTmp
     inds_reset += TEMPORARY(inds_resetTmp)
     DBs_reset  += TEMPORARY(DBs_resetTmp )
  ENDIF;; ELSE BEGIN
     ;; PASIS__alfDB_plot_struct = TEMPORARY(alfDB_plot_struct)
  ;; ENDELSE

  IF compare_IMF_struct THEN BEGIN
     ;; IF (COMPARE_STRUCT(PASIS__IMF_struct,IMF_struct,EXCEPT=['clock_i'])).nDiff GT 0 THEN inds_resetTmp = 1 ELSE inds_resetTmp = 0
     ;; inds_reset += TEMPORARY(inds_resetTmp)

     IF TAG_EXIST(PASIS__IMF_struct,'binOffset_delay') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.binOffset_delay,IMF_struct.binOffset_delay) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF
     
     IF TAG_EXIST(PASIS__IMF_struct,'btMin') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.btMin,IMF_struct.btMin) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF
     
     IF TAG_EXIST(PASIS__IMF_struct,'btMax') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.btMax,IMF_struct.btMax) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'bxMin') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.bxMin,IMF_struct.bxMin) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'bxMax') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.bxMax,IMF_struct.bxMax) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'byMin') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.byMin,IMF_struct.byMin) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'byMax') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.byMax,IMF_struct.byMax) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'bzMin') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.bzMin,IMF_struct.bzMin) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'bzMax') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.bzMax,IMF_struct.bzMax) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'N2007FuncMin') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.N2007FuncMin,IMF_struct.N2007FuncMin) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF TAG_EXIST(PASIS__IMF_struct,'N2007FuncMax') THEN BEGIN
        IF ~ARRAY_EQUAL(PASIS__IMF_struct.N2007FuncMax,IMF_struct.N2007FuncMax) THEN BEGIN
           inds_reset++
           plots_reset++
        ENDIF
     ENDIF

     IF ~ARRAY_EQUAL(PASIS__IMF_struct.clockStr,IMF_struct.clockStr) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF
     
     IF ~ARRAY_EQUAL(PASIS__IMF_struct.angleLim1,IMF_struct.angleLim1) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF
     
     IF ~ARRAY_EQUAL(PASIS__IMF_struct.angleLim2,IMF_struct.angleLim2) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF
     
     IF ~ARRAY_EQUAL(PASIS__IMF_struct.do_not_consider_IMF,IMF_struct.do_not_consider_IMF) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF
     
     IF ~ARRAY_EQUAL(PASIS__IMF_struct.dont_consider_clockAngles,IMF_struct.dont_consider_clockAngles) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF
     
     IF ~ARRAY_EQUAL(PASIS__IMF_struct.delay_res,IMF_struct.delay_res) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF
     
     IF ~ARRAY_EQUAL(PASIS__IMF_struct.stableIMF,IMF_struct.stableIMF) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF
     
     IF ~ARRAY_EQUAL(PASIS__IMF_struct.delay,IMF_struct.delay) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF

     IF ~ARRAY_EQUAL(PASIS__IMF_struct.latest_UTC,IMF_struct.latest_UTC) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF

     IF ~ARRAY_EQUAL(PASIS__IMF_struct.latest_JulDay,IMF_struct.latest_JulDay) THEN BEGIN
        inds_reset++
        plots_reset++
     ENDIF

     comp =  COMPARE_STRUCT(PASIS__IMF_struct,IMF_struct,EXCEPT=['binOffset_delay', $
                                                                 'btMin','btMax', $
                                                                 'bxMin','bxMax', $
                                                                 'byMin','byMax', $
                                                                 'bzMin','bzMax', $
                                                                 'N2007FuncMin','N2007FuncMax', $
                                                                 'clock_i','clockstr', $
                                                                 'angleLim1','angleLim2', $
                                                                 'do_not_consider_IMF', $
                                                                 'dont_consider_clockAngles', $
                                                                 'delay_res','stableIMF', $
                                                                 'delay', $
                                                                 'latest_UTC', $
                                                                 'latest_JulDay'])

     IF comp.nDiff GT 0 THEN BEGIN

        STOP

     ENDIF

     pIMFTags = (TAG_NAMES(PASIS__IMF_struct))[SORT(TAG_NAMES(PASIS__IMF_struct))]
     IMFTags  =  (TAG_NAMES(IMF_struct))       [SORT(TAG_NAMES(IMF_struct))]
     IF ~ARRAY_EQUAL(pIMFTags,IMFTags) THEN BEGIN
        diffList  = !NULL

        missingP  = INDGEN(N_ELEMENTS(pIMFTags))
        FOR k=0,N_ELEMENTS(IMFTags)-1 DO BEGIN
           tmpInd = WHERE(STRUPCASE(pIMFTags) EQ STRUPCASE(IMFTags[k]))
           IF tmpInd[0] EQ -1 THEN BEGIN
              diffList = [diffList,IMFTags[k]]
           ENDIF ELSE BEGIN
              ;; PRINT,"Match: ",IMFTags[k]
              missingP = CGSETDIFFERENCE(missingP,tmpInd)
              IF missingP[0] EQ -1 THEN STOP
           ENDELSE
        ENDFOR

        PRINT,"Differing IMF tags ... "
        FOR k=0,N_ELEMENTS(diffList)-1 DO BEGIN
           PRINT,FORMAT='("DiffList: ",10(A0,:,", "))',diffList[k]
        ENDFOR

        IF N_ELEMENTS(missingP) GT 0 AND N_ELEMENTS(diffList) GT 0 THEN BEGIN
           diffList = [diffList,pIMFTags[missingP]]
        ENDIF
        diffInds = INDGEN(N_ELEMENTS(diffList))

        ;;Check Bx
        tmp = WHERE((diffList EQ STRUPCASE("bxMin")) OR $
                    (diffList EQ STRUPCASE("bxMax")))
        IF tmp[0] NE -1 AND diffInds[0] NE -1 THEN BEGIN
           inds_reset++
           diffInds      = CGSETDIFFERENCE(diffInds,tmp,NORESULT=-1)
           diffList[tmp] = ''
        ENDIF

        ;;Check By
        tmp = WHERE((diffList EQ STRUPCASE("byMin")) OR $
                    (diffList EQ STRUPCASE("byMax")))
        IF tmp[0] NE -1 AND diffInds[0] NE -1 THEN BEGIN
           inds_reset++
           diffInds      = CGSETDIFFERENCE(diffInds,tmp,NORESULT=-1)
           diffList[tmp] = ''
        ENDIF

        ;;Check Bz
        tmp = WHERE((diffList EQ STRUPCASE("bzMin")) OR $
                    (diffList EQ STRUPCASE("bzMax")))
        IF tmp[0] NE -1 AND diffInds[0] NE -1 THEN BEGIN
           inds_reset++
           diffInds      = CGSETDIFFERENCE(diffInds,tmp,NORESULT=-1)
           diffList[tmp] = ''
        ENDIF

        ;;Check Bt
        tmp = WHERE((diffList EQ STRUPCASE("btMin")) OR $
                    (diffList EQ STRUPCASE("btMax")))
        IF tmp[0] NE -1 AND diffInds[0] NE -1 THEN BEGIN
           inds_reset++
           diffInds      = CGSETDIFFERENCE(diffInds,tmp,NORESULT=-1)
           diffList[tmp] = ''
        ENDIF

        tmp = WHERE((diffList EQ STRUPCASE("abs_bxMin")) OR $
                    (diffList EQ STRUPCASE("abs_bxMax")) OR $
                    (diffList EQ STRUPCASE("abs_byMin")) OR $
                    (diffList EQ STRUPCASE("abs_byMax")) OR $
                    (diffList EQ STRUPCASE("abs_bzMin")) OR $
                    (diffList EQ STRUPCASE("abs_bzMax")) OR $
                    (diffList EQ STRUPCASE("abs_btMin")) OR $
                    (diffList EQ STRUPCASE("abs_btMax")))
        IF tmp[0] NE -1 AND diffInds[0] NE -1 THEN BEGIN
           inds_reset++
           diffInds      = CGSETDIFFERENCE(diffInds,tmp,NORESULT=-1)
           diffList[tmp] = ''
        ENDIF

        ;;Check smoothWindow
        tmp = WHERE(diffList EQ STRUPCASE("smoothWindow"))
        IF tmp[0] NE -1 AND diffInds[0] NE -1 THEN BEGIN
           inds_reset++
           diffInds      = CGSETDIFFERENCE(diffInds,tmp,NORESULT=-1)
           diffList[tmp] = ''
        ENDIF

        ;;Check smoothWindow
        tmp = WHERE(diffList EQ STRUPCASE("use_julDay_not_UTC"))
        IF tmp[0] NE -1 AND diffInds[0] NE -1 THEN BEGIN
           inds_reset++
           diffInds      = CGSETDIFFERENCE(diffInds,tmp,NORESULT=-1)
           diffList[tmp] = ''
        ENDIF

        IF diffInds[0] NE -1 THEN STOP

     ENDIF
  ENDIF ;; ELSE BEGIN
     ;; PASIS__IMF_struct = TEMPORARY(IMF_struct)
  ;; ENDELSE

  IF compare_MIMC_struct THEN BEGIN
     COMPARE_MIMC_STRUCT,PASIS__MIMC_struct,MIMC_struct,INDS_RESET=inds_resetTmp,DBS_RESET=DBs_resetTmp
     
     inds_reset += TEMPORARY(inds_resetTmp)
     DBs_reset  += TEMPORARY(DBs_resetTmp )
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
