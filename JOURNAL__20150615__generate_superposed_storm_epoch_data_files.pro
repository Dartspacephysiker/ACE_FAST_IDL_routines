;2015/06/15
;The purpose of this journal is to record the commands used to generate the stormtime files which
;will be used by the procedure SUPERPOSE_RANDOMTIMES_AND_ALFVEN_DB_QUANTITIES to perform K-S tests

PRO JOURNAL__20150615__generate_superposed_storm_epoch_data_files

  date='20150615'

  ;; ;small storms
  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=0,NEVENTHISTS=1,/USE_DARTDB_START_ENDDATE,NEVBINSIZE=60.0D,TBEFORESTORM=50,TAFTERSTORM=50, $
                                            SAVEFILE='superposed_small_storm_output_w_n_Alfven_events--'+date+'.dat'
  ;; ;large storms
  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1,NEVENTHISTS=1,/USE_DARTDB_START_ENDDATE,NEVBINSIZE=60.0D,TBEFORESTORM=50,TAFTERSTORM=50, $
                                            SAVEFILE='superposed_large_storm_output_w_n_Alfven_events--'+date+'.dat'  
  ;; ;all storms
  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=2,NEVENTHISTS=1,/USE_DARTDB_START_ENDDATE,NEVBINSIZE=60.0D,TBEFORESTORM=50,TAFTERSTORM=50, $
                                            SAVEFILE='superposed_all_storm_output_w_n_Alfven_events--'+date+'.dat'

END
