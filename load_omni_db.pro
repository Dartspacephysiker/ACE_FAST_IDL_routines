PRO LOAD_OMNI_DB,sw_data, $
                 SWDBDIR=swDBDir, $
                 SWDBFILE=swDBFile, $
                 LOAD_CULLED_OMNI_DB=load_culled_omni_db, $
                 FORCE_LOAD_DB=force_load_db, $
                 LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  defSWDBDir           = '/SPENCEdata/Research/Cusp/database/sw_omnidata/'
  defSWDBFile          = 'sw_data.dat'

  defCulledSWDBDir     = '/SPENCEdata/Research/Cusp/database/processed/'
  defCulledSWDBFile    = 'culled_OMNI_magdata_struct.dat'

  IF N_ELEMENTS(swDBDir) EQ 0 THEN BEGIN
     IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
        swDBDir = defCulledSWDBDir
     ENDIF ELSE BEGIN
        swDBDir = defSWDBDir
     ENDELSE
  ENDIF
  IF N_ELEMENTS(swDBFile) EQ 0 THEN BEGIN
     IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
        swDBFile = defCulledSWDBFile
     ENDIF ELSE BEGIN
        swDBFile = defSWDBFile
        ENDELSE
  ENDIF

  IF N_ELEMENTS(sw_data) EQ 0 OR KEYWORD_SET(force_load_db) THEN BEGIN
     IF KEYWORD_SET(force_load_db) THEN BEGIN
        PRINTF,lun,"Forced loading of OMNI database ..."
     ENDIF
     IF KEYWORD_SET(load_culled_omni_db) THEN BEGIN
        PRINTF,lun,'Loading culled OMNI DB: ' + swDBDir+swDBFile + '...'
        restore,swDBDir+swDBFile
        sw_data  = sw_data_culled
     ENDIF ELSE BEGIN
        PRINTF,lun,'Loading OMNI DB: ' + swDBDir+swDBFile + '...'
        restore,swDBDir+swDBFile
     ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,'OMNI DB already loaded! Not restoring ' + swDBFile + '...'
  ENDELSE

  RETURN

END