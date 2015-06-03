;From meeting with Professor LaBelle, Feb 11 2015
;We were exploring the Alfvèn database, and he had me make a few histograms
restore,"scripts_for_processing_Dartmouth_data/Dartdb_02042015--first11465--maximus.sav"
cghistoplot,maximus.width_time
cghistoplot,maximus.width_time,maxinput=5
cghistoplot,maximus.width_time,maxinput=1
cghistoplot,maximus.width_time,maxinput=5,binsize=0.5
cghistoplot,maximus.width_time,maxinput=5,binsize=0.25
cghistoplot,maximus.width_time,maxinput=5,binsize=0.1,mininput=0.1
cghistoplot,maximus.width_time,maxinput=5,binsize=0.01,mininput=0.1
cghistoplot,maximus.width_time,binsize=0.01,maxinput=0.1
cghistoplot,maximus.width_time,binsize=0.01,maxinput=0.5
maximus.width_time(uniq(maximus.width_time(sort(maximus.width_time))))
cghistoplot,maximus.width_time,maxinput=5
cghistoplot,maximus.width_time,maxinput=5,xtitle="Time (s)"
cghistoplot,maximus.width_time,maxinput=5,xtitle="Time (s)",filename="current_event_histo.png"
cghistoplot,maximus.db,maxinput=5,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,maxinput=5,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,maxinput=1e4,xtitle="dB (nT)"
print,n_elements(where(maximus.delta_b GT 1e4))
cghistoplot,maximus.delta_b,maxinput=1e2,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,maxinput=10,xtitle="dB (nT)"
print,maximus.delta_b(where(maximus.delta_b LE 5))
print,maximus.orbit(where(maximus.delta_b LE 5))
print,maximus.delta_b(where(maximus.mag_current GE 10))
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10))
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=1e2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=15
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=6,binsize=0.2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=9,binsize=0.2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=12,binsize=0.2,
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=12,binsize=0.2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=12,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 20)),maxinput=40,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 30)),maxinput=40,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 3)),maxinput=40,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 3)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 15)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 15)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.alt GE 1000 AND maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.alt GE 1000 AND maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 30)),maxinput=16,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 30)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 20)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 10)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 5)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 3)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 5)),maxinput=30,binsize=0.2,mininput=8
exit
