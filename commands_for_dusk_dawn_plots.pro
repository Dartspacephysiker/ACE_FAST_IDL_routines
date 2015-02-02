;02/02/2015
;A quicker(?) way to make all the plots I want

PRO commands_for_dusk_dawn_plots

  date='02022015'

  ;dirs='all_IMF'
  dirs=['duskward', 'dawnward']

  plotprf="Foolin_round_" + date + "/Dartdb_" + date

  mskm=8

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /orbplots,/orbtotplot,/orbfreqplot,/neventperorbplot,/WHOLECAP,/midnight
  
  ;;;;;;;;;;;;;;;
                                ;electron plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",customerange=[-1,1.5],/logefplot,/nonegeflux,/medianplot,/WHOLECAP,/midnight
  
  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherpplot",directions=dirs,maskmin=mskm, $
                                        /pplots,customprange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,/midnight

  ;Better (for showing features) plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherpplot",directions=dirs,maskmin=mskm, $
                                        /pplots,/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,/midnight

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf, directions=dirs,maskmin=mskm, $
                                        /chareplot,charetype="lossCone",/logchareplot,/nonegchare,/medianplot,/WHOLECAP,/midnight

END