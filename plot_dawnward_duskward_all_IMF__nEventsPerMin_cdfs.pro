;2015/04/02
;The idea is to plot all cdfs together on the same plot 

PRO plot_dawnward_duskward_all_IMF__nEventsPerMin_cdfs ;,DO_CHASTDB=do_ChastDB

  ;first, make the ks_stats files
  ;dawnward/all IMF
  ;; kolmogorov_smirnov_mlt,plot_i_file='PLOT_INDICES_North_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot_i_dir='plot_indices_saves/', $
  ;;                        ks_stats_filename='kolm-smir--North_dawnward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0'
  ;duskward/all IMF
  ;; kolmogorov_smirnov_mlt,plot_i_file='PLOT_INDICES_North_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot_i_dir='plot_indices_saves/', $
  ;;                        ks_stats_filename='kolm-smir--North_duskward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0'
  ;also do duskward/dawnward comparison
  ;; kolmogorov_smirnov_mlt,plot_i_file='PLOT_INDICES_North_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot2_i_file='PLOT_INDICES_North_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Mar_30_15.sav', $
  ;;                        plot_i_dir='plot_indices_saves/'

  ; Here are the filenames
  ks_dir = 'ks_output/'

  ;our DB
  ksNEvPerMinOutFile = 'ks_stats_neventpermin__20150410.sav'


  ;original Chaston DB
  ;; IF KEYWORD_SET(do_chastdb) THEN BEGIN
  ;;    dawnKSfile=ks_dir+'original_ChastonDB/original_ChastDB--kolm-smir--dawnward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0--Apr_2_15.sav'
  ;;    duskKSfile=ks_dir+'original_ChastonDB/original_ChastDB--kolm-smir--duskward_all_IMF--OMNI_GSM--5min_IMFsmooth_byMin_5.0--Apr_2_15.sav'
  ;;    dawnduskKSfile=ks_dir+'original_ChastonDB/original_ChastDB--kolm-smir--dawn_dusk--OMNI_GSM--5min_IMFsmooth_byMin_5.0--Apr_2_15.sav'
  ;; ENDIF 

  ;0 = dawn
  ;1 = dusk
  ;2 = all IMF
  nCHistos = 3

  ;dawn
  restore,ksNEvPerMinOutFile

  nMLTBins = nHistBins[0]
  binLocsMLT = make_array(nCHistos,nMLTBins)
  cHistosMLT = make_array(nCHistos,nMLTBins)
  ksStatMLT = make_array(nCHistos)
  pValMLT = make_array(nCHistos)

  nILATBins = nHistBins[1]
  binLocsILAT = make_array(nCHistos,nILATBins)
  cHistosILAT = make_array(nCHistos,nILATBins)
  ksStatILAT = make_array(nCHistos)
  pValILAT = make_array(nCHistos)

  ksStatString = make_array(nCHistos,/STRING)

  cHistosMLT[0,*] = dawn_MLT_cdf
  binLocsMLT[0,*] = dawn_MLT_binLocs
  ksStatMLT[0] = ks_MLT_dawnall
  pValMLT[0] = pVal_MLT_dawnall

  cHistosILAT[0,*] = dawn_ILAT_cdf
  binLocsILAT[0,*] = dawn_ILAT_binLocs
  ksStatILAT[0] = ks_ILAT_dawnall
  pValILAT[0] = pVal_ILAT_dawnall

  ksStatString[0] = 'dawn vs. all IMF'

  ;dusk
  cHistosMLT[1,*] = dusk_MLT_cdf
  binLocsMLT[1,*] = dusk_MLT_binLocs
  ksStatMLT[1] = ks_MLT_duskall
  pValMLT[1] = pVal_MLT_duskall

  cHistosILAT[1,*] = dusk_ILAT_cdf
  binLocsILAT[1,*] = dusk_ILAT_binLocs
  ksStatILAT[1] = ks_ILAT_duskall
  pValILAT[1] = pVal_ILAT_duskall

  ksStatString[1] = 'dusk vs. all IMF'

  ;all IMF
  cHistosMLT[2,*] = allIMF_MLT_cdf
  binLocsMLT[2,*] = allIMF_MLT_binLocs

  cHistosILAT[2,*] = allIMF_ILAT_cdf
  binLocsILAT[2,*] = allIMF_ILAT_binLocs

  ;get KS stat for dawn-dusk comparison
  ksStatMLT[2] = ks_MLT_duskdawn
  pValMLT[2] = pVal_MLT_duskdawn
  ksStatILAT[2] = ks_ILAT_duskdawn
  pValILAT[2] = pVal_ILAT_duskdawn
  ksStatString[2] = 'dawn vs. dusk'

  ;set up plots for each
  cHistoMLTPlots = make_array(nCHistos,/OBJ)
  ksStatMLTText = make_array(nCHistos,/OBJ)

  cHistoILATPlots = make_array(nCHistos,/OBJ)
  ksStatILATText = make_array(nCHistos,/OBJ)

  cHistoMLTPlotTitle = 'Cumulative MLT histograms of Alfvén events per minute for various IMF clock angles'
  cHistoILATPlotTitle = 'Cumulative ILAT histograms of Alfvén events per minute for various IMF clock angles'
  
  ;for Chaston DB
  ;; IF KEYWORD_SET(do_ChastDB) THEN BEGIN
  ;;    cHistoMLTPlotTitle = 'Cumulative MLT histograms of Alfvén events in original database'
  ;;    cHistoILATPlotTitle = 'Cumulative ILAT histograms of Alfvén events in original database'
  ;; ENDIF

  plotLegends = make_array(nCHistos,/STRING)
  plotFormats = make_array(nCHistos,/STRING)

  plotLegends[0] = "Dawnward"
  plotLegends[1] = "Duskward"
  plotLegends[2] = "All IMF"

  ;; plotFormats[0] = ':r2'  ;red solid line
  ;; plotFormats[1] = ':b2'  ;blue dotted line
  ;; plotFormats[2] = 'k--2' ;black dashed line

  plotFormats[0] = 'r5+'  ;red solid line
  plotFormats[1] = 'b5+'  ;blue dotted line
  plotFormats[2] = 'k2*' ;black dashed line

  ;properties of printed table for K-S statistics
  ksHeadText = 'K-S Stat   pVal'
  ksHeadFontSize = 10
  ksHeadFormat = '(T16,A0)'
  ksTableFormat = '(A0,T21,G-10.3,T32,G-10.3)'
  ksTableFontSize = 8
  ksFont = 'Courier'

  ;positions of text in data coordinates
  ksTextX_MLT = 10.0
  ksTextY_MLT = 0.3

  ksTextX_ILAT = 70
  ksTextY_ILAT = 0.25

  ; These were for the other plots
  ;; ksTextX_MLT = 11.5
  ;; ksTextY_MLT = 0.3

  ;; ksTextX_ILAT = 73
  ;; ksTextY_ILAT = 0.25

  ;loop over MLT plots
  FOR i=0,nChistos-1 DO BEGIN
     cHistoMLTPlots[i] = PLOT(binLocsMLT[i,*], cHistosMLT[i,*], $
                              plotFormats[i], NAME=plotLegends[i], $
                              YRANGE=[0,1.05], $
                              TITLE=(i EQ 0) ? cHistoMLTPlotTitle: !NULL, $
                              OVERPLOT=(i EQ 0) ? !NULL : 1)

  ksStatMLTText[i] = TEXT(ksTextX_MLT,(ksTextY_MLT-0.05*(i+1)), $
                          STRING(FORMAT=ksTableFormat,ksStatString[i]+": ",ksStatMLT[i],pValMLT[i]), $
                    FONT_SIZE=ksTableFontSize, FONT_NAME=ksFont, $
                    /DATA)
  
     
  ENDFOR
  legMLT = LEGEND(TARGET=cHistoMLTPlots, $
                  /AUTO_TEXT_COLOR, $
                  POSITION=[10,0.95], /DATA)
  ksStatMLTTitle = TEXT(ksTextX_MLT,ksTextY_MLT,STRING(FORMAT=ksHeadFormat,ksHeadText), $
                    FONT_SIZE=ksHeadFontSize, FONT_NAME=ksFont, $
                    /DATA)  

  ;loop over ILAT plots
  FOR i=0,nChistos-1 DO BEGIN
     cHistoILATPlots[i] = PLOT(binLocsILAT[i,*], cHistosILAT[i,*], $
                               plotFormats[i], NAME=plotLegends[i], $
                              TITLE=(i EQ 0) ? cHistoILATPlotTitle: !NULL, $
                              YRANGE=[0,1.05], $
                              OVERPLOT=(i EQ 0) ? !NULL : 1)

  ksStatILATText[i] = TEXT(ksTextX_ILAT,ksTextY_ILAT-0.05*(i+1), $
                          STRING(FORMAT=ksTableFormat,ksStatString[i]+": ",ksStatILAT[i],pValILAT[i]), $
                    FONT_SIZE=ksTableFontSize, FONT_NAME=ksFont, $
                    /DATA)

  ENDFOR
  legILAT = LEGEND(TARGET=cHistoILATPlots, $
                  /AUTO_TEXT_COLOR, $
                  POSITION=[70,0.95], /DATA)
  ksStatILATTitle = TEXT(ksTextX_ILAT,ksTextY_ILAT,STRING(FORMAT=ksHeadFormat,ksHeadText), $
                    FONT_SIZE=ksHeadFontSize, FONT_NAME=ksFont, $
                    /DATA)  

END