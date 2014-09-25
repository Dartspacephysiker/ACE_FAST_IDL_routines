pro compare_chastondbfile_dartdbfile, orbit,arr_elem=arr_elem,smooth=smooth,do_two=do_t

  ;Structure of data files (array element can be one of the following):
  ;0-Orbit number'
  ;1-max current time (based on location of max current)'
  ;2-max current altitude'
  ;3-max current MLT'
  ;4-max current ILAT'
  ;5-maximum size of the delta B current in that interval'
  ;6-maximum size of the current from the Electron esa at s/c alt.'
  ;7-maximum size of the electron energy flux mapped to the ionosphere-positive is downwards'
  ;8-integrated downgoing electron flux over that interval at ionosphere'
  ;9-maximum characteristic electron energy from that interval'
  ;10-maximum ion energy flux at the s/c altitude'
  ;11-maximum ion flux at the s/c altitude'
  ;12-maximum upgoing ion flux at the s/c altitude'
  ;13-integrated ion flux over the interval at ionosphere'
  ;14-integrated upgoing only ion flux over the interval at ionosphere'
  ;15-maximum characteristic ion energy'
  ;16-width of the current fiament in time (s)'
  ;17-width of the current filament in m at the s/c altitude'
  ;18-magnetic field amplitude (nT)'
  ;19-electric field amplitude (mV/m)'
  ;20-fields mode'
  ;21-fields sample period'
  ;22-maximum upgoing proton flux'
  ;23-maximum upgoing proton characteristic energy'
  ;24-maximum upgoing oxygen flux'
  ;25-maximum upgoing oxygen characteristic energy'
  ;26-maximum upgoing helium flux'
  ;27-maximum upgoing helium characteristic energy'
  ;28-spacecraft potential'
  ;SPENCE ADDITIONS:
  ;29-interval start time
  ;30-interval stop time
  ;31-duration of interval

  fieldnames=['orbit','time','alt','mlt','ilat','mag_current','esa_current','elec_energy_flux','integ_elec_energy_flux','char_elec_energy','ion_energy_flux','ion_flux','ion_flux_up',$
    'integ_ion_flux','integ_ion_flux_up','char_ion_energy','width_time','width_x','delta_B','delta_E','mode','sample_t','proton_flux_up','proton_energy_flux_up',$
    'oxy_flux_up','oxy_energy_flux_up','helium_flux_up','helium_energy_flux_up','sc_pot']

  if not keyword_set(arr_elem) then arr_elem = 1 ;default, do start times

;  if not keyword_set(orbit) then begin
;    print, 'No orbit provided! Setting orbit=10000...'
;    orbit=10000
;  endif
  ;dirs

  chastondbdir='/SPENCEdata/Research/Cusp/database/current_db/'
  datadir='/SPENCEdata/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/'
  outdir='/SPENCEdata/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput/'

  basename='dflux_'+strcompress(orbit,/remove_all)+'_0'
  savsuf='.sav'

  ;filenames
  chastonfname=chastondbdir+basename
  chastonoutname=outdir+'chast_'+basename+savsuf

  fname=datadir+'Dartmouth_'+basename
  outname=outdir+'Dartmouth_'+basename+savsuf

  smoothfname=fname+'_SMOOTH'
  smoothoutname=outdir+'Dartmouth_'+basename+'_SMOOTH'+savsuf

  print, "Chaston db file: " + chastonfname
  print, "Dartmou db file: " + fname
  print, "Dar smooth file: " + smoothfname ;smooth option?

  if ( (NOT KEYWORD_SET(do_t)) && KEYWORD_SET(smooth) ) then begin
    fname=smoothfname
    outname=smoothoutname 
    outdataf=outdir+basename+'_'+fieldnames[arr_elem]+'_SMOOTH.txt'
    print, 'Doing smooth Dart file instead of unsmoothed file...'
  endif else begin
    IF KEYWORD_SET(do_t) THEN BEGIN
      outdataf=outdir+basename+'_'+fieldnames[arr_elem]+'_two.txt'
    ENDIF ELSE BEGIN
      outdataf=outdir+basename+'_'+fieldnames[arr_elem]+'.txt'
    ENDELSE
  endelse

  ;get files in memory
  combine_dflux_dartchast,orbit, 0, in_name=chastonfname,outname=chastonoutname
  combine_dflux_dartchast,orbit, 1, in_name=fname,outname=outname
  restore, chastonoutname
  restore, outname

  IF (KEYWORD_SET(smooth) || KEYWORD_SET(do_t)) THEN BEGIN
    combine_dflux_dartchast,orbit, 2, in_name=smoothfname,outname=smoothoutname
    restore, smoothoutname
  ENDIF

