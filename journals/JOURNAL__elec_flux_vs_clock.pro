;We're trying to figure out how on earth to produce a scatter plot of IMF clock angle vs. current event. This is tricky...

;***********************************************
;Load up all the dater, working from ~/Research/ACE_indices_data/idl
restore,dataDir + "/processed/culled_ACE_magdata.dat"
restore,dataDir + "/processed/maximus.dat"


;***********************************************
;RESTRICTIONS ON CHASTON DATA TO USE
;(From JOURNAL_Oct112013_orb_avg_plots_extended.pro)

mu_0 = 4.0e-7 * !PI ;perm. of free space, for Poynt. est

min_orb=8100 ;8260 for Strangeway study
max_orb=8500 ;8292 for Strangeway study
n_orbits = max_orb - min_orb + 1

min_e = 4; 4 eV in Strangeway
max_e = 250; ~300 eV in Strangeway

min_mlt = 10
max_mlt = 15

min_ilat = -85
max_ilat = -60

min_magc = 10; Minimum current derived from mag data, in microA/m^2
max_negmagc = -10; Current must be less than this, if it's going to make the cut

POYNT_EST=maximus.DELTA_B * maximus.DELTA_E / mu_0 * 1e-12
ind_region=where(maximus.ilat GE min_ilat AND maximus.ilat LE max_ilat AND maximus.mlt GE min_mlt AND maximus.mlt LE max_mlt)
ind_magc_ge10=where(maximus.mag_current GE min_magc)
ind_magc_leneg10=where(maximus.mag_current LE max_negmagc)
ind_magc_geabs10=where(maximus.mag_current LE max_negmagc OR maximus.mag_current GE min_magc)
ind_region_magc_ge10=cgsetintersection(ind_region,ind_magc_ge10)
ind_region_magc_leneg10=cgsetintersection(ind_region,ind_magc_leneg10)
ind_region_magc_geabs10=cgsetintersection(ind_region,ind_magc_geabs10)
;ind_e_ge_min_le_max=where(maximus.char_ion_energy GE min_e AND maximus.char_ion_energy LE max_e)
;ind_region_e=cgsetintersection(ind_e_ge_min_le_max,ind_region)
;ind_region_e_curge10=cgsetintersection(ind_region_e,ind_magc_ge10)
;ind_region_e_curleneg10=cgsetintersection(ind_region_e,ind_magc_leneg10) 
;ind_n_orbs=where(maximus.orbit GE min_orb AND maximus.orbit LE max_orb)
;ind_region_e_n_orbs=cgsetintersection(ind_region_e,ind_n_orbs)


chastondb_time=str_to_time(maximus.time(ind_region_magc_geabs10))

;***********************************************
;delay of...
;print, maximus.time[0]
;1996-11-21/21:25:25.562
;print, maximus.time[134924]
;1999-03-02/18:13:54.120
;Zhang & Co. use a delay of 22 min based on cross-correlation analysis(Zhang et al. 2010; Journal Atm. Sol-Terr. Phys.)
;print, "Chaston's db spans from", maximus.time[0], " to ", maximus.time[134924]
;Chaston's db spans from 1996-11-21/21:25:25.562 to 1999-03-02/18:13:54.120
;Not very much--what's worse is that ACE propagated data begins in Feb 1998

delay=1320 ;delay of 22 min for starters
;***********************************************

;check monotonicity of propagated mag db
;check=shift(mag_utc,-1)-mag_utc
;print,where(check LT 60) ;should only be LT 60 at last element

;check monotonicity of Chastondb
;check=shift(chastondb_time,-1)-chastondb_time 
;print,where(check lt 0)
;print,check(134924)
; -71786909.
;print,chastondb_time(0)-chastondb_time(-1)
; -71786909.

;excellent--it's all monotonic

;***********************************************
mag_utc_delayed=mag_utc + delay ;delayed array gives time that IMF "info" reaches ionosphere

;Now, we call upon Craig Markwardt's elegant IDL practices to handle things from here:
;For chastondb_time[i], value_locate returns chastondb_aceprop_ind[i], which is the index number
;of mag_utc_delayed such that chastondb_time[i] lies between 
;mag_utc_delayed[chastondb_aceprop_ind[i]] and mag_utc_delayed[chastondb_aceprop_ind[i+1]]

chastondb_aceprop_ind=VALUE_LOCATE(mag_utc_delayed,chastondb_time)

;Only so many are useable, since ACE data start in 1998
useable=where(chastondb_aceprop_ind GE 0, ncomplement=nlost)
print,"You're losing ",nlost," current events because ACE data doesn't start until 1998."
useable_aceprop_ind=chastondb_aceprop_ind(useable)
delvar,useable

mag_idiff=abs(mag_utc_delayed(useable_aceprop_ind)-chastondb_time)
mag_iplusdiff=abs(mag_utc_delayed(useable_aceprop_ind+1)-chastondb_time)

;trouble gives where i+1 is closer to chastondb current event
trouble=where(abs(mag_idiff) GT abs(mag_iplusdiff))

;********************************************************
;make a hist of current vs. clock angle 

;put in degrees
theta_cone=theta_cone*180/!PI
phi_clock=phi_clock*180/!PI


cgscatter2d,phi_clock(useable_aceprop_ind),maximus.integ_elec_energy_flux(ind_region_magc_geabs10(1791:*)),xtitle="Clock angle",ytitle="Integrated electron energy flux",title="Electron energy flux vs. IMF clock angle in southern hemisphere, assuming"+string(delay/60)+"min. delay",xrange=[-180,180],output="elecflux_vs_clock_angle_south_hemi.png"
