;+
;2015/06/26 On Southwest flight from Sea-Tac to Chicago-Midway
;One of Roger Varney's suggestions after looking at my poster at CEDAR 2015 was that I check out the Alfvénic response to AE, so
;that's what I'm doing here. I'm using the same storm epochs as before, but just plotting AE instead
;-
PRO JOURNAL__20150626__CHECK_OUT_AE

  commencementFile='commencement_offsets_for_largestorms--20150625.sav'
  restore,commencementFile

  superpose_storms_and_alfven_db_quantities,MAXIND=6,STORMTYPE=1, $
                                            /USE_AE, $
                                            /USE_DARTDB_START_ENDDATE, $
                                            TBEFORESTORM=60,TAFTERSTORM=60, $
                                            /NEVENTHISTS,NEVBINSIZE=300,$
                                            SUBSET_OF_STORMS=lrg_commencement.ind, $
                                            HOUR_OFFSET_OF_SUBSET=lrg_commencement.offset, $
                                            /OVERLAY_NEVENTHISTS


END