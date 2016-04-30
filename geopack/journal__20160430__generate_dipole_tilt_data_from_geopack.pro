PRO JOURNAL__20160430__GENERATE_DIPOLE_TILT_DATA_FROM_GEOPACK

  ;;output
  outDir          = '/SPENCEdata/Research/Cusp/database/geopack_data/'
  outFile         = 'GEOPACK--dipole_tilt_angle--1990--2010.dat'

  ;;generate the dates
  nYears          = 21
  years           = INDGEN(nYears)+1990

  finalYearArr    = !NULL
  finalDOYArr     = !NULL
  finalMonthArr   = !NULL
  finalDayArr     = !NULL
  FOR i=0,nYears-1 DO BEGIN
     nDays        = 365 + ( (years[i] MOD 4) EQ 0 )
     tempDOY      = INDGEN(nDays)+1
     tempYArr     = REPLICATE(years[i],nDays)
     
     CALDAT,JULDAY(1, tempDOY, years[i]),tempMonth,tempDay

     finalYearArr    = [finalYearArr,tempYArr]
     finalDOYArr     = [finalDOYArr,tempDOY]
     finalMonthArr   = [finalMonthArr,tempMonth]
     finalDayArr     = [finalDayArr,tempDay]
  ENDFOR

  julDay             = JULDAY(finalMonthArr,finalDayArr,finalYearArr,0,0,0)
  time_utc           = JULDAY_TO_UTC(julDay)

  ;;feed it to GEOPACK
  nTot               = N_ELEMENTS(finalYearArr)
  finalTiltArr       = !NULL
  FOR i=0,nTot-1 DO BEGIN
     GEOPACK_RECALC,finalYearArr[i],finalDOYArr[i],TILT=tempTilt
     finalTiltArr    = [finalTiltArr,tempTilt]
  ENDFOR

  ;; Create format strings for a two-level axis:
  dummy              = LABEL_DATE(DATE_FORMAT=['%D-%M','%Y'])
  ;;plot it
  plot               = PLOT(julDay, $
                            finalTiltArr, $
                            XTICKUNITS=['Time', 'Time'], $
                            XTICKFORMAT='LABEL_DATE', $
                            XSTYLE=1, $
                            XMAJOR=6, $
                            XMINOR=0)

  ;;make some stuff
  tStamp             = TIMESTAMP(DAY=finalDayArr, $
                                 MONTH=finalMonthArr, $
                                 YEAR=finalYearArr) + "/00:00:00"


  ;;make struct
  tiltAngle          = {TIME: time_utc, $
                        ANGLE: finalTiltArr, $
                        TSTAMP: tStamp, $
                        JULDAY: julday, $
                        CREATED: GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                        ORIGINATING_ROUTINE: 'JOURNAL__20160430__GENERATE_DIPOLE_TILT_DATA_FROM_GEOPACK'}


  PRINT,'Saving ' + outDir + outFile + '...'
  save,tiltAngle,FILENAME=outDir+outFile

END
