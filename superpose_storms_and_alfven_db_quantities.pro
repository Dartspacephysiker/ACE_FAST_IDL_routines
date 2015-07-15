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
;                              USE_SYMH          : Use SYM-H geomagnetic index instead of DST for plots of storm epoch.
;                              NEVENTHISTS       : Create histogram of number of Alfvén events relative to storm epoch
;                              NEG_AND_POS_SEPAR : Do plots of negative and positive log numbers separately
;                              MAXIND            : Index into maximus structure; plot corresponding quantity as a function of time
;                                                    since storm commencement (e.g., MAXIND=6 corresponds to mag current).
;                              AVG_TYPE_MAXIND   : Type of averaging to perform for events in a particular time bin.
;                                                    1: standard averaging; 2: log averaging
;                              NEG_AND_POS_LAYOUT: Set to array of plot layout for pos_and_neg_plots
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
;                         2015/06/25 Added ability to specify a subset of storms through keyword SUBSET_OF_STORMS, and an
;                         associated offset via keyword HOUR_OFFSET_OF_SUBSET. This is done because it appears what I am
;calling 'storm commencement' is actually just the minimum DST of the storm, or something like the peak of the main phase. I want
;to know how Alfvén waves respond to true storm commencement, you know? 
;                           
;-


PRO superpose_storms_and_alfven_db_quantities,stormTimeArray,STARTDATE=startDate, STOPDATE=stopDate, STORMTYPE=stormType, $
   TBEFORESTORM=tBeforeStorm,TAFTERSTORM=tAfterStorm, $
   DAYSIDE=dayside,NIGHTSIDE=nightside, $
   MAXIND=maxInd, AVG_TYPE_MAXIND=avg_type_maxInd, $
   USER_SPECIFIED_MAXQUANTITY=user_specified_maxQuantity, $
   YRANGE_MAXIND=yRange_maxInd, $
   LOG_DBQUANTITY=log_DBquantity, $
   NEG_AND_POS_SEPAR=neg_and_pos_separ, POS_LAYOUT=pos_layout, NEG_LAYOUT=neg_layout, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   USE_SYMH=use_SYMH, $
   USE_AE=use_AE, $
   NO_SUPERPOSE=no_superpose, $
   NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, OVERLAY_NEVENTHISTS=overlay_nEventHists, NEVRANGE=nEvRange, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   SUBSET_OF_STORMS=subset_of_storms,HOUR_OFFSET_OF_SUBSET=hour_offset_of_subset, $
   RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
   SAVEFILE=saveFile, $
   TITLESUFF=titleSuff, $
   RETURNED_NEV_tbins_and_HIST=returned_nEv_tbins_and_Hist, BKGRND_HIST=bkgrnd_hist
  
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
  defDBFile            = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus--wpFlux.sav'  
  defDB_tFile          = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
  
  defUse_SYMH          = 0
  defUse_AE            = 0
  defMaxInd            = 6
  defavg_type_maxInd   = 0
  defLogDBQuantity     = 0
  
  defNeg_and_pos_separ = 0
  defPos_layout= [1,1,1]
  defNeg_layout= [1,1,1]
  
  defSymTransp         = 97
  defLineTransp        = 76
  defLineThick         = 2.5
  
  defRestrict_altRange = 0
  defRestrict_charERange = 0

  ;; ;For nEvent histos
  defnEvBinsize        = 60.0D  ;in minutes
  defOverlay_nEventHists= 0
  plotMargin=[0.10, 0.10, 0.10, 0.1]
  
  defSaveFile          = 0

  defTitleSuff         = ''
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Check defaults
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
  IF N_ELEMENTS(use_AE) EQ 0 THEN use_AE = defUse_AE
  
  IF N_ELEMENTS(nEvBinsize) EQ 0 THEN nEvBinsize=defnEvBinsize
  nEvBinsize = nEvBinsize/60.
  IF N_ELEMENTS(overlay_nEventHists) EQ 0 THEN overlay_nEventHists=defOverlay_nEventHists

  IF N_ELEMENTS(saveFile) EQ 0 THEN saveFile=defSaveFile
  
  IF KEYWORD_SET(dayside) THEN print,"Only considering dayside stuff!"
  IF KEYWORD_SET(nightside) THEN print,"Only considering nightside stuff!"

  IF N_ELEMENTS(restrict_charERange) EQ 0 THEN restrict_charERange = defRestrict_charERange
  IF N_ELEMENTS(restrict_altRange) EQ 0 THEN restrict_altRange = defRestrict_altRange

  IF N_ELEMENTS(titleSuff) EQ 0 THEN titleSuff=defTitleSuff

  ;;defs for maxPlots
  max_xtickfont_size=18
  max_xtickfont_style=1
  max_ytickfont_size=18
  max_ytickfont_style=1
  avg_symSize=2.0
  avg_symThick=2.0
  avg_Thick=2.5
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now restore 'em
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile
  totNStorm=N_ELEMENTS(stormStruct.time)
  
  IF ~use_SYMH AND ~use_AE THEN restore,dataDir+DST_AEDir+DST_AEFile
  
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
     
     IF KEYWORD_SET(subset_of_storms) THEN BEGIN
        PRINT,"Only looking at a subset of selected storms!"
        stormStruct_inds=stormStruct_inds(subset_of_storms)
     ENDIF
     
     nStorms=N_ELEMENTS(stormStruct_inds)     
     PRINT,STRCOMPRESS(N_ELEMENTS(stormStruct_inds),/REMOVE_ALL)+" storms out of " + STRCOMPRESS(totNStorm,/REMOVE_ALL) + " selected"
     
     IF nStorms EQ 0 THEN BEGIN
        PRINT,"No storms found for given time range:"
        PRINT,"Start date: ",time_to_str(startDate)
        PRINT,"Stop date: ",time_to_str(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF
     
     ;; Generate a list of indices to be plotted frobm the selected geomagnetic index, either SYM-H or DST, and do dat
     datStartStop = MAKE_ARRAY(totNStorm,2,/DOUBLE)
     datStartStop(*,0) = stormstruct.time - tBeforeStorm*3600. ;(*,0) are the times before which we don't want data for each storm
     datStartStop(*,1) = stormstruct.time + tAfterStorm*3600.  ;(*,1) are the times after which we don't want data for each storm
     
     IF KEYWORD_SET(hour_offset_of_subset) THEN BEGIN
        PRINT,"User trickery: Specifying an additional time offset"
        IF N_ELEMENTS(hour_offset_of_subset) NE N_ELEMENTS(subset_of_storms) THEN BEGIN
           PRINT,"Must have equal numbers of hour offsets specified and number of storms selected via keyword 'subset_of_storms'."
           PRINT,"Roll out."
           RETURN
        ENDIF
        
        datStartStop(stormstruct_inds,0)=datStartStop(stormstruct_inds,0)+hour_offset_of_subset*3600.
        datStartStop(stormstruct_inds,1)=datStartStop(stormstruct_inds,1)+hour_offset_of_subset*3600.
        PRINT,"Storm #    Storm date            Min DST  User-specified storm offset"
        
        FOR k=0,n_elements(hour_offset_of_subset)-1 DO BEGIN
           ind=stormStruct_inds(k)
           PRINT,FORMAT='(I0,T12,A0,T34,I0,T43,I0)',ind,stormstruct.tstamp(ind),stormstruct.dst(ind),hour_offset_of_subset(k)
        ENDFOR
     ENDIF
     
     IF ~use_SYMH AND ~use_AE THEN BEGIN                                                      ;Use DST for plots, not SYM-H
        ;; Now get a list of indices for DST data to be plotted for the storms found above
        yTitle='Dst (nT)'
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
     ENDIF ELSE BEGIN                                              ;Use SYM-H for plots 
        swDat_UTC=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
        
        ;; Now get a list of indices for SYM-H data to be plotted for the storms found above
        geomag_plot_i_list = LIST(WHERE(swDat_UTC GE datStartStop(stormStruct_inds(0),0) AND $ ;first initialize the list
                                        swDat_UTC LE datStartStop(stormStruct_inds(0),1)))
        geomag_time_list = LIST(swDat_UTC(geomag_plot_i_list(0)))
        
        IF use_SYMH THEN BEGIN
           geomag_dat_list = LIST(sw_data.sym_h.dat(geomag_plot_i_list(0)))
           
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
        ENDIF ELSE BEGIN
           IF use_AE THEN BEGIN
              geomag_dat_list = LIST(sw_data.ae_index.dat(geomag_plot_i_list(0)))
              
              geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
              geomag_max = MAX(geomag_dat_list(0))
              
              FOR i=1,nStorms-1 DO BEGIN ;Then update it
                 geomag_plot_i_list.add,WHERE(swDat_UTC GE datStartStop(stormStruct_inds(i),0) AND $
                                              swDat_UTC LE datStartStop(stormStruct_inds(i),1))
                 geomag_dat_list.add,sw_data.ae_index.dat(geomag_plot_i_list(i))
                 geomag_time_list.add,swDat_UTC(geomag_plot_i_list(i))
                 
                 tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
                 IF tempMin LT geomag_min THEN geomag_min=tempMin
                 IF tempMax GT geomag_max THEN geomag_max=tempMax
              ENDFOR
              
           ENDIF
        ENDELSE
     ENDELSE
  ENDIF ELSE BEGIN
     PRINT,"No start date provided! Please specify one in UTC time, seconds since Jan 1, 1970."
     RETURN
  ENDELSE
  
  ;;Get nearest events in Chaston DB
  cdb_storm_t=MAKE_ARRAY(nStorms,2,/DOUBLE)
  cdb_storm_i=MAKE_ARRAY(nStorms,2,/L64)
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS, $
                         ALTITUDERANGE=(restrict_altRange) ? [1000,5000] : !NULL, $
                         CHARERANGE=(restrict_charERange) ? [4,300] : !NULL, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside)
  
  FOR i=0,nStorms-1 DO BEGIN
     FOR j=0,1 DO BEGIN
        tempClosest=MIN(ABS(datStartStop(stormStruct_inds(i),j)-cdbTime(good_i)),tempClosest_ii)
        cdb_storm_i(i,j)=good_i(tempClosest_ii)
        cdb_storm_t(i,j)=cdbTime(good_i(tempClosest_ii))
     ENDFOR
  ENDFOR
  
  IF saveFile THEN saveStr+=',startDate,stopDate,stormType,stormStruct_inds,tBeforeStorm,tAfterStorm,geomag_min,geomag_max,geomag_plot_i_list,geomag_dat_list,geomag_time_list,dbFile'
  ;;Now plot geomag quantities
  IF KEYWORD_SET(no_superpose) THEN BEGIN
     geomagWindow=WINDOW(WINDOW_TITLE="SYM-H plots", $
                         DIMENSIONS=[1200,800])
        
  ENDIF ELSE BEGIN              ;Just do a regular superposition of all the plots
     
     xTitle='Hours since storm commencement'
     xRange=[-tBeforeStorm,tAfterStorm]
     ;; yRange=[geomag_min,geomag_max]
     yRange=[-300,100]
     ;; yRange=[-300,100]
     
     geomagWindow=WINDOW(WINDOW_TITLE="Superposed plots of " + stormStr + " storms: "+ $
                         stormStruct.tStamp(stormStruct_inds(0)) + " - " + $
                         stormStruct.tStamp(stormStruct_inds(-1)), $
                         DIMENSIONS=[1200,800])
     
     
     IF KEYWORD_SET(hour_offset_of_subset) THEN BEGIN
        stormRef=stormStruct.time(stormStruct_inds)+hour_offset_of_subset*3600.
     ENDIF ELSE BEGIN
        stormRef=stormStruct.time(stormStruct_inds)
     ENDELSE
     
     FOR i=0,nStorms-1 DO BEGIN
        
        IF N_ELEMENTS(geomag_time_list(i)) GT 1 THEN $
           
           geomagPlot=plot((geomag_time_list(i)-stormRef(i))/3600.,geomag_dat_list(i), $
                           XTITLE=xTitle+titleSuff, $
                           YTITLE=yTitle, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           AXIS_STYLE=1, $
                           MARGIN=(overlay_nEventHists) ? plotMargin : !NULL, $
                           XTICKFONT_SIZE=max_xtickfont_size, $
                           XTICKFONT_STYLE=max_xtickfont_style, $
                           YTICKFONT_SIZE=max_ytickfont_size, $
                           YTICKFONT_STYLE=max_ytickfont_style, $
                           /CURRENT,OVERPLOT=(i EQ 0) ? 0 : 1, $
                           SYM_TRANSPARENCY=defSymTransp, $
                           TRANSPARENCY=defLineTransp, $
                           THICK=2.5)
        
     ENDFOR
     
     axes=geomagPlot.axes
     axes[1].MAJOR=5
     axes[1].MINOR=3
     
     
  ENDELSE
  
                                ;And NOW let's plot quantity from the Alfven DB to see how it fares during storms
  IF KEYWORD_SET(maxInd) THEN BEGIN
     mTags=TAG_NAMES(maximus)
     
     
     IF ~overlay_nEventHists THEN maximusWindow=WINDOW(WINDOW_TITLE="Maximus plots", $
                                                       DIMENSIONS=[1200,800])
     
     ;; Get ranges for plots
     minMaxDat=MAKE_ARRAY(nStorms,2,/DOUBLE)
     
     IF neg_and_pos_separ OR (log_DBQuantity) THEN BEGIN
        pos_cdb_ind = WHERE(maximus.(maxInd) GT 0)
        neg_cdb_ind = WHERE(maximus.(maxInd) LT 0)
     ENDIF
        
     FOR i=0,nStorms-1 DO BEGIN
        tempInds=cgsetintersection(good_i,[cdb_storm_i(i,0):cdb_storm_i(i,1):1])
        minMaxDat(i,1)=MAX(maximus.(maxInd)(tempInds),MIN=tempMin)
        minMaxDat(i,0)=tempMin
     ENDFOR
     
     IF log_DBquantity OR neg_and_pos_separ THEN BEGIN
        
        neg_and_pos_separ = 1
        
                                ;Are there negs? Handle, if so
        IF neg_cdb_ind(0) NE -1 THEN BEGIN
           
           PRINT,"There are negs in this quantity, and you've asked me to log it. I'm setting neg_and_pos_separ."
           
           temp=WHERE(minMaxDat(*,1) LT 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN maxDat_neg=MAX(ABS(minMaxDat(temp,1)))
           temp=WHERE(minMaxDat(*,0) LT 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN minDat_neg=MIN(ABS(minMaxDat(temp,0)))
           
        ENDIF
        
        IF pos_cdb_ind(0) NE -1 THEN BEGIN
           
           temp=WHERE(minMaxDat(*,1) GT 0.,/NULL)
           IF N_ELEMENTS(temp) NE 0 THEN maxDat_pos=MAX(ABS(minMaxDat(temp,1)))
           temp=WHERE(minMaxDat(*,0) GT 0.,/NULL)
           IF N_ELEMENTS(temp) NE 0 THEN minDat_pos=MIN(ABS(minMaxDat(temp,0)))
           
        ENDIF
        
        IF pos_cdb_ind(0) NE -1 AND neg_cdb_ind(0) NE -1 THEN BEGIN
           
           IF N_ELEMENTS(maxDat_pos) EQ 0 THEN BEGIN
              IF N_ELEMENTS(maxDat_neg) EQ 0 THEN BEGIN
                 PRINT,"something's up; neither maxdat_pos nor maxdat_neg are defined..."
                 RETURN
              ENDIF
              maxDat_pos=maxDat_neg
           ENDIF
           IF N_ELEMENTS(maxDat_neg) EQ 0 THEN BEGIN
              maxDat_neg=maxDat_pos
           ENDIF
           
           IF N_ELEMENTS(minDat_pos) EQ 0 THEN BEGIN
              IF N_ELEMENTS(minDat_neg) EQ 0 THEN BEGIN
                 PRINT,"something's up; neither maxdat_pos nor maxdat_neg are defined..."
                 RETURN
              ENDIF
              minDat_pos=minDat_neg
           ENDIF
           IF N_ELEMENTS(minDat_neg) EQ 0 THEN BEGIN
              minDat_neg=minDat_pos
           ENDIF
           
           IF maxDat_pos GE maxDat_neg THEN maxDat_neg=maxDat_pos $
           ELSE maxDat_pos=maxDat_neg
           
           IF minDat_pos LE minDat_neg THEN minDat_neg=minDat_pos $
           ELSE minDat_pos=minDat_neg
        ENDIF
        
     ENDIF ELSE BEGIN
        maxDat=MAX(minMaxDat(*,1))
        minDat=MIN(minMaxDat(*,0))
     ENDELSE
     
     ;; now plot DB quantity
     xTitle='Hours since storm commencement'
     ;; yTitle='Maximus:
     
     xRange=[-tBeforeStorm,tAfterStorm]
     yRange=[geomag_min,geomag_max]
     FOR i=0,nStorms-1 DO BEGIN
           
        IF neg_and_pos_separ THEN BEGIN
           ;; get appropriate indices
           plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
           plot_i_pos=cgsetintersection(plot_i,pos_cdb_ind)
           plot_i_neg=cgsetintersection(plot_i,neg_cdb_ind)
           
           ;; get relevant time range
           cdb_t_pos=(DOUBLE(cdbTime(plot_i_pos))-DOUBLE(stormRef(i)))/3600.
           cdb_t_neg=(DOUBLE(cdbTime(plot_i_neg))-DOUBLE(stormRef(i)))/3600.
           
           ;; get corresponding data
           ;; cdb_y=maximus.(maxInd)(cdb_storm_i(i,0):cdb_storm_i(i,1))
           cdb_y_pos=maximus.(maxInd)(plot_i_pos)
           cdb_y_neg=ABS(maximus.(maxInd)(plot_i_neg))
           
           IF plot_i_pos(0) GT -1 AND N_ELEMENTS(plot_i_pos) GT 1 THEN BEGIN
                 
              IF ~overlay_nEventHists THEN BEGIN
                 plot_pos=plot(cdb_t_pos, $
                               cdb_y_pos, $
                               XTITLE='Hours since storm commencement'+titleSuff, $
                               YTITLE=mTags(maxInd), $
                               ;; YTITLE="Upward ion flux (N/$cm^3$)", $
                               XRANGE=xRange, $
                               YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                               yRange_maxInd : [minDat_pos,maxDat_pos], $
                               ;; YRANGE=[1e5,1e10], $
                               ;; YRANGE=[1e-5,1e0], $
                               YLOG=(log_DBQuantity) ? 1 : 0, $
                               LINESTYLE=' ', $
                               SYMBOL='+', $
                               SYM_COLOR='r', $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                               XTICKFONT_STYLE=max_xtickfont_style, $
                               YTICKFONT_SIZE=max_ytickfont_size, $
                               YTICKFONT_STYLE=max_ytickfont_style, $
                               /CURRENT, $
                               OVERPLOT=(i EQ 0) ? 0: 1, $
                               LAYOUT=pos_layout, $
                               SYM_TRANSPARENCY=defSymTransp)
                 
              ENDIF
              
              IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
                 
                 IF N_ELEMENTS(nEvHist_pos) EQ 0 THEN BEGIN
                    nEvHist_pos=histogram(cdb_t_pos,LOCATIONS=tBin, $
                                          MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                          BINSIZE=nEvBinsize)
                    nEvTot_pos=N_ELEMENTS(plot_i_pos)
                    tot_plot_i_pos_list=LIST(plot_i_pos)
                    tot_cdb_t_pos_list=LIST(cdb_t_pos)
                 ENDIF ELSE BEGIN
                    nEvHist_pos=histogram(cdb_t_pos,LOCATIONS=tBin, $
                                          MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                          BINSIZE=nEvBinsize, $
                                          INPUT=nEvHist_pos)
                    nEvTot_pos+=N_ELEMENTS(plot_i_pos)
                    tot_plot_i_pos_list.add,plot_i_pos
                    tot_cdb_t_pos_list.add,cdb_t_pos
                 ENDELSE
              ENDIF             ;end nEventHists
           ENDIF
           
           IF plot_i_neg(0) GT -1 AND (N_ELEMENTS(plot_i_neg) GT 1) THEN BEGIN
              
              IF ~overlay_nEventHists THEN BEGIN
                 plot_neg=plot(cdb_t_neg, $
                               cdb_y_neg, $
                               XTITLE='Hours since storm commencement'+titleSuff, $
                               YTITLE=mTags(maxInd), $
                               XRANGE=xRange, $
                               YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                               yRange_maxInd : [minDat_neg,maxDat_neg], $
                               ;; YRANGE=[minDat_neg,maxDat_neg], $
                               YLOG=(log_DBQuantity) ? 1 : 0, $
                               LINESTYLE=' ', $
                               SYMBOL='+', $
                               SYM_COLOR='SEA GREEN', $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                                  XTICKFONT_STYLE=max_xtickfont_style, $
                               /CURRENT, $
                               OVERPLOT=1, $
                               LAYOUT=neg_layout, $
                               SYM_TRANSPARENCY=defSymTransp)
              ENDIF
              
              IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
                 
                 IF N_ELEMENTS(nEvHist_neg) EQ 0 THEN BEGIN
                    nEvHist_neg=histogram(cdb_t_neg,LOCATIONS=tBin, $
                                          MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                             BINSIZE=nEvBinsize)
                    nEvTot_neg=N_ELEMENTS(plot_i_neg)
                    tot_plot_i_neg_list=LIST(plot_i_neg)
                    tot_cdb_t_neg_list=LIST(cdb_t_neg)
                 ENDIF ELSE BEGIN
                    nEvHist_neg=histogram(cdb_t_neg,LOCATIONS=tBin, $
                                          MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                          BINSIZE=nEvBinsize, $
                                          INPUT=nEvHist_neg)
                    nEvTot_neg+=N_ELEMENTS(plot_i_neg)
                    tot_plot_i_neg_list.add,plot_i_neg
                    tot_cdb_t_neg_list.add,cdb_t_neg
                 ENDELSE
              ENDIF             ;end nEventHists
           ENDIF
           
        ENDIF ELSE BEGIN
           ;; get appropriate indices
           plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
           
           ;; get relevant time range
           cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(stormRef(i)))/3600.
           
           ;; get corresponding data
           cdb_y=maximus.(maxInd)(plot_i)
           
           IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN
              
              IF ~overlay_nEventHists THEN BEGIN
                 plot=plot(cdb_t, $
                           (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                           XTITLE='Hours since storm commencement'+titleSuff, $
                           ;; YTITLE="Upward ion flux (N/$cm^3$)", $
                           YTITLE=mTags(maxInd), $
                           XRANGE=xRange, $
                           YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                           yRange_maxInd : [minDat,maxDat], $
                           ;; YRANGE=[minDat,maxDat], $
                           YLOG=(log_DBQuantity) ? 1 : 0, $
                           LINESTYLE=' ', $
                           SYMBOL='+', $
                           XTICKFONT_SIZE=max_xtickfont_size, $
                           XTICKFONT_STYLE=max_xtickfont_style, $
                           /CURRENT,OVERPLOT=(i EQ 0) ? 0: 1, $
                           SYM_TRANSPARENCY=defSymTransp)
              ENDIF
              
              IF KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) THEN BEGIN ;Histos of Alfvén events relative to storm epoch
                 
                 IF i EQ 0 THEN BEGIN
                    nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                      MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                      BINSIZE=nEvBinsize)
                    nEvTot=N_ELEMENTS(plot_i)
                    tot_plot_i_list=LIST(plot_i)
                    tot_cdb_t_list=LIST(cdb_t)
                 ENDIF ELSE BEGIN
                    nEvHist=histogram(cdb_t,LOCATIONS=tBin, $
                                      MAX=tAfterStorm+nEvBinsize,MIN=-tBeforeStorm, $
                                      BINSIZE=nEvBinsize, $
                                      INPUT=nEvHist)
                    nEvTot+=N_ELEMENTS(plot_i)
                    tot_plot_i_list.add,plot_i
                    tot_cdb_t_list.add,cdb_t
                 ENDELSE
              ENDIF             ;end nEventHists
           ENDIF
           
        ENDELSE                 ;end ~neg_and_pos_separ
     ENDFOR
     
     ;; Add the legend, if neg_and_pos_separ
     IF neg_and_pos_separ THEN BEGIN
        IF N_ELEMENTS(plot_pos) GT 0 AND N_ELEMENTS(plot_neg) GT 0 THEN BEGIN
           leg = LEGEND(TARGET=[plot_pos,plot_neg], $
                        POSITION=[0.1,0.1], /NORMAL, $
                        /AUTO_TEXT_COLOR)
        ENDIF
     ENDIF
     
     IF avg_type_maxInd GT 0  THEN BEGIN
        
        nBins=N_ELEMENTS(tBin)
        IF neg_and_pos_separ THEN BEGIN
           
           ;;combine all plot_i        
           IF N_ELEMENTS(plot_pos) GT 0 THEN BEGIN
              tot_plot_i_pos=tot_plot_i_pos_list(0)
              tot_cdb_t_pos=tot_cdb_t_pos_list(0)
              FOR i=1,N_ELEMENTS(tot_plot_i_pos_list)-1 DO BEGIN
                 tot_plot_i_pos=[tot_plot_i_pos,tot_plot_i_pos_list(i)]
                 tot_cdb_t_pos=[tot_cdb_t_pos,tot_cdb_t_pos_list(i)]
              ENDFOR
              
              Avgs_pos=MAKE_ARRAY(nBins,/DOUBLE)
              avg_data_pos=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_pos))) : ABS(maximus.(maxInd)(tot_plot_i_pos))
              
              ;;now loop over histogram bins, perform average
              FOR i=0,nBins-1 DO BEGIN
                 temp_inds=WHERE(tot_cdb_t_pos GE (tBin(0) + i*NEvBinsize) AND tot_cdb_t_pos LT (tBin(0)+(i+1)*nEvBinSize))
                 Avgs_pos[i] = TOTAL(avg_data_pos(temp_inds))/DOUBLE(nEvHist_pos[i])
              ENDFOR
              
              safe_i=WHERE(FINITE(Avgs_pos) AND Avgs_pos NE 0.)
              IF ~overlay_nEventHists THEN $
                 plot_pos=plot(tBin(safe_i)+0.5*nEvBinsize, $
                               (log_DBQuantity) ? 10^Avgs_pos(safe_i) : Avgs_pos(safe_i), $
                               XTITLE='Hours since storm commencement'+titleSuff, $
                               YTITLE=mTags(maxInd), $
                               ;; YTITLE="Upward ion flux (N/$cm^3$)", $
                               XRANGE=xRange, $
                               ;; YRANGE=[1e5,1e10], $
                               YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                               yRange_maxInd : [minDat_pos,maxDat_pos], $
                               ;; YRANGE=[1e-5,1e0], $
                               ;; YRANGE=[minDat_pos,maxDat_pos], $
                               LINESTYLE='--', $
                               COLOR='MAROON', $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                               XTICKFONT_STYLE=max_xtickfont_style, $
                               YTICKFONT_SIZE=max_ytickfont_size, $
                               YTICKFONT_STYLE=max_ytickfont_style, $
                               LAYOUT=pos_layout, $
                               SYMBOL='d', $
                               SYM_COLOR='MAROON', $
                               SYM_SIZE=avg_symSize, $
                               SYM_THICK=avg_symThick, $
                               THICK=avg_thick, $
                               /CURRENT,/OVERPLOT) ;, $
              
                 
           ENDIF
           
           IF N_ELEMENTS(plot_neg) GT 0 THEN BEGIN
              tot_plot_i_neg=tot_plot_i_neg_list(0)
              tot_cdb_t_neg=tot_cdb_t_neg_list(0)
              FOR i=1,N_ELEMENTS(tot_plot_i_neg_list)-1 DO BEGIN
                 tot_plot_i_neg=[tot_plot_i_neg,tot_plot_i_neg_list(i)]
                 tot_cdb_t_neg=[tot_cdb_t_neg,tot_cdb_t_neg_list(i)]
              ENDFOR
              
              Avgs_neg=MAKE_ARRAY(nBins,/DOUBLE)
              avg_data_neg=log_DBQuantity ? ALOG10(ABS(maximus.(maxInd)(tot_plot_i_neg))) : ABS(maximus.(maxInd)(tot_plot_i_neg))
              
              ;;now loop over histogram bins, perform average
              FOR i=0,nBins-1 DO BEGIN
                 temp_inds=WHERE(tot_cdb_t_neg GE (tBin(0) + i*NEvBinsize) AND tot_cdb_t_neg LT (tBin(0)+(i+1)*nEvBinSize))
                 Avgs_neg[i] = TOTAL(avg_data_neg(temp_inds))/DOUBLE(nEvHist_neg[i])
              ENDFOR
              
              safe_i=WHERE(FINITE(Avgs_neg) AND Avgs_neg NE 0.)
              IF ~overlay_nEventHists THEN $
                 plot_neg=plot(tBin(safe_i)+0.5*nEvBinsize, $
                               (log_DBQuantity) ? 10^Avgs_neg(safe_i) : Avgs_neg(safe_i), $
                               XTITLE='Hours since storm commencement'+titleSuff, $
                               YTITLE=mTags(maxInd), $
                               XRANGE=xRange, $
                               ;; YRANGE=[minDat_neg,maxDat_neg], $
                               YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                               yRange_maxInd : [minDat_neg,maxDat_neg], $
                               LINESTYLE='-:', $
                               COLOR='DARK GREEN', $
                               XTICKFONT_SIZE=max_xtickfont_size, $
                               XTICKFONT_STYLE=max_xtickfont_style, $
                               YTICKFONT_SIZE=max_ytickfont_size, $
                               YTICKFONT_STYLE=max_ytickfont_style, $
                               SYMBOL='d', $
                               SYM_COLOR='DARK GREEN', $
                               SYM_SIZE=avg_symSize, $
                               SYM_THICK=avg_symThick, $
                               THICK=avg_thick, $
                               LAYOUT=neg_layout, $
                               /CURRENT,/OVERPLOT) ;, $
              
           ENDIF
           
        ENDIF ELSE BEGIN
           
                                ;combine all plot_i
           tot_plot_i=tot_plot_i_list(0)
           tot_cdb_t=tot_cdb_t_list(0)
           FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO BEGIN
              tot_plot_i=[tot_plot_i,tot_plot_i_list(i)]
              tot_cdb_t=[tot_cdb_t,tot_cdb_t_list(i)]
           ENDFOR
           
           Avgs=MAKE_ARRAY(nBins,/DOUBLE)
           avg_data=maximus.(maxInd)(tot_plot_i)
                                ;now loop over histogram bins, perform average
           FOR i=0,nBins-1 DO BEGIN
              temp_inds=WHERE(tot_cdb_t GE (tBin(0) + i*NEvBinsize) AND tot_cdb_t LT (tBin(0)+(i+1)*nEvBinSize))
              Avgs[i] = TOTAL(avg_data(temp_inds))/DOUBLE(nEvHist[i])
           ENDFOR
           
           safe_i=(log_DBQuantity) ? WHERE(FINITE(Avgs) AND Avgs GT 0.) : WHERE(FINITE(Avgs))
           IF ~overlay_nEventHists THEN $
              plot=plot(tBin(safe_i)+0.5*nEvBinsize, $
                        Avgs(safe_i), $
                        XTITLE='Hours since storm commencement'+titleSuff, $
                        ;; YTITLE="Upward ion flux (N/$cm^3$)", $
                        YTITLE=mTags(maxInd), $
                        XRANGE=xRange, $
                        YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                        yRange_maxInd : [minDat,maxDat], $
                        LINESTYLE='--', $
                        SYMBOL='d', $
                        XTICKFONT_SIZE=max_xtickfont_size, $
                        XTICKFONT_STYLE=max_xtickfont_style, $
                        YTICKFONT_SIZE=max_ytickfont_size, $
                        YTICKFONT_STYLE=max_ytickfont_style, $
                        /CURRENT,/OVERPLOT, $
                        SYM_SIZE=1.5, $
                        SYM_COLOR='g') ;, $
           
        ENDELSE
        
     ENDIF
     
     IF KEYWORD_SET(nEventHists) THEN BEGIN
        IF neg_and_pos_separ THEN BEGIN
           
           IF pos_cdb_ind(0) NE -1 THEN BEGIN
              histWindow_pos=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                    DIMENSIONS=[1200,800])
              
              plot_nEv_pos=plot(tBin,nEvHist_pos, $
                                /STAIRSTEP, $
                                TITLE='Number of Alfvén events relative to storm epoch for ' + stormStr + ' storms, ' + $
                                stormStruct.tStamp(stormStruct_inds(0)) + " - " + $
                                stormStruct.tStamp(stormStruct_inds(-1)), $
                                XTITLE='Hours since storm commencement'+titleSuff, $
                                YTITLE='Number of Alfvén events', $
                                /CURRENT, LAYOUT=pos_layout,COLOR='red')
              
              cNEvHist_pos= TOTAL(nEvHist_pos, /CUMULATIVE) / nEvTot_pos
              cdf_nEv_pos=plot(tBin,cNEvHist_pos, $
                               XTITLE='Hours since storm commencement'+titleSuff, $
                               YTITLE='Cumulative number of Alfvén events', $
                               /CURRENT, LAYOUT=pos_layout, AXIS_STYLE=1,COLOR='r')
              
              
           ENDIF
           
           IF neg_cdb_ind(0) NE -1 THEN BEGIN
              histWindow_neg=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                    DIMENSIONS=[1200,800])
              
              plot_nEv_neg=plot(tBin,nEvHist_neg, $
                                /STAIRSTEP, $
                                TITLE='Number of Alfvén events relative to storm epoch for ' + stormStr + ' storms, ' + $
                                stormStruct.tStamp(stormStruct_inds(0)) + " - " + $
                                stormStruct.tStamp(stormStruct_inds(-1)), $
                                XTITLE='Hours since storm commencement'+titleSuff, $
                                YTITLE='Number of Alfvén events', $
                                /CURRENT,/OVERPLOT, LAYOUT=neg_layout,COLOR='b')
              
              cNEvHist_neg= TOTAL(nEvHist_neg, /CUMULATIVE) / nEvTot_neg
              cdf_nEv_neg=plot(tBin,cNEvHist_neg, $
                               XTITLE='Hours since storm commencement'+titleSuff, $
                               YTITLE='Cumulative number of Alfvén events', $
                               /CURRENT, LAYOUT=neg_layout,/OVERPLOT, AXIS_STYLE=1,COLOR='b')
              
              ;; IF saveFile THEN saveStr+=',cNEvHist,cdf_nEv,plot_nEv,nEvHist,tBin,nEvBinsize'
           ENDIF
           
           IF saveFile THEN saveStr+=',cNEvHist_pos,nEvHist_pos,cNEvHist_neg,nEvHist_neg,tBin,nEvBinsize,tot_plot_i_pos_list,tot_plot_i_neg_list,maxInd'
           
        ENDIF ELSE BEGIN
           
           ;; Has user requested overlaying DST/SYM-H with the histogram?
           IF overlay_nEventHists THEN BEGIN
              ;; geomagWindow.setCurrent
              
              plot_nEv=plot(tBin,nEvHist, $
                            /STAIRSTEP, $
                            YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : [0,7000], $
                            NAME='Stormtime histogram', $
                            XRANGE=xRange, $
                            AXIS_STYLE=0, $
                            COLOR='red', $
                            MARGIN=plotMargin, $
                            THICK=6.5, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                            /CURRENT)
              
              yaxis = AXIS('Y', LOCATION='right', TARGET=plot_nEv, $
                           TITLE='Number of Alfvén events'+titleSuff, $
                           MAJOR=8, $
                           MINOR=3, $
                           TICKFONT_SIZE=max_ytickfont_size, $
                           TICKFONT_STYLE=max_ytickfont_style, $
                           ;; AXIS_RANGE=[minDat,maxDat], $
                           TEXTPOS=1, $
                           COLOR='red')
              
              
              IF KEYWORD_SET(bkgrnd_hist) THEN BEGIN
                 plot_bkgrnd=plot(tBin,bkgrnd_hist, $
                                  /STAIRSTEP, $
                                  YRANGE=KEYWORD_SET(nEvRange) ? nEvRange : [0,7500], $
                                  NAME='Background histogram (average)', $
                                  XRANGE=xRange, $
                                  AXIS_STYLE=0, $
                                  COLOR='blue', $
                                  MARGIN=plotMargin, $
                                  THICK=6.5, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                                  /CURRENT,TRANSPARENCY=50)

                 leg = LEGEND(TARGET=[plot_nEv,plot_bkgrnd], $
                              POSITION=[0.1,0.1], /NORMAL, $
                              /AUTO_TEXT_COLOR)
              ENDIF
                 

           ENDIF ELSE BEGIN
              histWindow=WINDOW(WINDOW_TITLE="Histogram of number of Alfven events", $
                                DIMENSIONS=[1200,800])
              plot_nEv=plot(tBin,nEvHist, $
                            /STAIRSTEP, $
                            TITLE='Number of Alfvén events relative to storm epoch for ' + stormStr + ' storms, ' + $
                            stormStruct.tStamp(stormStruct_inds(0)) + " - " + $
                            stormStruct.tStamp(stormStruct_inds(-1)), $
                            XTITLE='Hours since storm commencement'+titleSuff, $
                            YTITLE='Number of Alfvén events', $
                            /CURRENT, LAYOUT=[2,1,1],COLOR='red')
              
              cNEvHist = TOTAL(nEvHist, /CUMULATIVE) / nEvTot
              cdf_nEv=plot(tBin,cNEvHist, $
                           XTITLE='Hours since storm commencement'+titleSuff, $
                           YTITLE='Cumulative number of Alfvén events', $
                           /CURRENT, LAYOUT=[2,1,2], AXIS_STYLE=1,COLOR='blue')
           ENDELSE
           
           
           ;; IF saveFile THEN saveStr+=',cNEvHist,cdf_nEv,plot_nEv,nEvHist,tBin,nEvBinsize'
           IF saveFile THEN saveStr+=',cNEvHist,nEvHist,tBin,nEvBinsize,tot_plot_i_list,maxInd'
        ENDELSE
        returned_nev_tbins_and_Hist=[[tbin],[nEvHist]]
     ENDIF                      ;end IF nEventHists
     
  ENDIF
  
  IF saveFile THEN BEGIN
     saveStr+=',filename='+'"'+saveFile+'"'
     PRINT,"Saving output to " + saveFile
     PRINT,"SaveStr: ",saveStr
     biz = EXECUTE(saveStr)
  ENDIF
  
END