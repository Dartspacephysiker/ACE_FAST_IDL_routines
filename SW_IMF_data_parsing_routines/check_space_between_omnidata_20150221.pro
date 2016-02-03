;02/21/2015
;This new OMNI dataset appears to have super coverage of time, since it integrates data from several
;satellites monitoring the SW. I'm just checking to see how important my space checking stuff
;in check_imf_stability.pro is.
;
;02/23/2015 This script was used to handle the culling and saving of OMNI data as well. 
; It covers 08-01-1996/0:00:00 - 12-31-2004/23:59:00
;
;2016/01/26
; Hold the phone! I culled a bunch of the mag values with goodmag_goodtimes_i, but I never culled mag_utc! Isn't that crazy?
; There will not have been a single instance of proper correlation of SW stuff with the Alfvén wave DB to this date as a result!
; I'm fixing it now... 

PRO CHECK_SPACE_BETWEEN_OMNIDATA_20150221

  ;;db in memory
  restore,dataDir+'sw_omnidata/sw_data.dat'

  ;;where to save data
  culledDataStr="/SPENCEdata/Research/Cusp/database/processed/culled_OMNI_magdata.dat"
  culledDataStructStr='/SPENCEdata/Research/Cusp/database/processed/culled_OMNI_magdata_struct.dat'
  ;;culledDataStr=dataDir + "/processed/culled_OMNI_magdata.dat"

  ;;time between observations thing
  help,sw_data.time_btwn_obs

  ;;simplify life
  tbo=sw_data.time_btwn_obs.dat

  ;;total num elements
  print,n_elements(tbo)
  ;;4428000

  print,n_elements(where(tbo GT 1e5))
  ;;346852--yeesh

  ;;n spaces greater than 10 min
  print,n_elements(where(tbo GT 600))
  ;;;398142--OK, lots

  ;;;OK, now I see...
  print,n_elements(where(tbo EQ 999999))
  ;;346852

  ;;Right, it all adds up now...
  print,sw_data.time_btwn_obs.fillval
  ;;999999

  ;;but there is still some garbage in there
  ;;I need to cull this db
  print,n_elements(where(tbo GT 10000 AND tbo LT 999999))
  ;;116

  ;;Disturbingly, this number isn't equal to the number of bad time_btwn_obs vals
  print,n_elements(where(sw_data.by_gsm.dat EQ 9999.99))
  ;;286451

  ;;all right, cull 'em
  ;;times
  goodtimes_i=where(ABS(sw_data.time_btwn_obs.dat) LE 10000)
  help,goodtimes_i
  ;;GOODTIMES_I     LONG      = Array[4080915]

  ;;mag vals
  goodmagvals_i=where((abs(sw_data.bx_gse.dat) LE 99.9) AND (abs(sw_data.by_gsm.dat) LE 99.9) AND (abs(sw_data.bz_gsm.dat) LE 99.9) AND (abs(sw_data.by_gse.dat) LE 99.9) AND (abs(sw_data.bz_gse.dat) LE 99.9))
  help,goodmagvals_i
  ;;GOODMAGVALS_I   LONG      = Array[4141549]

  goodmag_goodtimes_i=cgsetintersection(goodmagvals_i,goodtimes_i)
  help,goodmag_goodtimes_i
  ;;GOODMAG_GOODTIME_I LONG      = Array[4080915]

  ;;;here is the way to check out a time with this silly SPDF epoch format thing
  biz=CDF_EPOCH_TOJULDAYS(sw_data.epoch.dat[1004], /string)
  print,biz
  ;;1996-08-01T16:44:00.000

  ;;pure gold
  t_to_1970=62167219200000.0000D
  biz=CDF_EPOCH_TOJULDAYS(t_to_1970, /string) & print,biz
  ;;1970-01-01T00:00:00.000

  ;;times in a way that is proper for time_to_str
  mag_utc=(sw_data.epoch.dat[goodmag_goodtimes_i]-62167219200000.0000D)/1000.0D
  print,time_to_str(mag_utc[0])

  ;;Now the GSE and GSM components
  ;;Remember, Bx is the same in both coord systems
  Bx=sw_data.bx_gse.dat[goodmag_goodtimes_i]
  By_GSE=sw_data.by_gse.dat[goodmag_goodtimes_i]
  Bz_GSE=sw_data.bz_gse.dat[goodmag_goodtimes_i]
  By_GSM=sw_data.by_gsm.dat[goodmag_goodtimes_i]
  Bz_GSM=sw_data.bz_gsm.dat[goodmag_goodtimes_i]

  ;;The foregoing should be all the ingredients for a new SW database

  ;;some derived stuff
  phiClock_GSE=ATAN(By_GSE,Bz_GSE)
  thetaCone_GSE=ACOS(abs(Bx)/SQRT(Bx*Bx+By_GSE*By_GSE+Bz_GSE*Bz_GSE))
  Bxy_over_Bz_GSE=sqrt(Bx*Bx+By_GSE*By_GSE)/abs(Bz_GSE)
  cone_overClock_GSE=thetaCone_GSE/phiClock_GSE

  ;;now GSM
  phiClock_GSM=ATAN(By_GSM,Bz_GSM)
  thetaCone_GSM=ACOS(abs(Bx)/SQRT(Bx*Bx+By_GSM*By_GSM+Bz_GSM*Bz_GSM))
  Bxy_over_Bz_GSM=sqrt(Bx*Bx+By_GSM*By_GSM)/abs(Bz_GSM)
  cone_overClock_GSM=thetaCone_GSM/phiClock_GSM

  ;;histos
  ;;cghistoplot,bxy_over_bz,maxinput=70,mininput=-70,xtitle="Sqrt(Bx^2+By^2)/Bz",title="Histogram of Bxy over Bz for ACE data, 1998-2000",output="bxy_over_bz.png"
  ;;cgHistoplot,cone_overClock,title="Distr. of cone angle over clock angle, 1998-2000",xtitle="cone over clock ratio",reverse_indices=ri,mininput=-1e2,maxinput=1e2,output="cone_overClock_zoomout.png"
  ;;cgHistoplot,180/!PI*phiClock,title="Distr. of IMF clock angles, 1998-2000",xtitle="IMF clock angle, degrees",output="IMFclockangle_histo.png"
  ;;cgHistoplot,180/!PI*thetaCone,title="Distr. of IMF cone angles, 1998-2000",xtitle="IMF cone angle, degrees",output="IMFconeangle_histo.png"

  help,culledDataStr,Bx,By_GSE,By_GSM,Bz_GSE,Bz_GSM,phiClock_GSE,phiClock_GSM,thetaCone_GSE,thetaCone_GSM, $
       cone_overClock_GSE,cone_overClock_GSM,bxy_over_bz_GSE,Bxy_over_Bz_GSM,mag_utc,goodmag_goodtimes_i

  PRINT,'Saving culled OMNI data to ' + culledDataStr
  save,filename=culledDataStr,Bx,By_GSE,By_GSM,Bz_GSE,Bz_GSM,phiClock_GSE,phiClock_GSM,thetaCone_GSE,thetaCone_GSM, $
       cone_overClock_GSE,cone_overClock_GSM,bxy_over_bz_GSE,Bxy_over_Bz_GSM,mag_utc,goodmag_goodtimes_i

  sw_data_culled                 = {BX:Bx, $
                                    BY_GSE:By_GSE, $
                                    BZ_GSE:Bz_GSE, $
                                    BZ_GSM:Bz_GSM, $
                                    PHICLOCK_GSE:phiClock_GSE, $
                                    PHICLOCK_GSM:phiClock_GSM, $
                                    THETACONE_GSE:thetaCone_GSE, $
                                    THETACONE_GSM:thetaCone_GSM, $
                                    CONE_OVERCLOCK_GSE:cone_overClock_GSE, $
                                    CONE_OVERCLOCK_GSM:cone_overClock_GSM, $
                                    BXY_OVER_BZ_GSE:bxy_over_bz_GSE, $
                                    BXY_OVER_BZ_GSM:Bxy_over_Bz_GSM, $
                                    MAG_UTC:mag_utc, $
                                    GOODMAG_GOODTIMES_I:goodmag_goodtimes_i}

  PRINT,'Saving culled OMNI data struct to ' + culledDataStructStr
  save,sw_data_culled,FILENAME=culledDataStructStr

END