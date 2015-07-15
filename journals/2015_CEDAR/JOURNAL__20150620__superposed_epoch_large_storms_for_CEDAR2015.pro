;+
;2015/06/20
;Another necessary plot for my CEDAR 2015 poster...
;-

PRO JOURNAL__20150620_SUPERPOSED_EPOCH_LARGE_STORMS_FOR_CEDAR2015


   superpose_storms_and_alfven_db_quantities,STORMTYPE=1, $
                                             /NEVENTHISTS,NEVBINSIZE=60, $
                                             /USE_DARTDB_START_ENDDATE, $
                                             TBEFORESTORM=60,TAFTERSTORM=60,MAXIND=6
   superpose_storms_nevents,STORMTYPE=1, $
                            /NEVENTHISTS,NEVBINSIZE=300, $
                            /USE_DARTDB_START_ENDDATE, $
                            TBEFORESTORM=60,TAFTERSTORM=60,MAXIND=6,/OVERPLOT_HIST,/USE_SYMH
   
END