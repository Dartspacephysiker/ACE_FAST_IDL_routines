;Here is the command we used to get inds from our cleaned DB
;batch_get_inds_from_db,smoothwindow=5,stableimf=1

;first, get inds from the database for Chaston's stuff
  ;; batch_get_inds_from_db,smoothwindow=5,stableimf=1,dbfile='/SPENCEdata/Research/Cusp/database/processed/maximus.dat',indprefix='original_chaston_db--'
;you'll need these lines, trust me:
  ;; ind_n_orbs=where(maximus.char_elec_energy GE charERange[0] AND maximus.char_elec_energy LE charERange[1])

;chaston ind files
chastDBFile = '/SPENCEdata/Research/Cusp/database/processed/maximus.dat'

chastDB_dawn_ind = 'PLOT_INDICES_original_chaston_db--North_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_Apr_ 2_15.sav'
chastDB_dusk_ind = 'PLOT_INDICES_original_chaston_db--North_duskward--1stable--5min_IMFsmooth--OMNI_GSM_Apr_ 2_15.sav'
chastDB_allIMF_ind = 'PLOT_INDICES_original_chaston_db--North_all_IMF--1stable--5min_IMFsmooth--OMNI_GSM_Apr_ 2_15.sav'

kolmogorov_smirnov_mlt,'/SPENCEdata/Research/Cusp/database/processed/maximus.dat',PLOT_I_FILE=chastDB_dawn_ind,PLOT2_I_FILE=chastDB_allIMF_ind, $
                       KS_STATS_FILENAME='original_ChastDB--kolm-smir--dawnward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0', $
                       PLOTPREFIX='original_ChastDB--'
kolmogorov_smirnov_mlt,'/SPENCEdata/Research/Cusp/database/processed/maximus.dat',PLOT_I_FILE=chastDB_dusk_ind,PLOT2_I_FILE=chastDB_allIMF_ind, $
                       KS_STATS_FILENAME='original_ChastDB--kolm-smir--duskward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0', $
                       PLOTPREFIX='original_ChastDB--'
kolmogorov_smirnov_mlt,'/SPENCEdata/Research/Cusp/database/processed/maximus.dat',PLOT_I_FILE=chastDB_dawn_ind,PLOT2_I_FILE=chastDB_dusk_ind, $
                       KS_STATS_FILENAME='original_ChastDB--kolm-smir--dawn_dusk--OMNI_GSM--5min_IMFsmooth_byMin_5.0', $
                       PLOTPREFIX='original_ChastDB--'