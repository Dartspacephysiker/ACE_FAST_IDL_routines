.RESET_SESSION
CD, '/home/spencerh/Research/Cusp/ACE_FAST'
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
help
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
; % Syntax error.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
; % Syntax error.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/clock_angle_cur_event_histo.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/clock_angle_cur_event_histo.png
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
print,clock(0:10)
;     0.178518     0.180526     0.160245     0.167545     0.177320     0.157702     0.166272     0.162563     0.149553     0.173244     0.122637
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
; % PLOT: Warning: Infinite plot range.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
; % PLOT: Warning: Infinite plot range.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
; % Syntax error.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
help
help,/str,maximus
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle.png
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
; % Syntax error.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
cghistoplot,maximus.ILAT
@"current_event_vs_imf.pro"
;You're losing            0 current events because ACE data doesn't start until 1998.
;Traceback Report from CGHISTOPLOT:
;     % HISTOGRAM: Illegal binsize or max/min.
;     % Execution halted at:  CGHISTOPLOT       856 /home/spencerh/idl/lib/coyote/cghistoplot.pro
;     %                       $MAIN$          
; % Program caused arithmetic error: Floating illegal operand
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/clock_angle_cur_event_histo_south_hemi.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/clock_angle_cur_event_histo_south_hemi.png
@"current_event_vs_imf.pro"
;You're losing         1791 current events because ACE data doesn't start until 1998.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/clock_angle_cur_event_histo_south_hemi.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/clock_angle_cur_event_histo_south_hemi.png
@"current_event_vs_imf.pro"
;You're losing         1791 current events because ACE data doesn't start until 1998.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle_south_hemi.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle_south_hemi.png
@"current_event_vs_imf.pro"
;You're losing         1791 current events because ACE data doesn't start until 1998.
;Output file located here: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle_south_hemi.png
;Output File: /SPENCEdata/Research/ACE_indices_data/idl/poynt_est_vs_clock_angle_south_hemi.png
print,poynt_est(useable_ind)

print,maximus.DELTA_B(useable_ind)

print,maximus.DELTA_e(useable_ind)
print, min(maximus.DELTA_B)
;      5.00004
print, max(maximus.DELTA_B)
;      5745.70
print, AVG((maximus.DELTA_B)
; % Syntax error.
print, AVG(maximus.DELTA_B)
;      18.3047
print,n_elements(where(maximus.delta_b(useable_ind) GT 21 AND maximus.delta_b(useable_ind) LT 20))
;           1
print,n_elements(where(maximus.delta_e(useable_ind) GT 21 AND maximus.delta_e(useable_ind) LT 20))
;           1
print,maximus.delta_e(useable_ind)

print,n_elements(where(maximus.delta_e(useable_ind) GE 21 AND maximus.delta_e(useable_ind) LE 20))
;           1
print,n_elements(where(maximus.delta_e(useable_ind) LT 21 AND maximus.delta_e(useable_ind) GT 20))
;        2008
print,n_elements(where(maximus.delta_b(useable_ind) LT 6 AND maximus.delta_b(useable_ind) GT 5))
;        2008
@"current_event_vs_imf.pro"
;You're losing         6597 current events because ACE data doesn't start until 1998.
;        2639
;        3026
print,n_elements(where(maximus.delta_b(useable_ind) LT 6 AND maximus.delta_b(useable_ind) GT 5))
;        3026
@"current_event_vs_imf.pro"
;You're losing         1791 current events because ACE data doesn't start until 1998.
help,useable_ind
print,maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind)

print,n_elements(where(maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind) LT 1491 AND maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind) GT 1490))
;        2008
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
min_ilat = 60
max_ilat = 85
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
;For chastondb_time[i], value_locate returns chastondb_magprop_ind[i], which is the index number
;of mag_utc_delayed such that chastondb_time[i] lies between 
;mag_utc_delayed[chastondb_magprop_ind[i]] and mag_utc_delayed[chastondb_magprop_ind[i+1]]
chastondb_magprop_ind=VALUE_LOCATE(mag_utc_delayed,chastondb_time)
;Only so many are useable, since ACE data start in 1998
useable=where(chastondb_magprop_ind GE 0, ncomplement=nlost)
print,"You're losing ",nlost," current events because ACE data doesn't start until 1998."
;You're losing         6597 current events because ACE data doesn't start until 1998.
useable_ind=chastondb_magprop_ind(useable)
delvar,useable
help
print,n_elements(where(maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind) LT 1491 AND maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind) GT 1490))
;        2553
print,maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind)


print,n_elements(where(maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind) LT 1491 AND maximus.INTEG_ELEC_ENERGY_FLUX(useable_ind) GT 1490))
;        2553
print,maximus.time(useable_ind)

print,useable_ind
;        1093        1093        1093        1093        1093        1093        1094        1094        1094        1094        1094     
print,ind_region_magc_geabs10

restore,"culled_ACE_magdata.dat"
restore,"../../Chastondb/idl_datafiles/maximus.dat"
@"elec_flux_vs_clock.pro"
;You're losing         1791 current events because ACE data doesn't start until 1998.
print,useable_ind
;      128001      128001      128001      128001      128001      128001      128001      128001      128001      128001      128001     
print,maximus.INTEG_ELEC_ENERGY_FLUX(540874)
; % Illegal subscript range: <No name>.
print,maximus.time(useable_ind)
;1999-02-05/10:49:11.863 1999-02-05/10:49:11.863 1999-02-05/10:49:11.863 1999-02-05/10:49:11.863 1999-02-05/10:49:11.863 1999-02-05/10:49:
