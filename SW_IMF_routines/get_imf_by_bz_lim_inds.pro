PRO GET_IMF_BY_BZ_LIM_INDS,By,Bz,byMin,byMax,bzMin,bzMax,btMin,btMax,bxMin,bxMax, $
                           DO_ABS_BYMIN=abs_byMin, $
                           DO_ABS_BYMAX=abs_byMax, $
                           DO_ABS_BZMIN=abs_bzMin, $
                           DO_ABS_BZMAX=abs_bzMax, $
                           DO_ABS_BTMIN=abs_btMin, $
                           DO_ABS_BTMAX=abs_btMax, $
                           DO_ABS_BXMIN=abs_bxMin, $
                           DO_ABS_BXMAX=abs_bxMax, $
                           LUN=lun

  COMPILE_OPT idl2

  COMMON OMNI_STABILITY

  IF ~KEYWORD_SET(lun) THEN lun = -1

  IF N_ELEMENTS(byMin) GT 0 THEN BEGIN 
     C_OMNI__byMin          = byMin
     C_OMNI__abs_byMin      = KEYWORD_SET(abs_byMin)
     IF C_OMNI__abs_byMin THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__byMin_i     = WHERE(By LE -ABS(byMin) OR By GE ABS(byMin),NCOMPLEMENT=byMinLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__byMin_i     = WHERE(By GE byMin,NCOMPLEMENT=byMinLost)
     ENDELSE

     PRINTF,lun,FORMAT='("ByMin requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__byMin,byMinLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"byMin_",F0.2)',absStr,C_OMNI__byMin)
  ENDIF

  IF N_ELEMENTS(byMax) GT 0 THEN BEGIN 
     C_OMNI__byMax          = byMax
     C_OMNI__abs_byMax      = KEYWORD_SET(abs_byMax)
     IF C_OMNI__abs_byMax THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__byMax_i     = WHERE(ABS(By) LE ABS(C_OMNI__byMax),NCOMPLEMENT=byMaxLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__byMax_i     = WHERE(By LE C_OMNI__byMax,NCOMPLEMENT=byMaxLost)
     ENDELSE

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("ByMax magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__byMax,byMaxLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"byMax_",F0.2)',absStr,C_OMNI__byMax)
  ENDIF

  IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN 
     C_OMNI__bzMin          = bzMin
     C_OMNI__abs_bzMin      = KEYWORD_SET(abs_bzMin)
     IF C_OMNI__abs_bzMin THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__bzMin_i     = WHERE(Bz LE -ABS(C_OMNI__bzMin) OR Bz GE ABS(C_OMNI__bzMin),NCOMPLEMENT=bzMinLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__bzMin_i     = WHERE(Bz GE C_OMNI__bzMin,NCOMPLEMENT=bzMinLost)
     ENDELSE

     PRINTF,lun,FORMAT='("BzMin magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__bzMin,bzMinLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bzMin_",F0.2)',absStr,C_OMNI__bzMin)
  ENDIF

  IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
     C_OMNI__bzMax          = bzMax
     C_OMNI__abs_bzMax      = KEYWORD_SET(abs_bzMax)
     IF C_OMNI__abs_bzMax THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__bzMax_i     = WHERE(ABS(Bz) LE ABS(C_OMNI__bzMax),NCOMPLEMENT=bzMaxLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__bzMax_i     = WHERE(Bz LE C_OMNI__bzMax,NCOMPLEMENT=bzMaxLost)
     ENDELSE

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("BzMax magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__bzMax,bzMaxLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bzMax_",F0.2)',absStr,C_OMNI__bzMax)
  ENDIF  

  IF N_ELEMENTS(btMin) GT 0 THEN BEGIN 
     C_OMNI__btMin          = btMin
     C_OMNI__abs_btMin      = KEYWORD_SET(abs_btMin)
     IF C_OMNI__abs_btMin THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__btMin_i     = WHERE(Bt LE -ABS(C_OMNI__btMin) OR Bt GE ABS(C_OMNI__btMin),NCOMPLEMENT=btMinLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__btMin_i     = WHERE(Bt GE C_OMNI__btMin,NCOMPLEMENT=btMinLost)
     ENDELSE

     PRINTF,lun,FORMAT='("BtMin magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__btMin,btMinLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"btMin_",F0.2)',absStr,C_OMNI__btMin)
  ENDIF

  IF N_ELEMENTS(btMax) GT 0 THEN BEGIN 
     C_OMNI__btMax          = btMax
     C_OMNI__abs_btMax      = KEYWORD_SET(abs_btMax)
     IF C_OMNI__abs_btMax THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__btMax_i     = WHERE(ABS(Bt) LE ABS(C_OMNI__btMax),NCOMPLEMENT=btMaxLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__btMax_i     = WHERE(Bt LE C_OMNI__btMax,NCOMPLEMENT=btMaxLost)
     ENDELSE

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("BtMax magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__btMax,btMaxLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"btMax_",F0.2)',absStr,C_OMNI__btMax)
  ENDIF

  IF N_ELEMENTS(bxMin) GT 0 THEN BEGIN 
     C_OMNI__bxMin          = bxMin
     C_OMNI__abs_bxMin      = KEYWORD_SET(abs_bxMin)
     IF C_OMNI__abs_bxMin THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__bxMin_i     = WHERE(Bx LE -ABS(C_OMNI__bxMin) OR Bx GE ABS(C_OMNI__bxMin),NCOMPLEMENT=bxMinLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__bxMin_i     = WHERE(Bx GE C_OMNI__bxMin,NCOMPLEMENT=bxMinLost)
     ENDELSE

     PRINTF,lun,FORMAT='("BxMin magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__bxMin,bxMinLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bxMin_",F0.2)',absStr,C_OMNI__bxMin)
  ENDIF

  IF N_ELEMENTS(bxMax) GT 0 THEN BEGIN 
     C_OMNI__bxMax          = bxMax
     C_OMNI__abs_bxMax      = KEYWORD_SET(abs_bxMax)
     IF C_OMNI__abs_bxMax THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__bxMax_i     = WHERE(ABS(Bx) LE ABS(C_OMNI__bxMax),NCOMPLEMENT=bxMaxLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__bxMax_i     = WHERE(Bx LE C_OMNI__bxMax,NCOMPLEMENT=bxMaxLost)
     ENDELSE

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("BxMax magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__bxMax,bxMaxLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bxMax_",F0.2)',absStr,C_OMNI__bxMax)
  ENDIF

END