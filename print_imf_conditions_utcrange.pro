;2017/03/11
PRO PRINT_IMF_CONDITIONS_UTCRANGE,UTCRanges, $
                                  LEEWAYLOWER=leewayLower, $
                                  LEEWAYUPPER=leewayUpper

  COMPILE_OPT IDL2,STRICTARRSUBS

  IF N_ELEMENTS(leewayLower) EQ 0 THEN BEGIN
     leewayLower = 30
  ENDIF

  IF N_ELEMENTS(leewayUpper) EQ 0 THEN BEGIN
     leewayUpper = leewayLower
  ENDIF


  dataDir           = "/SPENCEdata/Research/database/OMNI/"
  culledDataStr     = "culled_OMNI_magdata.dat"
  ;; tiltFile          = 'sw_data--GEOPACK-dpTilt.sav'
  tiltFile          = 'sw_data--dpTilt_for_culled_OMNI_magdata.dat'

  RESTORE,dataDir + culledDataStr


  nTPeriods = N_ELEMENTS(UTCRanges[0,*])

  indList  = LIST()
  nHereArr = MAKE_ARRAY(nTPeriods,/LONG)

  FOR k=0,nTPeriods-1 DO BEGIN
     indList.Add,WHERE((mag_utc GE (STR_TO_TIME(UTCRanges[0,k])-leewayLower*60)) AND (mag_utc LE (STR_TO_TIME(UTCRanges[1,k])+leewayUpper*60)),nHere)
     nHereArr[k] = nHere
  ENDFOR

  PRINT,FORMAT='(A-9,T25,A-9,T35,A-9,T45,A-9,T55,A-9,T65,A-9)', $
        "Time (UT)","Bx","By","Bz","PhiClock","ThetaCone"
  FOR k=0,nTPeriods-1 DO BEGIN
     inds = indList[k]

     tDiff = (STR_TO_TIME(UTCRanges[1,k])+leewayUpper*60)-(STR_TO_TIME(UTCRanges[0,k])-leewayLower*60)
     hrs   = FLOOR(FLOAT(tDiff)/3600)
     min   = FLOOR((tDiff - hrs*3600.)/60.)
     PRINT,''
     PRINT,FORMAT='("PERIOD ",I0,": ",A0," - ",A0," (",I0," hr, ",I0," min, ",F0.3," sec)")', $
           k,UTCRanges[0,k],UTCRanges[1,k],hrs,min,tDiff MOD 60.
     PRINT,'*****************************************************'

     mag_utcTmp = mag_utc[inds]
     BXTmp = BX[inds]
     BY_GSMTmp = BY_GSM[inds]
     BZ_GSMTmp      = BZ_GSM[inds]
     phiClock_GSMTmp = phiClock_GSM[inds]*!RADEG
     thetaCone_GSMTmp = thetaCone_GSM[inds]*!RADEG

     FOR j=0,nHereArr[k]-1 DO BEGIN
        PRINT,FORMAT='(A0,T25,F8.2,T35,F8.2,T45,F8.2,T55,F8.2,T65,F8.2)', $
              TIME_TO_STR(mag_utcTmp[j]), $
              BX[j],BY_GSMTmp[j],BZ_GSMTmp[j],phiClock_GSMTmp[j],thetaCone_GSMTmp[j]
     ENDFOR

     PRINT,'-----------------------------'
     PRINT,FORMAT='(A-9,T25,A-9,T35,A-9,T45,A-9,T55,A-9,T65,A-9)', $
           "Time (UT)","Bx","By","Bz","PhiClock","ThetaCone"
     PRINT,FORMAT='(A0,T25,F8.2,T35,F8.2,T45,F8.2,T55,F8.2,T65,F8.2)', $
           "AVG", $
           MEAN(BX),MEAN(BY_GSMTmp),MEAN(BZ_GSMTmp),MEAN(phiClock_GSMTmp),MEAN(thetaCone_GSMTmp)
     PRINT,FORMAT='(A0,T25,F8.2,T35,F8.2,T45,F8.2,T55,F8.2,T65,F8.2)', $
           "STDDEV", $
           STDDEV(BX),STDDEV(BY_GSMTmp),STDDEV(BZ_GSMTmp),STDDEV(phiClock_GSMTmp),STDDEV(thetaCone_GSMTmp)

  ENDFOR


END
