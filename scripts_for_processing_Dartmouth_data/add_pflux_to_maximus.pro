PRO add_pflux_to_maximus,maximus

                   maximus={orbit:maximus.orbit,$
                            alfvenic:maximus.alfvenic,$
                            TIME:maximus.time,$
                            ALT:maximus.alt,$
                            MLT:maximus.mlt,$
                            ILAT:maximus.ilat,$
                            MAG_CURRENT:maximus.MAG_CURRENT,$
                            ESA_CURRENT:maximus.ESA_CURRENT,$
                            ELEC_ENERGY_FLUX:maximus.ELEC_ENERGY_FLUX,$
                            INTEG_ELEC_ENERGY_FLUX:maximus.INTEG_ELEC_ENERGY_FLUX,$
                            EFLUX_LOSSCONE_INTEG:maximus.EFLUX_LOSSCONE_INTEG,$
                            total_eflux_integ:maximus.total_eflux_integ,$
                            max_chare_losscone:maximus.max_chare_losscone,$
                            max_chare_total:maximus.max_chare_total,$
                            ION_ENERGY_FLUX:maximus.ION_ENERGY_FLUX,$
                            ION_FLUX:maximus.ION_FLUX,$
                            ION_FLUX_UP:maximus.ION_FLUX_UP,$
                            INTEG_ION_FLUX:maximus.INTEG_ION_FLUX,$
                            INTEG_ION_FLUX_UP:maximus.INTEG_ION_FLUX_UP,$
                            CHAR_ION_ENERGY:maximus.CHAR_ION_ENERGY,$
                            WIDTH_TIME:maximus.WIDTH_TIME,$
                            WIDTH_X:maximus.WIDTH_X,$
                            DELTA_B:maximus.DELTA_B,$
                            DELTA_E:maximus.DELTA_E,$
                            SAMPLE_T:maximus.SAMPLE_T,$
                            MODE:maximus.MODE,$
                            PROTON_FLUX_UP:maximus.PROTON_FLUX_UP,$
                            PROTON_CHAR_ENERGY:maximus.PROTON_CHAR_ENERGY,$
                            OXY_FLUX_UP:maximus.OXY_FLUX_UP,$
                            OXY_CHAR_ENERGY:maximus.OXY_CHAR_ENERGY,$
                            HELIUM_FLUX_UP:maximus.HELIUM_FLUX_UP,$
                            HELIUM_CHAR_ENERGY:maximus.HELIUM_CHAR_ENERGY,$
                            SC_POT:maximus.SC_POT,$
                            L_PROBE:maximus.L_PROBE,$
                            MAX_L_PROBE:maximus.MAX_L_PROBE,$
                            MIN_L_PROBE:maximus.MIN_L_PROBE,$
                            MEDIAN_L_PROBE:maximus.MEDIAN_L_PROBE,$
                            START_TIME:maximus.START_TIME,$
                            STOP_TIME:maximus.STOP_TIME,$
                            TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,$
                            TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,$
                            TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,$
                            TOTAL_ION_OUTFLOW_SINGLE:maximus.TOTAL_ION_OUTFLOW_SINGLE,$
                            TOTAL_ION_OUTFLOW_MULTIPLE_TOT:maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT,$
                            TOTAL_ALFVEN_ION_OUTFLOW:maximus.TOTAL_ALFVEN_ION_OUTFLOW,$
                            TOTAL_UPWARD_ION_OUTFLOW_SINGLE:maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE,$
                            TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,$
                            TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW, $
                            PFLUXEST:maximus.delta_e*maximus.delta_b * 1.0e-9 / (4.0e-7 * !PI)}




END

