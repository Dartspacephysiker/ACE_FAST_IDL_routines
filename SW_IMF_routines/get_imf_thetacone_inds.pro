;;12/22/16
PRO GET_IMF_THETACONE_INDS,thetaCone, $
                           IMF_STRUCT=IMF_struct, $
                           LUN=lun

  COMPILE_OPT IDL2

  @common__omni_stability.pro

  IF TAG_EXIST(IMF_struct,'tConeMin') THEN BEGIN 
     C_OMNI__tConeMin    = IMF_struct.tConeMin
     C_OMNI__tConeMin_i  = WHERE(C_OMNI__thetaCone GE tConeMin,NCOMPLEMENT=tConeMinLost)


     PRINTF,lun,FORMAT='("TConeMin requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__tConeMin,tConeMinLost
     C_OMNI__paramStr   += STRING(FORMAT='("-tConeMin_",F0.2)',C_OMNI__tConeMin)
  ENDIF

  IF TAG_EXIST(IMF_struct,'tConeMax') THEN BEGIN 
     C_OMNI__tConeMax    = IMF_struct.tConeMax
     C_OMNI__tConeMax_i  = WHERE(C_OMNI__thetaCone LE C_OMNI__tConeMax,NCOMPLEMENT=tConeMaxLost)

     PRINTF,lun,""
     PRINTF,lun,FORMAT='("TConeMax magnitude requirement, nLost:",T40,F5.2," nT, ",T50,I0)',C_OMNI__tConeMax,tConeMaxLost
     C_OMNI__paramStr   += STRING(FORMAT='("-tConeMax_",F0.2)',C_OMNI__tConeMax)
  ENDIF

END
