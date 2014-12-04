pro write_dbfiles_3, dbf1_struct, dbf2_struct, arr_elem1=arr_elem1, filename=file, $
  check_current_thresh=check_c, max_tdiff=max_tdiff, $
  dbf1_is_as5=dbf1_is_as5, dbf2_is_as5=dbf2_is_as5, $
  dbf1_only_alfvenic=dbf1_only_alfvenic, dbf2_only_alfvenic=dbf2_only_alfvenic, $
  dbf1_check_sorted=dbf1_check_sorted, dbf2_check_sorted=dbf2_check_sorted, $
  check_sorted=check_sorted, _extra = e

;This one incorporates the idea from my most recent meeting with Professor LaBelle that we ought
;to say that two points are a match if they're within a few milliseconds of each other. 
;Let's see how this changes the statistics...
 
  if ISA(e) THEN BEGIN
    print,"Why the following extra parameters? They have no home...:"
    help,e
    RETURN
  endif

  ;make sure we're not dealing with dupes
  IF KEYWORD_SET(dbf1_check_sorted) OR KEYWORD_SET(check_sorted) THEN BEGIN
     ;For dbf1 struct
     uniq_times_i2=uniq(str_to_time(dbf1_struct.time),sort(str_to_time(dbf1_struct.time)))
     tags_dbf1=tag_names(dbf1_struct)
     ntags_dbf1=n_elements(tags_dbf1)
     tmp = create_struct(tags_dbf1[0], dbf1_struct.(0)(uniq_times_i2))
     for i=1,ntags_dbf1-1 do tmp = create_struct(tmp, tags_dbf1[i],dbf1_struct.(i)(uniq_times_i2))
     print,"Original number of elements  in dbf1_struct : " + strcompress(n_elements(dbf1_struct.time),/REMOVE_ALL)
     print,"Number of duplicate elements in dbf1_struct : " + strcompress(n_elements(dbf1_struct.time)-n_elements(uniq_times_i2),/REMOVE_ALL)
     dbf1_struct = tmp
  ENDIF

  IF KEYWORD_SET(dbf2_check_sorted) OR KEYWORD_SET(check_sorted) THEN BEGIN
     ;For dbf2 struct
     uniq_times_i2=uniq(str_to_time(dbf2_struct.time),sort(str_to_time(dbf2_struct.time)))
     tags_dbf2=tag_names(dbf2_struct)
     ntags_dbf2=n_elements(tags_dbf2)
     tmp = create_struct(tags_dbf2[0], dbf2_struct.(0)(uniq_times_i2))
     for i=1,ntags_dbf2-1 do tmp = create_struct(tmp, tags_dbf2[i],dbf2_struct.(i)(uniq_times_i2))
     print,"Original number of elements  in dbf2_struct : " + strcompress(n_elements(dbf2_struct.time),/REMOVE_ALL)
     print,"Number of duplicate elements in dbf2_struct : " + strcompress(n_elements(dbf2_struct.time)-n_elements(uniq_times_i2),/REMOVE_ALL)
     dbf2_struct = tmp
  ENDIF
  

  ;index of mag_current in structs for as3 files
  dbf2_magc_ind = 5 
  dbf1_magc_ind = 5

  ;default, do max current times
  if not keyword_set(arr_elem1) then begin
    print, "No array element specified! Comparing times of max current..."
    IF KEYWORD_SET(dbf1_is_as5) THEN dbf1_arr_elem = 2 ELSE dbf1_arr_elem = 1
 endif

  ;Setup indexing into structs for each dbfile to compare desired data products
  IF KEYWORD_SET(dbf2_is_as5) AND NOT KEYWORD_SET(dbf1_is_as5) THEN BEGIN
     print,"dbfile1          : as3"
     print,"dbfile2          : as5"
    dbf2_magc_ind = 6
    ;Array to match as5 data with as3 data
    dbf2_as5_arr_elem = [0,-1,1,2,3,4,5,6,7,-1,$
                         8,-1,9,-1,10,11,12,13,14,15,$
                         16,17,18,19,21,20,22,23,24,25,$
                         26,27,28,-1,-1,-1,-1]
    dbf1_as3_arr_elem = [0,2,3,4,5,6,7,8,10,12, $
                         14,15,16,17,18,19,20,21,22,23,$
                         25,24,26,27,28,29,30,31,32,-1,-1,$
                         -1,-1,-1]
    dbf2_arr_elem = dbf1_as3_arr_elem[arr_elem1]
    dbf1_arr_elem = arr_elem1
