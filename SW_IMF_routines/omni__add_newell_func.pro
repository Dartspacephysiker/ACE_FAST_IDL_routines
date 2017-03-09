PRO OMNI__ADD_NEWELL_FUNC,goodmag_goodtimes_i

  COMPILE_OPT idl2,strictarrsubs

  @common__omni_stability.pro

  ;;Get SW flow data
  dataDir             = "/SPENCEdata/Research/database/OMNI/"
  culledSWDataStr     = "culled_OMNI_swdata.dat"

  RESTORE,dataDir + culledSWDataStr

  nMagUTC             = N_ELEMENTS(C_OMNI__mag_UTC)
  C_OMNI__NewellFunc  = MAKE_ARRAY(nMagUTC,VALUE=!VALUES.F_NAN,/FLOAT)
  SWMag_i             = VALUE_CLOSEST2(mag_UTC_sw,C_OMNI__mag_UTC)
  SWMag_ii            = WHERE(ABS(mag_UTC_sw[SWMag_i]-C_OMNI__mag_UTC) LT 60.,nGood_SWMag)
  IF nGood_SWMag EQ 0 THEN BEGIN
     PRINT,"Hosed!! Looks like there's no place for SW data and IMF mag data to line up. "
     STOP
  ENDIF

  ;;Now the opposite--inds for mag data
  magSW_i             = VALUE_CLOSEST2(C_OMNI__mag_UTC,mag_UTC_sw)
  magSW_ii            = WHERE(ABS(mag_UTC_sw-C_OMNI__mag_UTC[magSW_i]) LT 60.,nGood_magSW)

  good_SWMag_i                      = SWMag_i[SWMag_ii]
  good_magSW_i                      = magSW_i[magSW_ii]
  C_OMNI__NewellFunc[good_magSW_i]  = (flow_speed[good_SWMag_i] )^(4.D/3.D)*(1.D4)*$ ;Flow speed in m/s ( (1.D3)^(4./3.) = 1.D4)
                                      (C_OMNI__Bt[good_magSW_i] )^(2.D/3.D)*(1.D-6)*$ ;magField in nT! ( (1.D-9)^(2./3.) = 1.D-6 )
                                      ABS(SIN(C_OMNI__phiClock[good_magSW_i]*!DTOR/2.D))^(8.D/3.D)

END