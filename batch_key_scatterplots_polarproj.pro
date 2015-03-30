;2015/03/29
; Do some sweet n_events plots

PRO BATCH_KEY_SCATTERPLOTS_POLARPROJ

  ind_files=['PLOT_INDICES_North_dawnward--0stable--OMNI_GSM_maskMin_4_Mar_30_15.sav', $
             'PLOT_INDICES_North_duskward--0stable--OMNI_GSM_maskMin_4_Mar_30_15.sav']

  FOR i=0,n_elements(ind_files)-1 DO BEGIN
     key_scatterplots_polarproj,plot_i_file=ind_files[i]
  ENDFOR

END