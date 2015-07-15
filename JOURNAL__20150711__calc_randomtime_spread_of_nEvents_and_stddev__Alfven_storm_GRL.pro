;2015/07/11
;The data file which goes with this journal is
;'JOURNAL__20150611__calc_randomtime_spread_of_nEvents_and_stddev__Alfven_storm_GRL.dat', and it contains a list of plot indices
;to go with the 20150611 maximus database that gets returned from my running the following command:
;JOURNAL__20150711__CALC_RANDOMTIME_SPREAD_OF_NEVENTS_AND_STDDEV__ALFVEN_STORM_GRL,n_iter=20,NRANDTIMEPERSLAG=100,RET_I_MASTER_LIST=ret_i_master_list

;MAN!! The variance associated with the number of events per random period is no good, at least not as calculated.

;That's what's up

PRO JOURNAL__20150711__calc_randomtime_spread_of_nEvents_and_stddev__Alfven_storm_GRL,N_ITER=n_iter,nRandTimePerSlag=nRandTimePerSlag,RET_I_MASTER_LIST=ret_i_list

  dataDir='/SPENCEdata/Research/Cusp/database/'
  date='20150615'

  defswDBDir       = 'sw_omnidata/'
  defswDBFile      = 'sw_data.dat'
                   
  defStormDir      = 'processed/'
  ;; defStormFiles     = 'large_and_small_storms--1985-2011--Anderson.sav'
  defStormFile     = ['superposed_small_storm_output_w_n_Alfven_events--'+date+'.dat', $
                      'superposed_large_storm_output_w_n_Alfven_events--'+date+'.dat', $
                      'superposed_all_storm_output_w_n_Alfven_events--'+date+'.dat']

  defDST_AEDir     = 'processed/'
  defDST_AEFile    = 'idl_ae_dst_data.dat'
                   
  defUse_SYMH      = 0

  defDBDir         = 'dartdb/saves/'
  defDBFile        = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  defDB_tFile      = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'

  defnRandTimePerSlag = 100


  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile

  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir

  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile

  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH=defUse_SYMH

  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile

  IF N_ELEMENTS(nRandTimePerSlag) EQ 0 THEN nRandTimePerSlag=defNRandTimePerSlag

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  IF N_ELEMENTS(sw_data) EQ 0 THEN restore,dataDir+swDBDir+swDBFile

  IF ~use_SYMH THEN BEGIN
     IF N_ELEMENTS(dst) EQ 0 THEN restore,dataDir+DST_AEDir+DST_AEFile
  ENDIF

  IF N_ELEMENTS(maximus) EQ 0 THEN restore,dataDir+defDBDir+DBFile
  IF N_ELEMENTS(cdbTime) EQ 0 THEN restore,dataDir+defDBDir+DB_tFile

  STORMS__STATISTICS_OF_NEVENTS_RANDOMTIMES, $
     RET_MAXIMUS_I_LIST=ret_i_list, $
     NRANDTIME=nRandTimePerSlag, $
     TAFTERRANDTIME=60, $
     TBEFORERANDTIME=60, $
     STORMFILE='superposed_large_storm_output_w_n_Alfven_events--20150711.dat', $
     MAXIMUS=maximus, $
     CDBTIME=cdbTime, $
     SW_DATA=sw_data, $
     DST=dst
  
  ret_i_master_list = LIST(ret_i_list)

  FOR i=0,n_iter-2 DO BEGIN
     PRINT,FORMAT='(I4," out of ",I4)',i,n_iter
     STORMS__STATISTICS_OF_NEVENTS_RANDOMTIMES, $
        RET_MAXIMUS_I_LIST=ret_i_list, $
        NRANDTIME=nRandTimePerSlag, $
        TAFTERRANDTIME=60, $
        TBEFORERANDTIME=60, $
        STORMFILE='superposed_large_storm_output_w_n_Alfven_events--20150711.dat',$
        MAXIMUS=maximus, $
        CDBTIME=cdbTime, $
        SW_DATA=sw_data, $
        DST=dst

     ret_i_master_list.add,ret_i_list
     
  ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now let's get statistical

  ;;MEAN
  totNRandTimes=n_iter*nRandTimePerSlag
  nEvents_in_each_storm=MAKE_ARRAY(totNRandTimes,/L64)
  totNonzeroTimes=0               ;keep track of num periods that actually have events
  FOR i=0,n_iter-1 DO BEGIN
     PRINT,'i = ' + STRCOMPRESS(i,/REMOVE_ALL)
     ;; FOR j=0,nRandTimePerSlag-1 DO BEGIN
     nInThisGo=N_ELEMENTS(ret_i_master_list[i])
     IF nInThisGo NE nRandTimePerSlag THEN PRINT,'nInThisGo is only ' + $
        STRCOMPRESS(nInThisGo,/REMOVE_ALL) + '!!!!'
     FOR j=0,nInThisGo-1 DO BEGIN
        PRINT,'j = ' + STRCOMPRESS(j,/REMOVE_ALL)
        ;; nEvents_in_each_storm[i*nRandTimePerSlag+j] = N_ELEMENTS((ret_i_master_list[i])[j])
        nEvents_in_each_storm[totNonzeroTimes] = N_ELEMENTS((ret_i_master_list[i])[j])
        totNonzeroTimes++
     ENDFOR
  ENDFOR
  totNEvents=TOTAL(nEvents_in_each_storm)
  avg_nEvents = DOUBLE(totNEvents)/DOUBLE(totNRandTimes)
  
  ;;VARIANCE
  var_nEvPartial=MAKE_ARRAY(totNRandTimes,/DOUBLE)
  FOR i =0,totNRandTimes-1 DO var_nEvPartial(i) = (nEvents_in_each_storm(i)-avg_nEvents)^2
  var_nEvents = TOTAL(var_nEvPartial)/DOUBLE(totNRandTimes-1)
  
  cghistoplot,nevents_in_each_storm

  ;;LOG AVERAGE
  print,10.0^(total(alog10(nevents_in_each_storm(where(nevents_in_each_storm GT 0)))/totNRandTimes))

END