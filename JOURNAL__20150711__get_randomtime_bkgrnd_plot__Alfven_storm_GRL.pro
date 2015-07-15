;2015/07/11
;I'm trying to make a plot that has the number of  Alfven waves for 68 random times plotted
;in the background as well

PRO JOURNAL__20150711__GET_RANDOMTIME_BKGRND_PLOT__ALFVEN_STORM_GRL

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


  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            TBEFORESTORM=60,TAFTERSTORM=60, $
                                            /NEVENTHISTS,NEVBINSIZE=300,$
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            /OVERLAY_NEVENTHISTS, $
                                            SAVEFILE='superposed_large_storm_output_w_n_Alfven_events--20150711.dat',RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist


  ;Now get a bunch of random time stuff
  superpose_randomtimes_and_alfven_db_quantities,nevbinsize=300,stormfile='superposed_large_storm_output_w_n_Alfven_events--20150711.dat',/overlay_neventhists,/neventhists,returned_nev_tbins_and_hist=randtime_returned_tbins_and_nevhist

  rt_tbins_and_nevhist_list=LIST(randtime_returned_tbins_and_nevhist)
  FOR i=0,20 DO BEGIN
     superpose_randomtimes_and_alfven_db_quantities,nevbinsize=300,stormfile='superposed_large_storm_output_w_n_Alfven_events--20150711.dat',/overlay_neventhists,/neventhists,returned_nev_tbins_and_hist=randtime_returned_tbins_and_nevhist
     rt_tbins_and_nevhist_list.add,randtime_returned_tbins_and_nevhist
  ENDFOR

  ;now avg them
  sumHist=(rt_tbins_and_nevhist_list[0])[*,1]
  FOR i=1,21 DO sumHist+=(rt_tbins_and_nevhist_list[i])[*,1]
     
  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            TBEFORESTORM=60,TAFTERSTORM=60, $
                                            /NEVENTHISTS,NEVBINSIZE=300,$
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            /OVERLAY_NEVENTHISTS, $
                                            BKGRND_HIST=sumHist/22.

END