;2015/04/07
;The purpose of this pro is to now take fastloc output that has been processed by combine_fastloc_intervals and to make a
;'denominator histogram', so to speak, so we know where events are actually happening. 
;This should be standardized so that these files don't get remade all the time.
;For the histogram, these things should only be divided up by altitude,mlt,and ilat.
;The default in all fastloc* programs is that delta_t=5 between data points, so I'm hardcoding that here.

PRO make_fastloc_histo,TIMEHISTO=timeHisto, $
                       MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT, $
                       MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                       MINALT=minAlt,MAXALT=maxAlt,BINALT=binAlt, $
                       DELTA_T=delta_T, $
                       FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                       OUTFILEPREFIX=outFilePrefix,OUTFILESUFFIX=outFileSuffix, OUTDIR=outDir, $
                       OUTPUT_TEXTFILE=output_textFile

  ;defaults
  defFastLocDir = '/home/spencerh/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
  defFastLocFile = 'fastLoc_intervals2--20150407.sav'
  defFastLocTimeFile = 'fastLoc_intervals2--20150407--times.sav'
  defOutFilePrefix = 'fastLoc_intervals2--'
  defOutFileSuffix = '--timeHisto'
  defOutDir = '/home/spencerh/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/fastLoc_timeHistos/'

  defDelta_T = 5 ;5 seconds

  defMinMLT = 0.0
  defMaxMLT = 24.0
  defBinMLT = 0.75

  defMinILAT = 60
  defMaxILAT = 89.0
  defBinILAT = 3.0

  ;; defMinALT = 0.0
  ;; defMaxALT = 5000.0
  ;; defBinALT = 1000.0

  ;files
  IF NOT KEYWORD_SET(fastLocDir) THEN fastLocDir = defFastLocDir
  IF NOT KEYWORD_SET(fastLocFile) THEN fastLocFile = defFastLocFile
  IF NOT KEYWORD_SET(fastLocTimeFile) THEN fastLocTimeFile = defFastLocTimeFile
  IF NOT KEYWORD_SET(outFilePrefix) THEN outFilePrefix = defOutFilePrefix
  IF NOT KEYWORD_SET(outFileSuffix) THEN outFileSuffix = defOutFileSuffix
  IF NOT KEYWORD_SET(outDir) THEN outDir = defOutDir

  IF NOT KEYWORD_SET(delta_T) THEN delta_T = defDelta_T

  ;MLT
  IF NOT KEYWORD_SET(minMLT) THEN minMLT = defMinMLT
  IF NOT KEYWORD_SET(maxMLT) THEN maxMLT = defMaxMLT
  IF NOT KEYWORD_SET(binMLT) THEN binMLT = defBinMLT

  ;ILAT
  IF NOT KEYWORD_SET(minILAT) THEN minILAT = defMinILAT
  IF NOT KEYWORD_SET(maxILAT) THEN maxILAT = defMaxILAT
  IF NOT KEYWORD_SET(binILAT) THEN binILAT = defBinILAT

  ;Don't do altitudes now
  ;; IF 
  ;; IF NOT KEYWORD_SET(minALT) THEN minALT = defMinALT
  ;; IF NOT KEYWORD_SET(maxALT) THEN maxALT = defMaxALT
  ;; IF NOT KEYWORD_SET(binALT) THEN binALT = defBinALT

  ;open dem files
  RESTORE,fastLocDir+fastLocFile
  IF FILE_TEST(fastLocDir+fastLocTimeFile) THEN RESTORE, fastLocDir+fastLocTimeFile ELSE fastLoc_Times = str_to_time(fastLoc.time)

  ;set up outfilename
  ;It's gotta be standardized!
  minOrb = MIN(fastLoc.orbit,MAX=maxOrb)
  fNameSansPref = STRING(format='(A0,I0,"-",I0,"-",G0.2,"_MLT--",I0,"-",I0,"-",G0.2,"_ILAT--orbs",I0,"-",I0,A0)', $
                         outFilePrefix,minMLT,maxMLT,binMLT,minILAT,maxILAT,binILAT,minOrb,maxOrb,outFileSuffix)
  outFileName=fNameSansPref + ".sav"

  ;are we doing a text file?
  IF KEYWORD_SET(output_textFile) THEN BEGIN
     textFileName=fNameSansPref + ".txt"
     
     OPENW,textLun,outDir+textFileName,/GET_LUN
     PRINTF,textLun,"Output from make_fastloc_histo"
     PRINTF,textLun,"The filename gives {min,max,binsize}{MLT,ILAT}--{min,max}Orb"
     PRINTF,textLun,FORMAT='("MLT",T10,"ILAT",T20,"Time in bin (minutes)")'
  ENDIF

  ;set up grid
  nXlines=(maxMLT-minMLT)/binMLT + 1
  nYlines=(maxILAT-minILAT)/binILAT + 1

  mlts=indgen(nXlines)*binMLT+minMLT
  ilats=indgen(nYlines)*binILAT+minILAT

  nMLT = N_ELEMENTS(mlts)
  nILAT = N_ELEMENTS(ilats)

  timeHisto = MAKE_ARRAY(nMLT,nILAT,/L64) ;how long FAST spends in each bin

  ;loop over MLTs and ILATs
  FOR j=0, nILAT-2 DO BEGIN 
     FOR i=0, nMLT-2 DO BEGIN 
        tempNCounts = N_ELEMENTS(WHERE(fastLoc.MLT GE mlts[i] AND fastLoc.MLT LT mlts[i+1] AND $
                                       fastLoc.ILAT GE ilats[j] AND fastLoc.ILAT LT ilats[j+1],/NULL))
        tempBinTime = tempNCounts * delta_T
        timeHisto[i,j] = tempBinTime
        
        IF KEYWORD_SET(output_textFile) THEN PRINTF,textLun,FORMAT='(G0.2,T10,G0.2,T20,G0.3)',mlts[i],ilats[j],FLOAT(tempBinTime)/60.0
     ENDFOR
  ENDFOR

  ;save the file
  save,timeHisto,FILENAME=outDir+outFileName

  IF KEYWORD_SET(output_textFile) THEN CLOSE,textLun
  
END