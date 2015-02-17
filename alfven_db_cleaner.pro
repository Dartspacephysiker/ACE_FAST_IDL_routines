;+
; NAME:                  ALFVEN_DB_CLEANER
;
; PURPOSE:               Get rid of all those nasty NaNs and huge values in various quanitities.
;                        I've been meaning to write such a function for a while. This is finally being precipitated by a
;                        discussion with Professor LaBelle I had while traveling from the MIT Haystack Observatory.
;
; CALLING SEQUENCE:      good_indices = alfven_db_cleaner(maximus)
;
; INPUTS:                Maximus
;
; OUTPUTS:
;
; MODIFICATION HISTORY:  
; 02/14/2015 Born  
;; Note, there are also several bad measurements of TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,
;;   TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX, TOTAL_ION_OUTFLOW_MULTIPLE_TOT, TOTAL_ALFVEN_ION_OUTFLOW, 
;;   TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT, TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
;; I never use these quantities, so I'm ignoring their NaNs.
;
;-

function alfven_db_cleaner,maximus,LUN=lun

  ;;If not lun, just send to stdout
  IF NOT KEYWORD_SET(lun) THEN lun = -1

  ;;First make sure maximus is present
  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     printf,lun,"No such structure as maximus! Can't clean up Alfven database."
     printf,lun,"Returning..."
     RETURN, !NULL
  ENDIF

  ;number of events in total
  n_events = n_elements(maximus.alfvenic)

  ; Cutoff values
  
  ;; mag current cutoffs
  magc_hcutOff = 5.0e2            ;junks 245 events above, 256 below
  ;;magc_lcutOff = -1.0e3 ;
  
  ;; delta_B cutoffs
  dB_hcutOff = 1.0e3            ;junks 190 events
  dB_lcutOff = -1.0e3 ;
  ;;  dB_lcutOff = 0.0 ; Below zero should be garbage?
  
  ;; delta_E cutoffs
  dE_hcutoff = 1.0e4            ;junks 328 events
  dE_lcutoff = -1.0e4
  ;; dE_lcutoff = 0.0              ; Below zero should be garbage?
  
  ;; losscone electron flux cutoffs
  ef_lc_integ_hcutoff = 1.0e7   ;junks 191 events
  ef_lc_integ_lcutoff = -1.0e7
  
  ;; electron energy flux cutoffs
  elec_ef_hcutoff = 1.0e3       ;junks 284 events
  elec_ef_lcutoff = 0.0         ;because less than zero is garbage, right?
  
  ;; max characteristic electron energy cutoffs
  max_chare_hcutoff = 1.5e4     ;junks 120 events
  max_chare_lcutoff = 0.0       ;less than zero must be garbage
  
  ;; ion flux cutoffs
  iflux_hcutoff = 5.0e10        ;junks 122 events
  iflux_lcutoff = -5.0e10       ;junks something like 100 events
  
  ;; ion energy flux cutoffs
  ieflux_hcutoff = 1.0e1        ;cuts off 209 events
  ieflux_lcutoff = 0.0          ;below zero is junk, eh?
  
  ;; upward ion flux cutoffs
  iflux_up_hcutoff = 7.0e10     ;cuts off 286 events
  iflux_up_lcutoff = 0.0        ;below zero is junk, eh?
  
  ;; characteristic ion energy cutoffs
  char_ion_e_hcutoff = 250.0    ;cuts off 237 events
  char_ion_e_lcutoff = 0.0      ;below zero is junk, eh?
  
  ;**********
  ;   NaNs  *
  ;**********

  ;; Get rid of junk in various dangerous quantities we might be using
  
  ;; delta Bs and delta Es
  good_i = WHERE(FINITE(maximus.delta_B),/NULL)
  good_i = cgsetintersection(good_i,where(FINITE(maximus.delta_E),/NULL))
  
  ;; Now electron stuff
  good_i = cgsetintersection(good_i,where(FINITE(maximus.elec_energy_flux),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.integ_elec_energy_flux),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.eflux_losscone_integ),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.total_eflux_integ),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.max_chare_losscone),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.max_chare_total),/NULL))

  ;; Now ion stuff
  good_i = cgsetintersection(good_i,where(FINITE(maximus.ion_energy_flux),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.ion_flux),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.ion_flux_up),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.integ_ion_flux),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.integ_ion_flux_up),/NULL))
  good_i = cgsetintersection(good_i,where(FINITE(maximus.char_ion_energy),/NULL))


  printf,lun,""
  printf,lun,"****From alfven_db_cleaner.pro****"

  nlost = n_events-n_elements(good_i)
  printf,lun,"Lost " + strcompress(nlost,/REMOVE_ALL) + " events to NaNs and infinities..."
  n_events -=nlost
  
  ;******************
  ;   Other limits  *
  ;******************
  
  ;No delta_Bs above any absurd values
  good_i = cgsetintersection(good_i,where(abs(maximus.mag_current) LE magc_hcutOff,/NULL))

  ;No delta_Bs above any absurd values
  good_i = cgsetintersection(good_i,where(maximus.delta_b LE dB_hcutOff AND maximus.delta_b GT dB_lcutoff,/NULL))

  ;No delta_Es above any absurd values
  good_i = cgsetintersection(good_i,where(maximus.delta_e LE dE_hcutOff AND maximus.delta_e GT dE_lcutoff,/NULL))

  ;No losscone e- fluxes with any absurd values
  good_i = cgsetintersection(good_i,where(maximus.eflux_losscone_integ LE ef_lc_integ_hcutOff AND maximus.eflux_losscone_integ GT ef_lc_integ_lcutoff,/NULL))
  ;No absurd electron energy fluxes
  good_i = cgsetintersection(good_i,where(maximus.elec_energy_flux LE elec_ef_hcutOff AND maximus.elec_energy_flux GT elec_ef_lcutoff,/NULL)) 

  ;No absurd characteristic electron energies
  good_i = cgsetintersection(good_i,where(maximus.max_chare_losscone LE max_chare_hcutOff AND maximus.max_chare_losscone GT max_chare_lcutoff,/NULL)) 
  
  ;No absurd ion fluxes
  good_i = cgsetintersection(good_i,where(maximus.ion_flux LE iflux_hcutOff AND maximus.ion_flux GT iflux_lcutoff,/NULL)) 

  ;No weird ion energy fluxes
  good_i = cgsetintersection(good_i,where(maximus.ion_energy_flux LE ieflux_hcutOff AND maximus.ion_energy_flux GT ieflux_lcutoff,/NULL)) 

  ;No wonky upward ion fluxes
  good_i = cgsetintersection(good_i,where(maximus.ion_flux_up LE iflux_up_hcutOff AND maximus.ion_flux_up GT iflux_up_lcutoff,/NULL)) 

  ;No weird characteristic ion energies
  good_i = cgsetintersection(good_i,where(maximus.char_ion_energy LE char_ion_e_hcutOff AND maximus.char_ion_energy GT char_ion_e_lcutoff,/NULL)) 

  ;; for i=0,n_elements(max_tags)-1 do begin
  ;;    nkept=n_elements(where(FINITE(maximus.(i)),NCOMPLEMENT=nlost))
  ;;    printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." 
  ;; endfor

  nlost = n_events-n_elements(good_i)
  printf,lun,"Lost " + strcompress(nlost,/REMOVE_ALL) + " events to user-defined cutoffs for various quantities..."

  printf,lun,"****END alfven_db_cleaner.pro****"
  printf,lun,""

  RETURN, good_i

