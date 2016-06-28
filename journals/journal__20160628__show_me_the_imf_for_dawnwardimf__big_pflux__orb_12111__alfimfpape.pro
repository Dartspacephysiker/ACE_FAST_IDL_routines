PRO JOURNAL__20160628__SHOW_ME_THE_IMF_FOR_DAWNWARDIMF__BIG_PFLUX__ORB_12111__ALFIMFPAPE
  
  orbStr                   = '12111'
  savePlot                 = 1
  savePName                = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + $
                             '--SW_conditions_for_dawnwardIMF--orb'+orbStr+'.png'

  use_dartDB__bef_nov1999  = 1
  geomag_axis_style        = 3

  tStartString             = '1999-09-12/19:20:00.000'
  tStart                   = STR_TO_TIME(tStartString)

  ;; maxind                   = 49
  ;; yLogScale_maxInd         = 1
  ;; min_nEvents              = 10

  ;;SEA options
  tBeforeEpoch             = 1
  tAfterEpoch              = 1
  remove_dupes             = 0
  only_OMNI_plots          = 1

  ;;flow speed is constantly ~560 km/s
  ;; OMNI_quantities_to_plot  = 'by_gse,bz_gse,bx_gse,flow_speed'
  ;; omni_quantity_ranges     = [[-10,10],[-10,2],[-5,5],[200,700]]
  ;; omni_quantity_axis_style = [3,1,1,1]

  OMNI_quantities_to_plot  = 'by_gse,bz_gse,bx_gse'
  omni_quantity_ranges     = [[-10,5],[-12,-2],[-10,5]]
  omni_quantity_axis_style = [3,1,1]

  SUPERPOSE_SEA_TIMES_ALFVENDBQUANTITIES, $
     TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
     STARTDATE=startDate, STOPDATE=stopDate, $
     DAYSIDE=dayside,NIGHTSIDE=nightside, $
     ;; EPOCHINDS=epochInds, $
     SEA_CENTERTIMES_UTC=tStart, $     
     ;; SEA_CENTERTIMES_UTC=tStartArr, $     
     REMOVE_DUPES=remove_dupes, $
     HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes, $
     REVERSE_REMOVE_DUPES=remove_dupes__reverse, $
     HOURS_BEF_FOR_NO_DUPES=hours_bef_for_no_dupes, $
     USE_SYMH=use_symh,USE_AE=use_AE, $
     OMNI_QUANTITIES_TO_PLOT=OMNI_quantities_to_plot, $
     OMNI_QUANTITY_RANGES=OMNI_quantity_ranges, $
     OMNI_QUANTITY_AXIS_STYLE=omni_quantity_axis_style, $
     LOG_OMNI_QUANTITIES=log_omni_quantities, $
     NEVENTHISTS=nEventHists, $
     HISTOBINSIZE=histoBinSize, HISTORANGE=histoRange, $
     TITLE__HISTO_PLOT=title__histo_plot, $
     XLABEL_HISTO_PLOT__SUPPRESS=xLabel_histo_plot__suppress, $
     SYMCOLOR__HISTO_PLOT=symColor__histo_plot, $
     MAKE_LEGEND__HISTO_PLOT=make_legend__histo_plot, $
     NAME__HISTO_PLOT=name__histo_plot, $
     N__HISTO_PLOTS=n__histo_plots, $
     ACCUMULATE__HISTO_PLOTS=accumulate__histo_plots, $
     PROBOCCURRENCE_SEA=probOccurrence_sea, $
     LOG_PROBOCCURRENCE=log_probOccurrence, $
     HIST_MAXIND_SEA=hist_maxInd_sea, $
     TIMEAVGD_MAXIND_SEA=timeAvgd_maxInd_sea, $
     LOG_TIMEAVGD_MAXIND=log_timeAvgd_maxInd, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
     ONLY_POS=only_pos, $
     ONLY_NEG=only_neg, $
     NEG_AND_POS_SEPAR=neg_and_pos_separ, $
     LAYOUT=layout, $
     POS_LAYOUT=pos_layout, $
     NEG_LAYOUT=neg_layout, $
     CUSTOM_MAXIND=custom_maxInd, $
     MAXIND=maxInd, $
     AVG_TYPE_MAXIND=avg_type_maxInd, $
     DO_TWO_PANELS=do_two_panels, $
     SECOND_PANEL__PREP_FOR_SECONDARY_AXIS=second_panel__prep_for_secondary_axis, $
     OVERPLOT_TOTAL_EPOCH_VARIATION=overplot_total_epoch_variation, $
     YRANGE_TOTALVAR=yRange_totalVar, $
     YLOGSCALE_TOTALVAR=yLogScale_totalVar, $
     TITLE__EPOCHVAR_PLOT=title__epochVar_plot, $
     NAME__EPOCHVAR_PLOT=name__epochVar_plot, $
     TOTAL_EPOCH__DO_HISTOPLOT=total_epoch__do_histoPlot, $
     SYMCOLOR__TOTAL_EPOCH_VAR=symColor__totalVar_plot, $
     SYMCOLOR__MAX_PLOT=symColor__max_plot, $
     TITLE__AVG_PLOT=title__avg_plot, $
     SYMCOLOR__AVG_PLOT=symColor__avg_plot, $
     SECONDARY_AXIS__TOTALVAR_PLOT=secondary_axis__totalVar_plot, $
     DIFFCOLOR_SECONDARY_AXIS=diffColor_secondary_axis, $
     MAKE_LEGEND__AVG_PLOT=make_legend__avg_plot, $
     MAKE_ERROR_BARS__AVG_PLOT=make_error_bars__avg_plot, $
     ERROR_BAR_NBOOT=error_bar_nBoot, $
     ERROR_BAR_CONFLIMIT=error_bar_confLimit, $
     NAME__AVG_PLOT=name__avg_plot, $
     N__AVG_PLOTS=n__avg_plots, $
     ACCUMULATE__AVG_PLOTS=accumulate__avg_plots, $
     RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
     LOG_DBQUANTITY=log_DBQuantity, $
     YLOGSCALE_MAXIND=yLogScale_maxInd, $
     XLABEL_MAXIND__SUPPRESS=xLabel_maxInd__suppress, $
     YTITLE_MAXIND=yTitle_maxInd, $
     YRANGE_MAXIND=yRange_maxInd, $
     SYMTRANSP_MAXIND=symTransp_maxInd, $
     YMINOR_MAXIND=yMinor_maxInd, $
     PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
     BKGRND_HIST=bkgrnd_hist, BKGRND_MAXIND=bkgrnd_maxInd, $
     TBINS=tBins, $
     DBFILE=dbFile,DB_TFILE=db_tFile, $
     NO_SUPERPOSE=no_superpose, $
     WINDOW_GEOMAG=geomagWindow, $
     WINDOW_MAXIMUS=maximusWindow, $
     NOPLOTS=noPlots, $
     NOGEOMAGPLOTS=noGeomagPlots, $
     ONLY_OMNI_PLOTS=only_OMNI_plots, $
     NOMAXPLOTS=noMaxPlots, $
     NOAVGPLOTS=noAvgPlots, $
     USE_DARTDB__BEF_NOV1999=use_dartDB__bef_nov1999, $
     DO_DESPUNDB=do_despunDB, $
     USING_HEAVIES=using_heavies, $
     SAVEFILE=saveFile, $
     OVERPLOT_HIST=overplot_hist, $
     PLOTTITLE=plotTitle, $
     SAVEPNAME=savePName, $
     SAVEPLOT=savePlot, $
     SAVEMAXPLOT=saveMaxPlot, $
     SAVEMPNAME=saveMPName, $
     DO_SCATTERPLOTS=do_scatterPlots, $
     EPOCHPLOT_COLORNAMES=epochPlot_colorNames, $
     SCATTEROUTPREFIX=scatterOutPrefix, $
     RANDOMTIMES=randomTimes, $
     MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
     DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
     HEMI=hemi, $
     OUT_BKGRND_HIST=out_bkgrnd_hist, $
     OUT_BKGRND_MAXIND=out_bkgrnd_maxind, $
     OUT_TBINS=out_tBins, $
     OUT_MAXPLOT=out_maxPlot, $
     OUT_GEOMAG_PLOT=out_geomag_plot, $
     OUT_HISTO_PLOT=out_histo_plot, $
     OUT_AVG_PLOT=out_avg_plot
  
END