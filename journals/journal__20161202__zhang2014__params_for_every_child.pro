;;12/02/16
;;We need some UNITY for crying out loud

   nonstorm                           = 1
   DSTcutoff                          = -50
   smooth_dst                         = 5
   use_mostRecent_Dst_files           = 1

  @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

  include_32Hz                       = 0

  plotH2D_contour                    = 0
  plotH2D__kde                       = 1

  EA_binning                         = 1

  minMC                              = 1
  maxNegMC                           = -1

  do_timeAvg_fluxQuantities          = 1
  logAvgPlot                         = 0
  medianPlot                         = 0
  divide_by_width_x                  = 1
  org_plots_by_folder                = 1

  dont_blackball_maximus             = 1
  dont_blackball_fastloc             = 1

  ;;DB stuff
  do_despun                          = 0
  use_AACGM                          = 1
  use_MAG                            = 0

  autoscale_fluxPlots                = 0
  fluxPlots__remove_outliers         = 0
  fluxPlots__remove_log_outliers     = 0

  show_integrals                     = 1
  write_obsArr_textFile              = 1
  write_obsArr__inc_IMF              = 1
  write_obsArr__orb_avg_obs          = 1
  justData                           = 0

  ;;bonus
  make_OMNI_stuff                    = 0
  print_avg_imf_components           = KEYWORD_SET(make_OMNI_stuff)
  print_master_OMNI_file             = KEYWORD_SET(make_OMNI_stuff)
  save_master_OMNI_inds              = KEYWORD_SET(make_OMNI_stuff)
  calc_KL_sw_coupling_func           = 1
  make_integral_savfiles             = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds                = 1

  ;; altRange                    = [[340,1180], $
  ;;                             [1180,2180], $
  ;;                             [2180,3180], $
  ;;                             [3180,4180]]

  altRange                       = [[300,4300]]

  orbRange                       = [1000,10600]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 1.0

  smoothWindow                   = 9

  stableIMF                      = 9

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1800
  binOffset_delay                = 0
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  reset_omni_inds                = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 60
  ;; maxILAT                        = 90
  ;; maskMin                        = 5
  ;; tHist_mask_bins_below_thresh   = 1
  ;; numOrbLim                      = 5

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -90
  ;; maxILAT                        = -60
  ;; southern_hemi_plotScales          = 1
  ;; maskMin                        =  1
  ;; tHist_mask_bins_below_thresh   = 10

  ;; numOrbLim                      = 10

  binILAT                        = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.5
  shiftMLT                       = 0.0

