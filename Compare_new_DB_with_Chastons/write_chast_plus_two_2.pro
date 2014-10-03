pro write_chast_plus_two_2, chast_struct,dart1_struct,dart2_struct,arr_elem=arr_elem,filename=file

  n_chast=N_ELEMENTS(chast_struct.time)
  n_dart1=n_elements(dart1_struct.time)
  n_dart2=n_elements(dart2_struct.time)

  if not keyword_set(file) then begin
    file="./write_chast_plus_two.out"
    print, "write_chast_plus_two: No file selected! using default '" + file +"'"
  endif

  if not keyword_set(arr_elem) then begin
    print, "No array element specified! Comparing times of max current..."
    arr_elem = 1 ;default, do max current times
  endif

  ;open a file for writing
  openu,outf,file,/append,/get_lun
  printf,outf, "      Chaston orig             Dartmouth1                  Dartmouth2"

  i=0
  i_chast = 0
  i_dart1 = 0
  i_dart2 = 0

  chast_dart1_dart2_match = 0
  chast_dart1_match = 0
  chast_dart2_match = 0
  dart1_dart2_match = 0
  
  WHILE ((i_chast LT n_chast) && (i_dart1 LT n_dart1) && (i_dart2 LT n_dart2)) DO BEGIN
    IF str_to_time(chast_struct.time[i_chast]) LT str_to_time(dart1_struct.time[i_dart1]) THEN BEGIN
      IF str_to_time(chast_struct.time[i_chast]) LT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
        printf,outf, format= '(I-6,A-24)',i,str(chast_struct.(arr_elem)[i_chast])
        i_chast++
        i++
      ENDIF ELSE BEGIN
        IF str_to_time(chast_struct.time[i_chast]) GT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
          printf,outf, format= '(I-6,T60,A-0)',i,str(dart2_struct.(arr_elem)[i_dart2])
          i_dart2++
          i++
        ENDIF ELSE BEGIN
          IF str_to_time(chast_struct.time[i_chast]) EQ str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
            printf,outf, format= '(I-5,"*",A-23,", ",T60,A-0)',i,str(chast_struct.(arr_elem)[i_chast]), str(dart2_struct.(arr_elem)[i_dart2])
            i_chast++
            i_dart2++
            chast_dart2_match++
            i++
          ENDIF
        ENDELSE
      ENDELSE
    ENDIF ELSE BEGIN
      IF str_to_time(chast_struct.time[i_chast]) GT str_to_time(dart1_struct.time[i_dart1]) THEN BEGIN
        IF str_to_time(dart1_struct.time[i_dart1]) LT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
          printf,outf, format= '(I-6,T32,A-0)',i,str(dart1_struct.(arr_elem)[i_dart1])
          i_dart1++
          i++
        ENDIF ELSE BEGIN
          IF str_to_time(dart1_struct.time[i_dart1]) GT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
            printf,outf, format= '(I-6,T60,A-0)',i,str(dart2_struct.(arr_elem)[i_dart2])
            i_dart2++
            i++
          ENDIF ELSE BEGIN
            IF str_to_time(dart1_struct.time[i_dart1]) EQ str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
              printf,outf, format= '(I-5,"*",T32,2(A-23,", ",:))',i,str(dart1_struct.(arr_elem)[i_dart1]), str(dart2_struct.(arr_elem)[i_dart2])
              i_dart1++
              i_dart2++
              dart1_dart2_match++
              i++
            ENDIF
          ENDELSE
        ENDELSE
      ENDIF ELSE BEGIN
        IF str_to_time(chast_struct.time[i_chast]) EQ str_to_time(dart1_struct.time[i_dart1]) THEN BEGIN
          IF str_to_time(chast_struct.time[i_chast]) LT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
            printf,outf, format= '(I-5,"*",2(A-23,:,", "))',i,str(chast_struct.(arr_elem)[i_chast]),str(dart1_struct.(arr_elem)[i_dart1])
            i_chast++
            i_dart1++
            chast_dart1_match++
            i++
          ENDIF ELSE BEGIN
            IF str_to_time(chast_struct.time[i_chast]) GT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
              printf,outf, format= '(I-6,T60,A-0)',i,str(dart2_struct.(arr_elem)[i_dart2])
              i_dart2++
              i++
            ENDIF ELSE BEGIN
              IF str_to_time(chast_struct.time[i_chast]) EQ str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
                printf,outf, format= '(I-5,"*",3(A-23,:,", "))',i,str(chast_struct.(arr_elem)[i_chast]), $
                  str(dart1_struct.(arr_elem)[i_dart1]),str(dart2_struct.(arr_elem)[i_dart2])
                i_chast++
                i_dart1++
                i_dart2++
                chast_dart1_dart2_match++
                i++
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
        printf,outf, format= '(I-6,A-0)',i,str(chast_struct.(arr_elem)[i_chast])
        i_chast++
        i++
      ENDWHILE
    ENDIF ELSE BEGIN
      print, 'Wrapping up chast and dart2 lines...'
      WHILE ((i_chast LT n_chast) && (i_dart2 LT n_dart2)) DO BEGIN
        IF str_to_time(chast_struct.time[i_chast]) LT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
          printf,outf, format= '(I-6,A-0)',i,str(chast_struct.(arr_elem)[i_chast])
          i_chast++
          i++
        ENDIF ELSE BEGIN
          IF str_to_time(chast_struct.time[i_chast]) GT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
            printf,outf, format= '(I-6,T60,A-0)',i,str(dart2_struct.(arr_elem)[i_dart2])
            i_dart2++
            i++
          ENDIF ELSE BEGIN
            IF str_to_time(chast_struct.time[i_chast]) EQ str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
              printf,outf, format= '(I-5,"*",A-23,", ",T60,", "A-0))',i,str(chast_struct.(arr_elem)[i_chast]), str(dart2_struct.(arr_elem)[i_dart2])
              i_chast++
              i_dart2++
              chast_dart2_match++
              i++
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
          printf,outf, format= '(I-6,T32,A-0)',i,str(dart1_struct.(arr_elem)[i_dart1])
          i_dart1++
          i++
        ENDWHILE
      ENDIF ELSE BEGIN
        print, 'Wrapping up dart1 and dart2 lines...'
        WHILE ((i_dart1 LT n_dart1) && (i_dart2 LT n_dart2)) DO BEGIN
          IF str_to_time(dart1_struct.time[i_dart1]) LT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
            printf,outf, format= '(I-6,A-0)',i,str(dart1_struct.(arr_elem)[i_dart1])
            i_dart1++
            i++
          ENDIF ELSE BEGIN
            IF str_to_time(dart1_struct.time[i_dart1]) GT str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
              printf,outf, format= '(I-6,T60,A-0)',i,str(dart2_struct.(arr_elem)[i_dart2])
              i_dart2++
              i++
            ENDIF ELSE BEGIN
              IF str_to_time(dart1_struct.time[i_dart1]) EQ str_to_time(dart2_struct.time[i_dart2]) THEN BEGIN
                printf,outf, format= '(I-5,"*",T32,A-23,", "A-0))',i,str(dart1_struct.(arr_elem)[i_dart1]), str(dart2_struct.(arr_elem)[i_dart2])
                i_dart1++
                i_dart2++
                dart1_dart2_match++
                i++
              ENDIF
            ENDELSE
          ENDELSE
        ENDWHILE
        
        ;Take care of last dart1 and/or dart2 lines, if any
        IF (i_dart1 LT n_dart1) && (i_dart2 EQ n_dart2) THEN BEGIN
          print, 'Wrapping up dart1 lines...'
          WHILE (i_dart1 LT n_dart1) DO BEGIN
            printf,outf, format= '(I-6,T32,A-0)',i,str(dart1_struct.(arr_elem)[i_dart1])
            i_dart1++
            i++
          ENDWHILE
        ENDIF ELSE BEGIN
          IF (i_dart1 EQ n_dart1) && (i_dart2 LT n_dart2) THEN BEGIN
            print, 'Wrapping up dart lines...'
            WHILE (i_dart2 LT n_dart2) DO BEGIN
              printf,outf, format= '(I-6,T60,A-0)',i,str(dart2_struct.(arr_elem)[i_dart2])
              i_dart2++
              i++
            ENDWHILE
          ENDIF
        ENDELSE

      ENDELSE
    ENDIF
  ENDELSE

  print, 'i_chast = ' + str(i_chast) + ' and n_chast = ' + str(n_chast)
  print, 'i_dart1 = ' + str(i_dart1) + ' and n_dart1 = ' + str(n_dart1)
  print, 'i_dart2 = ' + str(i_dart2) + ' and n_dart2 = ' + str(n_dart2)

  printf,outf, string(13b)
  printf,outf, "Number of Chaston events   : " + str(n_chast)
  printf,outf, "Number of Dartmouth events : " + str(n_dart1)
  printf,outf, "Number of Dartmout2 events : " + str(n_dart2)
  printf,outf, string(13b)
  printf,outf, "Chaston/Dart1/Dart2 matches :" + str(chast_dart1_dart2_match)
  printf,outf, "Chaston/Dart1       matches :" + str(chast_dart1_match)
  printf,outf, "Chaston/     /Dart2 matches :" + str(chast_dart2_match)
  printf,outf, "        Dart1/Dart2 matches :" + str(dart1_dart2_match)
  
  FREE_LUN, outf

end