end

;; ORBIT ALFVENIC TIME ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
;; INTEG_ELEC_ENERGY_FLUX EFLUX_LOSSCONE_INTEG TOTAL_EFLUX_INTEG MAX_CHARE_LOSSCONE
;; MAX_CHARE_TOTAL ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP INTEG_ION_FLUX
;; INTEG_ION_FLUX_UP CHAR_ION_ENERGY WIDTH_TIME WIDTH_X DELTA_B DELTA_E SAMPLE_T
;; MODE PROTON_FLUX_UP PROTON_CHAR_ENERGY OXY_FLUX_UP OXY_CHAR_ENERGY
;; HELIUM_FLUX_UP HELIUM_CHAR_ENERGY SC_POT L_PROBE MAX_L_PROBE MIN_L_PROBE
;; MEDIAN_L_PROBE TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE
;; TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
;; TOTAL_ION_OUTFLOW_SINGLE TOTAL_ION_OUTFLOW_MULTIPLE_TOT TOTAL_ALFVEN_ION_OUTFLOW
;; TOTAL_UPWARD_ION_OUTFLOW_SINGLE TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;; TOTAL_ALFVEN_UPWARD_ION_OUTFLOW


;; for i=0,n_elements(max_tags)-1 do begin & $
;; IDL> nkept=n_elements(where(FINITE(maximus.(i)),NCOMPLEMENT=nlost)) & $
;; IDL> printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." & $
;; IDL> endfor
;; Maximus.ORBIT is causing us to lose 0 events.
;; Maximus.ALFVENIC is causing us to lose 0 events.
;; Maximus.TIME is causing us to lose 0 events.
;; Maximus.ALT is causing us to lose 0 events.
;; Maximus.MLT is causing us to lose 0 events.
;; Maximus.ILAT is causing us to lose 0 events.
;; Maximus.MAG_CURRENT is causing us to lose 0 events.
;; Maximus.ESA_CURRENT is causing us to lose 0 events.
;; Maximus.ELEC_ENERGY_FLUX is causing us to lose 1 events.
;; Maximus.INTEG_ELEC_ENERGY_FLUX is causing us to lose 0 events.
;; Maximus.EFLUX_LOSSCONE_INTEG is causing us to lose 903 events.
;; Maximus.TOTAL_EFLUX_INTEG is causing us to lose 903 events.
;; Maximus.MAX_CHARE_LOSSCONE is causing us to lose 2 events.
;; Maximus.MAX_CHARE_TOTAL is causing us to lose 0 events.
;; Maximus.ION_ENERGY_FLUX is causing us to lose 0 events.
;; Maximus.ION_FLUX is causing us to lose 45 events.
;; Maximus.ION_FLUX_UP is causing us to lose 0 events.
;; Maximus.INTEG_ION_FLUX is causing us to lose 956 events.
;; Maximus.INTEG_ION_FLUX_UP is causing us to lose 956 events.
;; Maximus.CHAR_ION_ENERGY is causing us to lose 228 events.
;; Maximus.WIDTH_TIME is causing us to lose 0 events.
;; Maximus.WIDTH_X is causing us to lose 0 events.
;; Maximus.DELTA_B is causing us to lose 0 events.
;; Maximus.DELTA_E is causing us to lose 22890 events.
;; Maximus.SAMPLE_T is causing us to lose 0 events.
;; Maximus.MODE is causing us to lose 0 events.
;; Maximus.PROTON_FLUX_UP is causing us to lose 0 events.
;; Maximus.PROTON_CHAR_ENERGY is causing us to lose 0 events.
;; Maximus.OXY_FLUX_UP is causing us to lose 0 events.
;; Maximus.OXY_CHAR_ENERGY is causing us to lose 0 events.
;; Maximus.HELIUM_FLUX_UP is causing us to lose 0 events.
;; Maximus.HELIUM_CHAR_ENERGY is causing us to lose 0 events.
;; Maximus.SC_POT is causing us to lose 0 events.
;; Maximus.L_PROBE is causing us to lose 0 events.
;; Maximus.MAX_L_PROBE is causing us to lose 733774 events.
;; Maximus.MIN_L_PROBE is causing us to lose 733774 events.
;; Maximus.MEDIAN_L_PROBE is causing us to lose 733773 events.
;; Maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE is causing us to lose 0 events.
;; Maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT is causing us to lose 60446 events.
;; Maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX is causing us to lose 10245 events.
;; Maximus.TOTAL_ION_OUTFLOW_SINGLE is causing us to lose 0 events.
;; Maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT is causing us to lose 67864 events.
;; Maximus.TOTAL_ALFVEN_ION_OUTFLOW is causing us to lose 10039 events.
;; Maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE is causing us to lose 0 events.
;; Maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT is causing us to lose 67864 events.
;; Maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW is causing us to lose 10039 events.