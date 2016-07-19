PRO LOAD_KP_DB,Kp,DBFILE=dbFile,DBDIR=dbDir, $
               LUN=lun

  COMMON KP,KP__Kp,KP__dbDir,KP__dbFile

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN  BEGIN
     lun      = -1
  ENDIF

  defDBDir    = '/SPENCEdata/Research/database/OMNI/'
  defDBFile   = 'Kp__1980-2010.sav'

  IF N_ELEMENTS(KP__KP) NE 0 AND ~KEYWORD_SET(force_load_db) THEN BEGIN
     PRINT,'Restoring Kp DB already in memory...'
     Kp       = KP__Kp
     dbDir    = KP__dbDir
     dbFile   = KP__dbFile
     RETURN
  ENDIF

  IF N_ELEMENTS(dbDir) EQ 0 THEN BEGIN
     dbDir    = defDbDir

  ENDIF
  KP__dbDir   = dbDir

  IF N_ELEMENTS(dbFile) EQ 0 THEN BEGIN
     
     dbFile   = defDbFile

  ENDIF
  KP__dbFile  = dbFile
  
  IF N_ELEMENTS(Kp) EQ 0 OR KEYWORD_SET(force_load_db) THEN BEGIN
     IF KEYWORD_SET(force_load_db) THEN BEGIN
        PRINTF,lun,"Forced loading of Kp database ..."
     ENDIF

     PRINTF,lun,'Loading Kp DB: ' + dbDir+dbFile + '...'
     RESTORE,dbDir+dbFile
     
  ENDIF ELSE BEGIN
     PRINTF,lun,'Kp DB already loaded! Not restoring ' + dbFile + '...'
  ENDELSE
  KP__Kp      = Kp

  RETURN

END