IDL Version 8.4 (linux x86_64 m64). (c) 2014, Exelis Visual Information Solutions, Inc.
Installation number: 212858-3.
Licensed for use by: Dartmouth College

Data dir set to /SPENCEdata2/Research/Cusp/database/
IDL> restore,'scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus.sav'
IDL> .run "/tmp/idltemp96855b"

     RETURN, !NULL
                  ^
% Return statement in procedures can't have values.
  At: /tmp/idltemp96855b, Line 9
% 1 Compilation error(s) in module $MAIN$.
IDL> lun=-1
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
% Compiled module: CGSETINTERSECTION.

****From alfven_db_cleaner.pro****
Lost 27711 events to NaNs and infinities...
Lost 1565 events to user-defined cutoffs for various quantities...
****END alfven_db_cleaner.pro****

IDL> help,good_i
GOOD_I          LONG      = Array[790543]
IDL> print,good_i[0]
           0
IDL> print,good_i[10000]
       10102
IDL> print,good_i[100000]
      111135
IDL> print,good_i[200000]
      213049
IDL> good_i=cgsetintersection(good_i,where(abs(maximus.mag_current) GT 10))
IDL> print,n_elements(good_i)
      237815
IDL> .full_reset_session
Data dir set to /SPENCEdata2/Research/Cusp/database/
IDL> restore,'../database/processed/maximus.dat'
IDL> lun=-1
IDL> n_events=n_elements(maximus.mag_current)
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
% Compiled module: CGSETINTERSECTION.
% Tag name EFLUX_LOSSCONE_INTEG is undefined for structure <Anonymous>.
% Execution halted at: $MAIN$             61 /tmp/idltemp96855b
IDL> print,tag_names(maximus)
ORBIT TIME ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
INTEG_ELEC_ENERGY_FLUX CHAR_ELEC_ENERGY ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP
INTEG_ION_FLUX INTEG_ION_FLUX_UP CHAR_ION_ENERGY WIDTH_TIME WIDTH_X DELTA_B
DELTA_E MODE SAMPLE_T PROTON_FLUX_UP PROTON_ENERGY_FLUX_UP OXY_FLUX_UP
OXY_ENERGY_FLUX_UP HELIUM_FLUX_UP HELIUM_ENERGY_FLUX_UP SC_POT
TOTAL_ELECTRON_ENERGY_DFLUX TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX TOTAL_ION_OUTFLOW
TOTAL_ALFVEN_ION_OUTFLOW TOTAL_UPWARD_ION_OUTFLOW
TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
IDL> max_tags=tag_names(maximus)
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
Maximus.ORBIT is causing us to lose 0 events.
Maximus.TIME is causing us to lose 0 events.
Maximus.ALT is causing us to lose 0 events.
Maximus.MLT is causing us to lose 0 events.
Maximus.ILAT is causing us to lose 0 events.
Maximus.MAG_CURRENT is causing us to lose 0 events.
Maximus.ESA_CURRENT is causing us to lose 0 events.
Maximus.ELEC_ENERGY_FLUX is causing us to lose 0 events.
Maximus.INTEG_ELEC_ENERGY_FLUX is causing us to lose 0 events.
Maximus.CHAR_ELEC_ENERGY is causing us to lose 0 events.
Maximus.ION_ENERGY_FLUX is causing us to lose 0 events.
Maximus.ION_FLUX is causing us to lose 0 events.
Maximus.ION_FLUX_UP is causing us to lose 0 events.
Maximus.INTEG_ION_FLUX is causing us to lose 0 events.
Maximus.INTEG_ION_FLUX_UP is causing us to lose 0 events.
Maximus.CHAR_ION_ENERGY is causing us to lose 89 events.
Maximus.WIDTH_TIME is causing us to lose 0 events.
Maximus.WIDTH_X is causing us to lose 0 events.
Maximus.DELTA_B is causing us to lose 0 events.
Maximus.DELTA_E is causing us to lose 0 events.
Maximus.MODE is causing us to lose 0 events.
Maximus.SAMPLE_T is causing us to lose 0 events.
Maximus.PROTON_FLUX_UP is causing us to lose 0 events.
Maximus.PROTON_ENERGY_FLUX_UP is causing us to lose 0 events.
Maximus.OXY_FLUX_UP is causing us to lose 0 events.
Maximus.OXY_ENERGY_FLUX_UP is causing us to lose 51860 events.
Maximus.HELIUM_FLUX_UP is causing us to lose 0 events.
Maximus.HELIUM_ENERGY_FLUX_UP is causing us to lose 0 events.
Maximus.SC_POT is causing us to lose 0 events.
Maximus.TOTAL_ELECTRON_ENERGY_DFLUX is causing us to lose 0 events.
Maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX is causing us to lose 0 events.
Maximus.TOTAL_ION_OUTFLOW is causing us to lose 0 events.
Maximus.TOTAL_ALFVEN_ION_OUTFLOW is causing us to lose 0 events.
Maximus.TOTAL_UPWARD_ION_OUTFLOW is causing us to lose 0 events.
Maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW is causing us to lose 0 events.
IDL> 
IDL> help,maximus
** Structure <1950668>, 35 tags, length=20508608, data length=20508600, refs=1:
   ORBIT           LONG      Array[134925]
   TIME            STRING    Array[134925]
   ALT             FLOAT     Array[134925]
   MLT             FLOAT     Array[134925]
   ILAT            FLOAT     Array[134925]
   MAG_CURRENT     FLOAT     Array[134925]
   ESA_CURRENT     FLOAT     Array[134925]
   ELEC_ENERGY_FLUX
                   FLOAT     Array[134925]
   INTEG_ELEC_ENERGY_FLUX
                   FLOAT     Array[134925]
   CHAR_ELEC_ENERGY
                   FLOAT     Array[134925]
   ION_ENERGY_FLUX FLOAT     Array[134925]
   ION_FLUX        FLOAT     Array[134925]
   ION_FLUX_UP     FLOAT     Array[134925]
   INTEG_ION_FLUX  FLOAT     Array[134925]
   INTEG_ION_FLUX_UP
                   FLOAT     Array[134925]
   CHAR_ION_ENERGY FLOAT     Array[134925]
                   < Press Spacebar to continue, ? for help > 
   WIDTH_TIME      FLOAT     Array[134925]
   WIDTH_X         FLOAT     Array[134925]
   DELTA_B         FLOAT     Array[134925]
   DELTA_E         FLOAT     Array[134925]
   MODE            FLOAT     Array[134925]
   SAMPLE_T        FLOAT     Array[134925]
   PROTON_FLUX_UP  FLOAT     Array[134925]
   PROTON_ENERGY_FLUX_UP
                   FLOAT     Array[134925]
   OXY_FLUX_UP     FLOAT     Array[134925]
   OXY_ENERGY_FLUX_UP
                   FLOAT     Array[134925]
   HELIUM_FLUX_UP  FLOAT     Array[134925]
   HELIUM_ENERGY_FLUX_UP
                   FLOAT     Array[134925]
   SC_POT          FLOAT     Array[134925]
   TOTAL_ELECTRON_ENERGY_DFLUX
                   FLOAT     Array[134925]
   TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
                   FLOAT     Array[134925]
   TOTAL_ION_OUTFLOW
                   FLOAT     Array[134925]
                   < Press Spacebar to continue, ? for help > 
   TOTAL_ALFVEN_ION_OUTFLOW
                   FLOAT     Array[134925]
   TOTAL_UPWARD_ION_OUTFLOW
                   FLOAT     Array[134925]
   TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
                   FLOAT     Array[134925]
