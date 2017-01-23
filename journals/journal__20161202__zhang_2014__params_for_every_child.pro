;;12/02/16
;;We need some UNITY for crying out loud

   nonstorm                           = 1
   DSTcutoff                          = -40
   smooth_dst                         = 0
   use_mostRecent_Dst_files           = 0

  @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

  plotH2D_contour                    = 1
  ;; plotH2D__kde                       = 1
  plotH2D__kde                       = KEYWORD_SET(plotH2D_contour)
  contour__levels                    = KEYWORD_SET(plotH2D_contour) ? [0,20,40,60,80,100] : !NULL
  contour__percent                   = KEYWORD_SET(plotH2D_contour)

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
  use_MAG                            = 0

  autoscale_fluxPlots                = 0
  fluxPlots__remove_outliers         = 0
  fluxPlots__remove_log_outliers     = 0

  show_integrals                     = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds                = 1

  altRange                       = [[750,4300]]

  orbRange                       = [1000,10800]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 1.0

  smoothWindow                   = 0

  stableIMF                      = 4

  ;;Delay stuff
  ;; nDelays                        = 1
  delayDeltaSec                  = 1200
  binOffset_delay                = 0
  ;; delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
  ;; delayArr                       = 300
  delayArr                       = 0

  reset_omni_inds                = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  ;; minI                           = 60
  ;; maxI                           = 90
  ;; maskMin                        = 5
  ;; tHist_mask_bins_below_thresh   = 1
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
  binM                           = 1.0
  shiftM                         = 0.5
