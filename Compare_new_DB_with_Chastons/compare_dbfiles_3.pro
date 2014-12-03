;+
; :NAME:
;   compare_dbfiles_3
; :REQUIRED KEYWORD(S):
;   dbfile1                = first db file
;   dbfile2                = second dbfile
;   outfile                = file to be written
; :OPTIONAL KEYWORDS:
;   dbfile1_is_idl_sav       = file 1 is an IDL .sav file; don't
;                            run rdf_dflux_fout on it
;   dbf2_is_idl_sav       = file 2 is an IDL .sav file; don't
;                            run rdf_dflux_fout on it
;   max_tdiff              = Max time difference (in seconds) between a Dartmouth event
;                            and a Chaston event for considering them identical
;   check_current_thresh   = Specify a current density threshold (in microA/m^2) which
;                            events must meet. Outputs statistics of those meeting criterion.
;   do_as3                 = Use old Alfven_Stats_3 database
;   outdataf               = Name of analysis file to be outputted
;   
; :HISTOIRE:
;   12/03/2014  Forked from compare_dbfiles_3_burst to make possible
;               comparison between two user-specified files
;   12/02/2014  Forked from compare_dbfiles_3 to accommodate 'burst
;               mode' output from Alfven_Stats_5, which tends to 
;               generate many intervals for a given orbit instead of 
;               the typical 1 or 2 intervals.
;   10/28/2014  Added outdataf and fname options, updated
;               documentation a little, changed do_as5 to do_as3, since as3 is the older code
;               and the default behavior should be usage of the new alfven_stats_5 database  
;   10/02/2014  Adding check_current_thresh option to see if
;               our DBs match for a given current threshold (default 10)
; 
; :AUTEUR:
;   Monsieur Hatch
;   Dartworth College (Après l'esprit de nous coopérateurs francais)
;-

pro compare_dbfiles_3, $
  dbfile1,dbfile2,outfile,dbfile1_idl_sav=dbfile1_idl_sav,dbfile2_idl_sav=dbfile2_idl_sav, $
  dbf1_is_as3=dbf1_is_as3,dbf2_is_as3=dbf2_is_as3,arr_elem1=arr_elem1, $
  extra_times=extra_t, $
  check_current_thresh=check_c,ucla_mag_despin=ucla,show_fieldnames=show_f,max_tdiff=max_tdiff,$
  fname=fname,outname=outname,_ref_extra = e

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


  fieldnames_as5=['orbit','alfvenic','time','alt','mlt','ilat','mag_current','esa_current','eflux_losscone_max','NOtotal_eflux_max','YESeflux_losscone_integ','NOtotal_eflux_integ', $
                  'max_chare_losscone', 'max_chare_total','max_ie','max_ion_flux','max_upgoing_ionflux','integ_ionf','integ_upgoing_ionf','max_char_ie','width_t','width_spatial','db','de', $
                  'fields_samp_period', 'fields_mode', 'max_hf_up','max_h_chare','max_of_up','max_o_chare','max_hef_up','max_he_chare','sc_pot','lp_num', $
                  'max_lp_current','min_lp_current','median_lp_current']
    
  fieldnames_as3=['orbit','time','alt','mlt','ilat','mag_current','esa_current','elec_energy_flux','integ_elec_energy_flux','char_elec_energy','ion_energy_flux','ion_flux','ion_flux_up',$
                  'integ_ion_flux','integ_ion_flux_up','char_ion_energy','width_time','width_x','delta_B','delta_E','mode','sample_t','proton_flux_up','proton_energy_flux_up',$
                  'oxy_flux_up','oxy_energy_flux_up','helium_flux_up','helium_energy_flux_up','sc_pot']

  if not keyword_set(arr_elem1) then begin
    print, "No array element specified! Comparing times of max current..."
    IF NOT KEYWORD_SET(dbf1_is_as3) THEN arr_elem1 = 2 ELSE arr_elem1 = 1 ;default, do max current times
    IF NOT KEYWORD_SET(dbf2_is_as3) THEN arr_elem2 = 2 ELSE arr_elem2 = 1 ;default, do max current times
  endif

  IF NOT KEYWORD_SET(dbf1_is_as3) THEN BEGIN
    PRINT,"dbfile1 is using field names for Alfven_Stats_5"
    fieldnames1=fieldnames_as5
    dbf1_is_as3=0
  ENDIF ELSE BEGIN
    fieldnames1=fieldnames_as3
    PRINT,"dbfile1 is using field names for Alfven_Stats_3!  (For as5 unset keyword /dbf1_is_as3)"
  ENDELSE

  IF NOT KEYWORD_SET(dbf2_is_as3) THEN BEGIN
    PRINT,"dbfile2 is using field names for Alfven_Stats_5"
    fieldnames2=fieldnames_as5
    dbf2_is_as3=0
  ENDIF ELSE BEGIN
    PRINT,"dbfile2 is using field names for Alfven_Stats_3!  (For as5 unset keyword /dbf2_is_as3)"
    fieldnames2=fieldnames_as3
  ENDELSE

  
  IF KEYWORD_SET(show_f) THEN BEGIN
    fieldind=indgen(n_elements(fieldnames1))

    PRINT, "Field indices and corresponding data:"
    for j=0,((N_ELEMENTS(fieldind)-1)/4 - 1) DO BEGIN
      PRINT, format='(4(I2,": ",A-22,:))',fieldind[j*4],fieldnames1[j*4],fieldind[j*4+1],fieldnames1[j*4+1], $
        fieldind[j*4+2],fieldnames1[j*4+2],fieldind[j*4+3],fieldnames1[j*4+3]
    endfor
    RETURN
  ENDIF

  IF KEYWORD_SET(check_c) AND check_c EQ !NULL THEN check_c=10 ;default 

  drive='SPENCEdata2'
  chastondbdir='/'+drive+'/Research/Cusp/database/current_db/'
  ;datadir='/'+drive+'/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/'
  datadir='/'+drive+'/software/sdt/batch_jobs/Alfven_study/'
  IF NOT KEYWORD_SET(do_as3) THEN datadir += 'as5_14F/' $
    ELSE datadir += 'as3_pristine/'
  ;outdir='/'+drive+'/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput//jigglemicroA/'
  outdir='/'+drive+'/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput/'

;  IF NOT KEYWORD_SET(dbfile1) OR NOT KEYWORD_SET(dbfile2) OR NOT
;  KEYWORD_SET(outfile) THEN BEGIN
  IF NOT KEYWORD_SET(dbfile1) THEN BEGIN
    PRINT,"WHAT'S DBFILE1?"
    RETURN
  ENDIF

  IF NOT KEYWORD_SET(dbfile2) THEN BEGIN
    PRINT,"WHAT's DBFILE2?"
    RETURN
  ENDIF

  IF NOT KEYWORD_SET(outfile) THEN BEGIN
    PRINT,"WHAT'S THE OUTFILE?"
    RETURN
  ENDIF

  print, "dbfile1  : " + dbfile1
  print, "dbfile2  : " + dbfile2
  print, "Outfile  : " + outfile

  ;get files in memory
  IF NOT KEYWORD_SET(dbfile1_idl_sav) THEN BEGIN
     combine_dbfile, dbf1_is_as3, dat1,in_name=dbfile1,outname="combine_dbfile1.out"
  ENDIF ELSE BEGIN
     restore,dbfile1
     dat1=dat
  ENDELSE

  IF NOT KEYWORD_SET(dbfile2_idl_sav) THEN BEGIN
    combine_dbfile, dbf2_is_as3, dat2,in_name=dbfile2,outname="combine_dbfile2.out"
  ENDIF ELSE BEGIN
     restore,dbfile2
     dat2=dat
  ENDELSE

  ;find which data set has larger number of filaments
  n_dbf1 = N_ELEMENTS(dat1.time)
  n_dbf2 = N_ELEMENTS(dat2.time)
  n = max([n_dbf1,n_dbf2],k)

  if k eq 0 then begin
    print, 'dbfile1 has larger number of filaments: ' + Str(n)
  endif else begin
    print, 'dbfile2 has larger number of filaments: ' + Str(n)
  endelse

  ;find which data set begins first and which ends last
  if str_to_time(dat1.time[0]) lt str_to_time(dat2.time[0]) then begin
    print, 'dbfile1 begins first: ' + dat1.time[0]
  endif else begin
    if str_to_time(dat1.time[0]) gt str_to_time(dat2.time[0]) then begin
      print, 'dbfile2 begins first: ' + dat2.time[0]
    endif else print, 'dbfiles begin at the same time: ' + dat1.time[0]

  endelse

  if str_to_time(dat1.time[n_dbf1-1]) lt str_to_time(dat2.time[n_dbf2-1]) then begin
    print, 'dbfile1 ends first: ' + dat1.time[n_dbf1-1]
  endif else begin
    if str_to_time(dat1.time[n_dbf1-1]) gt str_to_time(dat2.time[n_dbf2-1]) then begin
      print, 'dbfile2 ends first: ' + dat2.time[n_dbf2-1]
    endif else print, 'dbfiles end at the same time: ' + dat1.time[n_dbf1-1]
  endelse

  ;Some prelims for the output file
  openw,outf,outfile,/get_lun
  
  print, "Comparing " + fieldnames1[arr_elem1] + "..."
  print, "dbfile1: " + dbfile1
  print, "dbfile2: " + dbfile2

  PRINTF,outf, SYSTIME()
  printf,outf, "***Comparison of '" + fieldnames1[arr_elem1] + "' data***"
  printf,outf, "dbfile1: " + dbfile1
  printf,outf, "dbfile2: " + dbfile2

  printf,outf, "(Two data points on same line ==> identical time of occurrence of max FAC corresponding to data)"

  IF KEYWORD_SET(check_c) THEN BEGIN
    print, "Current threshold: " + str(check_c) + " microA/m^2"
    printf, outf, "Current threshold: " + str(check_c) + " microA/m^2"
  ENDIF

  ;New line and close file here (re-opened in write_chast_* routines below)
  printf,outf, string(13b)
  FREE_LUN, outf


  ;Now the magic staggering part:
  IF KEYWORD_SET(check_c) THEN BEGIN
     write_dbfiles_3,dat1,dat2,arr_elem=arr_elem1,filename=outfile,check_c=check_c,max_tdiff=max_tdiff, _extra = e,dbf1_is_as5=~dbf1_is_as3,dbf2_is_as5=~dbf2_is_as3
  ENDIF ELSE BEGIN
     write_dbfiles_3,dat1,dat2,arr_elem=arr_elem1,filename=outfile,max_tdiff=max_tdiff, _extra = e,dbf1_is_as5=~dbf1_is_as3,dbf2_is_as5=~dbf2_is_as3
  ENDELSE

  return
end
