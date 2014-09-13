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

;IMF clock angle "phi" is defined as the angle between the IMF vector (projected into the y-z plane and the z direction, where 0 deg corresponds to +z (northward), +/-90 deg to +/-y, and +/-180 deg to -z (southward)
;phi = atan(By/Bz)

phi = ATAN(mag_prop.BY_GSE,mag_prop.BZ_GSE)