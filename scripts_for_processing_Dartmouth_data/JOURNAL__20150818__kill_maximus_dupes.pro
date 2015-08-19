;No way; I think there are some dupes in maximus...
PRO JOURNAL__20150818__kill_maximus_dupes

  dataDir='/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  DBFile='Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  DB_tFile='Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
  stormFile='saves_output_etc/superposed_large_storm_output_w_n_Alfven_events--20150817.dat'

  print,'Restoring ' + DBFile + '...'
  restore,dataDir+DBFile

  print,'Restoring ' + DB_tFile + '...'
  restore,dataDir+DB_tFile
 
  check_dupes,cdbtime,OUT_DUPE_I=out_dupe_i,printdupes='n'

  UNIQ_II=uniq(cdbtime(out_dupe_i))
  
  uniq_i=uniq(cdbtime)

  maximus=resize_maximus(maximus,CDBTIME=cdbTime,INDS=uniq_i)

  save,maximus,filename=DBFile+'_nodupes'
  save,cdbTime,filename=DB_tFile+'_nodupes'

END