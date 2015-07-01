;;Just like it says: we want the indices for the huge storm. Now we can start exploring.

;; restore,'commencement_offsets_for_largestorms--20150629--HEAVILY_PARED.sav'
;; restore,'../database/sw_omnidata/large_and_small_storms--1985-2011--Anderson.sav'

;; print,min(lrg_commencement.dst_min,minind)
;; print,lrg_commencement.ind(minind)
;; print,stormstruct_inds_large(68)
;; print,stormstruct.dst(339)
;; print,stormstruct.tstamp(339)

myTime='2000-07-16T00:00:00Z'
sw_data_plotter_and_dartdb_ind_getter,center_t=myTime,prod='SYM-H',dartdb_inds_list=dartdb_inds_list,OMNI_INDS_LIST=omni_inds_list

;;print,time_to_str(cdbtime[dartdb_inds_list[0]])
;; print,maximus.time(dartdb_inds_list(0))

bigStorm_i=dartDB_inds_list(0)
bigStorm_OMNI_i=omni_inds_list(0)
dbFile='../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'
save,bigStorm_i,bigStorm_OMNI_i,dbFile,FILENAME='PLOT_INDICES--Huge_20000716_storm.sav'

