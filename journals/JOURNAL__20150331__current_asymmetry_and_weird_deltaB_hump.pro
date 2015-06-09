; IDL Version 8.4 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST
; Date: Tue Mar 31 10:10:58 2015
 
date='20150331'
restore,'/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus--cleaned.sav'
print,tag_names(maximus)
inds_gt_15=where(maximus.mag_current GT 15)
inds_0_15=where(maximus.mag_current LE 15 AND maximus.mag_current GE 0)
inds_lt_neg15=where(maximus.mag_current LT -15)
inds_neg15_0=where(maximus.mag_current GE -15 AND maximus.mag_current LE 0)
inds_abs_gt_15=where(ABS(maximus.mag_current) GT 15)
inds_abs_le_15=where(ABS(maximus.mag_current) LE 15)
cghistoplot,maximus.mag_current(inds_gt_15),title='mag_current > 15 (signed)',output='magc_gt_15--cleaned_DB--'+date+'.png'
cghistoplot,maximus.mag_current(inds_0_15),title='0 < mag_current < 15 (signed)',output='magc_0_15--cleaned_DB--'+date+'.png',mininput=0,maxinput=15
cghistoplot,maximus.mag_current(inds_neg15_0),title='-15 < mag_current < 0 (signed)',output='magc_neg15_0--cleaned_DB--'+date+'.png',mininput=-15,maxinput=0
cghistoplot,maximus.mag_current(inds_lt_neg15),title='mag_current < -15 (signed)',output='magc_lt_neg15--cleaned_DB--'+date+'.png'
cghistoplot,maximus.mag_current(inds_abs_gt_15),title='mag_current > 15 (absolute value)',output='magc_abs_gt_15--cleaned_DB--'+date+'.png'
cghistoplot,maximus.mag_current(inds_abs_le_15),title='mag_current <= 15 (absolute value)',output='magc_abs_le_15--cleaned_DB--'+date+'.png'

;;now zoomed in!
cghistoplot,maximus.mag_current(inds_gt_15),title='mag_current > 15 (signed)',output='magc_gt_15--zoomed--cleaned_DB--'+date+'.png',maxinput=150
cghistoplot,maximus.mag_current(inds_lt_neg15),title='mag_current < -15 (signed)',output='magc_lt_neg15--zoomed--cleaned_DB--'+date+'.png',mininput=-150
cghistoplot,maximus.mag_current(inds_abs_gt_15),title='mag_current > 15 (absolute value)',output='magc_abs_gt_15--zoomed--cleaned_DB--'+date+'.png',mininput=-150,maxinput=150



;;;;;;;;;;;;;;;;;;;
;;Now delta_b plots
;;;;;;;;;;;;;;;;;;;

cghistoplot,maximus.delta_b(inds_gt_15),title='Delta_b for mag_current > 15 (signed)',output='delta_b_for_magc_gt_15--cleaned_DB--'+date+'.png'
cghistoplot,maximus.delta_b(inds_0_15),title='Delta_b for 0 < mag_current < 15 (signed)',output='delta_b_for_magc_0_15--cleaned_DB--'+date+'.png'
cghistoplot,maximus.delta_b(inds_neg15_0),title='Delta_b for -15 < mag_current < 0 (signed)',output='delta_b_for_magc_neg15_0--cleaned_DB--'+date+'.png'
cghistoplot,maximus.delta_b(inds_lt_neg15),title='Delta_b for mag_current < -15 (signed)',output='delta_b_for_magc_lt_neg15--cleaned_DB--'+date+'.png'
cghistoplot,maximus.delta_b(inds_abs_gt_15),title='Delta_b for mag_current > 15 (absolute value)',output='delta_b_for_magc_abs_gt_15--cleaned_DB--'+date+'.png'
cghistoplot,maximus.delta_b(inds_abs_le_15),title='Delta_b for mag_current <= 15 (absolute value)',output='delta_b_for_magc_abs_le_15--cleaned_DB--'+date+'.png'

;;now zoomed in!
cghistoplot,maximus.delta_b(inds_gt_15),title='Delta_b for mag_current > 15 (signed)',output='delta_b_for_magc_gt_15--zoomed--cleaned_DB--'+date+'.png',maxinput=100
cghistoplot,maximus.delta_b(inds_0_15),title='Delta_b for 0 < mag_current < 15 (signed)',output='delta_b_for_magc_0_15--zoomed--cleaned_DB--'+date+'.png',maxinput=100
cghistoplot,maximus.delta_b(inds_neg15_0),title='Delta_b for -15 < mag_current < 0 (signed)',output='delta_b_for_magc_neg15_0--zoomed--cleaned_DB--'+date+'.png',maxinput=100
cghistoplot,maximus.delta_b(inds_lt_neg15),title='Delta_b for mag_current < -15 (signed)',output='delta_b_for_magc_lt_neg15--zoomed--cleaned_DB--'+date+'.png',maxinput=100
cghistoplot,maximus.delta_b(inds_abs_gt_15),title='Delta_b for mag_current > 15 (absolute value)',output='delta_b_for_magc_abs_gt_15--zoomed--cleaned_DB--'+date+'.png',maxinput=100
cghistoplot,maximus.delta_b(inds_abs_le_15),title='Delta_b for mag_current <= 15 (absolute value)',output='delta_b_for_magc_abs_le_15--zoomed--cleaned_DB--'+date+'.png',maxinput=100