;2016/05/04 So where are the big dawgs during IMF By?
;Includes scatter plots
PRO JOURNAL__20160504__PLOT_NEVENTS_W_PFLUX_GE_5MW_PER_M2_FOR_ALT_SLICES__ORG_BY_IMF_BY

  ;;The reason we're gathered
  pFluxMin                 = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Scatterplot options
  do_scatterplot           = 0

  overlayAurZone           = 1

  ;; nonStorm                 = 1
  mainPhase                = 0

  centerLon                = 270
  sTrans                   = 20
  savePlot                 = 1
  add_orbit_legend         = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;orbit txt file?
  output_orbit_details     = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds          = 1

  hemi                     = 'NORTH'
  ;; hemi                     = 'SOUTH'
  
  orbContribPlot           = 1
  logOrbContribPlot        = 0
  ;; orbContribRange          = [
  orbContribAutoscale      = 1
  orbContrib_noMask        = 1

  nOrbsWithEventsPerContribOrbsPlot = 1
  nowepco_range            = [0.0,1.0]
  nowepco_autoscale        = 0

  nEventPerOrbPlot         = 1
  logNEventPerOrb          = 0
  nEventPerOrbRange        = [0,10]

  nPlots                   = 1
  ;; nEventsPlotNormalize     = 1  
  nEventsPlotAutoscale     = 1

  tHistDenominatorPlot     = 1
  ;; tHistDenomPlotNormalize  = 1
  tHistDenomPlotAutoscale  = 1
  tHistDenomPlot_noMask    = 1

  nEventPerMinPlot         = 1
  nEventPerMinAutoscale    = 1
  ;; nEventPerMinRange        = [1e-1,10]
  ;; logNEventPerMin          = 1
  ;; nEventPerMinRange        = [0,20]
  ;; logNEventPerMin          = 0

  tile_images              = 1
  ;; tiling_order             = [2,0,1]
  n_tile_columns           = 3
  n_tile_rows              = 2
  tilePlotSuff             = "--normed_nEvents_tHistos__and_nEvPerMin"

  ;; altRange                 = [[0,4180], $
  ;;                             [340,500], $
  ;;                             [500,1000], $
  ;;                             [1000,1500], $
  ;;                             [1500,2000], $
  ;;                             [2000,2500], $
  ;;                             [2500,3000], $
  ;;                             [3000,3500], $
  ;;                             [3500,3800], $
  ;;                             [3800,4000], $
  ;;                             [4000,4180]]

  ;; altRange                 = [[340,1180], $
  ;;                             [1180,2180], $
  ;;                             [2180,3180], $
  ;;                             [3180,4180]]

  altRange                 = [[1000,4180]]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff
  ;; clockStr                       = 'bzSouth'
  ;; bzMax                          = -5
  ;; byMax                          = 5
  ;; abs_byMax                      = 1

  ;; clockStr                       = 'bzNorth'
  ;; bzMin                          = 5
  ;; byMax                          = 5
  ;; abs_byMax                      = 1

  ;; clockStr                       = 'duskward'
  ;; byMin                          = 5
  ;; bzMax                          = -1

  clockStr                       = 'dawnward'
  byMax                          = -5
  bzMax                          = -5

  ;;DB stuff
  do_despun                      = 1

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1800
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  reset_omni_inds                = 1
                                                                                                           
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 4.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 2.0
  shiftMLT                       = 1.0

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun

  restrict_with_these_i          = WHERE(maximus.pFluxEst GE pFluxMin)

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange = altRange[*,i]
     altStr        = STRING(FORMAT='("--",I0,"-",I0,"km")',altitudeRange[0],altitudeRange[1]) + '--pFlux_GE_'+STRCOMPRESS(pFluxMin,/REMOVE_ALL)
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km, Poynting flux $\geq$ ",I0," mW m!U-2!N")',altitudeRange[0],altitudeRange[1],pFluxMin)
     tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km")',altitudeRange[0],altitudeRange[1])
     IMFStr        = clockStr
     IMFTitle      = clockStr
     IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
        IMFStr += '--bzMax_' + STRCOMPRESS(bzMax,/REMOVE_ALL)
        IMFTitle += ' B!Dz!N Max: ' + STRCOMPRESS(bzMax,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN
        IMFStr += '--bzMin_' + STRCOMPRESS(bzMin,/REMOVE_ALL)
        IMFTitle += ' B!Dz!N Min: ' + STRCOMPRESS(bzMin,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(byMax) GT 0 THEN BEGIN 
        IMFStr += '--byMax_' + STRCOMPRESS(byMax,/REMOVE_ALL)
        IMFTitle += ' B!Dy!N Max: ' + STRCOMPRESS(byMax,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(byMin) GT 0 THEN BEGIN
        IMFStr += '--byMin_' + STRCOMPRESS(byMin,/REMOVE_ALL)
        IMFTitle += ' B!Dy!N Min: ' + STRCOMPRESS(byMin,/REMOVE_ALL) + 'nT'
     ENDIF

     tilePlotSuffFinal   = IMFStr + tilePlotSuff
     tilePlotTitleFinal  = IMFTitle + ' ' + tilePlotTitle

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        POYNTRANGE=poyntRange, $
        DELAY=delayArr, $
        /MULTIPLE_DELAYS, $
        RESOLUTION_DELAY=delayDeltaSec, $
        BINOFFSET_DELAY=binOffset_delay, $
        NUMORBLIM=numOrbLim, $
        MINMLT=minMLT, $
        MAXMLT=maxMLT, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        HWMAUROVAL=HwMAurOval, $
        HWMKPIND=HwMKpInd, $
        ;; MIN_NEVENTS=min_nEvents, $
        MASKMIN=maskMin, $
        CLOCKSTR=clockStr, $
        ;; DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
        ANGLELIM1=angleLim1, $
        ANGLELIM2=angleLim2, $
        BYMIN=byMin, $
        BZMIN=bzMin, $
        BYMAX=byMax, $
        BZMAX=bzMax, $
        DO_ABS_BYMIN=abs_byMin, $
        DO_ABS_BYMAX=abs_byMax, $
        DO_ABS_BZMIN=abs_bzMin, $
        DO_ABS_BZMAX=abs_bzMax, $
        RESET_OMNI_INDS=reset_omni_inds, $
        SATELLITE=satellite, $
        OMNI_COORDS=omni_Coords, $
        HEMI=hemi, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        ;; /DO_NOT_CONSIDER_IMF, $
        NONSTORM=nonStorm, $
        RECOVERYPHASE=recoveryPhase, $
        MAINPHASE=mainPhase, $
        NPLOTS=nPlots, $
        EPLOTS=ePlots, $
        EPLOTRANGE=ePlotRange, $                                       
        EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
        ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
        ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
        NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
        PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
        NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
        IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
        NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
        OXYPLOTS=oxyPlots, $
        OXYFLUXPLOTTYPE=oxyFluxPlotType, $
        LOGOXYFPLOT=logOxyfPlot, $
        ABSOXYFLUX=absOxyFlux, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        OXYPLOTRANGE=oxyPlotRange, $
        CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
        NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
        CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
        NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
        ORBCONTRIBPLOT=orbContribPlot, $
        LOGORBCONTRIBPLOT=logOrbContribPlot, $
        ORBCONTRIBRANGE=orbContribRange, $
        ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
        ORBCONTRIB_NOMASK=orbContrib_noMask, $
        ORBTOTPLOT=orbTotPlot, $
        ORBFREQPLOT=orbFreqPlot, $
        ORBTOTRANGE=orbTotRange, $
        ORBFREQRANGE=orbFreqRange, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, $
        LOGNEVENTPERORB=logNEventPerOrb, $
        NEVENTPERORBRANGE=nEventPerOrbRange, $
        DIVNEVBYTOTAL=divNEvByTotal, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        NEVENTPERMINRANGE=nEventPerMinRange, $
        LOGNEVENTPERMIN=logNEventPerMin, $
        NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
        NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
        NOWEPCO_RANGE=nowepco_range, $
        NOWEPCO_AUTOSCALE=nowepco_autoscale, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        THISTDENOMINATORPLOT=tHistDenominatorPlot, $
        THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
        THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
        THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
        THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
        TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
        MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots, $
        SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
        DBFILE=dbfile, $
        NO_BURSTDATA=no_burstData, $
        RESET_GOOD_INDS=reset_good_inds, $
        DATADIR=dataDir, $
        DO_CHASTDB=do_chastDB, $
        DO_DESPUNDB=do_despunDB, $
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, SAVEDIR=saveDir, $
        JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIX=altStr, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        EPS_OUTPUT=eps_output, $
        OUT_TEMPFILE_LIST=out_tempFile_list, $
        OUT_DATANAMEARR_list=out_dataNameArr_list, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        TILEPLOTSUFF=tilePlotSuffFinal, $
        TILING_ORDER=tiling_order, $
        TILEPLOTTITLE=tilePlotTitleFinal, $
        NO_COLORBAR=no_colorbar, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        /MIDNIGHT, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        OUT_PLOT_I_LIST=out_plot_i_list, $
        OUT_PARAMSTRING_LIST=out_paramString_list, $
        _EXTRA = e
  
     
     plot_i                   = out_plot_i_list[0]
     paramStr                 = out_paramString_list[0]
     plotTitle                = hemi + 'ERN HEMI: Poynting flux $\geq$ ' + STRCOMPRESS(pFluxMin,/REMOVE_ALL) + ' mW/m!U2!N' + $
                                (KEYWORD_SET(altitudeRange) OR KEYWORD_SET(gotStorms) ? '(' + altStr + ')' : '')
     scatterPlotName          = 'scatterplot--' + paramStr + altStr + '.gif'
     outOrbDetFile            = 'orbit_details--' + paramStr + altStr + '.txt'

     IF KEYWORD_SET(do_scatterplot) THEN BEGIN
        KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus, $
                                   HEMI=hemi, $
                                   OVERLAYAURZONE=overlayAurZone, $
                                   ADD_ORBIT_LEGEND=add_orbit_legend, $
                                   CENTERLON=centerLon, $
                                   OVERPLOT=overplot, $
                                   LAYOUT=layout, $
                                   PLOTPOSITION=plotPosition, $
                                   OUT_PLOT=out_plot, $
                                   CURRENT_WINDOW=window, $
                                   PLOTSUFF=plotSuff, $
                                   DBFILE=dbFile, $
                                   JUST_PLOT_I=plot_i, $
                                   STRANS=sTrans, $
                                   SAVEPLOT=savePlot, $
                                   SPNAME=scatterPlotName, $
                                   PLOTDIR=plotDir, $
                                   /CLOSE_AFTER_SAVE, $
                                   OUTPUT_ORBIT_DETAILS=output_orbit_details, $
                                   OUT_ORBSTRARR_LIST=out_orbStrArr_list, $
                                   PLOTTITLE=plotTitle, $
                                   _EXTRA = e
     ENDIF

     IF KEYWORD_SET(output_orbit_details) THEN BEGIN
        IF ~KEYWORD_SET(do_scatterplot) THEN out_orbStrArr_list = plot_i

        PRINT_ORBIT_DETAILS_FROM_ORBSTRARR_LIST__OR__PLOT_I,out_orbStrArr_list,maximus, $
           ORBIT_DETAILS_FILENAME=outOrbDetFile, $
           ORBIT_DETAILS_HEADER=paramStr, $
           ANCILLARY_DATAPROD=maximus.pFluxEst, $
           ANCILLARY_DP_FORMAT='F-8.2', $
           ANCILLARY_DP_TITLE='Poynt. flux', $
           OUTDIR=plotDir
     ENDIF

  ENDFOR
END


