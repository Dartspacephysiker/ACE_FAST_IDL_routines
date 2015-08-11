;2015/06/25
;The purpose of this pro is to take advantage of the keywords that I've added to 
;superpose_storms_and_alfven_db_quantities which allow me to specify an offset of the 
;stormtime, and also to specify a subset of large storms to use for the plot
;I eyeballed all 68 (is it 68?) storms, dropping 9 from the original list of 77 because
;the DST traces exhibited unacceptable properties, like multiple main phases, etc.

PRO JOURNAL__20150625__use_arreglado_storm_commencement

  ;This commencement file is generated in the read_storm_commencement_textFile routine
  ;; commencementFile='commencement_offsets_for_largestorms--20150625.sav'
  commencementFile='commencement_offsets_for_largestorms--20150629--HEAVILY_PARED.sav'
  restore,commencementFile


  min_rating=3
  subset_i=WHERE(lrg_commencement.rating GE 3)

  lrg_commencement={ind:lrg_commencement.ind(subset_i), $
                    dst_min:lrg_commencement.dst_min(subset_i), $
                    offset:lrg_commencement.offset(subset_i), $
                    offset_dst:lrg_commencement.offset_dst(subset_i), $
                    rating:lrg_commencement.rating(subset_i), $
                    comment:lrg_commencement.comment(subset_i)}


  ;Added some new keywords to superpose_storm[...] routine so that we can specify offsets etc.
  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            TBEFORESTORM=60,TAFTERSTORM=60, $
                                            /NEVENTHISTS,NEVBINSIZE=300,$
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            /OVERLAY_NEVENTHISTS,/USE_SYMH

  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            TBEFORESTORM=60,TAFTERSTORM=60, $
                                            /NEVENTHISTS,NEVBINSIZE=300,$
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            /USE_SYMH

  ;ION_FLUX_UP
  SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=16,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            AVG_TYPE_MAXIND=1, $
                                            /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                            NEVBINSIZE=600,TBEFORESTORM=60,TAFTERSTORM=60, $
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            YRANGE_MAXIND=[1e5,1e10], $
                                            YTITLE_MAXIND="Maximum upward ion flux (N $cm^{-3} s^{-1}$)", $
                                            /USE_SYMH
                                            
  ;INTEG_ION_FLUX_UP
  SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=18,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            AVG_TYPE_MAXIND=1, $
                                            /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                            NEVBINSIZE=600,TBEFORESTORM=60,TAFTERSTORM=60, $
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            YRANGE_MAXIND=[1e7,1e13], $
                                            YTITLE_MAXIND="Integrated upward ion flux (N $s^{-1}$)", $
                                            /USE_SYMH

  ;ION_ENERGY_FLUX
  SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=14,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            AVG_TYPE_MAXIND=1, $
                                            /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                            NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            YRANGE_MAXIND=[1e-5,1e0], $
                                            /USE_SYMH
  


  ;EFLUX_LOSSCONE_INTEG
  SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=10,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            AVG_TYPE_MAXIND=1, $
                                            /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                            NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            YRANGE_MAXIND=[10,1e5], $
                                            /USE_SYMH

  ;Poynting flux
  SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=48,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            AVG_TYPE_MAXIND=1, $
                                            /NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                            NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            YRANGE_MAXIND=[4e-2,2e2], $
                                            /USE_SYMH
  
END