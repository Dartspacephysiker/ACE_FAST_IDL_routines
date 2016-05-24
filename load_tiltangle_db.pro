PRO LOAD_TILTANGLE_DB,tiltAngle, $
                 TANGLEDBDIR=tAngleDBDir, $
                 TANGLEDBFILE=tAngleDBFile, $
                 ;; LOAD_CULLED_OMNI_DB=load_culled_omni_db, $
                 FORCE_LOAD_DB=force_load_db, $
                 LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  deftAngleDBDir           = '/SPENCEdata/Research/database/geopack_data/'
  deftAngleDBFile          = 'GEOPACK--dipole_tilt_angle--1990--2010.dat'

  ;; defCulledSWDBDir     = '/SPENCEdata/Research/database/processed/'
  ;; defCulledSWDBFile    = 'culled_OMNI_magdata_struct.dat'

  IF N_ELEMENTS(tAngleDBDir) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
     ;;    swDBDir = defCulledSWDBDir
     ;; ENDIF ELSE BEGIN
        tAngleDBDir = deftAngleDBDir
     ;; ENDELSE
  ENDIF
  IF N_ELEMENTS(tAngleDBFile) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
     ;;    swDBFile = defCulledSWDBFile
     ;; ENDIF ELSE BEGIN
        tAngleDBFile = deftAngleDBFile
        ;; ENDELSE
  ENDIF

  IF N_ELEMENTS(tAngle) EQ 0 OR KEYWORD_SET(force_load_db) THEN BEGIN
     IF KEYWORD_SET(force_load_db) THEN BEGIN
        PRINTF,lun,"Forced loading of tiltAngle database ..."
     ENDIF
     ;; IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
     ;;    PRINTF,lun,'Loading culled OMNI DB: ' + tAngleDBDir+tAngleDBFile + '...'
     ;;    restore,tAngleDBDir+tAngleDBFile
     ;;    tAngle  = tAngle_culled
     ;; ENDIF ELSE BEGIN
        PRINTF,lun,'Loading tiltAngle DB: ' + tAngleDBDir+tAngleDBFile + '...'
        restore,tAngleDBDir+tAngleDBFile
     ;; ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,'tiltAngle DB already loaded! Not restoring ' + tAngleDBFile + '...'
  ENDELSE

  RETURN

END