PRO PRINT_MIN_MAX_NUNIQ_IN_MAXIMUS,maximus,maxInd,max_i,max_iName,CDBTIME=cdbTime,N=n,UNIQ_ii=uniq_max_ii

  maxTags=TAG_NAMES(maximus)

  IF N_ELEMENTS(maxInd) EQ 0 THEN BEGIN

     PRINT,'No provided maxInd! Here are the names of them for you: '
     FOR i=0,N_ELEMENTS(maxTags)-1 DO PRINT,FORMAT='(I0,T8,A0)',i,maxTags(i)

     RETURN
  ENDIF

  IF N_ELEMENTS(max_iName) EQ 0 THEN max_iName = maxTags(maxInd)

  N = N_ELEMENTS(max_i)

  check_sorted,max_i
  check_dupes,max_i

  uniq_max_ii=UNIQ((maximus.(maxInd))(max_i))

  IF N_ELEMENTS(cdbTime) GT 0 THEN minTime= MIN(cdbTime(max_i),minTime_ii,MAX=maxTime,SUBSCRIPT_MAX=maxTime_ii)
  
  PRINT,'***************'
  PRINT,'Stats for ' + STRUPCASE(max_iName)
  PRINT,''
  PRINT,'Min ' + max_iName + ': ' + STRCOMPRESS(MIN((maximus.(maxInd))(max_i)),/REMOVE_ALL)
  PRINT,'Max ' + max_iName + ': ' + STRCOMPRESS(MAX((maximus.(maxInd))(max_i)),/REMOVE_ALL)
  PRINT,''

  IF N_ELEMENTS(cdbTime) GT 0 THEN BEGIN
     PRINT,'Earliest time for ' + max_iName + ': ' + (maximus.time(max_i))(minTime_ii)
     PRINT,'Latest time for ' + max_iName + ': ' + (maximus.time(max_i))(maxTime_ii)
     PRINT,''
  ENDIF

  PRINT,'N Elements in provided inds: ' + STRCOMPRESS(N,/REMOVE_ALL)
  PRINT,'N uniq ' + max_iName + ': ' + STRCOMPRESS(N_ELEMENTS(uniq_max_ii),/REMOVE_ALL)
  PRINT,''

END