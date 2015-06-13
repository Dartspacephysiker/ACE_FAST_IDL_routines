;+
;Title: comparefoundstorms.pro
;
;Author: Brett Anderson
;
;Date Created: 22 May 2014
;
;Date Last Modified: 22 May 2014
;
;Purpose: Automated program to compare found storms using dst_stormfinder.
;			This procedure uses dst_stormfinder twice to create two different sets of storms, using different criteria.
;			Currently only set up to compare the Large Storm times that are found.
;			Then it tells you how many of the storms the two lists have in common, and how many are unique to each set.
;
;Calling Sequence:
; INPUT:
; OUTPUT:
;
;Notes:
;
;-


PRO comparefoundstorms
compile_opt defint32, strictarr, logical_predicate, strictarrsubs
close, /all				;just a precaution line
loadct, 39				;load a color template for plotting
device,decomposed=0		;Apply loadct call to plots
filepath='~/IDLWorkspace83/'
filename='compare_001'
ps=0
IF (keyword_set(ps) eq 1) THEN BEGIN
	set_plot, 'ps'
	device, decomposed=0, color=1, encapsulated=0, landscape=1, inches=1, $
		xsize=9, ysize=6.5, $
		xoffset=1, yoffset=10, $
		file=filepath+'dst_storm_finder/'+filename+'.ps'
ENDIF ELSE BEGIN
	device, decomposed=0   ;Apply loadct call to plots
ENDELSE

;This is the list of arguments for dst_stormfinder:
;	arg1_julday, arg2_dst, arg3_storms, arg4_sstimes, arg5_lgtimes

dst_stormfinder, a1, a2, a3, a4, a5, setHH2L=16, setDD2=60
stop
dst_stormfinder, b1, b2, b3, b4, b5, setHH2L=12, setDD2=55
;print, '---------------------------------------------------'
;help
print, '---------------------------------------------------'
IF (N_Elements(where(a5 NE b5)) EQ 1) THEN BEGIN
	IF (where(a5 NE b5) EQ -1) THEN BEGIN
		print, 'a5 and b5 arrays are equal'
		print, 'a5 and b5 arrays are equal'
		print, 'a5 and b5 arrays are equal'
		print, 'a5 and b5 arrays are equal'
		stop
	ENDIF
ENDIF

checka=LONARR(N_Elements(a5))
checkb=LONARR(N_Elements(b5))

FOR ii=0,N_Elements(a5)-1 DO BEGIN
	checka[ii]=where(b5 EQ a5[ii])
ENDFOR
FOR ii=0,N_Elements(b5)-1 DO BEGIN
	checkb[ii]=where(a5 EQ b5[ii])
ENDFOR


FOR ii=0,N_Elements(a5)-1 DO BEGIN
	IF (checka[ii] NE -1) THEN BEGIN
		IF (a5[ii]-b5[checka[ii]] NE 0) THEN STOP
	ENDIF
ENDFOR
FOR ii=0,N_Elements(b5)-1 DO BEGIN
	IF (checkb[ii] NE -1) THEN BEGIN
		IF (b5[ii]-a5[checkb[ii]] NE 0) THEN STOP
	ENDIF
ENDFOR
IF (N_Elements(where(checka NE -1)) NE N_Elements(where(checkb NE -1))) THEN STOP

print, 'number of elements the two Large storm sets have in common: '+strtrim(N_Elements(where(checkb NE -1)),2)
print, '           Percentage of large storms in group a: '+strtrim(100.*N_Elements(where(checka NE -1))/N_Elements(checka),2)+'%'
print, '           Percentage of large storms in group b: '+strtrim(100.*N_Elements(where(checkb NE -1))/N_Elements(checkb),2)+'%'

print, '---------------------------------------------------'
print, 'number of elements unique to "a" group: '+strtrim(N_Elements(where(checka EQ -1)),2)
print, 'number of elements unique to "b" group: '+strtrim(N_Elements(where(checkb EQ -1)),2)
print, '---------------------------------------------------'




stop
IF (keyword_set(ps) eq 1) THEN BEGIN
	device, /close
	set_plot, 'x'
ENDIF

END
