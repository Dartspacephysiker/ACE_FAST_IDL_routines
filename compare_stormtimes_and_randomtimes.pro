;+
; NAME:                           COMPARE_STORMTIMES_AND_RANDOMTIMES
;
; PURPOSE:                        TAKE A LIST OF RANDOMTIMES, SUPERPOSE THE RANDOMTIMES, COMPARE WITH KNOWN STORM TIMES
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
;                              KSARRAY           : Array of K-S statistics produced by this Monte Carlo bidness
;                              PVALARRAY         : Array of p-values associated with each K-S statistic
;                              NO_PLOTS          : Don't show histo plots of K-S stats and p-values
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


PRO COMPARE_STORMTIMES_AND_RANDOMTIMES,N_ITERATIONS=n_iterations, NRANDTIME=nRandTime,STARTDATE=startDate, STOPDATE=stopDate,STORMTYPE=stormType, $
                                       TBEFORERANDTIME=tBeforeRandTime,TAFTERRANDTIME=tAfterRandTime, $
                                       MAXIND=maxInd,LOG_DBQUANTITY=log_DBquantity, $
                                       DBFILE=dbFile,DB_TFILE=db_tFile, $
                                       USE_SYMH=use_symh, $
                                       NO_SUPERPOSE=no_superpose, $
                                       NEVENTHISTS=nEventHists,NEVBINSIZE=nEvBinSize, $
                                       USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
                                       KSARRAY=KSArray,PVALARRAY=pValArray, $
                                       ONE_OF_EACH=one_of_each, THRESH=thresh, $
                                       NO_PLOTS=no_plots, $
                                       SAVEFILE=saveFile


   ;; DO_KSSTATS=do_ksstats
  
  dataDir='/SPENCEdata/Research/Cusp/database/'
  ;; hoyDia= STRCOMPRESS(STRMID(SYSTIME(0), 4, 3),/REMOVE_ALL) + "_" + $
  ;;         STRCOMPRESS(STRMID(SYSTIME(0), 8,2),/REMOVE_ALL) + "_" + STRCOMPRESS(STRMID(SYSTIME(0), 22, 2),/REMOVE_ALL)
  date='20150615'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  defN_iterations  =  2000

  defTBeforeRandTime  = 22.0D                                                                       ;in hours
  defTAfterRandTime   = 16.0D                                                                       ;in hours
  defStormType     =  2

  defswDBDir       = 'sw_omnidata/'
  defswDBFile      = 'sw_data.dat'
                   
  defStormDir      = 'sw_omnidata/'
  defStormFile     = 'large_and_small_storms--1985-2011--Anderson.sav'

  defProcessedStormDir='processed/'
  defProcessedStormDB = ['superposed_small_storm_output_w_n_Alfven_events--'+date+'.dat', $
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

  defOne_of_each   = 0
  defThresh        = 1.5

  ;; defDo_KSStats    = 0
  defSaveFile      = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Check defaults

  ;; ;; Actually, let's handle these below when we re-load one of the storm files
  ;; IF N_ELEMENTS(tBeforeRandTime) EQ 0 THEN tBeforeRandTime = defTBeforeRandTime
  ;; IF N_ELEMENTS(tAfterRandTime) EQ 0 THEN tAfterRandTime = defTAfterRandTime

  IF N_ELEMENTS(n_iterations) EQ 0 THEN n_iterations=defN_iterations

  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile

  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir
  IF N_ELEMENTS(stormFile) EQ 0 THEN stormFile=defStormFile

  IF N_ELEMENTS(processedStormDB) EQ 0 THEN processedStormDB=defProcessedStormDB
  IF N_ELEMENTS(processedStormDir) EQ 0 THEN processedStormDir=defProcessedStormDir

  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile

  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile

  IF N_ELEMENTS(log_DBQuantity) EQ 0 THEN log_DBQuantity=defLogDBQuantity

  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH = defUse_SYMH

  IF N_ELEMENTS(nEvBinsize) EQ 0 THEN nEvBinsize=defnEvBinsize

  IF N_ELEMENTS(one_of_each) EQ 0 THEN one_of_each = defOne_of_each
  IF N_ELEMENTS(thresh) EQ 0 THEN thresh = defthresh

  ;; IF N_ELEMENTS(do_KSStats) EQ 0 THEN do_KSStats = defDo_KSStats

  IF N_ELEMENTS(saveFile) EQ 0 THEN saveFile=defSaveFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  restore,dataDir+swDBDir+swDBFile

  IF ~use_SYMH THEN restore,dataDir+DST_AEDir+DST_AEFile

  restore,dataDir+defDBDir+DBFile
  restore,dataDir+defDBDir+DB_tFile
  good_i=get_chaston_ind(maximus,"OMNI",-1,/NORTHANDSOUTH) ;need these later
  ;; mTags=TAG_NAMES(maximus)

  restore,dataDir+stormDir+stormFile

  ;; Check storm type to determine which file we restore
  IF N_ELEMENTS(stormType) EQ 0 THEN stormType=defStormType
  IF stormType EQ 1 THEN BEGIN  ;Only large storms
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
  ;; restore,dataDir+stormDir+processedStormDB[stormType]
  restore,dataDir+processedStormDir+processedStormDB[stormType]

  ;get a few variables from restored storm file
  nStormsFromFile=N_ELEMENTS(geomag_plot_i_list)
  tBeforeRandTime=tBeforeStorm
  tAfterRandTime=tAfterStorm
  stormTot_plot_i_list=tot_plot_i_list

  ;Now initialize the storm times
  IF one_of_each THEN BEGIN
     temp_i=FIX(RANDOMU(seed)*nStormsFromFile)
     storm_t=(DOUBLE(cdbTime(stormTot_plot_i_list(temp_i)))-DOUBLE(stormStruct.time(stormStruct_inds(temp_i))))/3600.
  ENDIF ELSE BEGIN
     storm_t=(DOUBLE(cdbTime(stormTot_plot_i_list(0)))-DOUBLE(stormStruct.time(stormStruct_inds(0))))/3600.
     FOR i=1,n_elements(stormTot_plot_i_list)-1 DO $
        storm_t=[storm_t, $
                 (DOUBLE(cdbTime(stormTot_plot_i_list(i)))-DOUBLE(stormStruct.time(stormStruct_inds(i))))/3600.]
  ENDELSE

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
  ENDIF

  IF saveFile THEN saveStr='save' ELSE saveStr=''
  IF SIZE(saveFile,/TYPE) NE 7 THEN saveFile='compare_stormtimes_and_randomtimes.dat'

  PRINT,"Looking at " + stormStr + " storms per user instruction..."
  PRINT,STRCOMPRESS(N_ELEMENTS(nStormsFromFile),/REMOVE_ALL)+" storms out of " + STRCOMPRESS(nStormsFromFile,/REMOVE_ALL) + " selected"
        
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Make a randomtimes struct which parallels that of the stormStruct used in the pro superpose_storms[...]
  
  ;;How many fake times to compare against?
  nToCompare=(one_of_each) ? 1 : nStormsFromFile

  ;Use these to keep track of the places we could or
  isBad = MAKE_ARRAY(n_iterations,/BOOLEAN,VALUE=0)                             ;number of bad
  nStorm_t=MAKE_ARRAY(n_iterations,/L64)
  nRand_t=MAKE_ARRAY(n_iterations,/L64)
  nStorm_vs_nRand=MAKE_ARRAY(n_iterations,/DOUBLE)
  FOR iter=0,n_iterations-1 DO BEGIN

     PRINT,'iter: ',iter

     tempTimes=RANDOMU(seed,nToCompare,/DOUBLE)*(stopDate-startDate)+startDate
     tempTimes=tempTimes(SORT(tempTimes))
     randTStruct={time:tempTimes, $
                  tStamp:time_to_str(tempTimes)}
     
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Get all randomtimes occuring within specified range
     
     IF KEYWORD_SET(STARTDATE) THEN BEGIN
        IF N_ELEMENTS(STOPDATE) EQ 0 THEN BEGIN
           PRINT,"No stop year specified! Plotting data up to a full year after startDate."
           stopDate=startDate+86400.*31.*12.
        ENDIF
        
        ;; randTStruct_inds=WHERE(randTStruct.time GE startDate AND randTStruct.time LE stopDate,/NULL)
        randTStruct_inds=INDGEN(nToCompare)

        nRandTime=N_ELEMENTS(randTStruct_inds)
        IF nRandTime EQ 0 THEN BEGIN
           PRINT,"No randTimes found for given time range:"
           PRINT,"Start date: ",time_to_str(startDate)
           PRINT,"Stop date: ",time_to_str(stopDate)
           PRINT,'Returning...'
           RETURN
        ENDIF
        
        ;; Generate a list of indices to be plotted from the selected geomagnetic index, either SYM-H or DST, and do dat
        datStartStop = MAKE_ARRAY(nToCompare,2,/DOUBLE)
        datStartStop(*,0) = randTStruct.time - tBeforeRandTime*3600. ;(*,0) are the times before which we don't want data for each storm
        datStartStop(*,1) = randTStruct.time + tAfterRandTime*3600.  ;(*,1) are the times after which we don't want data for each storm
        
     ENDIF ELSE BEGIN
        PRINT,"No start date provided! Please specify one in UTC time, seconds since Jan 1, 1970."
        RETURN
     ENDELSE
     
                                ;Get nearest events in Chaston DB
     cdb_randT_t=MAKE_ARRAY(nToCompare,2,/DOUBLE)
     cdb_randT_i=MAKE_ARRAY(nToCompare,2,/L64)
     FOR i=0,nToCompare-1 DO BEGIN
        FOR j=0,1 DO BEGIN
           tempClosest=MIN(ABS(datStartStop(randTStruct_inds(i),j)-cdbTime),tempClosest_i)
           cdb_randT_i(i,j)=tempClosest_i
           cdb_randT_t(i,j)=cdbTime(tempClosest_i)
        ENDFOR
     ENDFOR
     
        ;; Get ranges for plots
        maxMinutes=MAX((cdbTime(cdb_randT_i(*,1))-cdbTime(cdb_randT_i(*,0)))/3600.,longestRandT_i,MIN=minMinutes)
        
        IF one_of_each THEN BEGIN
           ;randomly select new storm
           temp_i=FIX(RANDOMU(seed)*nStormsFromFile)
           storm_t=(DOUBLE(cdbTime(stormTot_plot_i_list(temp_i)))-DOUBLE(stormStruct.time(stormStruct_inds(temp_i))))/3600.

           ;; get appropriate indices
           plot_i=cgsetintersection(good_i,indgen(cdb_randT_i(0,1)-cdb_randT_i(0,0)+1)+cdb_randT_i(0,0))
           
           ;; ;; get relevant time range
           ;; cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(randTStruct.time(randTStruct_inds(i))))/3600.
           
           rand_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(randTStruct.time(randTStruct_inds(0))))/3600.

        ENDIF ELSE BEGIN
           FOR i=0,nToCompare-1 DO BEGIN
              
              ;; get appropriate indices
              plot_i=cgsetintersection(good_i,indgen(cdb_randT_i(i,1)-cdb_randT_i(i,0)+1)+cdb_randT_i(i,0))
              
              ;; ;; get relevant time range
              ;; cdb_t=(DOUBLE(cdbTime(plot_i))-DOUBLE(randTStruct.time(randTStruct_inds(i))))/3600.
              
              IF plot_i(0) GT -1 AND N_ELEMENTS(plot_i) GT 1 THEN BEGIN
                 
                 IF i EQ 0 THEN BEGIN
                    
                    nEvTot=N_ELEMENTS(plot_i)
                    
                    randTot_plot_i_list=LIST(plot_i)
                    
                 ENDIF ELSE BEGIN
                    
                    nEvTot+=N_ELEMENTS(plot_i) 
                    
                    randTot_plot_i_list.add,plot_i ;Gather inds for K-S analysis
                    
                 ENDELSE
                 
                 
              ENDIF ELSE BEGIN
                 PRINT,'N_ELEMENTS(plot_i) = ' + STRCOMPRESS(N_ELEMENTS(plot_i),/REMOVE_ALL) + '!!'
                 PRINT,'plot_i             = ' + STRCOMPRESS(plot_i,/REMOVE_ALL) + '!!!'
              ENDELSE
              
           ENDFOR
           
           ;;Calculate K-S statistics
           rand_t=(DOUBLE(cdbTime(randTot_plot_i_list(0)))-DOUBLE(randTStruct.time(randTStruct_inds(0))))/3600.
           FOR i=1,n_elements(randTot_plot_i_list)-1 DO $
              rand_t=[rand_t, $
                      (DOUBLE(cdbTime(randTot_plot_i_list(i)))-DOUBLE(randTStruct.time(randTStruct_inds(i))))/3600.]
        ENDELSE

        nStorm_t(iter) = N_ELEMENTS(storm_t)
        nRand_t(iter) = N_ELEMENTS(rand_t)
        nStorm_vs_nRand(iter) = ABS(ALOG10(FLOAT(nStorm_t(iter))/FLOAT(nRand_t(iter))))
        ;; IF N_ELEMENTS(nStorm_t_arr) EQ 0 THEN BEGIN
        ;;    nStorm_t_arr = nStorm_t
        ;;    nRand_t_arr = nRand_t
        ;; ENDIF ELSE BEGIN
        ;;    nStorm_t_arr = [nStorm_t_arr,nStorm_t]
        ;;    nRand_t_arr = [nRand_t_arr,nRand_t]
        ;; ENDELSE

        IF nStorm_t(iter) LT 4 OR nRand_t(iter) LT 4 OR nStorm_vs_nRand(iter) GT thresh THEN BEGIN
           PRINT,"Insufficient data to perform K-S test!"
           PRINT,'nStorm_t = ' + STRCOMPRESS(nStorm_t(iter),/REMOVE_ALL)
           PRINT,'nRand_t = ' + STRCOMPRESS(nRand_t(iter),/REMOVE_ALL)
           isBad(iter) = 1
        ENDIF ELSE BEGIN ;do the K-S test

           KSTWO,storm_t,rand_t,temp_D,temp_pVal
           ;; IF iter EQ 0 THEN BEGIN
           IF N_ELEMENTS(KSArray) EQ 0 THEN BEGIN
              KSArray=temp_D
              pValArray=temp_pVal
              ;; randMaximus_plot_i_array_of_lists=randTot_plot_i_list
           ENDIF ELSE BEGIN
              KSArray=[KSArray,temp_D]
              pValArray=[pValArray,temp_pVal]
              ;; randMaximus_plot_i_array_of_lists=[randMaximus_plot_i_array_of_lists,randTot_plot_i_list]
           ENDELSE
        ENDELSE
        
        ;; ENDIF ;maxInd conditional

  ENDFOR

  IF saveFile THEN BEGIN

     saveStr+=',n_iterations,stormType,nStormsFromFile,nToCompare,storm_t,processedStormDB,tBeforeRandTime,tAfterRandTime,' + $
              'KSArray,pValArray' ;,randMaximus_plot_i_array_of_lists'

     IF one_of_each THEN saveStr+=',nRand_t,nStorm_t,nStorm_vs_nRand,isBad'

     saveStr+=',filename='+'"'+saveFile+'"'
     PRINT,"Saving output to " + saveFile
     PRINT,"SaveStr: ",saveStr
     biz = EXECUTE(saveStr)
  ENDIF

  ;plots?
  cgwindow,'cghistoplot',KSArray,TITLE='K-S Statistics, ' + STRCOMPRESS(n_iterations,/REMOVE_ALL) + ' iterations comparing ' + stormStr + $
              'storms with random times',BINSIZE=0.01
  cgwindow,'cghistoplot',pValArray,TITLE='P-values, ' + STRCOMPRESS(n_iterations,/REMOVE_ALL) + ' iterations comparing ' + stormStr + $
              'storms with random times',BINSIZE=1e-4,MAXINPUT=1e-2

END