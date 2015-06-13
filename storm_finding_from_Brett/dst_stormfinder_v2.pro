;+
;;Title: dst_stormfinder_v2.pro
;
;Author: Brett Anderson
;
;Date Created: 27 February 2015  (based on: dst_stormfinder.pro created 18 April 2014)
;
;Date Last Modified: 13 May 2015
;
;Purpose: Automated program to identify storms using the DST index.
;
;Calling Sequence:
; INPUT:
;	Optional Keywords:
;		setHH2L		set to desired value for HH2L
;		setDD2		set to desired value for DD2
;		stadate		startdate in format: [yyyy,mo,dd,hh,mi,ss]
;		enddate		enddate in format:   [yyyy,mo,dd,hh,mi,ss]
; OUTPUT:
;	arg1_julday		Julday values
;	arg2_dst		DST values
;	arg3_storms		Array identifying DST characteristics
;	arg4_sstimes	Index array (of arg1 and arg2) for when minumum DST of a small storm is identified
;	arg5_lgtimes	Index array (of arg1 and arg2) for when minimum DST of a large storm is identified
;
;Notes:
;
;-


PRO dst_stormfinder_v2, arg1_julday, arg2_dst, arg3_storms, arg4_sstimes, arg5_lgtimes, $
	setHH2L=setHH2L, setDD2=setDD2, stadate=stadate, enddate=enddate
compile_opt defint32, strictarr, logical_predicate, strictarrsubs
close, /all				;just a precaution line
loadct, 39				;load a color template for plotting
device,decomposed=0		;Apply loadct call to plots
filepath='~/IDLWorkspace83/'
filename='try2015_04'
ps=1
IF (keyword_set(ps) eq 1) THEN BEGIN
	set_plot, 'ps'
	device, decomposed=0, color=1, encapsulated=0, landscape=1, inches=1, $
		xsize=9, ysize=6.5, $
		xoffset=1, yoffset=10, $
		file=filepath+'dst_storm_finder/'+filename+'.ps'
ENDIF ELSE BEGIN
	device, decomposed=0   ;Apply loadct call to plots
	window, 0, title='xwin0', xsize=704, ysize=396, xpos=2256, ypos=925
ENDELSE


;Define colors
;If "loadct, 39" is used:
color_blk = 0		;black
color_blu = 60		;blue
color_grn = 135		;green
color_red = 254		;red
;If "loadct, 0" is used:
color_gry = 150		;grey


;Restore DST data from IDL Save file
; dstvalue	array of dst values
; jul_day	array of jd values
RESTORE, '~/IDLWorkspace83/data/dst2015/data_dst_pro-rt_2012_to_2015-05-11.sav'			;CHANGE !!!
;RESTORE, '~/IDLWorkspace83/data/dst2015/data_dst_final_1985-2011.sav'			;this restores FINAL dst data 1985-2011


;Define (or pass in from Keywords) Start and End Dates: [yyyy,mo,dd,hh,mi,ss]
;	   NOTE: start date must be at least 7 days after first time of DST data
;	   NOTE: end   date must be at least 7 days before last time of DST data
;Choose one of the below sets of startdate/enddate
;--------------------------------------------------------------------
;IF (Keyword_Set(stadate) EQ 0) THEN stadate = [1989,01,01,00,00,00]
;IF (Keyword_Set(enddate) EQ 0) THEN enddate = [2000,12,31,23,59,59]
;--------------------------------------------------------------------
;IF (Keyword_Set(stadate) EQ 0) THEN stadate = [2012,08,30,08,05,00]		;Launch date of RBSP spacecraft, UT   (change?) !!!
IF (Keyword_Set(stadate) EQ 0) THEN stadate = [2012,01,08,00,00,00]			;CHANGE !!!
IF (Keyword_Set(enddate) EQ 0) THEN enddate = [2015,05,04,00,00,00]			;CHANGE !!!
;--------------------------------------------------------------------
;IF (Keyword_Set(stadate) EQ 0) THEN stadate = [1985,01,08,0,0,0]			;alternate option for startdate
;IF (Keyword_Set(enddate) EQ 0) THEN enddate = [2011,12,24,23,0,0]			;alternate option for enddate
;--------------------------------------------------------------------
jd_stadate =	julday(stadate[1],stadate[2],stadate[0],stadate[3],stadate[4],stadate[5])
jd_enddate =	julday(enddate[1],enddate[2],enddate[0],enddate[3],enddate[4],enddate[5])
;NOTE: start date must be at least 7 days after first time of DST data
IF ( (jd_stadate - jul_day[0]  - 7) LT 0) THEN STOP
;NOTE: end   date must be at least 7 days before last time of DST data
IF ( (jul_day[-1] - jd_enddate - 7) LT 0) THEN STOP


