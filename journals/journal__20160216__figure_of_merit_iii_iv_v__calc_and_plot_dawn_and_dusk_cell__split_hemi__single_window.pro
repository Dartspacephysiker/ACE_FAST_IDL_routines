;;2016/02/16
;;Fancify
PRO JOURNAL__20160216__FIGURE_OF_MERIT_III_IV_V__CALC_AND_PLOT_DAWN_AND_DUSK_CELL__SPLIT_HEMI__SINGLE_WINDOW

  hemiStrings            = ['NORTH','SOUTH']
  plotHemi               = 'BOTH'
  fom_type               = [3,4,5]
  FOMStrings             = ['III','IV','V']

  cell_to_plot           = ['DAWN','DUSK']

  plotYRange             = [0.00,0.05]
  
  h2dFileDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/20160216--Alfven_cusp_figure_of_merit/data/'
  fileDia                = '20160216'

  ;; scale_plots_to_1       = 1
  subtract_center        = 0
  ;; detrend_window         = 8 ;minutes

  auto_adjust_yRange     = 1

  FOR i=0,N_ELEMENTS(fom_type)-1 DO BEGIN
     FOR j=0,N_ELEMENTS(hemiStrings)-1 DO BEGIN
        JOURNAL__20160216__FIGURE_OF_MERIT_III_IV_V_FOR_CUSP_SPLITTING__NORTH_OR_SOUTH__ROUND_TWO, $
           HEMI=hemiStrings[j], $
           FOMSTRING=FOMStrings[i], $
           SUBTRACT_CENTER=subtract_center
     ENDFOR

     PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_AND_DUSK_CELL__SPLIT_HEMI__SINGLE_WINDOW, $
        HEMI='BOTH', $
        FILEDAY=fileDia, $
        H2DFILEDIR=h2dFileDir, $
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