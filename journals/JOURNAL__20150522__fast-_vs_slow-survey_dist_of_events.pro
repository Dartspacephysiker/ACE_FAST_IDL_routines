;2015/05/22
;Here are the commands used to perform this study
;NOTE! I have set a breakpoint inside get_chaston_ind on the following line:

;  IF good_i NE !NULL THEN ind_region_magc_geabs10_ACEstart=cgsetintersection(ind_region_magc_geabs10_ACEstart,good_i)

;;The idea is that I will put in a manual screening at the breakpoint to restrict data to those
;corresponding to a specified sample rate (which I pull from
;info_on_FAST_database/Histogram_of_FAST_fields_sample_ts_for_Dartmouth_DB_20150228--cleaned--absmagc_GE_10.txt). 

;For 512 Hz samps (35714 samps)
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ512Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='dawnward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ512Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='duskward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ512Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='all_IMF',SMOOTHWINDOW=1

;For 128 Hz samps (187213 samps)
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ128Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='dawnward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ128Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='duskward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ128Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='all_IMF',SMOOTHWINDOW=1

;For 32 Hz samps (2875 samps)
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ32Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='dawnward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ32Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='duskward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ32Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='all_IMF',SMOOTHWINDOW=1

;For 8 Hz samps (8168 samps)
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ8Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='dawnward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ8Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='duskward',BYMIN=5,SMOOTHWINDOW=1
get_inds_from_db,INDSUFFIX='fieldsSampRateEQ8Hz', INDPREFIX='20150522__study_of_fast_vs_slow_survey--wholecap--', $
                 MINMLT=0,MAXMLT=24, $
                 CLOCKSTR='all_IMF',SMOOTHWINDOW=1

;;All right, now we have all the indices. What comes next?
;;MOKE DAT
;512-Hz files
all_IMF_512Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_all_IMF--1stable--1min_IMFsmooth--OMNI_GSM_fieldsSampRateEQ512Hz.sav'
dawnward_512Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_dawnward--1stable--1min_IMFsmooth--OMNI_GSM_byMin_5.0_fieldsSampRateEQ512Hz.sav'
duskward_512Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_duskward--1stable--1min_IMFsmooth--OMNI_GSM_byMin_5.0_fieldsSampRateEQ512Hz.sav'

key_scatterplots_polarproj,plot_i_file=all_IMF_512Hz_indsFile,STRANS=97
key_scatterplots_polarproj,plot_i_file=dawnward_512Hz_indsFile
key_scatterplots_polarproj,plot_i_file=duskward_512Hz_indsFile

;128-Hz files
all_IMF_128Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_all_IMF--1stable--1min_IMFsmooth--OMNI_GSM_fieldsSampRateEQ128Hz.sav'
dawnward_128Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_dawnward--1stable--1min_IMFsmooth--OMNI_GSM_byMin_5.0_fieldsSampRateEQ128Hz.sav'
duskward_128Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_duskward--1stable--1min_IMFsmooth--OMNI_GSM_byMin_5.0_fieldsSampRateEQ128Hz.sav'

key_scatterplots_polarproj,plot_i_file=all_IMF_128Hz_indsFile,STRANS=97
key_scatterplots_polarproj,plot_i_file=dawnward_128Hz_indsFile
key_scatterplots_polarproj,plot_i_file=duskward_128Hz_indsFile

;32-Hz files
all_IMF_32Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_all_IMF--1stable--1min_IMFsmooth--OMNI_GSM_fieldsSampRateEQ32Hz.sav'
dawnward_32Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_dawnward--1stable--1min_IMFsmooth--OMNI_GSM_byMin_5.0_fieldsSampRateEQ32Hz.sav'
duskward_32Hz_indsFile='PLOT_INDICES_20150522__study_of_fast_vs_slow_survey--wholecap--North_duskward--1stable--1min_IMFsmooth--OMNI_GSM_byMin_5.0_fieldsSampRateEQ32Hz.sav'

key_scatterplots_polarproj,plot_i_file=all_IMF_32Hz_indsFile,STRANS=90
key_scatterplots_polarproj,plot_i_file=dawnward_32Hz_indsFile,STRANS=90
key_scatterplots_polarproj,plot_i_file=duskward_32Hz_indsFile,STRANS=90
