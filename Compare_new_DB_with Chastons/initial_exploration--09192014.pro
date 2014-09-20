; IDL Version 8.3 (linux x86_64 m64)
; Journal File for spencerh@Merry2
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST/Comparison_dflux_10000_0
; Date: Fri Sep 19 17:46:53 2014
 
disparate_times=WHERE(dat.time NE dat1.time)
help,dat,dat1,dat_nosmooth,/str
;So each one has a different number of filaments identified
;Check out match, a, b, suba, subb
;a, b - two arrays in which to find matching elements
;suba = subscripts of elements in vector a with a match in vector b.
;subb = subscripts of the elements in vector b with matches in vector a.
;suba and subb are ordered such that a(suba) = b(subb) with increasing values (unless /ORIGINAL_ORDER options are invoked).
match,dat.time,dat_nosmooth.time,elem_in_dat_w_match_in_dat_nosmooth,elem_in_dat_nosmooth_w_match_in_dat
help
elem_in_dat_nosmooth_w_match_in_dat[0]
;           1
elem_in_dat_w_match_in_dat_nosmooth[0]
;           0
print, dat.time[0], dat_nosmooth.time[0]
;1999-03-02/17:56:01.9791999-03-02/17:55:42.159
print, dat.time[0], dat_nosmooth.time[1]
;1999-03-02/17:56:01.9791999-03-02/17:56:01.979
print, dat.time[1], dat_nosmooth.time[2]
;1999-03-02/17:56:08.5421999-03-02/17:56:23.284

;open a file for writing
openw,outf,"/SPENCEdata/Research/Cusp/ACE_FAST/Comparison_dflux_10000_0/compare_Chaston_and_Dartm_nosmooth_times.txt",/get_lun

printf,outf, "Chaston orig             Dartmouth_nosmooth"
for j=0,(N_ELEMENTS(dat_nosmooth.time)-1) do begin & $
  if (j LT n_elements(dat.time)) then begin & $
    printf,outf, format= '(2(A0,:,", "))',dat.time[j], dat_nosmooth.time[j] & $
  endif else begin & $
    printf,outf, format= '(T26,A0)',dat_nosmooth.time[j] & $
  endelse & $ 
endfor

;close file
free_lun,outf
