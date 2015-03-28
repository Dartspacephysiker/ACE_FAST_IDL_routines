; The purpose of this file is just what you'd expect--we want to resize maximus based on some stuff

;names of output files
cleanDBFile="Dartdb_02282015--500-14999--maximus--cleaned.sav"
cleanCdbTimeFile="Dartdb_02282015--500-14999--cdbTime--cleaned.sav" ;data prod is named cdbTime

;restore the DB in question
dbFile="Dartdb_02282015--500-14999--maximus.sav"
cdbTimeFile="Dartdb_02282015--500-14999--cdbTime.sav" ;data prod is named cdbTime

restore,dBfile
restore,cdbTimeFile

;Now, with maximus and cdbTime in hand...
;file containing cleaned indices (name of indices arr should be "clean_i")
cleanFile="../cleaned_indices_for_02282015_DB.sav"
restore,cleanFile

;Don't want any nasty non-Alfven waves in our database
ostracized_i=where(~maximus.alfvenic)
clean_i = cgsetdifference(clean_i,ostracized_i)

;cdbTime is easy
cdbTime = cdbTime(clean_i)
save,cdbTime,filename=cleanCdbTimeFile

;maximus is harder
maximus={orbit:maximus.orbit(clean_i),$
         alfvenic:maximus.alfvenic(clean_i),$
         TIME:maximus.time(clean_i),$
         ALT:maximus.alt(clean_i),$
         MLT:maximus.mlt(clean_i),$
         ILAT:maximus.ilat(clean_i),$
         MAG_CURRENT:maximus.MAG_CURRENT(clean_i),$
         ESA_CURRENT:maximus.ESA_CURRENT(clean_i),$
         ELEC_ENERGY_FLUX:maximus.ELEC_ENERGY_FLUX(clean_i),$
         INTEG_ELEC_ENERGY_FLUX:maximus.INTEG_ELEC_ENERGY_FLUX(clean_i),$
         EFLUX_LOSSCONE_INTEG:maximus.EFLUX_LOSSCONE_INTEG(clean_i),$
         total_eflux_integ:maximus.total_eflux_integ(clean_i),$
         max_chare_losscone:maximus.max_chare_losscone(clean_i),$
         max_chare_total:maximus.max_chare_total(clean_i),$
         ION_ENERGY_FLUX:maximus.ION_ENERGY_FLUX(clean_i),$
         ION_FLUX:maximus.ION_FLUX(clean_i),$
         ION_FLUX_UP:maximus.ION_FLUX_UP(clean_i),$
         INTEG_ION_FLUX:maximus.INTEG_ION_FLUX(clean_i),$
         INTEG_ION_FLUX_UP:maximus.INTEG_ION_FLUX_UP(clean_i),$
         CHAR_ION_ENERGY:maximus.CHAR_ION_ENERGY(clean_i),$
         WIDTH_TIME:maximus.WIDTH_TIME(clean_i),$
         WIDTH_X:maximus.WIDTH_X(clean_i),$
         DELTA_B:maximus.DELTA_B(clean_i),$
         DELTA_E:maximus.DELTA_E(clean_i),$
         SAMPLE_T:maximus.SAMPLE_T(clean_i),$
         MODE:maximus.MODE(clean_i),$
         PROTON_FLUX_UP:maximus.PROTON_FLUX_UP(clean_i),$
         PROTON_CHAR_ENERGY:maximus.PROTON_CHAR_ENERGY(clean_i),$
         OXY_FLUX_UP:maximus.OXY_FLUX_UP(clean_i),$
         OXY_CHAR_ENERGY:maximus.OXY_CHAR_ENERGY(clean_i),$
         HELIUM_FLUX_UP:maximus.HELIUM_FLUX_UP(clean_i),$
         HELIUM_CHAR_ENERGY:maximus.HELIUM_CHAR_ENERGY(clean_i),$
         SC_POT:maximus.SC_POT(clean_i),$
         L_PROBE:maximus.L_PROBE(clean_i),$
         MAX_L_PROBE:maximus.MAX_L_PROBE(clean_i),$
         MIN_L_PROBE:maximus.MIN_L_PROBE(clean_i),$
         MEDIAN_L_PROBE:maximus.MEDIAN_L_PROBE(clean_i),$
         START_TIME:maximus.START_TIME(clean_i),$
         STOP_TIME:maximus.STOP_TIME(clean_i),$
         TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE(clean_i),$
         TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT(clean_i),$
         TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX(clean_i),$
         TOTAL_ION_OUTFLOW_SINGLE:maximus.TOTAL_ION_OUTFLOW_SINGLE(clean_i),$
         TOTAL_ION_OUTFLOW_MULTIPLE_TOT:maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT(clean_i),$
         TOTAL_ALFVEN_ION_OUTFLOW:maximus.TOTAL_ALFVEN_ION_OUTFLOW(clean_i),$
         TOTAL_UPWARD_ION_OUTFLOW_SINGLE:maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE(clean_i),$
         TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT(clean_i),$
         TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW(clean_i),$
         PFLUXEST:maximus.delta_b(clean_i)*maximus.delta_e(clean_i)*4.0e-7*!PI}

save,maximus,filename=cleanDBFile