;Create index, then arrays for just the data between the start and end dates desired
index01 =	where((jul_day GE jd_stadate-7) AND (jul_day LE jd_enddate+7), /NULL)
data_jd =	jul_day[index01]
data_dst =	dstvalue[index01]
caldat, data_jd, data_month, data_day, data_year, data_hour, data_min, data_sec


;Define "storms" array, each element will be incremented for various storm-indicating factors
hours=N_Elements(data_dst)
storms=lonarr(hours)-1


;Initially define empty arrays that will be DST Drop arrays.
dst_drop_HH2 = fltarr(hours)-9999
dst_drop_HH2L = fltarr(hours)-9999


;Define (or Keyword pass through) values for the criteria for identifying storms
HH1=16	;Defines range of time in hours for: DST a minimum in +/- HH1 hours
HH2=12	;Defines range of time in hours for: DST drop in previous HH2 hours (NOTE: HH2 must be = or < HH1)
IF (Keyword_Set(setHH2L) EQ 0) THEN setHH2L=16 ELSE STOP
HH2L=setHH2L	;Defines range of time in hours for: DST drop in previous HH2L hours (NOTE: HH2L must be = or < HH1)
DD1=27	;Defines the DST drop required for SMALL storms
IF (Keyword_Set(setDD2) EQ 0) THEN setDD2=55 ELSE STOP
DD2=setDD2	;Defines the DST drop required for LARGE storms


;Prime Factors for the storms array:
;Each criteria for whether or not there is a storm at a given timepoint is given a Prime Factor (PF_1, PF_2, etc...).
;	For each element of the "storms" array (except those in the first and last "HH1" hours), the value will be
;	set to 1*(PF_1)*(PF_2)*etc... for as many criteria are satisfied at that timepoint.
;	This is similar to useing bitwise logic.  Afterwards, each element of the "storms" array can checked if ALL the necessary
;	criteria for a small/large storm are met at that timepoint.
;Prime Factor Summary:
;2		Indicates DST value is between -50 and -20 (inclusive)
;3		Indicates DST value is less than -50
;5		Indicates DST value is a minumum in a time period of plus/minus "HH1" hours
;7		Indicates DST value dropped at least DD1 nT in the previous "HH2" hours
;11		Indicates DST value is NOT a repeat of a DST value in the previous 12 hours
;13		Indicates DST value dropped at least DD2 nT in the previous "HH2L" hours
;17		Indicates DST value is NOT a repeat of a DST value in the previous 12 hours
;19		Indicates the time is between the specified startdate/enddate
;			(required since I load data from/through 7 days before/after the specified startdate/enddate)
;23		Indicates...
;29, 31, 37, 41, 43, 47, 53, 59, 61


