;The purpose of this file is merely to obtain the indices of the events in the Alfven DB that
;correspond to the awesomest storms.
date='20150701'
outFile='superposed_large_storm_output_w_n_Alfven_events--arreglado--HEAVILY_PARED--neg5_to_20hours--'+date+'.dat'

commencementFile='commencement_offsets_for_largestorms--20150629--HEAVILY_PARED.sav'
restore,commencementFile

;5='Gorgeous'
;4='Good'
;3='OK'
;2='Marginal'
;1='Marginal (very)'
;0=Bad

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
                                          TBEFORESTORM=5,TAFTERSTORM=20, $
                                          /NEVENTHISTS,NEVBINSIZE=120.,$
                                          SUBSET_OF_STORMS=lrg_commencement.ind, $
                                          HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                          /OVERLAY_NEVENTHISTS, NEVRANGE=[0,4000], $
                                          SAVEFILE=outFile
