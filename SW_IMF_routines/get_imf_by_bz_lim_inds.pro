PRO GET_IMF_BY_BZ_LIM_INDS,By,Bz,byMin,byMax,bzMin,bzMax, $
                           DO_ABS_BYMIN=abs_byMin, $
                           DO_ABS_BYMAX=abs_byMax, $
                           DO_ABS_BZMIN=abs_bzMin, $
                           DO_ABS_BZMAX=abs_bzMax, $
                           LUN=lun

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
        C_OMNI__bzMin_i     = WHERE(By LE -ABS(C_OMNI__bzMin) OR By GE ABS(C_OMNI__bzMin),NCOMPLEMENT=bzMinLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__bzMin_i     = WHERE(By GE C_OMNI__bzMin,NCOMPLEMENT=bzMinLost)
     ENDELSE

     PRINTF,lun,FORMAT='("BzMin magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__bzMin,bzMinLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bzMin_",F0.2)',absStr,C_OMNI__bzMin)
  ENDIF

  IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
     C_OMNI__bzMax          = bzMax
     C_OMNI__abs_bzMax      = KEYWORD_SET(abs_bzMax)
     IF C_OMNI__abs_bzMax THEN BEGIN
        absStr              = 'ABS_'
        C_OMNI__bzMax_i     = WHERE(ABS(By) LE ABS(C_OMNI__bzMax),NCOMPLEMENT=bzMaxLost)
     ENDIF ELSE BEGIN
        absStr              = ''
        C_OMNI__bzMax_i     = WHERE(By LE C_OMNI__bzMax,NCOMPLEMENT=bzMaxLost)
     ENDELSE

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("BzMax magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__bzMax,bzMaxLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bzMax_",F0.2)',absStr,C_OMNI__bzMax)
  ENDIF  

END