temp=1L				;indice for following FOR loop
ii=0L				;indice for following FOR loop
FOR ii=HH1,hours-(HH1+1) DO BEGIN
	temp=1L			;reset indice
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 2		Indicates DST value is between -50 and -20 (inclusive)
	IF ( (data_dst[ii] LE -20) AND (data_dst[ii] GE -50) ) THEN temp=temp*2
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 3		Indicates DST value is less than -50
	IF (data_dst[ii] LT -50) THEN temp=temp*3
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 5		Indicates DST value is a minumum in a time period of plus/minus "HH1" hours
	IF (data_dst[ii] EQ min(data_dst[ii-HH1:ii+HH1])) THEN temp=temp*5
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 7		Indicates DST value dropped at least DD1 nT in the previous "HH2" hours
	IF (max(data_dst[ii-HH2:ii])-data_dst[ii] GE DD1) THEN temp=temp*7			;should be GE DD1

	;Define the dst_drop arrays one element at a time
	dst_drop_HH2[ii] = max(data_dst[ii-HH2:ii]) - data_dst[ii]
	dst_drop_HH2L[ii] = max(data_dst[ii-HH2L:ii]) - data_dst[ii]
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 11		Indicates DST value is NOT a repeat of a DST value in the previous 12 hours
;	temp=temp*11												;test: use this line to allow storms to be ge 1 hour apart
;	IF ( (data_dst[ii] NE data_dst[ii-1]) ) THEN temp=temp*11	;test: use this line to allow storms to be ge 2 hours apart
	IF ( (data_dst[ii] NE data_dst[ii-1]) AND $
		 (data_dst[ii] NE data_dst[ii-2]) AND $
		 (data_dst[ii] NE data_dst[ii-3]) AND $
		 (data_dst[ii] NE data_dst[ii-4]) AND $
		 (data_dst[ii] NE data_dst[ii-5]) AND $
		 (data_dst[ii] NE data_dst[ii-6]) AND $
		 (data_dst[ii] NE data_dst[ii-7]) AND $
		 (data_dst[ii] NE data_dst[ii-8]) AND $
		 (data_dst[ii] NE data_dst[ii-9]) AND $
		 (data_dst[ii] NE data_dst[ii-10]) AND $
		 (data_dst[ii] NE data_dst[ii-11]) AND $
		 (data_dst[ii] NE data_dst[ii-12]) ) THEN temp=temp*11
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 13		Indicates DST value dropped at least DD2 nT in the previous "HH2L" hours
;	IF ( (max(data_dst[ii-HH2L:ii])-data_dst[ii] GE 75) AND $
;		 (max(data_dst[ii-HH2L:ii])-data_dst[ii] LE 79) ) THEN temp=temp*13
;	IF ( (max(data_dst[ii-16:ii])-data_dst[ii] GE 60) AND $
;		 (max(data_dst[ii-12:ii])-data_dst[ii] GE 55) ) THEN temp=temp*13
	IF (max(data_dst[ii-HH2L:ii])-data_dst[ii] GE DD2) THEN temp=temp*13			;should be GE DD2
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 17		Indicates DST value is NOT a repeat of a DST value in the previous 12 hours
;	temp=temp*17												;test: use this line to allow storms to be ge 1 hour apart
;	IF ( (data_dst[ii] NE data_dst[ii-1]) ) THEN temp=temp*17	;test: use this line to allow storms to be ge 2 hours apart
	IF ( (data_dst[ii] NE data_dst[ii-1]) AND $
		 (data_dst[ii] NE data_dst[ii-2]) AND $
		 (data_dst[ii] NE data_dst[ii-3]) AND $
		 (data_dst[ii] NE data_dst[ii-4]) AND $
		 (data_dst[ii] NE data_dst[ii-5]) AND $
		 (data_dst[ii] NE data_dst[ii-6]) AND $
		 (data_dst[ii] NE data_dst[ii-7]) AND $
		 (data_dst[ii] NE data_dst[ii-8]) AND $
		 (data_dst[ii] NE data_dst[ii-9]) AND $
		 (data_dst[ii] NE data_dst[ii-10]) AND $
		 (data_dst[ii] NE data_dst[ii-11]) AND $
		 (data_dst[ii] NE data_dst[ii-12]) ) THEN temp=temp*17
;-----------------------------------------------------------------------------------------------------------------------------
;Prime Factor: 19		Indicates the time is between the specified startdate/enddate
;							(required since I load data from/through 7 days before/after the specified startdate/enddate)
	IF ( (data_jd[ii] GE jd_stadate) AND $
		 (data_jd[ii] LE jd_enddate) ) THEN temp=temp*19
;-----------------------------------------------------------------------------------------------------------------------------
	storms[ii]=temp		;store the temp indice in the actual "storms" array
ENDFOR


;Create index arrays containing info on when a storm is identified
stti_sm = where(		((storms mod   2) EQ 0) AND $ 		; "STorm TImes SMall" = STTI_SM
						((storms mod   5) EQ 0) AND $
						((storms mod   7) EQ 0) AND $
						((storms mod  11) EQ 0) AND $
						((storms mod  19) EQ 0)  ,/L64)
