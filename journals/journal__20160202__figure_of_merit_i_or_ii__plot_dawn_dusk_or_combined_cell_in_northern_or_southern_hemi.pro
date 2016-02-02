;;2016/02/02
;;Fancify
PRO JOURNAL__20160202__FIGURE_OF_MERIT_I_OR_II__PLOT_DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_OR_SOUTHERN_HEMI

  hemi                   = 'BOTH'
  fom_type               = 2
  cell_to_plot           = ['DAWN','DUSK']

  FOR i=0,N_ELEMENTS(cell_to_plot)-1 DO BEGIN
     PLOT_FIGURE_OF_MERIT_I_OR_II__DAWN_DUSK_OR_COMBINED_CELL_IN_NORTHERN_OR_SOUTHERN_HEMI, $
        HEMI=hemi, $
        /USE_OLD_SOUTH_DATA, $
        ONLY_SHOW_COMBINED_HEMI=only_show_combined_hemi, $
        INCLUDE_ALLIMF=include_allIMF, $
        FOM_TYPE=fom_type, $
        COMBINE_FOMS_FOR_EACH_IMF=combine_foms_for_each_IMF, $
        CELL_TO_PLOT=cell_to_plot[i], $
        /SAVEPLOTS, $
        LUN=lun
  ENDFOR
END