;2016/07/02 There is this some suggestion that the culled OMNI db I've been using is bogus. Let's find out
PRO JOURNAL__20160702__MAKE_SURE_CULLED_OMNI_DB_IS_OK

  dataDir              = '/SPENCEdata/Research/database/'

  ;;where to save data
  culledDataStr        = dataDir + "OMNI/culled_OMNI_magdata__20160702.dat"
  culledDataStructStr  = dataDir + 'OMNI/culled_OMNI_magdata_struct__20160702.dat'

  ;;The honker
  RESTORE,dataDir+'OMNI/sw_data.dat'
  fullT                = CDF_EPOCH_TO_UTC(sw_data.epoch.dat)
  
  PRINT,TIME_TO_STR(fullT[0])
  ;; 1996-08-01/00:00:00
  PRINT,TIME_TO_STR(fullT[-1])
  ;; 2004-12-31/23:59:00

  ;;The culled DB
  ;; RESTORE,dataDir + "/OMNI/culled_OMNI_magdata.dat"
  ;; cullT                = TEMPORARY(mag_UTC)


  ;;Times that IAW data are good, Oct 1996 to Nov 1999
  maxTime              = STR_TO_TIME('1999-11-03/03:21:00.000')
  ;; maxTime           = STR_TO_TIME('2000-10-06/00:08:46.938')
  minTime              = STR_TO_TIME('1996-10-06/16:26:02.0')


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;How many in fullT?
  fullT_i              = WHERE((fullT LE maxTime) AND (fullT GE minTime),nFullT, $
                               /NULL, $
                               NCOMPLEMENT=nNotAlfvenDB)

  PRINT,nFullT/60./24./365
  ;;       3.0752187
  ;;That's the right answer!!!!

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;How many in cullT?
  ;; cullT_i              = WHERE((cullT LE maxTime) AND (cullT GE minTime),nCullT, $
  ;;                              /NULL, $
  ;;                              NCOMPLEMENT=nNotAlfvenDB)

  ;; PRINT,nCullT/60./24./365
  ;;        2.84773
  ;;That's the wrong answer!!!!


  ;; goodmagvals_i     = WHERE((ABS(sw_data.bx_gse.dat) LE 99.9) AND (ABS(sw_data.by_gsm.dat) LE 99.9) AND (ABS(sw_data.bz_gsm.dat) LE 99.9) AND (ABS(sw_data.by_gse.dat) LE 99.9) AND (ABS(sw_data.bz_gse.dat) LE 99.9))
  help,goodmagvals_i
  ;;GOODMAGVALS_I   LONG  EQ Array[4141549]

  goodmag_goodtimes_i  = fullT_i

  ;;mag_utc
  mag_utc              = CDF_EPOCH_TO_UTC(sw_data.epoch.dat[goodmag_goodtimes_i])

  ;;Now the GSE and GSM components
  ;;Remember, Bx is the same in both coord systems
  Bx                   = sw_data.bx_gse.dat[fullT_i]
  By_GSE               = sw_data.by_gse.dat[fullT_i]
  Bz_GSE               = sw_data.bz_gse.dat[fullT_i]
  By_GSM               = sw_data.by_gsm.dat[fullT_i]
  Bz_GSM               = sw_data.bz_gsm.dat[fullT_i]

  ;;The foregoing should be all the ingredients for a new SW database

  ;;some derived stuff
  Bt_GSE               = SQRT(By_GSE*By_GSE+Bz_GSE*Bz_GSE)
  phiClock_GSE         = ATAN(By_GSE,Bz_GSE)
  thetaCone_GSE        = ACOS(ABS(Bx)/SQRT(Bx*Bx+By_GSE*By_GSE+Bz_GSE*Bz_GSE))
  Bxy_over_Bz_GSE      = SQRT(Bx*Bx+By_GSE*By_GSE)/ABS(Bz_GSE)
  cone_overClock_GSE   = thetaCone_GSE/phiClock_GSE

  ;;now GSM
  Bt_GSM               = SQRT(By_GSM*By_GSM+Bz_GSM*Bz_GSM)
  phiClock_GSM         = ATAN(By_GSM,Bz_GSM)
  thetaCone_GSM        = ACOS(ABS(Bx)/SQRT(Bx*Bx+By_GSM*By_GSM+Bz_GSM*Bz_GSM))
  Bxy_over_Bz_GSM      = SQRT(Bx*Bx+By_GSM*By_GSM)/ABS(Bz_GSM)
  cone_overClock_GSM   = thetaCone_GSM/phiClock_GSM

  ;;histos
  ;;cghistoplot,bxy_over_bz,maxinput=70,mininput=-70,xtitle="Sqrt(Bx^2+By^2)/Bz",title="Histogram of Bxy over Bz for ACE data, 1998-2000",output="bxy_over_bz.png"
  ;;cgHistoplot,cone_overClock,title="Distr. of cone angle over clock angle, 1998-2000",xtitle="cone over clock ratio",reverse_indices=ri,mininput=-1e2,maxinput=1e2,output="cone_overClock_zoomout.png"
  ;;cgHistoplot,180/!PI*phiClock,title="Distr. of IMF clock angles, 1998-2000",xtitle="IMF clock angle, degrees",output="IMFclockangle_histo.png"
  ;;cgHistoplot,180/!PI*thetaCone,title="Distr. of IMF cone angles, 1998-2000",xtitle="IMF cone angle, degrees",output="IMFconeangle_histo.png"

  HELP,culledDataStr,Bx,By_GSE,By_GSM,Bz_GSE,Bz_GSM,Bt_GSE,Bt_GSM,phiClock_GSE,phiClock_GSM,thetaCone_GSE,thetaCone_GSM, $
       cone_overClock_GSE,cone_overClock_GSM,bxy_over_bz_GSE,Bxy_over_Bz_GSM,mag_utc,goodmag_goodtimes_i

  PRINT,'Saving culled OMNI data to ' + culledDataStr
  SAVE,FILENAME=culledDataStr, $
       Bx, $
       By_GSE,By_GSM, $
       Bz_GSE,Bz_GSM, $
       Bt_GSE,Bt_GSM, $
       phiClock_GSE,phiClock_GSM, $
       thetaCone_GSE,thetaCone_GSM, $
       cone_overClock_GSE,cone_overClock_GSM, $
       bxy_over_bz_GSE,Bxy_over_Bz_GSM, $
       mag_utc, $
       goodmag_goodtimes_i

  sw_data_culled       = {BX:Bx, $
                          BY_GSE:By_GSE, $
                          BY_GSM:By_GSM, $
                          BZ_GSE:Bz_GSE, $
                          BZ_GSM:Bz_GSM, $
                          BT_GSE:Bt_GSE, $
                          BT_GSM:Bt_GSM, $
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
  SAVE,sw_data_culled,FILENAME=culledDataStructStr



END