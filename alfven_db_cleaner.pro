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
; 2015/08/19    A bunch of limits got changed yesterday. I think I include more extreme events, but based on the distributions of the
;                 relevant quantities, they don't seem to be physically unreasonable.
; 2015/08/18    Thought about adding specific keyword so that ChastDB gets treated on its own each time.

; 02/14/2015 Born  
;; Note, there are also several bad measurements of TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,
;;   TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX, TOTAL_ION_OUTFLOW_MULTIPLE_TOT, TOTAL_ALFVEN_ION_OUTFLOW, 
;;   TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT, TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
;; I never use these quantities, so I'm ignoring their NaNs.
; 
; 
;-

function alfven_db_cleaner,maximus,IS_CHASTDB=is_chastDB,LUN=lun

  ;;If not lun, just send to stdout
  IF NOT KEYWORD_SET(lun) THEN lun = -1

  ;;First make sure maximus is present
  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     printf,lun,"No such structure as maximus! Can't clean up Alfven database."
     printf,lun,"Returning..."
     ;; RETURN, !NULL
     RETURN, !NULL
  ENDIF


  ;; mag current cutoffs
  magc_hcutOff = 5.0e2          ;junks 245 events above, 256 below
  magc_hcutOff = 8.0e2
  ;; magc_lcutOff = -1.0e3 ;
  
  ;; delta_B cutoffs
  dB_hcutOff = 1.0e3            ;junks 190 events
  dB_lcutOff = -1.0e3 ;
  ;;  dB_lcutOff = 0.0 ; Below zero should be garbage?
  
  ;; delta_E cutoffs
  dE_hcutoff = 1.0e4            ;junks 328 events
  dE_lcutoff = -1.0e4
  ;; dE_lcutoff = 0.0              ; Below zero should be garbage?
  
  ;; losscone electron flux cutoffs
  ;; ef_lc_integ_hcutoff = 1.0e7   ;junks 191 events
  ;; ef_lc_integ_lcutoff = -1.0e7
  ef_lc_integ_hcutoff = 1.0e9   ;junks 191 events
  ef_lc_integ_lcutoff = -1.0e9
  
  ;; electron energy flux cutoffs
  ;; 2015/08/19
  ;; NOTE: For Dartmouth DBs, 'maximus.elec_energy_flux' only takes on absurd values for elec_energy_flux < 0
  ;; However, in the original Chaston DB, 'maximus.elec_energy_flux' takes on perfectly reasonable values and has a reasonable
  ;; distribution for elec_energy_flux < 0, generally ABS(maximus.elec_energy_flux) in ChastDB is < 10^2.
  elec_ef_hcutoff = 1.0e3       ;junks 284 events. NOTE, units are ergs-cm^(-2)-s^(-1). 
                                ;1e3 ergs corresponds to ~6x10^14 eV, and Nakajima et al. [2008]
                                ;  call FAST observations of eflux > 10^12 eV-cm^(-2)-s^(-1)
                                ;  "remarkable"; in short this cutoff gives plenty of room for good data.
  elec_ef_lcutoff = 0.0         ;because less than zero is garbage, right?
  
  ;; max characteristic electron energy cutoffs
  max_chare_hcutoff = 2.0e4
  max_chare_lcutoff = 0.0  
  
  ;; ion flux cutoffs
  iflux_hcutoff = 8.0e11
  iflux_lcutoff = -8.0e11
  
  ;; ion energy flux cutoffs
  ieflux_hcutoff = 5.0e1
  ieflux_lcutoff = 0.0          ;below zero is junk, eh?
  
  ;; upward ion flux cutoffs
  iflux_up_hcutoff = 1.0e11
  iflux_up_lcutoff = 0.0   
  
  ;; characteristic ion energy cutoffs
  char_ion_e_hcutoff = 1.0e4
  char_ion_e_lcutoff = 1.0e-2  
  
  ;; cutoffs for sample_t, fields instrument
  ;; 512 Hz
  ;; sample_t_hcutoff = 0.0023
  ;; sample_t_lcutoff = 0.0014

  ;; 128 Hz
  ;; sample_t_hcutoff = 0.009
  ;; sample_t_lcutoff = 0.007

  ;; 32 Hz
  ;; sample_t_hcutoff = 0.033
  ;; sample_t_lcutoff = 0.029

  ;; 8 Hz
  ;; sample_t_hcutoff = 0.120
  ;; sample_t_lcutoff = 0.030

  ;; < 0.8 Hz, which is too small
  ;; sample_t_hcutoff = 1.25

  ;; < 100 Hz—exclude all of these per meeting with Professor LaBelle 2015/05/28
  ;; sample_t_hcutoff = 0.01

  ;; Keep all with sample rate > 5 Hz, which is good (I hope)
  sample_t_hcutoff = 0.2
  
  ;**********
  ;   NaNs  *
  ;**********

  IF ~KEYWORD_SET(IS_CHASTDB) THEN BEGIN
     ;; Get rid of junk in various dangerous quantities we might be using
     
     ;;number of events in total
     n_events = n_elements(maximus.alfvenic)
     
     ;; Cutoff values
  
     ;;Gots to be alfvenic
     alfvenic=1

     ;; alfvenicness
     good_i = where(maximus.alfvenic GT 0.1,/NULL )
     
     ;; delta Bs and delta Es
     good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.delta_B),/NULL))
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
     
  ENDIF ELSE BEGIN

     n_events = n_ELEMENTS(maximus.time)
     ;; delta Bs and delta Es
     good_i = indgen(n_events,/L64)
     good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.delta_B),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.delta_E),/NULL))
     
     ;; Now electron stuff
     good_i = cgsetintersection(good_i,where(FINITE(maximus.elec_energy_flux),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.integ_elec_energy_flux),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.char_elec_energy),/NULL))
     
     ;; Now ion stuff
     good_i = cgsetintersection(good_i,where(FINITE(maximus.ion_energy_flux),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.ion_flux),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.ion_flux_up),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.integ_ion_flux),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.integ_ion_flux_up),/NULL))
     good_i = cgsetintersection(good_i,where(FINITE(maximus.char_ion_energy),/NULL))

  ENDELSE 

  printf,lun,""
  printf,lun,"****From alfven_db_cleaner.pro****"

  nlost = n_events-n_elements(good_i)
  printf,lun,"Lost " + strcompress(nlost,/REMOVE_ALL) + " events to NaNs and infinities..."
  n_events -=nlost
  
  ;******************
  ;   Other limits  *
  ;******************
  
  IF ~KEYWORD_SET(is_chastDB) THEN BEGIN
     ;;No delta_Bs above any absurd values
     good_i = cgsetintersection(good_i,where(abs(maximus.mag_current) LE magc_hcutOff,/NULL))
   
     ;;No delta_Bs above any absurd values
     good_i = cgsetintersection(good_i,where(maximus.delta_b LE dB_hcutOff AND maximus.delta_b GT dB_lcutoff,/NULL))
     
     ;;No delta_Es above any absurd values
     good_i = cgsetintersection(good_i,where(maximus.delta_e LE dE_hcutOff AND maximus.delta_e GT dE_lcutoff,/NULL))

     ;;No losscone e- fluxes with any absurd values
     good_i = cgsetintersection(good_i,where(maximus.eflux_losscone_integ LE ef_lc_integ_hcutOff AND maximus.eflux_losscone_integ GT ef_lc_integ_lcutoff,/NULL))
     ;;No absurd electron energy fluxes ;At least for the dartDBs, negative values are absurd (like 10^-8, 10^-9--total garbage)
     ;; good_i = cgsetintersection(good_i,where(maximus.elec_energy_flux LE elec_ef_hcutOff AND maximus.elec_energy_flux GT elec_ef_lcutoff,/NULL)) 
     good_i = cgsetintersection(good_i,where(maximus.elec_energy_flux LE elec_ef_hcutOff AND maximus.elec_energy_flux GT elec_ef_lcutoff,/NULL)) 

     ;;No absurd characteristic electron energies
     good_i = cgsetintersection(good_i,where(maximus.max_chare_losscone LE max_chare_hcutOff AND maximus.max_chare_losscone GT max_chare_lcutoff,/NULL)) 
  
     ;;No absurd ion fluxes
     good_i = cgsetintersection(good_i,where(maximus.ion_flux LE iflux_hcutOff AND maximus.ion_flux GT iflux_lcutoff,/NULL)) 

     ;;No weird ion energy fluxes
     good_i = cgsetintersection(good_i,where(maximus.ion_energy_flux LE ieflux_hcutOff AND maximus.ion_energy_flux GT ieflux_lcutoff,/NULL)) 

     ;;No wonky upward ion fluxes
     good_i = cgsetintersection(good_i,where(maximus.ion_flux_up LE iflux_up_hcutOff AND maximus.ion_flux_up GT iflux_up_lcutoff,/NULL)) 

     ;;No weird characteristic ion energies
     good_i = cgsetintersection(good_i,where(ABS(maximus.char_ion_energy) LE char_ion_e_hcutOff AND ABS(maximus.char_ion_energy) GT char_ion_e_lcutoff,/NULL)) 

     ;; Now sample_t stuff
     good_i = cgsetintersection(good_i,where(maximus.sample_t LE sample_t_hcutoff,/NULL))
  ;; good_i = cgsetintersection(good_i,where(maximus.sample_t GE sample_t_lcutoff,/NULL))

  ;; for i=0,n_elements(max_tags)-1 do begin
  ;;    nkept=n_elements(where(FINITE(maximus.(i)),NCOMPLEMENT=nlost))
  ;;    printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." 
  ;; endfor

  ENDIF ELSE BEGIN

     ;;No currents above any absurd values
     good_i = cgsetintersection(good_i,where(abs(maximus.mag_current) LE magc_hcutOff,/NULL))
   
     ;;No delta_Bs above any absurd values
     good_i = cgsetintersection(good_i,where(maximus.delta_b LE dB_hcutOff AND maximus.delta_b GT dB_lcutoff,/NULL))
     
     ;;No delta_Es above any absurd values
     good_i = cgsetintersection(good_i,where(maximus.delta_e LE dE_hcutOff AND maximus.delta_e GT dE_lcutoff,/NULL))

     ;;No losscone e- fluxes with any absurd values
     ;; good_i = cgsetintersection(good_i,where(maximus.integ_elec_energy_flux LE ef_lc_integ_hcutOff AND maximus.integ_elec_energy_flux GT ef_lc_integ_lcutoff,/NULL))
     good_i = cgsetintersection(good_i,where(ABS(maximus.integ_elec_energy_flux) LE ef_lc_integ_hcutOff,/NULL))

     ;;No absurd electron energy fluxes
     ;; good_i = cgsetintersection(good_i,where(maximus.elec_energy_flux LE elec_ef_hcutOff AND maximus.elec_energy_flux GT elec_ef_lcutoff,/NULL)) 
     good_i = cgsetintersection(good_i,where(ABS(maximus.elec_energy_flux) LE elec_ef_hcutOff,/NULL)) 

     ;;No absurd characteristic electron energies
     good_i = cgsetintersection(good_i,where(maximus.char_elec_energy LE max_chare_hcutOff AND maximus.char_elec_energy GT max_chare_lcutoff,/NULL)) 
  
     ;;No absurd ion fluxes
     good_i = cgsetintersection(good_i,where(maximus.ion_flux LE iflux_hcutOff AND maximus.ion_flux GT iflux_lcutoff,/NULL)) 

     ;;No weird ion energy fluxes
     good_i = cgsetintersection(good_i,where(maximus.ion_energy_flux LE ieflux_hcutOff AND maximus.ion_energy_flux GT ieflux_lcutoff,/NULL)) 

     ;;No wonky upward ion fluxes
     good_i = cgsetintersection(good_i,where(maximus.ion_flux_up LE iflux_up_hcutOff AND maximus.ion_flux_up GT iflux_up_lcutoff,/NULL)) 

     ;;No weird characteristic ion energies
     good_i = cgsetintersection(good_i,where(maximus.char_ion_energy LE char_ion_e_hcutOff AND maximus.char_ion_energy GT char_ion_e_lcutoff,/NULL)) 

     ;; Now sample_t stuff
     ;;This is screwed up in the original DB; MODE = SAMPLE_T and SAMPLE_T = MODE
     good_i = cgsetintersection(good_i,where(maximus.mode LE sample_t_hcutoff,/NULL))
  ;; good_i = cgsetintersection(good_i,where(maximus.sample_t GE sample_t_lcutoff,/NULL))

  ;; for i=0,n_elements(max_tags)-1 do begin
  ;;    nkept=n_elements(where(FINITE(maximus.(i)),NCOMPLEMENT=nlost))
  ;;    printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." 
  ;; endfor

  ENDELSE

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
;;     nkept=n_elements(where(FINITE(maximus.(i)),NCOMPLEMENT=nlost)) & $
;;     printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." & $
;; endfor
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

;; max_tags=tag_names(maximus)
;; for i=0,n_elements(max_tags)-1 do begin 
;;    nkept=n_elements(where(FINITE(maximus.(i)),NCOMPLEMENT=nlost)) 
;;    printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." 
;; endfor