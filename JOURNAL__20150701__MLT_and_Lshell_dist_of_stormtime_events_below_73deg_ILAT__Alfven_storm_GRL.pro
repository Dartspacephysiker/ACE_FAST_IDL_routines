;2015/07/01
;This journal should result in one of the figures for the GRL we're trying to write on the Alfvénic response to large storms.
;Chris Chaston's idea is that we should change the x axis of the ILAT histograms to L-shell. (The conversion, you recall,
;is lshell=(cos(ilat*!PI/180.))^(-2)

;All those storms
dataDir='/SPENCEdata/Research/Cusp/database/'
;; restore,'superposed_largestorms_-15_to_5_hours.dat'
restore,'superposed_large_storm_output_w_n_Alfven_events--arreglado--HEAVILY_PARED--neg5_to_20hours--20150701.dat'

largeStorm_ind=tot_plot_i_list(0)
FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO largeStorm_ind=[largeStorm_ind,tot_plot_i_list(i)]

restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'
largestorm_ind=cgsetintersection(largestorm_ind,where(ABS(maximus.ILAT) LT 73))

pos=[0.15,0.15,0.95,0.925] ;Position of histos in window

;**************************************************
;For overlaid plots

;; xRange_lShell=[0,40]
xRange_MLT=[0,24]
;; xRange_ILAT=[50,90]

yRange_MLT_ILAT=[0,0.25]
;; yRange_lShell=[0.,0.15]

;; binSize_lShell=1
;; binSize_ILAT=2
binSize_MLT=1
;**************************************************
;L-SHELL

;; lShell=(cos(maximus.ilat*!PI/180.))^(-2)

;; cghistoplot,lShell(largeStorm_ind),/OPROBABILITY, $
;;             BINSIZE=binSize_lShell,OUTPUT='L-SHELL--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png', $
;;             CHARSIZE=2.5,THICK=2.0
;; ;Southern
;; cghistoplot,lShell,MAXINPUT=xRange_lShell[1],MININPUT=xRange_lShell[0], $
;;             /OPROBABILITY, $    ;Southern hemi
;;             BINSIZE=binSize_lShell,OUTPUT='L-SHELL--Southern--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'

;; cghistoplot,ABS(lShell(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0)))),MAXINPUT=xRange_lShell[1],MININPUT=xRange_lShell[0], $
;;             /OPROBABILITY, $    ;Southern hemi
;;             BINSIZE=binSize_lShell,OUTPUT='L-SHELL--Southern--reversed--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'

;; ;Northern
;; cghistoplot,lShell(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0))),MAXINPUT=xRange_lShell[1],MININPUT=xRange_lShell[0], $
;;             /OPROBABILITY, $    ;Northern
;;             BINSIZE=binSize_lShell,OUTPUT='L-SHELL--Northern--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'

;**************************************************
;ILAT

;; cghistoplot,maximus.ilat(largeStorm_ind),/OPROBABILITY, $
;;             BINSIZE=binSize_ILAT,OUTPUT='ILAT--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png',CHARSIZE=2.5,THICK=2.0
;; ;Southern
;; cghistoplot,maximus.ilat,MAXINPUT=-xRange_ILAT[0],MININPUT=-xRange_ILAT[1],/OPROBABILITY, $   ;Southern hemi
;;             BINSIZE=binSize_ILAT,OUTPUT='ILAT--Southern--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'

;; cghistoplot,ABS(maximus.ilat(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0)))),MAXINPUT=xRange_ILAT[1],MININPUT=xRange_ILAT[0], $
;;             /OPROBABILITY, $    ;Southern hemi
;;             BINSIZE=binSize_ILAT,OUTPUT='ILAT--Southern--reversed--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'

;; ;Northern
;; cghistoplot,maximus.ilat(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0))), $
;;             MAXINPUT=xRange_ILAT[1],MININPUT=xRange_ILAT[0], $
;;             /OPROBABILITY, $    ;Northern
;;             BINSIZE=binSize_ILAT,OUTPUT='ILAT--Northern--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'

