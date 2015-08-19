;No way; I think there are some dupes in maximus...
PRO JOURNAL__20150818__check_maximus_dupes

  dataDir='/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  DBFile='Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  DB_tFile='Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
  stormFile='saves_output_etc/superposed_large_storm_output_w_n_Alfven_events--20150817.dat'

  outDupeFile = 'Timestamps_for_duplicates_in_'+DBFile+'.txt'

  print,'Restoring ' + DBFile + '...'
  restore,dataDir+DBFile

  print,'Restoring ' + DB_tFile + '...'
  restore,dataDir+DB_tFile
 
  check_dupes,cdbtime,OUT_DUPE_I=out_dupe_i,printdupes='n'

  ;open, print
  OPENW,lun,dataDir+outDupeFile,/GET_LUN

  PRINTF,lun,FORMAT='("Duplicate index",T20,"Timestamp",T45,"Sample_T",T60,"Burst")'
  PRINTF,lun,""
  FOR i=0,N_ELEMENTS(out_dupe_i)-1 DO BEGIN
     ind=out_dupe_i[i]
     PRINTF,lun,FORMAT='(I0,T20,A0,T45,G0.5,T60,I0)',ind,maximus.time[ind],maximus.sample_t[ind],maximus.burst[ind]
  ENDFOR

  CLOSE,lun

END