;  disparate_times=WHERE(dat.time NE dat1.time)
;  ;  help,dat,dat1,dat_nosmooth,/str
;  ;So each one has a different number of filaments identified
;  ;Check out match, a, b, suba, subb
;  ;a, b - two arrays in which to find matching elements
;  ;suba = subscripts of elements in vector a with a match in vector b.
;  ;subb = subscripts of the elements in vector b with matches in vector a.
;  ;suba and subb are ordered such that a(suba) = b(subb) with increasing values (unless /ORIGINAL_ORDER options are invoked).
;  match,dat.time,dat1.time,elem_in_dat_w_match_in_dat1,elem_in_dat1_w_match_in_dat
;  help, elem_in_dat1_w_match_in_dat[0], elem_in_dat_w_match_in_dat1[0]
;  ;           0
;  print, dat.time[0], dat1.time[0]
;  ;1999-03-02/17:56:01.9791999-03-02/17:55:42.159
;  print, dat.time[0], dat1.time[1]
;  ;1999-03-02/17:56:01.9791999-03-02/17:56:01.979
;  print, dat.time[1], dat1.time[2]
;  ;1999-03-02/17:56:08.5421999-03-02/17:56:23.284

  ;find which data set has larger number of filaments
  n_dart = N_ELEMENTS(dat1.time)
  n_chast = N_ELEMENTS(dat.time)
  n = max([n_chast,n_dart],k)

  if k eq 0 then begin
    print, 'Chaston db file has larger number of filaments: ' + Str(n)
  endif else begin
    print, 'Dartmouth db file has larger number of filaments: ' + Str(n)
  endelse

  ;find which data set begins first and which ends last
  if str_to_time(dat.time[0]) lt str_to_time(dat1.time[0]) then begin
    print, 'Chaston db begins first: ' + dat.time[0]
  endif else begin
    if str_to_time(dat.time[0]) gt str_to_time(dat1.time[0]) then begin
      print, 'Dartmo db begins first: ' + dat1.time[0]
    endif else print, 'Chaston and Dartmo db begin at the same time: ' + dat.time[0]

  endelse




  if str_to_time(dat.time[n_chast-1]) lt str_to_time(dat1.time[n_dart-1]) then begin
    print, 'Chaston db ends first: ' + dat.time[n_chast-1]
  endif else begin
    if str_to_time(dat.time[n_chast-1]) gt str_to_time(dat1.time[n_dart-1]) then begin
      print, 'Dartmo db ends first: ' + dat1.time[n_dart-1]
    endif else print, 'Chaston and Dartmo db end at the same time: ' + dat.time[n_chast-1]
  endelse



  ;Now the magic staggering part:

  IF NOT KEYWORD_SET(do_t) THEN BEGIN
    write_chast_plus_one,dat.time,dat.(arr_elem),dat1.time,dat1.(arr_elem),filename=outdataf
  ENDIF ELSE BEGIN
    write_chast_plus_two,dat.time,dat.(arr_elem),dat1.time,dat1.(arr_elem), $
      dat_smooth.time,dat_smooth.(arr_elem),filename=outdataf
  ENDELSE



;  ;open a file for writing
;  openw,outf,outdataf,/get_lun
;  printf,outf, "Chaston orig             Dartmouth"
;
;  i_chast = 0
;  i_dart = 0
;  WHILE ((i_chast LT n_chast) && (i_dart LT n_dart)) DO BEGIN
;    IF str_to_time(dat.time[i_chast]) LT str_to_time(dat1.time[i_dart]) THEN BEGIN
;      printf,outf, format= '(A0)',dat.(arr_elem)[i_chast]
;      i_chast++
;    ENDIF ELSE BEGIN
;      IF str_to_time(dat.time[i_chast]) GT str_to_time(dat1.time[i_dart]) THEN BEGIN
;        printf,outf, format= '(T26,A0)',dat1.(arr_elem)[i_dart]
;        i_dart++
;      ENDIF ELSE BEGIN
;        IF str_to_time(dat.time[i_chast]) EQ str_to_time(dat1.time[i_dart]) THEN BEGIN
;          printf,outf, format= '(2(A0,:,", "))',dat.(arr_elem)[i_chast], dat1.(arr_elem)[i_dart]
;          i_chast++
;          i_dart++
;        ENDIF
;      ENDELSE
;    ENDELSE
;  ENDWHILE
;
;  ;Take care of last dart and/or chaston lines, if any
;  IF (i_chast LT n_chast) && (i_dart EQ n_dart) THEN BEGIN
;    print, 'Wrapping up chast lines...'
;    WHILE (i_chast LT n_chast) DO BEGIN
;      printf,outf, format= '(A0)',dat.(arr_elem)[i_chast]
;      i_chast++
;    ENDWHILE
;  ENDIF ELSE BEGIN
;    IF (i_chast EQ n_chast) && (i_dart LT n_dart) THEN BEGIN
;      print, 'Wrapping up dart lines...'
;      WHILE (i_dart LT n_dart) DO BEGIN
;        printf,outf, format= '(T26,A0)',dat1.(arr_elem)[i_dart]
;        i_dart++
;      ENDWHILE
;    ENDIF
;  ENDELSE
;
;print, 'i_dart = ' + str(i_dart) + ' and n_dart = ' + str(n_dart)
;print, 'i_chast = ' + str(i_chast) + ' and n_chast = ' + str(n_chast)

  ;  for j=0,(N_ELEMENTS(dat1.time)-1) do begin & $
  ;     if (j LT n_elements(dat.time)) then begin & $
  ;     printf,outf, format= '(2(A0,:,", "))',dat.time[j], dat1.time[j] & $
  ;     endif else begin & $
  ;     printf,outf, format= '(T26,A0)',dat1.time[j] & $
  ;     endelse & $
  ;     endfor

  ;close file
  ;free_lun,file

  return
end