stti_lg = where(		((storms mod   3) EQ 0) AND $ 		; "STorm TImes LarGe" = STTI_LG
						((storms mod   5) EQ 0) AND $
						((storms mod  13) EQ 0) AND $
						((storms mod  17) EQ 0) AND $
						((storms mod  19) EQ 0)  ,/L64)


;===IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN===
;The folliwing IF segment prints out all the relevant info on the small and large storms
IF ( 1 ) THEN BEGIN
print, ' '
print, 'Small Storm Times'
print, '#, Year, Month, Day, Hour, Minute, DST, Drop in DST in previous '+strtrim(HH2,2)+' hours'
jj=0L
FOR jj=0,N_Elements(stti_sm)-1 DO $
	print,	strtrim(jj,2), $
			data_year	[ stti_sm[jj] ], $
			data_month	[ stti_sm[jj] ], $
			data_day	[ stti_sm[jj] ], $
			data_hour	[ stti_sm[jj] ], $
			data_min	[ stti_sm[jj] ], $
			data_dst	[ stti_sm[jj] ], 'nT', $
			'  ('+strtrim(dst_drop_HH2[stti_sm[jj]],2)+'nT)'
print, ' '
print, '............'
print, '............'
print, '............'
print, '............'
print, ' '
print, 'Large Storm Times'
print, '#, Year, Month, Day, Hour, Minute, DST, Drop in DST in previous '+strtrim(HH2L,2)+' hours'
jj=0L
FOR jj=0,N_Elements(stti_lg)-1 DO $
	print,	strtrim(jj,2), $
			data_year	[ stti_lg[jj] ], $
			data_month	[ stti_lg[jj] ], $
			data_day	[ stti_lg[jj] ], $
			data_hour	[ stti_lg[jj] ], $
			data_min	[ stti_lg[jj] ], $
			data_dst	[ stti_lg[jj] ], 'nT', $
			'  ('+strtrim(dst_drop_HH2L[stti_lg[jj]],2)+'nT)'
print, '............'
print, '............'
print, '............'
print, '............'
ENDIF
;===IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE===


;===IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN===
;The following IF segment plots each small storm individually
IF ( 1 ) THEN BEGIN
HH3=168 ;hours before event to plot DST
HH4=168 ;hours after event to plot DST
wh_st = 0L ;"which storm"
jj=0L
FOR jj=0,N_Elements(stti_sm)-1 DO BEGIN
	wh_st = jj
	subt=''
	openw, zz, filepath+'dst_storm_finder/string.txt', /get_lun
	printf, zz, data_jd[stti_sm[wh_st]], FORMAT='(C())'
	close, zz
	free_lun, zz
	openr, zz, filepath+'dst_storm_finder/string.txt', /get_lun
	readf, zz, FORMAT='(A50)', subt
	close, zz
	free_lun, zz
	plot,	data_jd[stti_sm[wh_st]-HH3:stti_sm[wh_st]+HH4]-data_jd[stti_sm[wh_st]], $
			data_dst[stti_sm[wh_st]-HH3:stti_sm[wh_st]+HH4], $
			xstyle=1, xrange=[-7,7], xthick=8, $
			ystyle=1, yrange=[-80,40], ythick=8, $
			xtitle='Days from time of storm', ytitle='DST (nT)', $
			ticklen=-0.02, $
			title='SMALL storm: '+strtrim(wh_st,2)+$
				'      min DST: '+strtrim(data_dst[stti_sm[wh_st]],2)+$
				'      drop in previous '+strtrim(HH2,2)+' hours: '+strtrim(dst_drop_HH2[stti_sm[wh_st]] ,2)+$
				' !C minimum DST at: '+strtrim(subt,2), $
			thick=8, charthick=6, charsize=1, xcharsize=1.5, ycharsize=1.5
	oplot,	[-7,7], [0,0],		color=color_blu, thick=8				;Horizontal blue line at 0 nT
	oplot,	[-7,7], [-20,-20],	color=color_blu, thick=8				;Horizontal blue line at -20 nT
	oplot,	[-7,7], [-50,-50],	color=color_blu, thick=8				;Horizontal blue line at -50 nT
	oplot,	[-7,7], intarr(2)+data_dst[stti_sm[wh_st]], linestyle=2, thick=4				;Horizontal dashed line at minimum DST
	oplot,	[-7,7], intarr(2)+max(data_dst[stti_sm[wh_st]-HH2:stti_sm[wh_st]]), linestyle=2, thick=4		;Horizontal dashed line
	oplot,	[0,0],	[-80,40], color=color_red, thick=8					;Vertical red line at time of storm

	;Make vertical lines for other storms in this period
	other_sm_index = where( abs(data_jd[stti_sm] - data_jd[stti_sm[wh_st]]) LT 7, /NULL)
	other_lg_index = where( abs(data_jd[stti_lg] - data_jd[stti_sm[wh_st]]) LT 7, /NULL)
	FOR kk=0,N_Elements(other_sm_index)-1 DO BEGIN
		oplot, intarr(2)+data_jd[stti_sm[other_sm_index[kk]]]-data_jd[stti_sm[wh_st]], [-80,40], color=color_red, linestyle=2, thick=4
	ENDFOR
	FOR kk=0,N_Elements(other_lg_index)-1 DO BEGIN
		oplot, intarr(2)+data_jd[stti_lg[other_lg_index[kk]]]-data_jd[stti_sm[wh_st]], [-80,40], color=color_grn, linestyle=2, thick=4
	ENDFOR
