;2015/04/07
;The purpose of this pro is to now take fastloc output that has been processed by combine_fastloc_intervals and to make a
;'denominator histogram', so to speak, so we know where events are actually happening. 
;This should be standardized so that these files don't get remade all the time.
;For the histogram, these things should only be divided up by altitude,mlt,and ilat.
;The default in all fastloc* programs is that delta_t=5 between data points, so I'm hardcoding that here.

PRO make_fastloc_histo,MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT, $
                       MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                       MINALT=minAlt,MAXALT=maxAlt,BINALT=binAlt

  ;defaults
  defFastLocDir = '/home/spencerh/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data'
  defFastLocFile = 'fastLoc_intervals2--20150407.sav'
  defFastLocTimes = 'fastLoc_intervals2--20150407--times.sav'

  defMinMLT = 0.0
  defMaxMLT = 24.0
  defBinMLT = 0.75

  defMinILAT = 60
  defMaxILAT = 89.0
  defBinILAT = 3.0

  ;; defMinALT = 0.0
  ;; defMaxALT = 5000.0
  ;; defBinALT = 1000.0

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

  ;set up grid
  nXlines=(maxMLT-minMLT)/binMLT + 1
  nYlines=(maxILAT-minILAT)/binILAT + 1

  mlts=indgen(nXlines)*binMLT+minMLT
  ilats=indgen(nYlines)*binILAT+minILAT

END