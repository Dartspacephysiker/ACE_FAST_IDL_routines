PRO LOAD_OMNI_DB,omniDB

  OMNI_DBFile = '/SPENCEdata/Research/Cusp/database/sw_omnidata/sw_data.dat'

  PRINT,'Loading ' + OMNI_DBFile + '...'
  restore,OMNI_DBFile

  omniDB=sw_data

END