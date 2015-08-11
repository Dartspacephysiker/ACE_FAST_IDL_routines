;;2015/08/10

;;Newell et al. [2009] make me feel very much that I should expect the cusp to light up when viewed in terms of electron number
;;flux and ion number flux, but that I will _not_ see it light up when viewing in terms of energy fluxes. Hence, I'm
;;calculating the electron number flux from characteristic energy based on what I see in Alfven_stats_5, which follows below.

;; *****A WARNING ON THE USEFULNESS OF THIS CALCULATION!********
;; alfven_stats_5 ends up selecting the LARGEST energy flux over a given Alfven wave interval, which does not have any necessary
;;correspondence with largest number flux. We can only hope, that's all.

;; ***THIS COULD BE A FARCE***
;; Note that maximus already includes an eflux_losscone_integ and total_eflux_integ, which are just the summed-up number fluxes
;;over the time interval during which each Alfven wave is observed. FURTHERMORE, note that maxJe in alfven_stats_5 is merely the
;;max electron number flux, in microA/m^2. So max number flux for each event can be obtained, truly truly, by doing this:
;; microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9, which will give back maxJe, the max observed number flux, in #/cm^2
;; elec_num_flux = maximus.esa_current 

;; ***WHAT ABOUT UNITS??***
;; The deal is this: je_2d_b returns #/cm^2. If esa_current is in units of microA/m^2, then the appropriate conversion will be
;;1/1.6e-9, as given above for microCoul_per_m2__to_num_per_cm2.

  ;;*From alfven_stats_5*

  ;; ; GET ELECTRON ENERGY FLUX, JEE, AND CLEAN IT UP

  ;; get_2dt_ts_pot,'je_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1), $
  ;;                name='JEe',angle=e_angle,energy=energy_electrons,sc_pot=sc_pot

  ;; get_data,'JEe',data=tmp
  ;; ;;remove crap
  ;; ;;keep=where(finite(tmp.y) NE 0)
  ;; tmp.x=tmp.x(keep1)
  ;; tmp.y=tmp.y(keep1)
  ;; ;;keep=where(abs(tmp.y) GT 0.0)
  ;; jee_tmp_time=tmp.x(keep2)
  ;; jee_tmp_data=tmp.y(keep2)
  ;; store_data,'JEe',data={x:jee_tmp_time,y:jee_tmp_data}
  
  ;; ...AND ELECTRON NUMBER FLUX, PLUS CLEANING

  ;; get_2dt_ts,'j_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1), $
  ;;            name='Je_lc',energy=energy_electrons,angle=e_angle

  ;; get_data,'Je_lc',data=tmp
  ;; ;;remove_crap
  ;; ;;keep=where(finite(tmp.y) NE 0)
  ;; tmp.x=tmp.x(keep1)
  ;; tmp.y=tmp.y(keep1)
  ;; ;;keep=where(abs(tmp.y) GT 0.0)
  ;; je_lc_tmp_time=tmp.x(keep2)
  ;; je_lc_tmp_data=tmp.y(keep2)
  ;; store_data,'Je_lc',data={x:je_lc_tmp_time,y:je_lc_tmp_data}


  ;; NOW CALC CHAR. ENERGY
  ;; chare=(jee_tmp_data/je_lc_tmp_data)*6.242*1.0e11


  ;; ; *DO SOME REVERSE ENGINEERING
  ;; 

FUNCTION CALC_ELEC_NUMBERFLUX,maximus

  microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9

  IF NOT KEYWORD_SET(maximus) THEN BEGIN 
     PRINT,"No maximus in sight!"
     PRINT,"Outta here..."
     RETURN, !NULL
  ENDIF

  elec_numberflux=maximus.esa_current * microCoul_per_m2__to_num_per_cm2

  RETURN, elec_numberflux

END