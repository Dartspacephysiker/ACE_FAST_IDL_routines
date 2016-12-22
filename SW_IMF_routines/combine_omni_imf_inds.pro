PRO COMBINE_OMNI_IMF_INDS,LUN=lun

  COMPILE_OPT idl2

  @common__omni_stability.pro
  ;; COMMON OMNI_STABILITY

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  ;; C_OMNI__combined_i              = C_OMNI__time_i
  C_OMNI__combined_i          = CGSETINTERSECTION(C_OMNI__time_i,C_OMNI__clean_i, $
                                                  COUNT=nCombined)
  IF nCombined LE 1 THEN BEGIN
     PRINTF,lun,"No OMNI indices to speak of!!!"
     STOP
  ENDIF

  IF KEYWORD_SET(C_OMNI__restrict_i) THEN BEGIN
     PRINTF,lun,"Restricting OMNI with user-provided indices ..."
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__restrict_i, $
                                                  COUNT=nCombinedRestr)
     IF nCombined LE 1 THEN BEGIN
        PRINTF,lun,"No OMNI indices to speak of!!!"
        STOP
     ENDIF
     PRINTF,lun,"Losing " + STRCOMPRESS(nCombined-nCombinedRestr,/REMOVE_ALL) + $
            " OMNI entries en total"     
  ENDIF

  IF KEYWORD_SET(C_OMNI__phiIMF_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__phiIMF_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__bxMin_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__bxMin_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__bxMax_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__bxMax_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__byMin_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__byMin_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__byMax_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__byMax_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__bzMin_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__bzMin_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__bzMax_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__bzMax_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__btMin_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__btMin_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__btMax_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__btMax_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__bx_over_by_ratio_min_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__bx_over_by_ratio_min_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__bx_over_by_ratio_max_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__bx_over_by_ratio_max_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF

  IF KEYWORD_SET(C_OMNI__tConeMin_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__tConeMin_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF
  IF KEYWORD_SET(C_OMNI__tConeMax_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__tConeMax_i,SUCCESS=success)
     IF ~success THEN BEGIN
        PRINTF,lun,"Choked trying to combine OMNI indices corresponding to all requested restrictions! No inds left!"
        STOP
     ENDIF
  ENDIF

END
