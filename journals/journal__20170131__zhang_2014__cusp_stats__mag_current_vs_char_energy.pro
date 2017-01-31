;;01/31/17
PRO JOURNAL__20170131__ZHANG_2014__CUSP_STATS__MAG_CURRENT_VS_CHAR_ENERGY

  COMPILE_OPT IDL2

  dir           = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170129/'
  goodFile      = 'alfdb_good_i_above_60_ILAT__NORTH--20170126.sav'

  xLog          = 1
  yLog          = 1
  
  @common__maximus_vars.pro
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  RESTORE,dir+goodFile

  good_i = CGSETINTERSECTION(good_i,WHERE(MAXIMUS__maximus.MLT GE 9.5 AND $
                                          MAXIMUS__maximus.MLT LE 14.5,nReg))

  this = SCATTERPLOT(MAXIMUS__maximus.mag_current[good_i],MAXIMUS__maximus.max_charE_lossCone[good_i], $
                     XTITLE='Mag current ($\mu$A/m!U2!N)', $
                     YTITLE='Char. energy (eV)', $
                     XLOG=xLog, $
                     YLOG=yLog, $
                     SYM_TRANSPARENCY=90)
END