ENDFOR
plot, [0,10],[0,10]
plot, [0,10],[0,10]
ENDIF
;===IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE===


;===IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN===
;The following IF segment plots each large storm individually
IF ( 1 ) THEN BEGIN
HH3=168 ;hours before event to plot DST
HH4=168 ;hours after event to plot DST
wh_st = 0L ;"which storm"
jj=0L
FOR jj=0,N_Elements(stti_lg)-1 DO BEGIN
	wh_st = jj
	subt=''
	openw, zz, filepath+'dst_storm_finder/string.txt', /get_lun
	printf, zz, data_jd[stti_lg[wh_st]], FORMAT='(C())'
	close, zz
	free_lun, zz
	openr, zz, filepath+'dst_storm_finder/string.txt', /get_lun
	readf, zz, FORMAT='(A50)', subt
	close, zz
	free_lun, zz
	plot,	data_jd[stti_lg[wh_st]-HH3:stti_lg[wh_st]+HH4]-data_jd[stti_lg[wh_st]], $
			data_dst[stti_lg[wh_st]-HH3:stti_lg[wh_st]+HH4], $
			xstyle=1, xrange=[-7,7], xthick=8, $
			ystyle=1, yrange=[-200,60], ythick=8, $
			xtitle='Days from time of storm', ytitle='DST (nT)', $
			ticklen=-0.02, $
			title='LARGE storm: '+strtrim(wh_st,2)+$
				'      min DST: '+strtrim(data_dst[stti_lg[wh_st]],2)+$
				'      drop in previous '+strtrim(HH2L,2)+' hours: '+strtrim(dst_drop_HH2L[stti_lg[wh_st]] ,2)+$
				' !C minimum DST at: '+strtrim(subt,2), $
				thick=8, charthick=6, charsize=1, xcharsize=1.5, ycharsize=1.5
	oplot,	[-7,7], [0,0],		color=color_blu, thick=8				;Horizontal blue line at 0 nT
	oplot,	[-7,7], [-20,-20],	color=color_blu, thick=8				;Horizontal blue line at -20 nT
	oplot,	[-7,7], [-50,-50],	color=color_blu, thick=8				;Horizontal blue line at -50 nT
	oplot,	[-7,7], intarr(2)+data_dst[stti_lg[wh_st]], linestyle=2, thick=4				;Horizontal dashed line at minimum DST
	oplot,	[-7,7], intarr(2)+max(data_dst[stti_lg[wh_st]-HH2L:stti_lg[wh_st]]), linestyle=2, thick=4		;Horizontal dashed line
	oplot,	[0,0], [-200,60], color=color_grn, thick=8					;Vertical red line at time of storm

	;Make vertical lines for other storms in this period
	other_sm_index = where( abs(data_jd[stti_sm] - data_jd[stti_lg[wh_st]]) LT 7, /NULL)
	other_lg_index = where( abs(data_jd[stti_lg] - data_jd[stti_lg[wh_st]]) LT 7, /NULL)
	FOR kk=0,N_Elements(other_sm_index)-1 DO BEGIN
		oplot, intarr(2)+data_jd[stti_sm[other_sm_index[kk]]]-data_jd[stti_lg[wh_st]], [-200,60], color=color_red, linestyle=2, thick=4
	ENDFOR
	FOR kk=0,N_Elements(other_lg_index)-1 DO BEGIN
		oplot, intarr(2)+data_jd[stti_lg[other_lg_index[kk]]]-data_jd[stti_lg[wh_st]], [-200,60], color=color_grn, linestyle=2, thick=4
	ENDFOR
