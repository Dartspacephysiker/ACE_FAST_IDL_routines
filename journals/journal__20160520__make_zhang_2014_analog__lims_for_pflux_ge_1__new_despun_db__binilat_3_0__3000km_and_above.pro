;;2016/05/16 Try new text output
PRO JOURNAL__20160520__MAKE_ZHANG_2014_ANALOG__LIMS_FOR_PFLUX_GE_1__NEW_DESPUN_DB__BINILAT_3_0__3000KM_AND_ABOVE
  ;;The reason we're gathered
  pFluxMin                 = 1

  ;;DB stuff
  do_despun                = 1

  suffix_plotDir           = 'binILAT_3_0'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tile stuff
  ;; SETUP_TO_RUN_ALL_CLOCK_ANGLES,multiple_IMF_clockAngles,clockStrings,angleLim1,angleLim2,IMFStr,IMFTitle
  ;; multiple_IMF_clockAngles = 1
  ;; clockStrings    = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  ;; angleLim1       = 67.5
  ;; angleLim2       = 112.5  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;orbit txt file?
  write_obsArr_textFile    = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  ;; group_like_plots_for_tiling = 0
  ;; n_tile_columns              = 3
  ;; n_tile_rows                 = 2
  group_like_plots_for_tiling = 1
  scale_like_plots_for_tiling = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  orbContribPlot           = 1
  logOrbContribPlot        = 0
  orbContribRange          = [0,141]
  orbContribAutoscale      = 0
  orbContrib_noMask        = 1

  nOrbsWithEventsPerContribOrbsPlot = 1
  nowepco_range            = [0.0,1.0]
  nowepco_autoscale        = 0

  nEventPerOrbPlot         = 1
  logNEventPerOrb          = 0
  nEventPerOrbAutoscale    = 0
  nEventPerOrbRange        = [0,30]

  nPlots                   = 1
  ;; nEventsPlotNormalize     = 1  
  nEventsPlotRange         = [0,1250]
  nEventsPlotAutoscale     = 0

  tHistDenominatorPlot     = 1
  ;; tHistDenomPlotNormalize  = 1
  tHistDenomPlotRange      = [0,225]
  tHistDenomPlotAutoscale  = 0
  tHistDenomPlot_noMask    = 1

  nEventPerMinPlot         = 1
  nEventPerMinAutoscale    = 0
  ;; nEventPerMinRange        = [1e-1,10]
  ;; logNEventPerMin          = 1
  nEventPerMinRange        = [0,30.0]
  ;; logNEventPerMin          = 0

  ;; pPlots                   = 1
  ;; PPlotRange               = [pFluxMin,1e2]
  ;; logPfPlot                = 0

  ;; tilePlotSuff             = "--nEvents_tHistos_nEvPerMin_nEvPerOrb_NOWEPCO"

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

  altRange                 = [[3000,4180]]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  btMin                          = 5

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1800
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  reset_omni_inds                = 1
  reset_good_inds                = 1
                                                                                                           
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  shiftMLT                       = 0.5
  ;; minMLT                         = 0.0
  ;; maxMLT                         = 16.0

  ;;Bonus
  maskMin                        = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun

  restrict_with_these_i          = WHERE(maximus.pFluxEst GE pFluxMin)

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     IF KEYWORD_SET(minMC) THEN BEGIN
        magCStr    = STRING(FORMAT='("--ABSmagc_GE_",I0)',minMC)
        magCTitStr = STRING(FORMAT='(", magc GE ",I0)',minMC)
     ENDIF ELSE BEGIN
        magCStr    = ''
        magCTitStr = ''
     ENDELSE

     altitudeRange = altRange[*,i]
     altStr        = STRING(FORMAT='("/",I0,"-",I0,A0,"--pFlux_GE_",I0)', $
                            altitudeRange[0], $
                            altitudeRange[1], $
                            magCStr, $
                            pFluxMin)
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km, Poynting flux $\geq$ ",I0," mW m!U-2!N")',altitudeRange[0],altitudeRange[1],pFluxMin)
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km",A0,", pFlux GE ",I0)', $
     ;;                        altitudeRange[0], $
     ;;                        altitudeRange[1], $
     ;;                        magCTitStr, $
     ;;                        pFluxMin)

     SETUP_TO_RUN_ALL_CLOCK_ANGLES,multiple_IMF_clockAngles,clockStrings, $
                                   angleLim1,angleLim2, $
                                   IMFStr,IMFTitle, $
                                   BYMIN=byMin, $
                                   BYMAX=byMax, $
                                   BZMIN=bzMin, $
                                   BZMAX=bzMax, $
                                   BTMIN=btMin, $
                                   BTMAX=btMax, $
                                   BXMIN=bxMin, $
                                   BXMAX=bxMax, $
                                   /AND_TILING_OPTIONS, $
                                   GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
                                   TILE_IMAGES=tile_images, $
                                   TILING_ORDER=tiling_order, $
                                   N_TILE_COLUMNS=n_tile_columns, $
                                   N_TILE_ROWS=n_tile_rows, $
                                   TILEPLOTSUFF=plotSuff
     
     ;; tilePlotSuffs       = tilePlotSuff
     ;; tilePlotTitles      = IMFTitle + ' ' + tilePlotTitle

     ;; plotPrefix          = altStr
     ;; suffix_plotDir      = (N_ELEMENTS(suffix_plotDir) GT 0) ?  altStr + '/' + suffix_plotDir : altStr
     suffix_plotDir      = (N_ELEMENTS(suffix_plotDir) GT 0) ?  '/' + suffix_plotDir + '/' + altStr : altStr
     ;; plotSuffs           = '--'+IMFStr+altStr

     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        CLOCKSTR=clockStrings, $
        MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        POYNTRANGE=poyntRange, $
        DELAY=delayArr, $
        ;; /MULTIPLE_DELAYS, $
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
        WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
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
        DO_DESPUNDB=do_despun, $
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, RAWDIR=rawDir, $
        JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        SUFFIX_PLOTDIR=suffix_plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIX=plotSuff, $
        TXTOUTPUTDIR=txtOutputDir, $
        SUFFIX_TXTDIR=suffix_txtDir, $
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
        ;; TILEPLOTSUFFS=tilePlotSuff, $
        TILING_ORDER=tiling_order, $
        TILEPLOTTITLE=tilePlotTitle, $
        GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
        SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
        NO_COLORBAR=no_colorbar, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        /MIDNIGHT, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        _EXTRA = e  
     
  ENDFOR



END
