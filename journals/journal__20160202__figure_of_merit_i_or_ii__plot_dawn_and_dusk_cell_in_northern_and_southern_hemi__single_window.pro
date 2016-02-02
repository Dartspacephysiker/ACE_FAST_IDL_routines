;;2016/02/02
;;Fancify
PRO JOURNAL__20160202__FIGURE_OF_MERIT_I_OR_II__PLOT_DAWN_AND_DUSK_CELL_IN_NORTHERN_AND_SOUTHERN_HEMI__SINGLE_WINDOW

  hemi                   = 'BOTH'
  fom_type               = 2
  cell_to_plot           = ['DAWN','DUSK']

     PLOT_FIGURE_OF_MERIT_I_OR_II__DAWN_AND_DUSK_CELL_IN_NORTHERN_AND_SOUTHERN_HEMI__SINGLE_WINDOW, $
        HEMI=hemi, $
        /USE_OLD_SOUTH_DATA, $
        ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
        INCLUDE_ALLIMF=include_allIMF, $
        FOM_TYPE=fom_type, $
        COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
        /SAVEPLOTS, $
        LUN=lun
 END