; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST
; Date: Thu Jun  4 09:42:03 2015
 
restore,'plot_indices_saves/PLOT_INDICES_20150604_dawnward_inds_for_KS_analysis--6-18MLTNorth_dawnward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'
restore,dbfile
plot_i_duskward=plot_i
plot_i_dawnward=plot_i
restore,'plot_indices_saves/PLOT_INDICES_20150604_duskward_inds_for_KS_analysis--6-18MLTNorth_dawnward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'
; % RESTORE: Error opening file. Unit: 101
;            File: plot_indices_saves/PLOT_INDICES_20150604_duskward_inds_for_K
;            S_analysis--6-18MLTNorth_dawnward--0stable--OMNI_GSM_byMin_5.0_Jun
;            _4_15.sav
;   No such file or directory
restore,'plot_indices_saves/PLOT_INDICES_20150604_duskward_inds_for_KS_analysis--6-18MLTNorth_duskward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'
plot_i_duskward=plot_i
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
restore,'plot_indices_saves/PLOT_INDICES_20150604_allIMF_inds_for_KS_analysis--6-18MLTNorth_all_IMF--0stable--OMNI_GSM_Jun_4_15.sav'
plot_i_allIMF=plot_i
kstwo,maximus.mlt(plot_i_dawnward),maximus.mlt(plot_i_duskward),D_dawndusk,prob_dawndusk
kstwo,maximus.mlt(plot_i_allIMF),maximus.mlt(plot_i_dawnward),D_allIMF_dawn,prob_allIMF_dawn
; % Program caused arithmetic error: Floating underflow
kstwo,maximus.mlt(plot_i_allIMF),maximus.mlt(plot_i_duskward),D_allIMF_dusk,prob_allIMF_dusk
; % Program caused arithmetic error: Floating underflow
print,D_allIMF_dusk
;    0.0514092
print,prob_allIMF_dusk
;  1.79421e-19
print,D_allIMF_dawn
;    0.0590220
print,prob_allIMF_dawn
;  4.08495e-26
print,D_dawndusk
;    0.0355497
print,prob_dawndusk
;  1.50543e-05
help,n_Elements(plot_i_allIMF)
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
restore,'/SPENCEdata/Research/database/FAST/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'
print,tag_names(maximus)
;ORBIT ALFVENIC TIME ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
;INTEG_ELEC_ENERGY_FLUX EFLUX_LOSSCONE_INTEG TOTAL_EFLUX_INTEG MAX_CHARE_LOSSCONE
;MAX_CHARE_TOTAL ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP INTEG_ION_FLUX
;INTEG_ION_FLUX_UP CHAR_ION_ENERGY WIDTH_TIME WIDTH_X DELTA_B DELTA_E SAMPLE_T
;MODE PROTON_FLUX_UP PROTON_CHAR_ENERGY OXY_FLUX_UP OXY_CHAR_ENERGY
;HELIUM_FLUX_UP HELIUM_CHAR_ENERGY SC_POT L_PROBE MAX_L_PROBE MIN_L_PROBE
;MEDIAN_L_PROBE START_TIME STOP_TIME TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE
;TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
;TOTAL_ION_OUTFLOW_SINGLE TOTAL_ION_OUTFLOW_MULTIPLE_TOT TOTAL_ALFVEN_ION_OUTFLOW
;TOTAL_UPWARD_ION_OUTFLOW_SINGLE TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
print,maximus.(4)()
; % Syntax error.
print,maximus.(4)(0)
;      21.3089
print,maximus.(4)(1)
;      21.2759
print,maximus.(4)(2)
;      21.2632
print,maximus.MLT(2)
;      21.2632
.run "/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/JOURNAL__20150604__boxplots_for_allIMF_dawn_dusk_nevents.pro"
help,/breakpoints
.run "/tmp/idltemp23802-PH"
save,'idlwave_print_safe','idlwave_routine_info','idlwave_print_info_entry','idlwave_get_class_tags','idlwave_get_sysvars',FILE='/tmp/idltemp23802NeN',/ROUTINES
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0