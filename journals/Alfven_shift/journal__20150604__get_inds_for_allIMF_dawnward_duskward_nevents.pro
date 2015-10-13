;; Date: Thu Jun  4 09:14:11 2015
 
;The output for all of these commands is at the end of the file
get_inds_from_db,INDPREFIX='20150604_allIMF_inds_for_KS_analysis--6-18MLT',minmlt=6,maxmlt=18,clockstr='all_IMF',stableimf=0

get_inds_from_db,INDPREFIX='20150604_dawnward_inds_for_KS_analysis--6-18MLT',minmlt=6,maxmlt=18,clockstr='dawnward',stableimf=0,bymin=5

get_inds_from_db,INDPREFIX='20150604_duskward_inds_for_KS_analysis--6-18MLT',minmlt=6,maxmlt=18,clockstr='duskward',stableimf=0,bymin=5

;**************************************************
;All IMF
;; get_inds_from_db,INDPREFIX='20150604_allIMF_inds_for_KS_analysis--6-18MLT',minmlt=6,maxmlt=18,clockstr='all_IMF',stableimf=0
;There is already a maximus struct loaded! Not loading /SPENCEdata/Research/Cusp/ACE_FAST//SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 279204 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = /SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;There are 83623 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;83623 events with IMF predominantly all_IMF.
;****END check_imf_stability.pro****
;**********DATA SUMMARY**********
;OMNI satellite data delay: 900 seconds
;IMF stability requirement: 0 minutes
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6 18
;ILAT: 60.0000 88.0000
;Hemisphere: North
;IMF Predominance: all_IMF
;Angle lim 1: 180.000
;Angle lim 2: 180.000
;Number of orbits used: 2560
;Total number of events used: 83623
;Percentage of current DB used: 10.2002%
;Saving indices to plot_indices_saves/PLOT_INDICES_20150604_allIMF_inds_for_KS_analysis--6-18MLTNorth_all_IMF--0stable--OMNI_GSM_Jun_4_15.sav...
; % SAVE: Undefined item not saved: POYNTRANGE.
; % SAVE: Undefined item not saved: SMOOTHWINDOW.
; % SAVE: Undefined item not saved: MASKMIN.

;**************************************************
;Duskward
;; get_inds_from_db,INDPREFIX='20150604_duskward_inds_for_KS_analysis--6-18MLT',minmlt=6,maxmlt=18,clockstr='duskward',stableimf=0,bymin=5
;There is already a maximus struct loaded! Not loading /SPENCEdata/Research/Cusp/ACE_FAST//SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 279204 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = /SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;There are 83623 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;ByMin magnitude requirement: 5 nT
;Losing 63039 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;9184 events with IMF predominantly duskward.
;****END check_imf_stability.pro****
;**********DATA SUMMARY**********
;OMNI satellite data delay: 900 seconds
;IMF stability requirement: 0 minutes
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6 18
;ILAT: 60.0000 88.0000
;Hemisphere: North
;IMF Predominance: duskward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 404
;Total number of events used: 9184
;Percentage of current DB used: 1.12025%
;Saving indices to plot_indices_saves/PLOT_INDICES_20150604_duskward_inds_for_KS_analysis--6-18MLTNorth_duskward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav...
; % SAVE: Undefined item not saved: POYNTRANGE.
; % SAVE: Undefined item not saved: SMOOTHWINDOW.
; % SAVE: Undefined item not saved: MASKMIN.


;**************************************************
;Dawnward
;; get_inds_from_db,INDPREFIX='20150604_dawnward_inds_for_KS_analysis--6-18MLT',minmlt=6,maxmlt=18,clockstr='dawnward',stableimf=0,bymin=5
;There is already a maximus struct loaded! Not loading /SPENCEdata/Research/Cusp/ACE_FAST//SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 279204 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = /SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;There are 83623 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;ByMin magnitude requirement: 5 nT
;Losing 63039 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;9422 events with IMF predominantly dawnward.
;****END check_imf_stability.pro****
;**********DATA SUMMARY**********
;OMNI satellite data delay: 900 seconds
;IMF stability requirement: 0 minutes
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6 18
;ILAT: 60.0000 88.0000
;Hemisphere: North
;IMF Predominance: dawnward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 427
;Total number of events used: 9422
;Percentage of current DB used: 1.14928%
;Saving indices to plot_indices_saves/PLOT_INDICES_20150604_dawnward_inds_for_KS_analysis--6-18MLTNorth_dawnward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav...
; % SAVE: Undefined item not saved: POYNTRANGE.
; % SAVE: Undefined item not saved: SMOOTHWINDOW.
; % SAVE: Undefined item not saved: MASKMIN.
