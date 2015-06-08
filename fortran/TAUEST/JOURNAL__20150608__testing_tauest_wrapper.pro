; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST/fortran/TAUEST
; Date: Mon Jun  8 08:30:55 2015
 
PRO JOURNAL__20150608__testing_tauest_wrapper

  restore,'../../scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus.sav'
  restore,'../../plot_indices_saves/PLOT_INDICES_20150604_duskward_inds_for_KS_analysis--6-18MLTNorth_duskward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'
  
  orbit=6693
  
;; thisOrb_i=cgsetintersection(where(maximus.orbit EQ orbit),plot_i)
  thisOrb_i=cgsetintersection(where(maximus.orbit EQ orbit),where(ABS(maximus.mag_current) GT 10))
  thisOrb_i=cgsetintersection(thisOrb_i,alfven_db_cleaner(maximus))
  
  t=str_to_time(maximus.time(thisOrb_i))
  
  tauest_wrapper,DOUBLE(maximus.mag_current(thisOrb_i)),t-t(0),orbit,/DOSTREAKS
  
  ;; print,outFile

END