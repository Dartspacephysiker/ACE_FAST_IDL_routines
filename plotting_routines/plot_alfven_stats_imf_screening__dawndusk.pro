;2016/01/01 This is a wrapper so that we don't have to do the gobbledigook below every time we want to see 'sup with these plots
;;mod history
;;;;;;;
;;TO DO
;;
;;
PRO PLOT_ALFVEN_STATS_IMF_SCREENING__DAWNDUSK,maximus, $
   CLOCKSTR=clockStr, $
   NORTHSOUTH=northSouth, $
   RESTRICT_WITH_THESE_I=restrict_with_these_i, $
   ANGLELIM1=angleLim1, $
   ANGLELIM2=angleLim2, $
   ORBRANGE=orbRange, $
   ALTITUDERANGE=altitudeRange, $
   CHARERANGE=charERange, $
   POYNTRANGE=poyntRange, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   NUMORBLIM=numOrbLim, $
   MINMLT=minMLT,MAXMLT=maxMLT, $
   BINMLT=binMLT, $
   SHIFTMLT=shiftMLT, $
   MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
   DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
   MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
   MIN_MAGCURRENT=minMC, $
   MAX_NEGMAGCURRENT=maxNegMC, $
   HWMAUROVAL=HwMAurOval, $
   HWMKPIND=HwMKpInd, $
   MIN_NEVENTS=min_nEvents, $
   MASKMIN=maskMin, $
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
   RUN_AROUND_THE_RING_OF_CLOCK_ANGLES=ring_of_clock_angles, $
   SATELLITE=satellite, $
   OMNI_COORDS=omni_Coords, $
   HEMI=hemi, $
   BOTH_HEMIS=both_hemis, $
   NORTH=north, $
   SOUTH=south, $
   DELAY=delay, $
   MULTIPLE_DELAYS=multiple_delays, $
   RESOLUTION_DELAY=delay_res, $
   BINOFFSET_DELAY=binOffset_delay, $
   STABLEIMF=stableIMF, $
   SMOOTHWINDOW=smoothWindow, $
   INCLUDENOCONSECDATA=includeNoConsecData, $
   NONSTORM=nonStorm, $
   RECOVERYPHASE=recoveryPhase, $
   MAINPHASE=mainPhase, $
   DSTCUTOFF=dstCutoff, $
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
   DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
   ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
   ORBCONTRIBRANGE=orbContribRange, $
   ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
   ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
   NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
   DIVNEVBYTOTAL=divNEvByTotal, $
   NEVENTPERMINPLOT=nEventPerMinPlot, $
   NEVENTPERMINRANGE=nEventPerMinRange, $
   LOGNEVENTPERMIN=logNEventPerMin, $
   NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
   NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
   LOG_NOWEPCOPLOT=log_nowepcoPlot, $
   NOWEPCO_RANGE=nowepco_range, $
   NOWEPCO_AUTOSCALE=nowepco_autoscale, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   PROBOCCURRENCERANGE=probOccurrenceRange, $
   PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
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
   DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
   WRITE_GROSSRATE_INFO_TO_THIS_FILE=write_grossRate_info_to_this_file, $
   GROSSLUN=grossLun, $
   WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
   ADD_VARIANCE_PLOTS=add_variance_plots, $
   ONLY_VARIANCE_PLOTS=only_variance_plots, $
   VAR__PLOTRANGE=var__plotRange, $
   VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
   VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
   VAR__AUTOSCALE=var__autoscale, $
   PLOT_CUSTOM_MAXIND=plot_custom_maxInd, $
   CUSTOM_MAXINDS=custom_maxInds, $
   CUSTOM_MAXIND_RANGE=custom_maxInd_range, $
   CUSTOM_MAXIND_AUTOSCALE=custom_maxInd_autoscale, $
   CUSTOM_MAXIND_DATANAME=custom_maxInd_dataname, $
   CUSTOM_MAXIND_TITLE=custom_maxInd_title, $
   CUSTOM_GROSSRATE_CONVFACTOR=custom_grossRate_convFactor, $
   LOG_CUSTOM_MAXIND=log_custom_maxInd, $
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
   WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
   SAVERAW=saveRaw, RAWDIR=rawDir, $
   JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
   PLOTDIR=plotDir, $
   PLOTPREFIX=plotPrefix, $
   PLOTSUFFIXES=plotSuffixes, $
   TXTOUTPUTDIR=txtOutputDir, $
   MEDHISTOUTDATA=medHistOutData, $
   MEDHISTOUTTXT=medHistOutTxt, $
   OUTPUTPLOTSUMMARY=outputPlotSummary, $
   DEL_PS=del_PS, $
   COMBINE_PLOTS=combine_plots, $
   N_TO_COMBINE=n_to_combine, $
   COMBINED_TO_BUFFER=combined_to_buffer, $
   SAVE_COMBINED_WINDOW=save_combined_window, $
   SAVE_COMBINED_NAME=save_combined_name, $
   NO_COLORBAR=no_colorbar, $
   KEEP_COLORBAR=keep_colorbar,$
   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
   CB_FORCE_OOBLOW=cb_force_oobLow, $
   FANCY_PLOTNAMES=fancy_plotNames, $
   _EXTRA = e, $
   PRINT_DATA_AVAILABILITY=print_data_availability, $
   GET_PLOT_I_LIST_LIST=get_plot_i_list_list, $
   GET_PARAMSTR_LIST_LIST=get_paramStr_list_list, $
   PLOT_I_LIST_LIST=plot_i_list_list, $
   PARAMSTR_LIST_LIST=paramStr_list_list, $
   TILE_IMAGES=tile_images, $
   N_TILE_ROWS=n_tile_rows, $
   N_TILE_COLUMNS=n_tile_columns, $
   TILEPLOTSUFFS=tilePlotSuffs, $
   TILING_ORDER=tiling_order, $
   TILEPLOTTITLES=tilePlotTitles, $
   VERBOSE=verbose, $
   LUN=lun


  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  SET_TXTOUTPUT_DIR,txtOutputDir,/FOR_SW_IMF,/ADD_TODAY

  IF KEYWORD_SET(combine_plots) THEN BEGIN
     outTempFiles = !NULL
     no_colorbar  = KEYWORD_SET(keep_colorbar) ? [0,0] : [0,1]
  ENDIF ELSE BEGIN
     no_colorbar  = [0,0]
  ENDELSE

  ;; suff            = STRING(FORMAT='("--Dstcutoff_",I0)',dstCutoff)
  ;; clockStrings    = [""+suff,"mainphase"+suff,"recoveryphase"+suff]
  CASE 1 OF
     KEYWORD_SET(northSouth): BEGIN
        titles          = ['B!Dz!N North','B!Dz!N South']
        clockStrings    = ['bzNorth','bzSouth']
     END
     KEYWORD_SET(ring_of_clock_angles): BEGIN
        PRINT,'Running the ring of clock angles!'
        titles          = ['B!Dz!N North','Dusk-North','Duskward','Dusk-South','B!Dz!N South','Dawn-South','Dawnward','Dawn-north']
        clockStrings    = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
        angleLim1       = 67.5
        angleLim2       = 112.5
        no_colorbar     = [0,0,0,0,0,0,0,0]
     END
     ELSE: BEGIN
        titles          = ['Dawnward','Duskward']
        clockStrings    = ['dawnward','duskward']
     END
  ENDCASE
  
  outTempfiles_list_list = LIST()
  plot_i_list_list       = LIST()
  paramStr_list_list     = LIST()
  FOR i=0,N_ELEMENTS(clockStrings)-1 DO BEGIN

     IF KEYWORD_SET(tile_images) THEN BEGIN

        CASE N_ELEMENTS(tilePlotSuffs) OF
           0: BEGIN
              END
           1: BEGIN
              tilePlotSuffFinal = tilePlotSuffs
           END
           ELSE: BEGIN
              tilePlotSuffFinal = tilePlotSuffs[i]
           END
        ENDCASE

        CASE N_ELEMENTS(plotSuffixes) OF
           0: BEGIN
              END
           1: BEGIN
              plotSuffix        = plotSuffixes
           END
           ELSE: BEGIN
              plotSuffix        = plotSuffixes[i]
           END
        ENDCASE

        CASE N_ELEMENTS(tilePlotTitles) OF
           0: BEGIN
              END
           1: BEGIN
              tilePlotTitleFinal = tilePlotTitles
           END
           ELSE: BEGIN
              tilePlotTitleFinal = tilePlotTitles[i]
           END
        ENDCASE
     ENDIF

     PLOT_ALFVEN_STATS_IMF_SCREENING,maximus, $
                                     CLOCKSTR=clockStrings[i], $
                                     ;; MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                                     ANGLELIM1=angleLim1, $
                                     ANGLELIM2=angleLim2, $
                                     ORBRANGE=orbRange, $
                                     ALTITUDERANGE=altitudeRange, $
                                     CHARERANGE=charERange, $
                                     POYNTRANGE=poyntRange, $
                                     RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                     SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                     NUMORBLIM=numOrbLim, $
                                     MINMLT=minMLT,MAXMLT=maxMLT, $
                                     BINMLT=binMLT, $
                                     SHIFTMLT=shiftMLT, $
                                     MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                     DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                     MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                                     MIN_MAGCURRENT=minMC, $
                                     MAX_NEGMAGCURRENT=maxNegMC, $
                                     BOTH_HEMIS=both_hemis, $
                                     NORTH=north, $
                                     SOUTH=south, $
                                     HEMI=hemi, $
                                     HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                     MIN_NEVENTS=min_nEvents, $
                                     MASKMIN=maskMin, $
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
                                     DELAY=delay, $
                                     MULTIPLE_DELAYS=multiple_delays, $
                                     RESOLUTION_DELAY=delay_res, $
                                     BINOFFSET_DELAY=binOffset_delay, $
                                     STABLEIMF=stableIMF, $
                                     SMOOTHWINDOW=smoothWindow, $
                                     INCLUDENOCONSECDATA=includeNoConsecData, $
                                     NONSTORM=nonStorm, $
                                     RECOVERYPHASE=recoveryPhase, $
                                     MAINPHASE=mainPhase, $
                                     DSTCUTOFF=dstCutoff, $
                                     EPLOTS=ePlots, $
                                     EPLOTRANGE=ePlotRange, $                                       
                                     EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                                     ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                                     ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
                                     LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
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
                                     DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
                                     DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                                     NPLOTS=nPlots, $
                                     NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                     ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                     ORBCONTRIBRANGE=orbContribRange, $
                                     ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
                                     ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                     NEVENTPERORBPLOT=nEventPerOrbPlot, $
                                     LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                     DIVNEVBYTOTAL=divNEvByTotal, $
                                     NEVENTPERMINPLOT=nEventPerMinPlot, $
                                     NEVENTPERMINRANGE=nEventPerMinRange, $
                                     LOGNEVENTPERMIN=logNEventPerMin, $
                                     NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
                                     NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
                                     LOG_NOWEPCOPLOT=log_nowepcoPlot, $
                                     NOWEPCO_RANGE=nowepco_range, $
                                     NOWEPCO_AUTOSCALE=nowepco_autoscale, $
                                     PROBOCCURRENCEPLOT=probOccurrencePlot, $
                                     PROBOCCURRENCERANGE=probOccurrenceRange, $
                                     PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
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
                                     DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                                     WRITE_GROSSRATE_INFO_TO_THIS_FILE=write_grossRate_info_to_this_file, $
                                     GROSSLUN=grossLun, $
                                     WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
                                     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                     MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                                     ADD_VARIANCE_PLOTS=add_variance_plots, $
                                     ONLY_VARIANCE_PLOTS=only_variance_plots, $
                                     VAR__PLOTRANGE=var__plotRange, $
                                     VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
                                     VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
                                     VAR__AUTOSCALE=var__autoscale, $
                                     PLOT_CUSTOM_MAXIND=plot_custom_maxInd, $
                                     CUSTOM_MAXINDS=custom_maxInds, $
                                     CUSTOM_MAXIND_RANGE=custom_maxInd_range, $
                                     CUSTOM_MAXIND_AUTOSCALE=custom_maxInd_autoscale, $
                                     CUSTOM_MAXIND_DATANAME=custom_maxInd_dataname, $
                                     CUSTOM_MAXIND_TITLE=custom_maxInd_title, $
                                     CUSTOM_GROSSRATE_CONVFACTOR=custom_grossRate_convFactor, $
                                     LOG_CUSTOM_MAXIND=log_custom_maxInd, $
                                     SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
                                     MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                     ALL_LOGPLOTS=all_logPlots, $
                                     SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                                     WHOLECAP=wholeCap, $
                                     DBFILE=dbfile, $
                                     NO_BURSTDATA=no_burstData, $
                                     RESET_GOOD_INDS=reset_good_inds, $
                                     DATADIR=dataDir, $
                                     DO_CHASTDB=do_chastDB, $
                                     DO_DESPUNDB=do_despunDB, $
                                     WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                     SAVERAW=saveRaw, RAWDIR=rawDir, $
                                     JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                     PLOTDIR=plotDir, $
                                     PLOTPREFIX=plotPrefix, $
                                     PLOTSUFFIX=plotSuffix, $
                                     TXTOUTPUTDIR=txtOutputDir, $
                                     MEDHISTOUTDATA=medHistOutData, $
                                     MEDHISTOUTTXT=medHistOutTxt, $
                                     OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                                     OUT_TEMPFILE_LIST=out_tempFile_list, $
                                     OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
                                     OUT_PARAMSTRING_LIST=out_paramString_list, $
                                     OUT_PLOT_I_LIST=out_plot_i_list, $
                                     TILE_IMAGES=tile_images, $
                                     N_TILE_ROWS=n_tile_rows, $
                                     N_TILE_COLUMNS=n_tile_columns, $
                                     TILEPLOTSUFF=tilePlotSuffFinal, $
                                     TILING_ORDER=tiling_order, $
                                     TILEPLOTTITLE=tilePlotTitleFinal, $
                                     GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
                                     NO_COLORBAR=no_colorbar[i], $
                                     CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                     CB_FORCE_OOBLOW=cb_force_oobLow, $
                                     FANCY_PLOTNAMES=fancy_plotNames, $
                                     _EXTRA = e  
     
     IF KEYWORD_SET(combine_plots) THEN BEGIN
        ;; IF KEYWORD_SET(multiple_delays) THEN BEGIN
           outTempFiles_list_list.add,out_tempFile_list
        ;; ENDIF 
     ENDIF
              
     IF KEYWORD_SET(get_plot_i_list_list) THEN BEGIN
        plot_i_list_list.add,out_plot_i_list
     ENDIF

     IF KEYWORD_SET(get_paramStr_list_list) THEN BEGIN
        paramStr_list_list.add,out_paramString_list
     ENDIF

  ENDFOR

  IF KEYWORD_SET(combine_plots) THEN BEGIN

     IF KEYWORD_SET(ring_of_clock_angles) THEN BEGIN
        PRINT,"Can't combine when we're doing ring of clock angles!"
        STOP
     ENDIF

     FOR iDawnDuskSet=0,N_ELEMENTS(outTempFiles_list_list[0])-1 DO BEGIN
        outTempFiles              = [outTempFiles_list_list[0,iDawnDuskSet],outTempFiles_list_list[1,iDawnDuskSet]]

        COMBINE_ALFVEN_STATS_PLOTS,titles, $
                                   N_TO_COMBINE=n_to_combine, $
                                   TEMPFILES=outTempFiles, $
                                   ;; OUT_IMGS_ARR=out_imgs_arr, $
                                   ;; OUT_TITLEOBJS_ARR=out_titleObjs_arr, $
                                   COMBINED_TO_BUFFER=combined_to_buffer, $
                                   SAVE_COMBINED_WINDOW=save_combined_window, $
                                   SAVE_COMBINED_NAME=save_combined_name, $
                                   PLOTNAMEPREFARR=paramStrings, $
                                   PLOTSUFFIX=plotSuffix, $
                                   PLOTDIR=plotDir, $
                                   /DELETE_PLOTS_WHEN_FINISHED
     ENDFOR
  ENDIF

END