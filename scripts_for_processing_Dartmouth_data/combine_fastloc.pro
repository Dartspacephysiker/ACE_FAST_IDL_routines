;2015/04/07 This files reads what gets parsed by rd_fastloc_output
PRO combine_fastloc,fastLoc

  Dartmouth_DB='/SPENCEdata2/software/sdt/batch_jobs/FASTloc/batch_output__intervals/'
  contents_file='./orbits_contained_in_fastloc_.txt'

  fNamePrefix='Dartmouth_fastloc_intervals2'

  outSuffix='intervals'

 ;open file to write list of orbits included
  OPENW,outlun,contents_file,/get_lun

  min_orbit=500
  max_orbit=999

  FOR j=min_orbit,max_orbit DO BEGIN

    filename='Dartmouth_as5_dflux'+'_'+strcompress(j,/remove_all)+'_0'
    ;filename='orb'+strcompress(j,/remove_all)+'_dflux'
    result=file_which(Dartmouth_DB,filename)
    IF result THEN BEGIN
       FOR jj=0,5 DO BEGIN
          result=file_which(Dartmouth_DB,filename)
          IF result THEN BEGIN
             print,j,jj
             printf,outlun,j,jj
             rdf_stats_dartmouth_as5,result,dat
             IF j GT min_orbit THEN BEGIN
                fastLoc={ORBIT:[fastLoc.orbit,dat.orbit],$
                         TIME:[fastLoc.time,dat.time],$
                         ALT:[fastLoc.alt,dat.alt],$
                         MLT:[fastLoc.mlt,dat.mlt],$
                         ILAT:[fastLoc.ilat,dat.ilat],$
                         FIELDS_MODE:[fastLoc.FIELDS_MODE,dat.FIELDS_MODE],$
                         INTERVAL:[fastLoc.INTERVAL,dat.INTERVAL],$
                         INTERVAL_START:[fastLoc.INTERVAL_START,dat.INTERVAL_START],$
                         INTERVAL_STOP:[fastLoc.INTERVAL_STOP,dat.INTERVAL_STOP]}
             ENDIF ELSE BEGIN
                fastLoc=dat
             ENDELSE
          ENDIF
          filename=fNamePrefix+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
       ENDFOR
    ENDIF
 ENDFOR
  
  save,fastLoc,filename='fastLoc_'+outSuffix+'--'+date+'.sav'
  
  RETURN
  
END
