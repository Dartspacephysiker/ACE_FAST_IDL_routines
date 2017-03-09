;;2017/01/27 Dagen har kommet
PRO MAKE_CULLED_OMNI_DENS_PRESSURE_TEMP_FILE

  COMPILE_OPT idl2,strictarrsubs

  dataDir              = '/SPENCEdata/Research/database/'

  ;;db in memory
  RESTORE,dataDir+'OMNI/sw_data.dat'

  ;;where to save data
  culledDataStr        = "OMNI/culled_OMNI_densPressTempData.dat"


  ;;where to get mag data, good mag things
  culledMagDataStr     = "OMNI/culled_OMNI_magdata.dat"
  RESTORE,dataDir + culledMagDataStr
  ;;Undefine everyone but goodmag_goodtimes_i
  
  Bx                  = !NULL
  By_GSE              = !NULL
  Bz_GSE              = !NULL
  Bt_GSE              = !NULL
  By_GSM              = !NULL
  Bz_GSM              = !NULL
  Bt_GSM              = !NULL
  mag_utc             = !NULL

  ;;time between observations thing
  HELP,sw_data.time_btwn_obs

  ;;simplify life
  tbo                  = sw_data.time_btwn_obs.dat

  ;;total num elements
  print,N_ELEMENTS(tbo)
  ;;4428000

  print,N_ELEMENTS(WHERE(tbo GT 1e5))
  ;;346852--yeesh

  ;;n spaces greater than 10 min
  print,N_ELEMENTS(WHERE(tbo GT 600))
  ;;;398142--OK, lots

  ;;;OK, now I see...
  print,N_ELEMENTS(WHERE(tbo EQ 999999))
  ;;346852

  ;;Right, it all adds up now...
  print,sw_data.time_btwn_obs.fillval
  ;;999999

  ;;but there is still some garbage in there
  ;;I need to cull this db
  print,N_ELEMENTS(WHERE(tbo GT 10000 AND tbo LT 999999))
  ;;116

  ;;Disturbingly, this number isn't equal to the number of bad time_btwn_obs vals
  print,N_ELEMENTS(WHERE(sw_data.Vy.dat EQ 9999.99))
  ;;286451

  ;;all right, cull 'em
  ;;times
  goodtimes_i                = WHERE(ABS(sw_data.time_btwn_obs.dat) LE 10000)
  HELP,goodtimes_i
  ;;GOODTIMES_I     LONG     = Array[4080915]

  indsWeWant = [20:26] ;PROTON_DENSITY, T, PRESSURE, E, BETA, MACH_NUM, MGS_MACH_NUM
  tagsWeWant = (TAG_NAMES(sw_data))[indsWeWant]
  PRINT,(TAG_NAMES(sw_data))[indsWeWant]
  validmax = !NULL
  validmin = !NULL
  goodSWTP_i = goodtimes_i
  goingRate = N_ELEMENTS(sw_data.(indsWeWant[0]).dat)
  FOR k=0,N_ELEMENTS(indsWeWant)-1 DO BEGIN
     ind = indsWeWant[k]

     IF N_ELEMENTS(sw_data.(ind).dat) NE goingRate THEN STOP
     
     validMax = [validMax,sw_data.(ind).validMax]
     validMin = [validMin,sw_data.(ind).validMin]

     goodSWTP_i = CGSETINTERSECTION(goodSWTP_i, $
                                    WHERE((sw_data.(ind).dat LE validMax[-1]) AND $
                                          (sw_data.(ind).dat GE validMin[-1]) AND $
                                          (FINITE(sw_data.(ind).dat))             ), $
                                    COUNT=nValid)
     IF nValid LT 1000000 THEN STOP
  ENDFOR

  HELP,goodSWTP_i
  ;;GOODSWTP_I   LONG     = Array[4141549]

  ;; goodsw_goodtimes_i        = CGSETINTERSECTION(goodSWTP_i,goodtimes_i)
  ;; HELP,goodsw_goodtimes_i
  ;;GOODSW_GOODTIME_I LONG  = Array[4080915]

  ;;;here is the way to check out a time with this silly SPDF epoch format thing
  biz                        = CDF_EPOCH_TOJULDAYS(sw_data.epoch.dat[1004],/STRING)
  print,biz
  ;;1996-08-01T16:44:00.000

  ;;pure gold
  t_to_1970                  = 62167219200000.0000D
  biz                        = CDF_EPOCH_TOJULDAYS(t_to_1970,/STRING)
  PRINT,biz
  ;;1970-01-01T00:00:00.000

  ;;times in a way that is proper for time_to_str
  mag_UTC_SWTP      = (sw_data.epoch.dat[goodSWTP_i]-62167219200000.0000D)/1000.0D
  PRINT,TIME_TO_STR(mag_UTC_SWTP[0])

  ;;Now the GSE and GSM components
  ;;Remember, Vx is the same in both coord systems
  proton_density  = sw_data.proton_density.dat[goodSWTP_i]
  T               = sw_data.T.dat[goodSWTP_i]
  pressure        = sw_data.pressure.dat[goodSWTP_i]
  eField          = sw_data.E.dat[goodSWTP_i]
  beta            = sw_data.beta.dat[goodSWTP_i]
  mach_num        = sw_data.mach_num.dat[goodSWTP_i]
  mgs_mach_num    = sw_data.mgs_mach_num.dat[goodSWTP_i]
  ;;The foregoing should be all the ingredients for a new SW database

  ;;histos
  ;;cghistoplot,proton_densityy_over_pressure,maxinput=70,mininput=-70,xtitle="Sqrt(proton_density^2+T^2)/pressure",title="Histogram of proton_densityy over pressure for ACE data, 1998-2000",output="proton_densityy_over_pressure.png"
  ;;cgHistoplot,cone_overClock,title="Distr. of cone angle over clock angle, 1998-2000",xtitle="cone over clock ratio",reverse_indices=ri,mininput=-1e2,maxinput=1e2,output="cone_overClock_zoomout.png"
  ;;cgHistoplot,180/!PI*phiClock,title="Distr. of IMF clock angles, 1998-2000",xtitle="IMF clock angle, degrees",output="IMFclockangle_histo.png"
  ;;cgHistoplot,180/!PI*thetaCone,title="Distr. of IMF cone angles, 1998-2000",xtitle="IMF cone angle, degrees",output="IMFconeangle_histo.png"

  HELP,culledDataStr,proton_density,T,pressure,eField,beta,mach_num,mgs_mach_num,mag_UTC_SWTP,goodSWTP_i

  PRINT,'Saving culled OMNI SW data to ' + culledDataStr
  SAVE,FILENAME=dataDir + culledDataStr, $
       proton_density, $
       T, $
       pressure, $
       eField, $
       beta, $
       mach_num, $
       mgs_mach_num, $
       mag_UTC_SWTP, $
       goodSWTP_i

  ;; sw_data_culled             = {PROTON_DENSITY:proton_density, $
  ;;                               T:T, $
  ;;                               PRESSURE:pressure, $
  ;;                               VT:Vt, $
  ;;                               PROTON_DENSITYY_OVER_PRESSURE:proton_densityy_over_pressure, $
  ;;                               MAG_UTC_SWTP:mag_UTC_SWTP, $
  ;;                               GOODSWTP_I:goodSWTP_i}

  ;; PRINT,'Saving culled OMNI SW data struct to ' + culledDataStructStr
  ;; SAVE,sw_data_culled,FILENAME=culledDataStructStr

END