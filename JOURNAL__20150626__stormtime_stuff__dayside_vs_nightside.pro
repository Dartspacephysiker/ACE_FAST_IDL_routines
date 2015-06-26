PRO JOURNAL__20150626__stormtime_stuff__dayside_vs_nightside

  use_symh=0

  titleSuff=[" (dayside)","(nightside)"]
  ;This commencement file is generated in the read_storm_commencement_textFile routine
  commencementFile='commencement_offsets_for_largestorms--20150625.sav'
  restore,commencementFile

  ;Added some new keywords to superpose_storm[...] routine so that we can specify offsets etc.
  FOR i=0,1 DO BEGIN
     superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               TBEFORESTORM=60,TAFTERSTORM=60, $
                                               /NEVENTHISTS,NEVBINSIZE=300,$
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               /OVERLAY_NEVENTHISTS,USE_SYMH=use_symh, $
                                               /USE_AE, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR

  FOR i=0,1 DO BEGIN
     superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               TBEFORESTORM=60,TAFTERSTORM=60, $
                                               /NEVENTHISTS,NEVBINSIZE=300,$
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR

  ;ION_FLUX_UP
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=16,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[1e5,1e10], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR
                                            
  ;ION_ENERGY_FLUX
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=14,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[1e-5,1e0], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR
  
  ;EFLUX_LOSSCONE_INTEG
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=10,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[10,1e5], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR

  ;Poynting flux
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=48,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[4e-2,2e2], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR

  ;;MAX_CHARE_TOTAL
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=13,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[12,6e3], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR
 
  ;;MAX_CHARE_LOSSCONE
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=12,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[12,6e3], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR

  ;;MAX_CHARE_LOSSCONE
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=12,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[12,6e3], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR

  ;MAG_CURRENT
  FOR i=0,1 DO BEGIN
     SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=6,STORMTYPE=1, $
                                               /USE_DARTDB_START_ENDDATE, $
                                               AVG_TYPE_MAXIND=1, $
                                               /NEG_AND_POS_SEPAR, $
                                               NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                               SUBSET_OF_STORMS=lrg_commencement.ind, $
                                               HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                               YRANGE_MAXIND=[10,1e3], $
                                               USE_SYMH=use_symh, $
                                               DAYSIDE=(i EQ 0) ? 1 : 0, $
                                               NIGHTSIDE=(i EQ 0) ? 0 : 1, $
                                               TITLESUFF=titleSuff[i]
  ENDFOR


END