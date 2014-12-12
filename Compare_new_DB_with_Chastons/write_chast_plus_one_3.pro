;+
; NAME: WRITE_CHAST_PLUS_ONE_3
;
;
;
; PURPOSE: Write a file that compares a Chaston Alfvènic FAC db file
;          with one of ours.
;
;
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE: This is called by compare_chastondbfile_dartdbfile_3.pro, which is how you should leave it.
;
;
;
; INPUTS:
;
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; SIDE EFFECTS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPLE: (for calling compare_chastondbfile_dartdbfile_3, which calls this pro)
;          compare_chastondbfile_dartdbfile_3,10000,out_suffix="--AGU_mtg_w_Chaston",max_tdiff=0.016,check_current_thresh=5,/only_alfvenic
;
;
; MODIFICATION HISTORY:
; 12/12/2014 Added 'check_sorted' option originally written in compare_dbfiles_3.pro
;-
pro write_chast_plus_one_3,chast_struct,dart_struct,arr_elem=arr_elem,filename=file,$
  check_current_thresh=check_c,max_tdiff=max_tdiff, as5=as5, only_alfvenic=only_alfvenic, $
  chaston_check_sorted=chaston_check_sorted, dart_check_sorted=dart_check_sorted, check_sorted=check_sorted, $
  _extra = e
;This one incorporates the idea from my most recent meeting with Professor LaBelle that we ought to
;say that two points are a match if they're within a few milliseconds of each other. 
;Let's see how this changes the statistics...
 
  if ISA(e) THEN BEGIN
    help,e
    print,"Why the extra parameters? They have no home..."
    RETURN
  endif

  n_chast=N_ELEMENTS(chast_struct.time)

  ;
  if KEYWORD_SET(as5) AND KEYWORD_SET(only_alfvenic) THEN BEGIN
    print, "Only considering Alfvènic Dartmouth DB events"
    keep_dart=where(dart_struct.alfvenic GT 0)
    n_dart=n_elements(keep_dart)
