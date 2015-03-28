;A little procedure for picking up on storms for certain 
;values of dst, ae, etc.
;10/24/2013, manyana

pro get_storm_times

;go where is the data
cd, '/home/spencerh/Research/Cusp/database/'

;look for indices 
dst_thresh =  -40.0 ;
;ae_thresh = 

;talk about it
restore,dataDir + "/processed/idl_acedata.dat"

;think about it

;Use "comp_dur" to compute duration of storms based on threshold value

;dst storm duration calc
dst_storm = dst.dstval LE dst_thresh
dst_storm_dur = comp_dur(dst_storm,WhereChange=dststormchange)

;now ae
;ae_storm = ae.ae LE ae_thresh
;ae_storm_dur = comp_dur(ae_storm,WhereChange=aestormchange)

;I think this command will crash idlde
;cgboxplot,mag_prop.bz_gse(these),stats=bizz

end
