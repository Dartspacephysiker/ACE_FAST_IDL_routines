; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/scripts_for_processing_Dartmouth_data
; Date: Sat Aug  8 18:44:39 2015
 
;restore the burst-mode file (see below for code that generated it in this form)
;; restore,'/SPENCEdata/Research/Cusp/database/dartdb/saves/maximus_and_cdbtime--burstmode_orbs1000-16361_cleaned_and_only_gt_10current.sav'

;;Now it's time to plot
plot_alfven_stats_imf_screening,maximus,clockstr='all_IMF',/orbtotplot,/include_burstdata, $
                                /orbfreqplot, orbfreqrange=[0.0,1.0], $
                                /orbcontribplot, orbcontribrange=[0,25], $
                                /chareplots, /logchareplot, charerange=[4,4000], $
                                /neventperorbplot, neventperorbrange=[0,30], $
                                /wholecap,plotprefix='all_data_burstmode_test--orbs500-16361--chare_4-4000--'

plot_alfven_stats_imf_screening,maximus,clockstr='all_IMF',/orbtotplot,/include_burstdata, $
                                /orbfreqplot, orbfreqrange=[0.0,1.0], $
                                /orbcontribplot, orbcontribrange=[0,25], $
                                /chareplots, /logchareplot, charerange=[4,300], $
                                /neventperorbplot, neventperorbrange=[0,30], $
                                /wholecap,plotprefix='all_data_burstmode_test--orbs500-16361--chare_4-300--'

;histos
cghistoplot,maximus.mag_current,output='burstmode_test--orbs1000-16361--histo_magcurrent.png',title='Burst mode: Mag current distribution'
cghistoplot,maximus.mlt,output='burstmode_test--orbs1000-16361--histo_MLT.png',title='Burst mode: MLT distribution'
cghistoplot,maximus.ilat,output='burstmode_test--orbs1000-16361--histo_ILAT.png',title='Burst mode: ILAT distribution'
cghistoplot,maximus.alt,output='burstmode_test--orbs1000-16361--histo_ALTITUDE.png',title='Burst mode: Altitude distribution'

 

;*****************************************
;Code for generating the file restored above
;; restore,'../database/dartdb/saves/Dartdb_20150810--1000-16361--maximus--burstmode.sav'
;; restore,'../database/dartdb/saves/Dartdb_20150810--1000-16361--cdbtime--burstmode.sav'
;; this=alfven_db_cleaner(maximus)
;****From alfven_db_cleaner.pro****
;Lost 133 events to NaNs and infinities...
;Lost 6062 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****

;; maximus=resize_maximus(maximus,inds=this,cdbtime=cdbtime)
;**********from resize_maximus.pro**********
;Resizing based on indices
;N_elements before: 17027
;Also doing cdbTime!
;N cdbTime before: 17027
;N cdbTime after: 10832
;N_elements after: 10832
;***********end resize_maximus.pro**********

;; maximus=resize_maximus(maximus,maximus_ind=6,/only_absvals,max_for_ind=800,min_for_ind=10,cdbtime=cdbtime)
;**********from resize_maximus.pro**********
;Resizing based on ABS(MAG_CURRENT)
;Upper limit: 800
;Lower limit: 10
;N_elements before: 10832
;Also doing cdbTime!
;N cdbTime before: 10832
;N cdbTime after: 5869
;N_elements after: 5869
;***********end resize_maximus.pro**********
;; save,maximus,cdbtime,filename='maximus_and_cdbtime--burstmode_orbs1000-16361_cleaned_and_only_gt_10current.sav'
