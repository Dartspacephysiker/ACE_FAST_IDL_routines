;;11/25/16
FUNCTION GET_LATEST_OMNI_INDS_FILE

  COMPILE_OPT IDL2

  saveDir = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/'
  fName   = 'latest_OMNI_inds.txt'

  SPAWN,'cat ' + saveDir+fName,fName

  RETURN,fName
END
