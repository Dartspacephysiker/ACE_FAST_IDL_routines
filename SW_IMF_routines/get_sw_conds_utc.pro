;2017/04/07
;; 2018/09/26  : Serious upgrades. Look at the git commit from today—Du skal se

;; DELTA_T     : If tee1 and tee2 provided, delta_t is desired time between samples
PRO GET_SW__CHECK_CLOSENESS,t1,t2,dbTimes,inds,nGot,min_tDiff
  IF Ngot EQ 0 THEN BEGIN
     baby = [t1,t2]
     tmpInds = VALUE_CLOSEST2(dbTimes,baby,/CONSTRAINED)
     min_tDiff = MIN(ABS(dBTimes[tmpInds]-baby),minInd)
     inds = minInd
  ENDIF ELSE BEGIN
     min_tDiff = !VALUES.F_NaN
  ENDELSE
END
FUNCTION GET_SW_CONDS_UTC,tee1,tee2, $
                          TIME_ARRAY=time_array, $
                          GET_ALL_VALUES_BETWEEN_T1_AND_T2=get_all_values_between_t1_and_t2, $
                          DELTA_T=delta_t,       $
                          GSE=GSE, $
                          REABERRATE_VY=reaberrate_Vy

  COMPILE_OPT IDL2,STRICTARRSUBS

  ;; COMMON OMNI_DBs,OMNI_SW,OMNI_B,OMNI_TP
  COMMON KPCOMMON,KP__Kp,KP__dbDir,KP__dbFile
  @common__dst_and_ae_db.pro
  ;; COMMON DSTCOMMON,DST__Dst,DST__dbDir,Dst__dbFile
  ;; COMMON AECOMMON,AE__AE,AE__dbDir,AE__dbFile

  @common__omni_structs.pro

  ;;Innie
  ;; dataDir           = "/SPENCEdata/Research/database/OMNI/"
  ;; tiltFile          = 'sw_data--dpTilt_for_culled_OMNI_magdata.dat'
  ;; culledDataStr     = "culled_OMNI_magdata.dat"
  ;; culledSWDataStr   = "culled_OMNI_swdata.dat"
  ;; culledPresDataStr = "culled_OMNI_densPressTempData.dat"

  ;; culledDataStructStr = 'culled_OMNI_magdata_struct.dat'

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
           t2 = tee2
        END
     ENDCASE

     dt = KEYWORD_SET(delta_t) ? delta_t : 20

     times = [0:(t2-t1):dt] + t1

  ENDIF ELSE IF KEYWORD_SET(get_all_values_between_t1_and_t2) THEN BEGIN
     t2 = time_array[-1]
  ENDIF ELSE times = t1

  ;; GET_FA_ORBIT,t1,t2, $
  ;;              TIME_ARRAY=time_array, $
  ;;              DELTA_T=delta_t,       $
  ;;              /NO_STORE, $
  ;;              STRUC=struc



  ;;If we've come this far, load 'em up!

  ;;Solar winders
  LOAD_OMNI_STRUCTS
  ;; RESTORE,dataDir + culledSWDataStr
  ;; RESTORE,dataDir + culledDataStr
  ;; RESTORE,dataDir + culledPresDataStr

  IF N_ELEMENTS(DST__Dst) EQ 0 OR N_ELEMENTS(AE__AE) EQ 0 THEN BEGIN
     LOAD_DST_AE_DBS            ;,Dst,AE
  ENDIF

  IF N_ELEMENTS(KP__Kp) EQ 0 THEN BEGIN
     LOAD_KP_DB
  ENDIF

  CASE 1 OF
     KEYWORD_SET(get_all_values_between_t1_and_t2): BEGIN
        magInds       = WHERE(OMNIB.UTC GE t1 AND OMNIB.UTC LE t2,nB)
        swInds        = WHERE(OMNISW.UTC GE t1 AND OMNISW.UTC LE t2,nSW)
        presInds      = WHERE(OMNIPRES.UTC GE t1 AND OMNIPRES.UTC LE t2,nPres)
        dstInds       = WHERE(DST__dst.time GE t1 AND DST__dst.time LE t2,nDST)
        aeInds        = WHERE(AE__ae.time GE t1 AND AE__ae.time LE t2,nAE)
        KpInds        = WHERE(KP__Kp.time GE t1 AND KP__Kp.time LE t2,nKP)

        GET_SW__CHECK_CLOSENESS,t1,t2,OMNIB.UTC,magInds,nB,min_tDiff_B
        GET_SW__CHECK_CLOSENESS,t1,t2,OMNISW.UTC,swInds,nSW,min_tDiff_SW
        GET_SW__CHECK_CLOSENESS,t1,t2,OMNIPRES.UTC,presInds,nPres,min_tDiff_Pres
        GET_SW__CHECK_CLOSENESS,t1,t2,DST__dst.time,dstInds,nDST,min_tDiff_DST
        GET_SW__CHECK_CLOSENESS,t1,t2,AE__ae.time,aeInds,nAE,min_tDiff_AE
        GET_SW__CHECK_CLOSENESS,t1,t2,KP__Kp.time,KpInds,nKP,min_tDiff_KP

        min_tDiffs = { $
                     B     : min_tDiff_B    , $
                     SW    : min_tDiff_SW   , $
                     Pres  : min_tDiff_Pres , $
                     DST   : min_tDiff_DST  , $
                     AE    : min_tDiff_AE   , $
                     KP    : min_tDiff_KP, $
                     explanation : "Here, I give you a NaN if the data lay between t1 and t2. A min_tDiff is only given if I had to use VALUE_CLOSEST2 and no data were available between t1 and t2."}

     END
     ELSE: BEGIN

        magInds       = VALUE_CLOSEST2(OMNIB.UTC,times,/CONSTRAIN)
        swInds        = VALUE_CLOSEST2(OMNISW.UTC,times,/CONSTRAIN)
        presInds      = VALUE_CLOSEST2(OMNIPRES.UTC,times,/CONSTRAIN)
        dstInds       = VALUE_CLOSEST2(DST__dst.time,times,/CONSTRAIN)
        aeInds        = VALUE_CLOSEST2(AE__ae.time,times,/CONSTRAIN)
        KpInds        = VALUE_CLOSEST2(KP__Kp.time,times,/CONSTRAIN)

        maxTDiff      = 90.
        maxDstTDiff   = 3600.
        IF (WHERE(ABS(OMNIB.UTC[magInds]-times      ) GT maxTDiff   ))[0] NE -1 OR $
           (WHERE(ABS(OMNISW.UTC[swInds]-times      ) GT maxTDiff*5 ))[0] NE -1 OR $
           (WHERE(ABS(OMNIPRES.UTC[presInds]-times  ) GT maxTDiff*5 ))[0] NE -1 OR $
           (WHERE(ABS(DST__Dst.time[dstInds]-times  ) GT maxDstTDiff))[0] NE -1 OR $
           (WHERE(ABS(AE__AE.time[AEInds]-times     ) GT maxDstTDiff))[0] NE -1 OR $
           (WHERE(ABS(KP__Kp.time[kpInds]-times     ) GT maxDstTDiff))[0] NE -1 $
        THEN BEGIN
           ;; STOP
           good_SW_dat = 0
        ENDIF ELSE $
           good_SW_dat   = 1 ;;Otherwise it's good


     END
  ENDCASE


  Bx            = OMNIB.Bx[magInds]
  IF KEYWORD_SET(GSE) THEN BEGIN
     phiClock   = OMNIB.GSE.phiClock[magInds]
     By         = OMNIB.GSE.By[magInds]
     Bz         = OMNIB.GSE.Bz[magInds]
  ENDIF ELSE BEGIN
     phiClock   = OMNIB.GSM.phiClock[magInds]
     By         = OMNIB.GSM.By[magInds]
     Bz         = OMNIB.GSM.Bz[magInds]
  ENDELSE

  IMF           = TRANSPOSE([[Bx],[By],[Bz]])

  swSpeed       = OMNISW.flow_speed[swInds]
  V_SW          = TRANSPOSE([[OMNISW.Vx[swInds]*(-1.D)], $
                             [OMNISW.Vy[swInds]], $
                             [OMNISW.Vz[swInds]]])
  ;; Vt            = Vt[swInds]

  press         = OMNIPRES.pressure[presInds]
  temp          = KELVIN_TO_EV(OMNIPRES.T[presInds])
  protDens      = OMNIPRES.proton_density[presInds]

  dstVal        = DST__Dst.dst[dstInds]
  AEVal         = AE__AE.AE[AEInds]
  KpVal         = KP__Kp.Kp[KpInds]

  struct        = {times : {FAST  : times, $
                            mag   : OMNIB.UTC[magInds], $
                            dst   : DST__Dst.time[dstInds], $
                            kp    : KP__Kp.time[KpInds], $
                            SWTP  : OMNIPRES.UTC[presInds]}, $
                   ;; Bx    : Bx, $
                   ;; By    : By, $
                   ;; Bz    : Bz, $
                   IMF    : TEMPORARY(IMF)      , $
                   clkAngle : TEMPORARY(phiClock), $
                   N      : TEMPORARY(protDens) , $
                   P      : TEMPORARY(press)    , $
                   T      : TEMPORARY(temp)     , $
                   V_SW   : TEMPORARY(V_SW)     , $
                   VSpeed : TEMPORARY(swSpeed)  , $
                   dst    : TEMPORARY(dstVal)   , $
                   AE     : TEMPORARY(AEVal)    , $
                   Kp     : TEMPORARY(KpVal), $
                   all_vals_twixt_t1_t2 : KEYWORD_SET(get_all_values_between_t1_and_t2)}
  CASE 1 OF
     KEYWORD_SET(get_all_values_between_t1_and_t2): BEGIN
        struct = CREATE_STRUCT(struct,"min_tDiffs",min_tDiffs)
     END
     ELSE: BEGIN
        struct = CREATE_STRUCT(struct,"valid",KEYWORD_SET(good_SW_dat))
     END
  ENDCASE
  
  IF KEYWORD_SET(reaberrate_vy) THEN BEGIN
     struct.v_SW[1,*] += 29.78   ;Re-aberrate Vy (you know, earth's orbital motion of ~30 km/s)
  ENDIF

  RETURN,struct
  
END