;**************************************************
;MLT
cghistoplot,maximus.mlt(largestorm_ind), $                                            ;South
            /OPROBABILITY,BINSIZE=binSize_MLT,OUTPUT='MLT--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'
cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat GT 0))), $ ;South
            /OPROBABILITY,BINSIZE=binSize_MLT,OUTPUT='MLT--Northern--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'
cghistoplot,maximus.mlt(cgsetintersection(largestorm_ind,where(maximus.ilat LT 0))), $ ;North
            /OPROBABILITY,BINSIZE=binSize_MLT,OUTPUT='MLT--Southern--below_73_deg_ILAT--histogram_and_cdf--large_storms--HEAVILY_PARED--1996-10-23_through_2000-10-05.png'

;****************************************
;good_i
good_i_all=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/BOTH_HEMIS)
good_i_south=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/SOUTH)
good_i_north=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/NORTH)

;**************************************************
;overlay the two MLT plots
data_1_ind=largeStorm_ind
data_1=maximus.mlt(data_1_ind)

data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
data_2=maximus.mlt(data_2_ind)

data_1_col='yellow'
data_2_col='olive'

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_all),/REMOVE_ALL)
data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

histTitle='Relative freq. of activity'

BINSIZE=binSize_MLT
yRange=yRange_MLT_ILAT
xRange=xRange_MLT
xTitle='MLT'
outFile='MLT--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile,POS=pos

;just northern
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
data_1=maximus.mlt(data_1_ind)

data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
data_2=maximus.mlt(data_2_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_north),/REMOVE_ALL)
data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

histTitle='Relative freq. of activity, Northern'

outFile='MLT--Northern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile,POS=pos

;just southern
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
data_1=maximus.mlt(data_1_ind)

data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
data_2=maximus.mlt(data_2_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_south),/REMOVE_ALL)
data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

histTitle='Relative freq. of activity, Southern'

outFile='MLT--Southern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'
OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile,POS=pos

;**************************************************
;overlay two L-SHELL plots

;; data_1_ind=largeStorm_ind
;; data_1=lShell(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
;; data_2=lShell(data_2_ind)

;; data_1_col='yellow'
;; data_2_col='olive'

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

;; histTitle='Relative freq. of activity'

;; binsize=binSize_lShell
;; ;; XRANGE=[-90,90]
;; XRANGE=xRange_lShell
;; yRange=yRange_lShell
;; xTitle='L-SHELL'
;; outFile='L-SHELL--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos


;; ;just northern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
;; data_1=lShell(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
;; data_2=lShell(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; ;; xRange=[50,90]
;; xRange=xRange_lShell
;; histTitle='Relative freq. of activity, Northern'

;; outFile='L-SHELL--Northern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos

;; ;just southern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
;; data_1=lShell(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
;; data_2=lShell(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; xRange=xRange_lShell
;; ;; xRange=[-90,-50]
;; histTitle='Relative freq. of activity, Southern'

;; outFile='L-SHELL--Southern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'
;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos


;**************************************************
;;overlay two ILAT plots

;; data_1_ind=largeStorm_ind
;; data_1=maximus.ilat(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
;; data_2=maximus.ilat(data_2_ind)

;; data_1_col='yellow'
;; data_2_col='olive'

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

;; histTitle='Relative freq. of activity'

;; binsize=binSize_ILAT
;; XRANGE=[-xRange_ILAT[1],xRange_ILAT[1]]
;; yRange=yRange_MLT_ILAT
;; xTitle='ILAT'
;; outFile='ILAT--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos


;;just northern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
;; data_1=maximus.ilat(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
;; data_2=maximus.ilat(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; XRANGE=xRange_ILAT
;; histTitle='Relative freq. of activity, Northern'

;; outFile='ILAT--Northern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos

;;just southern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
;; data_1=maximus.ilat(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
;; data_2=maximus.ilat(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; xRange=-REVERSE(xRange_ILAT)
;; histTitle='Relative freq. of activity, Southern'

;; outFile='ILAT--Southern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'
;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos
