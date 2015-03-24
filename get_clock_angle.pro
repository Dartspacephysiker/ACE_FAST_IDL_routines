;A little procedure for picking up on storms for certain 
;values of dst, ae, etc.
;10/24/2013, manyana

;go where is the data
cd, '/home/spencerh/Research/ACE_indices_data/idl'

;talk about it
restore,"idl_acedata.dat"

;IMF cone angle "theta" defined as the angle between the IMF direction and the Sun-Earth line 
;theta = acos(|Bx|/|Bt|)

theta = ACOS(abs(mag_prop.Bx_GSE),sqrt(mag_prop.bx_gse*mag_prop.bx_gse+mag_prop.by_gse*mag_prop.by_gse+mag_prop.bz_gse*mag_prop.BZ_GSE))

;IMF clock angle "phi" is defined as the angle between the IMF vector (projected into the y-z plane
;and the z direction, where 0 deg corresponds to +z (northward), +/-90 deg to +/-y, and +/-180 deg
;to -z (southward)
;If you don't believe, see http://www.ips.gov.au/Category/Solar/Solar%20Conditions/Solar%20Wind%20Clock%20Angle/Solar%20Wind%20Clock%20Angle.php
;phi = atan(By/Bz)

;Dawnward IMF:
;angle=atan(-1,0)*180/!PI
;print,(angle+360) MOD 360
;      270.000
;Duskward IMF:
;angle=atan(1,0)*180/!PI
;print,(angle+360) MOD 360
;      90.0000
;
;IMF Bz North:
;angle=atan(0,1)*180/!PI
;print,(angle+360) MOD 360
;      0.00000
;
;IMF Bz South:
;angle=atan(0,-1)*180/!PI
;print,(angle+360) MOD 360
;      180.000
;

phi = ATAN(mag_prop.BY_GSE,mag_prop.BZ_GSE)