;;11/25/16
FUNCTION GET_LATEST_OMNI_INDS

  COMPILE_OPT IDL2

  latestFile = GET_LATEST_OMNI_INDS_FILE()

  IF ~FILE_TEST(latestFile) THEN BEGIN
     PRINT,"Couldn't restore OMNI inds file: " + latestFile
     RETURN,-1
  ENDIF

  RESTORE,latestFile

  structStr = 'struct = CREATE_STRUCT("params",out_paramString_list'
  IF N_ELEMENTS(out_plot_i_list) GT 0 THEN BEGIN
     structStr += ',"alfdb",out_plot_i_list'
  ENDIF
  IF N_ELEMENTS(out_fastLoc_i_list) GT 0 THEN BEGIN
     structStr += ',"fastLoc",out_fastLoc_i_list'
  ENDIF
  IF N_ELEMENTS(out_i_nonAlfven_eSpec_list) GT 0 THEN BEGIN
     structStr += ',"nonAlf_eSpec",out_i_nonAlfven_eSpec_list'
  ENDIF
  IF N_ELEMENTS(out_i_nonAlfven_ion_list) GT 0 THEN BEGIN
     out_i_nonAlfven_ion_list    = indices__nonAlfven_ion_list
     structStr += '"nonAlf_ion",out_i_nonAlfven_ion_list'
  ENDIF  

  IF N_ELEMENTS(indsInfoStr) GT 0 THEN BEGIN
     bro = EXECUTE('haveInfo = N_ELEMENTS(' + indsInfoStr + ') GT 0')
     IF haveInfo THEN BEGIN
        structStr += '"info",' + indsInfoStr
     ENDIF ELSE BEGIN
        PRINT,"Who lied to you?"
        STOP
     ENDELSE
  ENDIF

  structStr += ')'
  bro = EXECUTE(structStr)

  IF bro EQ 0 OR N_ELEMENTS(struct) EQ 0 THEN BEGIN
     PRINT,"GET_LATEST_OMNI_INDS: Couldn't restore struct!"
  ENDIF

  RETURN,struct

END
