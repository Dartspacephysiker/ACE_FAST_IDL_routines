PRO LOAD_OMNI_DB,sw_data,SWDBDIR=swDBDir,SWDBFILE=swDBFile,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  defSWDBDir           = '/SPENCEdata/Research/Cusp/database/sw_omnidata/'
  defSWDBFile          = 'sw_data.dat'

  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir = defSWDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile = defSWDBFile

  IF N_ELEMENTS(sw_data) EQ 0 THEN BEGIN
     PRINTF,lun,'Loading ' + swDBDir+swDBFile + '...'
     restore,swDBDir+swDBFile
  ENDIF ELSE BEGIN
     PRINTF,lun,'OMNI DB already loaded! Not restoring' + swDBFile + '...'
  ENDELSE

  RETURN

END