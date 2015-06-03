;2015/05/04
;trying to figure out why the timehistos from 04/22 look so much different from those on 05/02
 
allIMF_interped_i=get_fastloc_inds__imf_conds(clockstr='all_IMF',/MAKE_OUTINDSFILE,byMin=0,STABLEIMF=0)
make_fastloc_histo,timehisto=allIMF_timeHisto,fastloc_inds=allIMF_interped_i,/output_textfile,outfileprefix='fastLoc_intervals2--all_IMF--'

dawn_interped_i=get_fastloc_inds__imf_conds(clockstr='dawnward',bzMin=0,/MAKE_OUTINDSFILE,byMin=5)
make_fastloc_histo,timehisto=dawn_timeHisto,fastloc_inds=dawn_interped_i,/output_textfile,outfileprefix='fastLoc_intervals2--dawn_45.00-135.00deg--'

dusk_interped_i=get_fastloc_inds__imf_conds(clockstr='duskward',/MAKE_OUTINDSFILE,byMin=5)
make_fastloc_histo,timehisto=dusk_timeHisto,fastloc_inds=dusk_interped_i,/output_textfile,outfileprefix='fastLoc_intervals2--dusk_45.00-135.00deg--'

bzNorth_interped_i=get_fastloc_inds__imf_conds(clockstr='bzNorth',bzMin=2,/MAKE_OUTINDSFILE,byMin=0)
make_fastloc_histo,timehisto=bzNorth_timeHisto,fastloc_inds=bzNorth_interped_i,/output_textfile,outfileprefix='fastLoc_intervals2--bzNorth_45.00-135.00deg--'

bzSouth_interped_i=get_fastloc_inds__imf_conds(clockstr='bzSouth',bzMin=2,/MAKE_OUTINDSFILE,byMin=0)
make_fastloc_histo,timehisto=bzSouth_timeHisto,fastloc_inds=bzSouth_interped_i,/output_textfile,outfileprefix='fastLoc_intervals2--bzSouth_45.00-135.00deg--'

outFileName='allIMF_dawndusk_bzNorthSouth_timehistos--20150502.sav'
print,'Saving ' + outFileName + '...'
save,allIMF_timeHisto,dawn_timeHisto,dusk_timeHisto,bzNorth_timeHisto,bzSouth_timeHisto,filename=outFileName