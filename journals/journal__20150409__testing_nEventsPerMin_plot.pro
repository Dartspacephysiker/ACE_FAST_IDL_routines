; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/scripts_for_processing_Dartmouth_data
; Date: Thu Apr  9 15:17:13 2015
 
plot_alfven_stats_imf_screening,CLOCKSTR="dawnward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5,/DEL_PS
plot_alfven_stats_imf_screening,CLOCKSTR="duskward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5,/DEL_PS

plot_alfven_stats_imf_screening,CLOCKSTR="dawnward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5, $
                                /NEVENTPERMINPLOT,SMOOTHWINDOW=5,/DEL_PS,/logneventpermin
plot_alfven_stats_imf_screening,CLOCKSTR="duskward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5, $
                                /NEVENTPERMINPLOT,SMOOTHWINDOW=5,/DEL_PS,/logneventpermin

;Here's a bunch of garbage I generated while trying to make sure everything was sane earlier today
; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST
; Date: Thu Apr  9 15:57:58 2015
 
help,divisor
print,clockStr
;duskward
divisor_nonZero_i=WHERE(divisor GT 0)
print,n_elements(divisor_nonZero_i)
;         101
print,n_elements(h2dNonzeroNEv_i)
;          96
help,h2dnevperminstr.data
combined_nonzero_i=cgsetintersection(divisor_nonzero_i,h2dnonzeronev_i)
help,combined_nonzero_i
.o
;Current directory is /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/
;Creating output files...
;PostScript output will be created here: 
;plots/nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
;PostScript output will be created here: 
;plots/nEvents_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEvents_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
print,mini
; % PRINT: Variable is undefined: MINI.
plot_alfven_stats_imf_screening,CLOCKSTR="duskward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5
;Can't do nEventPerOrbPlot without nPlots!!
;Enabling nPlots...
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;There are 85668 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 62486 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;11814 events with IMF predominantly duskward.
;There are 11415 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 291 unique orbits in the data you've provided for predominantly duskward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 89.0000
;Hemisphere: North
;IMF Predominance: duskward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 291
;Total number of events used: 11415
;Percentage of current DB used: 1.39238%
.so 1
.so 1
.so 1
.so 1
.so 1
.so 1
.so 1
.so 1
.so 1
.so 1
.so 1
;****From interp_mag_data_for_fastloc.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 2401287 time segments because of minimum By requirement.
;****END text from interp_mag_data_for_fastloc.pro****
;****From check_imf_stability_for_fastloc.pro****
;295827 time segments with IMF predominantly duskward.
;There are 294300 time segments prior to which we have  at least 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability_for_fastloc.pro****
.so 1
help,combined_nonzero_i
     divisor = divisor(h2dNonzeroNEv_i)/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
