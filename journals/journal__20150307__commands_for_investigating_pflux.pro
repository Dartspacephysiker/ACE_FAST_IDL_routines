;01/30/2015 6 PM
;Here I am, reproducing these figures on a Friday night. It's totally excellent, because things appear to line up with Chaston's picture!

PRO STUDY_commands_for_investigating_pflux__03072015

  date='03072015'
  dbDate = '02282015'

  dirs='all_IMF'
  ;; dirs=['duskward', 'dawnward']

  plotDir="plots/Foolin_round_" + date + "/midnight_nomask/"
  plotSuff="Dartdb_" + dbDate 
  ;; plotDir="LaBelle_Bin_mtg--02042015/Chaston_2003_fig4a-d/"

  ;;different delay?
  ;delay=!NULL
  delay=1020

  ;maskMin
  mskm=3

  ;delete postscript?
  del_PS = 1

  ;charERange?
  charERange=[4.0,5e3]

 ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm,/orbplots, $
                                        /orbcontribplot,/orbtotplot,/orbfreqplot, $
                                        /neventperorbplot, /logneventperorb, $
                                        ;; neventperorbrange=[0.01,10.0], $
                                        neventperorbrange=[-2.0,1.0], $
                                        nEventsRange=[0,3000], orbFreqRange=[0.0, 0.8], orbcontribrange=[1,200], $
                                        /WHOLECAP,/midnight,DELAY=delay,/noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange

  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
  ;;                                       /eplots,efluxplottype="Max",customerange=[-1,1.5],/logefplot,/nonegeflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",eplotrange=[-1,1.5],/logefplot,/abseflux,/medianplot,/WHOLECAP,/midnight, $
                                        DELAY=delay,/noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange
  
  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="ChastRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,pplotrange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,/midnight, $
                                        DELAY=delay,/noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="ChastRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,pplotrange=[0.05,10],/medianplot,/WHOLECAP,/midnight,DELAY=delay, $
                                        /noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange
  
  ;Better (for showing features) plotrange
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="otherRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,pplotrange=[0,2],/logpfplot,/nonegpflux,/medianplot,/WHOLECAP,/midnight,DELAY=delay, $
                                        /noplotintegral,DEL_PS = del_PS,/polarcontour
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="otherRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,/medianplot,/WHOLECAP,/midnight,DELAY=delay, $
                                        /noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /chareplot,charetype="lossCone",/logCharEPlot, $ ;chareplotrange=[0,4e3],
                                        /medianplot,/WHOLECAP,/midnight,DELAY=delay, $
                                        /noplotintegral,DEL_PS = del_PS, CHARERANGE=charERange

END
