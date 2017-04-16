;2017/04/07
FUNCTION GET_SW_CONDS_UTC,tee1,tee2, $
                          TIME_ARRAY=time_array

  COMPILE_OPT IDL2,STRICTARRSUBS

  COMMON OMNI_DBs,OMNI_SW,OMNI_B,OMNI_TP
  COMMON KPCOMMON,KP__Kp,KP__dbDir,KP__dbFile
  COMMON DSTCOMMON,DST__Dst,DST__dbDir,Dst__dbFile
  COMMON AECOMMON,AE__AE,AE__dbDir,AE__dbFile

  ;;Innie
  dataDir           = "/SPENCEdata/Research/database/OMNI/"
  tiltFile          = 'sw_data--dpTilt_for_culled_OMNI_magdata.dat'
  culledDataStr     = "culled_OMNI_magdata.dat"
  culledSWDataStr   = "culled_OMNI_swdata.dat"
  culledPresDataStr = "culled_OMNI_densPressTempData.dat"

  CASE SIZE(tee1,/TYPE) OF
     0: BEGIN
        PRINT,"Nope"
        RETURN,-1
     END
     7: BEGIN
        t1 = STR_TO_TIME(tee1)
     END
     5: BEGIN
        t1 = tee1
     END
  ENDCASE

  IF ~KEYWORD_SET(time_array) THEN BEGIN

     CASE SIZE(tee2,/TYPE) OF
        0: BEGIN
           PRINT,"Nope"
           RETURN,-1
        END
        7: BEGIN
           t2 = STR_TO_TIME(tee2)
        END
        5: BEGIN
           t1 = tee2
        END
     ENDCASE

  ENDIF

  GET_FA_ORBIT,t1,t2, $
               TIME_ARRAY=time_array, $
               /NO_STORE, $
               STRUC=struc

  ;;If we've come this far, load 'em up!

  ;;Solar winders
  RESTORE,dataDir + culledSWDataStr
  RESTORE,dataDir + culledDataStr
  RESTORE,dataDir + culledPresDataStr
  IF N_ELEMENTS(DST__Dst) EQ 0 OR N_ELEMENTS(AE__AE) EQ 0 THEN BEGIN
     LOAD_DST_AE_DBS            ;,Dst,AE
  ENDIF

  IF N_ELEMENTS(KP__Kp) EQ 0 THEN BEGIN
     LOAD_KP_DB
  ENDIF

  magInds       = VALUE_CLOSEST2(mag_UTC,struc.time,/CONSTRAIN)
  swInds        = VALUE_CLOSEST2(mag_UTC_SW,struc.time,/CONSTRAIN)
  presInds      = VALUE_CLOSEST2(mag_UTC_SWTP,struc.time,/CONSTRAIN)
  dstInds       = VALUE_CLOSEST2(DST__dst.time,struc.time,/CONSTRAIN)
  aeInds        = VALUE_CLOSEST2(AE__ae.time,struc.time,/CONSTRAIN)
  KpInds        = VALUE_CLOSEST2(KP__Kp.time,struc.time,/CONSTRAIN)

  maxTDiff      = 90.
  maxDstTDiff   = 3600.
  IF (WHERE(ABS(mag_UTC[magInds]-struc.time      ) GT maxTDiff   ))[0] NE -1 OR $
     (WHERE(ABS(mag_UTC_SW[swInds]-struc.time    ) GT maxTDiff*5))[0] NE -1 OR $
     (WHERE(ABS(mag_UTC_SWTP[presInds]-struc.time) GT maxTDiff*5 ))[0] NE -1 OR $
     (WHERE(ABS(DST__Dst.time[dstInds]-struc.time     ) GT maxDstTDiff))[0] NE -1 OR $
     (WHERE(ABS(AE__AE.time[AEInds]-struc.time       ) GT maxDstTDiff))[0] NE -1 OR $
     (WHERE(ABS(KP__Kp.time[kpInds]-struc.time       ) GT maxDstTDiff))[0] NE -1 $
  THEN BEGIN
     STOP
  ENDIF

  Bx            = Bx[magInds]
  IF KEYWORD_SET(GSE) THEN BEGIN
     phiClock   = phiClock_GSE[magInds]
     By         = By_GSE[magInds]
     Bz         = Bz_GSE[magInds]
  ENDIF ELSE BEGIN
     phiClock   = phiClock_GSM[magInds]
     By         = By_GSM[magInds]
     Bz         = Bz_GSM[magInds]
  ENDELSE

  IMF           = TRANSPOSE([[Bx],[By],[Bz]])

  swSpeed       = flow_speed[swInds]
  V_SW          = TRANSPOSE([[Vx[swInds]],[Vy[swInds]],[Vz[swInds]]])
  ;; Vt            = Vt[swInds]

  press         = pressure[presInds]
  temp          = KELVIN_TO_EV(T[presInds])
  protDens      = proton_density[presInds]

  dstVal        = DST__Dst.dst[dstInds]
  AEVal         = AE__AE.AE[AEInds]
  KpVal         = KP__Kp.Kp[KpInds]

  struct        = {times : {FAST  : struc.time, $
                            mag   : mag_UTC[magInds], $
                            dst   : DST__Dst.time[dstInds], $
                            kp    : KP__Kp.time[KpInds], $
                            SWTP  : mag_UTC_SWTP[presInds]}, $
                   ;; Bx    : Bx, $
                   ;; By    : By, $
                   ;; Bz    : Bz, $
                   IMF    : TEMPORARY(IMF)      , $
                   N      : TEMPORARY(protDens) , $
                   P      : TEMPORARY(press)    , $
                   T      : TEMPORARY(temp)     , $
                   V_SW   : TEMPORARY(V_SW)     , $
                   VSpeed : TEMPORARY(swSpeed)  , $
                   dst    : TEMPORARY(dstVal)   , $
                   AE     : TEMPORARY(AEVal)    , $
                   Kp     : TEMPORARY(KpVal)}

  
  RETURN,struct
  
END
