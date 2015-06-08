; Date: Mon Jun  8 16:28:35 2015
 
restore,'../database/sw_omnidata/sw_data.dat'

print,cdf_encode_epoch(sw_data.epoch.dat(4427999))
;31-Dec-2004 23:59:00.000
;OK, we've got data through 2004

print,cdf_encode_epoch(sw_data.epoch.dat(2171700))
;17-Sep-2000 03:00:00.000
;There we go. The FAST stuff reported in Yao et al. 2008 was happening on 18 Sep, ~4:30-5:00 p.m.
