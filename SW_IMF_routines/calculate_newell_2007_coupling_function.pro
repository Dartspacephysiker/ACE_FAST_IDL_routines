;;11/07/16
FUNCTION CALCULATE_NEWELL_COUPLING_FUNCTION, $
   swSpeed_Avg,Bt_Avg,phiClock_avg, $
   swSpeed_StdDev,Bt_StdDev,phiClock_StdDev, $   
   INC_STDDEV=inc_stdDev, $
   CALC_FROM_COMMON_VARS=calc_from_common_vars, $
   OUT_SW_SPEED=sw_speed

  COMPILE_OPT IDL2

  @common__omni_stability.pro

  dataDir                = "/SPENCEdata/Research/database/OMNI/"
  culledSWDataStr        = "culled_OMNI_swdata.dat"

  RESTORE,dataDir + culledSWDataStr

  CASE 1 OF
     KEYWORD_SET(calc_from_common_vars): BEGIN
        ;;First find out where things match
        stable_SW_i      = VALUE_CLOSEST2(mag_UTC_sw,c_omni__mag_UTC[C_OMNI__stable_i])
        stable_SW_ii     = WHERE(ABS(mag_UTC_sw[stable_SW_i] - $
                                     C_OMNI__mag_UTC[C_OMNI__stable_i]) LE 60.,nStableSW)
        stable_SW_i      = stable_SW_i[stable_SW_ii]

        PRINT,FORMAT='("Got ",I0," SW points for Kan-Lee coupling calc")',nStableSW

        swSpeed_Avg      = MEAN(flow_speed[stable_SW_i])   * 1000.D ;m/s
        swSpeed_StdDev   = STDDEV(flow_speed[stable_SW_i]) * 1000.D ;m/s

        Bt_Avg           = MEAN(C_OMNI__Bt[C_OMNI__stable_i])   * 1.0e-9 ;nT!
        Bt_StdDev        = STDDEV(C_OMNI__Bt[C_OMNI__stable_i]) * 1.0e-9 ;nT!

        tmpangle          = C_OMNI__phiClock[C_OMNI__stable_i]

        ;;This must be bzSouth if true, since nAngles le -90 within factor of 2 of angles ge 90
        IF ABS(ALOG10(N_ELEMENTS(WHERE(tmpAngle LE -90.,nNegAngles))) - $
               ALOG10(N_ELEMENTS(WHERE(tmpAngle GE 90.,nPosAngles)))) LE 0.3 THEN BEGIN
           IF (nPosAngles GE 5) AND (nNegAngles GE 5) THEN BEGIN
              PRINT,'Sneg'
              tmpangle[WHERE(tmpAngle LT 0)] += 360.
           ENDIF
        ENDIF ELSE BEGIN
           PRINT,'Spos'
        ENDELSE
        ;; phiClock_avg     = MEAN(C_OMNI__phiClock[C_OMNI__stable_i])
        ;; phiClock_stdDev  = STDDEV(C_OMNI__phiClock[C_OMNI__stable_i])
        phiClock_avg     = MEAN(tmpAngle)
        phiClock_stdDev  = STDDEV(tmpAngle)


     END
     ELSE: BEGIN

     END
  ENDCASE

  KL_EField_Avg       = ABS(swSpeed_Avg) * Bt_Avg * (SIN(phiClock_Avg * !DTOR / 2.))^2 * 1000. ;mV/m
  IF KEYWORD_SET(inc_stdDev) THEN BEGIN
     KL_EField_StdDev = SQRT( $
                        ( Bt_Avg * (SIN(phiClock_Avg*!DTOR/2.))^2 )^2 * swSpeed_stdDev^2 + $
                        ( swSpeed_Avg * (SIN(phiClock_Avg*!DTOR/2.))^2 )^2 * Bt_stdDev^2 + $
                        ( Bt_Avg * swSpeed_Avg * SIN(phiClock_Avg*!DTOR/2.) * COS(phiClock_Avg*!DTOR/2.) )^2 * phiClock_stdDev^2 $
                            ) * 1000.
                        
     sw_speed = [swSpeed_Avg,swSpeed_StdDev]
     RETURN,[KL_EField_Avg,KL_EField_StdDev]
  ENDIF

  sw_speed = swSpeed_Avg
  RETURN,KL_EField_Avg


END
