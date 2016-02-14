;;2016/02/13
;;Fancify
PRO JOURNAL__20160213__FIGURE_OF_MERIT_III_IV_V__CALC_AND_PLOT_DAWN_AND_DUSK_CELL_IN_NORTHERN_AND_SOUTHERN_HEMI__SINGLE_WINDOW

  hemiStrings            = ['NORTH','SOUTH']
  plotHemi               = 'BOTH'
  fom_type               = [3,4,5]
  FOMStrings             = ['III','IV','V']

  cell_to_plot           = ['DAWN','DUSK']

  plotYRange             = [0.00,0.05]

  FOR i=0,N_ELEMENTS(fom_type)-1 DO BEGIN
     FOR j=0,N_ELEMENTS(hemiStrings)-1 DO BEGIN
        JOURNAL__20160213__FIGURE_OF_MERIT_III_IV_V_FOR_CUSP_SPLITTING__NORTH_OR_SOUTH, $
           HEMI=hemiStrings[j], $
           FOMSTRING=FOMStrings[i]
     ENDFOR

     PLOT_FIGURE_OF_MERIT_III_IV_V__DAWN_AND_DUSK_CELL_IN_NORTHERN_AND_SOUTHERN_HEMI__SINGLE_WINDOW, $
        HEMI='BOTH', $
        ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
        INCLUDE_ALLIMF=include_allIMF, $
        FOM_TYPE=fom_type[i], $
        COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
        /SCALE_PLOTS_TO_1, $
        PLOTYRANGE=plotYRange, $
        /SAVEPLOTS, $
        LUN=lun

  ENDFOR
        
 END