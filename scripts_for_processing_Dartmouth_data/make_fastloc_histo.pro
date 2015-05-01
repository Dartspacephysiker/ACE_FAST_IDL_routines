;2015/04/07
;The purpose of this pro is to now take fastloc output that has been processed by combine_fastloc_intervals and to make a
;'denominator histogram', so to speak, so we know where events are actually happening. 
;This should be standardized so that these files don't get remade all the time.
;For the histogram, these things should only be divided up by altitude,mlt,and ilat.
;The default in all fastloc* programs is that delta_t=5 between data points, so I'm hardcoding that here.

PRO make_fastloc_histo,TIMEHISTO=timeHisto, FASTLOC_INDS=fastLoc_inds, $
                       MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT, $
                       MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                       MINALT=minAlt,MAXALT=maxAlt,BINALT=binAlt, $
                       DELTA_T=delta_T, $
                       FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                       OUTFILEPREFIX=outFilePrefix,OUTFILESUFFIX=outFileSuffix, OUTDIR=outDir, $
                       OUTPUT_TEXTFILE=output_textFile

  ;defaults
  defFastLocDir = '/home/spencerh/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
  defFastLocFile = 'fastLoc_intervals2--20150409.sav'
  defFastLocTimeFile = 'fastLoc_intervals2--20150409--times.sav'
  defOutFilePrefix = 'fastLoc_intervals2--'
  defOutFileSuffix = '--timeHisto'
  defSmallestMinBinStr = '--smallestBinMin'
  defOutDir = '/home/spencerh/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/fastLoc_timeHistos/'

  defDelta_T = 5 ;5 seconds

  ;; defMinMLT = 0.0
  ;; defMaxMLT = 24.0
  defMinMLT = 6.0
  defMaxMLT = 18.0
  defBinMLT = 0.75

  defMinILAT = 60
  ;; defMaxILAT = 89.0
  ;; defBinILAT = 3.0
  defMaxILAT = 84.0
  defBinILAT = 2.0

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
  IF FILE_TEST(fastLocDir+fastLocTimeFile) THEN RESTORE, fastLocDir+fastLocTimeFile 
  
  ;avoid any trickery
  nFastLoc = N_ELEMENTS(fastLoc.orbit)
  nFastLoc_Times = N_ELEMENTS(fastLoc_Times)
  IF nFastLoc NE nFastLoc_Times THEN BEGIN
     PRINT,"Something is wrong. nFastLoc = " + strcompress(nFastLoc) + " while nFastLoc_Times = " + strcompress(nFastLoc_Times) + "."
     PRINT,"Fix it! In the meantime, we're quitting."
     RETURN
  ENDIF

  IF fastLoc_delta_t EQ !NULL THEN BEGIN
     IF fastLoc_Times EQ !NULL THEN fastLoc_Times = str_to_time(fastLoc.time)
     fastLoc_delta_t = shift(fastLoc_Times,-1)-fastLoc_Times
     save,fastLoc_Times,fastLoc_delta_t,FILENAME=fastLocDir+fastLocTimeFile+'_raw'
     fastLoc_delta_t[-1] = 10.0                             ;treat last element specially, since otherwise it is a huge negative number
     fastLoc_delta_t = ROUND(fastLoc_delta_t*8.0)/8.0 ;round to nearest eigth of a second
     fastLoc_delta_t(WHERE(fastLoc_delta_t GT 10.0)) = 10.0 ;many events with a large delta_t correspond to ends of intervals/orbits
     save,fastLoc_Times,fastLoc_delta_t,FILENAME=fastLocDir+fastLocTimeFile
  ENDIF

  ;Are we only using a user-supplied array of indices?
  IF KEYWORD_SET(fastLoc_inds) THEN BEGIN
     fastLoc={ORBIT:fastLoc.orbit(fastLoc_inds),$
                          TIME:fastLoc.time(fastLoc_inds),$
                          ALT:fastLoc.alt(fastLoc_inds),$
                          MLT:fastLoc.mlt(fastLoc_inds),$
                          ILAT:fastLoc.ilat(fastLoc_inds),$
                          FIELDS_MODE:fastLoc.FIELDS_MODE(fastLoc_inds),$
                          INTERVAL:fastLoc.INTERVAL(fastLoc_inds),$
                          INTERVAL_START:fastLoc.INTERVAL_START(fastLoc_inds),$
                          INTERVAL_STOP:fastLoc.INTERVAL_STOP(fastLoc_inds)$
             }

     fastLoc_Times = fastLoc_Times(fastLoc_inds)
     fastLoc_delta_t = fastLoc_delta_t(fastLoc_inds)
  ENDIF

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

  timeHisto = MAKE_ARRAY(nMLT,nILAT,/DOUBLE) ;how long FAST spends in each bin

  ;loop over MLTs and ILATs
  FOR j=0, nILAT-2 DO BEGIN 
     FOR i=0, nMLT-2 DO BEGIN 
        ;; tempNCounts = N_ELEMENTS(WHERE(fastLoc.MLT GE mlts[i] AND fastLoc.MLT LT mlts[i+1] AND $
        ;;                                fastLoc.ILAT GE ilats[j] AND fastLoc.ILAT LT ilats[j+1],/NULL))
        ;; tempBinTime = tempNCounts * delta_T
        tempInds = WHERE(fastLoc.MLT GE mlts[i] AND fastLoc.MLT LT mlts[i+1] AND $
                                       fastLoc.ILAT GE ilats[j] AND fastLoc.ILAT LT ilats[j+1],/NULL)
        IF tempInds NE !NULL THEN BEGIN
           tempBinTime = TOTAL(DOUBLE(fastLoc_delta_t(tempInds)))
           timeHisto[i,j] = tempBinTime

           IF KEYWORD_SET(output_textFile) THEN PRINTF,textLun,FORMAT='(F0.2,T10,F0.2,T20,F0.3)',mlts[i],ilats[j],DOUBLE(tempBinTime)/60.0
        ENDIF ELSE tempBinTime = DOUBLE(0.0)
     ENDFOR
  ENDFOR

  ;save the file
  IF NOT KEYWORD_SET(fastLoc_Inds) AND $
  NOT (outFilePrefix EQ defOutFilePrefix) OR NOT (outFileSuffix EQ defOutFileSuffix) THEN BEGIN
     save,timeHisto,FILENAME=outDir+outFileName
     print,'Saving ' + outDir+outFileName + '...'
  ENDIF

  IF KEYWORD_SET(output_textFile) THEN CLOSE,textLun
  
END