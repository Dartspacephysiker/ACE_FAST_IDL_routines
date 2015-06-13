;+
; NAME:                           SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES
;
; PURPOSE:                        TAKE A LIST OF STORMS, SUPERPOSE THE STORMS AS WELL AS THE RELEVANT DB QUANTITIES
;
; CATEGORY:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          TBEFORESTORM      : Amount of time (hours) to plot before a given DST min
;                              TAFTERSTORM       : Amount of time (hours) to plot after a given DST min
;                              STARTDATE         : Include storms starting with this time (in seconds since Jan 1, 1970)
;                              STOPDATE          : Include storms up to this time (in seconds since Jan 1, 1970)
;                              STORMTYPE         : '0'=small, '1'=large, '2'=all
; OUTPUTS:                     
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:   2015/06/12 Born
;                           
;-


PRO superpose_storms_and_alfven_db_quantities,stormTimeArray,STARTDATE=startDate, STOPDATE=stopDate, STORMTYPE=stormType, $
   TBEFORESTORM=tBeforeStorm,TAFTERSTORM=tAfterStorm, $
   MAXIND=maxInd,LOG_DBQUANTITY=log_DBquantity, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   USE_SYMH=use_symh
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  defTBeforeStorm= 22                                                       ;in hours
  defTAfterStorm=  16                                                       ;in hours

  defswDBDir='sw_omnidata/'
  defswDBFile='sw_data.dat'

  defStormDir='sw_omnidata/'
  defStormFile='large_and_small_storms--1985-2011--Anderson.sav'

  defDST_AEDir='processed/'
  defDST_AEFile='idl_ae_dst_data.dat'

  defDBDir='dartdb/saves/'
  defDBFile='Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  defDB_tFile='Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'

  defMaxInd=6
  defLog_DBquantity=0

  ;; plotScaleString='Hours'
  ;; plotScaleString='Minutes'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Check defaults
  IF ~KEYWORD_SET(tBeforeStorm) THEN tBeforeStorm = defTBeforeStorm
  IF ~KEYWORD_SET(tAfterStorm) THEN tAfterStorm = defTAfterStorm

  IF ~KEYWORD_SET(swDBDir) THEN swDBDir=defswDBDir
  IF ~KEYWORD_SET(swDBFile) THEN swDBFile=defswDBFile

  IF ~KEYWORD_SET(stormDir) THEN stormDir=defStormDir
  IF ~KEYWORD_SET(stormFile) THEN stormFile=defStormFile

  IF ~KEYWORD_SET(DST_AEDir) THEN DST_AEDir=defDST_AEDir
  IF ~KEYWORD_SET(DST_AEFile) THEN DST_AEFile=defDST_AEFile

  IF ~KEYWORD_SET(dbDir) THEN dbDir=defDBDir
  IF ~KEYWORD_SET(dbFile) THEN dbFile=defDBFile
  IF ~KEYWORD_SET(db_tFile) THEN db_tFile=defDB_tFile

  IF ~KEYWORD_SET(log_DBQuantity) THEN log_DBQuantity=defLogDBQuantity

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile

  IF ~KEYWORD_SET(use_symh) THEN restore,dataDir+DST_AEDir+DST_AEFile

  restore,dataDir+defDBDir+DBFile
  restore,dataDir+defDBDir+DB_tFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all storms occuring within specified range
  IF KEYWORD_SET(STARTDATE) THEN BEGIN
     IF ~KEYWORD_SET(STOPDATE) THEN BEGIN
        PRINT,"No stop year specified! Plotting data up to a full year after startDate."
        stopDate=startDate+86400.*31.*12.
     ENDIF

     stormStruct_inds=WHERE(stormStruct.time GE startDate AND stormStruct.time LE stopDate,/NULL)
     nStorms=N_ELEMENTS(stormStruct_inds)
     
     IF nStorms EQ 0 THEN BEGIN
        PRINT,"No storms found for given time range:"
        PRINT,"Start date: ",time_to_string(startDate)
        PRINT,"Stop date: ",time_to_string(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF

     

     IF ~KEYWORD_SET(use_symh) THEN BEGIN                 ;Use DST for plots, not SYM-H
        
     ENDIF ELSE BEGIN                                     ;Use SYM-H for plots 

     ENDELSE
  ENDIF

  storm_i=MAKE_ARRAY(4,2,/L64)
  stormStr=MAKE_ARRAY(4)

  ;Get nearest events in Chaston DB
  storm_utc=MAKE_ARRAY(4,2,/DOUBLE)
  cdb_storm_t=MAKE_ARRAY(4,2,/DOUBLE)
  cdb_storm_i=MAKE_ARRAY(4,2,/L64)
  ;; mag_utc=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
  FOR i=0,3 DO BEGIN
     FOR j=0,1 DO BEGIN
        storm_utc(i,j)=(sw_data.epoch.dat(storm_i(i,j))-62167219200000.0000D)/1000.0D
        tempMin=MIN(ABS(storm_utc(i,j)-cdbTime),temp_min_i)
        cdb_storm_i(i,j)=temp_min_i
        cdb_storm_t(i,j)=cdbTime(temp_min_i)
     ENDFOR
  ENDFOR

  ;Now plot SYM-H
  plotWind=WINDOW(WINDOW_TITLE="SYM-H plots", $
                  DIMENSIONS=[1200,900])

  FOR i=0,3 DO BEGIN

                                ;make a string array for plot
     factor=1440                ;leave this as 1440 (n minutes in a day), since storm_i has a separation of 1 min between data points
     nTimes=(storm_i(i,1) - storm_i(i,0)) / factor + 1
     tArr=INDGEN(nTimes,/L64)*factor/60.
     tStr=MAKE_ARRAY(nTimes,/STRING)
     FOR t=0L,nTimes-1 DO tStr[t] = cdf_encode_epoch(sw_data.epoch.dat(storm_i(i,0)+factor*t)) ;strings for each day

                                ;plot data
     t=(sw_data.epoch.dat(storm_i(i,0):storm_i(i,1))-sw_data.epoch.dat(storm_i(i,0)))/3600000D0
     y=sw_data.sym_h.dat(storm_i(i,0):storm_i(i,1))

     plot=plot(t,y, $
               XTITLE='Hours since '+tStr[0], $
               YTITLE='SYM-H (nT)', $
               ;; XRANGE=[0,7000./60.], $
               XRANGE=[0,120], $
               YRANGE=[-350,50], $
               XTICKFONT_SIZE=10, $
               XTICKFONT_STYLE=1, $
               ;; XTICKNAME=STRMID(tStr,0,12), $
               ;; XTICKVALUES=tArr, $
               LAYOUT=[1,4,i+1], $
               /CURRENT)
  ENDFOR

  ;And NOW let's plot quantity from the Alfven DB to see how it fares during storms

  good_i=get_chaston_ind(maximus,"OMNI",-1,/NORTHANDSOUTH)
  mTags=TAG_NAMES(maximus)

  plotWind=WINDOW(WINDOW_TITLE="Maximus plots", $
                  DIMENSIONS=[1200,900])

  ;Get ranges for plots
  maxMinutes=MAX((cdbTime(cdb_storm_i(*,1))-cdbTime(cdb_storm_i(*,0)))/3600.,longestStorm_i,MIN=minMinutes)
  minMaxDat=MAKE_ARRAY(4,2,/DOUBLE)
  FOR i=0,3 DO BEGIN
     minMaxDat(i,1)=MAX(maximus.(maxInd)(cdb_storm_i(i,0):cdb_storm_i(i,1)),MIN=tempMin)
     minMaxDat(i,0)=tempMin
  ENDFOR

  IF log_DBquantity THEN BEGIN
     maxDat=ALOG10(MAX(minMaxDat(*,1)))
     minDat=ALOG10(MIN(minMaxDat(*,0)))
  ENDIF ELSE BEGIN
     maxDat=MAX(minMaxDat(*,1))
     minDat=MIN(minMaxDat(*,0))
  ENDELSE

  ;now plot DB quantity
  IF KEYWORD_SET(maxInd) THEN BEGIN
     FOR i=0,3 DO BEGIN
        
  ;get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
        
  ;get relevant time range
        cdb_t=cdbTime(plot_i)-storm_utc(i,0)
        minTime=MIN(cdb_t)
        minTime=(minTime LT 0) ? minTime : 0.
  ;get corresponding data
        ;; cdb_y=maximus.(maxInd)(cdb_storm_i(i,0):cdb_storm_i(i,1))
        cdb_y=maximus.(maxInd)(plot_i)
        
        IF plot_i(0) GT -1 THEN plot=plot(cdb_t/3600., $
                                          (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                                          ;; XTITLE='Hours since '+maximus.time(cdb_storm_i(i,0)), $
                                          XTITLE='Hours since '+time_to_str(storm_utc(i,0),/msec), $
                                          YTITLE=mTags(maxInd), $
                                          XRANGE=[minTime,maxMinutes], $
                                          YRANGE=[minDat,maxDat], $
                                          LINESTYLE=' ', $
                                          SYMBOL='+', $
                                          XTICKFONT_SIZE=10, $
                                          XTICKFONT_STYLE=1, $
                                          ;; XTICKNAME=STRMID(tStr,0,12), $
                                          ;; XTICKVALUES=tArr, $
                                          LAYOUT=[1,4,i+1], $
                                          /CURRENT)
     ENDFOR
     
  ENDIF

END