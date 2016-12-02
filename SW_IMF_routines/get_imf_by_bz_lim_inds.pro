PRO GET_IMF_BY_BZ_LIM_INDS,By,Bz,Bt,Bx,byMin,byMax,bzMin,bzMax,btMin,btMax,bxMin,bxMax, $
                           IMF_STRUCT=IMF_struct, $
                           ;; DO_ABS_BYMIN=abs_byMin, $
                           ;; DO_ABS_BYMAX=abs_byMax, $
                           ;; DO_ABS_BZMIN=abs_bzMin, $
                           ;; DO_ABS_BZMAX=abs_bzMax, $
                           ;; DO_ABS_BTMIN=abs_btMin, $
                           ;; DO_ABS_BTMAX=abs_btMax, $
                           ;; DO_ABS_BXMIN=abs_bxMin, $
                           ;; DO_ABS_BXMAX=abs_bxMax, $
                           ;; BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
                           ;; BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
                           LUN=lun

  COMPILE_OPT idl2

  @common__omni_stability.pro
  ;; COMMON OMNI_STABILITY

  IF ~KEYWORD_SET(lun) THEN lun = -1

  IF TAG_EXIST(IMF_struct,'byMin') THEN BEGIN 
     C_OMNI__byMin          = IMF_struct.byMin
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

  IF TAG_EXIST(IMF_struct,'byMax') THEN BEGIN 
     C_OMNI__byMax          = IMF_struct.byMax
     C_OMNI__abs_byMax      = KEYWORD_SET(IMF_struct.abs_byMax)
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

  IF TAG_EXIST(IMF_struct,'bzMin') THEN BEGIN 
     C_OMNI__bzMin          = IMF_struct.bzMin
     C_OMNI__abs_bzMin      = KEYWORD_SET(IMF_struct.abs_bzMin)
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

  IF TAG_EXIST(IMF_struct,'bzMax') THEN BEGIN 
     C_OMNI__bzMax          = IMF_struct.bzMax
     C_OMNI__abs_bzMax      = KEYWORD_SET(IMF_struct.abs_bzMax)
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

  IF TAG_EXIST(IMF_struct,'btMin') THEN BEGIN 
     C_OMNI__btMin          = IMF_struct.btMin
     C_OMNI__abs_btMin      = KEYWORD_SET(IMF_struct.abs_btMin)
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

  IF TAG_EXIST(IMF_struct,'btMax') THEN BEGIN 
     C_OMNI__btMax          = IMF_struct.btMax
     C_OMNI__abs_btMax      = KEYWORD_SET(IMF_struct.abs_btMax)
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

  IF TAG_EXIST(IMF_struct,'bxMin') THEN BEGIN 
     C_OMNI__bxMin          = IMF_struct.bxMin
     C_OMNI__abs_bxMin      = KEYWORD_SET(IMF_struct.abs_bxMin)
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

  IF TAG_EXIST(IMF_struct,'bxMax') THEN BEGIN 
     C_OMNI__bxMax          = IMF_struct.bxMax
     C_OMNI__abs_bxMax      = KEYWORD_SET(IMF_struct.abs_bxMax)
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

  IF TAG_EXIST(IMF_struct,'bx_over_by_ratio_min') THEN BEGIN 
     C_OMNI__bx_over_by_ratio_min          = IMF_struct.bx_over_by_ratio_min
     ;; C_OMNI__abs_bx_over_by_ratio_min      = KEYWORD_SET(abs_bx_over_by_ratio_min)
     ;; IF C_OMNI__abs_bx_over_by_ratio_min THEN BEGIN
     ;;    absStr              = 'ABS_'
     ;;    C_OMNI__bx_over_by_ratio_min_i     = WHERE(ABS(Bx) LE ABS(C_OMNI__bx_over_by_ratio_min),NCOMPLEMENT=bx_over_by_ratio_minLost)
     ;; ENDIF ELSE BEGIN
     absStr                = ''
     tmpRatio                           = ABS(Bx/By)
     C_OMNI__bx_over_by_ratio_min_i     = WHERE((FINITE(tmpRatio)) AND (tmpRatio GE C_OMNI__bx_over_by_ratio_min),NCOMPLEMENT=bx_over_by_ratio_minLost)
     ;; ENDELSE

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("Bx_Over_By_Ratio_Min requirement, nLost:",T40,F5.2,", ",T50,I0)',C_OMNI__bx_over_by_ratio_min,bx_over_by_ratio_minLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bxy_ratioMin_",F0.2)',absStr,C_OMNI__bx_over_by_ratio_min)
  ENDIF

  IF TAG_EXIST(IMF_struct,'bx_over_by_ratio_max') THEN BEGIN 
     C_OMNI__bx_over_by_ratio_max          = IMF_struct.bx_over_by_ratio_max
     ;; C_OMNI__abs_bx_over_by_ratio_max      = KEYWORD_SET(abs_bx_over_by_ratio_max)
     ;; IF C_OMNI__abs_bx_over_by_ratio_max THEN BEGIN
     ;;    absStr              = 'ABS_'
     ;;    C_OMNI__bx_over_by_ratio_max_i     = WHERE(ABS(Bx) LE ABS(C_OMNI__bx_over_by_ratio_max),NCOMPLEMENT=bx_over_by_ratio_maxLost)
     ;; ENDIF ELSE BEGIN
     absStr                = ''
     tmpRatio                              = ABS(Bx/By)
     C_OMNI__bx_over_by_ratio_max_i        = WHERE((FINITE(tmpRatio)) AND (tmpRatio LE C_OMNI__bx_over_by_ratio_max),NCOMPLEMENT=bx_over_by_ratio_maxLost)
     ;; C_OMNI__bx_over_by_ratio_max_i        = WHERE(ABS(Bx/By) LE C_OMNI__bx_over_by_ratio_max,NCOMPLEMENT=bx_over_by_ratio_maxLost)
     ;; ENDELSE

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("Bx_Over_By_Ratio_Max requirement, nLost:",T40,F5.2,", ",T50,I0)',C_OMNI__bx_over_by_ratio_max,bx_over_by_ratio_maxLost
     C_OMNI__paramStr      += STRING(FORMAT='("--",A0,"bxy_ratioMax_",F0.2)',absStr,C_OMNI__bx_over_by_ratio_max)
  ENDIF

END