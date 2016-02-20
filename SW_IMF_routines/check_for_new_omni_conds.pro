PRO CHECK_FOR_NEW_OMNI_CONDS,MAG_UTC=mag_utc, $
                             CLOCKSTR=clockStr, $
                             ANGLELIM1=angleLim1, $
                             ANGLELIM2=angleLim2, $
                             STABLEIMF=stableIMF, $
                             RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                             BYMIN=byMin, $
                             BZMIN=bzMin, $
                             BYMAX=byMax, $
                             BZMAX=bzMax, $
                             DO_ABS_BYMIN=abs_byMin, $
                             DO_ABS_BYMAX=abs_byMax, $
                             DO_ABS_BZMIN=abs_bzMin, $
                             DO_ABS_BZMAX=abs_bzMax, $
                             OMNI_COORDS=OMNI_coords, $
                             LUN=lun

  COMPILE_OPT idl2

  COMMON OMNI_STABILITY

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

  IF N_ELEMENTS(bzMin) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bzMin) NE 0 THEN BEGIN
        IF C_OMNI__bzMin NE bzMin THEN BEGIN
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

  IF N_ELEMENTS(bzMax) NE 0 THEN BEGIN
     IF N_ELEMENTS(C_OMNI__bzMax) NE 0 THEN BEGIN
        IF C_OMNI__bzMax NE bzMax THEN BEGIN
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