;Make plots of all normalized time histos! (They are normalized to themselves, you know--see
;JOURNAL_normalizing_time...20150422.pro)

datfile='scripts_for_processing_Dartmouth_data/fastLoc_timeHistos/fastLoc_intervals2--normalized_timehistos--all_IMF-dawn-dusk--20150422.sav'
restore,datFile

;now we've got [orientation]_normedTimeHisto_struct, [orientation]_temp_or_rawfile, which
;should be all we need

allIMF_outPS='timehisto_normalized--allIMF--20150422.ps'
dawn_outPS='timehisto_normalized--dawnward--20150422.ps'
dusk_outPS='timehisto_normalized--duskward--20150422.ps'

;allIMF
independent_polar_plot2dhist,allIMF_temp_or_rawfile,allIMF_normedTimeHisto_struct,outpsfname=allIMF_outPS

;dawn
independent_polar_plot2dhist,dawn_temp_or_rawfile,dawn_normedTimeHisto_struct,outpsfname=dawn_outPS

;dusk
independent_polar_plot2dhist,dusk_temp_or_rawfile,dusk_normedTimeHisto_struct,outpsfname=dusk_outPS

