;02/02/2015
;A quicker(?) way to make all the plots I want

PRO commands_for_dusk_dawn_plots__charE_3e2_to_5e3

  date='03182015'
  dbDate='02282015'

;;  hemi='North'
;;  mirror = !NULL
  hemi='North'
  mirror = !NULL

  ;dirs='all_IMF'
  ;; dirs=['dawn-north', 'dawn-south', 'dusk-north', 'dusk-south']
  ;; dirs=['duskward', 'dawnward','bzSouth','bzNorth']
  dirs=['duskward', 'dawnward']
  ;; dirs=['bzNorth','bzSouth']

  ;Plot prefix?
  ;;plotprf="Foolin_round_" + date + "/quads/Dartdb_" + dbDate
  plotDir="plots/Foolin_round_" + date + "/"
;;  plotSuff="Dartdb_" + dbDate + "--" + "pFlux_GE_0.1"
  plotSuff="Dartdb_" + dbDate + "--" + "charE_3e2_to_5e3--"
  ;; plotprf="LaBelle_Bin_mtg--" + date + "/Dartdb_" + dbDate

  ;; mask min?
  mskm=3

  ;; midnight?
  midn=!NULL
  ;; midn=1

  ;; byMin?
  byMin=3.0 ;for bzNorth, bzSouth plots
  ;; byMin=3.0
  numOrbLim=!NULL
  ;; numOrbLim=2

  ;; whole cap?
;;  wc=!NULL
   wc=1

  ;;median plots?
  ;; medPlot=!NULL
  medPlot=1

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
  stableIMF = 1 ; in Min

  ;delete postscript?
  del_PS = 1
;;  noPlotIntegral=!NULL
  noPlotIntegral=1

  ;charERange?
  charERange=[250,5e3]
;;  charERange=[4,300]

  ;;Poynt range?
;; poyntRange=!NULL
  poyntRange=[1e-4,1e3]

  ;;;;;;;;;;
  ;orb plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /orbPlots, /orbContribPlot,/orbTotPlot,/orbFreqPlot, $
                                        /nEventPerOrbPlot, $
;;                                        neventperorbrange=[0.0,2.5], $
;;                                        /logneventperorb, neventperorbrange=[-1,0.4772], $
;;                                        /divNEvByApplicable, neventperorbrange=[0.0,40.0], $
                                        /logneventperorb, /divNEvByApplicable, neventperorbrange=[FLOOR(100.0*ALOG10(mskm))/100.0,2], $
;;                                        /logneventperorb, neventperorbrange=[-1,0.699], $
;;                                        poyntRange=[0.1,1e3], HEMI='North', nEventsRange=[100,750], orbFreqRange=[0.0, 0.15], orbContribRange=[0,40], $
;;                                        poyntRange=[0.1,1e3], HEMI='South', nEventsRange=[0,425], orbFreqRange=[0.0, 0.1], orbContribRange=[0,20], $
                                        nEventsRange=[0,200], orbFreqRange=[0.0, 0.1], orbContribRange=[0,15], $
                                        WHOLECAP=wc,midnight=midn,BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS, NOPLOTINTEGRAL=noPlotIntegral, NUMORBLIM=numOrbLim
  
  ;;;;;;;;;;;;;;;
  ;electron plots
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
  ;;                                       /eplots,efluxplottype="Max",eplotrange=[-1,2.0],/logefplot,/nonegeflux,MEDIANPLOT=medPlot,WHOLECAP=wc,midnight=midn
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /eplots,efluxplottype="Max",eplotrange=[-0.5,1.8],/logefplot,/abseflux,MEDIANPLOT=medPlot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS, NOPLOTINTEGRAL=noPlotIntegral, NUMORBLIM=numOrbLim

  
  ;;;;;;;;;;;;;;;
  ;ion plots
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff,directions=dirs,maskmin=mskm, $
                                        /ionplots,ifluxplottype="Max_Up",iplotrange=[6.5,9.5],/logifplot,/absiflux,MEDIANPLOT=medPlot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS, NOPLOTINTEGRAL=noPlotIntegral, NUMORBLIM=numOrbLim

  ;;;;;;;;;;;;;;;;;;;;
  ;Poynting flux plots
  ;Chaston's plotrange
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="ChastRange_" + plotSuff,directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,pplotrange=[-1.7,1.3],/logpfplot,/nonegpflux,MEDIANPLOT=medPlot, $
  ;; ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir + "ChastRange_",directions=dirs,maskmin=mskm, $
  ;; ;;                                       /pplots,pplotrange=[0.01,1.5],/abspflux,MEDIANPLOT=medPlot, $
  ;;                                       WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
  ;;                                       altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, POYNTRANGE=poyntRange, $
  ;;                                       MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
  ;;                                       SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
  ;;                                       DEL_PS=del_PS, NOPLOTINTEGRAL=noPlotIntegral, NUMORBLIM=numOrbLim
  
  ;Better (for showing features) plotrange
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX="otherRange_" + plotSuff,directions=dirs,maskmin=mskm, $
                                        /pplots,/nonegpflux,MEDIANPLOT=medPlot, $
  ;; batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir + "otherRange_",directions=dirs,maskmin=mskm, $
  ;;                                       /pplots,/abspflux,MEDIANPLOT=medPlot, $
                                        /logpfplot, pplotrange=[-1,1.5], $
;;                                        pplotrange=[0.1,2], $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS, NOPLOTINTEGRAL=noPlotIntegral, NUMORBLIM=numOrbLim

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;characteristic energy plot
  batch_plot_alfven_stats_imf_screening,PLOTDIR=plotDir,PLOTSUFFIX=plotSuff, directions=dirs,maskmin=mskm, $
                                        /chareplots,charetype="lossCone",/logchareplot,/nonegchare,charePlotRange=[2.3, 3.7], $ ;charePlotRange=[1.3, 2.477], $
                                        MEDIANPLOT=medPlot, $
                                        WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                        altitudeRange=[1000.0, 5000.0], CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                        MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                        SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror, $
                                        DEL_PS=del_PS, NOPLOTINTEGRAL=noPlotIntegral, NUMORBLIM=numOrbLim

END