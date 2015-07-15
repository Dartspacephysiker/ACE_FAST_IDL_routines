PRO PRINT_MAXIMUS,maximus,indices,ALLTAGS=allTags,LUN=lun


  IF (N_ELEMENTS(indices) EQ 0) THEN BEGIN
     PRINT,"Gotta give a range of indices, friend"
     PRINT,"Usage: PRINT_MAXIMUS,maximus,indices,ALLTAGS=allTags,LUN=lun"
     RETURN
  ENDIF ELSE nInd=n_elements(indices)
  
  IF (nInd GT 1000) THEN BEGIN
     PRINT,"indices has more than 1000 elements!"
     respuesta=''
     READ, respuesta, PROMPT='Continue (Y/N)? '
     IF STRMATCH(STRLOWCASE(respuesta),'n') THEN BEGIN
     ;; CASE STRLOWCASE(respuesta) OF
        ;; 'y' : CONTINUE
        ;; 'n' : BEGIN
           PRINT,"Ending..."
           RETURN
        ;; END
     ;; ENDCASE
        ENDIF ELSE PRINT,"Printing " + STRCOMPRESS(n_elements(indices),/REMOVE_ALL) + $
                         " elements..."
  ENDIF

  tags=TAG_NAMES(maximus)
  IF KEYWORD_SET(allTags) THEN nTags=N_ELEMENTS(tags) ELSE nTags=28

  tArray=MAKE_ARRAY(nTags,/LONG)
  fArray=MAKE_ARRAY(nTags,/STRING)
  FOR i=0,nTags-1 DO BEGIN 
     tArray(i)=SIZE(maximus.(i),/TYPE)
     case tArray(i) of 
        2: fArray(i) = 'I0'
        4: fArray(i) = 'F0.4'
        7: fArray(i) = 'A0'
     endcase
  ENDFOR

  strNTags=STRCOMPRESS(nTags-1,/REMOVE_ALL)
  PRINT,FORMAT = '('+strNTags+'(A0, :, ", "))', tags(0:nTags-1)
  
  FOR i=0,nInd-1 DO BEGIN
     PRINT,"*************************************"
     PRINT,"ind = " + STRCOMPRESS(i,/REMOVE_ALL)
     FOR j=0,nTags-1 DO PRINT,FORMAT='(A20,": ",'+fArray(j)+')',tags(j),(maximus.(j))(indices(i))
  ENDFOR

END