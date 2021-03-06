;02/02/2015
;A quicker(?) way to make all the plots I want

PRO commands_for_quad_plots

  date='02102015'
  dbDate='02292015'
  ;dirs='all_IMF'
  dirs=['dawn-north', 'dawn-south', 'dusk-north', 'dusk-south']
  ;;dirs=['duskward', 'dawnward']

  ;Plot prefix?
  plotDir="plots/Foolin_round_" + date + "/quads/"
  plotSuff = "Dartdb_" + dbDate
  ;; plotprf="plots/LaBelle_Bin_mtg--" + date + "/quads/"

  ;; mask min?
  mskm=1

  ;; midnight?
  midn=!NULL

  ;; byMin?
  byMin=1.0

  ;; whole cap?
  wc=!NULL

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,directions=dirs,maskmin=mskm, $
                                        /orbContribPlot,/orbTotPlot,/orbFreqPlot,/nEventPerOrbPlot,/orbPlots, $
                                        neventperorbrange=[0.5,2.2], nEventsRange=[0,600], orbFreqRange=[0.05, 0.15], orbContribRange=[10,30], $
                                        WHOLECAP=wc,midnight=midn,BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0]
  
  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,directions=dirs,maskmin=mskm, $
  ;;                                       /eplots,efluxplottype="Max",customerange=[-1,2.0],/logefplot,/nonegeflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",eplotrange=[-0.1,0.7],/logefplot,/abseflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0]
  
  ;;;;;;;;;;;;;;;
  ;ion plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,directions=dirs,maskmin=mskm, $
                                        /ionplots,ifluxplottype="Max_Up",iplotrange=[7.5,10.0],/logifplot,/absiflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0]

  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir + "ChastRange_",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,customprange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFF="ChastRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,pplotrange=[0.1,2.8],/abspflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0]

  ;Better (for showing features) plotrange
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir + "otherRange_",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,/logpfplot,/nonegpflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFF="otherRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,/abspflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir, directions=dirs,maskmin=mskm, $
                                        /chareplots,charetype="lossCone",/logchareplot,/nonegchare,charePlotRange=[1.0, 2.5], $
                                        /medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0]

END