;    dart_struct.time = dart_struct.time(keep_dart)
;    dart_struct.(arr_elem) = dart_struct.(arr_elem)(keep_dart)
  endif else begin
    n_dart=n_elements(dart_struct.time)
    keep_dart=indgen(n_dart)
  endelse

  ;make sure we're not dealing with dupes
  IF KEYWORD_SET(chaston_check_sorted) OR KEYWORD_SET(check_sorted) THEN BEGIN
     ;For chaston struct
     uniq_times_i2=uniq(str_to_time(chast_struct.time),sort(str_to_time(chast_struct.time)))
     tags_chast=tag_names(chast_struct)
     ntags_chast=n_elements(tags_chast)
     tmp = create_struct(tags_chast[0], chast_struct.(0)(uniq_times_i2))
     for i=1,ntags_chast-1 do tmp = create_struct(tmp, tags_chast[i],chast_struct.(i)(uniq_times_i2))
     print,"Original number of elements  in chast_struct : " + strcompress(n_elements(chast_struct.time),/REMOVE_ALL)
     print,"Number of duplicate elements in chast_struct : " + strcompress(n_elements(chast_struct.time)-n_elements(uniq_times_i2),/REMOVE_ALL)
     chast_struct = tmp
  ENDIF

  IF KEYWORD_SET(dart_check_sorted) OR KEYWORD_SET(check_sorted) THEN BEGIN
     ;For dart struct
     uniq_times_i2=uniq(str_to_time(dart_struct.time),sort(str_to_time(dart_struct.time)))
     tags_dart=tag_names(dart_struct)
     ntags_dart=n_elements(tags_dart)
     tmp = create_struct(tags_dart[0], dart_struct.(0)(uniq_times_i2))
     for i=1,ntags_dart-1 do tmp = create_struct(tmp, tags_dart[i],dart_struct.(i)(uniq_times_i2))
     print,"Original number of elements  in dart_struct : " + strcompress(n_elements(dart_struct.time),/REMOVE_ALL)
     print,"Number of duplicate elements in dart_struct : " + strcompress(n_elements(dart_struct.time)-n_elements(uniq_times_i2),/REMOVE_ALL)
     dart_struct = tmp
  ENDIF

  magc_ind = 5 ;index of mag_current in structs
  chast_magc_ind = 5

  IF KEYWORD_SET(as5) THEN BEGIN
  
    magc_ind = 6
    ;Array to match as5 data with as3 data
    dart_as5_arr_elem = [0,-1,1,2,3,4,5,6,7,-1,8,-1,9, $; =(max_chare_losscone), Not sure if max_chare_losscone or max_chare_total correspond to char_elec_energy
      -1,10,11,12,13,14,15,16,17,18,19,21,20, $ ;fields mode
      22,23,24,25,26,27,28,-1,-1,-1,-1]
    chast_arr_elem = dart_as5_arr_elem[arr_elem]
    IF chast_arr_elem LE -1.0 THEN BEGIN
      PRINT, "ERROR! You're attempting to use Alfven_Stats_5 array element " +string(arr_elem) + " for comparison, but the Chaston DB doesn't include this calculation!"
      PRINT, "Exiting..."
      RETURN
    ENDIF
  ENDIF ELSE chast_arr_elem = arr_elem

  if not keyword_set(file) then begin
    file="./write_chast_plus_one.out"
    print, "write_chast_plus_one_2: No file selected! using default '" + file +"'"
  endif

  if not keyword_set(arr_elem) then begin
    print, "No array element specified! Comparing times of max current..."
    arr_elem = 1 ;default, do max current times
  endif

  if NOT KEYWORD_SET(max_tdiff) OR max_tdiff EQ !NULL then begin
    max_tdiff = 0.00 ;maximum time difference in seconds to qualify as a match
    print, "No max time_difference specified...using " + str(max_tdiff) + " seconds"
  endif

  ;help,chast_struct,/str
  ;help,dart_struct,/str 

  ;open a file for writing
  openu,outf,file,/append,/get_lun 
  printf,outf, "      Chaston orig             Dartmouth                   Chast ind     Dart ind"

  i = 0
  i_chast = 0
  i_dart = 0
  
  matches = 0
  
  chast_ct = 0 ;current threshold counters
  dart_ct = 0
  ct_matches = 0
  chastct_ind = []
  chastct_eig = []
  dartct_ind = []
  dartct_eig = []
  matchct_ind = []
  matchct_eig = []
  
  tdiff = 0
  
  WHILE ((i_chast LT n_chast) && (i_dart LT n_dart)) DO BEGIN
     
     tdiff = str_to_time(chast_struct.time[i_chast]) - str_to_time(dart_struct.time[keep_dart[i_dart]])

     IF ABS(tdiff) GT max_tdiff THEN BEGIN
        IF (ABS(tdiff) GT 0.000001) AND (tdiff/ABS(tdiff) LT 0) THEN BEGIN
           printf,outf, format= '(I-6,A-24,T60,I-4)',i,str(chast_struct.(chast_arr_elem)[i_chast]),i_chast
           if ( KEYWORD_SET(check_c) && (chast_struct.(chast_magc_ind)[i_chast] GT check_c) ) then begin
              chastct_ind = [chastct_ind, i]
              chast_ct++
              chastct_eig = [chastct_eig, i_chast]
           endif
           i_chast++
           i++
        ENDIF ELSE BEGIN
           IF FINITE(tdiff/ABS(tdiff)) GT 0.0 THEN BEGIN
              printf,outf, format= '(I-6,T32,A-0,T74,I-4)',i,str(dart_struct.(arr_elem)[keep_dart[i_dart]]),i_dart
              if ( KEYWORD_SET(check_c) && (dart_struct.(magc_ind)[keep_dart[i_dart]] GT check_c) ) then begin
                 dartct_ind = [dartct_ind, i]
                 dartct_eig = [dartct_eig, keep_dart[i_dart]]
                 dart_ct++
              endif
              i_dart++
              i++
           ENDIF
        ENDELSE
     ENDIF ELSE BEGIN
        IF ABS(tdiff) GE 0.00005 THEN BEGIN
           printf,outf, format= '(I-5,"!",2(A-23,:,", "),T60,I-4,T74,I-4)',i,$
                  str(chast_struct.(chast_arr_elem)[i_chast]), str(dart_struct.(arr_elem)[keep_dart[i_dart]]),i_chast,i_dart
        ENDIF ELSE BEGIN
           printf,outf, format= '(I-5,"*",2(A-23,:,", "),T60,I-4,T74,I-4)',i,$
                  str(chast_struct.(chast_arr_elem)[i_chast]), str(dart_struct.(arr_elem)[keep_dart[i_dart]]),i_chast,i_dart
        ENDELSE
        if ( KEYWORD_SET(check_c) && (chast_struct.(chast_magc_ind)[i_chast] GT check_c) ) then begin
           matchct_ind = [matchct_ind, i]
           matchct_eig = [matchct_eig, keep_dart[i_dart]]
           chast_ct++
           dart_ct++
           ct_matches++
        endif

        i_chast++
        i_dart++
        matches++
        i++
     ENDELSE
