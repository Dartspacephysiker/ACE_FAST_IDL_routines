;;02/09/17
PRO JOURNAL__20170209__LOOK_AT_NEWELLINTERP_FOR_ALFS_IN_CUSP

  COMPILE_OPT IDL2

  outFile     = 'NewellInterp_for_Alfs-' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'

  good_i_dir  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170209/'
  good_i_file = 'maximus_good_i-20170209.sav'

  RESTORE,good_i_dir+good_i_file

  all      = MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE(/USE_COMMON_VARS)

  justGood = MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE(/USE_COMMON_VARS,USER_INDS=good_i)

  PRINT,"Saving ALL and JUSTGOOD to " + outFile + ' ...'
  SAVE,all,justGood,FILENAME=good_i_dir+outFile

END
