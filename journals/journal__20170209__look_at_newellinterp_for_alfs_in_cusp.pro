;;02/09/17
PRO JOURNAL__20170209__LOOK_AT_NEWELLINTERP_FOR_ALFS_IN_CUSP

  COMPILE_OPT IDL2

  @common__maximus_vars.pro

  outFile     = 'NewellInterp_for_Alfs-' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'

  good_i_dir  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170209/'
  good_i_file = 'maximus_good_i-20170209.sav'


  RESTORE,good_i_dir+good_i_file

  IF KEYWORD_SET(make_file) THEN BEGIN

     all      = MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE(/USE_COMMON_VARS)

     justGood = MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE(/USE_COMMON_VARS,USER_INDS=good_i)

     PRINT,"Saving ALL and JUSTGOOD to " + outFile + ' ...'
     SAVE,all,justGood,FILENAME=good_i_dir+outFile

  ENDIF ELSE BEGIN
     RESTORE,good_i_dir+outFile
  ENDELSE
  
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  STR_ELEMENT,justGood,'charE',ABS(justGood.jee/justGood.je)*6.242*1.0e11,/ADD_REPLACE
  ;; CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,all,all_interp
  ;; CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,justGood,justGood,/HUGE_STRUCTURE

  nooner_ii = WHERE((MAXIMUS__maximus.MLT[good_i] GE 9.5) AND $
                    (MAXIMUS__maximus.MLT[good_i] LE 14.5), $
                    nNooner, $
                    COMPLEMENT=notNooner_ii, $
                    NCOMPLEMENT=nNotNooner)
  
  goodNoon_i    = good_i[nooner_ii]
  goodNotNoon_i = good_i[notNooner_ii]

  PRINT,'************'
  PRINT,"In noon   : ",nNooner
  PRINT,"In notNoon: ",nNotNooner
  PRINT,"Tot       : ",nNooner+nNotNooner

  noonHighCE_iii = WHERE(MAXIMUS__maximus.max_charE_lossCone[goodNoon_i] GE 300, $
                        nNoonHighCE, $
                        COMPLEMENT=noonLowCE_iii, $
                        NCOMPLEMENT=nNoonLowCE)
  
  notNoonHighCE_iii = WHERE(MAXIMUS__maximus.max_charE_lossCone[goodNotNoon_i] GE 80, $
                        nNotNoonHighCE, $
                        COMPLEMENT=notNoonLowCE_iii, $
                        NCOMPLEMENT=nNotNoonLowCE)

  PRINT,'************'
  PRINT,"highCE in noon: ",nNoonHighCE,FLOAT(nNoonHighCE)/nNooner*100.,"%"
  PRINT,"lowCE  in noon: ",nNoonLowCE,FLOAT(nNoonLowCE)/nNooner*100.,"%"
  PRINT,"Tot           : ",nNoonHighCE+nNoonLowCE
  PRINT,''
  PRINT,"highCE in notNoon: ",nNotNoonHighCE,FLOAT(nNotNoonHighCE)/nNotNooner*100.,"%"
  PRINT,"lowCE  in notNoon: ",nNotNoonLowCE,FLOAT(nNotNoonLowCE)/nNotNooner*100.,"%"
  PRINT,"Tot              : ",nNotNoonHighCE+nNotNoonLowCE

  nHCE_i = goodNoon_i[noonHighCE_iii]
  nLCE_i = goodNoon_i[noonLowCE_iii]

  nNHCE_i = goodNotNoon_i[notNoonHighCE_iii]
  nNLCE_i = goodNotNoon_i[notNoonLowCE_iii]

  ;; broadBef_iii = WHERE((justGood.broad[nooner_ii] EQ 1) OR (justGood.broad[nooner_ii] EQ 2), $
  ;;                 nBroadBef)
  ;; monoBef_iii  = WHERE((justGood.mono[nooner_ii] EQ 1) OR (justGood.mono[nooner_ii] EQ 2), $
  ;;                 nMonoBef)
  ;; diffBef_iii  = WHERE((justGood.diffuse[nooner_ii] EQ 1) OR (justGood.diffuse[nooner_ii] EQ 2), $
  ;;                    nDiffBef)
  ;; PRINT,''
  ;; PRINT,"BroadBef : ",nBroadBef,FLOAT(nBroadBef)/nNooner*100.,"%"
  ;; PRINT,"MonoBef  : ",nMonoBef,FLOAT(nMonoBef)/nNooner*100.,"%"
  ;; PRINT,"DiffBef  : ",nDiffBef,FLOAT(nDiffBef)/nNooner*100.,"%"

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
  ;; PRINT,"BroadAft : ",nBroadAft,FLOAT(nBroadAft)/nNooner*100.,"%"
  ;; PRINT,"MonoAft  : ",nMonoAft,FLOAT(nMonoAft)/nNooner*100.,"%"
  ;; PRINT,"DiffAft  : ",nDiffAft,FLOAT(nDiffAft)/nNooner*100.,"%"

  PRINT,''
  PRINT,'****************************************'
  PRINT,''
  PRINT,"These should all be discarded, based on whahappun to the Alfven waves"
  PRINT,''
  
  broadBef_iii = WHERE((justGood.broad[nooner_ii[noonLowCE_iii]] EQ 1) OR (justGood.broad[nooner_ii[noonLowCE_iii]] EQ 2), $
                  nBroadBef)
  monoBef_iii  = WHERE((justGood.mono[nooner_ii[noonLowCE_iii]] EQ 1) OR (justGood.mono[nooner_ii[noonLowCE_iii]] EQ 2), $
                  nMonoBef)
  diffBef_iii  = WHERE((justGood.diffuse[nooner_ii[noonLowCE_iii]] EQ 1) OR (justGood.diffuse[nooner_ii[noonLowCE_iii]] EQ 2), $
                     nDiffBef)
  PRINT,''
  PRINT,"BroadBef : ",nBroadBef,FLOAT(nBroadBef)/nNooner*100.,"%"
  PRINT,"MonoBef  : ",nMonoBef,FLOAT(nMonoBef)/nNooner*100.,"%"
  PRINT,"DiffBef  : ",nDiffBef,FLOAT(nDiffBef)/nNooner*100.,"%"

  ;; justGood.broad[nooner_ii[noonLowCE_iii]] = 0

  ;; justGood.info.converted = 0
  justGNoon = {x       : justGood.x    [nooner_ii], $
               mlt     : justGood.mlt  [nooner_ii], $
               broad   : justGood.broad[nooner_ii], $
               mono    : justGood.mono [nooner_ii], $
               diffuse : justGood.diffuse[nooner_ii], $
               charE   : justGood.charE[nooner_ii], $
               tDiff   : justGood.tDiff[nooner_ii], $
               info    : justGood.info}

  ;; CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,justGood,alfESpec,/VERBOSE
  CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,justGNoon,alfNoon,/VERBOSE
  
  ;; broadAft_iii = WHERE((alfESpec.broad[nooner_ii[noonLowCE_iii]] EQ 1) OR (alfESpec.broad[nooner_ii[noonLowCE_iii]] EQ 2), $
  ;;                 nBroadAft)
  ;; monoAft_iii  = WHERE((alfESpec.mono[nooner_ii[noonLowCE_iii]] EQ 1) OR (alfESpec.mono[nooner_ii[noonLowCE_iii]] EQ 2), $
  ;;                 nMonoAft)
  ;; diffAft_iii  = WHERE((alfESpec.diffuse[nooner_ii[noonLowCE_iii]] EQ 1) OR (alfESpec.diffuse[nooner_ii[noonLowCE_iii]] EQ 2), $
  ;;                 nDiffAft)

  broadAft_iii = WHERE((alfNoon.broad[noonLowCE_iii] EQ 1) OR (alfNoon.broad[noonLowCE_iii] EQ 2), $
                  nBroadAft)
  monoAft_iii  = WHERE((alfNoon.mono[noonLowCE_iii] EQ 1) OR (alfNoon.mono[noonLowCE_iii] EQ 2), $
                  nMonoAft)
  diffAft_iii  = WHERE((alfNoon.diffuse[noonLowCE_iii] EQ 1) OR (alfNoon.diffuse[noonLowCE_iii] EQ 2), $
                  nDiffAft)

  PRINT,''
  PRINT,"BroadAft : ",nBroadAft,FLOAT(nBroadAft)/nNooner*100.,"%"
  PRINT,"MonoAft  : ",nMonoAft,FLOAT(nMonoAft)/nNooner*100.,"%"
  PRINT,"DiffAft  : ",nDiffAft,FLOAT(nDiffAft)/nNooner*100.,"%"

  STOP


END
