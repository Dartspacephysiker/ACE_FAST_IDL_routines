;+
; NAME: PLOT_ALFVEN_STATS_IMF_SCREENING
;
; PURPOSE: Plot FAST data processed by Chris Chaston's ALFVEN_STATS_5 procedure (with mods).
;          All data are binned by MLT and ILAT (bin sizes can be set manually).
;
; CALLING SEQUENCE: PLOT_ALFVEN_STATS_IMF_SCREENING
;
; INPUTS:
;
; OPTIONAL INPUTS:   
;                *DATABASE PARAMETERS
;                    CLOCKSTR          :  Interplanetary magnetic field clock angle.
;                                            Can be 'dawnward', 'duskward', 'bzNorth', 'bzSouth', 'all_IMF',
;                                            'dawn-north', 'dawn-south', 'dusk-north', or 'dusk-south'.
;		     ANGLELIM1         :     
;		     ANGLELIM2         :     
;		     ORBRANGE          :  Two-element vector, lower and upper limit on orbits to include   
;		     ALTITUDERANGE     :  Two-element vector, lower and upper limit on altitudes to include   
;                    CHARERANGE        :  Two-element vector, lower ahd upper limit on characteristic energy of electrons in 
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
;                    POYNTRANGE        :  Two-element vector, lower and upper limit Range of Poynting flux values to include.
;                    NUMORBLIM         :  Minimum number of orbits passing through a given bin in order for the bin to be 
;                                            included and not masked in the plot.
; 		     MINMLT            :  MLT min  (Default: 9)
; 		     MAXMLT            :  MLT max  (Default: 15)
; 		     BINMLT            :  MLT binsize  (Default: 0.5)
;		     MINILAT           :  ILAT min (Default: 64)
;		     MAXILAT           :  ILAT max (Default: 80)
;		     BINILAT           :  ILAT binsize (Default: 2.0)
;		     MIN_NEVENTS       :  Minimum number of events an orbit must contain to qualify as a "participating orbit"
;                    MASKMIN           :  Minimum number of events a given MLT/ILAT bin must contain to show up on the plot.
;                                            Otherwise it gets shown as "no data". (Default: 1)
;                    BYMIN             :  Minimum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMIN             :  Minimum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;                    BYMAX             :  Maximum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMAX             :  Maximum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;		     NPLOTS            :  Plot number of orbits.   
;                    HEMI              :  Hemisphere for which to show statistics. Can be "North", "South", or "Both".
;
;                *IMF SATELLITE PARAMETERS
;                    SATELLITE         :  Satellite to use for checking FAST data against IMF.
;                                           Can be any of "ACE", "wind", "wind_ACE", or "OMNI" (default).
;                    OMNI_COORDS       :  If using "OMNI" as the satellite, choose between GSE or GSM coordinates for the database.
;                    DELAY             :  Time (in seconds) to lag IMF behind FAST observations. 
;                                         Binzheng Zhang has found that current IMF conditions at ACE or WIND usually rear   
;                                            their heads in the ionosphere about 11 minutes after they are observed.
;                    STABLEIMF         :  Time (in minutes) over which stability of IMF is required to include data.
;                                            NOTE! Cannot be less than 1 minute.
;                    SMOOTHWINDOW      :  Smooth IMF data over a given window (default: none)
;
;                *HOLZWORTH/MENG STATISTICAL AURORAL OVAL PARAMETERS 
;                    HWMAUROVAL        :  Only include those data that are above the statistical auroral oval.
;                    HWMKPIND          :  Kp Index to use for determining the statistical auroral oval (def: 7)
;
;                *ELECTRON FLUX PLOT OPTIONS
;		     EPLOTS            :     
;                    EFLUXPLOTTYPE     :  Options are 'Integ' for integrated or 'Max' for max data point.
;                    LOGEFPLOT         :  Do log plots of electron energy flux.
;                    ABSEFLUX          :  Use absolute value of electron energy flux (required for log plots).
;                    NONEGEFLUX        :  Do not use negative e fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOSEFLUX        :  Do not use positive e fluxes in any of the plots
;                    EPLOTRANGE        :  Range of allowable values for e- flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;
;                *ELECTRON NUMBER FLUX PLOT OPTIONS
;		     ENUMFLPLOTS       :  Do plots of max electron number flux
;                    ENUMFLPLOTTYPE    :  Options are 'Total_Eflux_Integ', 'Eflux_Losscone_Integ', 'ESA_Number_flux'.
;                    LOGENUMFLPLOT     :  Do log plots of electron number flux.
;                    ABSENUMFL         :  Use absolute value of electron number flux (required for log plots).
;                    NONEGENUMFL       :  Do not use negative e num fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOSENUMFL       :  Do not use positive e num fluxes in any of the plots
;                    ENUMFLPLOTRANGE   :  Range of allowable values for e- num flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;                    
;                *POYNTING FLUX PLOT OPTIONS
;		     PPLOTS            :  Do Poynting flux plots.
;                    LOGPFPLOT         :  Do log plots of Poynting flux.
;                    ABSPFLUX          :  Use absolute value of Poynting flux (required for log plots).
;                    NONEGPFLUX        :  Do not use negative Poynting fluxes in any of the plots
;                    NOPOSPFLUX        :  Do not use positive Poynting fluxes in any of the plots
;                    PPLOTRANGE        :  Range of allowable values for e- flux plots. 
;                                         (Default: [0,3]; [-1,0.5] for log plots)
;
;                *ION FLUX PLOT OPTIONS
;		     IONPLOTS          :  Do ion plots (using ESA data).
;                    IFLUXPLOTTYPE     :  Options are 'Integ', 'Max', 'Integ_Up', 'Max_Up', or 'Energy'.
;                    LOGIFPLOT         :  Do log plots of ion flux.
;                    ABSIFLUX          :  Use absolute value of ion flux (required for log plots).
;                    NONEGIFLUX        :  Do not use negative ion fluxes in any of the plots (positive is earthward for ion flux)
;                    NOPOSIFLUX        :  Do not use positive ion fluxes in any of the plots
;                    IPLOTRANGE        :  Range of allowable values for ion flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;
;                *CHAR E PLOTS
;                    CHAREPLOTS        :  Do characteristic electron energy plots
;                    CHARETYPE         :  Options are 'lossCone' for electrons in loss cone or 'Total' for all electrons.
;                    LOGCHAREPLOT      :  Do log plots of characteristic electron energy.
;                    ABSCHARE          :  Use absolute value of characteristic electron (required for log plots).
;                    NONEGCHARE        :  Do not use negative char e in any of the plots (positive MIGHT be earthward...)
;                    NOPOSCHARE        :  Do not use positive char e in any of the plots
;                    CHAREPLOTRANGE    :  Range of allowable values for characteristic electron energy plots. 
;                                         (Default: [-500000,500000]; [0,3.6] for log plots)
;
;                *ORBIT PLOT OPTIONS
;		     ORBCONTRIBPLOT    :  Contributing orbit plots
;		     ORBCONTRIBRANGE   :  Range for contributing orbit plot
;		     ORBTOTPLOT        :  Plot of total number of orbits for each bin, 
;                                            given user-specified restrictions on the database.
;		     ORBTOTRANGE       :  Range for Orbtotplot 
;		     ORBFREQPLOT       :  Plot of orbits contributing to a given bin, 
;		     ORBFREQRANGE      :  Range for Orbfreqplot.
;                                            divided by total orbits passing through the bin.
;                    NEVENTSPLOTRANGE  :  Range for nEvents plot.
;                    LOGNEVENTSPLOT    :  Do log plot for n events
;
;                    NEVENTPERORBPLOT  :  Plot of number of events per orbit.
;                    NEVENTPERORBRANGE :  Range for Neventperorbplot.
;                    LOGNEVENTPERORB   :  Log of Neventperorbplot (for comparison with Chaston et al. [2003])
;                    DIVNEVBYTOTAL     :  Divide number of events in given bin by the number of orbits occurring 
;                                            during specified IMF conditions. (Default is to divide by total number of orbits 
;                                            pass through given bin for ANY IMF condition.)
;
;                    NEVENTPERMINPLOT  :  Plot of number of events per minute that FAST spent in a given MLT/ILAT region when
;                                           FAST electron survey data were available (since that's the only time we looked
;                                           for Alfvén activity.
;                    LOGNEVENTPERMIN   :  Log of Neventpermin plot 
;                    MAKESMALLESTBINMIN:  Find the smallest bin, make that 
;
;                *ASSORTED PLOT OPTIONS--APPLICABLE TO ALL PLOTS
;		     MEDIANPLOT        :  Do median plots instead of averages.
;                    LOGAVGPLOT        :  Do log averaging instead of straight averages
;		     ALL_LOGPLOT       :  All plots logged
;		     SQUAREPLOT        :  Do plots in square bins. (Default plot is in polar stereo projection)    
;                    POLARCONTOUR      :  Do polar plot, but do a contour instead
;                    WHOLECAP*         :   *(Only for polar plot!) Plot the entire polar cap, not just a range of MLTs and ILATs
;                    MIDNIGHT*         :   *(Only for polar plot!) Orient polar plot with midnight (24MLT) at bottom
;		     DBFILE            :  Which database file to use?
;                    NO_BURSTDATA      :  Exclude data from burst runs of Alfven_stats_5 (burst data were produced 2015/08/10)
;		     DATADIR           :     
;		     CHASTDB        :  Use Chaston's original ALFVEN_STATS_3 database. 
;                                            (He used it for a few papers, I think, so it's good).
;
;                  *VARIOUS OUTPUT OPTIONS
;		     WRITEASCII        :     
;		     WRITEHDF5         :      
;                    WRITEPROCESSEDH2D :  Use this to output processed, histogrammed data. That way you
;                                            can share with others!
;		     SAVERAW           :  Save all raw data
;		     SAVEDIR           :  Directory in which to save things
;                    JUSTDATA          :  No plots whatsoever; just give me the dataz.
;                    SHOWPLOTSNOSAVE   :  Don't save plots, just show them immediately
;		     PLOTDIR           :     
;		     PLOTPREFIX        :     
;		     PLOTSUFFIX        :     
;                    OUTPUTPLOTSUMMARY :  Make a text file with record of running params, various statistics
;                    MEDHISTOUTDATA    :  If doing median plots, output the median pointer array. 
;                                           (Good for further inspection of the statistics involved in each bin
;                    MEDHISTDATADIR    :  Directory where median histogram data is outputted.
;                    MEDHISTOUTTXT     :  Use 'medhistoutdata' output to produce .txt files with
;                                           median and average values for each MLT/ILAT bin.
;                    DEL_PS            :  Delete postscript outputted by plotting routines
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS: 
;                    MAXIMUS           :  Return maximus structure used in this pro.
;

; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE: 
;     Use Chaston's original (ALFVEN_STATS_3) database, only including orbits falling in the range 1000-4230
;     plot_alfven_stats_imf_screening,clockstr="duskward",/chastDB,$
;                                          plotpref='NESSF2014_reproduction_Jan2015--orbs1000-4230',ORBRANGE=[1000,4230]
;
;
;
; MODIFICATION HISTORY: Best to follow my mod history on the Github repository...
;                       2015/08/15 : Changed INCLUDE_BURST to NO_BURSTDATA, because why wouldn't we want to use it?
;                       Aug 2015   : Added INCLUDE_BURST option, which includes all Alfvén waves identified by as5 while FAST
;                                    was running in burst mode.
;                       Jan 2015  :  Finally turned interp_plots_str into a procedure! Here you have
;                                    the result.
;                       Dec 2015   : ... And now added stormtime keywords as well as RESTRICT_WITH_THESE_I keyword
;                       Jan 2016   : Added DESPUNDB keyword for our new despun database with TEAMS data!
;                     2016/02/10   : Added DO_NOT_CONSIDER_IMF keyword
;                     2016/02/20   : Big changes. Added multiple_delays keyword, which shakes up the whole system.
;-

PRO PLOT_ALFVEN_STATS_IMF_SCREENING, $
   RESTRICT_WITH_THESE_I=restrict_with_these_i, $
   FOR_ION_DBS=for_ion_DBs, $
   FOR_ESPEC_DBS=for_eSpec_DBs, $
   NEED_FASTLOC_I=need_fastLoc_i, $
   USE_STORM_STUFF=use_storm_stuff, $
   AE_STUFF=ae_stuff, $    
   MASKMIN=maskMin, $
   THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   RESET_OMNI_INDS=reset_omni_inds, $
   OMNI_COORDS=omni_Coords, $
   PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
   PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
   PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
   SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
   MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
   OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
   CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
   INCLUDENOCONSECDATA=includeNoConsecData, $
   NPLOTS=nPlots, $
   EPLOTS=ePlots, $
   EPLOTRANGE=ePlotRange, $
   EFLUXPLOTTYPE=eFluxPlotType, $
   LOGEFPLOT=logEfPlot, $
   ENUMFLPLOTS=eNumFlPlots, $
   ENUMFLPLOTTYPE=eNumFlPlotType, $
   LOGENUMFLPLOT=logENumFlPlot, $
   ENUMFLPLOTRANGE=ENumFlPlotRange, $
   AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
   NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
   NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
   NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
   NEWELL__COMBINE_ACCELERATED=Newell__comb_accelerated, $
   ESPEC__NO_MAXIMUS=no_maximus, $
   ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
   PPLOTS=pPlots, $
   LOGPFPLOT=logPfPlot, $
   PPLOTRANGE=PPlotRange, $
   IONPLOTS=ionPlots, $
   IFLUXPLOTTYPE=ifluxPlotType, $
   LOGIFPLOT=logIfPlot, $
   IPLOTRANGE=IPlotRange, $
   OXYPLOTS=oxyPlots, $
   OXYFLUXPLOTTYPE=oxyFluxPlotType, $
   LOGOXYFPLOT=logOxyfPlot, $
   OXYPLOTRANGE=oxyPlotRange, $
   CHAREPLOTS=charEPlots, $
   CHARETYPE=charEType, $
   LOGCHAREPLOT=logCharEPlot, $
   CHAREPLOTRANGE=CharEPlotRange, $
   CHARIEPLOTS=chariePlots, $
   LOGCHARIEPLOT=logChariePlot, $
   CHARIEPLOTRANGE=ChariePlotRange, $
   AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
   FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
   FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
   FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
   FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
   DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
   DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
   DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
   ORBCONTRIBPLOT=orbContribPlot, $
   LOGORBCONTRIBPLOT=logOrbContribPlot, $
   ORBTOTPLOT=orbTotPlot, $
   ORBFREQPLOT=orbFreqPlot, $
   ORBCONTRIBRANGE=orbContribRange, $
   ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
   ORBCONTRIB__REFERENCE_ALFVENDB_NOT_EPHEMERIS=orbContrib__reference_alfvenDB, $
   ORBTOTRANGE=orbTotRange, $
   ORBFREQRANGE=orbFreqRange, $
   ORBCONTRIB_NOMASK=orbContrib_noMask, $
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
   LOG_NOWEPCOPLOT=log_nowepcoPlot, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   PROBOCCURRENCERANGE=probOccurrenceRange, $
   PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
   LOGPROBOCCURRENCE=logProbOccurrence, $
   THISTDENOMINATORPLOT=tHistDenominatorPlot, $
   THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
   THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
   THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
   THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
   NEWELLPLOTS=newellPlots, $
   NEWELL_PLOTRANGE=newell_plotRange, $
   LOG_NEWELLPLOT=log_newellPlot, $
   NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
   NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
   NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
   ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
   ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
   ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
   ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
   TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
   TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
   LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
   TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
   TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
   LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
   DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
   DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
   DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
   WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
   WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
   WRITE_ORB_AND_OBS__INC_IMF=write_obsArr__inc_IMF, $
   WRITE_ORB_AND_OBS__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
   MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
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
   SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
   SUMMED_EFLUX_PFLUX_LOGPLOT=summed_eFlux_pFlux_logPlot, $
   MEDIANPLOT=medianPlot, $
   LOGAVGPLOT=logAvgPlot, $
   ALL_LOGPLOTS=all_logPlots, $
   SQUAREPLOT=squarePlot, $
   POLARCONTOUR=polarContour, $
   DBFILE=dbfile, $
   RESET_GOOD_INDS=reset_good_inds, $
   NO_BURSTDATA=no_burstData, $
   DATADIR=dataDir, $
   COORDINATE_SYSTEM=coordinate_system, $
   USE_AACGM_COORDS=use_AACGM, $
   USE_MAG_COORDS=use_MAG, $
   NEVENTSPLOTRANGE=nEventsPlotRange, $
   LOGNEVENTSPLOT=logNEventsPlot, $
   NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
   NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
   WRITEASCII=writeASCII, $
   WRITEHDF5=writeHDF5, $
   WRITEPROCESSEDH2D=writeProcessedH2d, $
   SAVERAW=saveRaw, $
   SAVEDIR=saveDir, $
   SHOWPLOTSNOSAVE=showPlotsNoSave, $
   PLOTDIR=plotDir, $
   SUFFIX_PLOTDIR=suffix_plotDir, $
   PLOTPREFIX=plotPrefix, $
   PLOTSUFFIX=plotSuffix, $
   ORG_PLOTS_BY_FOLDER=org_plots_by_folder, $
   SAVE_ALF_INDICES=save_alf_indices, $
   TXTOUTPUTDIR=txtOutputDir, $
   SUFFIX_TXTDIR=suffix_txtDir, $
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
   LABELS_FOR_PRESENTATION=labels_for_presentation, $
   TILE_IMAGES=tile_images, $
   N_TILE_ROWS=n_tile_rows, $
   N_TILE_COLUMNS=n_tile_columns, $
   TILING_ORDER=tiling_order, $
   TILE__FAVOR_ROWS=tile__favor_rows, $
   TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
   TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
   TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
   GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
   SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
   ADJ_UPPER_PLOTLIM_IF_NTH_MAX_IS_GREATER=adj_upper_plotlim_thresh, $
   ADJ_LOWER_PLOTLIM_IF_NTH_MIN_IS_GREATER=adj_lower_plotlim_thresh, $
   TILEPLOTSUFF=tilePlotSuff, $
   TILEPLOTTITLE=tilePlotTitle, $
   NO_COLORBAR=no_colorbar, $
   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
   CB_FORCE_OOBLOW=cb_force_oobLow, $
   ;; PLOTH2D_CONTOUR=plotH2D_contour, $
   CONTOUR__LEVELS=contour__levels, $
   CONTOUR__PERCENT=contour__percent, $
   ;; PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
   OVERPLOT_FILE=overplot_file, $
   OVERPLOT_ARR=overplot_arr, $
   OVERPLOT_CONTOUR__LEVELS=op_contour__levels, $
   OVERPLOT_CONTOUR__PERCENT=op_contour__percent, $
   OVERPLOT_PLOTRANGE=op_plotRange, $
   FANCY_PLOTNAMES=fancy_plotNames, $
   ;; SHOW_INTEGRALS=show_integrals, $
   ;; MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
   ;; MAKE_INTEGRAL_SAVFILES=make_integral_savfiles, $
   ;; INTEGRALSAVFILEPREF=integralSavFilePref, $
   OUT_TEMPFILE_LIST=out_tempFile_list, $
   OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
   OUT_PARAMSTRING_LIST=out_paramString_list, $
   USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
   REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_file, $
   OUT_PLOT_I_LIST=out_plot_i_list, $
   OUT_FASTLOC_I_LIST=out_fastLoc_i_list, $
   OUT_I_ESPEC_LIST=out_i_eSpec_list, $
   OUT_I_ION_LIST=out_i_ion_list, $
   ;; RESTORE_LAST_SESSION=restore_last_session, $
   DONT_LOAD_IN_MEMORY=nonMem   ;, $
;   _EXTRA=e
  
 COMPILE_OPT idl2

  !EXCEPT=0                                                      ;Do report errors, please

  @common__maximus_vars.pro
  @common__fastloc_vars.pro
  @common__fastloc_espec_vars.pro
  @common__newell_espec.pro
  @common__newell_ion_db.pro
  @common__pasis_lists.pro
  @common__overplot_vars.pro

  IF KEYWORD_SET(for_eSpec_DBs) AND KEYWORD_SET(for_ion_DBs) THEN BEGIN
     PRINT,"Just do one database at a time. It hurts me and you to do more, after all"
     STOP
  ENDIF

  IF KEYWORD_SET(use_prev_plot_i) THEN BEGIN

     CHECK_PASIS_VARS, $
        INDS_RESET=inds_reset, $
        PLOTS_RESET=plots_reset, $
        DBS_RESET=DBs_reset, $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        IMF_STRUCT=IMF_struct, $
        MIMC_STRUCT=MIMC_struct, $
        GET_PLOT_I=get_plot_i, $
        GET_FASTLOC_I=get_fastLoc_i, $
        GET_ESPEC_I=get_eSpec_i, $
        GET_ION_I=get_ion_i, $
        PLOT_I_LIST=plot_i_list, $
        INDICES__ESPEC_LIST=indices__eSpec_list, $
        INDICES__ION_LIST=indices_ion_list, $
        GET_PARAMSTRING=get_paramString, $
        GET_PARMSTRINGLIST=get_paramString_list, $
        COMPARE_ALFDB_PLOT_STRUCT=compare_alfDB_plot_struct, $
        COMPARE_MIMC_STRUCT=compare_MIMC_struct, $
        COMPARE_IMF_STRUCT=compare_IMF_struct       

  ENDIF ELSE BEGIN
     get_plot_i           = 1
     get_fastLoc_i        = 1
     get_eSpec_i          = 1
     get_paramString      = 1
     get_paramString_list = 1
     ;; get_ion_i      = 1 ;not implemented

     inds_reset           = 1
     DBs_reset            = 1
     plots_reset          = 1
  ENDELSE

  ;;In any case
  PASIS__alfDB_plot_struct = TEMPORARY(alfDB_plot_struct)
  PASIS__IMF_struct        = TEMPORARY(IMF_struct)
  PASIS__MIMC_struct       = TEMPORARY(MIMC_struct)

  PASIS__paramString_list  = PASIS__alfDB_plot_struct.paramString_list
  PASIS__paramString       = PASIS__alfDB_plot_struct.paramString


  ;;See if we can just get 'em from elsewhere
  IF KEYWORD_SET(use_prev_plot_i) THEN BEGIN

     IF LOAD_PASIS_VARS(NEED_FASTLOC_I=need_fastLoc_i, $
                        REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_file, $
                        /VERBOSE) $
     THEN BEGIN
        get_plot_i    = 0
        get_fastLoc_i = 0
        get_eSpec_i   = 0
     ENDIF ELSE BEGIN
        ;; STOP
     ENDELSE
  ENDIF

  get_OMNI_i = (KEYWORD_SET(get_eSpec_i  )            OR $
                KEYWORD_SET(get_fastLoc_i)            OR $
                KEYWORD_SET(get_plot_i)  )            AND $
                ;; KEYWORD_SET(print_avg_IMF_components) OR $
                ;; KEYWORD_SET(save_master_OMNI_inds   ) OR $
                ;; KEYWORD_SET(make_OMNI_stats_savFile )    ) AND $
               ~KEYWORD_SET(PASIS__IMF_struct.do_not_consider_IMF)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Load DBs we need
  IF ~KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) THEN BEGIN



     IF N_ELEMENTS(MAXIMUS__maximus) GT 0 THEN BEGIN
        IF (STRUPCASE(STRMID(MAXIMUS__maximus.info.coords,0,3)) NE       $
            STRUPCASE(STRMID(PASIS__MIMC_struct.coordinate_system,0,3))) $
        THEN BEGIN
           DBs_reset = 1
        ENDIF
     ENDIF 

     IF (N_ELEMENTS(MAXIMUS__maximus) EQ 0) OR $
        KEYWORD_SET(DBs_reset)                 $
     THEN BEGIN
        LOAD_MAXIMUS_AND_CDBTIME, $
           INCLUDE_32HZ=PASIS__alfDB_plot_struct.include_32Hz, $
           DBFile=DBFile, $
           CORRECT_FLUXES=correct_fluxes, $
           DO_NOT_MAP_ESA_CURRENT=do_not_map_esa_current, $
           DO_NOT_MAP_PFLUX=do_not_map_pflux, $
           DO_NOT_MAP_IONFLUX=do_not_map_ionflux, $
           DO_NOT_MAP_HEAVIES=do_not_map_heavies, $
           DO_NOT_MAP_WIDTH_X=do_not_map_width_x, $
           DO_NOT_MAP_WIDTH_T=do_not_map_width_t, $
           DO_NOT_MAP_ANYTHING=no_mapping, $
           CHASTDB=PASIS__alfDB_plot_struct.chastDB, $
           DESPUNDB=PASIS__alfDB_plot_struct.despunDB, $
           COORDINATE_SYSTEM=PASIS__MIMC_struct.coordinate_system, $
           USE_AACGM_COORDS=PASIS__MIMC_struct.use_aacgm, $
           USE_GEO_COORDS=PASIS__MIMC_struct.use_geo, $
           USE_MAG_COORDS=PASIS__MIMC_struct.use_mag, $
           LOAD_DELTA_ILAT_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dILAT, $
           LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dAngle, $
           LOAD_DELTA_X_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dx, $
           USE_SDT_COORDS=use_SDT, $
           USING_HEAVIES=using_heavies, $
           FORCE_LOAD_MAXIMUS=force_load_maximus, $
           FORCE_LOAD_CDBTIME=force_load_cdbTime, $
           FORCE_LOAD_BOTH=KEYWORD_SET(force_load_both) OR KEYWORD_SET(DBs_reset), $
           QUIET=quiet, $
           CLEAR_MEMORY=clear_memory, $
           NO_MEMORY_LOAD=noMem, $
           LUN=lun
     ENDIF

     ;;Maximus pointers
     pAlfDB = PTR_NEW(MAXIMUS__maximus)
     pAlfT  = PTR_NEW(MAXIMUS__times  )

  ENDIF

  IF KEYWORD_SET(need_fastLoc_i) THEN BEGIN

     fl_elOrIon = KEYWORD_SET(for_eSpec_DBs) OR KEYWORD_SET(for_ion_DBs)

     IF N_ELEMENTS((KEYWORD_SET(fl_elOrIon) ? FL_eSpec__fastLoc : FL__fastLoc)) GT 0 THEN BEGIN
        IF (STRUPCASE(STRMID((KEYWORD_SET(fl_elOrIon) ? FL_eSpec__fastLoc : FL__fastLoc).info.coords,0,3)) NE $
            STRUPCASE(STRMID(PASIS__MIMC_struct.coordinate_system,0,3))) $
        THEN BEGIN
           DBs_reset = 1
        ENDIF
     ENDIF 

     IF ( KEYWORD_SET(fl_elOrIon) AND (N_ELEMENTS(FL_eSpec__fastLoc) EQ 0)) OR $
        (~KEYWORD_SET(fl_elOrIon) AND (N_ELEMENTS(FL__fastLoc      ) EQ 0)) OR $
        KEYWORD_SET(DBs_reset)                                                    $
     THEN BEGIN
        LOAD_FASTLOC_AND_FASTLOC_TIMES, $
           FORCE_LOAD_FASTLOC=force_load_fastLoc, $
           FORCE_LOAD_TIMES=force_load_times, $
           FORCE_LOAD_ALL=KEYWORD_SET(force_load_all) OR KEYWORD_SET(DBs_reset), $
           INCLUDE_32Hz=PASIS__alfDB_plot_struct.include_32Hz, $
           COORDINATE_SYSTEM=coordinate_system, $
           USE_AACGM_COORDS=PASIS__MIMC_struct.use_aacgm, $
           USE_GEO_COORDS=PASIS__MIMC_struct.use_geo, $
           USE_MAG_COORDS=PASIS__MIMC_struct.use_mag, $
           FOR_ESPEC_DBS=fl_elOrIon, $
           ;; CHECK_DB=check_DB, $
           JUST_FASTLOC=just_fastLoc, $
           JUST_TIMES=just_times, $
           LOAD_DELTA_ILAT_NOT_DELTA_T=PASIS__alfDB_plot_struct.load_dILAT, $
           LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=PASIS__ALFDB_PLOT_struct.load_dAngle, $
           LOAD_DELTA_X_FOR_WIDTH_TIME=PASIS__ALFDB_PLOT_struct.load_dx, $
           DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
           NO_MEMORY_LOAD=noMem, $
           CLEAR_MEMORY=clear_memory, $
           LUN=lun     

     ENDIF
  ENDIF 

  IF (KEYWORD_SET(PASIS__alfDB_plot_struct.eNumFlPlots)                      OR $
      KEYWORD_SET(PASIS__alfDB_plot_struct.ePlots)                            OR $ 
      KEYWORD_SET(PASIS__alfDB_plot_struct.eSpec__newellPlot_probOccurrence)) AND $
     KEYWORD_SET(PASIS__alfDB_plot_struct.for_eSpec_DBs) $
  THEN BEGIN

     other_guys = PASIS__alfDB_plot_struct.load_dILAT OR PASIS__alfDB_plot_struct.load_dAngle OR PASIS__alfDB_plot_struct.load_dx
     LOAD_NEWELL_ESPEC_DB, $
        UPGOING=PASIS__alfDB_plot_struct.eSpec__upgoing, $
        DONT_CONVERT_TO_STRICT_NEWELL=~KEYWORD_SET(PASIS__alfDB_plot_struct.eSpec__Newell_2009_interp), $
        USE_2000KM_FILE=PASIS__alfDB_plot_struct.eSpec__use_2000km_file, $
        DONT_MAP_TO_100KM=PASIS__alfDB_plot_struct.eSpec__noMap, $
        LOAD_DELTA_T=( (KEYWORD_SET(PASIS__alfDB_plot_struct.do_timeAvg_fluxQuantities) OR $
                        KEYWORD_SET(PASIS__alfDB_plot_struct.t_probOccurrence) $
                       ) $
                       AND ~other_guys), $
        LOAD_DELTA_ILAT_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dILAT, $
        LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dAngle, $
        LOAD_DELTA_X_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dx, $
        FORCE_LOAD_DB=KEYWORD_SET(DBs_reset)

     eSpec_info = NEWELL__eSpec.info

  ENDIF

  IF KEYWORD_SET(PASIS__alfDB_plot_struct.ionPlots   ) AND $
     KEYWORD_SET(PASIS__alfDB_plot_struct.for_ion_DBs) $
  THEN BEGIN

     other_guys = PASIS__alfDB_plot_struct.load_dILAT OR PASIS__alfDB_plot_struct.load_dAngle OR PASIS__alfDB_plot_struct.load_dx
     LOAD_NEWELL_ION_DB, $
        DOWNGOING=PASIS__alfDB_plot_struct.ion__downgoing, $
        DONT_MAP_TO_100KM=PASIS__alfDB_plot_struct.ion__noMap, $
        LOAD_DELTA_T=( (KEYWORD_SET(PASIS__alfDB_plot_struct.do_timeAvg_fluxQuantities) OR $
                        KEYWORD_SET(PASIS__alfDB_plot_struct.t_probOccurrence) $
                       ) $
                       AND ~other_guys), $
        LOAD_DELTA_ILAT_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dILAT, $
        LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dAngle, $
        LOAD_DELTA_X_FOR_WIDTH_TIME=PASIS__alfDB_plot_struct.load_dx, $
        FORCE_LOAD_DB=KEYWORD_SET(DBs_reset)

     ion_info = NEWELL_I__ion.info

  ENDIF

  ;;Handle hemisphere issues up front if we're doing equal-area binning
  IF KEYWORD_SET(PASIS__alfDB_plot_struct.EA_binning) THEN BEGIN
     LOAD_EQUAL_AREA_BINNING_STRUCT,EA, $
                                    HEMI=PASIS__MIMC_struct.hemi, $
                                    FORCE_LOAD=KEYWORD_SET(DBs_reset)
  ENDIF

  IF KEYWORD_SET(PASIS__IMF_struct.do_not_consider_IMF) THEN BEGIN
     IF ~KEYWORD_SET(plotDir) THEN $
        SET_PLOT_DIR, $
        plotDir, $
        FOR_ALFVENDB=~(KEYWORD_SET(PASIS__alfDB_plot_struct.use_storm_stuff) OR KEYWORD_SET(PASIS__alfDB_plot_struct.AE_stuff)), $
        FOR_STORMS=(KEYWORD_SET(PASIS__alfDB_plot_struct.use_storm_stuff) OR KEYWORD_SET(PASIS__alfDB_plot_struct.AE_stuff)), $
        /ADD_TODAY, $
        ADD_SUFF=suffix_plotDir
     IF ~KEYWORD_SET(txtOutputDir) THEN $
        SET_TXTOUTPUT_DIR, $
        txtOutputDir, $
        FOR_ALFVENDB=~(KEYWORD_SET(PASIS__alfDB_plot_struct.use_storm_stuff) OR KEYWORD_SET(PASIS__alfDB_plot_struct.AE_stuff)), $
        FOR_STORMS=(   KEYWORD_SET(PASIS__alfDB_plot_struct.use_storm_stuff)    OR KEYWORD_SET(PASIS__alfDB_plot_struct.AE_stuff)), $
        /ADD_TODAY, $
        ADD_SUFF=suffix_txtDir
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(plotDir) THEN $
        SET_PLOT_DIR, $
        plotDir, $
        /FOR_SW_IMF, $
        /ADD_TODAY, $
        ADD_SUFF=suffix_plotDir
     IF ~KEYWORD_SET(txtOutputDir) THEN $
        SET_TXTOUTPUT_DIR, $
        txtOutputDir, $
        /FOR_SW_IMF, $
        /ADD_TODAY, $
        ADD_SUFF=suffix_txtDir
  ENDELSE


  ;;Does it all "hang together"?
  IF PASIS__alfDB_plot_struct.use_storm_stuff GT 1 THEN BEGIN
     PRINT,"Can't set more than one of the storm keywords simultaneously!"
     STOP
  ENDIF
  IF PASIS__alfDB_plot_struct.ae_stuff GT 1 THEN BEGIN
     PRINT,"only select one of (AE,AU,AL,AO)!"
     STOP
  ENDIF
  IF PASIS__alfDB_plot_struct.ae_stuff AND PASIS__alfDB_plot_struct.use_storm_stuff THEN BEGIN
     PRINT,"Currently not possible to use AE stuff together with storm stuff!"
     STOP
  ENDIF

  too_many = KEYWORD_SET(PASIS__alfDB_plot_struct.multiple_delays) + $
             KEYWORD_SET(PASIS__alfDB_plot_struct.multiple_IMF_clockAngles) + $
             KEYWORD_SET((TAG_EXIST(PASIS__alfDB_plot_struct,'storm_opt')   ? $
                          PASIS__alfDB_plot_struct.storm_opt.all_storm_phases  : $
                          0)                                         )  + $
             KEYWORD_SET((TAG_EXIST(PASIS__alfDB_plot_struct,'ae_opt') ?    $
                          PASIS__alfDB_plot_struct.AE_opt.AE_both      :    $
                          0)                                         )
  IF too_many GT 1 THEN BEGIN
     PRINT,"Not set up to handle multiples of several conditions right now! Sorry. You'll find trouble in GET_RESTRICTED_AND_INTERPED_DB_INDICES if you attempt this..."
     STOP
  ENDIF

  ;;Open file for text summary, if desired
  IF KEYWORD_SET(PASIS__alfDB_plot_struct.outputPlotSummary) THEN BEGIN
     OPENW,lun,txtOutputDir + 'outputSummary_'+paramString+'.txt',/GET_LUN 
     IF KEYWORD_SET(PASIS__alfDB_plot_struct.executing_multiples) THEN BEGIN
        PRINT,"What are you thinking? You're not setup to get multi-output..."
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     lun=-1                     ;-1 is lun for STDOUT
  ENDELSE
  
  ;;********************************************************
  ;;Now clean and tap the databases and interpolate satellite data

  IF KEYWORD_SET(PASIS__alfDB_plot_struct.use_storm_stuff) THEN BEGIN

     IF ~KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) AND KEYWORD_SET(get_plot_i) $
     THEN BEGIN
        GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           IMF_STRUCT=PASIS__IMF_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           ;; DSTCUTOFF=dstCutoff, $
           ;; SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
           NONSTORM_I=ns_i, $
           MAINPHASE_I=mp_i, $
           RECOVERYPHASE_I=rp_i, $
           STORM_DST_I=s_dst_i, $
           NONSTORM_DST_I=ns_dst_i, $
           MAINPHASE_DST_I=mp_dst_i, $
           RECOVERYPHASE_DST_I=rp_dst_i, $
           N_STORM=n_s, $
           N_NONSTORM=n_ns, $
           N_MAINPHASE=n_mp, $
           N_RECOVERYPHASE=n_rp, $
           NONSTORM_T1=ns_t1,MAINPHASE_T1=mp_t1,RECOVERYPHASE_T1=rp_t1, $
           NONSTORM_T2=ns_t2,MAINPHASE_T2=mp_t2,RECOVERYPHASE_T2=rp_t2
        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.nonStorm): BEGIN
              PRINTF,lun,'Restricting maximus with non-storm indices ...'
              restrict_with_these_i = ns_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.mainPhase): BEGIN
              PRINTF,lun,'Restricting maximus with main-phase indices ...'
              restrict_with_these_i = mp_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.recoveryPhase): BEGIN
              PRINTF,lun,'Restricting maximus with recovery-phase indices ...'
              restrict_with_these_i = rp_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.all_storm_phases): BEGIN
              PRINTF,lun,'Restricting maximus with each storm phase in turn ...'
              restrict_with_these_i = LIST(ns_i,mp_i,rp_i)
           END
        ENDCASE
     ENDIF

     ;;Now OMNI, if desired
     IF KEYWORD_SET(get_OMNI_i) THEN BEGIN
        GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_OMNIDB_INDICES, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           IMF_STRUCT=PASIS__IMF_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           ;; DSTCUTOFF=dstCutoff, $
           ;; SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
           EARLIEST_UTC=PASIS__IMF_struct.earliest_UTC, $
           LATEST_UTC=PASIS__IMF_struct.latest_UTC, $
           USE_JULDAY_NOT_UTC=PASIS__IMF_struct.use_julDay_not_UTC, $
           EARLIEST_JULDAY=PASIS__IMF_struct.earliest_julDay, $
           LATEST_JULDAY=PASIS__IMF_struct.latest_julDay, $
           NONSTORM_I=ns_OMNI_i, $
           MAINPHASE_I=mp_OMNI_i, $
           RECOVERYPHASE_I=rp_OMNI_i, $
           STORM_DST_I=s_dst_OMNI_i, $
           NONSTORM_DST_I=ns_dst_OMNI_i, $
           MAINPHASE_DST_I=mp_dst_OMNI_i, $
           RECOVERYPHASE_DST_I=rp_dst_OMNI_i, $
           N_STORM=n_OMNI_s, $
           N_NONSTORM=n_OMNI_ns, $
           N_MAINPHASE=n_OMNI_mp, $
           N_RECOVERYPHASE=n_OMNI_rp, $
           NONSTORM_T1=ns_OMNI_t1,MAINPHASE_T1=mp_OMNI_t1,RECOVERYPHASE_T1=rp_OMNI_t1, $
           NONSTORM_T2=ns_OMNI_t2,MAINPHASE_T2=mp_OMNI_t2,RECOVERYPHASE_T2=rp_OMNI_t2

        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.nonStorm): BEGIN
              PRINTF,lun,'Restricting OMNI with non-storm indices ...'
              restrict_OMNI_with_these_i = ns_OMNI_i
              t1_OMNI_arr                = ns_OMNI_t1
              t2_OMNI_arr                = ns_OMNI_t2
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.mainPhase): BEGIN
              PRINTF,lun,'Restricting OMNI with main-phase indices ...'
              restrict_OMNI_with_these_i = mp_OMNI_i
              t1_OMNI_arr                = mp_OMNI_t1
              t2_OMNI_arr                = mp_OMNI_t2         
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.recoveryPhase): BEGIN
              PRINTF,lun,'Restricting OMNI with recovery-phase indices ...'
              restrict_OMNI_with_these_i = rp_OMNI_i
              t1_OMNI_arr                = rp_OMNI_t1
              t2_OMNI_arr                = rp_OMNI_t2
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.all_storm_phases): BEGIN
              PRINTF,lun,'Restricting OMNI with each storm phase in turn ...'
              restrict_OMNI_with_these_i = LIST(ns_OMNI_i,mp_OMNI_i,rp_OMNI_i)
           END
        ENDCASE

     ENDIF

     ;;Now fastLoc
     IF KEYWORD_SET(need_fastLoc_i) $
        AND KEYWORD_SET(get_fastLoc_i) $
     THEN BEGIN 

        GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           IMF_STRUCT=PASIS__IMF_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           /GET_TIME_I_NOT_ALFDB_I, $
           ;; DSTCUTOFF=dstCutoff, $
           ;; SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
           NONSTORM_I=ns_FL_i, $
           MAINPHASE_I=mp_FL_i, $
           RECOVERYPHASE_I=rp_FL_i, $
           STORM_DST_I=s_dst_FL_i, $
           NONSTORM_DST_I=ns_dst_FL_i, $
           MAINPHASE_DST_I=mp_dst_FL_i, $
           RECOVERYPHASE_DST_I=rp_dst_FL_i, $
           N_STORM=n_FL_s, $
           N_NONSTORM=n_FL_ns, $
           N_MAINPHASE=n_FL_mp, $
           N_RECOVERYPHASE=n_FL_rp, $
           NONSTORM_T1=ns_t1,MAINPHASE_T1=mp_t1,RECOVERYPHASE_T1=rp_t1, $
           NONSTORM_T2=ns_t2,MAINPHASE_T2=mp_t2,RECOVERYPHASE_T2=rp_t2, $
           GET_TIME_FOR_ESPEC_DBS=fl_elOrIon
        
        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.nonStorm): BEGIN
              PRINTF,lun,'Restricting fastLoc with non-storm indices ...'
              restrict_with_these_FL_i = ns_FL_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.mainPhase): BEGIN
              PRINTF,lun,'Restricting fastLoc with main-phase indices ...'
              restrict_with_these_FL_i = mp_FL_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.recoveryPhase): BEGIN
              PRINTF,lun,'Restricting fastLoc with recovery-phase indices ...'
              restrict_with_these_FL_i = rp_FL_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.all_storm_phases): BEGIN
              PRINTF,lun,'Restricting fastLoc with each storm phase in turn ...'
              restrict_with_these_FL_i = LIST(ns_FL_i,mp_FL_i,rp_FL_i)
           END
        ENDCASE

     ENDIF

     ;;Now eSpecDB
     IF PASIS__alfDB_plot_struct.for_eSpec_DBs AND KEYWORD_SET(get_eSpec_i) $
     THEN BEGIN 

        GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           IMF_STRUCT=PASIS__IMF_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           /GET_ESPECDB_I_NOT_ALFDB_I, $
           ;; DSTCUTOFF=dstCutoff, $
           ;; SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
           NONSTORM_I=ns_eSpec_i, $
           MAINPHASE_I=mp_eSpec_i, $
           RECOVERYPHASE_I=rp_eSpec_i, $
           STORM_DST_I=s_dst_eSpec_i, $
           NONSTORM_DST_I=ns_dst_eSpec_i, $
           MAINPHASE_DST_I=mp_dst_eSpec_i, $
           RECOVERYPHASE_DST_I=rp_dst_eSpec_i, $
           N_STORM=n_eSpec_s, $
           N_NONSTORM=n_eSpec_ns, $
           N_MAINPHASE=n_eSpec_mp, $
           N_RECOVERYPHASE=n_eSpec_rp, $
           NONSTORM_T1=ns_t1,MAINPHASE_T1=mp_t1,RECOVERYPHASE_T1=rp_t1, $
           NONSTORM_T2=ns_t2,MAINPHASE_T2=mp_t2,RECOVERYPHASE_T2=rp_t2
        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.nonStorm): BEGIN
              restrict_with_these_eSpec_i = ns_eSpec_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.mainPhase): BEGIN
              restrict_with_these_eSpec_i = mp_eSpec_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.recoveryPhase): BEGIN
              restrict_with_these_eSpec_i = rp_eSpec_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.all_storm_phases): BEGIN
              PRINTF,lun,'Restricting eSpec with each storm phase in turn ...'
              restrict_with_these_eSpec_i = LIST(ns_eSpec_i,mp_eSpec_i,rp_eSpec_i)
           END
        ENDCASE


     ENDIF

     IF PASIS__alfDB_plot_struct.for_ion_DBs AND KEYWORD_SET(get_ion_i) $
     THEN BEGIN 

        GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           IMF_STRUCT=PASIS__IMF_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           /GET_IONDB_I_NOT_ALFDB_I, $
           ;; DSTCUTOFF=dstCutoff, $
           ;; SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
           NONSTORM_I=ns_ion_i, $
           MAINPHASE_I=mp_ion_i, $
           RECOVERYPHASE_I=rp_ion_i, $
           STORM_DST_I=s_dst_ion_i, $
           NONSTORM_DST_I=ns_dst_ion_i, $
           MAINPHASE_DST_I=mp_dst_ion_i, $
           RECOVERYPHASE_DST_I=rp_dst_ion_i, $
           N_STORM=n_ion_s, $
           N_NONSTORM=n_ion_ns, $
           N_MAINPHASE=n_ion_mp, $
           N_RECOVERYPHASE=n_ion_rp, $
           NONSTORM_T1=ns_t1,MAINPHASE_T1=mp_t1,RECOVERYPHASE_T1=rp_t1, $
           NONSTORM_T2=ns_t2,MAINPHASE_T2=mp_t2,RECOVERYPHASE_T2=rp_t2
        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.nonStorm): BEGIN
              restrict_with_these_ion_i = ns_ion_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.mainPhase): BEGIN
              restrict_with_these_ion_i = mp_ion_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.recoveryPhase): BEGIN
              restrict_with_these_ion_i = rp_ion_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.storm_opt.all_storm_phases): BEGIN
              PRINTF,lun,'Restricting ionDB with each storm phase in turn ...'
              restrict_with_these_ion_i = LIST(ns_ion_i,mp_ion_i,rp_ion_i)
           END
        ENDCASE


     ENDIF

  ENDIF

  IF KEYWORD_SET(PASIS__alfDB_plot_struct.ae_stuff) THEN BEGIN

     IF ~(KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) OR KEYWORD_SET(PASIS__alfDB_plot_struct.ion__no_maximus)) THEN BEGIN
        GET_AE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           IMF_STRUCT=PASIS__IMF_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           GET_TIME_I_NOT_ALFDB_I=get_time_i_not_alfDB_I, $
           COORDINATE_SYSTEM=coordinate_system, $
           ;; AECUTOFF=AEcutoff, $
           ;; SMOOTH_AE=smooth_AE, $
           ;; USE_AU=use_au, $
           ;; USE_AL=use_al, $
           ;; USE_AO=use_ao, $
           HIGH_AE_I=high_ae_i, $
           LOW_AE_I=low_ae_i, $
           HIGH_I=high_i, $
           LOW_I=low_i, $
           N_HIGH=n_high, $
           N_LOW=n_low, $
           OUT_NAME=navn, $
           HIGH_AE_T1=high_ae_t1, $
           LOW_AE_T1=low_ae_t1, $
           HIGH_AE_T2=high_ae_t2, $
           LOW_AE_T2=low_ae_t2

        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_high): BEGIN
              PRINTF,lun,'Restricting maximus with high ' + navn + ' indices ...'
              restrict_with_these_i = high_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_low): BEGIN
              PRINTF,lun,'Restricting maximus with low ' + navn + ' indices ...'
              restrict_with_these_i = low_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_both): BEGIN
              PRINTF,lun,'Restricting maximus with low and high ' + navn + ' indices in turn ...'
              restrict_with_these_i = LIST(high_i,low_i)
           END
        ENDCASE
     ENDIF

     IF KEYWORD_SET(get_OMNI_i) THEN BEGIN

        ;;Now OMNI, if we need dat
        GET_AE_OMNIDB_INDICES, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           IMF_STRUCT=PASIS__IMF_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           ;; AECUTOFF=AEcutoff, $
           ;; SMOOTH_AE=smooth_AE, $
           ;; USE_AU=use_au, $
           ;; USE_AL=use_al, $
           ;; USE_AO=use_ao, $
           HIGH_AE_I=high_ae_i, $
           LOW_AE_I=low_ae_i, $
           HIGH_I=high_OMNI_i, $
           LOW_I=low_OMNI_i, $
           N_HIGH=n_high, $
           N_LOW=n_low, $
           OUT_NAME=navn, $
           HIGH_AE_T1=high_ae_t1, $
           LOW_AE_T1=low_ae_t1, $
           HIGH_AE_T2=high_ae_t2, $
           LOW_AE_T2=low_ae_t2, $
           LUN=lun


        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_high): BEGIN
              PRINTF,lun,'Restricting OMNI with high ' + navn + ' indices ...'
              restrict_OMNI_with_these_i = high_OMNI_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_low): BEGIN
              PRINTF,lun,'Restricting OMNI with low ' + navn + ' indices ...'
              restrict_OMNI_with_these_i = low_OMNI_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_both): BEGIN
              PRINTF,lun,'Restricting OMNI with low and high ' + navn + ' indices in turn ...'
              restrict_OMNI_with_these_i = LIST(high_OMNI_i,low_OMNI_i)
           END
        ENDCASE

     ENDIF

     ;;Now fastLoc
     IF KEYWORD_SET(need_fastLoc_i) AND $
        KEYWORD_SET(get_fastLoc_i) $
     THEN BEGIN

        GET_AE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
           IMF_STRUCT=IMF_struct, $
           MIMC_STRUCT=MIMC_struct, $
           /GET_TIME_I_NOT_ALFDB_I, $
           COORDINATE_SYSTEM=coordinate_system, $
           ;; AECUTOFF=AEcutoff, $
           ;; SMOOTH_AE=smooth_AE, $
           ;; USE_AU=use_au, $
           ;; USE_AL=use_al, $
           ;; USE_AO=use_ao, $
           HIGH_AE_I=high_ae_i, $
           LOW_AE_I=low_ae_i, $
           HIGH_I=high_FL_i, $
           LOW_I=low_FL_i, $
           N_HIGH=n_FL_high, $
           N_LOW=n_FL_low, $
           OUT_NAME=navn, $
           HIGH_AE_T1=high_ae_t1, $
           LOW_AE_T1=low_ae_t1, $
           HIGH_AE_T2=high_ae_t2, $
           LOW_AE_T2=low_ae_t2, $
           GET_TIME_FOR_ESPEC_DBS=fl_elOrIon
        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_high): BEGIN
              PRINTF,lun,'Restricting fastLoc with high ' + navn + ' indices ...'
              restrict_with_these_FL_i = high_FL_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_low): BEGIN
              PRINTF,lun,'Restricting fastLoc with low ' + navn + ' indices ...'
              restrict_with_these_FL_i = low_FL_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_both): BEGIN
              PRINTF,lun,'Restricting fastLoc with low and high ' + navn + ' indices in turn ...'
              restrict_with_these_i = LIST(high_FL_i,low_FL_i)
           END
        ENDCASE

     ENDIF

     ;;Now eSpecDB
     IF for_eSpec_DBs AND KEYWORD_SET(get_eSpec_i) $
     THEN BEGIN 

        GET_AE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
           IMF_STRUCT=IMF_struct, $
           MIMC_STRUCT=MIMC_struct, $
           /GET_ESPECDB_I_NOT_ALFDB_I, $
           COORDINATE_SYSTEM=coordinate_system, $
           ;; AECUTOFF=AEcutoff, $
           ;; SMOOTH_AE=smooth_AE, $
           USE_AU=use_au, $
           USE_AL=use_al, $
           USE_AO=use_ao, $
           HIGH_AE_I=high_ae_i, $
           LOW_AE_I=low_ae_i, $
           HIGH_I=high_eSpec_i, $
           LOW_I=low_eSpec_i, $
           N_HIGH=n_eSpec_high, $
           N_LOW=n_eSpec_low, $
           OUT_NAME=navn, $
           HIGH_AE_T1=high_ae_t1, $
           LOW_AE_T1=low_ae_t1, $
           HIGH_AE_T2=high_ae_t2, $
           LOW_AE_T2=low_ae_t2
        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_high): BEGIN
              PRINTF,lun,'Restricting eSpec with high ' + navn + ' indices ...'
              restrict_with_these_eSpec_i = high_eSpec_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_low): BEGIN
              PRINTF,lun,'Restricting eSpec with low ' + navn + ' indices ...'
              restrict_with_these_eSpec_i = low_eSpec_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_both): BEGIN
              PRINTF,lun,'Restricting eSpec with low and high ' + navn + ' indices in turn ...'
              restrict_with_these_i = LIST(high_eSpec_i,low_eSpec_i)
           END
        ENDCASE

     ENDIF

     ;;Now eSpecDB
     IF for_ion_DBs AND KEYWORD_SET(get_ion_i) $
     THEN BEGIN 

        GET_AE_FASTDB_INDICES, $
           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
           IMF_STRUCT=IMF_struct, $
           MIMC_STRUCT=MIMC_struct, $
           /GET_IONDB_I_NOT_ALFDB_I, $
           COORDINATE_SYSTEM=coordinate_system, $
           ;; AECUTOFF=AEcutoff, $
           ;; SMOOTH_AE=smooth_AE, $
           USE_AU=use_au, $
           USE_AL=use_al, $
           USE_AO=use_ao, $
           HIGH_AE_I=high_ae_i, $
           LOW_AE_I=low_ae_i, $
           HIGH_I=high_ion_i, $
           LOW_I=low_ion_i, $
           N_HIGH=n_ion_high, $
           N_LOW=n_ion_low, $
           OUT_NAME=navn, $
           HIGH_AE_T1=high_ae_t1, $
           LOW_AE_T1=low_ae_t1, $
           HIGH_AE_T2=high_ae_t2, $
           LOW_AE_T2=low_ae_t2
        
        CASE 1 OF
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_high): BEGIN
              PRINTF,lun,'Restricting ionDB with high ' + navn + ' indices ...'
              restrict_with_these_ion_i = high_ion_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_low): BEGIN
              PRINTF,lun,'Restricting ionDB with low ' + navn + ' indices ...'
              restrict_with_these_ion_i = low_ion_i
           END
           KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_both): BEGIN
              PRINTF,lun,'Restricting ionDB with low and high ' + navn + ' indices in turn ...'
              restrict_with_these_i = LIST(high_ion_i,low_ion_i)
           END
        ENDCASE

     ENDIF

     CASE 1 OF
        KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_high): BEGIN
           t1_arr                = high_ae_t1
           t2_arr                = high_ae_t2
        END
        KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_low): BEGIN
           t1_arr                = low_ae_t1
           t2_arr                = low_ae_t2
        END
        KEYWORD_SET(PASIS__alfDB_plot_struct.ae_opt.AE_both): BEGIN
           t1_arr                = LIST(high_ae_t1,low_ae_t1)
           t2_arr                = LIST(high_ae_t2,low_ae_t2)
        END
     ENDCASE

  ENDIF

  IF ~KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) THEN BEGIN
     
     IF KEYWORD_SET(get_plot_i) THEN BEGIN
        plot_i_list  = GET_RESTRICTED_AND_INTERPED_DB_INDICES( $
                       MAXIMUS__maximus, $
                       DBTIMES=MAXIMUS__times, $
                       DBFILE=dbfile, $
                       LUN=lun, $
                       ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
                       IMF_STRUCT=PASIS__IMF_struct, $
                       MIMC_STRUCT=PASIS__MIMC_struct, $
                       RESET_OMNI_INDS=KEYWORD_SET(reset_omni_inds) OR KEYWORD_SET(inds_reset), $
                       RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                       RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                       /DO_NOT_SET_DEFAULTS, $
                       PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                       PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                       PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                       SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                       MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
                       OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
                       CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                       RESET_GOOD_INDS=KEYWORD_SET(reset_good_inds) OR KEYWORD_SET(inds_reset), $
                       NO_BURSTDATA=no_burstData, $
                       DONT_LOAD_IN_MEMORY=KEYWORD_SET(PASIS__alfDB_plot_struct.eSpec_flux_plots) OR KEYWORD_SET(nonMem), $
                       TXTOUTPUTDIR=txtOutputDir)

        ;;These can be reloaded, if we like
        PASIS__plot_i_list = TEMPORARY(plot_i_list)
     ENDIF

  ENDIF                    
  
  IF KEYWORD_SET(need_fastLoc_i) THEN BEGIN

     IF KEYWORD_SET(get_fastLoc_i) THEN BEGIN

        fastLocInterped_i_list    = GET_RESTRICTED_AND_INTERPED_DB_INDICES( $
                                    KEYWORD_SET(fl_elOrIon) ? FL_eSpec__fastLoc : FL__fastLoc, $
                                    LUN=lun, $
                                    DBTIMES=KEYWORD_SET(fl_elOrIon) ? FASTLOC_E__times : FASTLOC__times, $
                                    DBFILE=KEYWORD_SET(fl_elOrIon) ? FASTLOC_E__dbFile : FASTLOC__dbFile, $
                                    ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
                                    IMF_STRUCT=PASIS__IMF_struct, $
                                    MIMC_STRUCT=PASIS__MIMC_struct, $
                                    RESET_OMNI_INDS=KEYWORD_SET(reset_omni_inds) OR KEYWORD_SET(inds_reset), $
                                    RESTRICT_WITH_THESE_I=restrict_with_these_FL_i, $
                                    RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                                    /DO_NOT_SET_DEFAULTS, $
                                    ;;Don't do these for fastLoc, since it amounts to duplicated
                                    ;;effort
                                    ;; PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                                    ;; PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                                    ;; PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                                    ;; SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                                    ;; CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                                    RESET_GOOD_INDS=KEYWORD_SET(reset_good_inds) OR KEYWORD_SET(inds_reset), $
                                    NO_BURSTDATA=no_burstData, $
                                    /GET_TIME_I_NOT_ALFVENDB_I, $
                                    GET_TIME_FOR_ESPEC_DBS=KEYWORD_SET(fl_elOrIon), $
                                    DONT_LOAD_IN_MEMORY=KEYWORD_SET(PASIS__alfDB_plot_struct.eSpec_flux_plots) OR KEYWORD_SET(nonMem))

        ;;These can be reloaded, if we like
        PASIS__fastLocInterped_i_list = TEMPORARY(fastLocInterped_i_list)

     ENDIF

  ENDIF

  IF (KEYWORD_SET(PASIS__alfDB_plot_struct.for_eSpec_DBs) OR KEYWORD_SET(PASIS__alfDB_plot_struct.for_ion_DBs)) THEN BEGIN

     IF (KEYWORD_SET(get_eSpec_i) AND KEYWORD_SET(PASIS__alfDB_plot_struct.for_eSpec_DBs)) OR $
        (KEYWORD_SET(get_ion_i  ) AND KEYWORD_SET(PASIS__alfDB_plot_struct.for_ion_DBs  ))    $
     THEN BEGIN

        GET_ESPEC_FLUX_DATA,plot_i_list, $
                            /FOR_IMF_SCREENING, $
                            ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
                            IMF_STRUCT=PASIS__IMF_struct, $
                            MIMC_STRUCT=PASIS__MIMC_struct, $
                            DBS_RESET=DBs_reset, $
                            T1_ARR=t1_arr,T2_ARR=t2_arr, $
                            ;; ESPEC_DELTA_T=eSpec_delta_t, $
                            ;; ION_DELTA_T=ion_delta_t, $
                            OUT_EFLUX_DATA=eFlux_eSpec_data, $
                            OUT_ENUMFLUX_DATA=eNumFlux_eSpec_data, $
                            OUT_IFLUX_DATA=iFlux_eSpec_data, $
                            OUT_INUMFLUX_DATA=iNumFlux_ion_data, $
                            INDICES__ESPEC=indices__eSpec_list, $
                            INDICES__ION=indices__ion_list, $
                            ESPEC__MLTS=eSpec__mlts, $
                            ESPEC__ILATS=eSpec__ilats, $
                            ESPEC__INFO=eSpec_info, $
                            ION__MLTS=ion__mlts, $
                            ION__ILATS=ion__ilats, $
                            ION__INFO=ion_info, $
                            CHARIERANGE=charIERange, $
                            RESET_OMNI_INDS=KEYWORD_SET(reset_omni_inds) OR KEYWORD_SET(inds_reset), $
                            RESTRICT_WITH_THESE_ESPEC_I=restrict_with_these_eSpec_i, $
                            RESTRICT_WITH_THESE_ION_I=restrict_with_these_ion_i, $
                            /DO_NOT_SET_DEFAULTS, $
                            RESET_GOOD_INDS=KEYWORD_SET(reset_good_inds) OR KEYWORD_SET(inds_reset), $
                            DONT_LOAD_IN_MEMORY=KEYWORD_SET(do_timeAvg_fluxQuantities) OR $
                            KEYWORD_SET(nonMem)

        IF KEYWORD_SET(indices__eSpec_list) THEN BEGIN
           PASIS__eFlux_eSpec_data     = KEYWORD_SET(eFlux_eSpec_data)
           PASIS__eNumFlux_eSpec_data  = KEYWORD_SET(eNumFlux_eSpec_data)
           ;; PASIS__eSpec_delta_t        = KEYWORD_SET(eSpec_delta_t) ? $
           ;;                               TEMPORARY(eSpec_delta_t) : !NULL
           PASIS__eSpec__MLTs          = KEYWORD_SET(eSpec__MLTs)
           PASIS__eSpec__ILATs         = KEYWORD_SET(eSpec__ILATs)
           PASIS__indices__eSpec_list  = TEMPORARY(indices__eSpec_list)
        ENDIF

        IF KEYWORD_SET(indices__ion_list) THEN BEGIN
           PASIS__iFlux_ion_data       = KEYWORD_SET(iFlux_ion_data)
           PASIS__iNumFlux_ion_data    = KEYWORD_SET(iNumFlux_ion_data)
           ;; PASIS__ion_delta_t          = KEYWORD_SET(ion_delta_t) ? $
           ;;                               TEMPORARY(ion_delta_t) : !NULL
           PASIS__ion__MLTs            = KEYWORD_SET(ion__MLTs)
           PASIS__ion__ILATs           = KEYWORD_SET(ion__ILATs)
           PASIS__indices__ion_list    = TEMPORARY(indices__ion_list)
        ENDIF
     ENDIF

  ENDIF

  ;;Save in any case?
  ;; IF KEYWORD_SET(use_prev_plot_i) THEN BEGIN
  SAVE_PASIS_VARS,NEED_FASTLOC_I=need_fastLoc_i, $
                  /VERBOSE
  ;; ENDIF

  ;;Leave early if we yust (yust) need indices
  IF KEYWORD_SET(PASIS__alfDB_plot_struct.justInds) THEN BEGIN
     PRINT,'PLOT_ALFVEN_STATS_IMF_SCREENING: Finished! Returning indices ...'

     out_paramString_list        = PASIS__paramString_list
     saveStr = 'SAVE,out_paramString_list,'

     indsInfoStr = 'indsInfo'
     infoStr     = indsInfoStr + ' = CREATE_STRUCT('
     nInfo       = 0

     IF N_ELEMENTS(PASIS__plot_i_list) GT 0 THEN BEGIN
        out_plot_i_list             = PASIS__plot_i_list
        saveStr += 'out_plot_i_list,'
        nInfo++
        infoStr += '"alfDB",MAXIMUS__maximus.info'
     ENDIF

     IF N_ELEMENTS(PASIS__fastLocInterped_i_list) GT 0 THEN BEGIN
        out_fastLoc_i_list          = PASIS__fastLocInterped_i_list
        saveStr += 'out_fastLoc_i_list,'
        nInfo++
        infoStr += (nInfo GT 1 ? ',' : '') + '"fastLoc",' + $
                   (KEYWORD_SET(for_eSpec_DBs) ? "FL_eSpec__fastLoc" : "FL__fastLoc" ) + '.info'
     ENDIF


     IF N_ELEMENTS(PASIS__indices__eSpec_list) GT 0 THEN BEGIN
        out_i_eSpec_list  = PASIS__indices__eSpec_list
        saveStr += 'out_i_eSpec_list,'
        nInfo++
        infoStr += (nInfo GT 1 ? ',' : '') + '"eSpec",eSpec_info'
     ENDIF


     IF N_ELEMENTS(PASIS__indices__ion_list) GT 0 THEN BEGIN
        out_i_ion_list    = PASIS__indices__ion_list
        saveStr += 'out_i_ion_list,'
        nInfo++
        infoStr += (nInfo GT 1 ? ',' : '') + '"ion",ion_info'
     ENDIF

     IF nInfo GT 0 THEN BEGIN
        infoStr += ')'
        bro = EXECUTE(infoStr)
        IF ~bro THEN STOP
        saveStr += indsInfoStr + ',indsInfoStr,'
     ENDIF

     IF KEYWORD_SET(PASIS__alfDB_plot_struct.justInds_saveToFile) THEN BEGIN

        IF SIZE(PASIS__alfDB_plot_struct.justInds_saveToFile,/TYPE) EQ 7 THEN BEGIN
           justIndsFile = PASIS__alfDB_plot_struct.justInds_saveToFile
        ENDIF ELSE BEGIN
           justIndsFile = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)+ '--OMNI_FAST--indices.sav'
        ENDELSE

        ;;Final blow
        saveStr += 'FILENAME="' + PASIS__alfDB_plot_struct.saveDir + $
                   justIndsFile + '"'

        PRINT,'Saving indices/paramStrings in directory ' + PASIS__alfDB_plot_struct.saveDir
        PRINT,'indsFile: ' + justIndsFile

        bro = EXECUTE(saveStr)
        IF ~bro THEN STOP

        ;; SAVE,out_paramstring_list, $
        ;;      out_plot_i_list, $
        ;;      out_fastLoc_i_list, $        
        ;;      out_i_eSpec_list, $
        ;;      out_i_ion_list, $  
        ;;      FILENAME=saveDir+justIndsFile

        ;;Let others know
        PRINT,'DONE! Updating latest_OMNI_inds.txt ...'
        SPAWN,'echo ' + PASIS__alfDB_plot_struct.saveDir + justIndsFile + $
              ' > ' + PASIS__alfDB_plot_struct.saveDir + $
              'latest_OMNI_inds.txt'

     ENDIF

     RETURN

  ENDIF


  IF KEYWORD_SET(need_fastLoc_i) THEN BEGIN
     IF ~(COMPARE_DELTA_TYPES(KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc, $
                              (KEYWORD_SET(for_eSpec_DBs) ? NEWELL__eSpec     : MAXIMUS__maximus))) $
     THEN BEGIN
        PRINT,"Mismatch!!"
        STOP
     ENDIF
  ENDIF
  
  ;;********************************************
  ;;Now time for data summary

  ;; IF ~KEYWORD_SET(no_maximus) THEN BEGIN
     PRINT_ALFVENDB_PLOTSUMMARY,KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) ? NEWELL__eSpec : MAXIMUS__maximus, $
                                KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) ? PASIS__indices__eSpec_list : PASIS__plot_i_list, $
                                IMF_STRUCT=PASIS__IMF_struct, $
                                MIMC_STRUCT=PASIS__MIMC_struct, $
                                ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
                                PARAMSTRING=PASIS__paramString, $
                                PARAMSTR_LIST=PASIS__paramString_list, $
                                LUN=lun
  ;; ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Saving indices?
  IF KEYWORD_SET(save_alf_indices) AND ~KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) THEN BEGIN
     IF N_ELEMENTS(PASIS__paramString_list) GT 0 THEN BEGIN
        alfDB_ind_filename    = PASIS__paramString_list.toArray() + '--' + 'alfDB_indices.sav'
     ENDIF ELSE BEGIN
        alfDB_ind_filename    = PASIS__paramString + '--' + 'alfDB_indices.sav'
     ENDELSE
     SAVE_ALFVENDB_INDICES,alfDB_ind_filename, $
                           saveDir, $
                           plot_i_list, $
                           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
                           ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
                           IMF_STRUCT=PASIS__IMF_struct, $
                           MIMC_STRUCT=PASIS__MIMC_struct
  ENDIF

  ;;********************************************************
  ;;HISTOS

  tmplt_h2dStr = MAKE_H2DSTR_TMPLT( $
                 BIN1=PASIS__MIMC_struct.binM, $
                 BIN2=(KEYWORD_SET(PASIS__MIMC_struct.do_lShell) ? $
                       PASIS__MIMC_struct.binL : PASIS__MIMC_struct.binI),$
                 MIN1=PASIS__MIMC_struct.minM, $
                 MIN2=(KEYWORD_SET(PASIS__MIMC_struct.do_Lshell) ? $
                       PASIS__MIMC_struct.minL : PASIS__MIMC_struct.minI),$
                 MAX1=PASIS__MIMC_struct.maxM, $
                 MAX2=(KEYWORD_SET(do_Lshell) ? $
                       PASIS__MIMC_struct.maxL : PASIS__MIMC_struct.maxI), $
                 SHIFT1=PASIS__MIMC_struct.shiftM, $
                 SHIFT2=shiftI, $
                 EQUAL_AREA_BINNING=PASIS__alfDB_plot_struct.EA_binning, $
                 DO_TIMEAVG_FLUXQUANTITIES=PASIS__alfDB_plot_struct.do_timeAvg_fluxQuantities, $
                 BOTH_HEMIS=STRUPCASE(PASIS__MIMC_struct.hemi) EQ 'BOTH', $
                 CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                 CB_FORCE_OOBLOW=cb_force_oobLow)

  IF KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) THEN BEGIN
     tmplt_h2dStr.is_alfDB   = 0B
     tmplt_h2dStr.is_eSpecDB = 1B
  ENDIF

  ;;Doing grossrates?
  IF KEYWORD_SET(PASIS__alfDB_plot_struct.do_grossRate_fluxQuantities) OR $
     KEYWORD_SET(do_grossRate_with_long_width) OR $
     KEYWORD_SET(grossRate_info_file) OR $
     KEYWORD_SET(PASIS__alfDB_plot_struct.show_integrals) OR $
     KEYWORD_SET(PASIS__alfDB_plot_struct.make_integral_txtfile) OR $
     KEYWORD_SET(PASIS__alfDB_plot_struct.make_integral_savfiles) $
  THEN grossRateMe = 1

  ;;Need area or length of each bin for gross rates
  IF KEYWORD_SET(grossRateMe                                            ) OR $
     KEYWORD_SET(PASIS__alfDB_plot_struct.plotH2D_contour               ) OR $
     KEYWORD_SET(PASIS__alfDB_plot_struct.plotH2D__kernel_density_unmask) OR $
     KEYWORD_SET(PASIS__alfDB_plot_struct.writeProcessedH2D             ) $
  THEN BEGIN
     IF KEYWORD_SET(do_grossRate_fluxQuantities) AND $
        KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        PRINTF,lun,"Can't do both types of gross rates simultaneously!!!"
        STOP
     ENDIF
     
     ;;In square kilometers
     GET_H2D_BIN_AREAS,h2dAreas, $
                       CENTERS1=centersMLT, $
                       CENTERS2=centersILAT, $
                       BINSIZE1=PASIS__MIMC_struct.binM*15., $
                       BINSIZE2=PASIS__MIMC_struct.binI, $
                       MAX1=PASIS__MIMC_struct.maxM*15., $
                       MAX2=PASIS__MIMC_struct.maxI, $
                       MIN1=PASIS__MIMC_struct.minM*15., $
                       MIN2=PASIS__MIMC_struct.minI, $
                       SHIFT1=PASIS__MIMC_struct.shiftM*15., $
                       SHIFT2=shiftI, $
                       EQUAL_AREA_BINNING=PASIS__alfDB_plot_struct.EA_binning

     IF KEYWORD_SET(EA_binning) THEN h2dAreas[*] = MEDIAN(h2dAreas)

     IF KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        GET_H2D_BIN_LENGTHS,h2dLongWidths, $
                            /LONGITUDINAL, $
                            CENTERS1=centersMLT, $
                            CENTERS2=centersILAT, $
                            BINSIZE1=PASIS__MIMC_struct.binM*15., $
                            BINSIZE2=PASIS__MIMC_struct.binI, $
                            MAX1=PASIS__MIMC_struct.maxM*15., $
                            MAX2=PASIS__MIMC_struct.maxI, $
                            MIN1=PASIS__MIMC_struct.minM*15., $
                            MIN2=PASIS__MIMC_struct.minI, $
                            SHIFT1=PASIS__MIMC_struct.shiftM*15., $
                            SHIFT2=shiftI, $
                            EQUAL_AREA_BINNING=PASIS__alfDB_plot_struct.EA_binning
     ENDIF
  ENDIF

  IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
     SETUP_GROSSRATE_INFO_FILE,grossRate_info_file, $
                               PARAMSTRING=PASIS__paramString, $
                               TXTOUTPUTDIR=txtOutputDir, $
                               GROSSLUN=grossLun, $
                               LUN=lun
  ENDIF

  IF KEYWORD_SET(PASIS__alfDB_plot_struct.executing_multiples) THEN BEGIN
     NIter = N_ELEMENTS(PASIS__alfDB_plot_struct.multiples) 
  ENDIF ELSE BEGIN
     NIter = 1
  ENDELSE

  h2dStrArr_List                   = LIST()
  dataNameArr_List                 = LIST()
  dataRawPtrArr_List               = LIST()
  ;; FOR iMulti=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN
  FOR iMulti=0,NIter-1 DO BEGIN

     PRINT,'PLOT_ALFVEN_STATS_IMF_SCREENING: '+PASIS__paramString_list[iMulti]

     IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
        PRINTF,grossLun,""
        PRINTF,grossLun,PASIS__paramString_list[iMulti]
     ENDIF

     h2dStrArr             = !NULL
     dataNameArr           = !NULL
     dataRawPtrArr         = !NULL

     IF KEYWORD_SET(PASIS__indices__ion_list) THEN BEGIN
        indices__ion       = PASIS__indices__ion_list[iMulti]
     ENDIF
     IF KEYWORD_SET(PASIS__indices__eSpec_list) THEN BEGIN
        indices__eSpec     = PASIS__indices__eSpec_list[iMulti]
     ENDIF

     IF ~KEYWORD_SET(PASIS__alfDB_plot_struct.no_maximus) THEN BEGIN
        plot_i             = PASIS__plot_i_list[iMulti]
     ENDIF

     IF KEYWORD_SET(need_fastLoc_i) THEN BEGIN
        fastLocInterped_i  = PASIS__fastLocInterped_i_list[iMulti]
     ENDIF

     IF KEYWORD_SET(PASIS__paramString_list) THEN BEGIN 
        paramStr           = PASIS__paramString_list[iMulti] 
     ENDIF

     extra = CREATE_STRUCT(PASIS__alfDB_plot_struct,alfDB_plotLim_struct)
     GET_ALFVENDB_2DHISTOS, $
        plot_i, $
        fastLocInterped_i, $
        H2DSTRARR=h2dStrArr, $
        DATARAWPTRARR=dataRawPtrArr, $
        DATANAMEARR=dataNameArr, $
        /DO_NOT_SET_DEFAULTS, $
        ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        IMF_STRUCT=PASIS__IMF_struct, $
        MIMC_STRUCT=PASIS__MIMC_struct, $
        NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
        NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
        EFLUX_ESPEC_DATA=PASIS__eFlux_eSpec_data, $
        ENUMFLUX_ESPEC_DATA=PASIS__eNumFlux_eSpec_data, $
        IFLUX_ION_DATA=PASIS__iFlux_ion_data, $
        INUMFLUX_ION_DATA=PASIS__iNumFlux_ion_data, $
        INDICES__ESPEC=indices__eSpec, $
        INDICES__ION=indices__ion, $
        ESPEC__NO_MAXIMUS=PASIS__alfDB_plot_struct.no_maximus, $
        ;; FOR_ESPEC_DB=for_eSpec_DB, $
        ESPEC__MLTS=PASIS__eSpec__mlts, $
        ESPEC__ILATS=PASIS__eSpec__ilats, $
        ;; FOR_ION_DB=for_ion_DB, $
        ION__MLTS=PASIS__ion__mlts, $
        ION__ILATS=PASIS__ion__ilats, $
        ION_DELTA_T=PASIS__ion_delta_t, $
        ORBCONTRIB__REFERENCE_ALFVENDB_NOT_EPHEMERIS=orbContrib__reference_alfvenDB, $
        DIVNEVBYTOTAL=divNEvByTotal, $
        NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
        ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
        ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
        GROSSRATE__H2D_AREAS=h2dAreas, $
        DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
        GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
        GROSSRATE__CENTERS_MLT=centersMLT, $
        GROSSRATE__CENTERS_ILAT=centersILAT, $
        WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
        GROSSLUN=grossLun, $
        SHOW_INTEGRALS=show_integrals, $
        WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
        WRITE_ORB_AND_OBS__INC_IMF=write_obsArr__inc_IMF, $
        WRITE_ORB_AND_OBS__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
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
        SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
        SUMMED_EFLUX_PFLUX_LOGPLOT=summed_eFlux_pFlux_logPlot, $
        MEDIANPLOT=medianPlot, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots,$
        PARAMSTRG=paramStr, $
        PARAMSTRPREFIX=plotPrefix, $
        PARAMSTRSUFFIX=plotSuffix, $
        TMPLT_H2DSTR=tmplt_h2dStr, $
        RESET_GOOD_INDS=reset_good_inds, $
        RESET_OMNI_INDS=reset_omni_inds, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        TXTOUTPUTDIR=txtOutputDir, $
        _EXTRA=extra, $
        LUN=lun

     h2dStrArr_List.add,h2dStrArr
     dataNameArr_list.add,dataNameArr
     dataRawPtrArr_list.add,dataRawPtrArr

  ENDFOR

  IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
     CLOSE_GROSSRATE_INFO_FILE,grossRate_info_file,grossLun
  ENDIF


  IF (KEYWORD_SET(PASIS__alfDB_plot_struct.executing_multiples) AND $
      KEYWORD_SET(group_like_plots_for_tiling)) $
  THEN BEGIN
     REARRANGE_H2DSTRARR_LIST_INTO_LIKE_PLOTS, $
        h2dStrArr_list, $
        dataNameArr_list, $
        dataRawPtrArr_list, $
        PASIS__paramString_list, $
        HAS_NPLOTS=nplots, $
        NEW_PARAMSTR_FOR_LIKE_PLOTARRS=PASIS__alfDB_plot_struct.multiString, $
        SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
        DO_REARRANGE_DATARAWPTRARR_LIST=do_rearrange_dataRawPtrArr_list, $
        ADJ_UPPER_PLOTLIM_IF_NTH_MAX_IS_GREATER=adj_upper_plotlim_thresh, $
        ADJ_LOWER_PLOTLIM_IF_NTH_MIN_IS_GREATER=adj_lower_plotlim_thresh, $
        /DONT_ADJUST_PARAMSTRING_LIST, $
        OUT_NEW_PARAMSTRING_LIST=new_paramString_list, $
        OUT_MASK_H2DSTRARR=h2dMaskArr
  ENDIF ELSE BEGIN
     new_paramString_list = PASIS__paramString_list
  ENDELSE

  ;;********************************************************
  ;;Handle Plots all at once

  ;;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively
  tempFile_list           = LIST()
  FOR iList=0,N_ELEMENTS(h2dStrArr_list)-1 DO BEGIN
     h2dStrArr            = h2dStrArr_list[iList]
     dataNameArr          = dataNameArr_list[iList]
     dataRawPtrArr        = (N_ELEMENTS(dataRawPtrArr_list)-1) GE iList ? $
                            dataRawPtrArr_list[iList] : $
                            !NULL
     paramString          = new_paramString_list[iList]

     IF ~KEYWORD_SET(group_like_plots_for_tiling) THEN BEGIN
        ;;Shift the way we historically have
        h2dStrArr         = SHIFT(h2dStrArr,-1-(nPlots))

        plot_i            = N_ELEMENTS(PASIS__plot_i_list) GT 0 ? PASIS__plot_i_list[iList] : !NULL
        IF PASIS__alfDB_plot_struct.keepMe THEN BEGIN 
           dataNameArr    = SHIFT(dataNameArr,-1-(nPlots)) 
           dataRawPtrArr  = SHIFT(dataRawPtrArr,-1-(nPlots)) 
        ENDIF
        
        ;; h2dStrArr_list[iList]         = SHIFT(h2dStrArr_List[iList],-1-(nPlots))
        ;; IF keepMe THEN BEGIN 
        ;;    dataNameArr_list[iList]    = SHIFT(dataNameArr_list[iList],-2) 
        ;;    dataRawPtrArr_list[iList]  = SHIFT(dataRawPtrArr_list[iList],-2) 
        ;; ENDIF
     ENDIF ELSE BEGIN
        plot_i            = KEYWORD_SET(FOR_eSpec_DBs) ? PASIS__indices__eSpec_list : PASIS__plot_i_list
     ENDELSE

     IF ~KEYWORD_SET(PASIS__alfDB_plot_struct.squarePlot) THEN BEGIN
        SAVE_ALFVENDB_TEMPDATA, $
           H2DSTRARR=h2dStrArr, $
           DATANAMEARR=dataNameArr,$
           H2DMASKARR=h2dMaskArr, $
           MAXM=PASIS__MIMC_struct.maxM, $
           MINM=PASIS__MIMC_struct.minM, $
           MAXI=PASIS__MIMC_struct.maxI, $
           MINI=PASIS__MIMC_struct.minI, $
           BINM=PASIS__MIMC_struct.binM, $
           SHIFTM=PASIS__MIMC_struct.shiftM, $
           BINI=PASIS__MIMC_struct.binI, $
           DO_LSHELL=PASIS__MIMC_struct.do_lShell, $
           REVERSE_LSHELL=PASIS__MIMC_struct.reverse_lShell,$
           MINL=PASIS__MIMC_struct.minL, $
           MAXL=PASIS__MIMC_struct.maxL, $
           BINL=PASIS__MIMC_struct.binL,$
           SAVEDIR=saveDir, $
           PARAMSTR=paramString,$
           CLOCKSTR=clockStr, $
           PLOTMEDORAVG=plotMedOrAvg, $
           STABLEIMF=PASIS__IMF_struct.stableIMF, $
           HOYDIA=hoyDia,HEMI=hemi, $
           OUT_TEMPFILE=out_tempFile
     ENDIF

     ;;Now plots
     IF ~KEYWORD_SET(PASIS__alfDB_plot_struct.justData) THEN BEGIN

        ;;Do we have any candidates for overplotting?
        IF KEYWORD_SET(PASIS__alfDB_plot_struct.overplot_file) AND KEYWORD_SET(PASIS__alfDB_plot_struct.overplot_arr) THEN BEGIN
           PRINT,'Checking for overplot stuff ...'

           ;; IF N_ELEMENTS(oplotStr) EQ 0 THEN BEGIN
           ;;    oplotStr = GET_OVERPLOT_VARS_FROM_FILE(overplot_file)
           ;; ENDIF
           IF ~KEYWORD_SET(OP__HAVE_VARS) THEN BEGIN
              SET_OVERPLOT_COMMON_VARS_FROM_FILE,PASIS__alfDB_plot_struct.overplot_file
           ENDIF

           match = 0
           ;; FOR bk=0,N_ELEMENTS(overplot_arr[0,*])-1 DO BEGIN
           ;;    match += ( STRMATCH(STRUPCASE(dataNameArr[0]),STRUPCASE(overplot_arr[0,bk])) AND     $
           ;;               STRMATCH(STRUPCASE(oplotStr.dataNameArr[0]),STRUPCASE(overplot_arr[1,bk])))
           ;; ENDFOR 
           FOR bk=0,N_ELEMENTS(PASIS__alfDB_plot_struct.overplot_arr[0,*])-1 DO BEGIN
              match += ( STRMATCH(STRUPCASE(dataNameArr[0]),STRUPCASE(PASIS__alfDB_plot_struct.overplot_arr[0,bk])) AND     $
                         STRMATCH(STRUPCASE(OP__dataNameArr[0]),STRUPCASE(PASIS__alfDB_plot_struct.overplot_arr[1,bk])))
           ENDFOR 

           CASE match OF
              0: sendit = 0
              1: sendit = 1
              ELSE: STOP
           ENDCASE
        ENDIF

        PLOT_ALFVENDB_2DHISTOS, $
           H2DSTRARR=h2dStrArr, $
           DATANAMEARR=dataNameArr, $
           H2DMASKARR=h2dMaskArr, $
           TEMPFILE=out_tempFile, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           ;; SQUAREPLOT=PASIS__alfDB_plot_struct.squarePlot, $
           ;; POLARCONTOUR=PASIS__alfDB_plot_struct.polarContour, $ 
           ;; JUSTDATA=PASIS__alfDB_plot_struct.justData, $
           ;; SHOWPLOTSNOSAVE=PASIS__alfDB_plot_struct.showPlotsNoSave, $
           PLOTDIR=plotDir, $
           ;; PLOTMEDORAVG=PASIS__alfDB_plot_struct.plotMedOrAvg, $
           PARAMSTR=paramString, $
           ORG_PLOTS_BY_FOLDER=org_plots_by_folder, $
           ;; DEL_PS=PASIS__alfDB_plot_struct.del_PS, $
           HEMI=PASIS__MIMC_struct.hemi, $
           CLOCKSTR=clockStr, $
           SUPPRESS_THICKGRID=suppress_thickGrid, $
           SUPPRESS_GRIDLABELS=suppress_gridLabels, $
           SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
           SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
           SUPPRESS_MLT_NAME=suppress_MLT_name, $
           SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
           SUPPRESS_TITLES=suppress_titles, $
           LABELS_FOR_PRESENTATION=labels_for_presentation, $
           TILE_IMAGES=tile_images, $
           N_TILE_ROWS=n_tile_rows, $
           N_TILE_COLUMNS=n_tile_columns, $
           TILING_ORDER=tiling_order, $
           TILE__FAVOR_ROWS=tile__favor_rows, $
           TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
           TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
           TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
           ;; BLANK_TILE_POSITIONS=blank_tile_positions, $
           TILEPLOTSUFF=tilePlotSuff, $
           TILEPLOTTITLE=tilePlotTitle, $
           NO_COLORBAR=no_colorbar, $
           EPS_OUTPUT=eps_output, $
           ;; PLOTH2D_CONTOUR=PASIS__alfDB_plot_struct.plotH2D_contour, $
           ;; CONTOUR__LEVELS=PASIS__alfDB_plot_struct.contour__levels, $
           ;; CONTOUR__PERCENT=PASIS__alfDB_plot_struct.contour__percent, $
           ;; PLOTH2D__KERNEL_DENSITY_UNMASK=PASIS__alfDB_plot_struct.plotH2D__kernel_density_unmask, $
           ;; OVERPLOTSTR=KEYWORD_SET(sendit) ? oplotStr : !NULL, $
           OVERPLOTSTR=KEYWORD_SET(sendit), $
           ;; OVERPLOT_CONTOUR__LEVELS=PASIS__alfDB_plot_struct.op_contour__levels, $
           ;; OVERPLOT_CONTOUR__PERCENT=PASIS__alfDB_plot_struct.op_contour__percent, $
           ;; OVERPLOT_PLOTRANGE=PASIS__alfDB_plot_struct.op_plotRange, $
           CENTERS_MLT=centersMLT, $
           CENTERS_ILAT=centersILAT, $
           ;; SHOW_INTEGRALS=PASIS__alfDB_plot_struct.show_integrals, $
           ;; MAKE_INTEGRAL_TXTFILE=PASIS__alfDB_plot_struct.make_integral_txtfile, $
           ;; MAKE_INTEGRAL_SAVFILE=PASIS__alfDB_plot_struct.make_integral_savfiles, $
           ;; INTEGRALSAVFILEPREF=PASIS__alfDB_plot_struct.integralSavFilePref, $
           TXTOUTPUTDIR=txtOutputDir, $
           _EXTRA=PASIS__alfDB_plot_struct
     ENDIF

     IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
        CLOSE,lun 
        FREE_LUN,lun 
     ENDIF

     ;;Save raw data, if desired
     IF KEYWORD_SET(saveRaw) THEN BEGIN
        SAVE, /ALL, filename=saveDir+'fluxplots_'+paramString+".dat"

     ENDIF

     WRITE_ALFVENDB_2DHISTOS, $
        MAXIMUS=MAXIMUS__maximus,PLOT_I=plot_i, $
        CENTERS_MLT=centersMLT, $
        CENTERS_ILAT=centersILAT, $
        WRITEHDF5=PASIS__alfDB_plot_struct.writeHDF5, $
        WRITEPROCESSEDH2D=PASIS__alfDB_plot_struct.writeProcessedH2D, $
        WRITEASCII=PASIS__alfDB_plot_struct.writeASCII, $
        H2DSTRARR=h2dStrArr, $
        DATARAWPTRARR=dataRawPtrArr, $
        DATANAMEARR=dataNameArr, $
        PARAMSTR=KEYWORD_SET(group_like_plots_for_tiling) ? PASIS__paramString_list : paramString, $
        TXTOUTPUTDIR=txtOutputDir

     tempFile_list.add,out_tempFile
  ENDFOR

  ;; out_tempFile_list      = tempFile_list
  ;; out_dataNameArr_list   = dataNameArr_list
  ;; out_paramString_list   = paramString_list
  ;; out_plot_i_list        = N_ELEMENTS(plot_i_list) GT 0 ? plot_i_list : !NULL

  ;;Collect garbage
  HEAP_GC

END