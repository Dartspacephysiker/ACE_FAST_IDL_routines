; GET ALL THOSE NORMALIZED TIME HISTOS
; IDL Version 8.3 (linux x86_64 m64)
; Journal File for spencerh@tadrith
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST
; Date: Wed Apr 22 10:46:57 2015

;files
allIMF_file='/SPENCEdata/Research/database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--all_IMF_180.00-180.00deg--OMNI_GSM--byMin_0.0--stableIMF_0min--delay_660--smoothWindow_5min--6-18-0.75_MLT--60-84-2_ILAT--orbs500-14999--timehisto--20150420.sav'

dawn_file='/SPENCEdata/Research/database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--dawnward_45.00-135.00deg--OMNI_GSM--byMin_5.0--stableIMF_1min--delay_660--smoothWindow_5min--6-18-0.75_MLT--60-84-2_ILAT--orbs520-10983--timehisto--20150420.sav'

dusk_file='/SPENCEdata/Research/database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--duskward_45.00-135.00deg--OMNI_GSM--byMin_5.0--stableIMF_1min--delay_660--smoothWindow_5min--6-18-0.75_MLT--60-84-2_ILAT--orbs500-14976--timehisto--20150420.sav'

;all IMF 
restore,allIMF_file

nonzero_allIMF_inds=where(timehisto GT 0)
timehisto_allIMF_nonzero=timehisto(nonzero_allIMF_inds)

print,min(timehisto_allIMF_nonzero,allIMF_nonzero__min_i)
;       68.000000
print,max(timehisto_allIMF_nonzero,allIMF_nonzero__max_i)
;       14953.000

allIMF__min_i=nonzero_allIMF_inds(allIMF_nonzero__min_i)
allIMF_min_i=nonzero_allIMF_inds(allIMF_nonzero__min_i)
allIMF_max_i=nonzero_allIMF_inds(allIMF_nonzero__max_i)

allIMF_timehisto=timehisto
print,allIMF_timehisto(allIMF_min_i)
;       68.000000
allIMF_timehisto_normalized=allIMF_timehisto/allIMF_timehisto(allIMF_min_i)

;dawnward
restore,dawn_file

nonzero_dawn_inds=where(timehisto GT 0)
timehisto_dawn_nonzero=timehisto(nonzero_dawn_inds)

print,min(timehisto_dawn_nonzero,dawn_nonzero__min_i)
print,max(timehisto_dawn_nonzero,dawn_nonzero__max_i)

dawn__min_i=nonzero_dawn_inds(dawn_nonzero__min_i)
dawn_min_i=nonzero_dawn_inds(dawn_nonzero__min_i)
dawn_max_i=nonzero_dawn_inds(dawn_nonzero__max_i)

dawn_timehisto=timehisto
print,dawn_timehisto(dawn_min_i)
dawn_timehisto_normalized=dawn_timehisto/dawn_timehisto(dawn_min_i)

;duskward
restore,dusk_file

nonzero_dusk_inds=where(timehisto GT 0)
timehisto_dusk_nonzero=timehisto(nonzero_dusk_inds)

print,min(timehisto_dusk_nonzero,dusk_nonzero__min_i)
print,max(timehisto_dusk_nonzero,dusk_nonzero__max_i)

dusk__min_i=nonzero_dusk_inds(dusk_nonzero__min_i)
dusk_min_i=nonzero_dusk_inds(dusk_nonzero__min_i)
dusk_max_i=nonzero_dusk_inds(dusk_nonzero__max_i)

dusk_timehisto=timehisto
print,dusk_timehisto(dusk_min_i)
dusk_timehisto_normalized=dusk_timehisto/dusk_timehisto(dusk_min_i)


;make structs
allimf_normedTimeHisto_struct={data:allimf_timehisto_normalized,$
                               title:'Normalized (by ' + strcompress(allimf_timehisto(allimf_min_i),/remove_all) + ' sec) allIMF time histogram', $
                               lim:[min(allimf_timehisto_normalized),max(allimf_timehisto_normalized)]}

dawn_normedTimeHisto_struct={data:dawn_timehisto_normalized,$
                               title:'Normalized (by ' + strcompress(dawn_timehisto(dawn_min_i),/remove_all) + ' sec) dawn time histogram', $
                               lim:[min(dawn_timehisto_normalized),max(dawn_timehisto_normalized)]}

dusk_normedTimeHisto_struct={data:dusk_timehisto_normalized,$
                               title:'Normalized (by ' + strcompress(dusk_timehisto(dusk_min_i),/remove_all) + ' sec) dusk time histogram', $
                               lim:[min(dusk_timehisto_normalized),max(dusk_timehisto_normalized)]}

;"temp_or_rawfile" for each orientation
allimf_temp_or_rawfile='temp/polarplots_North_avg_all_IMF--0stable--5min_IMFsmooth--OMNI_GSM_Apr_10_15.dat'
dawn_temp_or_rawfile='temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
dusk_temp_or_rawfile='temp/polarplots_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'

save,allimf_timehisto,allimf_timehisto_normalized,allimf_min_i, $
     dawn_timehisto,dawn_timehisto_normalized,dawn_min_i, $
     dusk_timehisto,dusk_timehisto_normalized,dusk_min_i, $
     allimf_normedTimeHisto_struct,dawn_normedTimeHisto_struct,dusk_normedTimeHisto_struct, $
     allimf_temp_or_rawfile,dawn_temp_or_rawfile,dusk_temp_or_rawfile, $
     filename='/SPENCEdata/Research/database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--normalized_timehistos--all_IMF-dawn-dusk--20150422.sav'