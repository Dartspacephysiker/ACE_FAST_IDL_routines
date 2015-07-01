;+
;2015/06/25 The idea is to identify the times of sudden commencement rather than using the minimum DST val.
;-
PRO JOURNAL__20150625__identify_sudden_commencement_for_large_storms
  dataDir='/SPENCEdata/Research/Cusp/database/'
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ;defaults
  defTBeforeStorm      = 22.0D  ;in hours
  defTAfterStorm       = 16.0D  ;in hours
  defStormType         =  2
  
  defswDBDir           = 'sw_omnidata/'
  defswDBFile          = 'sw_data.dat'
  
  defStormDir          = 'sw_omnidata/'
  defStormFile         = 'large_and_small_storms--1985-2011--Anderson.sav'
  
  defDST_AEDir         = 'processed/'
  defDST_AEFile        = 'idl_ae_dst_data.dat'
  
  defDBDir             = 'dartdb/saves/'
  defDBFile            = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  defDB_tFile          = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
  
  defUse_SYMH          = 0
  
  defMaxInd            = 6
  defavg_type_maxInd   = 0
  defLogDBQuantity     = 0
  
  defNeg_and_pos_separ = 0
  defPos_layout= [1,1,1]
  defNeg_layout= [1,1,1]
  
  defSymTransp         = 97
  defLineTransp        = 60
  
  ;; ;For nEvent histos
  defnEvBinsize        = 60.0D  ;in minutes
  
  defSaveFile          = 0
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ;Check defaults
  IF N_ELEMENTS(tBeforeStorm) EQ 0 THEN tBeforeStorm = defTBeforeStorm
  IF N_ELEMENTS(tAfterStorm) EQ 0 THEN tAfterStorm = defTAfterStorm
  
  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile
  
  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir
  IF N_ELEMENTS(stormFile) EQ 0 THEN stormFile=defStormFile
  
  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile
  
  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile
  
  IF N_ELEMENTS(avg_type_maxInd) EQ 0 THEN avg_type_maxInd=defAvg_type_maxInd
  
  IF N_ELEMENTS(log_DBQuantity) EQ 0 THEN log_DBQuantity=defLogDBQuantity
  
  IF N_ELEMENTS(neg_and_pos_separ) EQ 0 THEN neg_and_pos_separ=defNeg_and_pos_separ
  IF N_ELEMENTS(pos_layout) EQ 0 Then pos_layout=defPos_layout
  IF N_ELEMENTS(neg_layout) EQ 0 Then neg_layout=defNeg_layout
  
  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH = defUse_SYMH
  
  IF N_ELEMENTS(nEvBinsize) EQ 0 THEN nEvBinsize=defnEvBinsize
  nEvBinsize = nEvBinsize/60.
  
  IF N_ELEMENTS(saveFile) EQ 0 THEN saveFile=defSaveFile
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ;Now restore 'em
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile
  totNStorm=N_ELEMENTS(stormStruct.time)
  
  IF ~use_SYMH THEN restore,dataDir+DST_AEDir+DST_AEFile
  
  restore,dataDir+defDBDir+DBFile
  restore,dataDir+defDBDir+DB_tFile
  
  IF saveFile THEN BEGIN 
     saveStr='save' 
     IF SIZE(saveFile,/TYPE) NE 7 THEN saveFile='superpose_storms_alfven_db_quantities.dat'
  ENDIF ELSE saveStr=''
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Get all storms occuring within specified range
  
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
     
     stormStruct_inds=WHERE(stormStruct.time GE startDate AND stormStruct.time LE stopDate,/NULL)
     
     ;; Check storm type
     IF N_ELEMENTS(stormType) EQ 0 THEN stormType=defStormType
     
     IF stormType EQ 1 THEN BEGIN ;Only large storms
        stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStruct.is_largeStorm EQ 1,/NULL))
        stormStr='large'
     ENDIF ELSE BEGIN
        IF stormType EQ 0 THEN BEGIN
           stormStruct_inds=cgsetintersection(stormStruct_inds,WHERE(stormStruct.is_largeStorm EQ 0,/NULL))
           stormStr='small'
        ENDIF ELSE BEGIN
           IF stormType EQ 2 THEN BEGIN
              stormStr='all'
           ENDIF
        ENDELSE
     ENDELSE
     
     PRINT,"Looking at " + stormStr + " storms per user instruction..."
     PRINT,STRCOMPRESS(N_ELEMENTS(stormStruct_inds),/REMOVE_ALL)+" storms out of " + STRCOMPRESS(totNStorm,/REMOVE_ALL) + " selected"
     
     nStorms=N_ELEMENTS(stormStruct_inds)     
     IF nStorms EQ 0 THEN BEGIN
        PRINT,"No storms found for given time range:"
        PRINT,"Start date: ",time_to_str(startDate)
        PRINT,"Stop date: ",time_to_str(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF
     
     ;; Generate a list of indices to be plotted from the selected geomagnetic index, either SYM-H or DST, and do dat
     datStartStop = MAKE_ARRAY(totNStorm,2,/DOUBLE)
     datStartStop(*,0) = stormstruct.time - tBeforeStorm*3600. ;(*,0) are the times before which we don't want data for each storm
     datStartStop(*,1) = stormstruct.time + tAfterStorm*3600.  ;(*,1) are the times after which we don't want data for each storm
     
     IF ~use_SYMH THEN BEGIN                                                                  ;Use DST for plots, not SYM-H
        ;; Now get a list of indices for DST data to be plotted for the storms found above
        geomag_plot_i_list = LIST(WHERE(DST.time GE datStartStop(stormStruct_inds(0),0) AND $ ;first initialize the list
                                        DST.time LE datStartStop(stormStruct_inds(0),1)))
        geomag_dat_list = LIST(dst.dst(geomag_plot_i_list(0)))
        geomag_time_list = LIST(dst.time(geomag_plot_i_list(0)))
        
        geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
        geomag_max = MAX(geomag_dat_list(0))
        
        FOR i=1,nStorms-1 DO BEGIN ;Then update it
           geomag_plot_i_list.add,WHERE(DST.time GE datStartStop(stormStruct_inds(i),0) AND $
                                        DST.time LE datStartStop(stormStruct_inds(i),1))
           geomag_dat_list.add,dst.dst(geomag_plot_i_list(i))
           geomag_time_list.add,dst.time(geomag_plot_i_list(i))

           tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
           IF tempMin LT geomag_min THEN geomag_min=tempMin
           IF tempMax GT geomag_max THEN geomag_max=tempMax
        ENDFOR
     ENDIF ELSE BEGIN           ;Use SYM-H for plots 
        
        swDat_UTC=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
        
        ;; Now get a list of indices for SYM-H data to be plotted for the storms found above
        geomag_plot_i_list = LIST(WHERE(swDat_UTC GE datStartStop(stormStruct_inds(0),0) AND $ ;first initialize the list
                                        swDat_UTC LE datStartStop(stormStruct_inds(0),1)))
        geomag_dat_list = LIST(sw_data.sym_h.dat(geomag_plot_i_list(0)))
        geomag_time_list = LIST(swDat_UTC(geomag_plot_i_list(0)))
        
        geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
        geomag_max = MAX(geomag_dat_list(0))
        
        FOR i=1,nStorms-1 DO BEGIN ;Then update it
           geomag_plot_i_list.add,WHERE(swDat_UTC GE datStartStop(stormStruct_inds(i),0) AND $
                                        swDat_UTC LE datStartStop(stormStruct_inds(i),1))
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




  ;; FOR i=0,nStorms-1 DO BEGIN

  ;;    IF N_ELEMENTS(geomag_time_list(i)) GT 1 THEN $

  ;;use this to plot storms and pick sudden commencement
i=3 & FOR j=0,N_ELEMENTS(geomag_time_list(i))-1 DO PRINT,FORMAT='(F0.4,T15,F0.4)',((geomag_time_list(i))(j)-stormStruct.time(stormStruct_inds(i)))/3600.,(geomag_dat_list(i))(j) & geomagPlot=plot((geomag_time_list(i)-stormStruct.time(stormStruct_inds(i)))/3600.,geomag_dat_list(i),XTITLE=xTitle,YTITLE=yTitle, XRANGE=xRange,YRANGE=yRange,XTICKFONT_SIZE=10,XTICKFONT_STYLE=1,/CURRENT,/OVERPLOT,SYM_TRANSPARENCY=defSymTransp,TRANSPARENCY=defLineTransp)

  ;; geomagPlot=plot((geomag_time_list(i)-stormStruct.time(stormStruct_inds(i)))/3600.,geomag_dat_list(i), $
  ;;                 XTITLE=xTitle, $
  ;;                 YTITLE=yTitle, $
  ;;                 XRANGE=xRange, $
  ;;                 YRANGE=yRange, $
  ;;                 XTICKFONT_SIZE=10, $
  ;;                 XTICKFONT_STYLE=1, $
  ;;                 ;; LAYOUT=[1,4,i+1], $
  ;;                 /CURRENT,/OVERPLOT, $
  ;;                 SYM_TRANSPARENCY=defSymTransp, $
  ;;                 TRANSPARENCY=defLineTransp)
  
  ;; ENDFOR

END