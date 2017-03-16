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
  culledSWDataStr   = "culled_OMNI_swdata.dat"


  RESTORE,dataDir + culledDataStr
  RESTORE,dataDir+culledSWDataStr

  nTPeriods  = N_ELEMENTS(UTCRanges[0,*])

  indList     = LIST()
  nHereArr    = MAKE_ARRAY(nTPeriods,/LONG)

  indSWList   = LIST()
  nSWHereArr  = MAKE_ARRAY(nTPeriods,/LONG)
  allMatchArr = MAKE_ARRAY(nTPeriods,/BYTE)
  FOR k=0,nTPeriods-1 DO BEGIN
     indList.Add,WHERE((mag_utc GE (STR_TO_TIME(UTCRanges[0,k])-leewayLower*60)) AND $
                       (mag_utc LE (STR_TO_TIME(UTCRanges[1,k])+leewayUpper*60)),nHere)
     nHereArr[k]    = nHere

     ;;And solar wind
     indSWList.Add,WHERE((mag_utc_SW GE (STR_TO_TIME(UTCRanges[0,k])-leewayLower*60)) AND $
                         (mag_utc_SW LE (STR_TO_TIME(UTCRanges[1,k])+leewayUpper*60)),nSWHere)
     nSWHereArr[k]  = nSWHere
     matcher_ii     = VALUE_CLOSEST2(mag_utc_SW[indSWList[-1]],mag_utc[indList[-1]])
     ;; allMatchArr[k] = N_ELEMENTS(UNIQ((indSWList[-1])[matcher_ii],SORT((indSWList[-1])[matcher_ii]))) EQ N_ELEMENTS(matcher_ii)
     allMatchArr[k] = nSWHere EQ nHere

  ENDFOR


  vxStr = 'Vx'
  vyStr = 'Vy'
  vzStr = 'Vz'
  PRINT,FORMAT='(A-9,T25,A-9,T35,A-9,T45,A-9,T55,A-9,T65,' + $
                'A-9,T75,A-9,T85,A-9,T95,A-9,T105,A-9)', $
        "Time (UT)","Bx","By","Bz","PhiClock", $
        "ThetaCone","SWSpeed",vxStr,vyStr,vzStr
  FOR k=0,nTPeriods-1 DO BEGIN
     inds   = indList[k]
     SWinds = indSWList[k]


     tDiff = (STR_TO_TIME(UTCRanges[1,k])+leewayUpper*60)-(STR_TO_TIME(UTCRanges[0,k])-leewayLower*60)
     hrs   = FLOOR(FLOAT(tDiff)/3600)
     min   = FLOOR((tDiff - hrs*3600.)/60.)
     PRINT,''
     PRINT,FORMAT='("PERIOD ",I0,": ",A0," - ",A0," (",I0," hr, ",I0," min, ",F0.3," sec)")', $
           k,UTCRanges[0,k],UTCRanges[1,k],hrs,min,tDiff MOD 60.
     PRINT,'*****************************************************'

     mag_utcTmp        = mag_utc[inds]
     BxTmp             = Bx[inds]
     By_GSMTmp         = By_GSM[inds]
     Bz_GSMTmp         = Bz_GSM[inds]
     phiClock_GSMTmp   = phiClock_GSM[inds]*!RADEG
     thetaCone_GSMTmp  = thetaCone_GSM[inds]*!RADEG

     justInCase        = MAKE_ARRAY(nHereArr[k],VALUE=0)
     VxTmp             = allMatchArr[k] ? Vx[SWInds]          : justInCase
     VyTmp             = allMatchArr[k] ? Vy[SWInds]          : justInCase
     VzTmp             = allMatchArr[k] ? Vz[SWInds]          : justInCase
     flowSpeedTmp      = allMatchArr[k] ? flow_speed[SWInds]  : justInCase

     FOR j=0,nHereArr[k]-1 DO BEGIN
        PRINT,FORMAT='(A0,T25,F8.2,T35,F8.2,T45,F8.2,T55,F8.2,T65,' + $
                      'F8.2,T75,F8.2,T85,F8.2,T95,F8.2,T105,F8.2)', $
              TIME_TO_STR(mag_utcTmp[j]),BxTmp[j],By_GSMTmp[j],Bz_GSMTmp[j],phiClock_GSMTmp[j], $
              thetaCone_GSMTmp[j],flowSpeedTmp[j],VxTmp[j],VyTmp[j],VzTmp[j]
     ENDFOR

     PRINT,'-----------------------------'
     PRINT,FORMAT='(A-9,T25,A-9,T35,A-9,T45,A-9,T55,A-9,T65,' + $
           'A-9,T75,A-9,T85,A-9,T95,A-9,T105,A-9)', $
           "Time (UT)","Bx","By","Bz","PhiClock", $
           "ThetaCone","SWSpeed",vxStr,vyStr,vzStr
     PRINT,FORMAT='(A0,T25,F8.2,T35,F8.2,T45,F8.2,T55,F8.2,T65,' + $
                      'F8.2,T75,F8.2,T85,F8.2,T95,F8.2,T105,F8.2)', $
           "AVG", $
           MEAN(BxTmp),MEAN(By_GSMTmp),MEAN(Bz_GSMTmp),MEAN(phiClock_GSMTmp), $
           MEAN(thetaCone_GSMTmp),MEAN(flow_speed[SWInds]),MEAN(Vx[SWInds]),MEAN(Vy[SWInds]),MEAN(Vz[SWInds])
     PRINT,FORMAT='(A0,T25,F8.2,T35,F8.2,T45,F8.2,T55,F8.2,T65,' + $
                      'F8.2,T75,F8.2,T85,F8.2,T95,F8.2,T105,F8.2)', $
           "STDDEV", $
           STDDEV(BxTmp),STDDEV(By_GSMTmp),STDDEV(Bz_GSMTmp),STDDEV(phiClock_GSMTmp), $
           STDDEV(thetaCone_GSMTmp),STDDEV(flow_speed[SWInds]),STDDEV(Vx[SWInds]),STDDEV(Vy[SWInds]),STDDEV(Vz[SWInds])

  ENDFOR


END