IDL> 
IDL> help,lun
LUN             INT       =       -1
IDL> help,n_events
N_EVENTS        LONG      =       134925
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> help,n_events
N_EVENTS        LONG      =       134925
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.

****From alfven_db_cleaner.pro****
Lost 89 events to NaNs and infinities...
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> print,max_tags
ORBIT TIME ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
INTEG_ELEC_ENERGY_FLUX CHAR_ELEC_ENERGY ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP
INTEG_ION_FLUX INTEG_ION_FLUX_UP CHAR_ION_ENERGY WIDTH_TIME WIDTH_X DELTA_B
DELTA_E MODE SAMPLE_T PROTON_FLUX_UP PROTON_ENERGY_FLUX_UP OXY_FLUX_UP
OXY_ENERGY_FLUX_UP HELIUM_FLUX_UP HELIUM_ENERGY_FLUX_UP SC_POT
TOTAL_ELECTRON_ENERGY_DFLUX TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX TOTAL_ION_OUTFLOW
TOTAL_ALFVEN_ION_OUTFLOW TOTAL_UPWARD_ION_OUTFLOW
TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL>   good_i = cgsetintersection(good_i,where(maximus.char_elec_energy LE max_chare_hcutOff AND maximus.char_elec_energy GT max_chare_lcutoff,/NULL)) 
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
Lost 126465 events to user-defined cutoffs for various quantities...
****END alfven_db_cleaner.pro****

IDL> help,n_elements(good_i)
<Expression>    LONG      =         8371
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
% Tag name ALFVENIC is undefined for structure <Anonymous>.
% Execution halted at: $MAIN$              2 /tmp/idltemp96855b
IDL> n_events=n_elements(maximus.mag_current)
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> help,good_i
GOOD_I          LONG      = Array[134836]
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.

****From alfven_db_cleaner.pro****
Lost 89 events to NaNs and infinities...
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> help,good_i
GOOD_I          LONG      = Array[134810]
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> help,good_i
GOOD_I          LONG      = Array[8400]
IDL> n_events=n_elements(maximus.mag_current)
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> help,good_i
GOOD_I          LONG      = Array[134836]
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
IDL> .run "/tmp/idltemp96855b"
% Compiled module: $MAIN$.
Lost 291 events to user-defined cutoffs for various quantities...
****END alfven_db_cleaner.pro****

IDL> help,good_i
GOOD_I          LONG      = Array[134634]
IDL> good_i=cgsetintersection(good_i,where(abs(maximus.mag_current) GT 10))
IDL> help,good_i
GOOD_I          LONG      = Array[35212]
IDL> 