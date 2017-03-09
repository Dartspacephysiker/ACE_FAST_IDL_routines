;;12/06/16
PRO CLEAR_MIMC_COMMON_VARS

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__mlt_ilat_magc_etc.pro

  PRINT,"Clearing MIMC COMMON vars ..."

  MIMC__RECALCULATE                      = !NULL
  MIMC__minMLT                           = !NULL
  MIMC__maxMLT                           = !NULL
  MIMC__minILAT                          = !NULL
  MIMC__maxILAT                          = !NULL
  MIMC__binILAT                          = !NULL
  MIMC__EA_binning                       = !NULL
  MIMC__DO_lShell                        = !NULL
  MIMC__minLSHELL                        = !NULL
  MIMC__maxLSHELL                        = !NULL
  MIMC__binLSHELL                        = !NULL
  MIMC__minMC                            = !NULL
  MIMC__maxNegMC                         = !NULL
  MIMC__sample_t_restriction             = !NULL
  MIMC__include_32Hz                     = !NULL
  MIMC__disregard_sample_t               = !NULL
  MIMC__hemi                             = !NULL
  MIMC__orbRange                         = !NULL
  MIMC__altitudeRange                    = !NULL
  MIMC__charERange                       = !NULL
  MIMC__charE__Newell_the_cusp           = !NULL
  MIMC__poyntRange                       = !NULL
  MIMC__fluxplots__remove_outliers       = !NULL
  MIMC__fluxplots__remove_log_outliers   = !NULL
  MIMC__fluxplots__add_suspect_outliers  = !NULL
  MIMC__despunDB                         = !NULL
  MIMC__chastDB                          = !NULL
  MIMC__north                            = !NULL
  MIMC__south                            = !NULL
  MIMC__both_hemis                       = !NULL
  MIMC__HwMAurOval                       = !NULL
  MIMC__HwMKpInd                         = !NULL


END
