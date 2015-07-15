PRO STORMS__STATISTICS_OF_NEVENTS_RANDOMTIMES,NRANDTIME=nRandTime,STARTDATE=startDate, STOPDATE=stopDate,STORMTYPE=stormType, $
   TBEFORERANDTIME=tBeforeRandTime,TAFTERRANDTIME=tAfterRandTime, $
   MAXIND=maxInd,LOG_DBQUANTITY=log_DBquantity, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   USE_SYMH=use_symh, $
   NO_SUPERPOSE=no_superpose, $
   STORMFILE=stormFile, $
   NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   OVERLAY_NEVENTHISTS=overlay_nEventHists, NEVRANGE=nEvRange,RET_NEV_tbins_and_HIST=ret_nEv_tbins_and_Hist,RET_MAXIMUS_I_LIST=ret_maximus_i_list, $
   DST=dst,MAXIMUS=maximus,CDBTIME=cdbTime,SW_DATA=sw_data
  
  dataDir='/SPENCEdata/Research/Cusp/database/'
  date='20150615'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  defTBeforeRandTime  = 22.0D                                                                       ;in hours
  defTAfterRandTime   = 16.0D                                                                       ;in hours
  defStormType     =  2

  defswDBDir       = 'sw_omnidata/'
  defswDBFile      = 'sw_data.dat'
                   
  defStormDir      = 'processed/'
  ;; defStormFiles     = 'large_and_small_storms--1985-2011--Anderson.sav'
  defStormFile     = ['superposed_small_storm_output_w_n_Alfven_events--'+date+'.dat', $
                      'superposed_large_storm_output_w_n_Alfven_events--'+date+'.dat', $
                      'superposed_all_storm_output_w_n_Alfven_events--'+date+'.dat']

  defUse_SYMH      = 0

  defDST_AEDir     = 'processed/'
  defDST_AEFile    = 'idl_ae_dst_data.dat'
                   
  defDBDir         = 'dartdb/saves/'
  defDBFile        = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  defDB_tFile      = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
                   
  defMaxInd        = 6
  defLogDBQuantity = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Check defaults

  ;; ;; Actually, let's handle these below when we re-load one of the storm files
  ;; IF N_ELEMENTS(tBeforeRandTime) EQ 0 THEN tBeforeRandTime = defTBeforeRandTime
  ;; IF N_ELEMENTS(tAfterRandTime) EQ 0 THEN tAfterRandTime = defTAfterRandTime

  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile

  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir

  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile

  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH=defUse_SYMH

  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile

  ;; IF N_ELEMENTS(nEvBinsize) EQ 0 THEN nEvBinsize=defnEvBinsize

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  IF N_ELEMENTS(sw_data) EQ 0 THEN restore,dataDir+swDBDir+swDBFile

  IF ~use_SYMH THEN BEGIN
     IF N_ELEMENTS(dst) EQ 0 THEN restore,dataDir+DST_AEDir+DST_AEFile
  ENDIF

  IF N_ELEMENTS(maximus) EQ 0 THEN restore,dataDir+defDBDir+DBFile
  IF N_ELEMENTS(cdbTime) EQ 0 THEN restore,dataDir+defDBDir+DB_tFile

  ;; Check storm type to determine which file we restore
  ;; IF ~KEYWORD_SET(nRandTime) AND ~KEYWORD_SET(tBeforeRandTime) AND ~KEYWORD_SET(tAfterRandTime) THEN BEGIN
  IF N_ELEMENTS(stormFile) EQ 0 THEN BEGIN
     stormFile=defStormFile
     IF N_ELEMENTS(stormType) EQ 0 THEN stormType=defStormType
     IF stormType EQ 1 THEN BEGIN ;Only large storms
        stormStr='large'
     ENDIF ELSE BEGIN
        IF stormType EQ 0 THEN BEGIN
           stormStr='small'
        ENDIF ELSE BEGIN
           IF stormType EQ 2 THEN BEGIN
              stormStr='all'
           ENDIF
        ENDELSE
     ENDELSE
     PRINT,"Looking at " + stormStr + " storms per user instruction..."
     restore,dataDir+stormDir+stormFile[stormType]
  ENDIF ELSE BEGIN
     PRINT,'Restoring user-supplied storm file: ' + stormFile
     restore,stormFile
  ENDELSE
     
  ;;get a few variables from restored storm file
  ;; totNRandTime=N_ELEMENTS(geomag_plot_i_list)
  totNRandTime=(KEYWORD_SET(nRandTime) ? nRandTime : N_ELEMENTS(geomag_plot_i_list))
  IF ~KEYWORD_SET(tBeforeRandTime) THEN tBeforeRandTime=tBeforeStorm
  IF ~KEYWORD_SET(tAfterRandTime) THEN tAfterRandTime=tAfterStorm
  ;; ENDIF

  PRINT,'Total number of random times: ' + STRCOMPRESS(totNRandTime,/REMOVE_ALL)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Make a randomtimes struct which parallels that of the stormStruct used in the pro superpose_storms[...]
  
  tempTimes=RANDOMU(seed,totNRandTime,/DOUBLE)*(stopDate-startDate)+startDate
  tempTimes=tempTimes(SORT(tempTimes))
  randTStruct={time:tempTimes, $
               tStamp:time_to_str(tempTimes)}
 
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all randomtimes occuring within specified range

  IF KEYWORD_SET(use_dartdb_start_enddate) THEN BEGIN
     startDate=str_to_time(maximus.time(0))
     stopDate=str_to_time(maximus.time(-1))
     PRINT,'Using start and stop time from Dartmouth/Chaston database.'
     PRINT,'Start time: ' + maximus.time(0)
     PRINT,'Stop time: ' + maximus.time(-1)
  ENDIF

  IF KEYWORD_SET(STARTDATE) THEN BEGIN
     IF N_ELEMENTS(STOPDATE) EQ 0 THEN BEGIN
        PRINT,"No stop year specified! Plotting data up to a full year after startDate."
        stopDate=startDate+86400.*31.*12.
     ENDIF
     
     randTStruct_inds=WHERE(randTStruct.time GE startDate AND randTStruct.time LE stopDate,/NULL)
     
     PRINT,STRCOMPRESS(N_ELEMENTS(randTStruct_inds),/REMOVE_ALL)+" storms out of " + STRCOMPRESS(totNRandTime,/REMOVE_ALL) + " selected"

     nRandTime=N_ELEMENTS(randTStruct_inds)
     IF nRandTime EQ 0 THEN BEGIN
        PRINT,"No randTimes found for given time range:"
        PRINT,"Start date: ",time_to_str(startDate)
        PRINT,"Stop date: ",time_to_str(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF
     
     ;; Generate a list of indices to be plotted from the selected geomagnetic index, either SYM-H or DST, and do dat
     datStartStop = MAKE_ARRAY(totNRandTime,2,/DOUBLE)
     datStartStop(*,0) = randTStruct.time - tBeforeRandTime*3600.                    ;(*,0) are the times before which we don't want data for each storm
     datStartStop(*,1) = randTStruct.time + tAfterRandTime*3600.                     ;(*,1) are the times after which we don't want data for each storm
     
     IF ~use_SYMH THEN BEGIN                               ;Use DST for plots, not SYM-H
        ;; Now get a list of indices for DST data to be plotted for the storms found above
        geomag_plot_i_list = LIST(WHERE(DST.time GE datStartStop(randTStruct_inds(0),0) AND $    ;first initialize the list
                                        DST.time LE datStartStop(randTStruct_inds(0),1)))
        geomag_dat_list = LIST(dst.dst(geomag_plot_i_list(0)))
        geomag_time_list = LIST(dst.time(geomag_plot_i_list(0)))

        geomag_min = MIN(geomag_dat_list(0))                                                     ;For plots, we need the range
        geomag_max = MAX(geomag_dat_list(0))

        FOR i=1,nRandTime-1 DO BEGIN                                                               ;Then update it
           geomag_plot_i_list.add,WHERE(DST.time GE datStartStop(randTStruct_inds(i),0) AND $
                                        DST.time LE datStartStop(randTStruct_inds(i),1))
           geomag_dat_list.add,dst.dst(geomag_plot_i_list(i))
           geomag_time_list.add,dst.time(geomag_plot_i_list(i))

           tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
           IF tempMin LT geomag_min THEN geomag_min=tempMin
           IF tempMax GT geomag_max THEN geomag_max=tempMax
        ENDFOR
     ENDIF ELSE BEGIN                                                                            ;Use SYM-H for plots 
        
        swDat_UTC=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D                               ;For conversion between SW DB and ours
        
        ;; Now get a list of indices for SYM-H data to be plotted for the storms found above
        geomag_plot_i_list = LIST(WHERE(swDat_UTC GE datStartStop(randTStruct_inds(0),0) AND $   ;first initialize the list
                                        swDat_UTC LE datStartStop(randTStruct_inds(0),1)))
        geomag_dat_list = LIST(sw_data.sym_h.dat(geomag_plot_i_list(0)))
        geomag_time_list = LIST(swDat_UTC(geomag_plot_i_list(0)))

        geomag_min = MIN(geomag_dat_list(0))                                                     ;For plots, we need the range
        geomag_max = MAX(geomag_dat_list(0))

        FOR i=1,nRandTime-1 DO BEGIN                                                               ;Then update it
           geomag_plot_i_list.add,WHERE(swDat_UTC GE datStartStop(randTStruct_inds(i),0) AND $
                                        swDat_UTC LE datStartStop(randTStruct_inds(i),1))
           geomag_dat_list.add,sw_data.sym_h.dat(geomag_plot_i_list(i))
           geomag_time_list.add,swDat_UTC(geomag_plot_i_list(i))

           tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
           IF tempMin LT geomag_min THEN geomag_min=tempMin
           IF tempMax GT geomag_max THEN geomag_max=tempMax
        ENDFOR
     ENDELSE
  ENDIF ELSE BEGIN
     PRINT,"No start date provided! Please specify one in UTC time, seconds since Jan 1, 1970."
     RETURN
  ENDELSE

  ;Get nearest events in Chaston DB
  ;; cdb_randT_t=MAKE_ARRAY(totNRandT,2,/DOUBLE)
  ;; cdb_randT_i=MAKE_ARRAY(totNRandT,2,/L64)
  cdb_randT_t=MAKE_ARRAY(nRandTime,2,/DOUBLE)
  cdb_randT_i=MAKE_ARRAY(nRandTime,2,/L64)
  FOR i=0,nRandTime-1 DO BEGIN
     FOR j=0,1 DO BEGIN
        tempClosest=MIN(ABS(datStartStop(randTStruct_inds(i),j)-cdbTime),tempClosest_i)
        cdb_randT_i(i,j)=tempClosest_i
        cdb_randT_t(i,j)=cdbTime(tempClosest_i)
     ENDFOR
  ENDFOR

  ;And NOW let's plot quantity from the Alfven DB to see how it fares during randTs
  ;; IF KEYWORD_SET(maxInd) THEN BEGIN
  maxInd=6
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS)
  mTags=TAG_NAMES(maximus)
  
  ;; Get ranges for plots
  maxMinutes=MAX((cdbTime(cdb_randT_i(*,1))-cdbTime(cdb_randT_i(*,0)))/3600.,longestRandT_i,MIN=minMinutes)
  
  minMaxDat=MAKE_ARRAY(nRandTime,2,/DOUBLE) 
  FOR i=0,nRandTime-1 DO BEGIN
     minMaxDat(i,1)=MAX(maximus.(maxInd)(cdb_randT_i(i,0):cdb_randT_i(i,1)),MIN=tempMin)
     minMaxDat(i,0)=tempMin
  ENDFOR
     
  IF KEYWORD_SET(log_DBquantity) THEN BEGIN
     maxDat=ALOG10(MAX(minMaxDat(*,1)))
     minDat=ALOG10(MIN(minMaxDat(*,0)))
  ENDIF ELSE BEGIN
     maxDat=MAX(minMaxDat(*,1))
     minDat=MIN(minMaxDat(*,0))
  ENDELSE
  
  FOR i=0,nRandTime-1 DO BEGIN
     
     
     ;; get appropriate indices
     plot_i=cgsetintersection(good_i,indgen(cdb_randT_i(i,1)-cdb_randT_i(i,0)+1)+cdb_randT_i(i,0))
     
     ;; get relevant time range
     cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(randTStruct.time(randTStruct_inds(i))))/3600.
     
     cdb_y=maximus.(maxInd)(plot_i)
     
     IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN
        IF i EQ 0 THEN ret_maximus_i_list = LIST(plot_i) $
        ELSE ret_maximus_i_list.add,plot_i
     ENDIF
     
  ENDFOR
  
  ;; ENDIF
  
END