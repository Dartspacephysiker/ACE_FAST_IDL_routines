;;12/02/16
;;We need some UNITY for crying out loud

   nonstorm                           = 1
   DSTcutoff                          = -40
   smooth_dst                         = 0
   use_mostRecent_Dst_files           = 1

  @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

  include_32Hz                       = 0

  plotH2D_contour                    = 0
  ;; plotH2D__kde                       = 1
  plotH2D__kde                       = KEYWORD_SET(plotH2D_contour)

  EA_binning                         = 0

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
  use_AACGM                          = 0
  use_MAG                            = 0

  autoscale_fluxPlots                = 0
  fluxPlots__remove_outliers         = 0
  fluxPlots__remove_log_outliers     = 0

  show_integrals                     = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds                = 1

  altRange                       = [[300,4300]]

  orbRange                       = [1000,10600]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 1.0

  smoothWindow                   = 0

  stableIMF                      = 4

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1200
  binOffset_delay                = 0
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  reset_omni_inds                = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 90
  ;; maskMin                        = 5
  ;; tHist_mask_bins_below_thresh   = 1
  ;; numOrbLim                      = 5

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -90
  ;; maxILAT                        = -60
  ;; southern_hemi_plotScales          = 1
  ;; maskMin                        =  1
  ;; tHist_mask_bins_below_thresh   = 0

  ;; numOrbLim                      = 10

  binILAT                        = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  shiftMLT                       = 0.5

