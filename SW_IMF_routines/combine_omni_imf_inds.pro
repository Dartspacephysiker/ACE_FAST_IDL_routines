PRO COMBINE_OMNI_IMF_INDS,LUN=lun

  COMPILE_OPT idl2

  COMMON OMNI_STABILITY

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  C_OMNI__combined_i              = C_OMNI__time_i

  IF KEYWORD_SET(C_OMNI__phiIMF_i) THEN BEGIN
     C_OMNI__combined_i       = CGSETINTERSECTION(C_OMNI__combined_i,C_OMNI__phiIMF_i,SUCCESS=success)
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

END
