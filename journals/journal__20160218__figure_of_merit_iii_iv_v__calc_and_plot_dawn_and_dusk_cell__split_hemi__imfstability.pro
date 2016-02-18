;;2016/02/18
;;And now, try all this stuff with stable IMF!
PRO JOURNAL__20160218__FIGURE_OF_MERIT_III_IV_V__CALC_AND_PLOT_DAWN_AND_DUSK_CELL__SPLIT_HEMI__IMFSTABILITY

  hemiStrings            = ['NORTH','SOUTH']
  plotHemi               = 'BOTH'
  fom_type               = [3,4,5]
  FOMStrings             = ['III','IV','V']

  cell_to_plot           = ['DAWN','DUSK']

  ;; stableIMF              = 5
  plotYRange             = [0.00,0.1]
  ;; fileDay                = 'Feb_17_16'
  ;; fileDia                = '20160218'

  stableIMF              = 10
  ;; plotYRange             = [0.00,0.02]
  fileDay                = 'Feb_18_16'
  fileDia                = '20160218'

  h2dFileDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/20160217--Alfven_cusp_figure_of_merit/' + $
                           STRCOMPRESS(stableIMF,/REMOVE_ALL) + 'minstable/data/'

  ;; scale_plots_to_1       = 1
  subtract_center        = 0
  ;; detrend_window         = 8 ;minutes

  auto_adjust_yRange     = 0

  FOR i=0,N_ELEMENTS(fom_type)-1 DO BEGIN
     FOR j=0,N_ELEMENTS(hemiStrings)-1 DO BEGIN
        JOURNAL__20160218__FIGURE_OF_MERIT_III_IV_V_FOR_CUSP_SPLITTING__NORTH_OR_SOUTH__IMFSTABILITY, $
           HEMI=hemiStrings[j], $
           FOMSTRING=FOMStrings[i], $
           SUBTRACT_CENTER=subtract_center, $
           FILEDAY=fileDay, $
           STABLEIMF=stableIMF
     ENDFOR

     PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_AND_DUSK_CELL__SPLIT_HEMI__SINGLE_WINDOW, $
        HEMI='BOTH', $
        FILEDAY=fileDia, $
        H2DFILEDIR=h2dFileDir, $
        STABLEIMF=stableIMF, $
        ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
        ;; INCLUDE_ALLIMF=include_allIMF, $
        FOM_TYPE=fom_type[i], $
        COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
        DETREND_WINDOW=detrend_window, $
        AUTO_ADJUST_YRANGE=auto_adjust_yRange, $
        SCALE_PLOTS_TO_1=scale_plots_to_1, $
        PLOTYRANGE=plotYRange, $
        /SAVEPLOTS, $
        LUN=lun

  ENDFOR
        
 END