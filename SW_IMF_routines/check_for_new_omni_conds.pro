PRO CHECK_FOR_NEW_OMNI_CONDS,MAG_UTC=mag_utc, $
                             IMF_STRUCT=IMF_struct, $
                             RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                             RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                             LUN=lun

  COMPILE_OPT idl2,strictarrsubs

  @common__omni_stability.pro
  ;; COMMON OMNI_STABILITY

  IF TAG_EXIST(IMF_struct,'dont_consider_clockAngles') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__noClockAngles) GT 0 THEN BEGIN
        IF C_OMNI__noClockAngles NE IMF_struct.dont_consider_clockAngles THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'clockStr') THEN BEGIN
     IF KEYWORD_SET(C_OMNI__clockStr) THEN BEGIN
        IF C_OMNI__clockStr NE IMF_struct.clockStr[IMF_struct.clock_i] THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  ;; IF KEYWORD_SET(angleLim1) THEN BEGIN
  ;;    IF KEYWORD_SET(C_OMNI__angleLim1) THEN BEGIN
  ;;       IF C_OMNI__angleLim1 NE IMF_struct.angleLim1 THEN BEGIN
  ;;          C_OMNI__RECALCULATE = 1
  ;;       ENDIF
  ;;    ENDIF
  ;; ENDIF

  ;; IF KEYWORD_SET(angleLim2) THEN BEGIN
  ;;    IF KEYWORD_SET(C_OMNI__angleLim2) THEN BEGIN
  ;;       IF C_OMNI__angleLim2 NE IMF_struct.angleLim2 THEN BEGIN
  ;;          C_OMNI__RECALCULATE = 1
  ;;       ENDIF
  ;;    ENDIF
  ;; ENDIF

  IF TAG_EXIST(IMF_struct,'stableIMF') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__stableIMF) NE 0 THEN BEGIN
        IF C_OMNI__stableIMF NE IMF_struct.stableIMF THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(restrict_to_alfvendb_times) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__restrict_to_alfvendb_times) NE 0 THEN BEGIN
        IF C_OMNI__restrict_to_alfvendb_times NE restrict_to_alfvendb_times THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'byMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__byMin) NE 0 THEN BEGIN
        IF C_OMNI__byMin NE IMF_struct.byMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'byMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__byMax) NE 0 THEN BEGIN
        IF C_OMNI__byMax NE IMF_struct.byMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'bzMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bzMin) NE 0 THEN BEGIN
        IF C_OMNI__bzMin NE IMF_struct.bzMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF


  IF TAG_EXIST(IMF_struct,'bzMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bzMax) NE 0 THEN BEGIN
        IF C_OMNI__bzMax NE IMF_struct.bzMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'btMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__btMin) NE 0 THEN BEGIN
        IF C_OMNI__btMin NE IMF_struct.btMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'btMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__btMax) NE 0 THEN BEGIN
        IF C_OMNI__btMax NE IMF_struct.btMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'bxMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bxMin) NE 0 THEN BEGIN
        IF C_OMNI__bxMin NE IMF_struct.bxMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'bxMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bxMax) NE 0 THEN BEGIN
        IF C_OMNI__bxMax NE IMF_struct.bxMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'N2007FuncMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__N2007FuncMin) NE 0 THEN BEGIN
        IF C_OMNI__N2007FuncMin NE IMF_struct.N2007FuncMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'N2007FuncMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__N2007FuncMax) NE 0 THEN BEGIN
        IF C_OMNI__N2007FuncMax NE IMF_struct.N2007FuncMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_byMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_byMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_byMin NE IMF_struct.abs_byMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_byMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_byMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_byMax NE IMF_struct.abs_byMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_bzMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bzMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_bzMin NE IMF_struct.abs_bzMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_bzMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bzMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_bzMax NE IMF_struct.abs_bzMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_btMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_btMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_btMin NE IMF_struct.abs_btMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_btMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_btMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_btMax NE IMF_struct.abs_btMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_bxMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bxMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_bxMin NE IMF_struct.abs_bxMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_bxMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bxMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_bxMax NE IMF_struct.abs_bxMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_N2007FuncMin') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_N2007FuncMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_N2007FuncMin NE IMF_struct.abs_N2007FuncMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'abs_N2007FuncMax') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_N2007FuncMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_N2007FuncMax NE IMF_struct.abs_N2007FuncMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'bx_over_by_ratio_max') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bx_over_by_ratio_max) NE 0 THEN BEGIN
        IF C_OMNI__bx_over_by_ratio_max NE IMF_struct.bx_over_by_ratio_max THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'bx_over_by_ratio_min') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bx_over_by_ratio_min) NE 0 THEN BEGIN
        IF C_OMNI__bx_over_by_ratio_min NE IMF_struct.bx_over_by_ratio_min THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF TAG_EXIST(IMF_struct,'OMNI_coords') THEN BEGIN
     IF N_ELEMENTS(C_OMNI__magCoords) NE 0 THEN BEGIN
        IF C_OMNI__magCoords NE IMF_struct.OMNI_coords THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(restrict_OMNI_with_these_i) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__restrict_i) NE 0 THEN BEGIN
        IF ~ARRAY_EQUAL(restrict_OMNI_with_these_i,C_OMNI__restrict_i) THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  C_OMNI__RECALCULATE = 0

END