;;    print,"arr_elem1        : " + strcompress(arr_elem1,/REMOVE_ALL)
    print,"dbfile1 arr_elem : " + strcompress(dbf1_arr_elem,/REMOVE_ALL)
    print,"dbfile2 arr_elem : " + strcompress(dbf2_arr_elem,/REMOVE_ALL)

    IF dbf2_arr_elem LE -1.0 THEN BEGIN
      PRINT, "ERROR! You're attempting to use Alfven_Stats_5 array element " +strcompress(arr_elem,/REMOVE_ALL) + " for comparison, but DBFile1 doesn't include this calculation!"
      PRINT, "Exiting..."
      RETURN
    ENDIF
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(dbf1_is_as5) AND NOT KEYWORD_SET(dbf2_is_as5) THEN BEGIN
        print,"dbfile1          : as5"
        print,"dbfile2          : as3"
        dbf1_magc_ind = 6
        ;Array to match as5 data with as3 data
        dbf1_as5_arr_elem = [0,-1,1,2,3,4,5,6,7,-1,8,-1,9, $ ; =(max_chare_losscone), Not sure if max_chare_losscone or max_chare_total correspond to char_elec_energy
                             -1,10,11,12,13,14,15,16,17,18,19,21,20, $ ;fields mode
                             22,23,24,25,26,27,28,-1,-1,-1,-1]
        dbf2_arr_elem = dbf1_as5_arr_elem[arr_elem1]
        dbf1_as5_arr_elem=arr_elem1
;;        print,"arr_elem         : " + strcompress(arr_elem,/REMOVE_ALL)
        print,"dbfile1 arr_elem : " + strcompress(dbf1_arr_elem,/REMOVE_ALL)
        print,"dbfile2 arr_elem : " + strcompress(dbf2_arr_elem,/REMOVE_ALL)

        IF dbf2_arr_elem LE -1.0 THEN BEGIN
           PRINT, "ERROR! You're attempting to use Alfven_Stats_5 array element " +strcompress(arr_elem,/REMOVE_ALL) + " for comparison, but DBFile2 doesn't include this calculation!"
           PRINT, "Exiting..."
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(dbf1_is_as5) AND KEYWORD_SET(dbf2_is_as5) THEN BEGIN
           print,"dbfile1          : as5"
           print,"dbfile2          : as5"
           dbf1_magc_ind = 6
           dbf2_magc_ind = 6
           dbf1_arr_elem = arr_elem
           dbf2_arr_elem = arr_elem
