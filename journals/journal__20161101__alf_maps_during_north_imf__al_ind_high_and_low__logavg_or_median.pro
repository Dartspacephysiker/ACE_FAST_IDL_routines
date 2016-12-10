;;11/01/16
PRO JOURNAL__20161101__ALF_MAPS_DURING_NORTH_IMF__AL_IND_HIGH_AND_LOW__LOGAVG_OR_MEDIAN

  COMPILE_OPT IDL2

  restore_last_session           = 0

  EA_binning                     = 1
  use_AACGM                      = 1

  include_NORTH                  = 0
  include_SOUTH                  = 0

  minMC                          = 5
  maxNegMC                       = -5

  use_AL                         = 1
  AEcutoff                       = -80
  smooth_AE                      = 0

  ;; nonstorm                       = 1
  ;; Dstcutoff                      = -20

  do_timeAvg_fluxQuantities      = 0
  logAvgPlot                     = 0
  medianPlot                     = 1
  divide_by_width_x              = 1

  ;;DB stuff
  do_despun                      = 0

  ;; plotPref                       = 

  autoscale_fluxPlots            = 0
  
  make_integral_file             = 0

  ;;If you want to do grossrates with Bx, see the journal from 20160816
  ;; do_grossRate_fluxQuantities    = 1
  ;; grossRate_info_file            = 'hammertime-bxMax-1--SOUTH.txt'
  ;; grossRate_info_file            = 'hammertime-bxMin1--SOUTH.txt'

  ;;bonus
  print_avg_imf_components       = 0
  print_master_OMNI_file         = 0
  save_master_OMNI_inds          = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The plots
  ePlots                         = 0
  eNumFlPlots                    = 0
  pPlots                         = 1
  ionPlots                       = 0
  probOccurrencePlot             = 0
  sum_electron_and_poyntingflux  = 0
  nOrbsWithEventsPerContribOrbsPlot = 0

  nowepco_range                  = [0,0.64]

  ;;e- energy flux
  ;; eFluxPlotType                  = 'Eflux_losscone_integ'
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [0.0,10.0]
  logEfPlot                      = 0
  noNegEflux                     = 0

  eNumFlPlotType                 = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  noNegENumFl                    = [1,1]
  ;; logENumFlPlot               = [1,1]
  ;; ENumFlPlotRange             = [[1e-1,1e1], $
  ;;                             [1e7,1e9]]
  logENumFlPlot                  = [0,0]
  ENumFlPlotRange                = [[0,10.0], $
                                    [0,5.0e9]]
  ;; eNumFlPlotType                 = 'ESA_Number_flux'
  ;; noNegENumFl                    = 0
  ;; logENumFlPlot                  = 0
  ;; ENumFlPlotRange                = [0,2e9]

  ;; logPfPlot                   = 1
  ;; PPlotRange                  = [1e-1,1e1]
  logPfPlot                      = 0
  ;; PPlotRange                     = [0,1.5]
  PPlotRange                     = [0,0.75] ;For lower current thresh

  ifluxPlotType                  = 'Integ_Up'
  noNegIflux                     = 1
  ;; logIfPlot                   = 1
  ;; IPlotRange                  = [1e6,1e8]
  logIfPlot                      = 0
  IPlotRange                     = [0,4.0e8]
  
  logProbOccurrence              = 0
  probOccurrenceRange            = [0,0.05]

  summed_eFlux_pFluxplotRange    = [0,10]
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Southern hemi ranges
  ;; ePlotRange                     = [0,0.25]

  ;; noNegENumFl                    = [1,1]
  ;; logENumFlPlot                  = [0,0]
  ;; ENumFlPlotRange                = [[0,0.25], $
  ;;                                   [0,8.0e8]]

  ;; PPlotRange                     = [0,0.25]

  ;; IPlotRange                     = [0,7.0e7]

  ;; summed_eFlux_pFluxplotRange    = [0,0.8]


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  reset_good_inds                = 1

  ;; altRange                    = [[340,1180], $
  ;;                             [1180,2180], $
  ;;                             [2180,3180], $
  ;;                             [3180,4180]]

  altRange                       = [[1000,4200]]

  orbRange                       = [1000,10800]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff
  clockStr                       = 'bzNorth'
  btMinArr                       = [0.5]
  ;; btMinArr                       = [1.5,2.0]
  ;; btMax                       = 5

  ;; angleLim1                      = 0.
  ;; angleLim2                      = 180.

  ;;Delay stuff
  nDelays                        = 1
  delayDeltaSec                  = 1800
  binOffset_delay                = 0
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

  reset_omni_inds                = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Screen stuff

  ;; maskMin                        =  1
  ;; tHist_mask_bins_below_thresh   = 10

  ;; numOrbLim                      = 10

  CASE 1 OF
     KEYWORD_SET(use_AU): BEGIN
        AE_str = 'AU'
     END
     KEYWORD_SET(use_AO): BEGIN
        AE_str = 'AO'
     END
     KEYWORD_SET(use_AL): BEGIN
        AE_str = 'AL'
     END
     ELSE: BEGIN
        AE_str = 'AE'
     END
  ENDCASE

  ;;Which hemispheres to do?
  loopInds                                    = !NULL
  
  IF N_ELEMENTS(include_BOTH) EQ 0 THEN include_BOTH = 1
  IF KEYWORD_SET(include_BOTH ) THEN loopInds = [loopInds,0,1]
  IF KEYWORD_SET(include_NORTH) THEN loopInds = [loopInds,2,3]
  IF KEYWORD_SET(include_SOUTH) THEN loopInds = [loopInds,4,5]

  FOR jj=0,N_ELEMENTS(loopInds)-1 DO BEGIN

     bx_i = loopInds[jj]

     CASE 1 OF
        bx_i LE 1: BEGIN
           hemi                           = 'BOTH'
           minILAT                        = 60
           maxILAT                        = 90
        END
        bx_i LE 3: BEGIN
           hemi                           = 'NORTH'
           minILAT                        = 60
           maxILAT                        = 90
        END
        ELSE: BEGIN
           hemi                           = 'SOUTH'
           minILAT                        = -90
           maxILAT                        = -60
        END
     ENDCASE

     CASE 1 OF
        ((bx_i MOD 2) EQ 0): BEGIN
           AE_high                        = 1
           AE_low                         = !NULL
           AEhighlow                      = 'high'
        END
        ELSE: BEGIN
           AE_high                        = !NULL
           AE_low                         = 1
           AEhighlow                      = 'low'
        END
     ENDCASE

     FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN

        altitudeRange               = altRange[*,i]
        altStr                      = STRING(FORMAT='(I0,"-",I0,"_km--orbs_",I0,"-",I0)', $
                                             altitudeRange[0], $
                                             altitudeRange[1], $
                                             orbRange[0], $
                                             orbRange[1])

        FOR jow=0,N_ELEMENTS(btMinArr)-1 DO BEGIN

           btMin      = btMinArr[jow]
           btMinStr   = STRING(FORMAT='("--bzMin_",F0.1,"--AEcutoff_",I0,"--",A0,A0)', $
                               btMin,AEcutoff,AE_str,AEhighlow)
           IF KEYWORD_SET(numOrbLim) THEN BEGIN
              btMinStr += STRING(FORMAT='("/numOrbLim_",I0)',numOrbLim)
           ENDIF

           ;; SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF=btMinStr
           ;; plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

           SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
           plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr  + btMinStr

           PLOT_ALFVEN_STATS_IMF_SCREENING, $
              CLOCKSTR=clockStr, $
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
              EQUAL_AREA_BINNING=EA_binning, $
              MIN_MAGCURRENT=minMC, $
              MAX_NEGMAGCURRENT=maxNegMC, $
              HWMAUROVAL=HwMAurOval, $
              HWMKPIND=HwMKpInd, $
              MASKMIN=maskMin, $
              THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
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
              BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
              BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
              ;; RUN_AROUND_THE_RING_OF_CLOCK_ANGLES=run_the_clockAngle_ring, $
              RESET_OMNI_INDS=reset_omni_inds, $
              SATELLITE=satellite, $
              OMNI_COORDS=omni_Coords, $
              PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
              PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
              SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
              HEMI=hemi, $
              STABLEIMF=stableIMF, $
              SMOOTHWINDOW=smoothWindow, $
              INCLUDENOCONSECDATA=includeNoConsecData, $
              ;; /DO_NOT_CONSIDER_IMF, $
              NONSTORM=nonStorm, $
              RECOVERYPHASE=recoveryPhase, $
              MAINPHASE=mainPhase, $
              DSTCUTOFF=DstCutoff, $
              USE_AE=use_ae, $
              USE_AU=use_au, $
              USE_AL=use_al, $
              USE_AO=use_ao, $
              AECUTOFF=AeCutoff, $
              SMOOTH_AE=smooth_AE, $
              AE_HIGH=AE_high, $
              AE_LOW=AE_low, $
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
              WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
              DIVIDE_BY_WIDTH_X=divide_by_width_x, $
              MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
              SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
              SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
              MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
              ALL_LOGPLOTS=all_logPlots, $
              SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
              DBFILE=dbfile, $
              NO_BURSTDATA=no_burstData, $
              RESET_GOOD_INDS=reset_good_inds, $
              DATADIR=dataDir, $
              DO_CHASTDB=do_chastDB, $
              DO_DESPUNDB=do_despun, $
              COORDINATE_SYSTEM=coordinate_system, $
              USE_AACGM_COORDS=use_AACGM, $
              USE_MAG_COORDS=use_MAG, $
              NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
              NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
              NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
              WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
              SAVERAW=saveRaw, $
              SAVEDIR=saveDir, $
              JUSTDATA=justData, $
              SHOWPLOTSNOSAVE=showPlotsNoSave, $
              PLOTDIR=plotDir, $
              PLOTPREFIX=plotPrefix, $
              PLOTSUFFIXES=plotSuff, $
              MEDHISTOUTDATA=medHistOutData, $
              MEDHISTOUTTXT=medHistOutTxt, $
              OUTPUTPLOTSUMMARY=outputPlotSummary, $
              DEL_PS=del_PS, $
              EPS_OUTPUT=eps_output, $
              SUPPRESS_THICKGRID=suppress_thickGrid, $
              SUPPRESS_GRIDLABELS=suppress_gridLabels, $
              SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
              SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
              SUPPRESS_MLT_NAME=suppress_MLT_name, $
              SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
              SUPPRESS_TITLES=suppress_titles, $
              OUT_TEMPFILE_LIST=out_tempFile_list, $
              OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
              OUT_PLOT_I_LIST=out_plot_i_list, $
              OUT_PARAMSTRING_LIST=out_paramString_list, $
              GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
              SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
              ADJ_UPPER_PLOTLIM_THRESH=adj_upper_plotlim_thresh, $
              ADJ_LOWER_PLOTLIM_THRESH=adj_lower_plotlim_thresh, $
              TILE_IMAGES=tile_images, $
              N_TILE_ROWS=n_tile_rows, $
              N_TILE_COLUMNS=n_tile_columns, $
              ;; TILEPLOTSUFFS=tilePlotSuffs, $
              TILING_ORDER=tiling_order, $
              TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
              TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
              TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
              TILEPLOTTITLES=tilePlotTitle, $
              NO_COLORBAR=no_colorbar, $
              CB_FORCE_OOBHIGH=cb_force_oobHigh, $
              CB_FORCE_OOBLOW=cb_force_oobLow, $
              /MIDNIGHT, $
              FANCY_PLOTNAMES=fancy_plotNames, $
              MAKE_INTEGRAL_FILE=make_integral_file, $
              RESTORE_LAST_SESSION=restore_last_session, $
              _EXTRA=e
           ;; /GET_PLOT_I_LIST_LIST, $
           ;; /GET_PARAMSTR_LIST_LIST, $
           ;; PLOT_I_LIST_LIST=plot_i_list_list, $
           ;; PARAMSTR_LIST_LIST=paramStr_list_list
           
        ENDFOR
     ENDFOR
  ENDFOR

END
