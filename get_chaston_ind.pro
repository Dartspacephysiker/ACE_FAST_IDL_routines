;***********************************************
;This script merely accesses the ACE and Chaston
;current filaments databases in order to generate
;Created 01/08/2014
;See 'current_event_Poynt_flux_vs_imf.pro' for
;more info, since that's where this code comes from.

;***********************************************
;Load up all the dater, working from ~/Research/ACE_indices_data/idl
IF maximus EQ !NULL THEN restore,dataDir + "/processed/maximus.dat"


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

ind_ACEstart=(satellite EQ "ACE") ? 82896 : 0

ind_region_magc_geabs10_ACEstart=ind_region_magc_geabs10(where(ind_region_magc_geabs10 GE ind_ACEstart,$
	nGood,complement=lost,ncomplement=nlost))
lost=ind_region_magc_geabs10(lost)

cdbTime=str_to_time( maximus.time( ind_region_magc_geabs10_ACEstart ) )


printf,lun,""
printf,lun,"****From get_chaston_ind.pro****"
printf,lun,"There are " + strtrim(nGood,2) + " total events making the cut." 
IF (satellite EQ "ACE") THEN $
  printf,lun,"You're losing " + strtrim(nlost,2) + " current events because ACE data doesn't start until " + strtrim(maximus.time(ind_ACEstart),2) + "."
printf,lun,"****END get_chaston_ind.pro****"

;***********************************************
;Delete all the unnecessaries
delvar,ind_region,ind_magc_ge10,ind_magc_leneg10,ind_magc_geabs10,$
ind_region_magc_ge10,ind_region_magc_leneg10,ind_region_magc_geabs10,$
ind_ACEstart
