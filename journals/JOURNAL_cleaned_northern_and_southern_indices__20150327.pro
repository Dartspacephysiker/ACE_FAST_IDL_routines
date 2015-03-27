;2015/03/27
; It seems like I'm always wishing I had a cleaned database to work with. Well, now I do! 

;For both southern and northern hemisphere, 
; charerange=[2,4e3]
; altituderange=[0,5000]
; satellite="OMNI"
; minILAT = 60 / -84  (Northern/Southern)
; maxILAT = 84 / -60  (Northern/Southern)

; Other cleaning happens in alfven_db_cleaner
; This includes ensuring that there are no indices associated with NaNs, infinities, or very extreme values for any quantities
; You might want to consider the restriction on extremely high values, however, because you could be excluding the "most
;   interesting" events.

; Still other cleaning happens in resize_maximus.pro, where all non-Alfven wave events (whatever
; they are) get excluded for being such disgusting creatures.

;First, the northern hemisphere
 COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNegM
minM = 0 & maxM = 24 & minI = 60 & maxI = 88 & binM = 0.5 & binI = 2 & minMC = 1 & maxNegMC = -1
plot_alfven_stats_imf_screening,maximus,clockStr="all_IMF",altituderange=[0,5000],charerange=[2,4e3],minILAT=60,maxILAT=88,minMLT=0,maxMLT=24,satellite="OMNI"
clean_n_i=ind_region_magc_geabs10_ACEstart
save,clean_n_i,filename="cleaned_NORTHERN_i_for_02282015_DB.sav"

;Now the southern
 COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNegM
minM = 0 & maxM = 24 & minI = -88 & maxI = -60 & binM = 0.5 & binI = 2 & minMC = 1 & maxNegMC = -1
plot_alfven_stats_imf_screening,maximus,clockStr="all_IMF",altituderange=[0,5000],charerange=[2,4e3],minILAT=-88,maxILAT=-60,minMLT=0,maxMLT=24,satellite="OMNI"
minM = 0 & maxM = 24 & minI = -88 & maxI = -60 & binM = 0.5 & binI = 2 & minMC = 1 & maxNegMC = -1
clean_s_i=ind_region_magc_geabs10_ACEstart
save,clean_s_i,filename="cleaned_SOUTHERN_i_for_02282015_DB.sav"

;Now both!
restore,"cleaned_SOUTHERN_i_for_02282015_DB.sav"
restore,"cleaned_NORTHERN_i_for_02282015_DB.sav"
clean_i=cgsetunion(cleaned_northern_i,cleaned_southern_i)

save,clean_n_i,clean_s_i,clean_i,filename="cleaned_indices_for_02282015_DB.sav"
exit
