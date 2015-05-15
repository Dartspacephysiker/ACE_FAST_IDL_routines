pro update_fastloc_intervals,fastLoc
;01/20/2015
;We're in the middle of processing tons of FAST data, and it's inconvenient to run
;this routine for the full list of files in batch_output every time. The strategy here
;is to take a database that already exists and UPDATE it!
  
  ;DB dir
  fastLoc_DB='/SPENCEdata/software/sdt/batch_jobs/FASTlocation/batch_output__intervals/'

  ;Files to deal with
  oldDBDate='20150409'

  newDBDate='20150410'

  ;; fNamePrefix='Dartmouth_fastloc_intervals'
  fNamePrefix='Dartmouth_fastloc_intervals2'
  outSuffix='intervals2'

  oldOutFileSansPref = 'fastLoc_'+outSuffix+'--'+oldDBDate
  oldOutFile = oldOutFileSansPref+'.sav'
  oldOutTimeFile = oldOutFileSansPref+'--times.sav'

  newOutFileSansPref = 'fastLoc_'+outSuffix+'--'+newDBDate
  newOutFile = newOutFileSansPref+'.sav'
  newOutTimeFile = newOutFileSansPref+'--times.sav'

  ;max orbit to check out
  max_orbit=14999

  ;do a new time file as well?
  doNewTime=1

  newContentsFile='./orbits_added_to_fastloc_'+newDBdate+'.txt'

  ;open file to write list of orbits included
  OPENW,outlun,newContentsFile,/get_lun

  ;restore old DBfile
  restore,filename=oldOutFile

  ;;Print it
  PRINT,"Old DBFile: " + oldOutFile
  PRINT,"New DBFile: " + newOutFile

  ;get latest orbit processed in old db
  latestOrb=MAX(fastloc.orbit,MIN=firstOrb)
  PRINT,"Latest orb found in oldDBFile is " + strcompress(latestOrb,/REMOVE_ALL)
  PRINT,"Earliest orb found in oldDBFile is " + strcompress(firstOrb,/REMOVE_ALL)

  IF latestOrb GE max_orbit THEN BEGIN
     PRINT, "What are you thinking? latestOrb is greater than max_orbit!"
     PRINT, "latestOrb = " + strcompress(latestOrb,/remove_all)
     PRINT, "Nothing to do here. Exiting..."
     RETURN
  ENDIF

  for j=latestOrb+1,max_orbit do begin
     filename=fNamePrefix+'_'+strcompress(j,/remove_all)+'_0'
                                ;filename='orb'+strcompress(j,/remove_all)+'_dflux'
     result=file_which(fastLoc_DB,filename)
     IF result THEN BEGIN
        FOR jj=0,5 DO BEGIN
           result=file_which(fastLoc_DB,filename)
           IF result THEN BEGIN
              print,j,jj
              printf,outlun,j,jj
              rd_fastloc_output,result,dat
              fastLoc={ORBIT:[fastLoc.orbit,dat.orbit],$
                       TIME:[fastLoc.time,dat.time],$
                       ALT:[fastLoc.alt,dat.alt],$
                       MLT:[fastLoc.mlt,dat.mlt],$
                       ILAT:[fastLoc.ilat,dat.ilat],$
                       FIELDS_MODE:[fastLoc.FIELDS_MODE,dat.FIELDS_MODE],$
                       INTERVAL:[fastLoc.INTERVAL,dat.INTERVAL],$
                       INTERVAL_START:[fastLoc.INTERVAL_START,dat.INTERVAL_START],$
                       INTERVAL_STOP:[fastLoc.INTERVAL_STOP,dat.INTERVAL_STOP]}
           ENDIF
           filename=fNamePrefix+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
        ENDFOR
     ENDIF ELSE PRINT,"Couldn't open " + filename + "!!!"
  endfor
  
  save,fastLoc,filename=newOutFile
  
  IF (doNewTime) THEN BEGIN
     fastLoc_Times=str_to_time(fastLoc.time)
     fastLoc_delta_t = shift(fastLoc_Times,-1)-fastLoc_Times
     save,fastLoc_Times,fastLoc_delta_t,FILENAME=newOutTimeFile+'_raw'
     fastLoc_delta_t[-1] = 10.0                          ;treat last element specially, since otherwise it is a huge negative number
     fastLoc_delta_t = ROUND(fastLoc_delta_t*4.0)/4.0    ;round to nearest quarter of a second
     fastLoc_delta_t(WHERE(fastLoc_delta_t GT 10.0)) = 10.0 ;many events with a large delta_t correspond to ends of intervals/orbits
     save,fastLoc_Times,fastLoc_delta_t,filename=newOutTimeFile
  ENDIF

  return

end
