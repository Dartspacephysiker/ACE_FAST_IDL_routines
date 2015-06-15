;+
; NAME:                           SUPERPOSE_RANDOMTIMES_AND_ALFVEN_DB_QUANTITIES
;
; PURPOSE:                        TAKE A LIST OF RANDOMTIMES, SUPERPOSE THE RANDOMTIMES AS WELL AS THE RELEVANT DB QUANTITIES
;
; CATEGORY:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          TBEFORERAN_T      : Amount of time (hours) to plot before a given DST min
;                              TAFTERRAN_T       : Amount of time (hours) to plot after a given DST min
;                              STARTDATE         : Include randomtimes starting with this time (in seconds since Jan 1, 1970)
;                              STOPDATE          : Include randomtimes up to this time (in seconds since Jan 1, 1970)
;                              STORMTYPE         : '0'=small, '1'=large, '2'=all
;                              USE_SYMH          : Use SYM-H geomagnetic index instead of DST for plots of ran_t epoch.
;                              NEVENTHISTS       : Create histogram of number of Alfvén events relative to ran_t epoch
;                              STATFILE          : Save generated K-S statistics to this file.
;                              DO_KSSTATS        : Calculate Kolmogorov-Smirnov statistic and associated p-value for the
;                                                  storm-time cdf and random-time cdf. (Two-sample K-S statistic.)
;
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


