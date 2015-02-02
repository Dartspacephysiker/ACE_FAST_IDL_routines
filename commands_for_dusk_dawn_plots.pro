;02/02/2015
;A quicker(?) way to make all the plots I want

PRO commands_for_dusk_dawn_plots

  date='02022015'

  ;dirs='all_IMF'
  dirs=['duskward', 'dawnward']

  ;Plot prefix?
  plotprf="Foolin_round_" + date + "/Dartdb_" + date

  ;mask min?
  mskm=8

  ;midnight?
  midn=0

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /orbContribPlot,/orbTotPlot,/orbFreqPlot,/nEventPerOrbPlot,/orbPlots, $
                                        neventperorbrange=[0.0,10.0], nEventsRange=[0,1025], orbFreqRange=[0.0, 0.3], $
                                        /WHOLECAP,midnight=midn
  
  ;;;;;;;;;;;;;;;
                                ;electron plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Integ",customerange=[-1,2.0],/logefplot,/nonegeflux,/medianplot,/WHOLECAP,midnight=midn
  
  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_ChastRange",directions=dirs,maskmin=mskm, $
                                        /pplots,customprange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,midnight=midn

  ;Better (for showing features) plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherRange",directions=dirs,maskmin=mskm, $
                                        /pplots,/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,midnight=midn

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf, directions=dirs,maskmin=mskm, $
                                        /chareplot,charetype="lossCone",/logchareplot,/nonegchare,customcharerange=[0, 3.6], $
                                        /medianplot,/WHOLECAP,midnight=midn

END