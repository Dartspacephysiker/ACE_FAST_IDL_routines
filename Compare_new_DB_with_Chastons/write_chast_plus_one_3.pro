pro write_chast_plus_one_3,chast_struct,dart_struct,arr_elem=arr_elem,filename=file,$
  check_current_thresh=check_c,max_tdiff=max_tdiff

;This one incorporates the idea from my most recent meeting with Professor LaBelle that we ought to
;say that two points are a match if they're within a few milliseconds of each other. 
;Let's see how this changes the statistics...
 
  magc_ind = 5 ;index of mag_current in structs

  n_chast=N_ELEMENTS(chast_struct.time)
  n_dart=n_elements(dart_struct.time)

  if not keyword_set(file) then begin
    file="./write_chast_plus_one.out"
    print, "write_chast_plus_one_2: No file selected! using default '" + file +"'"
  endif

  if not keyword_set(arr_elem) then begin
    print, "No array element specified! Comparing times of max current..."
    arr_elem = 1 ;default, do max current times
  endif

  if KEYWORD_SET(max_tdiff) and max_tdiff EQ !NULL then begin
    max_tdiff = 0.00 ;maximum time difference in seconds to qualify as a match
    print, "No max time_difference specified...using " + str(max_tdiff) + "seconds"
  endif

  ;help,chast_struct,/str
  ;help,dart_struct,/str 

  ;open a file for writing
  openu,outf,file,/append,/get_lun 
  printf,outf, "      Chaston orig             Dartmouth"

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
     
     tdiff = str_to_time(chast_struct.time[i_chast]) - str_to_time(dart_struct.time[i_dart])

     IF ABS(tdiff) GT max_tdiff THEN BEGIN
        IF tdiff/ABS(tdiff) LT 0 THEN BEGIN
           printf,outf, format= '(I-6,A-24,T56,I-4)',i,str(chast_struct.(arr_elem)[i_chast]),i_chast
           if ( KEYWORD_SET(check_c) && (chast_struct.(magc_ind)[i_chast] GT check_c) ) then begin
              chastct_ind = [chastct_ind, i]
              chast_ct++
              chastct_eig = [chastct_eig, i_chast]
           endif
           i_chast++
           i++
        ENDIF ELSE BEGIN
           IF tdiff/ABS(tdiff) GT 0.0 THEN BEGIN
              printf,outf, format= '(I-6,T32,A-0,T60,I-4)',i,str(dart_struct.(arr_elem)[i_dart]),i_dart
              if ( KEYWORD_SET(check_c) && (dart_struct.(magc_ind)[i_dart] GT check_c) ) then begin
                 dartct_ind = [dartct_ind, i]
                 dartct_eig = [dartct_eig, i_dart]
                 dart_ct++
              endif
              i_dart++
              i++
           ENDIF
        ENDELSE
     ENDIF ELSE BEGIN
        IF ABS(tdiff) GE 0.0005 THEN BEGIN
           printf,outf, format= '(I-5,"!",2(A-23,:,", "))',i,$
                  str(chast_struct.(arr_elem)[i_chast]), str(dart_struct.(arr_elem)[i_dart])
        ENDIF ELSE BEGIN
           printf,outf, format= '(I-5,"*",2(A-23,:,", "))',i,$
                  str(chast_struct.(arr_elem)[i_chast]), str(dart_struct.(arr_elem)[i_dart])
        ENDELSE
        if ( KEYWORD_SET(check_c) && (chast_struct.(magc_ind)[i_chast] GT check_c) ) then begin
           matchct_ind = [matchct_ind, i]
           matchct_eig = [matchct_eig, i_dart]
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
      printf,outf, format= '(I-6,A-24,T56,I-4)',i,chast_struct.(arr_elem)[i_chast],i_chast
      if ( KEYWORD_SET(check_c) && (chast_struct.(magc_ind)[i_chast] GT check_c) ) then begin
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
        printf,outf, format= '(I-6,T26,A-24,T60,I-4)',i,dart_struct.(arr_elem)[i_dart],i_dart
        if ( KEYWORD_SET(check_c) && (dart_struct.(magc_ind)[i_dart] GT check_c) ) then begin
          dartct_ind = [dartct_ind, i]
          dartct_eig = [dartct_eig, i_dart]
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
      print, format='("Line numbers of qualifying Chaston events    : ",(T48,10(I-4)))',$
        chastct_ind
      printf,outf, format='("Line numbers of qualifying Chaston events    : ",(T48,10(I-4)))',$
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
      print, format='("Line numbers of qualifying Dartmouth events  : ",(T48,10(I-4)))',dartct_ind
      printf,outf, format='("Line numbers of qualifying Dartmouth events  : ",(T48,10(I-4)))',dartct_ind
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
      print, format='("Line numbers of qualifying matching events   : ",(T48,10(I-4)))',matchct_ind
      printf,outf, format='("Line numbers of qualifying matched events    : ",(T48,10(I-4)))',matchct_ind
      print,format='("Time of matching events                      :",(T48,3(A-25)))',dart_struct.time[matchct_eig]
      printf,outf,format='("Time of matching events                      :",(T48,3(A-25)))',$
        dart_struct.time[matchct_eig]
    ENDIF
 
  endif

  printf,outf, string(13b)
  printf,outf, "Chaston events   : " + str(n_chast)
  printf,outf, "Dartmouth events : " + str(n_dart)
  printf,outf, 'Total matches              : ' +str(matches)
  FREE_LUN, outf

end
