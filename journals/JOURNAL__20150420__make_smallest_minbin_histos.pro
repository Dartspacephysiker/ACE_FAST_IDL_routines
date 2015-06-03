PRO JOURNAL_make_smallest_minbin_histos__20150420

  date='20150420'
  timeHistoDir='fastLoc_timeHistos/'
  ;dawn = 0
  ;dusk = 1
  ;allIMF = 2
  nFiles = 3
  clockNames = MAKE_ARRAY(nFiles,/STRING)
  clockNames[0]='all_IMF'
  clockNames[1]='dawnward'
  clockNames[2]='duskward'


  ;filenames
  fNames = MAKE_ARRAY(nFiles,/STRING)
  fNames[0]='fastLoc_intervals2--all_IMF_180.00-180.00deg--OMNI_GSM--byMin_0.0--stableIMF_0min--delay_660--smoothWindow_5min.sav'
  fNames[1]='fastLoc_intervals2--dawnward_45.00-135.00deg--OMNI_GSM--byMin_5.0--stableIMF_1min--delay_660--smoothWindow_5min.sav'
  fNames[2]='fastLoc_intervals2--duskward_45.00-135.00deg--OMNI_GSM--byMin_5.0--stableIMF_1min--delay_660--smoothWindow_5min.sav'

  FOR i=0,nFiles-1 DO BEGIN
     curFile = timeHistoDir+fNames[i]
     print,'Doing ' + clockNames[i] + ' file...'
     print,'Filename: ' + curFile
     restore,curFile

     ;get param string
     suffLoc = strpos(fNames[i],'.sav')
     outFNameBare=strmid(fNames[i],20,suffLoc-20)

     make_fastloc_histo,fastloc_inds=fastLocInterped_i, $
                        outfileprefix='fastLoc_intervals2--'+outFNameBare+'--', $
                        outfilesuffix='--timehisto--'+date,/output_textfile

  ENDFOR
  


END