PRO JOURNAL__20160430__GENERATE_DIPOLE_TILT_DATA_FROM_GEOPACK

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir          = '/SPENCEdata/Research/database/geopack_data/'
  outFile         = 'GEOPACK--dipole_tilt_angle--1990--2010.dat'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;cusp stuff
  cuspLocN_MAG     = [0,0,1]
  cuspLocS_MAG     = [0,0,-1]

;; GEOPACK_CONV_COORD
;; Description: Convert between a variety of commonly used coordinate systems.
;; Calling Sequence: geopack_conv_coord(_08), s1, s2, s3, d1, d2, d3.
;; Inputs: s1, s2, s3: Coordinates in system of origin.
;; Outputs: d1, d2, d3: Coordinates in target system.
;; Keywords: FROM_GEO: Specify source in geopgraphic coordinates. 
;;  FROM_MAG: Specify source in geomagnetic coordinates.
;;  FROM_GEI: Specify source in geocentric equatorial inertial coordinates.
;;  FROM_SM: Specify source in solar magnetic coordinates.
;;  FROM_GSM: Specify source in geocentric solar magnetospheric
;;  coordinates.
;;  FROM_GSE: Specify source in geocentric solar ecliptic coordinates.
;;  TO_GEO: Specify destination in geopgraphic coordinates.
;;  TO_MAG: Specify destination in geomagnetic coordinates.
;;  TO_GEI: Specify destination in geocentric equatorial inertial coordinates.
;;  TO_SM: Specify destination in solar magnetic coordinates.
;;  TO_GSM: Specify destination in geocentric solar magnetospheric
;;  coordinates. 

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;generate the dates
  nYears          = 21
  years           = INDGEN(nYears)+1990

  finalYearArr    = !NULL
  finalDOYArr     = !NULL
  finalMonthArr   = !NULL
  finalDayArr     = !NULL
  hourArr         = [0,3,6,18] ;for cusp stuff
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

  time_epoch         = UTC_TO_CDF_EPOCH(time_utc)

  ;; GEOPACK_RECALC_08
  ;; GEOPACK_CONV_COORD_08,cuspLoc_MAG[0],cuspLoc_MAG[1],cuspLoc_MAG[2],clgeo_x,clgeo_y,clgeo_z,/FROM_MAG,/TO_GEO,EPOCH=time_epoch

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  nTot               = N_ELEMENTS(finalYearArr)
  finalTiltArr       = !NULL
  clN_GEO_arr        = MAKE_ARRAY(3,nTot,/FLOAT)
  clN_GSM_arr        = MAKE_ARRAY(3,nTot,/FLOAT)
  clS_GEO_arr        = MAKE_ARRAY(3,nTot,/FLOAT)
  clS_GSM_arr        = MAKE_ARRAY(3,nTot,/FLOAT)
  FOR i=0,nTot-1 DO BEGIN
     GEOPACK_RECALC,finalYearArr[i],finalDOYArr[i],TILT=tempTilt

     ;;do those cusps
     GEOPACK_CONV_COORD,cuspLocN_MAG[0],cuspLocN_MAG[1],cuspLocN_MAG[2],clngeo_x,clngeo_y,clngeo_z,/FROM_MAG,/TO_GEO,EPOCH=time_epoch[i]
     GEOPACK_CONV_COORD,cuspLocN_MAG[0],cuspLocN_MAG[1],cuspLocN_MAG[2],clngsm_x,clngsm_y,clngsm_z,/FROM_MAG,/TO_GSM,EPOCH=time_epoch[i]

     GEOPACK_CONV_COORD,cuspLocS_MAG[0],cuspLocS_MAG[1],cuspLocS_MAG[2],clsgeo_x,clsgeo_y,clsgeo_z,/FROM_MAG,/TO_GEO,EPOCH=time_epoch[i]
     GEOPACK_CONV_COORD,cuspLocS_MAG[0],cuspLocS_MAG[1],cuspLocS_MAG[2],clsgsm_x,clsgsm_y,clsgsm_z,/FROM_MAG,/TO_GSM,EPOCH=time_epoch[i]

     ;;update
     finalTiltArr    = [finalTiltArr,tempTilt]
     clN_GEO_arr[*,i] = [clngeo_x,clngeo_y,clngeo_z]
     clN_GSM_arr[*,i] = [clngsm_x,clngsm_y,clngsm_z]
     clS_GEO_arr[*,i] = [clsgeo_x,clsgeo_y,clsgeo_z]
     clS_GSM_arr[*,i] = [clsgsm_x,clsgsm_y,clsgsm_z]
  ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Create format strings for a two-level axis:
  dummy              = LABEL_DATE(DATE_FORMAT=['%D-%M','%Y'])
  ;;plot it
  ;; plot               = PLOT(julDay, $
  ;;                           finalTiltArr, $
  ;;                           XTICKUNITS=['Time', 'Time'], $
  ;;                           XTICKFORMAT='LABEL_DATE', $
  ;;                           XSTYLE=1, $
  ;;                           XMAJOR=6, $
  ;;                           XMINOR=0)

  inds               = [0:1000]
  plot               = PLOT(julDay[inds], $
                            (clN_GSM_arr[2,*])[inds], $
                            NAME='Northern cusp', $
                            COLOR='red', $
                            XTICKUNITS=['Time', 'Time'], $
                            XTICKFORMAT='LABEL_DATE', $
                            XSTYLE=1, $
                            XMAJOR=6, $
                            XMINOR=0, $
                            YTITLE = 'Z (GSM)')

  plot               = PLOT(julDay[inds], $
                            (clS_GSM_arr[2,*])[inds], $
                            NAME='Southern cusp', $
                            COLOR='blue', $
                            XTICKUNITS=['Time', 'Time'], $
                            XTICKFORMAT='LABEL_DATE', $
                            /OVERPLOT, $
                            XSTYLE=1, $
                            XMAJOR=6, $
                            XMINOR=0, $
                            YTITLE = 'Z (GSM)')

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make some stuff
  tStamp             = TIMESTAMP(DAY=finalDayArr, $
                                 MONTH=finalMonthArr, $
                                 YEAR=finalYearArr) + "/00:00:00"


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make struct
  tiltAngle          = {TIME: time_utc, $
                        ANGLE: finalTiltArr, $
                        TSTAMP: tStamp, $
                        JULDAY: julday, $
                        CUSPLOC_N_GSM: clN_GSM_arr, $
                        CUSPLOC_S_GSM: clS_GSM_arr, $
                        CUSPLOC_N_GEO: clN_GEO_arr, $
                        CUSPLOC_S_GEO: clS_GEO_arr, $
                        CREATED: GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                        ORIGINATING_ROUTINE: 'JOURNAL__20160430__GENERATE_DIPOLE_TILT_DATA_FROM_GEOPACK'}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  PRINT,'Saving ' + outDir + outFile + '...'
  save,tiltAngle,FILENAME=outDir+outFile

END
