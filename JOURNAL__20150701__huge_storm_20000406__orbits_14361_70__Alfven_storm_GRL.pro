;+
;2015/07/01
;Just going to do some basic exploration to see which plots are most impressive for these orbits,
;which are all during a pretty gigantic storm 2000 Apr 6-8 or so
;-
PRO JOURNAL__20150701__huge_storm_20000406__orbits_14361_70__Alfven_storm_GRL

restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus--wpFlux.sav'

minOrb=14368
maxOrb=14369

inds=WHERE(maximus.orbit GE minOrb AND maximus.orbit LE maxOrb)

good_i=get_chaston_ind(maximus,'OMNI',-1,/BOTH_HEMIS)
inds_bedre=cgsetintersection(inds,good_i)

ts=(str_to_time(maximus.time[inds_bedre])-str_to_time(maximus.time[inds_bedre[0]]))/60.

;; splot=scatterplot(indgen(n_elements(inds_bedre)),maximus.mag_current(inds_bedre))
splot=scatterplot(ts,maximus.mag_current(inds_bedre), $
                 TITLE="Minutes since " + maximus.time[inds_bedre[0]])

END