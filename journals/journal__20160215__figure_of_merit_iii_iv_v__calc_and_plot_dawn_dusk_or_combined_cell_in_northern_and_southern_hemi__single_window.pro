;;2016/02/13
;;Fancify
PRO JOURNAL__20160215__FIGURE_OF_MERIT_III_IV_V__CALC_AND_PLOT_DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_AND_SOUTHERN_HEMI__SINGLE_WINDOW

  hemiStrings            = ['NORTH','SOUTH']
  plotHemi               = 'BOTH'
  fom_type               = [3,4,5]
  FOMStrings             = ['III','IV','V']

  cell_to_plot           = ['DAWN','DUSK']

  plotYRange             = [[0.00,0.1],[0.0,0.1],[0.00,0.1]]

  h2dFileDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/20160215--Alfven_cusp_figure_of_merit/data/'
  fileDia                = '20160215'

  scale_plots_to_1       = 0
  subtract_center        = 1
  ;; detrend_window         = 8 ;minutes

  auto_adjust_yRange     = 1

  FOR i=0,N_ELEMENTS(fom_type)-1 DO BEGIN
     FOR j=0,N_ELEMENTS(hemiStrings)-1 DO BEGIN
        JOURNAL__20160215__FIGURE_OF_MERIT_III_IV_V_FOR_CUSP_SPLITTING__NORTH_OR_SOUTH, $
           HEMI=hemiStrings[j], $
           FOMSTRING=FOMStrings[i], $
           SUBTRACT_CENTER=subtract_center
     ENDFOR

        PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_OR_SOUTHERN_HEMI__SINGLE_WINDOW, $
           HEMI='BOTH', $
           DETREND_WINDOW=detrend_window, $
           FILEDAY=fileDia, $
           H2DFILEDIR=h2dFileDir, $
           CELL_TO_PLOT='COMBINED', $
           FOM_TYPE=fom_type[i], $
           SCALE_PLOTS_TO_1=scale_plots_to_1, $
           COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
           PLOTYRANGE=plotYRange[*,i], $
           AUTO_ADJUST_YRANGE=auto_adjust_yRange, $
           /SAVEPLOTS, $
           LUN=lun
           

  ENDFOR
        
 END