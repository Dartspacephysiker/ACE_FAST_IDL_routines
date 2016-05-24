;Make plots of all normalized time histos! (They are normalized to themselves, you know--see
;JOURNAL_normalizing_time...20150502.pro)

datfile='/SPENCEdata/Research/database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--normalized_timehistos--all_IMF_dawndusk_bzNorthSouth--20150504.sav'
restore,datFile

;now we've got [orientation]_normedTimeHisto_struct, [orientation]_temp_or_rawfile, which
;should be all we need

date='20150504'
allIMF_outPS='timehisto_normalized--allIMF--'+date+'.ps'
dawn_outPS='timehisto_normalized--dawnward--'+date+'.ps'
dusk_outPS='timehisto_normalized--duskward--'+date+'.ps'
bzSouth_outPS='timehisto_normalized--bzSouthward--'+date+'.ps'
bzNorth_outPS='timehisto_normalized--bzNorthward--'+date+'.ps'

;allIMF
independent_polar_plot2dhist,allIMF_temp_or_rawfile,allIMF_normedTimeHisto_struct,outpsfname=allIMF_outPS

;dawn
independent_polar_plot2dhist,dawn_temp_or_rawfile,dawn_normedTimeHisto_struct,outpsfname=dawn_outPS

;dusk
independent_polar_plot2dhist,dusk_temp_or_rawfile,dusk_normedTimeHisto_struct,outpsfname=dusk_outPS

;bzSouth
independent_polar_plot2dhist,bzSouth_temp_or_rawfile,bzSouth_normedTimeHisto_struct,outpsfname=bzSouth_outPS

;bzNorth
independent_polar_plot2dhist,bzNorth_temp_or_rawfile,bzNorth_normedTimeHisto_struct,outpsfname=bzNorth_outPS