ENDFOR
plot, [0,10],[0,10]
ENDIF
;===IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE===


;===IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN===
;The following IF segment analyzes and plots the amount of time between storms
IF ( 1 ) THEN BEGIN
times_sm = data_jd[stti_sm]
times_lg = data_jd[stti_lg]
times_sm_n = N_Elements(times_sm)
times_lg_n = N_Elements(times_lg)
timediff_sm = ( times_sm[1:times_sm_n-1] - times_sm[0:times_sm_n-2] ) * 24D
timediff_lg = ( times_lg[1:times_lg_n-1] - times_lg[0:times_lg_n-2] ) * 24D
hist_sm = histogram(timediff_sm, BINSIZE=1, /L64, locations=locs_sm)
hist_lg = histogram(timediff_lg, BINSIZE=1, /L64, locations=locs_lg)
print, ' '
print, 'small storms'
help, times_sm, timediff_sm
print, ' '
print, 'large storms'
help, times_lg, timediff_lg
print, ' '
plot, times_sm[1:times_sm_n-1]-times_sm[0], timediff_sm, psym=2, $
	title='SMALL Storms', xtitle='small storm number', ytitle='hours between event and the previous event'
plot, locs_sm, hist_sm, ystyle=1, yrange=[0,max(hist_sm)+1], xstyle=1, xrange=[0,max(locs_sm)+1], psym=2, $
	title='SMALL Storms', xtitle='hours between event and the previous event', ytitle='small storm occurrence'
plot, locs_sm, hist_sm, ystyle=1, yrange=[0,max(hist_sm)+1], xstyle=1, xrange=[0,72], psym=2, $
	title='SMALL Storms', xtitle='hours between event and the previous event', ytitle='small storm occurrence'
plot, locs_sm, hist_sm, ystyle=1, yrange=[0,max(hist_sm)+1], xstyle=1, xrange=[0,24], psym=2, $
	title='SMALL Storms', xtitle='hours between event and the previous event', ytitle='small storm occurrence'
plot, locs_sm, hist_sm, ystyle=1, yrange=[0,max(hist_sm[1:*])+1], xstyle=1, xrange=[0,72], psym=2, $
	title='SMALL Storms', xtitle='hours between event and the previous event', ytitle='small storm occurrence'
plot, locs_sm, hist_sm, ystyle=1, yrange=[0,max(hist_sm[1:*])+1], xstyle=1, xrange=[0,24], psym=2, $
	title='SMALL Storms', xtitle='hours between event and the previous event', ytitle='small storm occurrence'
plot, times_lg[1:times_lg_n-1]-times_lg[0], timediff_lg, psym=2, $
	title='LARGE Storms', xtitle='large storm number', ytitle='hours between event and the previous event'
plot, locs_lg, hist_lg, ystyle=1, yrange=[0,max(hist_lg)+1], xstyle=1, xrange=[0,max(locs_lg)+1], psym=2, $
	title='LARGE Storms', xtitle='hours between event and the previous event', ytitle='large storm occurrence'
plot, locs_lg, hist_lg, ystyle=1, yrange=[0,max(hist_lg)+1], xstyle=1, xrange=[0,72], psym=2, $
	title='LARGE Storms', xtitle='hours between event and the previous event', ytitle='large storm occurrence'
plot, locs_lg, hist_lg, ystyle=1, yrange=[0,max(hist_lg)+1], xstyle=1, xrange=[0,24], psym=2, $
	title='LARGE Storms', xtitle='hours between event and the previous event', ytitle='large storm occurrence'
