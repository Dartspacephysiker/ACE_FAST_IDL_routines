;01/30/2015 6 PM
;Here I am, reproducing these figures on a Friday night. It's totally excellent, because things appear to line up with Chaston's picture!

PRO commands_for_Chaston_2003_figs4a_c_reproduction

  date='02022015'

  ;dirs='all_IMF'
  dirs=['duskward', 'dawnward']

  plotprf="Foolin_round_" + date + "/midnight_nomask/Dartdb_" + date 

  mskm=0
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
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /chareplot,charetype="lossCone",/logchareplot,/nonegchare,/medianplot,/WHOLECAP,/midnight

END