;  ENDELSE
  ENDWHILE

  ;Take care of last dart and/or chaston lines, if any
  IF (i_chast LT n_chast) && (i_dart EQ n_dart) THEN BEGIN
    print, 'Wrapping up chast lines...'
    WHILE (i_chast LT n_chast) DO BEGIN
      printf,outf, format= '(I-6,A-24,T60,I-4)',i,chast_struct.(chast_arr_elem)[i_chast],i_chast
      if ( KEYWORD_SET(check_c) && (chast_struct.(chast_magc_ind)[i_chast] GT check_c) ) then begin
        chastct_ind = [chastct_ind, i]
        chastct_eig = [chastct_eig, i_chast]
        chast_ct++
      endif
      i_chast++
      i++
    ENDWHILE
  ENDIF ELSE BEGIN
    IF (i_chast EQ n_chast) && (i_dart LT n_dart) THEN BEGIN
      print, 'Wrapping up dart lines...'
      WHILE (i_dart LT n_dart) DO BEGIN
        printf,outf, format= '(I-6,T32,A-24,T74,I-4)',i,dart_struct.(arr_elem)[keep_dart[i_dart]],i_dart
        if ( KEYWORD_SET(check_c) && (dart_struct.(magc_ind)[keep_dart[i_dart]] GT check_c) ) then begin
          dartct_ind = [dartct_ind, i]
          dartct_eig = [dartct_eig, keep_dart[i_dart]]
          dart_ct++
        endif
        i_dart++
        i++
      ENDWHILE
    ENDIF
  ENDELSE

  print, 'i_dart = ' + str(i_dart) + ' and n_dart = ' + str(n_dart)
  print, 'i_chast = ' + str(i_chast) + ' and n_chast = ' + str(n_chast)
  print, 'matches = ' +str(matches)

  if KEYWORD_SET(check_c) then begin
    print, string(13b)
    printf,outf, string(13b)
    print, 'Current threshold: ' + str(check_c) + ' microA/m^2'
    printf,outf, 'Current threshold: ' + str(check_c) + ' microA/m^2'
    print, string(13b)
    printf,outf, string(13b)
    print, 'Chaston events above cur_thresh              = ' + str(chast_ct)
    printf,outf, 'Chaston events above cur_thresh              = ' + str(chast_ct)
    IF chastct_ind NE !NULL THEN BEGIN
      print, format='("Line numbers of qualifying Chaston events    : ",(T48,10(I-6)))',$
        chastct_ind
      printf,outf, format='("Line numbers of qualifying Chaston events    : ",(T48,10(I-6)))',$
        chastct_ind
      print,format='("Time of Chaston events                       :",(T48,3(A-25)))',$
        chast_struct.time[chastct_eig]
      printf,outf,format='("Time of Chaston events                       :",(T48,3(A-25)))',$
        chast_struct.time[chastct_eig]
    ENDIF
    print, string(13b)
    printf,outf, string(13b)
    print, 'Dartmouth events above cur_thresh            = ' + str(dart_ct)
    printf,outf, 'Dartmouth events above cur_thresh            = ' + str(dart_ct)
    IF dartct_ind NE !NULL THEN BEGIN
      print, format='("Line numbers of qualifying Dartmouth events  : ",(T48,10(I-6)))',dartct_ind
      printf,outf, format='("Line numbers of qualifying Dartmouth events  : ",(T48,10(I-6)))',dartct_ind
      print,format='("Time of Dartmouth events                     :",(T48,3(A-25)))',$
        dart_struct.time[dartct_eig]
      printf,outf,format='("Time of Dartmouth events                     :",(T48,3(A-25)))',$
        dart_struct.time[dartct_eig]
    ENDIF
    print, string(13b)
    printf,outf, string(13b)
    print, 'Matching events above cur thresh             = ' + str(ct_matches)
    printf,outf, 'Matching events above cur thresh             = ' + str(ct_matches)
    IF matchct_ind NE !NULL THEN BEGIN
      print, format='("Line numbers of qualifying matching events   : ",(T48,10(I-6)))',matchct_ind
      printf,outf, format='("Line numbers of qualifying matched events    : ",(T48,10(I-6)))',matchct_ind
      print,format='("Time of matching events                      :",(T48,3(A-25)))',dart_struct.time[matchct_eig]
      printf,outf,format='("Time of matching events                      :",(T48,3(A-25)))',$
        dart_struct.time[matchct_eig]
    ENDIF
 
  endif

  printf,outf, string(13b)
  printf,outf, "Chaston events   : " + str(n_chast)
  printf,outf, "Dartmouth events : " + str(n_dart)
  printf,outf, 'Total matches    : ' +str(matches)
  FREE_LUN, outf

end
