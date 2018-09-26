;2018/09/26
PRO JOURNAL__20180926__MAKE_OMNI_STRUCTS

  COMPILE_OPT IDL2,STRICTARRSUBS

  dataDir           = "/SPENCEdata/Research/database/OMNI/"
  tiltFile          = 'sw_data--dpTilt_for_culled_OMNI_magdata.dat'
  culledDataStr     = "culled_OMNI_magdata.dat"
  culledSWDataStr   = "culled_OMNI_swdata.dat"
  culledPresDataStr = "culled_OMNI_densPressTempData.dat"

  culledDataStructStr = 'culled_OMNI_magdata_struct.dat'
  culledSWDataStructStr   = "culled_OMNI_swdata_struct.dat"
  culledPresDataStructStr = "culled_OMNI_densPressTempData_struct.dat"

  make_cData_struct    = 0
  make_SWData_struct   = 0
  make_presData_struct = 0

  IF KEYWORD_SET(make_cData_struct) THEN BEGIN

     RESTORE,dataDir+culledDataStr

     OMNIB = { $
             UTC         : TEMPORARY(MAG_UTC), $
             GOODTIMES_I : TEMPORARY(GOODMAG_GOODTIMES_I), $
             BX          : TEMPORARY(BX), $
             GSE         : {BY             : TEMPORARY(BY_GSE), $
                            BZ             : TEMPORARY(BZ_GSE), $
                            BT             : TEMPORARY(BT_GSE), $
                            BXY_OVER_BZ    : TEMPORARY(BXY_OVER_BZ_GSE), $
                            PHICLOCK       : TEMPORARY(PHICLOCK_GSE), $
                            THETACONE      : TEMPORARY(THETACONE_GSE), $
                            CONE_OVERCLOCK : TEMPORARY(CONE_OVERCLOCK_GSE)}, $
             GSM         : {BY             : TEMPORARY(BY_GSM), $
                            BZ             : TEMPORARY(BZ_GSM), $
                            BT             : TEMPORARY(BT_GSM), $
                            BXY_OVER_BZ    : TEMPORARY(BXY_OVER_BZ_GSM), $
                            PHICLOCK       : TEMPORARY(PHICLOCK_GSM), $
                            THETACONE      : TEMPORARY(THETACONE_GSM), $
                            CONE_OVERCLOCK : TEMPORARY(CONE_OVERCLOCK_GSM)}}


     PRINT,"Saving " + culledDataStructStr
     SAVE,OMNIB,FILENAME=dataDir+culledDataStructStr

  ENDIF

  IF KEYWORD_SET(make_SWData_struct) THEN BEGIN

     RESTORE,dataDir+culledSWDataStr

     OMNISW = { $
              UTC                 : TEMPORARY(MAG_UTC_SW), $
              GOODTIMES_I         : TEMPORARY(GOODSW_GOODTIMES_I), $
              FLOW_SPEED          : TEMPORARY(FLOW_SPEED), $
              VT                  : TEMPORARY(VT), $
              VX                  : TEMPORARY(VX), $
              VY                  : TEMPORARY(VY), $
              VZ                  : TEMPORARY(VZ)}

     PRINT,"Saving " + culledSWDataStructStr
     SAVE,OMNISW,FILENAME=dataDir+culledSWDataStructStr

  ENDIF

  IF KEYWORD_SET(make_presData_struct) THEN BEGIN

     RESTORE,dataDir+culledPresDataStr

     OMNIPRES = { $
                UTC             : TEMPORARY(MAG_UTC_SWTP), $
                GOODTIMES_I     : TEMPORARY(GOODSWTP_I), $
                EFIELD          : TEMPORARY(EFIELD), $
                MACH_NUM        : TEMPORARY(MACH_NUM), $
                MGS_MACH_NUM    : TEMPORARY(MGS_MACH_NUM), $
                PRESSURE        : TEMPORARY(PRESSURE), $
                PROTON_DENSITY  : TEMPORARY(PROTON_DENSITY), $
                T               : TEMPORARY(T)}

     PRINT,"Saving " + culledPresDataStructStr
     SAVE,OMNIPRES,FILENAME=dataDir+culledPresDataStructStr

  ENDIF



END
