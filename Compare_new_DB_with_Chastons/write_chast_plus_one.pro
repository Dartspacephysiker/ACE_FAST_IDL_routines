pro write_chast_plus_one, chast_time, chast_data, dart_time, dart_data, filename=file

  n_chast=N_ELEMENTS(chast_time)
  n_dart=n_elements(dart_time)

  if not keyword_set(file) then begin
    file="./write_chast_plus_one.out"
    print, "write_chast_plus_one: No file selected! using default '" + file +"'"
  endif

  ;open a file for writing
  openu,outf,file,/append,/get_lun 
  printf,outf, "      Chaston orig             Dartmouth"

  i = 0
  i_chast = 0
  i_dart = 0
  matches = 0
  WHILE ((i_chast LT n_chast) && (i_dart LT n_dart)) DO BEGIN
    IF str_to_time(chast_time[i_chast]) LT str_to_time(dart_time[i_dart]) THEN BEGIN
      printf,outf, format= '(I-6,A-24)',i,str(chast_data[i_chast])
      i_chast++
      i++
    ENDIF ELSE BEGIN
      IF str_to_time(chast_time[i_chast]) GT str_to_time(dart_time[i_dart]) THEN BEGIN
        printf,outf, format= '(I-6,T32,A-0)',i,str(dart_data[i_dart])
        i_dart++
        i++
      ENDIF ELSE BEGIN
        IF str_to_time(chast_time[i_chast]) EQ str_to_time(dart_time[i_dart]) THEN BEGIN
          printf,outf, format= '(I-5,"*",2(A-23,:,", "))',i,str(chast_data[i_chast]), str(dart_data[i_dart])
          i_chast++
          i_dart++
          matches++
          i++
        ENDIF
      ENDELSE
    ENDELSE
  ENDWHILE

  ;Take care of last dart and/or chaston lines, if any
  IF (i_chast LT n_chast) && (i_dart EQ n_dart) THEN BEGIN
    print, 'Wrapping up chast lines...'
    WHILE (i_chast LT n_chast) DO BEGIN
      printf,outf, format= '(I-6,A-24)',i,chast_data[i_chast]
      i_chast++
      i++
    ENDWHILE
  ENDIF ELSE BEGIN
    IF (i_chast EQ n_chast) && (i_dart LT n_dart) THEN BEGIN
      print, 'Wrapping up dart lines...'
      WHILE (i_dart LT n_dart) DO BEGIN
        printf,outf, format= '(I-6,T32,A-24)',i,dart_data[i_dart]
        i_dart++
        i++
      ENDWHILE
    ENDIF
  ENDELSE

  print, 'i_dart = ' + str(i_dart) + ' and n_dart = ' + str(n_dart)
  print, 'i_chast = ' + str(i_chast) + ' and n_chast = ' + str(n_chast)
  print, 'matches = ' +str(matches)

  printf,outf, string(13b)
  printf,outf, "Number of Chaston events   : " + str(n_chast)
  printf,outf, "Number of Dartmouth events : " + str(n_dart)
  printf,outf, 'Total matches              : ' +str(matches)
  FREE_LUN, outf

end