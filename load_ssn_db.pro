PRO LOAD_SSN_DB,ssn, $
                 SSNDBDIR=ssnDBDir, $
                 SSNDBFILE=ssnDBFile, $
                 ;; LOAD_CULLED_OMNI_DB=load_culled_omni_db, $
                 FORCE_LOAD_DB=force_load_db, $
                 LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  defSSNDBDir           = '/SPENCEdata/Research/database/sw_omnidata/'
  defSSNDBFile          = 'SSN--20160430--V2.dat'

  ;; defCulledSWDBDir     = '/SPENCEdata/Research/database/processed/'
  ;; defCulledSWDBFile    = 'culled_OMNI_magdata_struct.dat'

  IF N_ELEMENTS(ssnDBDir) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
     ;;    swDBDir = defCulledSWDBDir
     ;; ENDIF ELSE BEGIN
        ssnDBDir = defSSNDBDir
     ;; ENDELSE
  ENDIF
  IF N_ELEMENTS(ssnDBFile) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
     ;;    swDBFile = defCulledSWDBFile
     ;; ENDIF ELSE BEGIN
        ssnDBFile = defSSNDBFile
        ;; ENDELSE
  ENDIF

  IF N_ELEMENTS(ssn) EQ 0 OR KEYWORD_SET(force_load_db) THEN BEGIN
     IF KEYWORD_SET(force_load_db) THEN BEGIN
        PRINTF,lun,"Forced loading of SSN database ..."
     ENDIF
     ;; IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
     ;;    PRINTF,lun,'Loading culled OMNI DB: ' + ssnDBDir+ssnDBFile + '...'
     ;;    restore,ssnDBDir+ssnDBFile
     ;;    ssn  = ssn_culled
     ;; ENDIF ELSE BEGIN
        PRINTF,lun,'Loading SSN DB: ' + ssnDBDir+ssnDBFile + '...'
        restore,ssnDBDir+ssnDBFile
     ;; ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,'SSN DB already loaded! Not restoring ' + ssnDBFile + '...'
  ENDELSE

  RETURN

END