PRO CHECK_FOR_NEW_OMNI_CONDS,MAG_UTC=mag_utc, $
                             CLOCKSTR=clockStr, $
                             ANGLELIM1=angleLim1, $
                             ANGLELIM2=angleLim2, $
                             DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                             STABLEIMF=stableIMF, $
                             RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
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
                             OMNI_COORDS=OMNI_coords, $
                             LUN=lun

  COMPILE_OPT idl2

  COMMON OMNI_STABILITY

  IF N_ELEMENTS(dont_consider_clockAngles) GT 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__noClockAngles) GT 0 THEN BEGIN
        IF C_OMNI__noClockAngles NE dont_consider_clockAngles THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(clockStr) THEN BEGIN
     IF KEYWORD_SET(C_OMNI__clockStr) THEN BEGIN
        IF C_OMNI__clockStr NE clockStr THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  ;; IF KEYWORD_SET(angleLim1) THEN BEGIN
  ;;    IF KEYWORD_SET(C_OMNI__angleLim1) THEN BEGIN
  ;;       IF C_OMNI__angleLim1 NE angleLim1 THEN BEGIN
  ;;          C_OMNI__RECALCULATE = 1
  ;;       ENDIF
  ;;    ENDIF
  ;; ENDIF

  ;; IF KEYWORD_SET(angleLim2) THEN BEGIN
  ;;    IF KEYWORD_SET(C_OMNI__angleLim2) THEN BEGIN
  ;;       IF C_OMNI__angleLim2 NE angleLim2 THEN BEGIN
  ;;          C_OMNI__RECALCULATE = 1
  ;;       ENDIF
  ;;    ENDIF
  ;; ENDIF

  IF N_ELEMENTS(stableIMF) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__stableIMF) NE 0 THEN BEGIN
        IF C_OMNI__stableIMF NE stableIMF THEN BEGIN
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

  IF N_ELEMENTS(byMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__byMin) NE 0 THEN BEGIN
        IF C_OMNI__byMin NE byMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(byMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__byMax) NE 0 THEN BEGIN
        IF C_OMNI__byMax NE byMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(bzMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bzMin) NE 0 THEN BEGIN
        IF C_OMNI__bzMin NE bzMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF


  IF N_ELEMENTS(bzMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bzMax) NE 0 THEN BEGIN
        IF C_OMNI__bzMax NE bzMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(btMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__btMin) NE 0 THEN BEGIN
        IF C_OMNI__btMin NE btMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(btMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__btMax) NE 0 THEN BEGIN
        IF C_OMNI__btMax NE btMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(bxMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bxMin) NE 0 THEN BEGIN
        IF C_OMNI__bxMin NE bxMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(bxMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bxMax) NE 0 THEN BEGIN
        IF C_OMNI__bxMax NE bxMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_byMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_byMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_byMin NE abs_byMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_byMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_byMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_byMax NE abs_byMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_bzMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bzMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_bzMin NE abs_bzMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_bzMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bzMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_bzMax NE abs_bzMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_btMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_btMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_btMin NE abs_btMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_btMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_btMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_btMax NE abs_btMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_bxMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bxMin) NE 0 THEN BEGIN
        IF C_OMNI__abs_bxMin NE abs_bxMin THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(abs_bxMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__abs_bxMax) NE 0 THEN BEGIN
        IF C_OMNI__abs_bxMax NE abs_bxMax THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(bx_over_by_ratio_max) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bx_over_by_ratio_max) NE 0 THEN BEGIN
        IF C_OMNI__bx_over_by_ratio_max NE bx_over_by_ratio_max THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(bx_over_by_ratio_min) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bx_over_by_ratio_min) NE 0 THEN BEGIN
        IF C_OMNI__bx_over_by_ratio_min NE bx_over_by_ratio_min THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(OMNI_coords) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__magCoords) NE 0 THEN BEGIN
        IF C_OMNI__magCoords NE OMNI_coords THEN BEGIN
           C_OMNI__RECALCULATE = 1
           RETURN
        ENDIF
     ENDIF
  ENDIF

  C_OMNI__RECALCULATE = 0

END