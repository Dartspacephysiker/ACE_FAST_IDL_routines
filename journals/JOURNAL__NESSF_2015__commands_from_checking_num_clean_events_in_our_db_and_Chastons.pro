 ;; The point of this journal is to ascertain how many good (i.e., solidly Alfvénic)
 ;;  events there are in both the updated Dartmouth FAC databased and Chaston's original
 ;;  database. It appears there are
 ;;  237815 in the updated Dartmouth database
 ;;  35212 in the original Chaston database

 restore,'scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus.sav'

 ;; % Compiled module: $MAIN$.
 ;; % Compiled module: CGSETINTERSECTION.

 ;; ****From alfven_db_cleaner.pro****
 ;; Lost 27711 events to NaNs and infinities...
 ;; Lost 1565 events to user-defined cutoffs for various quantities...
 ;; ****END alfven_db_cleaner.pro****

 help,good_i
 ;; GOOD_I          LONG      = Array[790543]
 print,good_i[0]
 ;;      0
 print,good_i[10000]
 ;;  10102
 print,good_i[100000]
 ;; 111135
 print,good_i[200000]
 ;; 213049
 good_i=cgsetintersection(good_i,where(abs(maximus.mag_current) GT 10))

 ;; ************************************************
 ;; Here's the total number of "good" events in the updated DB 
 print,n_elements(good_i)
 ;; 237815

 ;; Now let's check out the original Chaston DB
 .full_reset_session
 ;; Data dir set to /SPENCEdata2/Research/Cusp/database/
 restore,'../database/processed/maximus.dat'
 lun=-1
 n_events=n_elements(maximus.mag_current)
 ;; .run "/tmp/idltemp96855b"
 ;; Compiled module: $MAIN$.
 ;; Compiled module: CGSETINTERSECTION.
 ;; Tag name EFLUX_LOSSCONE_INTEG is undefined for structure <Anonymous>.
 ;; Execution halted at: $MAIN$             61 /tmp/idltemp96855b
 print,tag_names(maximus)
 ;; ORBIT TIME ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
 ;; INTEG_ELEC_ENERGY_FLUX CHAR_ELEC_ENERGY ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP
 ;; INTEG_ION_FLUX INTEG_ION_FLUX_UP CHAR_ION_ENERGY WIDTH_TIME WIDTH_X DELTA_B
 ;; DELTA_E MODE SAMPLE_T PROTON_FLUX_UP PROTON_ENERGY_FLUX_UP OXY_FLUX_UP
 ;; OXY_ENERGY_FLUX_UP HELIUM_FLUX_UP HELIUM_ENERGY_FLUX_UP SC_POT
 ;; TOTAL_ELECTRON_ENERGY_DFLUX TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX TOTAL_ION_OUTFLOW
 ;; TOTAL_ALFVEN_ION_OUTFLOW TOTAL_UPWARD_ION_OUTFLOW
 ;; TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
 max_tags=tag_names(maximus)
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;; Maximus.ORBIT is causing us to lose 0 events.
 ;; Maximus.TIME is causing us to lose 0 events.
 ;; Maximus.ALT is causing us to lose 0 events.
 ;; Maximus.MLT is causing us to lose 0 events.
 ;; Maximus.ILAT is causing us to lose 0 events.
 ;; Maximus.MAG_CURRENT is causing us to lose 0 events.
 ;; Maximus.ESA_CURRENT is causing us to lose 0 events.
 ;; Maximus.ELEC_ENERGY_FLUX is causing us to lose 0 events.
 ;; Maximus.INTEG_ELEC_ENERGY_FLUX is causing us to lose 0 events.
 ;; Maximus.CHAR_ELEC_ENERGY is causing us to lose 0 events.
 ;; Maximus.ION_ENERGY_FLUX is causing us to lose 0 events.
 ;; Maximus.ION_FLUX is causing us to lose 0 events.
 ;; Maximus.ION_FLUX_UP is causing us to lose 0 events.
 ;; Maximus.INTEG_ION_FLUX is causing us to lose 0 events.
 ;; Maximus.INTEG_ION_FLUX_UP is causing us to lose 0 events.
 ;; Maximus.CHAR_ION_ENERGY is causing us to lose 89 events.
 ;; Maximus.WIDTH_TIME is causing us to lose 0 events.
 ;; Maximus.WIDTH_X is causing us to lose 0 events.
 ;; Maximus.DELTA_B is causing us to lose 0 events.
 ;; Maximus.DELTA_E is causing us to lose 0 events.
 ;; Maximus.MODE is causing us to lose 0 events.
 ;; Maximus.SAMPLE_T is causing us to lose 0 events.
 ;; Maximus.PROTON_FLUX_UP is causing us to lose 0 events.
 ;; Maximus.PROTON_ENERGY_FLUX_UP is causing us to lose 0 events.
 ;; Maximus.OXY_FLUX_UP is causing us to lose 0 events.
 ;; Maximus.OXY_ENERGY_FLUX_UP is causing us to lose 51860 events.
 ;; Maximus.HELIUM_FLUX_UP is causing us to lose 0 events.
 ;; Maximus.HELIUM_ENERGY_FLUX_UP is causing us to lose 0 events.
 ;; Maximus.SC_POT is causing us to lose 0 events.
 ;; Maximus.TOTAL_ELECTRON_ENERGY_DFLUX is causing us to lose 0 events.
 ;; Maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX is causing us to lose 0 events.
 ;; Maximus.TOTAL_ION_OUTFLOW is causing us to lose 0 events.
 ;; Maximus.TOTAL_ALFVEN_ION_OUTFLOW is causing us to lose 0 events.
 ;; Maximus.TOTAL_UPWARD_ION_OUTFLOW is causing us to lose 0 events.
 ;; Maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW is causing us to lose 0 events.
 
 help,maximus
 ;; ** Structure <1950668>, 35 tags, length=20508608, data length=20508600, refs=1:
 ;;    ORBIT           LONG      Array[134925]
 ;;    TIME            STRING    Array[134925]
 ;;    ALT             FLOAT     Array[134925]
 ;;    MLT             FLOAT     Array[134925]
 ;;    ILAT            FLOAT     Array[134925]
 ;;    MAG_CURRENT     FLOAT     Array[134925]
 ;;    ESA_CURRENT     FLOAT     Array[134925]
 ;;    ELEC_ENERGY_FLUX
 ;; %              FLOAT     Array[134925]
 ;;    INTEG_ELEC_ENERGY_FLUX
 ;; %              FLOAT     Array[134925]
 ;;    CHAR_ELEC_ENERGY
 ;; %              FLOAT     Array[134925]
 ;;    ION_ENERGY_FLUX FLOAT     Array[134925]
 ;;    ION_FLUX        FLOAT     Array[134925]
 ;;    ION_FLUX_UP     FLOAT     Array[134925]
 ;;    INTEG_ION_FLUX  FLOAT     Array[134925]
 ;;    INTEG_ION_FLUX_UP
 ;; %              FLOAT     Array[134925]
 ;;    CHAR_ION_ENERGY FLOAT     Array[134925]
 ;; %              < Press Spacebar to continue, ? for help > 
 ;;    WIDTH_TIME      FLOAT     Array[134925]
 ;;    WIDTH_X         FLOAT     Array[134925]
 ;;    DELTA_B         FLOAT     Array[134925]
 ;;    DELTA_E         FLOAT     Array[134925]
 ;;    MODE            FLOAT     Array[134925]
 ;;    SAMPLE_T        FLOAT     Array[134925]
 ;;    PROTON_FLUX_UP  FLOAT     Array[134925]
 ;;    PROTON_ENERGY_FLUX_UP
 ;; %              FLOAT     Array[134925]
 ;;    OXY_FLUX_UP     FLOAT     Array[134925]
 ;;    OXY_ENERGY_FLUX_UP
 ;; %              FLOAT     Array[134925]
 ;;    HELIUM_FLUX_UP  FLOAT     Array[134925]
 ;;    HELIUM_ENERGY_FLUX_UP
 ;; %              FLOAT     Array[134925]
 ;;    SC_POT          FLOAT     Array[134925]
 ;;    TOTAL_ELECTRON_ENERGY_DFLUX
 ;; %              FLOAT     Array[134925]
 ;;    TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
 ;; %              FLOAT     Array[134925]
 ;;    TOTAL_ION_OUTFLOW
 ;; %              FLOAT     Array[134925]
 ;; %              < Press Spacebar to continue, ? for help > 
 ;;    TOTAL_ALFVEN_ION_OUTFLOW
 ;; %              FLOAT     Array[134925]
 ;;    TOTAL_UPWARD_ION_OUTFLOW
 ;; %              FLOAT     Array[134925]
 ;;    TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
 ;; %              FLOAT     Array[134925]
 
 help,lun
 ;; LUN             INT       =       -1
 help,n_events
 ;; N_EVENTS        LONG      =       134925
 help,n_events
 ;; N_EVENTS        LONG      =       134925

