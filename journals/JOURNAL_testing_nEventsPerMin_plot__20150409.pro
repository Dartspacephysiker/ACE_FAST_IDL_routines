; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data
; Date: Thu Apr  9 15:17:13 2015
 
plot_alfven_stats_imf_screening,CLOCKSTR=dawnward,altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5
;{       1}
;Why the extra parameters? They have no home...
.run "/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp313072Mr' else if _v.path eq '' then restore,'/tmp/idltemp313072Mr'
idlwave_routine_info,'/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: $MAIN$<@><@>/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro<@>%s<@>
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN CHAREPLOTRANGE CHAREPLOTS
; CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPERORB LOGNEVENTSPLOT LOGPFPLOT 
;LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLUX NOPLOTSJUSTDATA NOPOSCHARE NOPOSEFLUX NOPOS
;IFLUX NOPOSPFLUX NOSAVEPLOTS NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS RAWDIR SATELLITE S
;AVERAW SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
plot_alfven_stats_imf_screening,CLOCKSTR=dawnward,altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT,SMOOTHWINDOW=5
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
;There are 85661 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;Smooth window is set to 5 minutes
;ByMin magnitude requirement: 5 nT
;Losing 62486 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;9638 events with IMF predominantly dawnward.
;There are 9271 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 268 unique orbits in the data you've provided for predominantly dawnward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 88.0000
;Hemisphere: North
;IMF Predominance: dawnward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 268
;Total number of events used: 9271
;Percentage of current DB used: 1.13086%
;Restoring fastLoc_intervals2--dawnward_45.00-135.00deg--OMNI_GSM--byMin_5.0--stableIMF_1min--delay_660--smoothWindow_5min.sav...
; % Variable is undefined: NEVBYAPPSTR.
     IF keepMe THEN dataName=[dataName,logNEvStr + "nEventPerMin"] 
.skip
help,/trace
help,/breakpoints
help,/breakpoints
breakpoint,'/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro',1350,/once
help,/breakpoints
print,(routine_info('PLOT_ALFVEN_STATS_IMF_SCREENING',/SOURCE)).PATH
;/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro
.c
help,/trace
help,/breakpoints
help,/breakpoints
breakpoint,'/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro',1361,/once
help,/breakpoints
print,(routine_info('PLOT_ALFVEN_STATS_IMF_SCREENING',/SOURCE)).PATH
;/SPENCEdata/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro
.c
help,/trace
help,/breakpoints
.o
; % SAVE: Error opening file. Unit: 101
;         File: temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OM
;         NI_GSM_byMin_5.0_Apr_ 9_15.dat
;   No such file or directory
.o
; % SAVE: Error opening file. Unit: 101
;         File: temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OM
;         NI_GSM_byMin_5.0_Apr_ 9_15.dat
;   No such file or directory
.so 1
; % SAVE: Error opening file. Unit: 101
;         File: temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OM
;         NI_GSM_byMin_5.0_Apr_ 9_15.dat
;   No such file or directory
.full_reset_session
;Data dir set to /SPENCEdata2/Research/Cusp/database/
