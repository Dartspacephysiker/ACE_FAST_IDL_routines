;2015/06/18
;Professor LaBelle is pretty interested in looking into how stormtime Alfvén events are distributed in MLT. My personal suspicion
;is that the distribution won't differ significantly from the distribution with no screening whatsoever. I am prepared to be corrected.

;All those storms
restore,'superposed_largestorms_-15_to_5_hours.dat'
largeStorm_ind=tot_plot_i_list(0)
FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO largeStorm_ind=[largeStorm_ind,tot_plot_i_list(i)]

restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'
largestorm_ind=cgsetintersection(largestorm_ind,where(maximus.max_chare_losscone GE 4 AND maximus.max_chare_losscone LE 5000))

;**************************************************
;ILAT
cghistoplot,maximus.ilat(largestorm_ind),/OPROBABILITY, $
            BINSIZE=2,OUTPUT='ILAT--histogram_and_cdf--large_storms--1996-10-23_through_2000-10-05.png'

;Southern
cghistoplot,maximus.ilat(largestorm_ind),MAXINPUT=-50,MININPUT=-88,/OPROBABILITY, $   ;Southern hemi
            BINSIZE=2,OUTPUT='ILAT--Southern--histogram_and_cdf--large_storms--1996-10-23_through_2000-10-05.png'
cghistoplot,ABS(maximus.ilat(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0)))),MAXINPUT=88,MININPUT=50,/OPROBABILITY, $   ;Southern hemi
            BINSIZE=2,OUTPUT='ILAT--Southern--reversed--histogram_and_cdf--large_storms--1996-10-23_through_2000-10-05.png'

;Northern
cghistoplot,maximus.ilat(largestorm_ind),MAXINPUT=88,MININPUT=50,/OPROBABILITY, $     ;Northern
            BINSIZE=2,OUTPUT='ILAT--Northern--histogram_and_cdf--large_storms--1996-10-23_through_2000-10-05.png'

;**************************************************
;MLT
cghistoplot,maximus.mlt(largestorm_ind), $                                            ;South
            /OPROBABILITY,BINSIZE=1,OUTPUT='MLT--histogram_and_cdf--large_storms--1996-10-23_through_2000-10-05.png'
cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0))), $ ;South
            /OPROBABILITY,BINSIZE=1,OUTPUT='MLT--Northern--histogram_and_cdf--large_storms--1996-10-23_through_2000-10-05.png'
cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0))), $ ;North
            /OPROBABILITY,BINSIZE=1,OUTPUT='MLT--Southern--histogram_and_cdf--large_storms--1996-10-23_through_2000-10-05.png'


;**************************************************
;overlay the two MLT plots
good_i=get_chaston_ind(maximus,'OMNI',-1,ALTITUDERANGE=[1000,5000],CHARERANGE=[4,5000],/BOTH_HEMIS)
data_1_ind=largeStorm_ind
;
data_2=maximus.mlt(good_i)
data_1=maximus.mlt(data_1_ind)

data_1_col='yellow'
data_2_col='olive'

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i),/REMOVE_ALL)

histTitle='Relative freq. of Alfven activity'

binSize=1.5
yRange=[0,0.25]
xRange=[0,24]
xTitle='MLT'
outFile='MLT--largeStorms_overlaid_w_all_events.png'

OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile

;just northern
good_i=get_chaston_ind(maximus,'OMNI',-1,ALTITUDERANGE=[1000,5000],CHARERANGE=[4,5000],/NORTH)
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))

data_2=maximus.mlt(good_i)
data_1=maximus.mlt(data_1_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i),/REMOVE_ALL)
histTitle='Relative freq. of Alfven activity, Northern hemi'

outFile='MLT--Northern--largeStorms_overlaid_w_all_events.png'

OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile

;just southern
good_i=get_chaston_ind(maximus,'OMNI',-1,ALTITUDERANGE=[1000,5000],CHARERANGE=[4,5000],/SOUTH)
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
data_2=maximus.mlt(good_i)
data_1=maximus.mlt(data_1_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i),/REMOVE_ALL)
histTitle='Relative freq. of Alfven activity, Southern hemi'

outFile='MLT--Southern--largeStorms_overlaid_w_all_events.png'
OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile

;**************************************************
;overlay two ILAT plots
good_i=get_chaston_ind(maximus,'OMNI',-1,ALTITUDERANGE=[1000,5000],CHARERANGE=[4,5000],/BOTH_HEMIS)
data_1_ind=largeStorm_ind
data_2=maximus.ilat(good_i)
data_1=maximus.ilat(data_1_ind)

data_1_col='yellow'
data_2_col='olive'

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i),/REMOVE_ALL)

histTitle='Relative freq. of Alfven activity'

binSize=2
XRANGE=[-90,90]
yRange=[0,0.25]
xTitle='ILAT'
outFile='ILAT--largeStorms_overlaid_w_all_events.png'

OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile


;just northern
good_i=get_chaston_ind(maximus,'OMNI',-1,ALTITUDERANGE=[1000,5000],CHARERANGE=[4,5000],/NORTH)
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))

data_2=maximus.ilat(good_i)
data_1=maximus.ilat(data_1_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i),/REMOVE_ALL)
XRANGE=[50,90]
histTitle='Relative freq. of Alfven activity, Northern hemi'

outFile='ILAT--Northern--largeStorms_overlaid_w_all_events.png'

OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile

;just southern
good_i=get_chaston_ind(maximus,'OMNI',-1,ALTITUDERANGE=[1000,5000],CHARERANGE=[4,5000],/SOUTH)
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
data_2=maximus.ilat(good_i)
data_1=maximus.ilat(data_1_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i),/REMOVE_ALL)
xRange=[-90,-50]
histTitle='Relative freq. of Alfven activity, Southern hemi'

outFile='ILAT--Southern--largeStorms_overlaid_w_all_events.png'
OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile
