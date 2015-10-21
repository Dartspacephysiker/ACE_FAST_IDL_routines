;***********************************************
;Back in the good old days, this script/journal
;was used to generate scatterplots of current 
;events and Poynting flux vs. clock angle.
;It has undergone a million mods, but its original
;purpose can still be achieved by uncommenting
;a lot of lines. (Originally created ~Sep 2013)
;

;RESTRICTIONS ON CHASTON DATA TO USE COME FROM interp_plots.pro
;(Originally from JOURNAL_Oct112013_orb_avg_plots_extended.pro)


;***********************************************
;Load up all the dater, working from ~/Research/ACE_indices_data/idl
restore,dataDir + "/processed/culled_ACE_magdata.dat"
restore,dataDir + "/processed/maximus.dat"

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

;generate indices based on restrictions in interp_plots.pro
ind_region=where(maximus.ilat GE minILAT AND maximus.ilat LE maxILAT AND maximus.mlt GE minMLT AND maximus.mlt LE maxMLT)
ind_magc_ge10=where(maximus.mag_current GE min_magc)
ind_magc_leneg10=where(maximus.mag_current LE max_negmagc)
ind_magc_geabs10=where(maximus.mag_current LE max_negmagc OR maximus.mag_current GE min_magc)
ind_region_magc_ge10=cgsetintersection(ind_region,ind_magc_ge10)
ind_region_magc_leneg10=cgsetintersection(ind_region,ind_magc_leneg10)
ind_region_magc_geabs10=cgsetintersection(ind_region,ind_magc_geabs10)
;ind_e_ge_min_le_max=where(maximus.char_ion_energy GE minE AND maximus.char_ion_energy LE maxE)
;ind_region_e=cgsetintersection(ind_e_ge_min_le_max,ind_region)
;ind_region_e_curge10=cgsetintersection(ind_region_e,ind_magc_ge10)
;ind_region_e_curleneg10=cgsetintersection(ind_region_e,ind_magc_leneg10) 
;ind_n_orbs=where(maximus.orbit GE minOrb AND maximus.orbit LE maxOrb)
;ind_region_e_n_orbs=cgsetintersection(ind_region_e,ind_n_orbs)


;gotta screen to make sure it's in ACE db too:
;Only so many are useable, since ACE data start in 1998

;cdbTime=str_to_time(maximus.time)
;ind_ACEgood=where(cdbTime GT (mag_utc(0)+delay))
;IDL> print,ind_ACEgood(0)
;       82896
;ind_ACEstart=ind_ACEgood(0)
;IDL> print,str_to_time(maximus.time(ind_acestart))
;   8.8666783e+08

ind_ACEstart=82896

ind_region_magc_geabs10_ACEstart=ind_region_magc_geabs10(where(ind_region_magc_geabs10 GT ind_ACEstart,$
	nGood,complement=lost,ncomplement=nlost))
lost=ind_region_magc_geabs10(lost)

cdbTime=str_to_time( maximus.time( ind_region_magc_geabs10_ACEstart ) )

print,""
print,"****From current_event_Poynt_flux_vs_imf.pro****"
print,"There are " + strtrim(nGood,2) + " total events making the cut." 
print,"You're losing " + strtrim(nlost,2) + " current events because ACE data doesn't start until " + strtrim(maximus.time(ind_ACEstart),2) + "."
print,"****END current_event_Poynt_flux_vs_imf.pro****"

;***********************************************
;Delete all the unnecessaries
delvar,ind_region,ind_magc_ge10,ind_magc_leneg10,ind_magc_geabs10,$
ind_region_magc_ge10,ind_region_magc_leneg10,ind_region_magc_geabs10,$
                     ind_ACEstart

;***********************************************
;Calculate Poynting flux estimate

POYNT_EST=maximus.DELTA_B * maximus.DELTA_E / mu_0


;***********************************************
;check monotonicity of propagated mag db
;check=shift(mag_utc,-1)-mag_utc
;print,where(check LT 60) ;should only be LT 60 at last element

;check monotonicity of Cdb
;check=shift(cdbTime,-1)-cdbTime 
;print,where(check lt 0)
;print,check(134924)
; -71786909.
;print,cdbTime(0)-cdbTime(-1)
; -71786909.

;excellent--it's all monotonic

;***********************************************
;Now, we call upon Craig Markwardt's elegant IDL practices to handle things from here:
;For cdbTime[i], value_locate returns cdbAceprop_i[i], which is the index number
;of mag_utc_delayed such that cdbTime[i] lies between 
;mag_utc_delayed[cdbAceprop_i[i]] and mag_utc_delayed[cdbAceprop_i[i+1]]


cdbAceprop_i=VALUE_LOCATE((mag_utc+delay),cdbTime)

mag_idiff=abs( mag_utc( cdbAceprop_i )- cdbTime)
mag_iplusdiff=abs( mag_utc( cdbAceprop_i )- cdbTime)

;trouble gives where i+1 is closer to cdb current event
trouble=where(abs(mag_idiff) GT abs(mag_iplusdiff))

;********************************************************
;histo for current event based on clock angle

;cghistoplot,phi_clock(cdbAceprop_i),$
;	xtickvalues=(indgen(5)*90-180),$
;	xtitle="Clock angle",$
;	title="> 10 microA/m^2 current events in northern hemisphere",$
;	output="NORTH_clock_angle_cur_event_histo.png"

;********************************************************
;scatterplot of Poynting estimate vs. clock angle

;cgscatter2d,phi_clock(cdbAceprop_i),$
;	poynt_est(ind_region_magc_geabs10_ACEstart),$
;	xtitle="Clock angle",ytitle="|E||B| (Poynting flux estimate)",$
;	title="Poynting flux estimate vs. IMF clock angle in northern hemisphere, assuming"+string(delay/60)+"min. delay",$
;	/ylog,yrange=[1.0e-5,1.0e-1],$
;	xrange=[-180,180],$
;	output="NORTH_poynt_est_vs_clock_angle.png"

;********************************************************
;!!!!!!!!!!!Garbage...You're using indices incorrectly...
;MANY delta_e and delta_b values are at the threshold:

;###FOR SOUTHERN HEMISPHERE (TOTAL USEABLE EVENTS 2074, 1791 LOST)
;print,n_elements(where(maximus.delta_e(ind_region_magc_geabs10) LT 21 AND maximus.delta_e(ind_region_magc_geabs10) GT 20))
;2008

;print,n_elements(where(maximus.delta_b(ind_region_magc_geabs10) LT 6 AND maximus.delta_b(ind_region_magc_geabs10) GT 5))
;2008

;IDENTICAL ISSUE for integ_elec_energy_flux (2008)


;###FOR NORTHERN HEMISPHERE (TOTAL USEABLE EVENTS 6638, 6597 LOST)
;print,n_elements(where(maximus.delta_e(ind_region_magc_geabs10) LT 21 AND maximus.delta_e(ind_region_magc_geabs10) GT 20))
;2639

;print,n_elements(where(maximus.delta_b(ind_region_magc_geabs10) LT 6 AND maximus.delta_b(ind_region_magc_geabs10) GT 5))
;3026

;print,n_elements(where(maximus.INTEG_ELEC_ENERGY_FLUX(ind_region_magc_geabs10) LT 1491 AND maximus.INTEG_ELEC_ENERGY_FLUX(ind_region_magc_geabs10) GT 1490))
;2553
;-------->The northern hemisphere is odd because several values are repeated many times
