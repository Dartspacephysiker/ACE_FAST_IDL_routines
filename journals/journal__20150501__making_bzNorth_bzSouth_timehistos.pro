; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/scripts_for_processing_Dartmouth_data
; Date: Fri May  1 08:05:47 2015
 

interped_i=get_fastloc_inds__imf_conds(clockstr='bzSouth',bzMin=5,/MAKE_OUTINDSFILE,byMin=0)
make_fastloc_histo,timehisto=bzSouth_timeHisto,fastloc_inds=interped_i,/output_textfile,outfileprefix='fastLoc_intervals2--bzSouth_45.00-135.00deg--'

interped_i=get_fastloc_inds__imf_conds(clockstr='bzNorth',bzMin=5,/MAKE_OUTINDSFILE,byMin=0)
make_fastloc_histo,timehisto=bzNorth_timeHisto,fastloc_inds=interped_i,/output_textfile,outfileprefix='fastLoc_intervals2--bzNorth_45.00-135.00deg--'
