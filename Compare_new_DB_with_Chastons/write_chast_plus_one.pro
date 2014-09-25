pro write_chast_plus_one, chast_time, chast_data, dart_time, dart_data, filename=file

  n_chast=N_ELEMENTS(chast_time)
  n_dart=n_elements(dart_time)

  if not keyword_set(file) then begin
    file="./write_chast_plus_one.out"
    print, "write_chast_plus_one: No file selected! using default '" + file +"'"
  endif

  ;open a file for writing
  openw,outf,file,/get_lun
  printf,outf, "Chaston orig             Dartmouth"

  i_chast = 0
  i_dart = 0
  WHILE ((i_chast LT n_chast) && (i_dart LT n_dart)) DO BEGIN
    IF str_to_time(chast_time[i_chast]) LT str_to_time(dart_time[i_dart]) THEN BEGIN
      printf,outf, format= '(A0)',chast_data[i_chast]
      i_chast++
    ENDIF ELSE BEGIN
      IF str_to_time(chast_time[i_chast]) GT str_to_time(dart_time[i_dart]) THEN BEGIN
        printf,outf, format= '(T26,A0)',dart_data[i_dart]
        i_dart++
      ENDIF ELSE BEGIN
        IF str_to_time(chast_time[i_chast]) EQ str_to_time(dart_time[i_dart]) THEN BEGIN
          printf,outf, format= '(2(A0,:,", "))',chast_data[i_chast], dart_data[i_dart]
          i_chast++
          i_dart++
        ENDIF
      ENDELSE
    ENDELSE
  ENDWHILE

  ;Take care of last dart and/or chaston lines, if any
  IF (i_chast LT n_chast) && (i_dart EQ n_dart) THEN BEGIN
    print, 'Wrapping up chast lines...'
    WHILE (i_chast LT n_chast) DO BEGIN
      printf,outf, format= '(A0)',chast_data[i_chast]
      i_chast++
    ENDWHILE
  ENDIF ELSE BEGIN
    IF (i_chast EQ n_chast) && (i_dart LT n_dart) THEN BEGIN
      print, 'Wrapping up dart lines...'
      WHILE (i_dart LT n_dart) DO BEGIN
        printf,outf, format= '(T26,A0)',dart_data[i_dart]
        i_dart++
      ENDWHILE
    ENDIF
  ENDELSE

  print, 'i_dart = ' + str(i_dart) + ' and n_dart = ' + str(n_dart)
  print, 'i_chast = ' + str(i_chast) + ' and n_chast = ' + str(n_chast)

end