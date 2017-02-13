;;02/09/17
PRO JOURNAL__20170209__LOOK_AT_NEWELLINTERP_FOR_ALFS_IN_CUSP

  COMPILE_OPT IDL2

  @common__maximus_vars.pro

  inDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  inFile          = 'Dartdb_20151222--500-16361_inc_lower_lats--max_magCurrent_time_alfs_into_20170203_eSpecDB__good_i.sav'
  inFile          = inDir + inFile
  
  make_file       = 1

  pasApresMidi    = 1

  ;; outFile      = 'NewellInterp_for_Alfs-' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'
  outFile         = 'NewellInterp_for_cusp_Alfs-' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'

  ;; good_i_dir   = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170209/'
  ;; good_i_file  = 'maximus_good_i-20170209.sav'
  good_i_dir      = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170210/'
  good_i_file     = 'maximus_good_i__NORTH-20170210.sav'


  RESTORE,good_i_dir+good_i_file

  IF KEYWORD_SET(make_file) THEN BEGIN

     IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
        LOAD_MAXIMUS_AND_CDBTIME
     ENDIF
     
     all      = MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE(!NULL,!NULL,!NULL, $
                                                              inFile, $
                                                              /USE_COMMON_VARS, $
                                                              /DONT_MAP_TO_100KM)

     nBef     = N_ELEMENTS(good_i)
     nooner_i = WHERE((MAXIMUS__maximus.MLT GE 9.5) AND $
                      (MAXIMUS__maximus.MLT LE 14.5), $
                      nNooner, $
                      COMPLEMENT=notNooner_i, $
                      NCOMPLEMENT=nNotNooner)

     IF KEYWORD_SET(pasApresMidi) THEN BEGIN
        restStr  = '!noon'
        good_i   = CGSETINTERSECTION(good_i,notNooner_i,COUNT=nAft)
        nGNooner = nAft
     ENDIF ELSE BEGIN
        restStr  = 'noon'
        good_i   = CGSETINTERSECTION(good_i,nooner_i,COUNT=nAft)
        nGNooner = nAft
     ENDELSE
     
     PRINT,FORMAT='("Lost ",I0," inds to ",A0," restriction")',nBef-nAft,restStr

     justGood = MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE(/USE_COMMON_VARS, $
                                                              USER_INDS=good_i, $
                                                              /DONT_MAP_TO_100KM)

     PRINT,"Saving ALL and JUSTGOOD to " + outFile + ' ...'
     SAVE,all,justGood,FILENAME=good_i_dir+outFile

  ENDIF ELSE BEGIN
     RESTORE,good_i_dir+outFile
  ENDELSE
  
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  ;; STR_ELEMENT,justGood,'charE',ABS(justGood.jee/justGood.je)*6.242*1.0e11,/ADD_REPLACE
  ;; CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,all,all_interp
  ;; CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,justGood,justGood,/HUGE_STRUCTURE

  ;; nooner_ii = WHERE((MAXIMUS__maximus.MLT[good_i] GE 9.5) AND $
  ;;                   (MAXIMUS__maximus.MLT[good_i] LE 14.5), $
  ;;                   nNooner, $
  ;;                   COMPLEMENT=notNooner_ii, $
  ;;                   NCOMPLEMENT=nNotNooner)
  
  ;; goodNoon_i    = good_i[nooner_ii]
  ;; goodNotNoon_i = good_i[notNooner_ii]

  PRINT,'************'
  PRINT,"In noon   : ",nGNooner
  PRINT,"In notNoon: ",nNotNooner
  PRINT,"Tot       : ",nGNooner+nNotNooner

  noonHighCE_ii  = WHERE(MAXIMUS__maximus.max_charE_lossCone[good_i] GE 80, $
                        nNoonHighCE, $
                        COMPLEMENT=noonLowCE_ii, $
                        NCOMPLEMENT=nNoonLowCE)
  
  IF MAXIMUS__maximus.info.mapped.mag_current THEN BEGIN
     PRINT,"Temp unmap mag_current ..."
     LOAD_MAPPING_RATIO_DB,mapRatio
     MAXIMUS__maximus.mag_current /= mapRatio.ratio
  ENDIF

  noonmagcge10_ii = WHERE(ABS(MAXIMUS__maximus.mag_current[good_i]) GE 10, $
                         nNoonMagCGE10, $
                         COMPLEMENT=noonmagclt10_ii, $
                         NCOMPLEMENT=nNoonMagCLT10)
  IF MAXIMUS__maximus.info.mapped.mag_current THEN BEGIN
     MAXIMUS__maximus.mag_current *= (TEMPORARY(mapRatio)).ratio
  ENDIF

  noonhighCEGE10_ii = CGSETINTERSECTION(noonHighCE_ii,noonmagcge10_ii,COUNT=nNoonHighCEGE10)
  noonlowCEGE10_ii = CGSETINTERSECTION(noonLowCE_ii,noonmagcge10_ii,COUNT=nNoonLowCEGE10)

  ;; notNoonHighCE_iii = WHERE(MAXIMUS__maximus.max_charE_lossCone[goodNotNoon_i] GE 80, $
  ;;                       nNotNoonHighCE, $
  ;;                       COMPLEMENT=notNoonLowCE_iii, $
  ;;                       NCOMPLEMENT=nNotNoonLowCE)

  PRINT,'************'
  PRINT,FORMAT='("highCE in ",A0,": ")',restStr,nNoonHighCE,FLOAT(nNoonHighCE)/nGNooner*100.,"%"
  PRINT,FORMAT='("lowCE  in ",A0,": ")',restStr,nNoonLowCE,FLOAT(nNoonLowCE)/nGNooner*100.,"%"
  PRINT,"Tot           : ",nNoonHighCE+nNoonLowCE
  PRINT,''
  PRINT,'************'
  PRINT,FORMAT='("highCEGE10 in ",A0,": ")',restStr,nNoonHighCEGE10,FLOAT(nNoonHighCEGE10)/nNoonMagCGE10*100.,"%"
  PRINT,FORMAT='("lowCEGE10  in ",A0,": ")',restStr,nNoonLowCEGE10,FLOAT(nNoonLowCEGE10)/nNoonMagCGE10*100.,"%"
  PRINT,"TotGE10           : ",nNoonHighCEGE10+nNoonLowCEGE10
  PRINT,''
  ;; PRINT,"highCE in notNoon: ",nNotNoonHighCE,FLOAT(nNotNoonHighCE)/nNotNooner*100.,"%"
  ;; PRINT,"lowCE  in notNoon: ",nNotNoonLowCE,FLOAT(nNotNoonLowCE)/nNotNooner*100.,"%"
  ;; PRINT,"Tot              : ",nNotNoonHighCE+nNotNoonLowCE

  nHCE_i = good_i[noonHighCE_ii]
  nLCE_i = good_i[noonLowCE_ii]

  ;; nNHCE_i = goodNotNoon_i[notNoonHighCE_iii]
  ;; nNLCE_i = goodNotNoon_i[notNoonLowCE_iii]

  ;; broadBef_iii = WHERE((justGood.broad[nooner_ii] EQ 1) OR (justGood.broad[nooner_ii] EQ 2), $
  ;;                 nBroadBef)
  ;; monoBef_iii  = WHERE((justGood.mono[nooner_ii] EQ 1) OR (justGood.mono[nooner_ii] EQ 2), $
  ;;                 nMonoBef)
  ;; diffBef_iii  = WHERE((justGood.diffuse[nooner_ii] EQ 1) OR (justGood.diffuse[nooner_ii] EQ 2), $
  ;;                    nDiffBef)
  ;; PRINT,''
  ;; PRINT,"BroadBef : ",nBroadBef,FLOAT(nBroadBef)/nGNooner*100.,"%"
  ;; PRINT,"MonoBef  : ",nMonoBef,FLOAT(nMonoBef)/nGNooner*100.,"%"
  ;; PRINT,"DiffBef  : ",nDiffBef,FLOAT(nDiffBef)/nGNooner*100.,"%"

  ;; ;; justGood.broad[nooner_ii[noonLowCE_iii]] = 0
  ;; ;; justGood.broad[nooner_ii[noonHighCE_iii]] = 0

  ;; justGood.info.converted = 0
  ;; CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,justGood,alfESpec
  
  ;; broadAft_iii = WHERE((alfESpec.broad[nooner_ii] EQ 1) OR (alfESpec.broad[nooner_ii] EQ 2), $
  ;;                 nBroadAft)
  ;; monoAft_iii  = WHERE((alfESpec.mono[nooner_ii] EQ 1) OR (alfESpec.mono[nooner_ii] EQ 2), $
  ;;                 nMonoAft)
  ;; diffAft_iii  = WHERE((alfESpec.diffuse[nooner_ii] EQ 1) OR (alfESpec.diffuse[nooner_ii] EQ 2), $
  ;;                 nDiffAft)

  ;; PRINT,''
  ;; PRINT,"BroadAft : ",nBroadAft,FLOAT(nBroadAft)/nGNooner*100.,"%"
  ;; PRINT,"MonoAft  : ",nMonoAft,FLOAT(nMonoAft)/nGNooner*100.,"%"
  ;; PRINT,"DiffAft  : ",nDiffAft,FLOAT(nDiffAft)/nGNooner*100.,"%"

  PRINT,''
  PRINT,'****************************************'
  PRINT,''
  PRINT,"These should all be discarded, based on whahappun to the Alfven waves"
  PRINT,''
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;First, the weak currents
  
  ;; discrimInds  = noonLowCE_ii
  ;; discrimInds  = LINDGEN(N_ELEMENTS(justGood.broad))

  discrimInds  = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(justGood.broad)),justGood.disqual_i,COUNT=cnt)
  nGNooner     = cnt
  
  broadBef_iii = WHERE((justGood.broad[discrimInds] EQ 1) OR (justGood.broad[discrimInds] EQ 2), $
                  nBroadBef)
  monoBef_iii  = WHERE((justGood.mono[discrimInds] EQ 1) OR (justGood.mono[discrimInds] EQ 2), $
                  nMonoBef)
  ;; diffBef_iii  = WHERE((justGood.diffuse[discrimInds] EQ 1) OR (justGood.diffuse[discrimInds] EQ 2), $
  ;;                    nDiffBef)
  diffBef_iii  = WHERE(( (justGood.broad[discrimInds] EQ 0) OR (justGood.broad[discrimInds] GT 2) ) AND $
                       ( (justGood.mono[discrimInds]  EQ 0) OR (justGood.mono[discrimInds]  GT 2) ),nDiffBef)

  nTotBef      = nBroadBef+nMonoBef+nDiffBef
  PRINT,''
  PRINT,"BroadBef : ",nBroadBef,FLOAT(nBroadBef)/nGNooner*100.,"%"
  PRINT,"MonoBef  : ",nMonoBef,FLOAT(nMonoBef)/nGNooner*100.,"%"
  PRINT,"DiffBef  : ",nDiffBef,FLOAT(nDiffBef)/nGNooner*100.,"%"
  PRINT,"TotBef   : ",nTotBef,FLOAT(nTotBef)/nGNooner*100.,"%"

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Then, the not-weak currents

  discrimInds  = CGSETDIFFERENCE(noonmagcge10_ii,justGood.disqual_i,COUNT=cnt)
  nGNooner     = cnt
  
  broadGE10_iii = WHERE((justGood.broad[discrimInds] EQ 1) OR (justGood.broad[discrimInds] EQ 2), $
                  nBroadGE10)
  monoGE10_iii  = WHERE((justGood.mono[discrimInds] EQ 1) OR (justGood.mono[discrimInds] EQ 2), $
                  nMonoGE10)
  ;; diffGE10_iii  = WHERE((justGood.diffuse[discrimInds] EQ 1) OR (justGood.diffuse[discrimInds] EQ 2), $
  ;;                    nDiffGE10)
  diffGE10_iii  = WHERE(( (justGood.broad[discrimInds] EQ 0) OR (justGood.broad[discrimInds] GT 2) ) AND $
                       ( (justGood.mono[discrimInds]  EQ 0) OR (justGood.mono[discrimInds]  GT 2) ),nDiffGE10)

  nTotGE10      = nBroadGE10+nMonoGE10+nDiffGE10
  PRINT,''
  PRINT,"BroadGE10 : ",nBroadGE10,FLOAT(nBroadGE10)/nGNooner*100.,"%"
  PRINT,"MonoGE10  : ",nMonoGE10,FLOAT(nMonoGE10)/nGNooner*100.,"%"
  PRINT,"DiffGE10  : ",nDiffGE10,FLOAT(nDiffGE10)/nGNooner*100.,"%"
  PRINT,"TotGE10   : ",nTotGE10,FLOAT(nTotGE10)/nGNooner*100.,"%"


  ;; broadAft_iii = WHERE((alfNoon.broad[discrimInds] EQ 1) OR (alfNoon.broad[discrimInds] EQ 2), $
  ;;                 nBroadAft)
  ;; monoAft_iii  = WHERE((alfNoon.mono[discrimInds] EQ 1) OR (alfNoon.mono[discrimInds] EQ 2), $
  ;;                 nMonoAft)
  ;; diffAft_iii  = WHERE((alfNoon.diffuse[discrimInds] EQ 1) OR (alfNoon.diffuse[discrimInds] EQ 2), $
  ;;                 nDiffAft)

  ;; PRINT,''
  ;; PRINT,"BroadAft : ",nBroadAft,FLOAT(nBroadAft)/nGNooner*100.,"%"
  ;; PRINT,"MonoAft  : ",nMonoAft,FLOAT(nMonoAft)/nGNooner*100.,"%"
  ;; PRINT,"DiffAft  : ",nDiffAft,FLOAT(nDiffAft)/nGNooner*100.,"%"

  STOP


END
