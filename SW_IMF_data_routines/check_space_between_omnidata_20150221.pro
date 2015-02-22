;02/21/2015
;This new OMNI dataset appears to have super coverage of time, since it integrates data from several
;satellites monitoring the SW. I'm just checking to see how important my space checking stuff
;in check_imf_stability.pro is.

;db in memory
restore,'../../database/sw_omnidata/sw_data.dat'

;time between observations thing
help,sw_data.time_btwn_obs

;simplify life
tbo=sw_data.time_btwn_obs.dat

;total num elements
print,n_elements(tbo)
;4428000

print,n_elements(where(tbo GT 1e5))
;346852--yeesh

;n spaces greater than 10 min
print,n_elements(where(tbo GT 600))
;;398142--OK, lots

;;OK, now I see...
print,n_elements(where(tbo EQ 999999))
;346852

;Right, it all adds up now...
print,sw_data.time_btwn_obs.fillval
;999999

;but there is still some garbage in there
;I need to cull this db
print,n_elements(where(tbo GT 10000 AND tbo LT 999999))
;116

;Disturbingly, this number isn't equal to the number of bad time_btwn_obs vals
print,n_elements(where(bygsm.dat EQ 9999.99))
;286451

;all right, cull 'em
;times
goodtimes_i=where(ABS(sw_data.time_btwn_obs.dat) LE 10000)
help,goodtimes_i
;GOODTIMES_I     LONG      = Array[4080915]

;mag vals
goodmagvals_i=where((abs(sw_data.bx_gse.dat) LE 99.9) AND (abs(sw_data.by_gsm.dat) LE 99.9) AND (abs(sw_data.bz_gsm.dat) LE 99.9) AND (abs(sw_data.by_gse.dat) LE 99.9) AND (abs(sw_data.bz_gse.dat) LE 99.9))
help,goodmagvals_i
;GOODMAGVALS_I   LONG      = Array[4141549]

goodmag_goodtimes_i=cgsetintersection(goodmagvals_i,goodtimes_i)
;GOODMAG_GOODTIME_I LONG      = Array[4080915]

;;here is the way to check out a time with this silly SPDF epoch format thing
biz=CDF_EPOCH_TOJULDAYS(sw_data.epoch.dat[1004], /string)
print,biz
;1996-08-01T16:44:00.000

;pure gold
biz=CDF_EPOCH_TOJULDAYS(62167219200000.0000D, /string) & print,biz
;1970-01-01T00:00:00.000

;proper times
omni_utc=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D
print,time_to_str(omni_utc[0])
