;2015/04/02
;The idea is to plot all cdfs together on the same plot 

PRO JOURNAL_plot_dawnward_duskward_all_IMF_cdfs__20150402

  ;first, make the ks_stats files
  ;dawnward/all IMF
  ;; kolmogorov_smirnov_mlt,plot_i_file='PLOT_INDICES_North_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot_i_dir='plot_indices_saves/', $
  ;;                        ks_stats_filename='kolm-smir--dawnward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0'
  ;; ;duskward/all IMF
  ;; kolmogorov_smirnov_mlt,plot_i_file='PLOT_INDICES_North_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot_i_dir='plot_indices_saves/', $
  ;;                        ks_stats_filename='kolm-smir--duskward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0'
  ;; ;also do duskward/dawnward comparison
  ;; kolmogorov_smirnov_mlt,plot_i_file='PLOT_INDICES_North_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot2_i_file='PLOT_INDICES_North_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot_i_dir='plot_indices_saves/'
kstwo
  ; Here are the filenames
  dawnKSfile='kolm-smir--dawnward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0--Apr_ 2_15.sav'
  duskKSfile='kolm-smir--duskward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0--Apr_ 2_15.sav'
  ;;dawnduskKSfile='kolm-smir--dawnward_duskward--OMNI_GSM--5min_IMFsmooth_byMin_5.0.sav--Apr_ 2_15.sav'
  
  ;make array for all cumulative dist functions
  ;0 = dawn
  ;1 = dusk
  ;2 = all IMF
  nCHistos = 3

  ;dawn
  restore,dawnKSfile
  cHistosMLT[0] = ks_stats.chisto1[0,0:nMLTBins-1]
  cHistosILAT[0] = ks_stats.chisto1[1,0:nILATBins-1]

  nMLTBins = ks_stats.nhistbins[0]
  cHistosMLT = make_array(nCHistos,nMLTBins)

  nILATBins = ks_stats.nhistbins[1]
  cHistosILAT = make_array(nCHistos,nILATBins)

  ;dusk
  restore,duskKSfile
  cHistosMLT[1] = ks_stats.chisto1[0,0:nMLTBins-1]
  cHistosILAT[1] = ks_stats.chisto1[1,0:nILATBins-1]

  ;all IMF
  cHistosMLT[2] = ks_stats.chisto2[0,0:nMLTBins-1]
  cHistosILAT[2] = ks_stats.chisto2[1,0:nILATBins-1]

  ;set up plots for each
  cHistoMLTPlots = make_array(nCHistos,/OBJ)
  cHistoILATPlots = make_array(nCHistos,/OBJ)

  cHistoMLTPlotTitle = 'Cumulative MLT histograms of Alfvén events for various IMF clock angles'
  cHistoILATPlotTitle = 'Cumulative ILAT histograms of Alfvén events for various IMF clock angles'

  plotLegends = make_array(nCHistos,/STRING)
  plotFormats = make_array(nCHistos,/STRING)

  plotLegends[0] = "Dawnward"
  plotLegends[1] = "Duskward"
  plotLegends[2] = "All IMF"

  plotFormats[0] = '-r2'  ;red solid line
  plotFormats[1] = ':b2'  ;blue dotted line
  plotFormats[2] = 'k--2' ;black dashed line

  ;loop over MLT plots
  FOR i=0,nChistos-1 DO BEGIN
     cHistoMLTPlots[i] = PLOT(cHistosMLT[i], plotFormats[i], NAME=plotLegends[i], $
                              TITLE=(i EQ 0) ? cHistoMLTPlotTitle: !NULL, $
                              OVERPLOT=(i EQ 0) ? !NULL : 1)
  ENDFOR
  legMLT = LEGEND(TARGET=cHistoMLTPlots, $
                  /AUTO_TEXT_COLOR)
                  ;; POSITION=[185,0.9], /DATA)
  
  ;loop over ILAT plots
  FOR i=0,nChistos-1 DO BEGIN
     cHistoILATPlots[i] = PLOT(cHistosILAT[i], plotFormats[i], NAME=plotLegends[i], $
                              TITLE=(i EQ 0) ? cHistoILATPlotTitle: !NULL, $
                              OVERPLOT=(i EQ 0) ? !NULL : 1)
  ENDFOR
  legILAT = LEGEND(TARGET=cHistoILATPlots, $
                  /AUTO_TEXT_COLOR)
                  ;; POSITION=[185,0.9], /DATA)

END