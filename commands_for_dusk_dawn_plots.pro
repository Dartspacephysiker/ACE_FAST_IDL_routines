;02/02/2015
;A quicker(?) way to make all the plots I want

PRO commands_for_dusk_dawn_plots

  date='02052015'

  ;dirs='all_IMF'
  ;;dirs=['dawn-north', 'dawn-south', 'dusk-north', 'dusk-south']
  dirs=['duskward', 'dawnward']

  ;Plot prefix?
  ;;plotprf="Foolin_round_" + date + "/quads/Dartdb_" + date
  plotprf="Foolin_round_" + date + "/Dartdb_" + date
  ;; plotprf="LaBelle_Bin_mtg--" + date + "/Dartdb_" + date

  ;; mask min?
  mskm=1

  ;; midnight?
  midn=!NULL

  ;; byMin?
  byMin=3.0

  ;; whole cap?
  wc=!NULL

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /orbContribPlot,/orbTotPlot,/orbFreqPlot,/nEventPerOrbPlot,/orbPlots, $
                                        neventperorbrange=[0.0,5.0], nEventsRange=[0,1200], orbFreqRange=[0.0, 0.3], orbContribRange=[0,60], $
                                        WHOLECAP=wc,midnight=midn,BYMIN=byMin,/polarcontour
  
  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
  ;;                                       /eplots,efluxplottype="Max",customerange=[-1,2.0],/logefplot,/nonegeflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",customerange=[-0.1,1.2],/logefplot,/abseflux,/medianplot,WHOLECAP=wc,midnight=midn
  
  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_ChastRange",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,customprange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_ChastRange",directions=dirs,maskmin=mskm, $
                                        /pplots,customprange=[0.01,3],/abspflux,/medianplot,WHOLECAP=wc,midnight=midn

  ;Better (for showing features) plotrange
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherRange",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,/logpfplot,/nonegpflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherRange",directions=dirs,maskmin=mskm, $
                                        /pplots,/abspflux,/medianplot,WHOLECAP=wc,midnight=midn

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf, directions=dirs,maskmin=mskm, $
                                        /chareplot,charetype="lossCone",/logchareplot,/nonegchare,customcharerange=[0, 3.6], $
                                        /medianplot,WHOLECAP=wc,midnight=midn

END