print,divisor
;       1.7145833       6.9687500       4.6687500       8.5354167       14.420833
;       23.127083       19.493750       22.408333       18.208333       21.962500
;       13.954167       13.579167       3.7000000       0.0000000       1.5125000
;       10.316667       16.629167       21.868750       14.714583       18.010417
;       15.272917       16.375000       19.043750       19.554167       23.050000
;       19.072917       27.997917       26.510417       28.102083       30.856250
;       31.802083       25.108333       25.293750       22.693750       19.110417
;       18.729167       16.010417       17.768750       18.354167       18.485417
;       21.216667       20.295833       24.214583       22.639583       30.535417
;       28.404167       29.118750       31.979167       27.589583       24.554167
;       23.527083       25.737500       19.122917       13.495833       12.335417
;       11.556250       11.425000       12.541667       13.222917       14.950000
;       19.022917       17.727083       18.860417       18.885417       16.179167
;       13.704167       13.006250       12.979167       11.418750       11.712500
;       7.7083333       10.162500       6.9875000       8.8083333       8.2166667
;       8.2729167       9.3000000       8.6687500       10.072917       11.120833
;       9.7312500       9.7750000       8.6833333       7.6020833       6.3687500
;       7.4062500       5.9750000       6.4750000       7.3354167       6.8500000
;       8.0708333       7.0895833       0.0000000       0.0000000       0.0000000
;       0.0000000
help,maximus
print,min(maximus.orbit,max=maxOrb) & print,maxOrb
;     500
;   14979
.full_reset_session
; % Program caused arithmetic error: Floating divide by 0
;Data dir set to /SPENCEdata2/Research/Cusp/database/
.run "/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plot_alfven_stats_imf_screening.pro"
; % Syntax error.
; % 1 Compilation error(s) in module PLOT_ALFVEN_STATS_IMF_SCREENING.
help,/breakpoints
.run "/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/scripts_for_processing_Dartmouth_data/get_fastloc_inds__IMF_conds.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp313072Mr' else if _v.path eq '' then restore,'/tmp/idltemp313072Mr'
; % Attempt to call undefined procedure: 'IDLWAVE_ROUTINE_INFO'.
idlwave_routine_info,'/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/scripts_for_processing_Dartmouth_data/get_fastloc_inds__IMF_conds.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-FUN: GET_FASTLOC_INDS__IMF_CONDS<@><@>/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/scripts_for_processing_Dartmouth_data/get_fastloc_inds__IMF_conds.pro<@>Result = %s()<@> ANGLELIM1 ANGLELIM2 BYMIN CLOCKSTR DELAY FASTLOCDIR FASTLOCFILE FASTLOCTIMEFILE INCL
;UDENOCONSECDATA MAKE_OUTINDSFILE OMNI_COORDS SATELLITE SMOOTHWINDOW STABLEIMF
;>>>END OF IDLWAVE ROUTINE INFO
.run "/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp313072Mr' else if _v.path eq '' then restore,'/tmp/idltemp313072Mr'
idlwave_routine_info,'/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN CHAREPLOTRANGE CHAREPLOTS
; CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPERMIN LOGNEVENTPERORB LOGNEVENT
;SPLOT LOGPFPLOT LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLUX NOPLOTSJUSTDATA NOPOSCHARE 
;NOPOSEFLUX NOPOSIFLUX NOPOSPFLUX NOSAVEPLOTS NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS RA
;WDIR SATELLITE SAVERAW SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
plot_alfven_stats_imf_screening,CLOCKSTR="duskward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5
;Can't do nEventPerOrbPlot without nPlots!!
;Enabling nPlots...
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;There are 85668 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 62486 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;11814 events with IMF predominantly duskward.
;There are 11415 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 291 unique orbits in the data you've provided for predominantly duskward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 89.0000
;Hemisphere: North
;IMF Predominance: duskward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 291
;Total number of events used: 11415
;Percentage of current DB used: 1.39238%
;****From interp_mag_data_for_fastloc.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 2401287 time segments because of minimum By requirement.
;****END text from interp_mag_data_for_fastloc.pro****
;****From check_imf_stability_for_fastloc.pro****
;295827 time segments with IMF predominantly duskward.
;There are 294300 time segments prior to which we have  at least 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability_for_fastloc.pro****
;Current directory is /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/
;Creating output files...
;PostScript output will be created here: 
;plots/nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
;PostScript output will be created here: 
;plots/nEvents_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEvents_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
plot_alfven_stats_imf_screening,CLOCKSTR="dawnward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5,/del_ps
;Can't do nEventPerOrbPlot without nPlots!!
;Enabling nPlots...
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;There are 85668 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 62486 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;9639 events with IMF predominantly dawnward.
;There are 9272 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 269 unique orbits in the data you've provided for predominantly dawnward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 89.0000
;Hemisphere: North
;IMF Predominance: dawnward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 269
;Total number of events used: 9272
;Percentage of current DB used: 1.13098%
;****From interp_mag_data_for_fastloc.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 2401287 time segments because of minimum By requirement.
;****END text from interp_mag_data_for_fastloc.pro****
;****From check_imf_stability_for_fastloc.pro****
;288945 time segments with IMF predominantly dawnward.
;There are 287522 time segments prior to which we have  at least 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability_for_fastloc.pro****
;Current directory is /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/
;Creating output files...
;PostScript output will be created here: 
;plots/nEventPerMinNorth_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEventPerMinNorth_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
;PostScript output will be created here: 
;plots/nEvents_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEvents_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
plot_alfven_stats_imf_screening,CLOCKSTR="dawnward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5,/del_ps,/logneventpermin
;Can't do nEventPerOrbPlot without nPlots!!
;Enabling nPlots...
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;There are 85668 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 62486 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;9639 events with IMF predominantly dawnward.
;There are 9272 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 269 unique orbits in the data you've provided for predominantly dawnward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 89.0000
;Hemisphere: North
;IMF Predominance: dawnward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 269
;Total number of events used: 9272
;Percentage of current DB used: 1.13098%
;****From interp_mag_data_for_fastloc.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 2401287 time segments because of minimum By requirement.
;****END text from interp_mag_data_for_fastloc.pro****
;****From check_imf_stability_for_fastloc.pro****
;288945 time segments with IMF predominantly dawnward.
;There are 287522 time segments prior to which we have  at least 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability_for_fastloc.pro****
;Current directory is /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/
;Creating output files...
;PostScript output will be created here: 
;plots/Log nEventPerMinNorth_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/Log nEventPerMinNorth_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
;PostScript output will be created here: 
;plots/nEvents_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEvents_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
plot_alfven_stats_imf_screening,CLOCKSTR="duskward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5,/del_ps,/logneventpermin
;Can't do nEventPerOrbPlot without nPlots!!
;Enabling nPlots...
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;There are 85668 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 62486 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;11814 events with IMF predominantly duskward.
;There are 11415 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 291 unique orbits in the data you've provided for predominantly duskward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 89.0000
;Hemisphere: North
;IMF Predominance: duskward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 291
;Total number of events used: 11415
;Percentage of current DB used: 1.39238%
;****From interp_mag_data_for_fastloc.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 2401287 time segments because of minimum By requirement.
;****END text from interp_mag_data_for_fastloc.pro****
;****From check_imf_stability_for_fastloc.pro****
;295827 time segments with IMF predominantly duskward.
;There are 294300 time segments prior to which we have  at least 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability_for_fastloc.pro****
;h2dStr.Log N Events per minute has 77 elements that are zero, whereas FluxN has 
;74.
;Sorry, can't plot anything meaningful.
;Current directory is /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/
;Creating output files...
;PostScript output will be created here: 
;plots/Log nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/Log nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
;PostScript output will be created here: 
;plots/nEvents_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/nEvents_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
.run "/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp313072Mr' else if _v.path eq '' then restore,'/tmp/idltemp313072Mr'
idlwave_routine_info,'/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN CHAREPLOTRANGE CHAREPLOTS
; CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPERMIN LOGNEVENTPERORB LOGNEVENT
;SPLOT LOGPFPLOT LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLUX NOPLOTSJUSTDATA NOPOSCHARE 
;NOPOSEFLUX NOPOSIFLUX NOPOSPFLUX NOSAVEPLOTS NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS RA
;WDIR SATELLITE SAVERAW SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
plot_alfven_stats_imf_screening,CLOCKSTR="duskward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5,/del_ps,/logneventpermin
;Can't do nEventPerOrbPlot without nPlots!!
;Enabling nPlots...
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000
;Max altitude: 5000
;Min characteristic electron energy: 4
;Max characteristic electron energy: 300
;There are 85668 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 62486 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;11814 events with IMF predominantly duskward.
;There are 11415 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 291 unique orbits in the data you've provided for predominantly duskward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 89.0000
;Hemisphere: North
;IMF Predominance: duskward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 291
;Total number of events used: 11415
;Percentage of current DB used: 1.39238%
;****From interp_mag_data_for_fastloc.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 2401287 time segments because of minimum By requirement.
;****END text from interp_mag_data_for_fastloc.pro****
;****From check_imf_stability_for_fastloc.pro****
;295827 time segments with IMF predominantly duskward.
;There are 294300 time segments prior to which we have  at least 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability_for_fastloc.pro****
;h2dStr.Log N Events per minute has 77 elements that are zero, whereas FluxN has 
;74.
;Sorry, can't plot anything meaningful.
;Current directory is /SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/
;Creating output files...
;PostScript output will be created here: 
;plots/Log nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: plots/Log nEventPerMinNorth_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.png
;PostScript output will be created here: 
;plots/nEvents_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_9_15.ps
;Output file located here: pl
