;2015/06/11
;I've got this fancy new database, but the issue is that I now don't know which events are above the
;statistical auroral oval. To fix that, I'm generating a binary array that indicates whether
;or not an event is above the statistical auroral oval

dataDir='/SPENCEdata/Research/database/FAST/dartdb/saves/'
DBFile='Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'

restore,dataDir+DBFile

nObs=n_elements(maximus.time)

keep=where(abs(maximus.ilat) GT auroral_zone(maximus.mlt,7,/lat)/(!DPI)*180.)


