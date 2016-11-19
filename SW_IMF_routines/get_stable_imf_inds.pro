;;2016/02/18 This thing has to be overhauled. I don't know exactly what the old one was doing.
;; This function either creates or loads the properfile to get IMF stability
;; "Stable" is defined here as a period of time over which the specified conditions/params remain met
FUNCTION GET_STABLE_IMF_INDS, $
   MAG_UTC=mag_utc, $
   CLOCKSTR=clockStr, $
   ANGLELIM1=angleLim1, $
   ANGLELIM2=angleLim2, $
   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
   STABLEIMF=stableIMF, $
   SMOOTH_IMF=smooth_IMF, $
   ;; RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
   EARLIEST_UTC=earliest_UTC, $
   LATEST_UTC=latest_UTC, $
   USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
   EARLIEST_JULDAY=earliest_julDay, $
   LATEST_JULDAY=latest_julDay, $
   BYMIN=byMin, $
   BYMAX=byMax, $
   BZMIN=bzMin, $
   BZMAX=bzMax, $
   BTMIN=btMin, $
   BTMAX=btMax, $
   BXMIN=bxMin, $
   BXMAX=bxMax, $
   DO_ABS_BYMIN=abs_byMin, $
   DO_ABS_BYMAX=abs_byMax, $
   DO_ABS_BZMIN=abs_bzMin, $
   DO_ABS_BZMAX=abs_bzMax, $
   DO_ABS_BTMIN=abs_btMin, $
   DO_ABS_BTMAX=abs_btMax, $
   DO_ABS_BXMIN=abs_bxMin, $
   DO_ABS_BXMAX=abs_bxMax, $
   BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
   BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
   RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
   RESET_OMNI_INDS=reset_omni_inds, $
   GET_BX=get_Bx, $
   GET_BY=get_By, $
   GET_BZ=get_Bz, $
   GET_BT=get_Bt, $
   GET_THETACONE=get_thetaCone, $
   GET_CLOCKANGLE=get_clockAngle, $
   GET_CONE_OVERCLOCK=get_cone_overClock, $
   GET_BXY_OVER_BZ=get_Bxy_over_Bz, $
   BX_OUT=bx_out,$
   BY_OUT=by_out,$
   BZ_OUT=bz_out,$
   BT_OUT=bt_out,$
   THETACONE_OUT=thetaCone_out, $
   CLOCKANGLE_OUT=clockAngle_out, $
   CONE_OVERCLOCK_OUT=cone_overClock_out, $
   BXY_OVER_BZ_OUT=Bxy_over_Bz_out, $
   OMNI_COORDS=OMNI_coords, $
   OMNI_PARAMSTR=omni_paramStr, $
   PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
   PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
   PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
   SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
   MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
   CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
   LUN=lun
  
  COMPILE_OPT idl2

  ;;This and GET_ALFVEN_OR_FASTLOC_INDS_MEETING_OMNI_REQUIREMENTS should be the only two routines that have a full definition of this block
  @common__omni_stability.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun  = -1

  IF KEYWORD_SET(reset_omni_inds) THEN BEGIN
     PRINT,"Resetting OMNI inds..."
     RESET_OMNI_INDS
  ENDIF
  IF N_ELEMENTS(C_OMNI__HAVE_STABLE_INDS) GT 0 THEN BEGIN
     IF ~C_OMNI__HAVE_STABLE_INDS THEN BEGIN
        calculate                   = 1 
        C_OMNI__HAVE_STABLE_INDS    = 0
        C_OMNI__STABLE_I            = !NULL
     ENDIF ELSE BEGIN

        ;;Do we need to recalculate anyway?
        CHECK_FOR_NEW_OMNI_CONDS,MAG_UTC=mag_utc, $
                                 CLOCKSTR=clockStr, $
                                 ANGLELIM1=angleLim1, $
                                 ANGLELIM2=angleLim2, $
                                 DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                 STABLEIMF=stableIMF, $
                                 RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                 BYMIN=byMin, $
                                 BYMAX=byMax, $
                                 BZMIN=bzMin, $
                                 BZMAX=bzMax, $
                                 BTMIN=btMin, $
                                 BTMAX=btMax, $
                                 BXMIN=bxMin, $
                                 BXMAX=bxMax, $
                                 DO_ABS_BYMIN=abs_byMin, $
                                 DO_ABS_BYMAX=abs_byMax, $
                                 DO_ABS_BZMIN=abs_bzMin, $
                                 DO_ABS_BZMAX=abs_bzMax, $
                                 DO_ABS_BTMIN=abs_btMin, $
                                 DO_ABS_BTMAX=abs_btMax, $
                                 DO_ABS_BXMIN=abs_bxMin, $
                                 DO_ABS_BXMAX=abs_bxMax, $
                                 RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                                 BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
                                 BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
                                 OMNI_COORDS=OMNI_coords, $
                                 LUN=lun
        
        calculate                   = C_OMNI__RECALCULATE
        IF N_ELEMENTS(C_OMNI__stable_i) EQ 0 THEN BEGIN
           PRINTF,lun,"Impossible! You said this was calculated ..."
           STOP
        ENDIF
     ENDELSE
  ENDIF ELSE BEGIN
     calculate                      = 1
  ENDELSE

  IF calculate THEN BEGIN
     PRINTF,lun,"****BEGIN GET_STABLE_IMF_INDS****"
     PRINTF,lun,"Calculating stable IMF inds for this run..."
     C_OMNI__paramStr  = 'OMNI_params'
     C_OMNI__stableStr = 'OMNI_stability'
     
     ;;********************************************************
     ;;Restore ACE/OMNI data
     ;; IF N_ELEMENTS(mag_utc) EQ 0 THEN BEGIN
     PRINTF,lun,'Restoring culled OMNI data to get mag_utc ...'
     dataDir           = "/SPENCEdata/Research/database/OMNI/"
     culledDataStr     = "culled_OMNI_magdata.dat"

     RESTORE,dataDir + culledDataStr
     ;; RESTORE,dataDir + "/OMNI/culled_OMNI_magdata__20160702.dat"
     ;; ENDIF

     C_OMNI__mag_UTC   = TEMPORARY(mag_UTC)

     OMNI__SELECT_COORDS,Bx, $
                         By_GSE,Bz_GSE,Bt_GSE, $
                         thetaCone_GSE,phiClock_GSE,cone_overClock_GSE,Bxy_over_Bz_GSE, $
                         By_GSM,Bz_GSM,Bt_GSM, $
                         thetaCone_GSM,phiClock_GSM,cone_overClock_GSM,Bxy_over_Bz_GSM, $
                         OMNI_COORDS=OMNI_coords, $
                         LUN=lun

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Do the cleaning

     C_OMNI__clean_i = GET_CLEAN_OMNI_I(C_OMNI__Bx,C_OMNI__By,C_OMNI__Bz, $
                                        LUN=lun)
     ;; clean_i                     = WHERE((ABS(bx_gse) LE 99.9) AND $
     ;;                                                   (ABS(by_gsm) LE 99.9) AND $
     ;;                                                   (ABS(bz_gsm) LE 99.9) AND $
     ;;                                                   (ABS(by_gse) LE 99.9) AND $
     ;;                                                   (ABS(bz_gse) LE 99.9))

     
     IF KEYWORD_SET(restrict_OMNI_with_these_i) THEN BEGIN

        C_OMNI__restrict_i = restrict_OMNI_with_these_i

     ENDIF
     ;;Don't clean here! These will get cleaned as part of COMBINE_OMNI_IMF_INDS
     ;; C_OMNI__By                     = C_OMNI__By[C_OMNI__clean_i]            
     ;; C_OMNI__Bz                     = C_OMNI__Bz[C_OMNI__clean_i]            
     ;; C_OMNI__Bt                     = C_OMNI__Bt[C_OMNI__clean_i]            
     ;; C_OMNI__thetaCone              = C_OMNI__thetaCone[C_OMNI__clean_i]     
     ;; C_OMNI__phiClock               = C_OMNI__phiClock[C_OMNI__clean_i]      
     ;; C_OMNI__cone_overClock         = C_OMNI__cone_overClock[C_OMNI__clean_i]
     ;; C_OMNI__Bxy_over_Bz            = C_OMNI__Bxy_over_Bz[C_OMNI__clean_i]
     ;; C_OMNI__mag_UTC                = C_OMNI__mag_UTC[C_OMNI__clean_i]
     ;; goodmag_goodtimes_i            = goodmag_goodtimes_i[C_OMNI__clean_i]

     ;;Any smoothing to be done?
     IF KEYWORD_SET(smooth_IMF) THEN BEGIN
        SMOOTH_OMNI_IMF,goodmag_goodtimes_i,smooth_IMF, $
                        BYMIN=byMin, $
                        BYMAX=byMax, $
                        BZMIN=bzMin, $
                        BZMAX=bzMax, $
                        BTMIN=btMin, $
                        BTMAX=btMax, $
                        BXMIN=bxMin, $
                        BXMAX=bxMax
     ENDIF

     C_OMNI__time_i = GET_OMNI_TIME_I(C_OMNI__mag_UTC, $
                                      ;; RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                      EARLIEST_UTC=earliest_UTC, $
                                      LATEST_UTC=latest_UTC, $
                                      USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
                                      EARLIEST_JULDAY=earliest_julDay, $
                                      LATEST_JULDAY=latest_julDay, $
                                      LUN=lun)

     IF KEYWORD_SET(clockStr) THEN BEGIN
        SET_IMF_CLOCK_ANGLE,CLOCKSTR=clockStr,IN_ANGLE1=angleLim1,IN_ANGLE2=AngleLim2, $
                            DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles

        GET_IMF_CLOCKANGLE_INDS,C_OMNI__phiClock, $
                                CLOCKSTR=clockStr, $
                                ANGLELIM1=angleLim1, $
                                ANGLELIM2=angleLim2, $
                                LUN=lun
        USE_COMBINED_INDS           = 1
     ENDIF

     IF N_ELEMENTS(byMin) GT 0 OR N_ELEMENTS(byMax) GT 0 $
        OR N_ELEMENTS(bzMin) GT 0 OR N_ELEMENTS(bzMax) GT 0 $
        OR N_ELEMENTS(btMin) GT 0 OR N_ELEMENTS(btMax) GT 0 $
        OR N_ELEMENTS(bxMin) GT 0 OR N_ELEMENTS(bxMax) GT 0 THEN BEGIN
        GET_IMF_BY_BZ_LIM_INDS,C_OMNI__By,C_OMNI__Bz,C_OMNI__Bt,C_OMNI__Bx,byMin,byMax,bzMin,bzMax,btMin,btMax,bxMin,bxMax, $
                               DO_ABS_BYMIN=abs_byMin, $
                               DO_ABS_BYMAX=abs_byMax, $
                               DO_ABS_BZMIN=abs_bzMin, $
                               DO_ABS_BZMAX=abs_bzMax, $
                               DO_ABS_BTMIN=abs_btMin, $
                               DO_ABS_BTMAX=abs_btMax, $
                               DO_ABS_BXMIN=abs_bxMin, $
                               DO_ABS_BXMAX=abs_bxMax, $
                               BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
                               BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
                               LUN=lun
        USE_COMBINED_INDS           = 1
     END

     ;;Now combine all of these
     COMBINE_OMNI_IMF_INDS

     IF KEYWORD_SET(stableIMF) THEN BEGIN
        C_OMNI__stableIMF           = stableIMF
        C_OMNI__paramStr                      += STRING(FORMAT='("--",I0,"_stable")',C_OMNI__stableIMF)

        GET_OMNI_IND_STREAKS,C_OMNI__mag_UTC,goodmag_goodtimes_i, $ ; Get streaks in the database first of all
                             USE_COMBINED_OMNI_IMF_INDS=USE_COMBINED_INDS, $
                             RECALCULATE_OMNI_IND_STREAKS=calculate                
        C_OMNI__stable_i            = WHERE(C_OMNI__StreakDurArr GE C_OMNI__stableIMF) ;This works because the gap between OMNI data is 1 minute

     ENDIF ELSE BEGIN
        GET_OMNI_IND_STREAKS,C_OMNI__mag_UTC,goodmag_goodtimes_i,USE_COMBINED_OMNI_IMF_INDS=USE_COMBINED_INDS ; Get streaks in the database first of all
        IF KEYWORD_SET(USE_COMBINED_INDS) THEN BEGIN
           ;; C_OMNI__stable_i      = INDGEN(N_ELEMENTS(C_OMNI__StreakDurArr))
           C_OMNI__stable_i         = C_OMNI__combined_i
        ENDIF ELSE BEGIN
           C_OMNI__stable_i         = INDGEN(N_ELEMENTS(C_OMNI__mag_UTC),/LONG)
           PRINTF,lun,"Wait, how did you get here? You have no restrictions whatsoever on IMF?"
           STOP
        ENDELSE
     ENDELSE

     ;;******************************
     ;;Day may come when we only require stability of certain conditions
     ;;CODE HERE IF THAT DAY EVER COMES

     ;; IF KEYWORD_SET(stable_clockAngles) OR KEYWORD_SET(stable_IMF_By) OR KEYWORD_SET(stable_IMF_Bz) THEN BEGIN
     ;;    GET_OMNI_IND_STREAKS,C_OMNI__mag_UTC
     ;; ENDIF

     ;; IF KEYWORD_SET(stable_clockAngles) THEN BEGIN
     ;;    C_OMNI__stableStr                           += STRING(FORMAT='("--stable_",A0,"--negAngle_",I0,"__posAngle_",I0,)', $
     ;;                                                          C_OMNI__clockStr,C_OMNI__negAngle,C_OMNI__posAngle)

     ;; ENDIF

     ;; IF KEYWORD_SET(stable_IMF_By) THEN BEGIN

     ;; ENDIF

     ;; IF KEYWORD_SET(stable_IMF_Bz) THEN BEGIN

     ;; ENDIF


     PRINTF,lun,"****END text from GET_STABLE_IMF_INDS****"
     PRINTF,lun,""


     C_OMNI__HAVE_STABLE_INDS       = 1

  ENDIF

  stable_OMNI_inds          = C_OMNI__stable_i
  mag_utc                   = C_OMNI__mag_utc

  PRINTF,lun,C_OMNI__paramStr
  IF KEYWORD_SET(print_avg_imf_components) OR $
     KEYWORD_SET(print_master_file) OR $
     KEYWORD_SET(make_OMNI_stats_savFile) $
  THEN BEGIN

     nPoints                = N_ELEMENTS(stable_omni_inds)
     nTime                  = N_ELEMENTS(C_OMNI__time_i)

     Bx_Avg                 = MEAN(C_OMNI__Bx[stable_omni_Inds])
     Bx_StdDev              = STDDEV(C_OMNI__Bx[stable_omni_Inds])

     By_avg                 = MEAN(C_OMNI__By[stable_omni_inds])
     By_stdDev              = STDDEV(C_OMNI__By[stable_omni_inds])

     Bz_avg                 = MEAN(C_OMNI__Bz[stable_omni_inds])
     Bz_stdDev              = STDDEV(C_OMNI__Bz[stable_omni_inds])

     Bt_Avg                 = MEAN(C_OMNI__Bt[stable_omni_Inds])
     Bt_StdDev              = STDDEV(C_OMNI__Bt[Stable_omni_Inds])

     cone_overClock_avg     = MEAN(C_OMNI__cone_overClock[stable_omni_inds])
     cone_overClock_stdDev  = STDDEV(C_OMNI__cone_overClock[stable_omni_inds])

     phiClock_avg           = MEAN(C_OMNI__phiClock[stable_omni_inds])
     phiClock_stdDev        = STDDEV(C_OMNI__phiClock[stable_omni_inds])

     thetaCone_avg          = MEAN(C_OMNI__thetaCone[stable_omni_inds])
     thetaCone_stdDev       = STDDEV(C_OMNI__thetaCone[stable_omni_inds])

     ;;And swSpeed stuff
     IF KEYWORD_SET(calc_KL_sw_coupling_func) OR $
        KEYWORD_SET(make_OMNI_stats_savFile) $
     THEN BEGIN
        epsilon_KanLee      = CALCULATE_KAN_LEE_SW_COUPLING_FUNCTION(/INC_STDDEV, $
                                                                     /CALC_FROM_COMMON_VARS, $
                                                                     OUT_SW_SPEED=sw_speed)


     ENDIF

     ;; IF KEYWORD_SET(print_OMNI_covariances) THEN BEGIN
     BxBy_covar          = CORRELATE(C_OMNI__Bx[stable_omni_Inds], $
                                     C_OMNI__By[stable_omni_Inds], $
                                     /COVARIANCE)
     BxBz_covar          = CORRELATE(C_OMNI__Bx[stable_omni_Inds], $
                                     C_OMNI__Bz[stable_omni_Inds], $
                                     /COVARIANCE)
     ByBz_covar          = CORRELATE(C_OMNI__By[stable_omni_Inds], $
                                     C_OMNI__Bz[stable_omni_Inds], $
                                     /COVARIANCE)

     BxBt_covar          = CORRELATE(C_OMNI__Bx[stable_omni_Inds], $
                                     C_OMNI__Bt[stable_omni_Inds], $
                                     /COVARIANCE)
     ;; ENDIF


     ;;Get cusp predictions
     PREDICTED_CUSP_LOCATION__ZHANG_ET_AL_2013,By_avg,Bz_avg, $
                                               LAT_CUSP_NWLL_1989=lat_cusp_nwll_1989, $
                                               MLAT_DIAMAG=mlat_diamag, $  
                                               MLAT_DENS_ENH=mlat_dens_enh, $
                                               MLAT_PAR_ION=mlat_par_ion, $ 
                                               MLT_DIAMAG=MLT_diamag, $  
                                               MLT_DENS_ENH=MLT_dens_enh, $
                                               MLT_PAR_ION=MLT_par_ion, $ 
                                               ILAT_CUSP_CTR=ILAT_cusp_ctr, $  
                                               ILAT_CUSP_EQW_B=ILAT_cusp_eqw_b, $
                                               ILAT_CUSP_PW_B=ILAT_cusp_pw_b

  ENDIF

  IF KEYWORD_SET(print_avg_imf_components) THEN BEGIN

     file                           = '~/Desktop/' + C_OMNI__paramStr + '.txt'
     PRINT,"opening " + file + ' ...'
     OPENW,outLun,file,/GET_LUN

     ;;output
     PRINTF,outLun,'**********************'
     PRINTF,outLun,'Average IMF conditions'
     PRINTF,outLun,''
     PRINTF,outLun,C_OMNI__paramStr
     PRINTF,outLun,'**********************'
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("N datapoints",T35,": ",F10.3)',nPoints
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("Average Bx",T35,": ",F10.3)',Bx_avg
     PRINTF,outLun,FORMAT='("Average By",T35,": ",F10.3)',By_avg
     PRINTF,outLun,FORMAT='("Average Bz",T35,": ",F10.3)',Bz_avg
     PRINTF,outLun,FORMAT='("Average Bt",T35,": ",F10.3)',Bt_avg
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("Bx stdDev",T35,": ",F10.3)',Bx_stdDev
     PRINTF,outLun,FORMAT='("By stdDev",T35,": ",F10.3)',By_stdDev
     PRINTF,outLun,FORMAT='("Bz stdDev",T35,": ",F10.3)',Bz_stdDev
     PRINTF,outLun,FORMAT='("Bt stdDev",T35,": ",F10.3)',Bt_stdDev
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("BxBt covar",T35,": ",F10.3)',BxBt_covar
     PRINTF,outLun,FORMAT='("BxBy covar",T35,": ",F10.3)',BxBy_covar
     PRINTF,outLun,FORMAT='("BxBz covar",T35,": ",F10.3)',BxBz_covar
     PRINTF,outLun,FORMAT='("ByBz covar",T35,": ",F10.3)',ByBz_covar
     PRINTF,outLun,''
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("Average thetaCone",T35,": ",F10.3)',thetaCone_avg
     PRINTF,outLun,FORMAT='("Average phiClock",T35,": ",F10.3)',phiClock_avg
     PRINTF,outLun,FORMAT='("Average cone_overClock",T35,": ",F10.3)',cone_overClock_avg
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("thetaCone stdDev",T35,": ",F10.3)',thetaCone_stdDev
     PRINTF,outLun,FORMAT='("phiClock stdDev",T35,": ",F10.3)',phiClock_stdDev
     PRINTF,outLun,FORMAT='("cone_overClock stdDev",T35,": ",F10.3)',cone_overClock_stdDev
     IF KEYWORD_SET(calc_KL_sw_coupling_func) THEN BEGIN
        PRINTF,outLun,''
        PRINTF,outLun,''
        PRINTF,outLun,FORMAT='("Average SW speed",T35,": ",F10.3)',sw_speed[0]
        PRINTF,outLun,FORMAT='("Average KL EField",T35,": ",F10.3)',epsilon_KanLee[0]
        PRINTF,outLun,''
        PRINTF,outLun,FORMAT='(" SW speed stdDev",T35,": ",F10.3)',sw_speed[1]
        PRINTF,outLun,FORMAT='("KL EField stdDev",T35,": ",F10.3)',epsilon_KanLee[1]
     END
     PRINTF,outLun,''
     PRINTF,outLun,";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
     PRINTF,outLun,"From Newell et al. [1989]"
     PRINTF,outLun,"Some low-altitude cusp dependencies on!Nthe interplanetary magnetic field"
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("LAT_CUSP_NWLL_1989",T35,": ",F10.3)',Bz_avg LE 0 ? LAT_CUSP_NWLL_1989 : -9999.999
     PRINTF,outLun,''
     PRINTF,outLun,";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
     PRINTF,outLun,"From Zhang et al. [2013]"
     PRINTF,outLun,"Predicting the Location of Polar Cusp in!Cthe Lyon-Fedder-Mobarry global magnetosphere simulation"
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("MLAT_DIAMAG",T35,": ",F10.3)',Bz_avg LE 0 ? mlat_diamag : -9999.999
     PRINTF,outLun,FORMAT='("MLAT_DENS_ENH",T35,": ",F10.3)',Bz_avg LE 0 ? mlat_dens_enh : -9999.999
     PRINTF,outLun,FORMAT='("MLAT_PAR_ION",T35,": ",F10.3)',Bz_avg LE 0 ? mlat_par_ion : -9999.999
     PRINTF,outLun,''
     PRINTF,outLun,FORMAT='("MLT_DIAMAG",T35,": ",F10.3)',MLT_DIAMAG        
     PRINTF,outLun,FORMAT='("MLT_DENS_ENH",T35,": ",F10.3)',MLT_DENS_ENH      
     PRINTF,outLun,FORMAT='("MLT_PAR_ION",T35,": ",F10.3)',MLT_PAR_ION       
     PRINTF,outLun,''
     PRINTF,outLun,";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
     PRINTF,outLun,"From Zhou et al. [2000]"
     PRINTF,outLun,"Solar wind control of the polar cusp at high altitude"
     PRINTF,outLun,FORMAT='("ILAT_CUSP_CTR",T35,": ",F10.3)',ILAT_CUSP_CTR     
     PRINTF,outLun,FORMAT='("ILAT_CUSP_EQW_B",T35,": ",F10.3)',ILAT_CUSP_EQW_B   
     PRINTF,outLun,FORMAT='("ILAT_CUSP_PW_B",T35,": ",F10.3)',ILAT_CUSP_PW_B    

     CLOSE,outLun
     FREE_LUN,outLun

  ENDIF

  IF KEYWORD_SET(print_master_OMNI_file) THEN BEGIN
     
     file        = '~/Desktop/master_OMNI_file.txt'
     file_exist  = FILE_TEST(file)
     PRINT,"Opening " + file + ' ...'
     OPENW,outLun,file,/GET_LUN,/APPEND

     IF ~file_exist THEN BEGIN
        PRINTF,outLun, $
               FORMAT='("Clock",T10,"Bx_avg",T20,"By_avg",T30,"Bz_avg",T40,"Bt_avg",T50,"Bx_stddev",T60,"By_stddev",T70,"Bz_stddev",T80,"Bt_stddev",T90,"BxBt_CV",T100,"BxBy_CV",T110,"BxBz_CV",T120,"ByBz_CV",T130,"Tfrac",T140,"days",A0)', $
               ''
     ENDIF

     mFormat     = '(A0,T10,F-8.3,T20,F-8.3,T30,F-8.3,T40,F-8.3,T50,F-8.3,T60,F-8.3,T70,F-8.3,T80,F-8.3,T90,F-8.3,T100,F-8.3,T110,F-8.3,T120,F-8.3,T130,F-8.3,T140,F-8.3)'

     PRINTF,outLun, $
            FORMAT=mFormat, $
            C_OMNI__clockStr, $
            Bx_avg, $
            By_avg, $
            Bz_avg, $
            Bt_avg, $
            Bx_stdDev, $
            By_stdDev, $
            Bz_stdDev, $
            Bt_stdDev, $
            BxBt_covar, $
            BxBy_covar, $
            BxBz_covar, $
            ByBz_covar, $
            nPoints/FLOAT(nTime), $
            FLOAT(nPoints)/60./24.

     CLOSE,outLun
     FREE_LUN,outLun

     ;; IF KEYWORD_SET(print_OMNI_covariances) THEN BEGIN
     ;;    file        = '~/Desktop/master_OMNI_file__covars.txt'
     ;;    file_exist  = FILE_TEST(file)
     ;;    PRINT,"Opening " + file + ' ...'
     ;;    OPENW,outLun,file,/GET_LUN,/APPEND

     ;;    IF ~file_exist THEN BEGIN
     ;;       PRINTF,outLun, $
     ;;              FORMAT='("Clock",T10,"BxBt_CV",T20,"BxBy_CV",T30,"BxBz_CV",T40,"ByBz_CV",T90,"Tfrac",T100,"days",A0)', $
     ;;              ''
     ;;    ENDIF

     ;;    mFormat     = '(A0,T10,F-8.3,T20,F-8.3,T30,F-8.3,T40,F-8.3,T90,F-8.3,T100,F-8.3)'

     ;;    PRINTF,outLun, $
     ;;           FORMAT=mFormat, $
     ;;           C_OMNI__clockStr, $
     ;;           BxBt_covar, $
     ;;           BxBy_covar, $
     ;;           BxBz_covar, $
     ;;           ByBz_covar, $
     ;;           nPoints/FLOAT(nTime), $
     ;;           FLOAT(nPoints)/60./24.

     ;;    CLOSE,outLun
     ;;    FREE_LUN,outLun

     ;; ENDIF


  ENDIF

  IF KEYWORD_SET(make_OMNI_stats_savFile) THEN BEGIN
     IF FILE_TEST(make_OMNI_stats_savFile) THEN BEGIN
        PRINT,'Restoring ' + make_OMNI_stats_savFile + ' ...'
        RESTORE,make_OMNI_stats_savFile

        stats = {nPoints:[stats.nPoints,nPoints], $
                 nTime:[stats.nTime,nTime], $
                 clockStr:[stats.clockStr,C_OMNI__clockStr], $
                 avg:{Bx:[stats.avg.Bx,Bx_avg], $
                      By:[stats.avg.By,By_avg], $
                      Bz:[stats.avg.Bz,Bz_avg], $
                      Bt:[stats.avg.Bt,Bt_avg], $
                      phiClock:[stats.avg.phiClock,phiClock_avg], $
                      thetaCone:[stats.avg.thetaCone,thetaCone_avg], $
                      cone_overClock:[stats.avg.cone_overClock,cone_overClock_avg], $
                      KL_Efield:[stats.avg.KL_EField,epsilon_KanLee[0]]}, $
                 stdDev:{Bx:[stats.stdDev.Bx,Bx_StdDev], $
                      By:[stats.stdDev.By,By_StdDev], $
                      Bz:[stats.stdDev.Bz,Bz_StdDev], $
                      Bt:[stats.stdDev.Bt,Bt_StdDev], $
                      phiClock:[stats.stdDev.phiClock,phiClock_StdDev], $
                      thetaCone:[stats.stdDev.thetaCone,thetaCone_StdDev], $
                      cone_overClock:[stats.stdDev.cone_overClock,cone_overClock_StdDev], $
                      KL_Efield:[stats.stdDev.KL_EField,epsilon_KanLee[1]]}, $
                 covar:{BxBt:[stats.covar.BxBt,BxBt_covar], $
                        BxBy:[stats.covar.BxBy,BxBy_covar], $
                        BxBz:[stats.covar.BxBz,BxBz_covar], $
                        ByBz:[stats.covar.ByBz,ByBz_covar]}}

     ENDIF ELSE BEGIN
        PRINT,'Making ' + make_OMNI_stats_savFile + ' ...'
        stats = {nPoints:nPoints, $
                 nTime:nTime, $
                 clockStr:C_OMNI__clockStr, $
                 avg:{Bx:Bx_avg, $
                      By:By_avg, $
                      Bz:Bz_avg, $
                      Bt:Bt_avg, $
                      phiClock:phiClock_avg, $
                      thetaCone:thetaCone_avg, $
                      cone_overClock:cone_overClock_avg, $
                      KL_Efield:epsilon_KanLee[0]}, $
                 stdDev:{Bx:Bx_StdDev, $
                      By:By_StdDev, $
                      Bz:Bz_StdDev, $
                      Bt:Bt_StdDev, $
                      phiClock:phiClock_StdDev, $
                      thetaCone:thetaCone_StdDev, $
                      cone_overClock:cone_overClock_StdDev, $
                      KL_Efield:epsilon_KanLee[1]}, $
                 covar:{BxBt:BxBt_covar, $
                        BxBy:BxBy_covar, $
                        BxBz:BxBz_covar, $
                        ByBz:ByBz_covar}}

     ENDELSE

     PRINT,'Saving OMNI stats to ' + make_OMNI_stats_savFile + ' ...'
     SAVE,stats,FILENAME=make_OMNI_stats_savFile
  ENDIF

  IF KEYWORD_SET(save_master_OMNI_inds) THEN BEGIN
     file = '~/Desktop/master_OMNI_ind_list--Alfvens_IMF_v8--nonstorm.sav'
     test = FILE_TEST(file)
     IF test THEN BEGIN
        PRINT,'Restoring master OMNI file, adding these OMNI inds ...'
        RESTORE,file
        IF N_ELEMENTS(stable_omni_ind_list) EQ 0 OR N_ELEMENTS(clockStr_list) EQ 0 THEN BEGIN
           PRINT,"Corrupted file? Couldn't find any inds!"
           stable_omni_ind_list = LIST(stable_omni_inds)
           clockStr_list        = LIST(C_OMNI__clockStr)
        ENDIF ELSE BEGIN
           stable_omni_ind_list.Add,stable_omni_inds
           clockStr_list.Add,C_OMNI__clockStr
        ENDELSE
     ENDIF ELSE BEGIN
        PRINT,"Creating stable OMNI inds file ..."
        stable_omni_ind_list = LIST(stable_omni_inds)
        clockStr_list        = LIST(C_OMNI__clockStr)
     ENDELSE
        SAVE,stable_omni_ind_list,clockStr_list,FILENAME=file
  ENDIF

  omni_paramStr                     = C_OMNI__paramStr

  IF KEYWORD_SET(get_Bx) THEN BEGIN
     Bx_out                         = C_OMNI__Bx
  ENDIF
  IF KEYWORD_SET(get_By) THEN BEGIN
     By_out                         = C_OMNI__By
  ENDIF
  IF KEYWORD_SET(get_Bz) THEN BEGIN
     Bz_out                         = C_OMNI__Bz
  ENDIF
  IF KEYWORD_SET(get_Bt) THEN BEGIN
     Bt_out                         = C_OMNI__Bt
  ENDIF
  IF KEYWORD_SET(get_thetaCone) THEN BEGIN
     thetaCone_out                  = C_OMNI__thetaCone
  ENDIF
  IF KEYWORD_SET(get_clockAngle) THEN BEGIN
     clockAngle_out                 = C_OMNI__phiClock
  ENDIF
  IF KEYWORD_SET(get_cone_overClock) THEN BEGIN
     cone_overClock_out             = C_OMNI__cone_overClock
  ENDIF
  IF KEYWORD_SET(get_Bxy_Over_Bz) THEN BEGIN
     Bxy_over_Bz_out                = C_OMNI__Bxy_over_Bz
  ENDIF
  RETURN,stable_OMNI_inds

END