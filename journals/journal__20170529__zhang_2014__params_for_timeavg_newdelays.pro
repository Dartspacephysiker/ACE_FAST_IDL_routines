;;12/02/16
;;We need some UNITY for crying out loud

   nonstorm                           = 1
   DSTcutoff                          = -25
   smooth_dst                         = 0
   use_mostRecent_Dst_files           = 1

  @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

  minMC                              = 10
  maxNegMC                           = -10

  do_timeAvg_fluxQuantities          = 1
  logAvgPlot                         = 0
  medianPlot                         = 0
  divide_by_width_x                  = 1
  org_plots_by_folder                = 1

  dont_blackball_maximus             = 1
  dont_blackball_fastloc             = 1

  ;;DB stuff
  do_despun                          = 0
  use_MAG                            = 0

  autoscale_fluxPlots                = 0
  fluxPlots__remove_outliers         = 0
  fluxPlots__remove_log_outliers     = 0

  show_integrals                     = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds                = 1

  altRange                       = [[300,4300]]

  orbRange                       = [500,12670]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 1.0

  smoothWindow                   = 0

  stableIMF                      = 14
  IMF_allowable_streak_dt        = 0

  reset_omni_inds                = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minI                           = 60
  maxI                           = 90
  ;; maskMin                        = 5
  ;; tHist_mask_bins_below_thresh   = 2
  ;; numOrbLim                      = 5

  ;; hemi                           = 'SOUTH'
  ;; minI                           = -90
  ;; maxI                           = -60
  ;; southern_hemi_plotScales          = 1
  ;; maskMin                        =  1
  ;; tHist_mask_bins_below_thresh   = 0

  ;; hemi                           = 'BOTH'

  ;; numOrbLim                      = 10

  binI                           = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binM                           = KEYWORD_SET(plotH2D_contour) OR KEYWORD_SET(shiftM_binM_for_contour)? 1.0 : 0.75 ;Why? 'Cause it 
  shiftM                         = KEYWORD_SET(plotH2D_contour) OR KEYWORD_SET(shiftM_binM_for_contour)? 0.5 : 0.0  ;means we're doing overplot stuff
  ;; binM                           = 1.0
  ;; shiftM                         = 0.5