PRO superpose_randomtimes_and_alfven_db_quantities,NRANDTIMES=nRandTimes,STARTDATE=startDate, STOPDATE=stopDate,STORMTYPE=stormType, $
   TBEFORERANDTIME=tBeforeRandTime,TAFTERRANDTIME=tAfterRandTime, $
   MAXIND=maxInd,LOG_DBQUANTITY=log_DBquantity, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   USE_SYMH=use_symh, $
   NO_SUPERPOSE=no_superpose, $
   NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   DO_KSSTATS=do_ksstats
  
  dataDir='/SPENCEdata/Research/Cusp/database/'

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

  defDST_AEDir     = 'processed/'
  defDST_AEFile    = 'idl_ae_dst_data.dat'
                   
  defDBDir         = 'dartdb/saves/'
  defDBFile        = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  defDB_tFile      = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
                   
  defUse_SYMH      = 0

  defMaxInd        = 6
  defLogDBQuantity = 0

  defSymTransp     = 97
  defLineTransp    = 85
  ;; plotScaleString='Hours'
  ;; plotScaleString='Minutes'

  ;; ;For nEvent histos
  defnEvBinsize    = 60.0D                                                                        ;in minutes

  defDo_KSStats    = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Check defaults
  IF N_ELEMENTS(tBeforeRandTime) EQ 0 THEN tBeforeRandTime = defTBeforeRandTime
  IF N_ELEMENTS(tAfterRandTime) EQ 0 THEN tAfterRandTime = defTAfterRandTime

  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile

  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir
  IF N_ELEMENTS(stormFile) EQ 0 THEN stormFile=defStormFile

  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile

  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile

  IF N_ELEMENTS(log_DBQuantity) EQ 0 THEN log_DBQuantity=defLogDBQuantity

  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH = defUse_SYMH

  IF N_ELEMENTS(nEvBinsize) EQ 0 THEN nEvBinsize=defnEvBinsize

  IF N_ELEMENTS(do_KSStats) EQ 0 THEN do_KSStats = defDo_KSStats

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile
  totNRandTime=N_ELEMENTS(randTStruct.time)

  IF ~use_SYMH THEN restore,dataDir+DST_AEDir+DST_AEFile

  restore,dataDir+defDBDir+DBFile
  restore,dataDir+defDBDir+DB_tFile

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
     
     ;; Check storm type
     IF N_ELEMENTS(stormType) EQ 0 THEN stormType=defStormType
     IF stormType EQ 1 THEN BEGIN                                                                ;Only large storms
        ;; stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStruct.is_largeStorm EQ 1,/NULL))
        stormStr='large'
     ENDIF ELSE BEGIN
        IF stormType EQ 0 THEN BEGIN
           ;; stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStruct.is_largeStorm EQ 0,/NULL))
           stormStr='small'
        ENDIF ELSE BEGIN
           IF stormType EQ 2 THEN BEGIN
              stormStr='all'
           ENDIF
        ENDELSE
     ENDELSE
     restore,dataDir+stormDir+stormFile[stormType]

     PRINT,"Looking at " + stormStr + " storms per user instruction..."
     PRINT,STRCOMPRESS(N_ELEMENTS(stormStruct_inds),/REMOVE_ALL)+" storms out of " + STRCOMPRESS(totNStorm,/REMOVE_ALL) + " selected"

     nRandTimes=N_ELEMENTS(randTStruct_inds)
     IF nRandTimes EQ 0 THEN BEGIN
        PRINT,"No randTimes found for given time range:"
        PRINT,"Start date: ",time_to_str(startDate)
        PRINT,"Stop date: ",time_to_str(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF
     
     ;; Generate a list of indices to be plotted from the selected geomagnetic index, either SYM-H or DST, and do dat
     datStartStop = MAKE_ARRAY(totNRandTime,2,/DOUBLE)
     datStartStop(*,0) = randTStruct.time - tBeforeStorm*3600.                          ;(*,0) are the times before which we don't want data for each storm
     datStartStop(*,1) = randTStruct.time + tAfterStorm*3600.                           ;(*,1) are the times after which we don't want data for each storm
     
     IF ~use_SYMH THEN BEGIN                               ;Use DST for plots, not SYM-H
        ;; Now get a list of indices for DST data to be plotted for the storms found above
        geomag_plot_i_list = LIST(WHERE(DST.time GE datStartStop(randTStruct_inds(0),0) AND $    ;first initialize the list
                                        DST.time LE datStartStop(randTStruct_inds(0),1)))
        geomag_dat_list = LIST(dst.dst(geomag_plot_i_list(0)))
        geomag_time_list = LIST(dst.time(geomag_plot_i_list(0)))

        geomag_min = MIN(geomag_dat_list(0))                                                     ;For plots, we need the range
        geomag_max = MAX(geomag_dat_list(0))

        FOR i=1,nStorms-1 DO BEGIN                                                               ;Then update it
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

        FOR i=1,nStorms-1 DO BEGIN                                                               ;Then update it
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
  cdb_randT_t=MAKE_ARRAY(nRandTs,2,/DOUBLE)
  cdb_randT_i=MAKE_ARRAY(nRandTs,2,/L64)
  FOR i=0,nRandTs-1 DO BEGIN
     FOR j=0,1 DO BEGIN
        tempClosest=MIN(ABS(datStartStop(randTStruct_inds(i),j)-cdbTime),tempClosest_i)
        cdb_randT_i(i,j)=tempClosest_i
        cdb_randT_t(i,j)=cdbTime(tempClosest_i)
     ENDFOR
  ENDFOR

  ;Now plot geomag quantities
  IF KEYWORD_SET(no_superpose) THEN BEGIN
     plotWind=WINDOW(WINDOW_TITLE="SYM-H plots", $
                     DIMENSIONS=[1200,900])
     
     ;; FOR i=0,3 DO BEGIN
        
     ;;                                                                                             ;make a string array for plot
     ;;    factor=1440                                   ;leave this as 1440 (n minutes in a day), since randT_i has a separation of 1 min between data points
     ;;    nTimes=(randT_i(i,1) - randT_i(i,0)) / factor + 1
     ;;    tArr=INDGEN(nTimes,/L64)*factor/60.
     ;;    tStr=MAKE_ARRAY(nTimes,/STRING)
     ;;    FOR t=0L,nTimes-1 DO tStr[t] = cdf_encode_epoch(sw_data.epoch.dat(randT_i(i,0)+factor*t)) ;strings for each day
        
     ;; ENDFOR
  ENDIF ELSE BEGIN ;Just do a regular superposition of all the plots

     plotWind=WINDOW(WINDOW_TITLE="Superposed randT plots: "+ $
                     randTStruct.tStamp(randTStruct_inds(0)) + " - " + $
                     randTStruct.tStamp(randTStruct_inds(-1)), $
                     DIMENSIONS=[1200,900])
     xTitle='Hours since randT commencement'
     yTitle=(~use_SYMH) ? 'DST (nT)' : 'SYM-H (nT)'
     
     xRange=[-tBeforeRandT,tAfterRandT]
     yRange=[geomag_min,geomag_max]
     ;; yRange=[-350,50]
     
     FOR i=0,nRandTs-1 DO BEGIN

        plot=plot((geomag_time_list(i)-randTStruct.time(randTStruct_inds(i)))/3600.,geomag_dat_list(i), $
                  XTITLE=xTitle, $
                  YTITLE=yTitle, $
                  XRANGE=xRange, $
                  YRANGE=yRange, $
                  XTICKFONT_SIZE=10, $
                  XTICKFONT_STYLE=1, $
                  LAYOUT=[1,4,i+1], $
                  /CURRENT,/OVERPLOT, $
                  SYM_TRANSPARENCY=defSymTransp, $
                  TRANSPARENCY=defLineTransp)
     ENDFOR
  ENDELSE

  ;And NOW let's plot quantity from the Alfven DB to see how it fares during randTs
  IF KEYWORD_SET(maxInd) THEN BEGIN
     good_i=get_chaston_ind(maximus,"OMNI",-1,/NORTHANDSOUTH)
     mTags=TAG_NAMES(maximus)
     
     plotWind=WINDOW(WINDOW_TITLE="Maximus plots", $
                     DIMENSIONS=[1200,900])
     
     ;; Get ranges for plots
     maxMinutes=MAX((cdbTime(cdb_randT_i(*,1))-cdbTime(cdb_randT_i(*,0)))/3600.,longestRandT_i,MIN=minMinutes)
     minMaxDat=MAKE_ARRAY(nRandTs,2,/DOUBLE)
     
     
     FOR i=0,nRandTs-1 DO BEGIN
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
     
     ;; now plot DB quantity
     xTitle='Hours since randT commencement'
     ;; yTitle='Maximus:
     
     xRange=[-tBeforeRandT,tAfterRandT]
     yRange=[geomag_min,geomag_max]
     FOR i=0,nRandTs-1 DO BEGIN
        
        ;; get appropriate indices
        plot_i=cgsetintersection(good_i,indgen(cdb_randT_i(i,1)-cdb_randT_i(i,0)+1)+cdb_randT_i(i,0))
        
        ;; get relevant time range
        cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(randTStruct.time(randTStruct_inds(i))))/3600.
        ;; minTime=MIN(cdb_t)
        ;; minTime=(minTime LT 0) ? minTime : 0.

        ;; get corresponding data
        ;; cdb_y=maximus.(maxInd)(cdb_randT_i(i,0):cdb_randT_i(i,1))
        cdb_y=maximus.(maxInd)(plot_i)
        
        IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN
           ;; print,'n plot points: ',n_elements(plot_i)
           ;; print,min(cdb_y)
           ;; print,max(cdb_y)
           ;; print,min(cdb_t)
           ;; print,max(cdb_t)
           plot=plot(cdb_t, $
                     (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                     XTITLE='Hours since randT commencement', $
                     ;; XTITLE='Hours since '+time_to_str(randT_utc(i,0),/msec), $
                     YTITLE=mTags(maxInd), $
                     XRANGE=xRange, $
                     ;; YRANGE=[minDat,maxDat], $
                     YRANGE=[-300,300], $
                     ;; YAXIS=1, $
                     LINESTYLE=' ', $
                     SYMBOL='+', $
                     XTICKFONT_SIZE=10, $
                     XTICKFONT_STYLE=1, $
                     ;; XTICKNAME=STRMID(tStr,0,12), $
                     ;; XTICKVALUES=tArr, $
                     ;; LAYOUT=[1,4,i+1], $
                     /CURRENT,OVERPLOT=(i EQ 0) ? 0: 1, $
                     SYM_TRANSPARENCY=defSymTransp)


           IF KEYWORD_SET(nEventHists) THEN BEGIN                                                ;Histos of Alfvén events relative to randT epoch
              
              IF i GT 0 THEN BEGIN
                 nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                   MAX=tAfterRandT,MIN=-tBeforeRandT, $
                                   BINSIZE=nEvBinsize/60., $
                                   INPUT=nEvHist)
                 nEvTot+=N_ELEMENTS(plot_i)
              ENDIF ELSE BEGIN
                 nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                   MAX=tAfterRandT,MIN=-tBeforeRandT, $
                                   BINSIZE=nEvBinsize/60.)
                 nEvTot=N_ELEMENTS(plot_i)
              ENDELSE
           ENDIF                                                                                 ;end nEventHists
        ENDIF
     
     ENDFOR

     IF KEYWORD_SET(nEventHists) THEN BEGIN
        plotWind=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                        DIMENSIONS=[1200,900])
        plot_nEv=plot(tBin,nEvHist, $
                      /STAIRSTEP, $
                      TITLE='Number of Alfvén events relative to randT epoch for ' + randTStr + ' randTs, ' + $
                      randTStruct.tStamp(randTStruct_inds(0)) + " - " + $
                      randTStruct.tStamp(randTStruct_inds(-1)), $
                      XTITLE='Hours since randT commencement', $
                      YTITLE='Number of Alfvén events', $
                      /CURRENT, LAYOUT=[2,1,1],COLOR='red')

        cNEvHist = TOTAL(nEvHist, /CUMULATIVE) / nEvTot
        cdf_nEv=plot(tBin,cNEvHist, $
                     XTITLE='Hours since randT commencement', $
                     YTITLE='Cumulative number of Alfvén events', $
                     /CURRENT, LAYOUT=[2,1,2], AXIS_STYLE=1,COLOR='blue')

        IF do_KSStats THEN BEGIN                                                                 ;Calculate K-S statistics
           
        ENDIF

     ENDIF

  ENDIF

  ;; IF statFile THEN save,randt

END