;+
;2015/06/24 I want to see where the Alfvén events for these storms were happening
;-

PRO JOURNAL__20150624__scatterplot_of_four_storms_from_2000__Yao_et_al_2008

  plot_i_file='PLOT_INDICES--four_storms_from_2000--Yao_et_al_2008.sav'
  restore,plot_i_file

  KEY_SCATTERPLOTS_POLARPROJ,/OVERLAYAURZONE,PLOT_I_LIST=plot_i_list,COLOR_LIST=color_list,STRANS=75,OUTFILE='scatterplot--northern--four_storms--Yao_et_al_2008.png'

  KEY_SCATTERPLOTS_POLARPROJ,/OVERLAYAURZONE,PLOT_I_LIST=plot_i_list,COLOR_LIST=color_list,STRANS=75,OUTFILE='scatterplot--southern--four_storms--Yao_et_al_2008.png',/SOUTH

END