pro write_chast_plus_two, chast_time, chast_data, dart1_time, dart1_data, dart2_time, dart2_data, filename=file

  n_chast=N_ELEMENTS(chast_time)
  n_dart1=n_elements(dart1_time)
  n_dart2=n_elements(dart2_time)

  if not keyword_set(file) then begin
    file="./write_chast_plus_two.out"
    print, "write_chast_plus_two: No file selected! using default '" + file +"'"
  endif

  ;open a file for writing
  openw,outf,file,/get_lun
  printf,outf, "Chaston orig             Dartmouth1             Dartmouth2"

  i_chast = 0
  i_dart1 = 0
  i_dart2 = 0
  
  WHILE ((i_chast LT n_chast) && (i_dart1 LT n_dart1) && (i_dart2 LT n_dart2)) DO BEGIN
    IF str_to_time(chast_time[i_chast]) LT str_to_time(dart1_time[i_dart1]) THEN BEGIN
      IF str_to_time(chast_time[i_chast]) LT str_to_time(dart2_time[i_dart2]) THEN BEGIN
        printf,outf, format= '(A0)',chast_data[i_chast]
        i_chast++
      ENDIF ELSE BEGIN
        IF str_to_time(chast_time[i_chast]) GT str_to_time(dart2_time[i_dart2]) THEN BEGIN
          printf,outf, format= '(T54,A0)',dart2_data[i_dart2]
          i_dart2++
        ENDIF ELSE BEGIN
          IF str_to_time(chast_time[i_chast]) EQ str_to_time(dart2_time[i_dart2]) THEN BEGIN
            printf,outf, format= '(A0,T26,A0)',chast_data[i_chast], dart2_data[i_dart2]
            i_chast++
            i_dart2++            
          ENDIF
        ENDELSE
      ENDELSE
    ENDIF ELSE BEGIN
      IF str_to_time(chast_time[i_chast]) GT str_to_time(dart1_time[i_dart1]) THEN BEGIN
        IF str_to_time(dart1_time[i_dart1]) LT str_to_time(dart2_time[i_dart2]) THEN BEGIN
          printf,outf, format= '(T26,A0)',dart1_data[i_dart1]
          i_dart1++
        ENDIF ELSE BEGIN
          IF str_to_time(dart1_time[i_dart1]) GT str_to_time(dart2_time[i_dart2]) THEN BEGIN
            printf,outf, format= '(T54,A0)',dart2_data[i_dart2]
            i_dart2++
          ENDIF ELSE BEGIN
            IF str_to_time(dart1_time[i_dart1]) EQ str_to_time(dart2_time[i_dart2]) THEN BEGIN
              printf,outf, format= '(T26,2(A0,:,", "))',dart1_data[i_dart1], dart2_data[i_dart2]
              i_dart1++
              i_dart2++
            ENDIF
          ENDELSE
        ENDELSE
      ENDIF ELSE BEGIN
        IF str_to_time(chast_time[i_chast]) EQ str_to_time(dart1_time[i_dart1]) THEN BEGIN
          IF str_to_time(chast_time[i_chast]) LT str_to_time(dart2_time[i_dart2]) THEN BEGIN
            printf,outf, format= '(2(A0,:,", "))',chast_data[i_chast],dart1_data[i_dart1]
            i_chast++
            i_dart1++
          ENDIF ELSE BEGIN
            IF str_to_time(chast_time[i_chast]) GT str_to_time(dart2_time[i_dart2]) THEN BEGIN
              printf,outf, format= '(T54,A0)',dart2_data[i_dart2]
              i_dart2++
            ENDIF ELSE BEGIN
              IF str_to_time(chast_time[i_chast]) EQ str_to_time(dart2_time[i_dart2]) THEN BEGIN
                printf,outf, format= '(3(A0,:,", "))',chast_data[i_chast], $
                  dart1_data[i_dart1],dart2_data[i_dart2]
                i_chast++
                i_dart1++
                i_dart2++
              ENDIF
            ENDELSE
          ENDELSE
        ENDIF
      ENDELSE
    ENDELSE
  ENDWHILE

  ;Take care of last dart and/or chaston lines, if any
  IF (i_chast LT n_chast) && (i_dart1 EQ n_dart1) THEN BEGIN
    IF (i_dart2 EQ n_dart2) THEN BEGIN
      print, 'Wrapping up chast lines...'
      WHILE (i_chast LT n_chast) DO BEGIN
        printf,outf, format= '(A0)',chast_data[i_chast]
        i_chast++
      ENDWHILE
    ENDIF ELSE BEGIN
      print, 'Wrapping up chast and dart2 lines...'
      WHILE ((i_chast LT n_chast) && (i_dart2 LT n_dart2)) DO BEGIN
        IF str_to_time(chast_time[i_chast]) LT str_to_time(dart2_time[i_dart2]) THEN BEGIN
          printf,outf, format= '(A0)',chast_data[i_chast]
          i_chast++
        ENDIF ELSE BEGIN
          IF str_to_time(chast_time[i_chast]) GT str_to_time(dart2_time[i_dart2]) THEN BEGIN
            printf,outf, format= '(T54,A0)',dart2_data[i_dart2]
            i_dart2++
          ENDIF ELSE BEGIN
            IF str_to_time(chast_time[i_chast]) EQ str_to_time(dart2_time[i_dart2]) THEN BEGIN
              printf,outf, format= '(A0,", ",T26,", "A0))',chast_data[i_chast], dart2_data[i_dart2]
              i_chast++
              i_dart2++
            ENDIF
          ENDELSE
        ENDELSE
      ENDWHILE
    ENDELSE
  ENDIF ELSE BEGIN
    IF (i_chast EQ n_chast) && (i_dart1 LT n_dart1) THEN BEGIN
      IF (i_dart2 EQ n_dart2) THEN BEGIN
        print, 'Wrapping up dart1 lines...'
        WHILE (i_dart1 LT n_dart1) DO BEGIN
          printf,outf, format= '(T26,A0)',dart1_data[i_dart1]
          i_dart1++
        ENDWHILE
      ENDIF ELSE BEGIN
        print, 'Wrapping up dart1 and dart2 lines...'
        WHILE ((i_dart1 LT n_dart1) && (i_dart2 LT n_dart2)) DO BEGIN
          IF str_to_time(dart1_time[i_dart1]) LT str_to_time(dart2_time[i_dart2]) THEN BEGIN
            printf,outf, format= '(A0)',dart1_data[i_dart1]
            i_dart1++
          ENDIF ELSE BEGIN
            IF str_to_time(dart1_time[i_dart1]) GT str_to_time(dart2_time[i_dart2]) THEN BEGIN
              printf,outf, format= '(T26,T26,A0)',dart2_data[i_dart2]
              i_dart2++
            ENDIF ELSE BEGIN
              IF str_to_time(dart1_time[i_dart1]) EQ str_to_time(dart2_time[i_dart2]) THEN BEGIN
                printf,outf, format= '(T26,A0,", "A0))',dart1_data[i_dart1], dart2_data[i_dart2]
                i_dart1++
                i_dart2++
              ENDIF
            ENDELSE
          ENDELSE
        ENDWHILE
        
        ;Take care of last dart1 and/or dart2 lines, if any
        IF (i_dart1 LT n_dart1) && (i_dart2 EQ n_dart2) THEN BEGIN
          print, 'Wrapping up dart1 lines...'
          WHILE (i_dart1 LT n_dart1) DO BEGIN
            printf,outf, format= '(T26,A0)',dart1_data[i_dart1]
            i_dart1++
          ENDWHILE
        ENDIF ELSE BEGIN
          IF (i_dart1 EQ n_dart1) && (i_dart2 LT n_dart2) THEN BEGIN
            print, 'Wrapping up dart lines...'
            WHILE (i_dart2 LT n_dart2) DO BEGIN
              printf,outf, format= '(T26,T26,A0)',dart2_data[i_dart2]
              i_dart2++
            ENDWHILE
          ENDIF
        ENDELSE

      ENDELSE
    ENDIF
  ENDELSE

  print, 'i_chast = ' + str(i_chast) + ' and n_chast = ' + str(n_chast)
  print, 'i_dart1 = ' + str(i_dart1) + ' and n_dart1 = ' + str(n_dart1)
  print, 'i_dart2 = ' + str(i_dart2) + ' and n_dart2 = ' + str(n_dart2)

end