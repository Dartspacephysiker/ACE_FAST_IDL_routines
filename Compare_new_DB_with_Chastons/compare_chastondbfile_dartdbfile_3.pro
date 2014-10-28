;+
; :NAME:
;   compare_chastondbfile_dartdbfile_3
; :REQUIRED KEYWORD(S):
;   orbit                = Specify orbit to be compared. If 'fname' is set, this will only specify which Chastondb file to use
;                          for comparison
; :OPTIONAL KEYWORDS:
;   interval             =  For a given orbit, which interval to consider 
;                           (There is only one interval per orbit--"0"--and this is the default. Chaston's DB divides orbits into intervals
;                            based, I believe, on location of the satellite) 
;   max_tdiff            =  Max time difference (in seconds) between a Dartmouth event
;                           and a Chaston event for considering them identical
;   check_current_thresh =  Specify a current density threshold (in microA/m^2) which
;                           events must meet. Outputs statistics of those meeting criterion.
;   do_as3               =  Use old Alfven_Stats_3 database
;   fname                =  Specify a filename to compare with a Chastondb file--make sure to specify proper orbit in call!
;   outdataf             =  Name of analysis file to be outputted
;   
; :HISTOIRE:
;   10/28/2014  Added outdataf and fname options, updated documentation a little, changed do_as5 to do_as3, since as3 is the older code
;               and the default behavior should be usage of the new alfven_stats_5 database  
;   10/02/2014  Adding check_current_thresh option to see if
;               our DBs match for a given current threshold (default 10)
; 
; :AUTEUR:
;   Monsieur Hatch
;   Dartworth College (Après l'esprit de nous coopérateurs francais)
;-

pro compare_chastondbfile_dartdbfile_3, $
  orbit,interval=interval,arr_elem=arr_elem,smooth=smooth, $
  do_two=do_t,analyse_noise=analyse_noise,extra_times=extra_t,no_screen=no_s, $
  smooth_extra_times=smooth_extra_t, smooth_no_screen=smooth_no_s, $
  check_current_thresh=check_c,ucla_mag_despin=ucla,show_fieldnames=show_f,max_tdiff=max_tdiff,$
  do_as3=do_as3, outdataf=outdataf,fname=fname,outname=outname,_ref_extra = e

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

  IF NOT KEYWORD_SET(do_as3) THEN BEGIN
    PRINT,"Using field names for Alfven_Stats_5!  (For as3 set keyword /do_as3)"
    fieldnames=['orbit','alfvenic','time','alt','mlt','ilat','mag_current','esa_current','eflux_losscone_max','NOtotal_eflux_max','YESeflux_losscone_integ','NOtotal_eflux_integ','max_chare_losscone',$
      'max_chare_total','max_ie','max_ion_flux','max_upgoing_ionflux','integ_ionf','integ_upgoing_ionf','max_char_ie','width_t','width_spatial','db','de','fields_samp_period','fields_mode',$
      'max_hf_up','max_h_chare','max_of_up','max_o_chare','max_hef_up','max_he_chare','sc_pot','lp_num','max_lp_current','min_lp_current','median_lp_current']
    as5=1
  ENDIF ELSE BEGIN
    PRINT,"Using field names for Alfven_Stats_3!  (For as5 unset keyword /do_as3)"
    fieldnames=['orbit','time','alt','mlt','ilat','mag_current','esa_current','elec_energy_flux','integ_elec_energy_flux','char_elec_energy','ion_energy_flux','ion_flux','ion_flux_up',$
        'integ_ion_flux','integ_ion_flux_up','char_ion_energy','width_time','width_x','delta_B','delta_E','mode','sample_t','proton_flux_up','proton_energy_flux_up',$
        'oxy_flux_up','oxy_energy_flux_up','helium_flux_up','helium_energy_flux_up','sc_pot']
  ENDELSE
  
  IF NOT KEYWORD_SET(interval) THEN BEGIN
    DEF_INTERVAL = 0
    PRINT, "No interval specified! Using " + STRCOMPRESS(string(DEF_INTERVAL),/REMOVE_ALL)
    interval = DEF_INTERVAL
  ENDIF
     
  IF KEYWORD_SET(show_f) THEN BEGIN
    fieldind=indgen(n_elements(fieldnames))

    PRINT, "Field indices and corresponding data:"
    for j=0,((N_ELEMENTS(fieldind)-1)/4 - 1) DO BEGIN
      PRINT, format='(4(I2,": ",A-22,:))',fieldind[j*4],fieldnames[j*4],fieldind[j*4+1],fieldnames[j*4+1], $
        fieldind[j*4+2],fieldnames[j*4+2],fieldind[j*4+3],fieldnames[j*4+3]
    endfor
    RETURN
  ENDIF

  IF KEYWORD_SET(check_c) AND check_c EQ !NULL THEN check_c=10 ;default 

  if not keyword_set(arr_elem) then begin
    print, "No array element specified! Comparing times of max current..."
    IF NOT KEYWORD_SET(do_as3) THEN arr_elem = 2 ELSE arr_elem = 1 ;default, do max current times
  endif

  chastondbdir='/SPENCEdata/Research/Cusp/database/current_db/'
  ;datadir='/SPENCEdata/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/'
  datadir='/SPENCEdata/software/sdt/batch_jobs/Alfven_study/'
  IF NOT KEYWORD_SET(do_as3) THEN datadir += 'as5_14F/' $
    ELSE datadir += 'as3_pristine/'
  ;outdir='/SPENCEdata/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput//jigglemicroA/'
  outdir='/SPENCEdata/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput/magcal_versions/'

  basename='dflux_' + strcompress(orbit,/remove_all)+'_' + STRCOMPRESS(interval,/REMOVE_ALL)
  savsuf='.sav'

  ;filenames
  chastonfname=chastondbdir+basename
  chastonoutname=outdir+'chast_'+basename+savsuf

  IF NOT KEYWORD_SET(fname) THEN BEGIN
    PRINT,"WHERE'S THE FILENAME?"
    RETURN
    fname=datadir+'Dartmouth_'
    if NOT KEYWORD_SET(do_as3) THEN fname += "as5_"
    fname +=basename
    IF KEYWORD_SET(analyse_noise) THEN fname += '_analysenoise'
    IF KEYWORD_SET(extra_t) THEN fname += '_extratimes'
    IF KEYWORD_SET(no_s) THEN fname += '_noscreen'
    IF KEYWORD_SET(ucla) THEN fname += '_magdespin'
  ENDIF

  IF NOT KEYWORD_SET(outname) THEN BEGIN
    IF KEYWORD_SET(do_as3) THEN outname=outdir+'as3/Dartmouth_as3_pristine_'+basename $
    ELSE outname=outdir+'as5/Dartmouth_as5_'+basename
    IF KEYWORD_SET(analyse_noise) THEN outname += '_analysenoise'
    IF KEYWORD_SET(extra_t) THEN outname += '_extratimes'
    IF KEYWORD_SET(no_s) THEN outname += '_noscreen'
    IF KEYWORD_SET(ucla) THEN outname += '_magdespin'
    ;IF KEYWORD_SET(check_c) THEN outname += '_curthresh' + str(check_c) + 'microA'
    outname += savsuf
  ENDIF

  smoothfname=fname+'_smooth'
  IF KEYWORD_SET(smooth_extra_t) THEN smoothfname += '_extratimes'
  IF KEYWORD_SET(smooth_no_s) THEN smoothfname += '_noscreen'

  smoothoutname=outdir+'Dartmouth_'+basename+'_smooth'+savsuf

  print, "Chaston db file: " + chastonfname
  print, "Dartmou db file: " + fname
  print, "Dar smooth file: " + smoothfname ;smooth option?

  ;Deal with output filename
  IF NOT KEYWORD_SET(outdataf) THEN BEGIN
    outdataf=outdir
    if NOT KEYWORD_SET(do_as3) THEN outdataf += "as5/"+basename+"_as5" $
    ELSE outdataf += "as3/"+basename+"_as3"
    IF KEYWORD_SET(analyse_noise) THEN outdataf += '_analysenoise'
    if ( (NOT KEYWORD_SET(do_t)) && KEYWORD_SET(smooth) ) then begin
      fname=smoothfname
      outname=smoothoutname
      outdataf+='_smooth'
      print, 'Doing smooth Dart file instead of unsmoothed file...'
    endif

    IF KEYWORD_SET(extra_t) THEN outdataf += '_extratimes'
    IF KEYWORD_SET(no_s) THEN outdataf += '_noscreen'
    IF KEYWORD_SET(do_t) THEN outdataf += '_two'
    IF KEYWORD_SET(check_c) THEN outdataf += '_curthresh' + str(check_c) + 'microA'
    IF KEYWORD_SET(ucla) THEN outdataf += '_magdespin'
    IF KEYWORD_SET(max_tdiff) THEN BEGIN
      outdataf += STRING(max_tdiff,FORMAT='("_tdiff_",F-0.3)')
    ENDIF
    outdataf = outdataf+'--'+fieldnames[arr_elem]+'.txt'
  ENDIF

  print, "Output filename: " + outdataf

  ;get files in memory
  combine_dflux_dartchast,orbit, 0, in_name=chastonfname,outname=chastonoutname
  restore, chastonoutname
  IF NOT KEYWORD_SET(do_as3) THEN BEGIN
    combine_dflux_dartchast,orbit, 3, in_name=fname,outname=outname
  ENDIF ELSE BEGIN
    combine_dflux_dartchast,orbit, 1, in_name=fname,outname=outname
  ENDELSE
  restore, outname

  IF (KEYWORD_SET(smooth) || KEYWORD_SET(do_t)) THEN BEGIN
    combine_dflux_dartchast,orbit, 2, in_name=smoothfname,outname=smoothoutname
    restore, smoothoutname
  ENDIF

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

  ;Some prelims for the output file
  openw,outf,outdataf,/get_lun
  
  print, "Comparing " + fieldnames[arr_elem] + "..."
  print, "Comparing files:"
  print, "Chaston file: " + chastonfname
  print, "Dart file: " + fname

  PRINTF,outf, SYSTIME()
  printf,outf, "***Comparison of '" + fieldnames[arr_elem] + "' data***"
  printf,outf, "*Chaston file: " + chastonfname
  printf,outf, "*Dart file: " + fname

  IF KEYWORD_SET(do_t) THEN BEGIN
    print, "Dart2  file: " + smoothfname
    printf,outf, "*Dart2  file: " + smoothfname
  ENDIF
  printf,outf, "(Two data points on same line ==> identical time of occurrence of max FAC corresponding to data)"

  IF KEYWORD_SET(check_c) THEN BEGIN
    print, "Current threshold: " + str(check_c) + " microA/m^2"
    printf, outf, "Current threshold: " + str(check_c) + " microA/m^2"
  ENDIF

;New line and close file here (re-opened in write_chast_* routines below)
  printf,outf, string(13b)
  FREE_LUN, outf


  ;Now the magic staggering part:
  IF NOT KEYWORD_SET(do_t) THEN BEGIN
    IF KEYWORD_SET(check_c) THEN BEGIN
      write_chast_plus_one_3,dat,dat1,arr_elem=arr_elem,filename=outdataf,check_c=check_c,max_tdiff=max_tdiff, _extra = e,as5=as5
    ENDIF ELSE BEGIN
      write_chast_plus_one_3,dat,dat1,arr_elem=arr_elem,filename=outdataf,max_tdiff=max_tdiff, _extra = e,as5=as5
    ENDELSE
  ENDIF ELSE BEGIN
    IF KEYWORD_SET(check_c) THEN BEGIN
      write_chast_plus_two_3,dat,dat1,dat_smooth,arr_elem=arr_elem,filename=outdataf,check_c=check_c,max_tdiff=max_tdiff
    ENDIF ELSE BEGIN
      write_chast_plus_two_3,dat,dat1,dat_smooth,arr_elem=arr_elem,filename=outdataf,max_tdiff=max_tdiff
    ENDELSE
  ENDELSE

  return
end
