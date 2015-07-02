;+
; NAME:                 SW_DATA_PLOTTER_AND_DARTDB_IND_GETTER
;
;
;
; PURPOSE:              Fill the eminent need for the ability to quickly glance at various solar wind stuff
;
;
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE:
;
;
;
; INPUTS:               START_T              : Start time (either as a string or in seconds since 1970-1-1 0:00.000
;                       STOP_T               : Stop time (either as a string or in seconds since 1970-1-1 0:00.000
;                       PROD                 : Either "AE", "DST", "SYM-H", or... I don't know what.
;                       CENTER_T             : Time at which to plot data; set boundaries using AFTER_T and BEFORE_T
;                       AFTER_T              : Upper bound of CENTER_T plot, in hours
;                       BEFORE_T             : Lower bound of CENTER_T plot, in hours
;                 
;
; OPTIONAL INPUTS:
;                       RESTRICT_CHARERANGE  : Restrict returned Dartmouth DB inds to those within restricted characteristic energy
;range
;                       RESTRICT_ALTRANGE    : Restrict returned Dartmouth DB inds to those within restricted altitude range
;                       OUTFILE              : Output a gif with this filename
;
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;                       DARTDB_INDS_LIST: Return the relevant indices from the Dartmouth Alfven wave database
;                       OMNI_INDS_LIST  : Return the relevant indices from the OMNI database
;
; OPTIONAL OUTPUTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:

;
; MODIFICATION HISTORY:        2015/07/01 Born
;
;-
PRO SW_DATA_PLOTTER_AND_DARTDB_IND_GETTER, $
   PROD=prod, $
   CENTER_T=center_t,AFTER_T=after_t,BEFORE_T=before_t, $
   START_T=start_t,STOP_T=stop_t, $
   OMNI_INDS_LIST=omni_inds_list, $
   DARTDB_INDS_LIST=dartDB_inds_list, DAYSIDE=dayside,NIGHTSIDE=nightside,RESTRICT_CHARERANGE=restrict_charerange,RESTRICT_ALTRANGE=restrict_altRange, $
   OUTFILE=outFile


  dataDir='/SPENCEdata/Research/Cusp/database/'
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Defaults

  defProd              = "SYM-H"

  defafter_t           = 22.0D  ;in hours
  defbefore_t          = 16.0D  ;in hours
  
  defswDBDir           = 'sw_omnidata/'
  defswDBFile          = 'sw_data.dat'
  
  defStormDir          = 'sw_omnidata/'
  defStormFile         = 'large_and_small_storms--1985-2011--Anderson.sav'
  
  defDST_AEDir         = 'processed/'
  defDST_AEFile        = 'idl_ae_dst_data.dat'
  
  defDBDir             = 'dartdb/saves/'
  defDBFile            = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus--wpFlux.sav'  
  defDB_tFile          = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
  
  defSymTransp         = 0
  defLineTransp        = 0
  defLineThick         = 1.5
  
  plotMargin=[0.13, 0.20, 0.13, 0.15]
  
  defSaveFile          = 0
  defOutFile           = 'sw_data_plotter.gif'

  defTitleSuff         = ''
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Check defaults
  IF N_ELEMENTS(prod) EQ 0 Then prod=defProd

  IF N_ELEMENTS(before_t) EQ 0 THEN before_t = defBefore_T
  IF N_ELEMENTS(after_t) EQ 0 THEN after_t = defAfter_T
  
  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile
  
  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir
  IF N_ELEMENTS(stormFile) EQ 0 THEN stormFile=defStormFile
  
  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile
  
  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile
  
  IF N_ELEMENTS(saveFile) EQ 0 THEN saveFile=defSaveFile
  
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
  
  ;;Any output?
  IF KEYWORD_SET(outFile) THEN BEGIN
     outFType = SIZE(outFile, /TYPE)
     IF outFType NE 7 THEN outFile=defOutFile

     PRINT,'Outputting plot to ' + outFile + '...'
  ENDIF

  ;;want corresponding inds for Alfven database
  restore,dataDir+defDBDir+DBFile
  restore,dataDir+defDBDir+DB_tFile
  
  ;what are we plotting?
  IF STRLOWCASE(prod) EQ STRLOWCASE("AE") THEN use_AE = 1 ELSE use_AE = 0
  IF STRLOWCASE(prod) EQ STRLOWCASE("DST") THEN use_DST = 1 ELSE use_DST = 0
  IF STRLOWCASE(prod) EQ STRLOWCASE("SYM-H") THEN use_SYMH = 1 ELSE use_SYMH = 0

  IF use_DST THEN restore,dataDir+DST_AEDir+DST_AEFile

  ;;Figure out time boundaries
  IF KEYWORD_SET(START_T) THEN BEGIN
     nStorms=N_ELEMENTS(start_t)

     IF nStorms NE N_ELEMENTS(stop_t) THEN BEGIN
        PRINT,"Number of start times doesn't equal number of stop times! Exiting..."
        RETURN
     ENDIF

     IF N_ELEMENTS(STOP_T) EQ 0 THEN BEGIN
        PRINT,"No stop year specified! Plotting data up to a full year after start_t."
        stop_t=start_t+86400.*31.*12.
     ENDIF

     startType = SIZE(start_t, /TYPE)
     IF startType EQ 7 THEN strt_t = STR_TO_TIME(start_t) ELSE strt_t = start_t
     IF strt_t EQ -1 THEN BEGIN
        PRINT,"Incorrectly formatted start_t string: " + start_t
        PRINT,"Exiting..."
        RETURN
     ENDIF

     stopType = SIZE(stop_t, /TYPE)
     IF stopType EQ 7 THEN stp_t = STR_TO_TIME(stop_t) ELSE stp_t = stop_t
     IF stopType EQ -1 THEN BEGIN
        PRINT,"Incorrectly formatted stop_t string: " + stop_t
        PRINT,"Exiting..."
        RETURN
     ENDIF

     FOR i=0,nStorms-1 DO BEGIN
        IF stp_t(i) LT strt_t(i) THEN BEGIN
           PRINT,"Stop time is less than start time!!"
           PRINT,"Start time: " +TIME_TO_STR(strt_t(i))
           PRINT,"Stop time: " + TIME_TO_STR(stp_t(i))
           PRINT,"Returning..."
           RETURN
        ENDIF
     ENDFOR

     cnt_t = (strt_t+stp_t) / 2.
     bef_t = cnt_t - strt_t 
     aft_t = stp_t - cnt_t

  ENDIF ELSE BEGIN
     IF KEYWORD_SET(CENTER_T) THEN BEGIN
        nStorms=N_ELEMENTS(center_t)

        centType = SIZE(center_t, /TYPE)
        IF centType EQ 7 THEN cnt_t = STR_TO_TIME(center_t) ELSE cnt_t = center_t
        IF centType EQ -1 THEN BEGIN
           PRINT,"Incorrectly formatted center_t string: " + center_t
           PRINT,"Exiting..."
           RETURN
        ENDIF

        befType = SIZE(before_t, /TYPE)
        IF befType EQ 7 THEN bef_t = STR_TO_TIME(before_t) ELSE bef_t = before_t
        IF bef_t EQ -1 THEN BEGIN
           PRINT,"Incorrectly formatted before_t string: " + before_t
           PRINT,"Exiting..."
           RETURN
        ENDIF

        aftType = SIZE(after_t, /TYPE)
        IF aftType EQ 7 THEN aft_t = STR_TO_TIME(after_t) ELSE aft_t = after_t
        IF aft_t EQ -1 THEN BEGIN
           PRINT,"Incorrectly formatted after_t string: " + after_t
           PRINT,"Exiting..."
           RETURN
        ENDIF

     ENDIF ELSE BEGIN
        PRINT,"No start date provided! Please specify one in UTC time, seconds since Jan 1, 1970."
        RETURN
     ENDELSE
  ENDELSE

  ;;Handle quantities in question
  IF use_DST THEN BEGIN         ;Use DST for plots, not SYM-H
     ;; Now get a list of indices for DST data to be plotted for the storms found above
     geomag_plot_i_list = LIST(WHERE(DST.time GE (cnt_t(0)-bef_t(0)*3600.) AND $ ;first initialize the list
                                     DST.time LE (cnt_t(0)+aft_t(0)*3600.)))
     geomag_dat_list = LIST(dst.dst(geomag_plot_i_list(0)))
     geomag_time_list = LIST(dst.time(geomag_plot_i_list(0)))
     
     geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
     geomag_max = MAX(geomag_dat_list(0))
     
     FOR i=1,nStorms-1 DO BEGIN ;Then update it
        geomag_plot_i_list.add,WHERE(DST.time GE (cnt_t(i)-bef_t(i)*3600.) AND $
                                     DST.time LE (cnt_t(i)+aft_t(i)*3600.))
        geomag_dat_list.add,dst.dst(geomag_plot_i_list(i))
        geomag_time_list.add,dst.time(geomag_plot_i_list(i))
        
        tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
        IF tempMin LT geomag_min THEN geomag_min=tempMin
        IF tempMax GT geomag_max THEN geomag_max=tempMax
     ENDFOR
  ENDIF ELSE BEGIN                                                 ;Use SYM-H for plots 
     swDat_UTC=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D    ;For conversion between SW DB and ours
     
     ;; Now get a list of indices for SYM-H data to be plotted for the storms found above
     geomag_plot_i_list = LIST(WHERE(swDat_UTC GE (cnt_t(0)-bef_t(0)*3600.) AND $ ;first initialize the list
                                     swDat_UTC LE (cnt_t(0)+aft_t(0)*3600.)))
     geomag_time_list = LIST(swDat_UTC(geomag_plot_i_list(0)))
     
     IF use_SYMH THEN BEGIN
        geomag_dat_list = LIST(sw_data.sym_h.dat(geomag_plot_i_list(0)))
        
        geomag_min = MIN(geomag_dat_list(0)) ;For plots, we need the range
        geomag_max = MAX(geomag_dat_list(0))
        
        FOR i=1,nStorms-1 DO BEGIN ;Then update it
           geomag_plot_i_list.add,WHERE(swDat_UTC GE (cnt_t(i)-bef_t(i)*3600.) AND $
                                        swDat_UTC LE (cnt_t(i)+aft_t(i)*3600.))
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
              geomag_plot_i_list.add,WHERE(swDat_UTC GE (cnt_t(i)-bef_t(i)*3600.) AND $
                                           swDat_UTC LE (cnt_t(i)+aft_t(i)*3600.))
              geomag_dat_list.add,sw_data.ae_index.dat(geomag_plot_i_list(i))
              geomag_time_list.add,swDat_UTC(geomag_plot_i_list(i))
              
              tempMin = MIN(geomag_dat_list(i),MAX=tempMax)
              IF tempMin LT geomag_min THEN geomag_min=tempMin
              IF tempMax GT geomag_max THEN geomag_max=tempMax
           ENDFOR
           
        ENDIF
     ENDELSE
  ENDELSE
  
  ;;Get nearest events in Chaston DB
  dartDB_t=MAKE_ARRAY(nStorms,2,/DOUBLE)
  dartdb_startstop_inds=MAKE_ARRAY(nStorms,2,/L64)
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS, $
                         ALTITUDERANGE=KEYWORD_SET(restrict_altRange) ? [1000,5000] : !NULL, $
                         CHARERANGE=KEYWORD_SET(restrict_charERange) ? [4,300] : !NULL, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside)
  
  FOR i=0,nStorms-1 DO BEGIN
        tempMinBeforeClosest=MIN(ABS((cnt_t(i)-bef_t(i)*3600.)-cdbTime(good_i)),tempClosestBefore_ii)
        tempMinAfterClosest=MIN(ABS((cnt_t(i)+aft_t(i)*3600.)-cdbTime(good_i)),tempClosestAfter_ii)
        dartdb_startstop_inds(i,0)=good_i(tempClosestBefore_ii)
        dartDB_t(i,0)=cdbTime(good_i(tempClosestBefore_ii))
        dartdb_startstop_inds(i,1)=good_i(tempClosestAfter_ii)
        dartDB_t(i,1)=cdbTime(good_i(tempClosestAfter_ii))
  ENDFOR

  ;; dartDB_inds_list=LIST(WHERE(good_i GE good_i[dartdb_startstop_inds(0,0)] AND good_i LE good_i[dartdb_startstop_inds(0,1)]))
  dartDB_inds_list=LIST(good_i(WHERE(good_i GE dartdb_startstop_inds(0,0) AND good_i LE dartdb_startstop_inds(0,1))))
  FOR i=0,nStorms-1 DO BEGIN
     ;; dartDB_inds_list.add,LIST(WHERE(good_i GE good_i[dartdb_startstop_inds(i,0)] AND good_i LE good_i[dartdb_startstop_inds(i,1)]))
     dartDB_inds_list.add,LIST(good_i(WHERE(good_i GE dartdb_startstop_inds(i,0) AND good_i LE dartdb_startstop_inds(i,1))))
  ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot deres egen ting
  FOR i=0,nStorms-1 DO BEGIN
     ;; geomagPlot=plot((geomag_time_list(i)-stormRef(i))/3600.,geomag_dat_list(i), $
     geomagPlot=plot((geomag_time_list(i)-cnt_t(i))/3600.,geomag_dat_list(i), $
                     XTITLE='Hours since '+TIME_TO_STR(cnt_t[i]), $
                     YTITLE=yTitle, $
                     XRANGE=xRange, $
                     YRANGE=yRange, $
                     AXIS_STYLE=1, $
                     MARGIN=(KEYWORD_SET(overlay_nEventHists)) ? plotMargin : !NULL, $
                     XTICKFONT_SIZE=max_xtickfont_size, $
                     XTICKFONT_STYLE=max_xtickfont_style, $
                     YTICKFONT_SIZE=max_ytickfont_size, $
                     YTICKFONT_STYLE=max_ytickfont_style, $
                     /CURRENT,OVERPLOT=(N_ELEMENTS(i) EQ 0) ? 0 : 1, $
                     SYM_TRANSPARENCY=defSymTransp, $
                     TRANSPARENCY=defLineTransp, $
                     THICK=defLineThick)
  ENDFOR
  
  IF KEYWORD_SET(outFile) THEN geomagPlot.save,outFile,HEIGHT=1200

  omni_inds_list=geomag_plot_i_list

END

