; GET ALL THOSE NORMALIZED TIME HISTOS
;2015/05/04

fastLocDir='/SPENCEdata/Research/database/FAST/dartdb/saves/fastLoc_timeHistos/'
date='20150504'

;files
inFileName='allIMF_dawndusk_bzNorthSouth_timehistos--20150502.sav'
outFileName=fastLocDir+'fastLoc_intervals2--normalized_timehistos--all_IMF_dawndusk_bzNorthSouth--'+date+'.sav'

;"temp_or_rawfile" for each orientation
allimf_temp_or_rawfile='temp/polarplots_North_avg_all_IMF--0stable--5min_IMFsmooth--OMNI_GSM_May_2_15.dat'
dawn_temp_or_rawfile='temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_May_2_15.dat'
dusk_temp_or_rawfile='temp/polarplots_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_May_2_15.dat'
bzNorth_temp_or_rawfile='temp/polarplots_North_avg_bzNorth--1stable--5min_IMFsmooth--OMNI_GSM_May_2_15.dat'
bzSouth_temp_or_rawfile='temp/polarplots_North_avg_bzSouth--1stable--5min_IMFsmooth--OMNI_GSM_May_2_15.dat'

;open 'im up
restore,inFileName

;all IMF 
nonzero_allIMF_inds=where(allIMF_timehisto GT 0)
timehisto_allIMF_nonzero=allIMF_timehisto(nonzero_allIMF_inds)

print,min(timehisto_allIMF_nonzero,allIMF_nonzero__min_i)
;       68.000000
print,max(timehisto_allIMF_nonzero,allIMF_nonzero__max_i)
;       14953.000

allIMF_min_i=nonzero_allIMF_inds(allIMF_nonzero__min_i)
allIMF_max_i=nonzero_allIMF_inds(allIMF_nonzero__max_i)

print,allIMF_timehisto(allIMF_min_i)
;       68.000000
allIMF_timehisto_normalized=allIMF_timehisto/allIMF_timehisto(allIMF_min_i)

;dawnward
nonzero_dawn_inds=where(dawn_timehisto GT 0)
timehisto_dawn_nonzero=dawn_timehisto(nonzero_dawn_inds)

print,min(timehisto_dawn_nonzero,dawn_nonzero__min_i)
print,max(timehisto_dawn_nonzero,dawn_nonzero__max_i)

dawn_min_i=nonzero_dawn_inds(dawn_nonzero__min_i)
dawn_max_i=nonzero_dawn_inds(dawn_nonzero__max_i)

print,dawn_timehisto(dawn_min_i)
dawn_timehisto_normalized=dawn_timehisto/dawn_timehisto(dawn_min_i)

;duskward
nonzero_dusk_inds=where(dusk_timehisto GT 0)
timehisto_dusk_nonzero=dusk_timehisto(nonzero_dusk_inds)

print,min(timehisto_dusk_nonzero,dusk_nonzero__min_i)
print,max(timehisto_dusk_nonzero,dusk_nonzero__max_i)

dusk_min_i=nonzero_dusk_inds(dusk_nonzero__min_i)
dusk_max_i=nonzero_dusk_inds(dusk_nonzero__max_i)

print,dusk_timehisto(dusk_min_i)
dusk_timehisto_normalized=dusk_timehisto/dusk_timehisto(dusk_min_i)

;bzNorth
nonzero_bzNorth_inds=where(bzNorth_timehisto GT 0)
timehisto_bzNorth_nonzero=bzNorth_timehisto(nonzero_bzNorth_inds)

print,min(timehisto_bzNorth_nonzero,bzNorth_nonzero__min_i)
print,max(timehisto_bzNorth_nonzero,bzNorth_nonzero__max_i)

bzNorth_min_i=nonzero_bzNorth_inds(bzNorth_nonzero__min_i)
bzNorth_max_i=nonzero_bzNorth_inds(bzNorth_nonzero__max_i)

print,bzNorth_timehisto(bzNorth_min_i)
bzNorth_timehisto_normalized=bzNorth_timehisto/bzNorth_timehisto(bzNorth_min_i)

;bzSouth
nonzero_bzSouth_inds=where(bzSouth_timehisto GT 0)
timehisto_bzSouth_nonzero=bzSouth_timehisto(nonzero_bzSouth_inds)

print,min(timehisto_bzSouth_nonzero,bzSouth_nonzero__min_i)
print,max(timehisto_bzSouth_nonzero,bzSouth_nonzero__max_i)

bzSouth_min_i=nonzero_bzSouth_inds(bzSouth_nonzero__min_i)
bzSouth_max_i=nonzero_bzSouth_inds(bzSouth_nonzero__max_i)

print,bzSouth_timehisto(bzSouth_min_i)
bzSouth_timehisto_normalized=bzSouth_timehisto/bzSouth_timehisto(bzSouth_min_i)

;;;;;;;;;;;;;
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

bzNorth_normedTimeHisto_struct={data:bzNorth_timehisto_normalized,$
                               title:'Normalized (by ' + strcompress(bzNorth_timehisto(bzNorth_min_i),/remove_all) + ' sec) dusk time histogram', $
                               lim:[min(bzNorth_timehisto_normalized),max(bzNorth_timehisto_normalized)]}

bzSouth_normedTimeHisto_struct={data:bzSouth_timehisto_normalized,$
                               title:'Normalized (by ' + strcompress(bzSouth_timehisto(bzSouth_min_i),/remove_all) + ' sec) dusk time histogram', $
                               lim:[min(bzSouth_timehisto_normalized),max(bzSouth_timehisto_normalized)]}

save,allimf_timehisto,allimf_timehisto_normalized,allimf_min_i, $
     dawn_timehisto,dawn_timehisto_normalized,dawn_min_i, $
     dusk_timehisto,dusk_timehisto_normalized,dusk_min_i, $
     bzNorth_timehisto,bzNorth_timehisto_normalized,bzNorth_min_i, $
     bzSouth_timehisto,bzSouth_timehisto_normalized,bzSouth_min_i, $
     allimf_normedTimeHisto_struct,dawn_normedTimeHisto_struct,dusk_normedTimeHisto_struct,bzNorth_normedTimeHisto_struct,bzSouth_normedTimeHisto_struct,$
     allimf_temp_or_rawfile,dawn_temp_or_rawfile,dusk_temp_or_rawfile,bzNorth_temp_or_rawfile,bzSouth_temp_or_rawfile, $
     filename=outFileName
