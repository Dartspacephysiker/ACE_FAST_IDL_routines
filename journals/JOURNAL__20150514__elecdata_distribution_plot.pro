; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST
; Date: Thu May 14 08:51:51 2015
 
;plot_alfven_stats_imf_screening,bymin=5,clockstr='duskward',/logavgplot,/eplots,/pplots,/logefplot,/logpfplot
;that's the command I used
;I inserted a break on this line too:
;           elecData=(KEYWORD_SET(logAvgPlot)) ? alog10(maximus.elec_energy_flux(plot_i)) : maximus.elec_energy_flux(plot_i)
(maximus.elec_energy_flux(plot_i))(0)
;       4.3605099
elecdata(0)
;      0.63953727
10^elecdata(0)
;       4.3605099
;OK, looks nice
print,max(elecdata)
;      1.50593
print,10^max(elecdata)
;      32.0576
print,max(maximus.elec_energy_flux)
;      113914.
print,max(maximus.elec_energy_flux(plot_i))
;      32.0576
print,n_elements(where(maximus.elec_energy_flux GT 300))
;         704
print,n_elements(where(maximus.elec_energy_flux GT 200))
;        1223
print,n_elements(where(maximus.elec_energy_flux GT 100))
;        2379
print,n_elements(where(maximus.elec_energy_flux GT 10))
;       36394
print,n_elements(where(maximus.elec_energy_flux GT 1))
;      283763
print,n_elements(where(maximus.elec_energy_flux GT 0.1))
;      724799
print,n_elements(where(maximus.integ_elec_energy_flux GT 0.1))
;      646079
print,n_elements(where(maximus.integ_elec_energy_flux GT 1))
;      248170
print,n_elements(where(maximus.integ_elec_energy_flux GT 10))
;       28191
print,n_elements(where(maximus.integ_elec_energy_flux GT 100))
;        1760
print,n_elements(where(maximus.integ_elec_energy_flux GT 1000))
;         143
print,n_elements(where(maximus.integ_elec_energy_flux GT 10000))
;          15
print,n_elements(where(elecdata GT 10000))
;           1
print,n_elements(where(elecdata GT 10000),/null)
; % Keyword parameters not allowed in call.
print,n_elements(where(elecdata GT 10000,/null))
;           0
print,n_elements(where(elecdata GT 1000,/null))
;           0
print,n_elements(where(elecdata GT 100,/null))
;           0
print,n_elements(where(elecdata GT 10,/null))
;           0
print,n_elements(where(elecdata GT 1,/null))
;         119
print,n_elements(where(10^elecdata GT 1,/null))
;        3976
print,n_elements(where(10^elecdata GT 10,/null))
;         119
print,n_elements(where(10^elecdata GT 100,/null))
;           0
cghistoplot,elecdata,maxinput=1.6,title='Electron energy flux histogram for duskward IMF, Bymin=5 nT'
cghistoplot,elecdata,maxinput=1.6,title='Electron energy flux histogram for duskward IMF, Bymin=5 nT',output='elec_energy_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/elec_energy_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/elec_energy_flux_histo--duskward--byMin5.png
cghistoplot,elecdata,maxinput=1.6,title='Log(Electron energy flux) histogram for duskward IMF, Bymin=5 nT',output='log_elec_energy_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/log_elec_energy_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/log_elec_energy_flux_histo--duskward--byMin5.png
cghistoplot,10^elecdata,maxinput=35,title='Electron energy flux histogram for duskward IMF, Bymin=5 nT',output='elec_energy_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/elec_energy_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/elec_energy_flux_histo--duskward--byMin5.png
cghistoplot,10^elecdata,maxinput=35,title='Electron energy flux histogram for duskward IMF, Bymin=5 nT'
.run "/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp15800m8w' else if _v.path eq '' then restore,'/tmp/idltemp15800m8w'
idlwave_routine_info,'/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN BZMIN CHAREPLOTRANGE C
;HAREPLOTS CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE JUSTDATA LOGAVGPLOT LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPER
;MIN LOGNEVENTPERORB LOGNEVENTSPLOT LOGPFPLOT LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLU
;X NOPOSCHARE NOPOSEFLUX NOPOSIFLUX NOPOSPFLUX NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS R
;AWDIR SATELLITE SAVERAW SHOWPLOTSNOSAVE SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
help,/breakpoints
breakpoint,/clear,0
breakpoint,/clear,1
help,/breakpoints
.run "/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp15800m8w' else if _v.path eq '' then restore,'/tmp/idltemp15800m8w'
idlwave_routine_info,'/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN BZMIN CHAREPLOTRANGE C
;HAREPLOTS CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE JUSTDATA LOGAVGPLOT LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPER
;MIN LOGNEVENTPERORB LOGNEVENTSPLOT LOGPFPLOT LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLU
;X NOPOSCHARE NOPOSEFLUX NOPOSIFLUX NOPOSPFLUX NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS R
;AWDIR SATELLITE SAVERAW SHOWPLOTSNOSAVE SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
help,/breakpoints
breakpoint,'/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro',845
help,/breakpoints
print,(routine_info('PLOT_ALFVEN_STATS_IMF_SCREENING',/SOURCE)).PATH
;/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro
.run "/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp15800m8w' else if _v.path eq '' then restore,'/tmp/idltemp15800m8w'
idlwave_routine_info,'/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN BZMIN CHAREPLOTRANGE C
;HAREPLOTS CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE JUSTDATA LOGAVGPLOT LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPER
;MIN LOGNEVENTPERORB LOGNEVENTSPLOT LOGPFPLOT LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLU
;X NOPOSCHARE NOPOSEFLUX NOPOSIFLUX NOPOSPFLUX NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS R
;AWDIR SATELLITE SAVERAW SHOWPLOTSNOSAVE SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
plot_alfven_stats_imf_screening,bymin=5,clockstr='duskward',/logavgplot,/eplots,/pplots,/logefplot,/logpfplot
;Warning!: You're trying to do log Eflux plots but you don't have 'absEflux', 'noNegEflux', or 'noPosEflux' set!
;Can't make log plots without using absolute value or only positive values...
;Default: junking all negative Eflux values
;Warning!: You're trying to do log Pflux plots but you don't have 'absPflux', 'noNegPflux', or 'noPosPflux' set!
;Can't make log plots without using absolute value or only positive values...
;Default: junking all negative Pflux values
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;There are 85237 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;ByMin magnitude requirement: 5 nT
;Losing 61954 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;11309 events with IMF predominantly duskward.
;There are 10903 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 298 unique orbits in the data you've provided for predominantly duskward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 84.0000
;Hemisphere: North
;IMF Predominance: duskward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 298
;Total number of events used: 10903
;Percentage of current DB used: 1.32993%
;Lost 1 events to NaNs in data...
;Found some NaNs in Poynting flux! Losing another 25982 events...
.so 1
print,max(pfluxest)
;      5.27332
cghistoplot,10^pfluxEst,maxinput=35,title='Poynting flux histogram for duskward IMF, Bymin=5 nT'
cghistoplot,10^pfluxEst,maxinput=10,title='Poynting flux histogram for duskward IMF, Bymin=5 nT'
cghistoplot,10^elecdata,maxinput=10,title='Poynting flux histogram for duskward IMF, Bymin=5 nT',output='poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
cghistoplot,10^elecdata,maxinput=10,title='Log(Poynting flux) histogram for duskward IMF, Bymin=5 nT',output='log_poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
cghistoplot,10^pfluxest,maxinput=10,title='Log(Poynting flux) histogram for duskward IMF, Bymin=5 nT',output='log_poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
cghistoplot,pfluxest,maxinput=10,title='Log(Poynting flux) histogram for duskward IMF, Bymin=5 nT',output='log_poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
cghistoplot,10^pfluxest,maxinput=1000,title='Poynting flux histogram for duskward IMF, Bymin=5 nT',output='poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
cghistoplot,10^pfluxest,maxinput=1000,title='Poynting flux histogram for duskward IMF, Bymin=5 nT'
cghistoplot,10^pfluxest,maxinput=100,title='Poynting flux histogram for duskward IMF, Bymin=5 nT'
cghistoplot,10^pfluxest,maxinput=10,title='Poynting flux histogram for duskward IMF, Bymin=5 nT'
cghistoplot,10^pfluxest,maxinput=10,title='Poynting flux histogram for duskward IMF, Bymin=5 nT',output='poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
cghistoplot,10^pfluxest(plot_i),maxinput=10,title='Poynting flux histogram for duskward IMF, Bymin=5 nT',output='poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/poynt_flux_histo--duskward--byMin5.png
cghistoplot,pfluxest(plot_i),maxinput=10,title='Log(Poynting flux) histogram for duskward IMF, Bymin=5 nT',output='log_poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
cghistoplot,pfluxest(plot_i),maxinput=3,title='Log(Poynting flux) histogram for duskward IMF, Bymin=5 nT',output='log_poynt_flux_histo--duskward--byMin5.png'
;Output file located here: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
;Output File: /SPENCEdata/Research/Cusp/ACE_FAST/log_poynt_flux_histo--duskward--byMin5.png
print,10^0.4
;      2.51189
print,alog10(2.5)
;     0.397940
print,alog10(0.01)
;     -2.00000
print,alog10(0.03)
;     -1.52288
.run "/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp15800m8w' else if _v.path eq '' then restore,'/tmp/idltemp15800m8w'
idlwave_routine_info,'/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN BZMIN CHAREPLOTRANGE C
;HAREPLOTS CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE JUSTDATA LOGAVGPLOT LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPER
;MIN LOGNEVENTPERORB LOGNEVENTSPLOT LOGPFPLOT LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLU
;X NOPOSCHARE NOPOSEFLUX NOPOSIFLUX NOPOSPFLUX NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS R
;AWDIR SATELLITE SAVERAW SHOWPLOTSNOSAVE SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
help,/breakpoints
breakpoint,/clear,0
help,/breakpoints
.run "/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro"
help,/breakpoints
if execute("_v=routine_info('idlwave_routine_info',/SOURCE)") eq 0 then restore,'/tmp/idltemp15800m8w' else if _v.path eq '' then restore,'/tmp/idltemp15800m8w'
idlwave_routine_info,'/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro'
;>>>BEGIN OF IDLWAVE ROUTINE INFO ("<@>" IS THE SEPARATOR)
;IDLWAVE-PRO: PLOT_ALFVEN_STATS_IMF_SCREENING<@><@>/home/spencerh/Research/Cusp/ACE_FAST/plot_alfven_stats_imf_screening.pro<@>%s, MAXIMUS<@> ABSCHARE ABSEFLUX ABSIFLUX ABSPFLUX ALTITUDERANGE ANGLELIM1 ANGLELIM2 BINILAT BINMLT BYMIN BZMIN CHAREPLOTRANGE C
;HAREPLOTS CHARERANGE CHARETYPE CLOCKSTR DATADIR DBFILE DELAY DEL_PS DIVNEVBYAPPLICABLE DO_CHASTDB EFLUXPLOTTYPE EPLOTRANGE EPLOTS HEMI IFLUXPLOTTYPE INCLUDENOCONSECDATA IONPLOTS IPLOTRANGE JUSTDATA LOGAVGPLOT LOGCHAREPLOT LOGEFPLOT LOGIFPLOT LOGNEVENTPER
;MIN LOGNEVENTPERORB LOGNEVENTSPLOT LOGPFPLOT LOGPLOT MASKMIN MAXILAT MAXMLT MEDHISTOUTDATA MEDHISTOUTTXT MEDIANPLOT MINILAT MINMLT MIN_NEVENTS NEVENTPERMINPLOT NEVENTPERORBPLOT NEVENTPERORBRANGE NEVENTSPLOTRANGE NONEGCHARE NONEGEFLUX NONEGIFLUX NONEGPFLU
;X NOPOSCHARE NOPOSEFLUX NOPOSIFLUX NOPOSPFLUX NPLOTS NUMORBLIM OMNI_COORDS ORBCONTRIBPLOT ORBCONTRIBRANGE ORBFREQPLOT ORBFREQRANGE ORBRANGE ORBTOTPLOT ORBTOTRANGE OUTPUTPLOTSUMMARY PLOTDIR PLOTPREFIX PLOTSUFFIX POLARCONTOUR POYNTRANGE PPLOTRANGE PPLOTS R
;AWDIR SATELLITE SAVERAW SHOWPLOTSNOSAVE SMOOTHWINDOW SQUAREPLOT STABLEIMF WRITEASCII WRITEHDF5 WRITEPROCESSEDH2D _EXTRA
;>>>END OF IDLWAVE ROUTINE INFO
plot_alfven_stats_imf_screening,bymin=5,clockstr='duskward',/logavgplot,/eplots,/pplots,/logefplot,/logpfplot
;Warning!: You're trying to do log Eflux plots but you don't have 'absEflux', 'noNegEflux', or 'noPosEflux' set!
;Can't make log plots without using absolute value or only positive values...
;Default: junking all negative Eflux values
;Warning!: You're trying to do log Pflux plots but you don't have 'absPflux', 'noNegPflux', or 'noPosPflux' set!
;Can't make log plots without using absolute value or only positive values...
;Default: junking all negative Pflux values
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;****From alfven_db_cleaner.pro****
;Lost 27711 events to NaNs and infinities...
;Lost 1565 events to user-defined cutoffs for various quantities...
;****END alfven_db_cleaner.pro****
;****From get_chaston_ind.pro****
;DBFile = Dartdb_02282015--500-14999--maximus.sav
;Min altitude: 1000.00
;Max altitude: 5000.00
;Min characteristic electron energy: 4.00000
;Max characteristic electron energy: 300.000
;There are 85237 total events making the cut.
;****END get_chaston_ind.pro****
;****From interp_mag_data.pro****
;ByMin magnitude requirement: 5 nT
;Losing 61954 events because of minimum By requirement.
;****END text from interp_mag_data.pro****
;****From check_imf_stability.pro****
;11309 events with IMF predominantly duskward.
;There are 10903 events prior to which we have 1 minutes of consecutive mag data.
;Losing 0 events associated with unstable IMF.
;****END check_imf_stability.pro****
;There are 298 unique orbits in the data you've provided for predominantly duskward IMF.
;**********DATA SUMMARY**********
;OMNI satellite data delay: 660 seconds
;IMF stability requirement: 1 minutes
;Events per bin requirement: >= 1 events
;Screening parameters: [Min] [Max]
;Mag current: -10 10
;MLT: 6.00000 18.0000
;ILAT: 60.0000 84.0000
;Hemisphere: North
;IMF Predominance: duskward
;Angle lim 1: 45.0000
;Angle lim 2: 135.000
;Number of orbits used: 298
;Total number of events used: 10903
;Percentage of current DB used: 1.32993%
;Lost 1 events to NaNs in data...
;Found some NaNs in Poynting flux! Losing another 25982 events...
;h2dStr.AbsNoPos--Log Poynting Flux (mW/m!U2!N) has 82
; elements that are zero, whereas FluxN has 87.
;Sorry, can't plot anything meaningful.
;Current directory is /SPENCEdata/Research/Cusp/ACE_FAST/plots/
;Creating output files...
;PostScript output will be created here: 
;plots/NoNegs--LogeFluxMax_North_logAvg_duskward--1stable--OMNI_GSM_byMin_5.0_May_14_15.ps
;Output file located here: plots/NoNegs--LogeFluxMax_North_logAvg_duskward--1stable--OMNI_GSM_byMin_5.0_May_14_15.png
;PostScript output will be created here: 
;plots/AbsNoPos--LogpFlux_North_logAvg_duskward--1stable--OMNI_GSM_byMin_5.0_May_14_15.ps
;Output file located here: plots/AbsNoPos--LogpFlux_North_logAvg_duskward--1stable--OMNI_GSM_byMin_5.0_May_14_15.png
