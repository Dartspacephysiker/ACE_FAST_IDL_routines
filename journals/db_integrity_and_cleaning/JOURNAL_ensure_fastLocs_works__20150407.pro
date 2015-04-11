; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data
; Date: Tue Apr  7 15:43:49 2015
 
restore,'scripts_for_processing_Dartmouth_data/fastLoc_intervals2--20150409.sav'
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data
restore,'scripts_for_processing_Dartmouth_data/fastLoc_intervals2--20150409--times.sav'
diff=shift(fastloc_times,-1)-fastloc_times
inds=where(diff GT 10)
print,fastloc.orbit(inds+1)-fastloc.orbit(inds)
;           1           1           1           2           1           1
;           0           0           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           0           1           1           1           1
;           1           1           1           2           1           1
;           1           1           1           1           1           1
;           1           1           1           1           2           1
;           1           1           1           1           1           1
;           1           1           1           1           3           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           0           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           2           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           2           1           1           1
;           1           1           1           1           1           1
;           4           1           1           1           1           1
;           1           1           2           1           1           1
;           1           1           1           1           1           1
;           1           0           1           1           0           1
;           1           1           1           1           1           1
;           3           1           1           1           1           1
;           1           1           1           4           1           1
;           0           1           1           1           1           1
;           1           1           1           2           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           5           1           1           1           1
;           1           1           1           4           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           2
;           1           4           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           2
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           4           1           2
;           1           1           1           1           1           1
;           1           0           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           0           1
;           1           1           1           2           1           1
;           1           1           1           0           1           1
;           1           1           1           1           1           1
;           0           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;           1           1           1           1           3           1
;           1           1           1           1           1           1
;           1           1           1           1           1           1
;See? These happen where the orbit number changes or else (I assume) where the interval changes. It's hunky-dory.

;now, how about a check on the total time?
print,total(fastloc_delta_t)
;  5.48038e+06
print,total(fastloc_delta_t)/60/60
;      1522.33
print,total(fastloc_delta_t)/60/60/24
;      63.4304
;So 63 days spent in the polar regions when electron survey data was available. It seems reasonable.