;;           print,"arr_elem         : " + strcompress(arr_elem,/REMOVE_ALL)
           print,"dbfile1 arr_elem : " + strcompress(dbf1_arr_elem,/REMOVE_ALL)
           print,"dbfile2 arr_elem : " + strcompress(dbf2_arr_elem,/REMOVE_ALL)
        ENDIF 
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(dbf1_only_alfvenic) THEN BEGIN
    IF NOT KEYWORD_SET(dbf1_is_as5) THEN BEGIN
     print,"Keyword set to use only Alfvènic events with as3 dbfile1! No such parameter exists..."
     RETURN
    ENDIF ELSE BEGIN
       print, "Only considering Alfvènic DBFile1 events"
       keep_dbf1=where(dbf1_struct.alfvenic GT 0)
       n_dbf1=n_elements(keep_dbf1)
       dbf1_struct.time = dbf1_struct.time(keep_dbf1)
       dbf1_struct.(dbf1_arr_elem) = dbf1_struct.(dbf1_arr_elem)(keep_dbf1)
    ENDELSE
 ENDIF ELSE BEGIN
    n_dbf1=n_elements(dbf1_struct.time)
 ENDELSE

  IF KEYWORD_SET(dbf2_only_alfvenic) THEN BEGIN
    IF NOT KEYWORD_SET(dbf2_is_as5) THEN BEGIN
     print,"Keyword set to use only Alfvènic events with as3 dbfile2! No such parameter exists..."
     RETURN
    ENDIF ELSE BEGIN
       print, "Only considering Alfvènic DBFile2 events"
       keep_dbf2=where(dbf2_struct.alfvenic GT 0)
       n_dbf2=n_elements(keep_dbf2)
       dbf2_struct.time = dbf2_struct.time(keep_dbf2)
       dbf2_struct.(dbf2_arr_elem) = dbf2_struct.(dbf2_arr_elem)(keep_dbf2)
    ENDELSE
 ENDIF ELSE BEGIN
    n_dbf2=n_elements(dbf2_struct.time)
 ENDELSE


  if not keyword_set(file) then begin
    file="./write_dbfiles_3.out"
    print, "write_dbfiles_3: No file selected! using default '" + file +"'"
  endif

  ;open a file for writing
  openu,outf,file,/append,/get_lun 

  ;set up tdiff stuff
  if NOT KEYWORD_SET(max_tdiff) OR max_tdiff EQ !NULL then begin
     max_tdiff = 0.00           ;maximum time difference in seconds to qualify as a match
     print, "***No max time_difference specified...using " + str(max_tdiff) + " seconds"
     printf,outf, "***No max time_difference specified...using " + str(max_tdiff) + " seconds"
  endif ELSE BEGIN
     print, "***Using max_tdiff="+strcompress(max_tdiff,/REMOVE_ALL) + " seconds"
     printf,outf, "***Using max_tdiff="+strcompress(max_tdiff,/REMOVE_ALL) + " seconds"
     printf,outf,""
  ENDELSE

  ;help,dbf1_struct,/str
  ;help,dbf2_struct,/str 

  printf,outf, "      DBFile1                  DBFile2                     DBF1 ind      DBF2 ind"

  i = 0
  i_dbf1 = 0
  i_dbf2 = 0
  
  matches = 0
  
  dbf1_ct = 0 ;current threshold counters
  dbf2_ct = 0
  ct_matches = 0
  dbf1ct_ind = []
  dbf1ct_eig = []
  dbf2ct_ind = []
  dbf2ct_eig = []
  matchct_ind = []
  matchct_eig = []
  
  tdiff = 0
  
  WHILE ((i_dbf1 LT n_dbf1) && (i_dbf2 LT n_dbf2)) DO BEGIN
     
     tdiff = str_to_time(dbf1_struct.time[i_dbf1]) - str_to_time(dbf2_struct.time[i_dbf2])

     IF ABS(tdiff) GT max_tdiff THEN BEGIN
        IF (ABS(tdiff) GT 0.000001) AND (tdiff/ABS(tdiff) LT 0) THEN BEGIN
           printf,outf, format= '(I-6,A-24,T60,I-4)',i,str(dbf1_struct.(dbf1_arr_elem)[i_dbf1]),i_dbf1
           if ( KEYWORD_SET(check_c) && (dbf1_struct.(dbf1_magc_ind)[i_dbf1] GT check_c) ) then begin
              dbf1ct_ind = [dbf1ct_ind, i]
              dbf1_ct++
              dbf1ct_eig = [dbf1ct_eig, i_dbf1]
           endif
           i_dbf1++
           i++
        ENDIF ELSE BEGIN
           IF FINITE(tdiff/ABS(tdiff)) GT 0.0 THEN BEGIN
              printf,outf, format= '(I-6,T32,A-0,T74,I-4)',i,str(dbf2_struct.(dbf2_arr_elem)[i_dbf2]),i_dbf2
              if ( KEYWORD_SET(check_c) && (dbf2_struct.(dbf2_magc_ind)[i_dbf2] GT check_c) ) then begin
                 dbf2ct_ind = [dbf2ct_ind, i]
                 dbf2ct_eig = [dbf2ct_eig, i_dbf2]
                 dbf2_ct++
              endif
              i_dbf2++
              i++
           ENDIF
        ENDELSE
     ENDIF ELSE BEGIN
        IF ABS(tdiff) GE 0.00005 THEN BEGIN
           printf,outf, format= '(I-5,"!",2(A-23,:,", "))',i,$
                  str(dbf1_struct.(dbf1_arr_elem)[i_dbf1]), str(dbf2_struct.(dbf2_arr_elem)[i_dbf2])
        ENDIF ELSE BEGIN
           printf,outf, format= '(I-5,"*",2(A-23,:,", "))',i,$
                  str(dbf1_struct.(dbf1_arr_elem)[i_dbf1]), str(dbf2_struct.(dbf2_arr_elem)[i_dbf2])
        ENDELSE
        if ( KEYWORD_SET(check_c) && (dbf1_struct.(dbf1_magc_ind)[i_dbf1] GT check_c) ) then begin
           matchct_ind = [matchct_ind, i]
           matchct_eig = [matchct_eig, i_dbf2]
           dbf1_ct++
           dbf2_ct++
           ct_matches++
        endif

        i_dbf1++
        i_dbf2++
        matches++
        i++
     ENDELSE
