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
SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=14,STORMTYPE=1,/LOG_DBQUANTITY,/USE_DARTDB_START_ENDDATE, $
                                          /NEG_AND_POS_SEPAR,NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60, $
                                          AVG_TYPE_MAXIND=1

;ion_flux_up
;this one shows special promise
SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=16,STORMTYPE=1,/USE_DARTDB_START_ENDDATE,AVG_TYPE_MAXIND=1,/NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                          NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60
;this one too,all-storm style
SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=16,STORMTYPE=2,/USE_DARTDB_START_ENDDATE,AVG_TYPE_MAXIND=1,/NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                          NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60

;ION_ENERGY_FLUX
SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=14,STORMTYPE=1,/USE_DARTDB_START_ENDDATE,AVG_TYPE_MAXIND=1,/NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                          NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60

SUPERPOSE_STORMS_AND_ALFVEN_DB_QUANTITIES,MAXIND=12,STORMTYPE=1,/USE_DARTDB_START_ENDDATE,AVG_TYPE_MAXIND=1,/NEG_AND_POS_SEPAR,/LOG_DBQUANTITY, $
                                          NEVBINSIZE=300,TBEFORESTORM=60,TAFTERSTORM=60


restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'
largestorm_ind=cgsetintersection(largestorm_ind,where(maximus.max_chare_losscone GE 4 AND maximus.max_chare_losscone LE 5000))

cghistoplot,maximus.ilat(largestorm_ind)
cghistoplot,maximus.ilat(largestorm_ind),maxinput=-50,mininput=-88
cghistoplot,maximus.ilat(largestorm_ind),maxinput=88,mininput=50

cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0)))
cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0)))

;; tag #   name
;; 0        ORBIT
;; 1        ALFVENIC
;; 2        TIME
;; 3        ALT
;; 4        MLT
;; 5        ILAT
;; 6        MAG_CURRENT
;; 7        ESA_CURRENT
;; 8        ELEC_ENERGY_FLUX
;; 9        INTEG_ELEC_ENERGY_FLUX
;; 10       EFLUX_LOSSCONE_INTEG
;; 11       TOTAL_EFLUX_INTEG
;; 12       MAX_CHARE_LOSSCONE
;; 13       MAX_CHARE_TOTAL
;; 14       ION_ENERGY_FLUX
;; 15       ION_FLUX
;; 16       ION_FLUX_UP
;; 17       INTEG_ION_FLUX
;; 18       INTEG_ION_FLUX_UP
;; 19       CHAR_ION_ENERGY
;; 20       WIDTH_TIME
;; 21       WIDTH_X
;; 22       DELTA_B
;; 23       DELTA_E
;; 24       SAMPLE_T
;; 25       MODE
;; 26       PROTON_FLUX_UP
;; 27       PROTON_CHAR_ENERGY
;; 28       OXY_FLUX_UP
;; 29       OXY_CHAR_ENERGY
;; 30       HELIUM_FLUX_UP
;; 31       HELIUM_CHAR_ENERGY
;; 32       SC_POT
;; 33       L_PROBE
;; 34       MAX_L_PROBE
;; 35       MIN_L_PROBE
;; 36       MEDIAN_L_PROBE
;; 37       START_TIME
;; 38       STOP_TIME
;; 39       TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE
;; 40       TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT
;; 41       TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
;; 42       TOTAL_ION_OUTFLOW_SINGLE
;; 43       TOTAL_ION_OUTFLOW_MULTIPLE_TOT
;; 44       TOTAL_ALFVEN_ION_OUTFLOW
;; 45       TOTAL_UPWARD_ION_OUTFLOW_SINGLE
;; 46       TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;; 47       TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
;; 48       PFLUXEST