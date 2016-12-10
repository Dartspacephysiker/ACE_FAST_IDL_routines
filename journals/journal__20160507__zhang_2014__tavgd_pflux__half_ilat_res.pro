;;2016/05/06 Professor LaBelle would like to see something similar to the Zhang et al. [2014] paper showing Alfvénic activity for
;;several different clock angles. Here goes.
PRO JOURNAL__20160507__ZHANG_2014__TAVGD_PFLUX__HALF_ILAT_RES

  run_the_clockAngle_ring  = 1

  do_timeAvg_fluxQuantities = 1
  logAvgPlot                = 0
  divide_by_width_x         = 1

  ;;DB stuff
  do_despun                = 1

  autoscale_fluxPlots      = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots

  eNumFlPlots              = 1
  eNumFlPlotType           = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  noNegENumFl              = [1,1]
  ;; logENumFlPlot            = [1,1]
  ;; ENumFlPlotRange          = [[1e-2,1e0], $
  ;;                             [1e6,1e9]]
  logENumFlPlot            = [0,0]
  ENumFlPlotRange          = [[0,0.15], $
                              [0,3.5e8]]

  pPlots                   = 1
  ;; logPfPlot                = 1
  ;; PPlotRange               = [1e-2,1e0]
  logPfPlot                = 0
  PPlotRange               = [0,0.3]

  ionPlots                 = 1
  ifluxPlotType            = 'Integ_Up'
  noNegIflux               = 1
  ;; logIfPlot                = 1
  ;; IPlotRange               = [1e6,1e8]
  logIfPlot                = 0
  IPlotRange               = [0,2.5e7]
  
  probOccurrencePlot       = 1
  logProbOccurrence        = 0
  probOccurrenceRange      = [0,0.04]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds          = 1

  tile_images              = 1
  ;; tiling_order             = [2,0,1]
  n_tile_columns           = 3
  n_tile_rows              = 2
  tilePlotSuff             = "--pFlux_n_eFlux_n_everyone"

  ;; altRange                 = [[340,1180], $
  ;;                             [1180,2180], $
  ;;                             [2180,3180], $
  ;;                             [3180,4180]]

  altRange                 = [[2000,4180]]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 5
  ;; btMax                          = 5

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1200
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  reset_omni_inds                = 1
                                                                                                           
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 62
  maxILAT                        = 86

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -62

  ;; binILAT                        = 2.0
  binILAT                        = 8.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  shiftMLT                       = 0.5

  ;; minMLT                         = 6
  ;; maxMLT                         = 18

  ;;Bonus
  maskMin                        = 2

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     IF KEYWORD_SET(minMC) THEN BEGIN
        magCStr    = STRING(FORMAT='("--ABSmagc_GE_",I0)',minMC)
        magCTitStr = STRING(FORMAT='(", magc GE ",I0)',minMC)
     ENDIF ELSE BEGIN
        magCStr    = ''
        magCTitStr = ''
     ENDELSE

     altitudeRange = altRange[*,i]
     altStr        = STRING(FORMAT='("--",I0,"-",I0,A0)', $
                            altitudeRange[0], $
                            altitudeRange[1], $
                            magCStr)
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km, Poynting flux $\geq$ ",I0," mW m!U-2!N")',altitudeRange[0],altitudeRange[1],pFluxMin)
     tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km",A0)', $
                            altitudeRange[0], $
                            altitudeRange[1], $
                            magCTitStr)

     IMFStr        = ['1--bzNorth','2--dusk-north','3--duskward','4--dusk-south','5--bzSouth','6--dawn-south','7--dawnward','8--dawn-north']
     IMFTitle      = ['B!Dz!N North','Dusk-North','Duskward','Dusk-South','B!Dz!N South','Dawn-South','Dawnward','Dawn-north']

     IF N_ELEMENTS(byMax) GT 0 THEN BEGIN 
        IMFStr += '--byMax_' + STRCOMPRESS(byMax,/REMOVE_ALL)
        IMFTitle += ' B!Dy!N Max: ' + STRCOMPRESS(byMax,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(byMin) GT 0 THEN BEGIN
        IMFStr += '--byMin_' + STRCOMPRESS(byMin,/REMOVE_ALL)
        IMFTitle += ' B!Dy!N Min: ' + STRCOMPRESS(byMin,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
        IMFStr += '--bzMax_' + STRCOMPRESS(bzMax,/REMOVE_ALL)
        IMFTitle += ' B!Dz!N Max: ' + STRCOMPRESS(bzMax,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN
        IMFStr += '--bzMin_' + STRCOMPRESS(bzMin,/REMOVE_ALL)
        IMFTitle += ' B!Dz!N Min: ' + STRCOMPRESS(bzMin,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(btMax) GT 0 THEN BEGIN 
        IMFStr += '--btMax_' + STRCOMPRESS(btMax,/REMOVE_ALL)
        IMFTitle += ' B!Dt!N Max: ' + STRCOMPRESS(btMax,/REMOVE_ALL) + 'nT'
     ENDIF
     IF N_ELEMENTS(btMin) GT 0 THEN BEGIN
        IMFStr += '--btMin_' + STRCOMPRESS(btMin,/REMOVE_ALL)
        IMFTitle += ' B!Dt!N Min: ' + STRCOMPRESS(btMin,/REMOVE_ALL) + 'nT'
     ENDIF

     tilePlotSuffs       = tilePlotSuff
     tilePlotTitles      = IMFTitle + ' ' + tilePlotTitle

     plotSuffs           = '--'+IMFStr+altStr

     PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSK, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
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
        MIN_MAGCURRENT=minMC, $
        MAX_NEGMAGCURRENT=maxNegMC, $
        HWMAUROVAL=HwMAurOval, $
        HWMKPIND=HwMKpInd, $
        MASKMIN=maskMin, $
        ANGLELIM1=angleLim1, $
        ANGLELIM2=angleLim2, $
        BYMIN=byMin, $
        BYMAX=byMax, $
        BZMIN=bzMin, $
        BZMAX=bzMax, $
        BTMIN=btMin, $
        BTMAX=btMax, $
        BXMIN=bxMin, $
        BXMAX=bxMax, $
        DO_ABS_BYMIN=abs_byMin, $
        DO_ABS_BYMAX=abs_byMax, $
        DO_ABS_BZMIN=abs_bzMin, $
        DO_ABS_BZMAX=abs_bzMax, $
        DO_ABS_BTMIN=abs_btMin, $
        DO_ABS_BTMAX=abs_btMax, $
        DO_ABS_BXMIN=abs_bxMin, $
        DO_ABS_BXMAX=abs_bxMax, $
        RUN_AROUND_THE_RING_OF_CLOCK_ANGLES=run_the_clockAngle_ring, $
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
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
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
        NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
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
        CHASTDB=chastDB, $
        DESPUNDB=despun, $
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, SAVEDIR=saveDir, $
        JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIXES=plotSuffs, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        EPS_OUTPUT=eps_output, $
        OUT_TEMPFILE_LIST=out_tempFile_list, $
        OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
        OUT_PLOT_I_LIST=out_plot_i_list, $
        OUT_PARAMSTRING_LIST=out_paramString_list, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        TILEPLOTSUFFS=tilePlotSuffs, $
        TILING_ORDER=tiling_order, $
        TILEPLOTTITLE=tilePlotTitles, $
        NO_COLORBAR=no_colorbar, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        /MIDNIGHT, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        _EXTRA=e
        ;; /GET_PLOT_I_LIST_LIST, $
        ;; /GET_PARAMSTR_LIST_LIST, $
        ;; PLOT_I_LIST_LIST=plot_i_list_list, $
        ;; PARAMSTR_LIST_LIST=paramStr_list_list
  
  ENDFOR



END