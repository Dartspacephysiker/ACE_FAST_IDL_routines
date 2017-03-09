;;2016/11/07 Someday we'll do one for these quantities:
;proton_density
;T
;pressure
PRO MAKE_CULLED_OMNI_SWDATA_FILE

  COMPILE_OPT idl2,strictarrsubs

  dataDir              = '/SPENCEdata/Research/database/'

  ;;db in memory
  RESTORE,dataDir+'OMNI/sw_data.dat'

  ;;where to save data
  culledDataStr        = "OMNI/culled_OMNI_swdata.dat"


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

  ;;mag vals
  validVx                   = 2000.000
  validVy                   = 1000.000
  validVz                   =  100.000
  validSpeed                = 2000.000
  goodswvals_i              = WHERE((ABS(sw_data.Vx.dat)         LE validVx) AND $
                                    (ABS(sw_data.Vy.dat)         LE validVy) AND $
                                    (ABS(sw_data.Vz.dat)         LE validVz) AND $
                                    (ABS(sw_data.flow_speed.dat) LE validSpeed), $
                                    COMPLEMENT=bad_i)
  HELP,goodswvals_i
  ;;GOODSWVALS_I   LONG     = Array[4141549]

  goodsw_goodtimes_i        = CGSETINTERSECTION(goodswvals_i,goodtimes_i)
  HELP,goodsw_goodtimes_i
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
  mag_utc_sw                 = (sw_data.epoch.dat[goodsw_goodtimes_i]-62167219200000.0000D)/1000.0D
  PRINT,TIME_TO_STR(mag_utc_sw[0])

  ;;Now the GSE and GSM components
  ;;Remember, Vx is the same in both coord systems
  Vx                     = sw_data.Vx.dat[goodsw_goodtimes_i]
  Vy                     = sw_data.Vy.dat[goodsw_goodtimes_i]
  Vz                     = sw_data.Vz.dat[goodsw_goodtimes_i]
  flow_speed             = sw_data.flow_speed.dat[goodsw_goodtimes_i]
  ;;The foregoing should be all the ingredients for a new SW database

  ;;some derived stuff
  Vt                     = SQRT(Vy*Vy+Vz*Vz)

  ;;histos
  ;;cghistoplot,Vxy_over_Vz,maxinput=70,mininput=-70,xtitle="Sqrt(Vx^2+Vy^2)/Vz",title="Histogram of Vxy over Vz for ACE data, 1998-2000",output="Vxy_over_Vz.png"
  ;;cgHistoplot,cone_overClock,title="Distr. of cone angle over clock angle, 1998-2000",xtitle="cone over clock ratio",reverse_indices=ri,mininput=-1e2,maxinput=1e2,output="cone_overClock_zoomout.png"
  ;;cgHistoplot,180/!PI*phiClock,title="Distr. of IMF clock angles, 1998-2000",xtitle="IMF clock angle, degrees",output="IMFclockangle_histo.png"
  ;;cgHistoplot,180/!PI*thetaCone,title="Distr. of IMF cone angles, 1998-2000",xtitle="IMF cone angle, degrees",output="IMFconeangle_histo.png"

  HELP,culledDataStr,Vx,Vy,Vz,Vt,flow_speed,mag_utc_sw,goodsw_goodtimes_i

  PRINT,'Saving culled OMNI SW data to ' + culledDataStr
  SAVE,FILENAME=dataDir + culledDataStr, $
       Vx, $
       Vy, $
       Vz, $
       Vt, $
       flow_speed, $
       mag_utc_sw, $
       goodsw_goodtimes_i

  ;; sw_data_culled             = {VX:Vx, $
  ;;                               VY:Vy, $
  ;;                               VZ:Vz, $
  ;;                               VT:Vt, $
  ;;                               VXY_OVER_VZ:Vxy_over_Vz, $
  ;;                               MAG_UTC_SW:mag_utc_sw, $
  ;;                               GOODSW_GOODTIMES_I:goodsw_goodtimes_i}

  ;; PRINT,'Saving culled OMNI SW data struct to ' + culledDataStructStr
  ;; SAVE,sw_data_culled,FILENAME=culledDataStructStr

END