****From alfven_db_cleaner.pro****
Lost 89 events to NaNs and infinities...
 .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 print,max_tags
 ;; ORBIT TIME ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
 ;; INTEG_ELEC_ENERGY_FLUX CHAR_ELEC_ENERGY ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP
 ;; INTEG_ION_FLUX INTEG_ION_FLUX_UP CHAR_ION_ENERGY WIDTH_TIME WIDTH_X DELTA_B
 ;; DELTA_E MODE SAMPLE_T PROTON_FLUX_UP PROTON_ENERGY_FLUX_UP OXY_FLUX_UP
 ;; OXY_ENERGY_FLUX_UP HELIUM_FLUX_UP HELIUM_ENERGY_FLUX_UP SC_POT
 ;; TOTAL_ELECTRON_ENERGY_DFLUX TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX TOTAL_ION_OUTFLOW
 ;; TOTAL_ALFVEN_ION_OUTFLOW TOTAL_UPWARD_ION_OUTFLOW
 ;; TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
 .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
   good_i = cgsetintersection(good_i,where(maximus.char_elec_energy LE max_chare_hcutOff AND maximus.char_elec_energy GT max_chare_lcutoff,/NULL)) 
 .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;; Lost 126465 events to user-defined cutoffs for various quantities...
 ;; ****END alfven_db_cleaner.pro****

 help,n_elements(good_i)
 ;; <Expression>    LONG      =         8371
 .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;; % Tag name ALFVENIC is undefined for structure <Anonymous>.
 ;; % Execution halted at: $MAIN$              2 /tmp/idltemp96855b
 n_events=n_elements(maximus.mag_current)
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 help,good_i
 ;; GOOD_I          LONG      = Array[134836]
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.

 ;; ****From alfven_db_cleaner.pro****
 ;; Lost 89 events to NaNs and infinities...
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 help,good_i
 ;; GOOD_I          LONG      = Array[134810]
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 help,good_i
 ;; GOOD_I          LONG      = Array[8400]
 n_events=n_elements(maximus.mag_current)
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 help,good_i
 ;; GOOD_I          LONG      = Array[134836]
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;;  .run "/tmp/idltemp96855b"
 ;; % Compiled module: $MAIN$.
 ;; Lost 291 events to user-defined cutoffs for various quantities...
 ;; ****END alfven_db_cleaner.pro****

 help,good_i
 ;; GOOD_I          LONG      = Array[134634]
 good_i=cgsetintersection(good_i,where(abs(maximus.mag_current) GT 10))

 ;; ************************************************
 ;; OK, here's the total number of "good" events in the original Chaston DB
 help,good_i
 ;; GOOD_I          LONG      = Array[35212]
 ;; ************************************************ 