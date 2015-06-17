;2015/06/16
;This journal will use the output from SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES for large storms to figure out what ion upflow
;during storm times looks like as seen by the FAST Alfvén wave database

restore,'superposed_largestorms_-15_to_5_hours.dat'
largeStorm_ind=tot_plot_i_list(0)
FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO largeStorm_ind=[largeStorm_ind,tot_plot_i_list(i)]
;;LARGESTORM_IND            LONG64    = Array[47936]

;Let's look at a scatterplot of these guys
KEY_SCATTERPLOTS_POLARPROJ,/NORTH,/OVERLAYAURZONE,PLOTSUFF='large_storms_-15_to_5_hours_around_storm_commencement--',JUST_PLOT_I=largeStorm_ind
KEY_SCATTERPLOTS_POLARPROJ,/SOUTH,/OVERLAYAURZONE,PLOTSUFF='large_storms_-15_to_5_hours_around_storm_commencement--',JUST_PLOT_I=largeStorm_ind

;;All right, they reveal nothing interesting... So let's move on!
;;A look at ion outflow directly, perhaps?

;; restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'
;; mTags=tag_names(maximus)
;; print,mTags(14:19)
;;**************************************************
;;*WINNERS*
;; ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP INTEG_ION_FLUX
;; INTEG_ION_FLUX_UP CHAR_ION_ENERGY 
;; (OTHERS ARE BELOW)
;;**************************************************

;;Now let's try this superpose thing
;;ION_ENERGY_FLUX
SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=14,STORMTYPE=1,/LOG_DBQUANTITY,/USE_DARTDB_START_ENDDATE,/NEG_AND_POS_SEPAR









;; ORBIT ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
;; INTEG_ELEC_ENERGY_FLUX EFLUX_LOSSCONE_INTEG TOTAL_EFLUX_INTEG MAX_CHARE_LOSSCONE
;; MAX_CHARE_TOTAL 
;; WIDTH_TIME WIDTH_X 
;; DELTA_B DELTA_E SAMPLE_T
;; TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
;; TOTAL_ION_OUTFLOW_SINGLE TOTAL_ION_OUTFLOW_MULTIPLE_TOT TOTAL_ALFVEN_ION_OUTFLOW
;; TOTAL_UPWARD_ION_OUTFLOW_SINGLE TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;; TOTAL_ALFVEN_UPWARD_ION_OUTFLOW