plot, [1,2], [1,2]
ENDIF
;===IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE===


;===IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN===
;The following IF segment analyzes and plots the values of the DST Drops before each storm
IF ( 1 ) THEN BEGIN
drop_sm_hist = histogram(dst_drop_HH2[stti_sm], BINSIZE=1, /L64, locations=drop_sm_locs)
drop_lg_hist = histogram(dst_drop_HH2L[stti_lg], BINSIZE=1, /L64, locations=drop_lg_locs)
plot, drop_sm_locs, drop_sm_hist, ystyle=1, yrange=[0,max(drop_sm_hist)+1], xstyle=1, xrange=[0,max(drop_sm_locs)+1], psym=2, $
	title='SMALL STORMS DST Drop Histogram', xtitle='DST Drop (nT)', ytitle='occurrence of storms'
plot, drop_sm_locs, drop_sm_hist, ystyle=1, yrange=[0,max(drop_sm_hist)+1], xstyle=1, xrange=[25,45], psym=2, $
	title='SMALL STORMS DST Drop Histogram', xtitle='DST Drop (nT)', ytitle='occurrence of storms'
plot, drop_lg_locs, drop_lg_hist, ystyle=1, yrange=[0,max(drop_lg_hist)+1], xstyle=1, xrange=[0,max(drop_lg_locs)+1], psym=2, $
	title='LARGE STORMS DST Drop Histogram', xtitle='DST Drop (nT)', ytitle='occurrence of storms'
plot, drop_lg_locs, drop_lg_hist, ystyle=1, yrange=[0,max(drop_lg_hist)+1], xstyle=1, xrange=[40,80], psym=2, $
	title='LARGE STORMS DST Drop Histogram', xtitle='DST Drop (nT)', ytitle='occurrence of storms'
plot, [1,2], [1,2]
ENDIF
;===IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE===


;Putting the important arrays into the output arguments
arg1_julday =		data_jd
arg2_dst =			data_dst
arg3_storms =		storms
arg4_sstimes =		stti_sm
arg5_lgtimes =		stti_lg


;===IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN============IF=LOOP=OPEN===
;The following IF segment saves the above 5 arguments into an IDL Save File
IF ( 0 ) THEN BEGIN																							;CHANGE !!!
;SAVE, data_jd, data_dst, storms, stti_sm, stti_lg, FILENAME=filepath+'dst_storm_finder/storm_times_final.sav'
SAVE, data_jd, data_dst, storms, stti_sm, stti_lg, $
	FILENAME=filepath+'dst_storm_finder/storm_times_rbsp_era/storm_times_pr-rt_2012_to_2015-05-11xxx.sav'		;CHANGE !!!

;storms_30ntdrop = storms
;stti_sm_30ntdrop = stti_sm
;SAVE, storms_30ntdrop, stti_sm_30ntdrop, FILENAME=filepath+'dst_storm_finder/storm_times_final_only_small30ntdrop.sav'

ENDIF
;===IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE============IF=LOOP=CLOSE===


;stop
IF (keyword_set(ps) eq 1) THEN BEGIN
	device, /close
	set_plot, 'x'
ENDIF

;;Example code to plot all DST for a time and oplot all storms:
;window, 0, title='xwin0', xsize=1260, ysize=737, xpos=10, ypos=-792
;loadct, 39
;RESTORE, '~/IDLWorkspace83/data/dst2015/data_dst_2012-08-01_to_2015-05-11prepared.sav'
;RESTORE: '~/IDLWorkspace83/dst_storm_finder/storm_times_rbsp_era/storm_times_2015-05-11.sav'
;plot, (jul_day-julday(1,0,2013,0,0,0))/30., dstvalue, xstyle=1, xrange=[-5,29], ystyle=1, yrange=[-250,75]
;FOR ii=0,N_Elements(stti_lg)-1 DO oplot, [0,0]+(data_jd[stti_lg[ii]]-julday(1,0,2013,0,0,0))/30.,[-300,100], color=120
;FOR ii=0,N_Elements(stti_sm)-1 DO oplot, [0,0]+(data_jd[stti_sm[ii]]-julday(1,0,2013,0,0,0))/30.,[-300,100], color=250

END