;  ENDELSE
  ENDWHILE

  ;Take care of last dbf2 and/or chaston lines, if any
  IF (i_dbf1 LT n_dbf1) && (i_dbf2 EQ n_dbf2) THEN BEGIN
    print, 'Wrapping up dbf1 lines...'
    WHILE (i_dbf1 LT n_dbf1) DO BEGIN
      printf,outf, format= '(I-6,A-24,T60,I-4)',i,dbf1_struct.(dbf1_arr_elem)[i_dbf1],i_dbf1
      if ( KEYWORD_SET(check_c) && (dbf1_struct.(dbf1_magc_ind)[i_dbf1] GT check_c) ) then begin
        dbf1ct_ind = [dbf1ct_ind, i]
        dbf1ct_eig = [dbf1ct_eig, i_dbf1]
        dbf1_ct++
      endif
      i_dbf1++
      i++
    ENDWHILE
  ENDIF ELSE BEGIN
    IF (i_dbf1 EQ n_dbf1) && (i_dbf2 LT n_dbf2) THEN BEGIN
      print, 'Wrapping up dbf2 lines...'
      WHILE (i_dbf2 LT n_dbf2) DO BEGIN
        printf,outf, format= '(I-6,T32,A-24,T74,I-4)',i,dbf2_struct.(dbf2_arr_elem)[i_dbf2],i_dbf2
        if ( KEYWORD_SET(check_c) && (dbf2_struct.(dbf2_magc_ind)[i_dbf2] GT check_c) ) then begin
          dbf2ct_ind = [dbf2ct_ind, i]
          dbf2ct_eig = [dbf2ct_eig, i_dbf2]
          dbf2_ct++
        endif
        i_dbf2++
        i++
      ENDWHILE
    ENDIF
  ENDELSE

  print, 'i_dbf1 = ' + str(i_dbf1) + ' and n_dbf1 = ' + str(n_dbf1)
  print, 'i_dbf2 = ' + str(i_dbf2) + ' and n_dbf2 = ' + str(n_dbf2)
  print, 'matches = ' +str(matches)

  if KEYWORD_SET(check_c) then begin
    print, string(13b)
    printf,outf, string(13b)
    print, 'Current threshold: ' + str(check_c) + ' microA/m^2'
    printf,outf, 'Current threshold: ' + str(check_c) + ' microA/m^2'
    print, string(13b)
    printf,outf, string(13b)
    print, 'DBFile1 events above cur_thresh            =   ' + str(dbf1_ct)
    printf,outf, 'DBFile1 events above cur_thresh            =   ' + str(dbf1_ct)
    IF dbf1ct_ind NE !NULL THEN BEGIN
      print, format='("Line numbers of qualifying DBFile1 events    : ",(T48,8(I-6)))',$
        dbf1ct_ind
      printf,outf, format='("Line numbers of qualifying DBFile1 events    : ",(T48,8(I-6)))',$
        dbf1ct_ind
      print,format='("Time of DBFile1 events                       :",(T48,3(A-25)))',$
        dbf1_struct.time[dbf1ct_eig]
      printf,outf,format='("Time of DBFile1 events                       :",(T48,3(A-25)))',$
        dbf1_struct.time[dbf1ct_eig]
    ENDIF
    print, string(13b)
    printf,outf, string(13b)
    print, 'DBFile2 events above cur_thresh            =   ' + str(dbf2_ct)
    printf,outf, 'DBFile2 events above cur_thresh            =   ' + str(dbf2_ct)
    IF dbf2ct_ind NE !NULL THEN BEGIN
      print, format='("Line numbers of qualifying DBFile2 events  : ",(T48,8(I-6)))',dbf2ct_ind
      printf,outf, format='("Line numbers of qualifying DBFile2 events  : ",(T48,8(I-6)))',dbf2ct_ind
      print,format='("Time of DBFile2 events                     :",(T48,3(A-25)))',$
        dbf2_struct.time[dbf2ct_eig]
      printf,outf,format='("Time of DBFile2 events                     :",(T48,3(A-25)))',$
        dbf2_struct.time[dbf2ct_eig]
    ENDIF
    print, string(13b)
    printf,outf, string(13b)
    print, 'Matching events above cur thresh           =    ' + str(ct_matches)
    printf,outf, 'Matching events above cur thresh           =    ' + str(ct_matches)
    IF matchct_ind NE !NULL THEN BEGIN
      print, format='("Line numbers of qualifying matching events : ",(T48,8(I-6)))',matchct_ind
      printf,outf, format='("Line numbers of qualifying matched events  : ",(T48,8(I-6)))',matchct_ind
      print,format='("Time of matching events                    :",(T48,3(A-25)))',dbf2_struct.time[matchct_eig]
      printf,outf,format='("Time of matching events                    :",(T48,3(A-25)))',$
        dbf2_struct.time[matchct_eig]
    ENDIF
 
  endif

  printf,outf, string(13b)
  printf,outf, "DBFile1 events   : " + str(n_dbf1)
  printf,outf, "DBFile2 events   : " + str(n_dbf2)
  printf,outf, 'Total matches    : ' +str(matches)
  FREE_LUN, outf

end
