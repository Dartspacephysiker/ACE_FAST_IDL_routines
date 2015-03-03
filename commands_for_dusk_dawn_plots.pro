;02/02/2015
;A quicker(?) way to make all the plots I want

PRO commands_for_dusk_dawn_plots

  date='02292015'

  ;dirs='all_IMF'
  ;; dirs=['dawn-north', 'dawn-south', 'dusk-north', 'dusk-south']
  ;; dirs=['duskward', 'dawnward','bzSouth','bzNorth']
  dirs=['duskward', 'dawnward']
  ;; dirs=['bzNorth','bzSouth']

  ;Plot prefix?
  ;;plotprf="Foolin_round_" + date + "/quads/Dartdb_" + date
  plotprf="Foolin_round_" + date + "/Dartdb_" + date 
  ;; plotprf="LaBelle_Bin_mtg--" + date + "/Dartdb_" + date

  ;; mask min?
  mskm=7

  ;; midnight?
  midn=!NULL
  ;; midn=1

  ;; byMin?
  byMin=6.0 ;for bzNorth, bzSouth plots
  ;; byMin=3.0

  ;; whole cap?
  wc=!NULL
  ;; wc=1

  ;;median histogram data?
  medHistOutData=1

  ;;median histogram text output?
  medHistOutTxt=1

  ;;different delay?
  delay=!NULL
  ;;delay=1020

  ;;smooth IMF data?
  ;; smoothWindow=!NULL
  smoothWindow=5 ;in Min

  ;;stability requirement?
  ;; stableIMF = !NULL
  stableIMF = 15 ; in Min

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /orbPlots, /orbContribPlot,/orbTotPlot,/orbFreqPlot, $
                                        /nEventPerOrbPlot, /divNEvByApplicable, $
;;                                        neventperorbrange=[0.0,3.5], $
                                        neventperorbrange=[0.0,120.0], $
                                        nEventsRange=[0,350], orbFreqRange=[0.0, 0.05], orbContribRange=[0,10], $
                                        WHOLECAP=wc,midnight=midn,BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0], $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF
  
  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
  ;;                                       /eplots,efluxplottype="Max",eplotrange=[-1,2.0],/logefplot,/nonegeflux,/medianplot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",eplotrange=[-1,1.0],/logefplot,/abseflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0], $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF

  
  ;;;;;;;;;;;;;;;
  ;ion plots
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf,directions=dirs,maskmin=mskm, $
                                        /ionplots,ifluxplottype="Max",iplotrange=[5.0,9.0],/logifplot,/absiflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0], $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF

  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_ChastRange",directions=dirs,maskmin=mskm, $
                                        /pplots,pplotrange=[-1.7,1.3],/logpfplot,/nonegpflux,/medianplot, $
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_ChastRange",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,pplotrange=[0.01,1.5],/abspflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0], $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF
  
  ;Better (for showing features) plotrange
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherRange",directions=dirs,maskmin=mskm, $
                                        /pplots,/logpfplot,/nonegpflux,/medianplot, $
  ;; batch_plot_alfven_stats_imf_screening,plotprefix=plotprf + "_otherRange",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,/abspflux,/medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0], $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,plotprefix=plotprf, directions=dirs,maskmin=mskm, $
                                        /chareplots,charetype="lossCone",/logchareplot,/nonegchare,charePlotRange=[1.5, 2.6], $
                                        /medianplot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], charERange=[4.0,250.0], $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF

END