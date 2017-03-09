;;06/15/16
PRO PREDICTED_CUSP_LOCATION__ZHANG_ET_AL_2013,By,Bz, $
   LAT_CUSP_NWLL_1989=lat_cusp_nwll_1989, $
   MLAT_DIAMAG=mlat_diamag, $  
   MLAT_DENS_ENH=mlat_dens_enh, $
   MLAT_PAR_ION=mlat_par_ion, $ 
   MLT_DIAMAG=MLT_diamag, $  
   MLT_DENS_ENH=MLT_dens_enh, $
   MLT_PAR_ION=MLT_par_ion, $ 
   ILAT_CUSP_CTR=ILAT_cusp_ctr, $  
   ILAT_CUSP_EQW_B=ILAT_cusp_eqw_b, $
   ILAT_CUSP_PW_B=ILAT_cusp_pw_b, $
   LUN=lun

  COMPILE_OPT IDL2,STRICTARRSUBS

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;From Zhang et al. 2013 Predicting the Location of Polar Cusp in
  ;;the Lyon-Fedder-Mobarry global magnetosphere simulation
  
  IF Bz LE 0 THEN BEGIN
     lat_cusp_nwll_1989 = 77.1 + 0.76 * Bz

     mlat_diamag    = 77.3 + 0.77 * Bz
     mlat_dens_enh  = 77.7 + 0.80 * Bz
     mlat_par_ion   = 76.8 + 0.81 * Bz

  ENDIF

  MLT_diamag        = 0.12 * By + 12.13
  MLT_dens_enh      = 0.11 * By + 12.14
  MLT_par_ion       = 0.16 * By + 12.22


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;From Zhou et al. [2000]
  ;;"Solar wind control of the polar cusp at high altitude"
  CASE 1 OF
     Bz LT 0: BEGIN
        ILAT_cusp_ctr   = 81.3 + 0.98  * Bz
        ILAT_cusp_eqw_b = 79.5 + 0.86  * Bz
        ILAT_cusp_pw_b  = 83.0 + 1.08  * Bz
     END
     ELSE: BEGIN
        ILAT_cusp_ctr   = 80.7 - 0.027 * Bz
        ILAT_cusp_eqw_b = 79.2 - 0.07  * Bz
        ILAT_cusp_pw_b  = 82.0 + 0.02  * Bz
     END
  ENDCASE

END
