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
;		     DO_CHASTDB        :  Use Chaston's original ALFVEN_STATS_3 database. 
;                                            (He used it for a few papers, I think, so it's good).
;
;                  *VARIOUS OUTPUT OPTIONS
;		     WRITEASCII        :     
;		     WRITEHDF5         :      
;                    WRITEPROCESSEDH2D :  Use this to output processed, histogrammed data. That way you
;                                            can share with others!
;		     SAVERAW           :  Save all raw data
;		     RAWDIR            :  Directory in which to store raw data
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
;     plot_alfven_stats_imf_screening,clockstr="duskward",/do_chastdb,$
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
;                       Jan 2016   : Added DO_DESPUNDB keyword for our new despun database with TEAMS data!
;                     2016/02/10   : Added DO_NOT_CONSIDER_IMF keyword
;                     2016/02/20   : Big changes. Added multiple_delays keyword, which shakes up the whole system.
;-

PRO PLOT_ALFVEN_STATS_IMF_SCREENING,maximus, $
                                    RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                    ORBRANGE=orbRange, $
                                    ALTITUDERANGE=altitudeRange, $
                                    CHARERANGE=charERange, $
                                    CHARIERANGE=charIERange, $ ;;Only applicable for non-Alfvén stuff
                                    POYNTRANGE=poyntRange, $
                                    SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                    INCLUDE_32HZ=include_32Hz, $
                                    DISREGARD_SAMPLE_T=disregard_sample_t, $
                                    NUMORBLIM=numOrbLim, $
                                    MINMLT=minM,MAXMLT=maxM, $
                                    BINMLT=binM, $
                                    SHIFTMLT=shiftM, $
                                    MINILAT=minI,MAXILAT=maxI, $
                                    BINILAT=binI, $
                                    EQUAL_AREA_BINNING=EA_binning, $
                                    DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                    MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                    MIN_MAGCURRENT=minMC, $
                                    MAX_NEGMAGCURRENT=maxNegMC, $
                                    HWMAUROVAL=HwMAurOval, $
                                    HWMKPIND=HwMKpInd, $
                                    ;; MIN_NEVENTS=min_nEvents, $
                                    MASKMIN=maskMin, $
                                    THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
                                    CLOCKSTR=clockStr, $
                                    DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
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
                                    RESET_OMNI_INDS=reset_omni_inds, $
                                    SATELLITE=satellite, $
                                    OMNI_COORDS=omni_Coords, $
                                    PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                                    PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                                    PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                                    SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                                    MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
                                    OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
                                    CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                                    HEMI=hemi, $
                                    NORTH=north, $
                                    SOUTH=south, $
                                    BOTH_HEMIS=both_hemis, $
                                    DELAY=delay, $
                                    MULTIPLE_DELAYS=multiple_delays, $
                                    MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                                    RESOLUTION_DELAY=delay_res, $
                                    BINOFFSET_DELAY=binOffset_delay, $
                                    STABLEIMF=stableIMF, $
                                    SMOOTHWINDOW=smoothWindow, $
                                    INCLUDENOCONSECDATA=includeNoConsecData, $
                                    DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                    NONSTORM=nonStorm, $
                                    RECOVERYPHASE=recoveryPhase, $
                                    MAINPHASE=mainPhase, $
                                    DSTCUTOFF=dstCutoff, $
                                    SMOOTH_DST=smooth_dst, $
                                    USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
                                    USE_AE=use_ae, $
                                    USE_AU=use_au, $
                                    USE_AL=use_al, $
                                    USE_AO=use_ao, $
                                    AECUTOFF=AEcutoff, $
                                    SMOOTH_AE=smooth_AE, $
                                    AE_HIGH=AE_high, $
                                    AE_LOW=AE_low, $
                                    NPLOTS=nPlots, $
                                    EPLOTS=ePlots, $
                                    EPLOTRANGE=ePlotRange, $
                                    EFLUXPLOTTYPE=eFluxPlotType, $
                                    LOGEFPLOT=logEfPlot, $
                                    ABSEFLUX=abseflux, $
                                    NOPOSEFLUX=noPosEFlux, $
                                    NONEGEFLUX=noNegEflux, $
                                    ENUMFLPLOTS=eNumFlPlots, $
                                    ENUMFLPLOTTYPE=eNumFlPlotType, $
                                    LOGENUMFLPLOT=logENumFlPlot, $
                                    ABSENUMFL=absENumFl, $
                                    NONEGENUMFL=noNegENumFl, $
                                    NOPOSENUMFL=noPosENumFl, $
                                    ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                    AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
                                    NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
                                    NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
                                    NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                                    NEWELL__COMBINE_ACCELERATED=Newell__comb_accelerated, $
                                    NONALFVEN__NO_MAXIMUS=no_maximus, $
                                    NONALFVEN_FLUX_PLOTS=nonAlfven_flux_plots, $
                                    NONALFVEN__JUNK_ALFVEN_CANDIDATES=nonAlfven__junk_alfven_candidates, $
                                    NONALFVEN__ALL_FLUXES=nonalfven__all_fluxes, $
                                    ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
                                    ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
                                    ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
                                    PPLOTS=pPlots, $
                                    LOGPFPLOT=logPfPlot, $
                                    ABSPFLUX=absPflux, $
                                    NONEGPFLUX=noNegPflux, $
                                    NOPOSPFLUX=noPosPflux, $
                                    PPLOTRANGE=PPlotRange, $
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
                                    FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                                    FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
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
                                    NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, $
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
                                    NONALFVEN__NEWELLPLOT_PROBOCCURRENCE=nonAlfven__newellPlot_probOccurrence, $
                                    NONALFVEN__NEWELL_PLOTRANGE=nonalfven__newell_plotRange, $
                                    TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                                    TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                    LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                                    TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                                    TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                                    LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
                                    DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
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
                                    MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                    ALL_LOGPLOTS=all_logPlots, $
                                    SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                    DBFILE=dbfile, $
                                    RESET_GOOD_INDS=reset_good_inds, $
                                    NO_BURSTDATA=no_burstData, $
                                    DATADIR=dataDir, $
                                    DO_CHASTDB=do_chastDB, $
                                    DO_DESPUNDB=do_despunDB, $
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
                                    SAVERAW=saveRaw, RAWDIR=rawDir, $
                                    JUSTDATA=justData, $
                                    JUSTINDS_THENQUIT=justInds, $
                                    JUSTINDS_SAVETOFILE=justInds_saveToFile, $
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
                                    ;; BLANK_TILE_POSITIONS=blank_tile_positions, $
                                    TILEPLOTSUFF=tilePlotSuff, $
                                    TILEPLOTTITLE=tilePlotTitle, $
                                    NO_COLORBAR=no_colorbar, $
                                    CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                    CB_FORCE_OOBLOW=cb_force_oobLow, $
                                    PLOTH2D_CONTOUR=plotH2D_contour, $
                                    FANCY_PLOTNAMES=fancy_plotNames, $
                                    SHOW_INTEGRALS=show_integrals, $
                                    MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
                                    MAKE_INTEGRAL_SAVFILES=make_integral_savfiles, $
                                    INTEGRALSAVFILEPREF=integralSavFilePref, $
                                    OUT_TEMPFILE_LIST=out_tempFile_list, $
                                    OUT_DATANAMEARR_LIST=out_dataNameArr_list, $
                                    OUT_PARAMSTRING_LIST=out_paramString_list, $
                                    OUT_PLOT_I_LIST=out_plot_i_list, $
                                    OUT_FASTLOC_I_LIST=out_fastLoc_i_list, $
                                    OUT_I_NONALFVEN_ESPEC_LIST=out_i_nonAlfven_eSpec_list, $
                                    OUT_I_NONALFVEN_ION_LIST=out_i_nonAlfven_ion_list, $
                                    RESTORE_LAST_SESSION=restore_last_session, $
                                    DONT_LOAD_IN_MEMORY=nonMem, $
                                    _EXTRA = e
  
;;  COMPILE_OPT idl2

  !EXCEPT=0                                                      ;Do report errors, please

  lastSessionFile = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/last_session.sav'

  @common__fastloc_vars.pro
  @common__fastloc_espec_vars.pro

  IF KEYWORD_SET(do_not_consider_IMF) THEN BEGIN
     IF ~KEYWORD_SET(plotDir) THEN $
        SET_PLOT_DIR,plotDir, $
                     /FOR_ALFVENDB, $
                     /ADD_TODAY, $
                     ADD_SUFF=suffix_plotDir
     IF ~KEYWORD_SET(txtOutputDir) THEN $
        SET_TXTOUTPUT_DIR,txtOutputDir, $
                          /FOR_ALFVENDB, $
                          /ADD_TODAY, $
                          ADD_SUFF=suffix_txtDir
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(plotDir) THEN $
        SET_PLOT_DIR,plotDir, $
                     /FOR_SW_IMF, $
                     /ADD_TODAY, $
                     ADD_SUFF=suffix_plotDir
     IF ~KEYWORD_SET(txtOutputDir) THEN $
        SET_TXTOUTPUT_DIR,txtOutputDir, $
                          /FOR_SW_IMF, $
                          /ADD_TODAY, $
                          ADD_SUFF=suffix_txtDir
  ENDELSE


  IF KEYWORD_SET(restore_last_session) THEN BEGIN
     RESTORE,lastSessionFile
  ;; IF KEYWORD_SET(restore_last_session) THEN BEGIN
  ;;    ;; RESTORE,lastSessionFile
  ;;    SPAWN,'cat '
  ENDIF ELSE BEGIN

     IF KEYWORD_SET(multiple_delays) AND KEYWORD_SET(multiple_IMF_clockAngles) THEN BEGIN
        PRINT,"Not set up to handle multiples of both conditions right now! Sorry. You'll find trouble in GET_RESTRICTED_AND_INTERPED_DB_INDICES if you attempt this..."
        STOP
     ENDIF

     SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, $
                                ALTITUDERANGE=altitudeRange, $
                                CHARERANGE=charERange, $
                                POYNTRANGE=poyntRange, $
                                SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                INCLUDE_32HZ=include_32Hz, $
                                DISREGARD_SAMPLE_T=disregard_sample_t, $
                                MINMLT=minM,MAXMLT=maxM, $
                                BINMLT=binM, $
                                SHIFTMLT=shiftM, $
                                MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                EQUAL_AREA_BINNING=EA_binning, $
                                DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                MIN_MAGCURRENT=minMC, $
                                MAX_NEGMAGCURRENT=maxNegMC, $
                                HWMAUROVAL=HwMAurOval, $
                                HWMKPIND=HwMKpInd, $
                                ;; MIN_NEVENTS=min_nEvents, $
                                MASKMIN=maskMin, $
                                THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
                                DO_DESPUNDB=do_despunDB, $
                                USE_AACGM_COORDS=use_AACGM, $
                                USE_MAG_COORDS=use_MAG, $
                                HEMI=hemi, $
                                NORTH=north, $
                                SOUTH=south, $
                                BOTH_HEMIS=both_hemis, $
                                NPLOTS=nPlots, $
                                EPLOTS=ePlots, $
                                EFLUXPLOTTYPE=eFluxPlotType, $
                                ENUMFLPLOTS=eNumFlPlots, $
                                ENUMFLPLOTTYPE=eNumFlPlotType, $
                                PPLOTS=pPlots, $
                                IONPLOTS=ionPlots, $
                                IFLUXPLOTTYPE=ifluxPlotType, $
                                CHAREPLOTS=charEPlots, $
                                CHARETYPE=charEType, $
                                CHARIEPLOTS=chariEPlots, $
                                AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
                                ;; FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                                ;; FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                                ORBCONTRIBPLOT=orbContribPlot, $
                                ;; ORBCONTRIB_NOMASK=orbContrib_noMask, $
                                ORBTOTPLOT=orbTotPlot, $
                                ORBFREQPLOT=orbFreqPlot, $
                                NEVENTPERORBPLOT=nEventPerOrbPlot, $
                                NEVENTPERMINPLOT=nEventPerMinPlot, $
                                ;; NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
                                PROBOCCURRENCEPLOT=probOccurrencePlot, $
                                SQUAREPLOT=squarePlot, $
                                POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                MEDIANPLOT=medianPlot, $
                                LOGAVGPLOT=logAvgPlot, $
                                PLOTMEDORAVG=plotMedOrAvg, $
                                DATADIR=dataDir, $
                                NO_BURSTDATA=no_burstData, $
                                WRITEASCII=writeASCII, $
                                WRITEHDF5=writeHDF5, $
                                WRITEPROCESSEDH2D=writeProcessedH2d, $
                                SAVERAW=saveRaw, RAWDIR=rawDir, $
                                SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                ;; PLOTDIR=plotDir, $
                                MEDHISTOUTDATA=medHistOutData, $
                                MEDHISTOUTTXT=medHistOutTxt, $
                                OUTPUTPLOTSUMMARY=outputPlotSummary, $
                                ;; OUT_TEMPFILE=out_tempFile, $
                                ;; PRINT_ALFVENDB_2DHISTOS=print_alfvendb_2dhistos, $
                                DEL_PS=del_PS, $
                                KEEPME=keepMe, $
                                PARAMSTRING=paramString, $
                                PARAMSTRPREFIX=plotPrefix, $
                                PARAMSTRSUFFIX=plotSuffix,$
                                PLOTH2D_CONTOUR=plotH2D_contour, $
                                HOYDIA=hoyDia,LUN=lun,_EXTRA=e
     
     SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, $
                                     ANGLELIM1=angleLim1, $
                                     ANGLELIM2=angleLim2, $
                                     ORBRANGE=orbRange, $
                                     ALTITUDERANGE=altitudeRange, $
                                     CHARERANGE=charERange, $
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
                                     BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                     DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                     DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                     PARAMSTRING=paramString, $
                                     PARAMSTR_LIST=paramString_list, $
                                     SATELLITE=satellite, $
                                     OMNI_COORDS=omni_Coords, $
                                     DELAY=delay, $
                                     MULTIPLE_DELAYS=multiple_delays, $
                                     MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                                     OUT_EXECUTING_MULTIPLES=executing_multiples, $
                                     OUT_MULTIPLES=multiples, $
                                     OUT_MULTISTRING=multiString, $
                                     RESOLUTION_DELAY=delay_res, $
                                     BINOFFSET_DELAY=binOffset_delay, $
                                     STABLEIMF=stableIMF, $
                                     SMOOTHWINDOW=smoothWindow, $
                                     INCLUDENOCONSECDATA=includeNoConsecData, $
                                     EARLIEST_UTC=earliest_UTC, $
                                     LATEST_UTC=latest_UTC, $
                                     EARLIEST_JULDAY=earliest_julDay, $
                                     LATEST_JULDAY=latest_julDay, $
                                     LUN=lun


     ;;Open file for text summary, if desired
     IF KEYWORD_SET(outputPlotSummary) THEN BEGIN
        OPENW,lun,txtOutputDir + 'outputSummary_'+paramString+'.txt',/GET_LUN 
        IF KEYWORD_SET(executing_multiples) THEN BEGIN
           PRINT,"What are you thinking? You're not setup to get multi-output..."
           STOP
        ENDIF
     ENDIF ELSE BEGIN
        lun=-1                  ;-1 is lun for STDOUT
     ENDELSE
     
     ;;Handle hemisphere issues up front if we're doing equal-area binning
     IF KEYWORD_SET(EA_binning) THEN BEGIN
        LOAD_EQUAL_AREA_BINNING_STRUCT,HEMI=hemi
     ENDIF

     ;;********************************************************
     ;;Now clean and tap the databases and interpolate satellite data
     use_storm_stuff = KEYWORD_SET(nonStorm     ) + $
                       KEYWORD_SET(mainPhase    ) + $
                       KEYWORD_SET(recoveryPhase)

     use_ae_stuff    = KEYWORD_SET(use_AE) + $
                       KEYWORD_SET(use_AO) + $
                       KEYWORD_SET(use_AU) + $
                       KEYWORD_SET(use_AL)

     ;;Does it all "hang together"?
     IF use_storm_stuff GT 1 THEN BEGIN
        PRINT,"Can't set more than one of the storm keywords simultaneously!"
        STOP
     ENDIF
     IF use_ae_stuff GT 1 THEN BEGIN
        PRINT,"only select one of (AE,AU,AL,AO)!"
        STOP
     ENDIF
     IF use_ae_stuff AND use_storm_stuff THEN BEGIN
        PRINT,"Currently not possible to use AE stuff together with storm stuff!"
        STOP
     ENDIF
     ;; IF use_ae_stuff OR use_storm_stuff THEN BEGIN
     ;;    earliest_UTC = STR_TO_TIME('1996-10-06/16:26:02.417')
     ;;    latest_UTC   = STR_TO_TIME('1999-11-03/03:20:59.853')
     ;; ENDIF

     IF KEYWORD_SET(use_storm_stuff) THEN BEGIN

        IF ~KEYWORD_SET(no_maximus) THEN BEGIN
           GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
              DO_DESPUNDB=do_despunDB, $
              COORDINATE_SYSTEM=coordinate_system, $
              USE_AACGM_COORDS=use_AACGM, $
              USE_MAG_COORDS=use_MAG, $
              SAMPLE_T_RESTRICTION=sample_t_restriction, $
              INCLUDE_32Hz=include_32Hz, $
              DISREGARD_SAMPLE_T=disregard_sample_t, $
              DSTCUTOFF=dstCutoff, $
              SMOOTH_DST=smooth_dst, $
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
              KEYWORD_SET(nonStorm): BEGIN
                 PRINTF,lun,'Restricting maximus with non-storm indices ...'
                 restrict_with_these_i = ns_i
              END
              KEYWORD_SET(mainPhase): BEGIN
                 PRINTF,lun,'Restricting maximus with main-phase indices ...'
                 restrict_with_these_i = mp_i
              END
              KEYWORD_SET(recoveryPhase): BEGIN
                 PRINTF,lun,'Restricting maximus with recovery-phase indices ...'
                 restrict_with_these_i = rp_i
              END
           ENDCASE
        ENDIF

        ;;Now OMNI, if desired
        GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_OMNIDB_INDICES, $
           OMNI_COORDS=OMNI_coords, $
           ;; /RESTRICT_TO_ALFVENDB_TIMES, $
           EARLIEST_UTC=earliest_UTC, $
           LATEST_UTC=latest_UTC, $
           USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
           EARLIEST_JULDAY=earliest_julDay, $
           LATEST_JULDAY=latest_julDay, $
           ;; COORDINATE_SYSTEM=coordinate_system, $
           ;; USE_AACGM_COORDS=use_AACGM, $
           ;; USE_MAG_COORDS=use_MAG, $
           DSTCUTOFF=dstCutoff, $
           SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
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
           KEYWORD_SET(nonStorm): BEGIN
              PRINTF,lun,'Restricting OMNI with non-storm indices ...'
              restrict_OMNI_with_these_i = ns_OMNI_i
              t1_OMNI_arr                = ns_OMNI_t1
              t2_OMNI_arr                = ns_OMNI_t2
           END
           KEYWORD_SET(mainPhase): BEGIN
              PRINTF,lun,'Restricting OMNI with main-phase indices ...'
              restrict_OMNI_with_these_i = mp_OMNI_i
              t1_OMNI_arr                = mp_OMNI_t1
              t2_OMNI_arr                = mp_OMNI_t2         
           END
           KEYWORD_SET(recoveryPhase): BEGIN
              PRINTF,lun,'Restricting OMNI with recovery-phase indices ...'
              restrict_OMNI_with_these_i = rp_OMNI_i
              t1_OMNI_arr                = rp_OMNI_t1
              t2_OMNI_arr                = rp_OMNI_t2
           END
        ENDCASE

        ;;Now fastLoc
        IF KEYWORD_SET(nEventPerMinPlot) OR KEYWORD_SET(probOccurrencePlot) $
           OR KEYWORD_SET(do_timeAvg_fluxQuantities) $
           OR KEYWORD_SET(nEventPerOrbPlot) $
           OR KEYWORD_SET(tHistDenominatorPlot) $
           OR KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) $
           OR KEYWORD_SET(div_fluxPlots_by_applicable_orbs) $
           OR KEYWORD_SET(tHist_mask_bins_below_thresh) $
           OR KEYWORD_SET(numOrbLim) $
        THEN BEGIN 

           GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
              COORDINATE_SYSTEM=coordinate_system, $
              USE_AACGM_COORDS=use_AACGM, $
              USE_MAG_COORDS=use_MAG, $
              SAMPLE_T_RESTRICTION=sample_t_restriction, $
              INCLUDE_32Hz=include_32Hz, $
              DISREGARD_SAMPLE_T=disregard_sample_t, $
              /GET_TIME_I_NOT_ALFDB_I, $
              DSTCUTOFF=dstCutoff, $
              SMOOTH_DST=smooth_dst, $
              USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
              EARLIEST_UTC=earliest_UTC, $
              LATEST_UTC=latest_UTC, $
              USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
              EARLIEST_JULDAY=earliest_julDay, $
              LATEST_JULDAY=latest_julDay, $
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
              GET_TIME_FOR_ESPEC_DBS=KEYWORD_SET(nonAlfven_flux_plots) OR KEYWORD_SET(nonAlfven__newellPlot_probOccurrence)
           
           
           CASE 1 OF
              KEYWORD_SET(nonStorm): BEGIN
                 PRINTF,lun,'Restricting fastLoc with non-storm indices ...'
                 restrict_with_these_FL_i = ns_FL_i
              END
              KEYWORD_SET(mainPhase): BEGIN
                 PRINTF,lun,'Restricting fastLoc with main-phase indices ...'
                 restrict_with_these_FL_i = mp_FL_i
              END
              KEYWORD_SET(recoveryPhase): BEGIN
                 PRINTF,lun,'Restricting fastLoc with recovery-phase indices ...'
                 restrict_with_these_FL_i = rp_FL_i
              END
           ENDCASE

        ENDIF

        ;;Now eSpecDB
        IF KEYWORD_SET(nonAlfven_flux_plots) OR KEYWORD_SET(nonAlfven__newellPlot_probOccurrence) THEN BEGIN 

           GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
              COORDINATE_SYSTEM=coordinate_system, $
              USE_AACGM_COORDS=use_AACGM, $
              USE_MAG_COORDS=use_MAG, $
              SAMPLE_T_RESTRICTION=sample_t_restriction, $
              INCLUDE_32Hz=include_32Hz, $
              DISREGARD_SAMPLE_T=disregard_sample_t, $
              /GET_ESPECDB_I_NOT_ALFDB_I, $
              ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
              ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
              ;; ESPEC__REDUCED_DB=reduce_dbSize, $
              DSTCUTOFF=dstCutoff, $
              SMOOTH_DST=smooth_dst, $
              USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
              EARLIEST_UTC=earliest_UTC, $
              LATEST_UTC=latest_UTC, $
              USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
              EARLIEST_JULDAY=earliest_julDay, $
              LATEST_JULDAY=latest_julDay, $
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
              KEYWORD_SET(nonStorm): BEGIN
                 restrict_with_these_eSpec_i = ns_eSpec_i
              END
              KEYWORD_SET(mainPhase): BEGIN
                 restrict_with_these_eSpec_i = mp_eSpec_i
              END
              KEYWORD_SET(recoveryPhase): BEGIN
                 restrict_with_these_eSpec_i = rp_eSpec_i
              END
           ENDCASE


        ENDIF

        CASE 1 OF
           KEYWORD_SET(nonStorm): BEGIN
              ;; PRINTF,lun,'Restricting with non-storm indices ...'
              stormString           = 'non-storm'
              t1_arr                = ns_t1
              t2_arr                = ns_t2
           END
           KEYWORD_SET(mainPhase): BEGIN
              ;; PRINTF,lun,'Restricting with main-phase indices ...'
              restrict_with_these_i = mp_i
              stormString           = 'mainPhase'
              t1_arr                = mp_t1
              t2_arr                = mp_t2
           END
           KEYWORD_SET(recoveryPhase): BEGIN
              ;; PRINTF,lun,'Restricting with recovery-phase indices ...'
              restrict_with_these_i = rp_i
              stormString           = 'recoveryPhase'
              t1_arr                = rp_t1
              t2_arr                = rp_t2
           END
        ENDCASE

        paramString          += '--' + stormString
        IF KEYWORD_SET(executing_multiples) THEN BEGIN
           FOR iMult=0,N_ELEMENTS(multiples)-1 DO BEGIN
              paramString_list[iMult] += '--' + stormString
           ENDFOR
        ENDIF
     ENDIF

     IF KEYWORD_SET(use_ae_stuff) THEN BEGIN

        IF ~KEYWORD_SET(no_maximus) THEN BEGIN
           GET_AE_FASTDB_INDICES, $
              DO_DESPUNDB=do_despunDB, $
              COORDINATE_SYSTEM=coordinate_system, $
              USE_AACGM_COORDS=use_AACGM, $
              USE_MAG_COORDS=use_MAG, $
              SAMPLE_T_RESTRICTION=sample_t_restriction, $
              INCLUDE_32Hz=include_32Hz, $
              DISREGARD_SAMPLE_T=disregard_sample_t, $
              GET_TIME_I_NOT_ALFDB_I=get_time_i_not_alfDB_I, $
              AECUTOFF=AEcutoff, $
              SMOOTH_AE=smooth_AE, $
              EARLIEST_UTC=earliest_UTC, $
              LATEST_UTC=latest_UTC, $
              USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
              EARLIEST_JULDAY=earliest_julDay, $
              LATEST_JULDAY=latest_julDay, $
              USE_AU=use_au, $
              USE_AL=use_al, $
              USE_AO=use_ao, $
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
              KEYWORD_SET(AE_high): BEGIN
                 PRINTF,lun,'Restricting maximus with high ' + navn + ' indices ...'
                 restrict_with_these_i = high_i
              END
              ELSE: BEGIN
                 PRINTF,lun,'Restricting maximus with low ' + navn + ' indices ...'
                 restrict_with_these_i = low_i
              END
           ENDCASE
        ENDIF

        ;;Now OMNI, if desired
        GET_AE_OMNIDB_INDICES, $
           OMNI_COORDS=OMNI_coords, $
           ;; RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
           ;; COORDINATE_SYSTEM=coordinate_system, $
           ;; USE_AACGM_COORDS=use_AACGM, $
           ;; USE_MAG_COORDS=use_MAG, $
           AECUTOFF=AEcutoff, $
           SMOOTH_AE=smooth_AE, $
           EARLIEST_UTC=earliest_UTC, $
           LATEST_UTC=latest_UTC, $
           USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
           EARLIEST_JULDAY=earliest_julDay, $
           LATEST_JULDAY=latest_julDay, $
           USE_AU=use_au, $
           USE_AL=use_al, $
           USE_AO=use_ao, $
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
           LOW_AE_T2=low_ae_t2, $
           LUN=lun


        CASE 1 OF
           KEYWORD_SET(AE_high): BEGIN
              PRINTF,lun,'Restricting OMNI with high ' + navn + ' indices ...'
              restrict_with_these_i = high_i
           END
           ELSE: BEGIN
              PRINTF,lun,'Restricting OMNI with low ' + navn + ' indices ...'
              restrict_with_these_i = low_i
           END
        ENDCASE

        ;;Now fastLoc
        IF KEYWORD_SET(nEventPerMinPlot) OR KEYWORD_SET(probOccurrencePlot) $
           OR KEYWORD_SET(do_timeAvg_fluxQuantities) $
           OR KEYWORD_SET(nEventPerOrbPlot) $
           OR KEYWORD_SET(tHistDenominatorPlot) $
           OR KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) $
           OR KEYWORD_SET(div_fluxPlots_by_applicable_orbs) $
           OR KEYWORD_SET(tHist_mask_bins_below_thresh) $
           OR KEYWORD_SET(numOrbLim) $
        THEN BEGIN 

           GET_AE_FASTDB_INDICES, $
              /GET_TIME_I_NOT_ALFDB_I, $
              DO_DESPUNDB=do_despunDB, $
              COORDINATE_SYSTEM=coordinate_system, $
              USE_AACGM_COORDS=use_AACGM, $
              USE_MAG_COORDS=use_MAG, $
              SAMPLE_T_RESTRICTION=sample_t_restriction, $
              INCLUDE_32Hz=include_32Hz, $
              DISREGARD_SAMPLE_T=disregard_sample_t, $
              AECUTOFF=AEcutoff, $
              SMOOTH_AE=smooth_AE, $
              EARLIEST_UTC=earliest_UTC, $
              LATEST_UTC=latest_UTC, $
              USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
              EARLIEST_JULDAY=earliest_julDay, $
              LATEST_JULDAY=latest_julDay, $
              USE_AU=use_au, $
              USE_AL=use_al, $
              USE_AO=use_ao, $
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
              LOW_AE_T2=low_ae_t2
           
           CASE 1 OF
              KEYWORD_SET(AE_high): BEGIN
                 PRINTF,lun,'Restricting fastLoc with high ' + navn + ' indices ...'
                 restrict_with_these_FL_i = high_FL_i
              END
              ELSE: BEGIN
                 PRINTF,lun,'Restricting fastLoc with low ' + navn + ' indices ...'
                 restrict_with_these_FL_i = low_FL_i
              END
           ENDCASE

        ENDIF

        CASE 1 OF
           KEYWORD_SET(AE_high): BEGIN
              t1_arr                = high_ae_t1
              t2_arr                = high_ae_t2
              AEstring              = 'high_' + navn
           END
           ELSE: BEGIN
              t1_arr                = low_ae_t1
              t2_arr                = low_ae_t2
              AEstring              = 'low_' + navn
           END
        ENDCASE

        paramString          += '--' + AEstring
        IF KEYWORD_SET(executing_multiples) THEN BEGIN
           FOR iMult=0,N_ELEMENTS(multiples)-1 DO BEGIN
              paramString_list[iMult] += '--' + AEString
           ENDFOR
        ENDIF


     ENDIF

     IF ~KEYWORD_SET(no_maximus) THEN BEGIN
        plot_i_list  = GET_RESTRICTED_AND_INTERPED_DB_INDICES( $
                       maximus,satellite,delay, $
                       DBTIMES=cdbTime, $
                       DBFILE=dbfile, $
                       LUN=lun, $
                       DO_CHASTDB=do_chastdb, $
                       DO_DESPUNDB=do_despunDB, $
                       COORDINATE_SYSTEM=coordinate_system, $
                       USE_AACGM_COORDS=use_AACGM, $
                       HEMI=hemi, $
                       ORBRANGE=orbRange, $
                       ALTITUDERANGE=altitudeRange, $
                       CHARERANGE=charERange, $
                       POYNTRANGE=poyntRange, $
                       SAMPLE_T_RESTRICTION=sample_t_restriction, $
                       INCLUDE_32HZ=include_32Hz, $
                       DISREGARD_SAMPLE_T=disregard_sample_t, $
                       DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
                       DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
                       MINMLT=minM,MAXMLT=maxM, $
                       BINM=binM, $
                       SHIFTM=shiftM, $
                       MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                       EQUAL_AREA_BINNING=EA_binning, $
                       DO_LSHELL=do_lshell, $
                       MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                       MIN_MAGCURRENT=minMC, $
                       MAX_NEGMAGCURRENT=maxNegMC, $
                       SMOOTH_IMF=smoothWindow, $
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
                       RESET_OMNI_INDS=reset_omni_inds, $
                       CLOCKSTR=clockStr, $
                       DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                       RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                       RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                       /DO_NOT_SET_DEFAULTS, $
                       BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                       MULTIPLE_DELAYS=multiple_delays, $
                       RESOLUTION_DELAY=delay_res, $
                       BINOFFSET_DELAY=binOffset_delay, $
                       MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                       STABLEIMF=stableIMF, $
                       DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                       OMNI_COORDS=omni_Coords, $
                       ANGLELIM1=angleLim1, $
                       ANGLELIM2=angleLim2, $
                       HWMAUROVAL=HwMAurOval, $
                       HWMKPIND=HwMKpInd, $
                       PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                       PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                       PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                       SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                       MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
                       OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
                       CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                       RESET_GOOD_INDS=reset_good_inds, $
                       NO_BURSTDATA=no_burstData, $
                       EARLIEST_UTC=earliest_UTC, $
                       LATEST_UTC=latest_UTC, $
                       USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
                       EARLIEST_JULDAY=earliest_julDay, $
                       LATEST_JULDAY=latest_julDay, $
                       DONT_LOAD_IN_MEMORY=KEYWORD_SET(nonAlfven_flux_plots) OR KEYWORD_SET(nonMem), $
                       TXTOUTPUTDIR=txtOutputDir)
     ENDIF                    
    
     IF KEYWORD_SET(nEventPerMinPlot) OR KEYWORD_SET(probOccurrencePlot) $
        ;; OR KEYWORD_SET(timeAvgd_pfluxPlot) OR KEYWORD_SET(timeAvgd_eFluxMaxPlot) $
        OR KEYWORD_SET(do_timeAvg_fluxQuantities) $
        OR KEYWORD_SET(nEventPerOrbPlot) $
        OR KEYWORD_SET(tHistDenominatorPlot) $
        OR KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) $
        OR KEYWORD_SET(div_fluxPlots_by_applicable_orbs) $
        OR KEYWORD_SET(tHist_mask_bins_below_thresh) $
        OR KEYWORD_SET(numOrbLim) $
     THEN BEGIN 
        do_fastLoc_i              = 1
     ENDIF

     for_eSpec_DBs = KEYWORD_SET(nonAlfven_flux_plots) OR KEYWORD_SET(nonAlfven__newellPlot_probOccurrence)
     IF KEYWORD_SET(do_fastLoc_i) THEN BEGIN
        fastLocInterped_i_list    = GET_RESTRICTED_AND_INTERPED_DB_INDICES( $
                                    KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc, $
                                    satellite, $
                                    delay, $
                                    LUN=lun, $
                                    DBTIMES=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times : FASTLOC__times, $
                                    DBFILE=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__dbFile : FASTLOC__dbFile, $
                                    COORDINATE_SYSTEM=coordinate_system, $
                                    USE_AACGM=use_AACGM, $
                                    USE_MAG_COORDS=use_MAG, $
                                    HEMI=hemi, $
                                    ORBRANGE=orbRange, $
                                    ALTITUDERANGE=altitudeRange, $
                                    CHARERANGE=charERange, $
                                    POYNTRANGE=poyntRange, $
                                    SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                    INCLUDE_32HZ=include_32Hz, $
                                    DISREGARD_SAMPLE_T=disregard_sample_t, $
                                    DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
                                    DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
                                    MINMLT=minM,MAXMLT=maxM, $
                                    BINM=binM, $
                                    SHIFTM=shiftM, $
                                    MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                    EQUAL_AREA_BINNING=EA_binning, $
                                    DO_LSHELL=do_lshell, $
                                    MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                    MIN_MAGCURRENT=minMC, $
                                    MAX_NEGMAGCURRENT=maxNegMC, $
                                    SMOOTH_IMF=smoothWindow, $
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
                                    RESET_OMNI_INDS=reset_omni_inds, $
                                    CLOCKSTR=clockStr, $
                                    DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                    RESTRICT_WITH_THESE_I=restrict_with_these_FL_i, $
                                    RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
                                    /DO_NOT_SET_DEFAULTS, $
                                    BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                    MULTIPLE_DELAYS=multiple_delays, $
                                    RESOLUTION_DELAY=delay_res, $
                                    BINOFFSET_DELAY=binOffset_delay, $
                                    MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                                    STABLEIMF=stableIMF, $
                                    DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                    OMNI_COORDS=omni_Coords, $
                                    ANGLELIM1=angleLim1, $
                                    ANGLELIM2=angleLim2, $
                                    HWMAUROVAL=HwMAurOval, $
                                    HWMKPIND=HwMKpInd, $
                                    ;;Don't do these for fastLoc, since it amounts to duplicated
                                    ;;effort
                                    ;; PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
                                    ;; PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
                                    ;; PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
                                    ;; SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
                                    ;; CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
                                    RESET_GOOD_INDS=reset_good_inds, $
                                    NO_BURSTDATA=no_burstData, $
                                    /GET_TIME_I_NOT_ALFVENDB_I, $
                                    GET_TIME_FOR_ESPEC_DBS=KEYWORD_SET(for_eSpec_DBs), $
                                    EARLIEST_UTC=earliest_UTC, $
                                    LATEST_UTC=latest_UTC, $
                                    USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
                                    EARLIEST_JULDAY=earliest_julDay, $
                                    LATEST_JULDAY=latest_julDay, $
                                    DONT_LOAD_IN_MEMORY=KEYWORD_SET(nonAlfven_flux_plots) OR KEYWORD_SET(nonMem))
     ENDIF

     IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN

        GET_NONALFVEN_FLUX_DATA,plot_i_list, $
                                ;; FOR_STORMS=KEYWORD_SET(nonStorm) OR KEYWORD_SET(mainPhase) OR KEYWORD_SET(recoveryPhase) ? stormString : !NULL, $
                                /FOR_IMF_SCREENING, $
                                NONALFVEN__JUNK_ALFVEN_CANDIDATES=nonAlfven__junk_alfven_candidates, $
                                NONALFVEN__ALL_FLUXES=nonalfven__all_fluxes, $
                                ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
                                ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
                                ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
                                NONALFVEN__NEWELLPLOT_PROBOCCURRENCE=nonAlfven__newellPlot_probOccurrence, $
                                DESPUN_ALF_DB=do_despunDB, $
                                ;; COORDINATE_SYSTEM=coordinate_system, $
                                USE_AACGM=use_AACGM, $
                                USE_MAG_COORDS=use_MAG, $
                                T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                EPLOTS=ePlots, $
                                EFLUXPLOTTYPE=eFluxPlotType, $
                                ENUMFLPLOTS=eNumFlPlots, $
                                ENUMFLPLOTTYPE=eNumFlPlotType, $
                                IONPLOTS=ionPlots, $
                                IFLUXPLOTTYPE=iFluxPlotType, $
                                DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                ESPEC_DELTA_T=eSpec_delta_t, $
                                ION_DELTA_T=ion_delta_t, $
                                OUT_EFLUX_DATA=eFlux_nonAlfven_data, $
                                OUT_ENUMFLUX_DATA=eNumFlux_nonAlfven_data, $
                                OUT_IFLUX_DATA=iFlux_nonAlfven_data, $
                                OUT_INUMFLUX_DATA=iNumFlux_nonAlfven_data, $
                                INDICES__NONALFVEN_ESPEC=indices__nonAlfven_eSpec_list, $
                                INDICES__NONALFVEN_ION=indices__nonAlfven_ion_list, $
                                ESPEC__MLTS=eSpec__mlts, $
                                ESPEC__ILATS=eSpec__ilats, $
                                ESPEC__INFO=eSpec_info, $
                                ION__MLTS=ion__mlts, $
                                ION__ILATS=ion__ilats, $
                                ION__INFO=ion_info, $
                                ORBRANGE=orbRange, $
                                ALTITUDERANGE=altitudeRange, $
                                CHARERANGE=charERange, $
                                CHARIERANGE=charIERange, $
                                SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                INCLUDE_32HZ=include_32Hz, $
                                DISREGARD_SAMPLE_T=disregard_sample_t, $
                                BOTH_HEMIS=both_hemis, $
                                NORTH=north, $
                                SOUTH=south, $
                                HEMI=hemi, $
                                HWMAUROVAL=HwMAurOval, $
                                HWMKPIND=HwMKpInd, $
                                MINMLT=minM, $
                                MAXMLT=maxM, $
                                BINM=binM, $
                                MINILAT=minI, $
                                MAXILAT=maxI, $
                                BINILAT=binI, $
                                EQUAL_AREA_BINNING=EA_binning, $
                                ;; DO_LSHELL=do_lshell, $
                                ;; MINLSHELL=minL, $
                                ;; MAXLSHELL=maxL, $
                                ;; BINLSHELL=binL, $
                                DAYSIDE=dayside, $
                                NIGHTSIDE=nightside, $
                                SATELLITE=satellite, $
                                SMOOTH_IMF=smoothWindow, $
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
                                RESET_OMNI_INDS=reset_omni_inds, $
                                CLOCKSTR=clockStr, $
                                DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                RESTRICT_WITH_THESE_ESPEC_I=restrict_with_these_eSpec_i, $
                                RESTRICT_WITH_THESE_ION_I=restrict_with_these_ion_i, $
                                /DO_NOT_SET_DEFAULTS, $
                                BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                DELAY=delay, $
                                MULTIPLE_DELAYS=multiple_delays, $
                                RESOLUTION_DELAY=delay_res, $
                                BINOFFSET_DELAY=binOffset_delay, $
                                MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                                STABLEIMF=stableIMF, $
                                DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                OMNI_COORDS=omni_Coords, $
                                ANGLELIM1=angleLim1, $
                                ANGLELIM2=angleLim2, $
                                ;; GET_ESPEC_I_NOT_ION_I=get_eSpec_i, $
                                RESET_GOOD_INDS=reset_good_inds, $
                                DONT_LOAD_IN_MEMORY=KEYWORD_SET(do_timeAvg_fluxQuantities) OR KEYWORD_SET(nonMem)

     ENDIF
     ;; PRINT,'Saving this session''s vars...'
     ;; SAVE,/VARIABLES,FILENAME=lastSessionFile
  ENDELSE   

  IF KEYWORD_SET(justInds) THEN BEGIN
     PRINT,'PLOT_ALFVEN_STATS_IMF_SCREENING: Finished! Returning indices ...'

     out_paramString_list        = TEMPORARY(paramString_list)
     saveStr = 'SAVE,out_paramString_list,'

     indsInfoStr = 'indsInfo'
     infoStr     = indsInfoStr + ' = CREATE_STRUCT('
     nInfo       = 0

     IF N_ELEMENTS(plot_i_list) GT 0 THEN BEGIN
        out_plot_i_list             = TEMPORARY(plot_i_list)
        saveStr += 'out_plot_i_list,'
        nInfo++
        infoStr += '"alfDB",maximus.info'
     ENDIF
     IF N_ELEMENTS(fastLocInterped_i_list) GT 0 THEN BEGIN
        out_fastLoc_i_list          = TEMPORARY(fastLocInterped_i_list)
        saveStr += 'out_fastLoc_i_list,'
        nInfo++
        infoStr += (nInfo GT 1 ? ',' : '') + '"fastLoc",fastLoc.info'
     ENDIF
     IF N_ELEMENTS(indices__nonAlfven_eSpec_list) GT 0 THEN BEGIN
        out_i_nonAlfven_eSpec_list  = indices__nonAlfven_eSpec_list
        saveStr += 'out_i_nonAlfven_eSpec_list,'
        nInfo++
        infoStr += (nInfo GT 1 ? ',' : '') + '"eSpec",eSpec_info'
     ENDIF
     IF N_ELEMENTS(indices__nonAlfven_ion_list) GT 0 THEN BEGIN
        out_i_nonAlfven_ion_list    = indices__nonAlfven_ion_list
        saveStr += 'out_i_nonAlfven_ion_list,'
        nInfo++
        infoStr += (nInfo GT 1 ? ',' : '') + '"ion",ion_info'
     ENDIF

     IF nInfo GT 0 THEN BEGIN
        infoStr += ')'
        bro = EXECUTE(infoStr)
        saveStr += indsInfoStr + ',indsInfoStr,'
     ENDIF

     IF KEYWORD_SET(justInds_saveToFile) THEN BEGIN
        saveDir = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/'

        IF SIZE(justInds_saveToFile,/TYPE) EQ 7 THEN BEGIN
           justIndsFile = justInds_saveToFile
        ENDIF ELSE BEGIN
           justIndsFile = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)+ '--OMNI_FAST--indices.sav'
        ENDELSE

        ;;Final blow
        saveStr += 'FILENAME="' + saveDir + justIndsFile + '"'

        PRINT,'Saving indices/paramStrings in directory ' + saveDir
        PRINT,'indsFile: ' + justIndsFile

        this = EXECUTE(saveStr)
        ;; SAVE,out_paramstring_list, $
        ;;      out_plot_i_list, $
        ;;      out_fastLoc_i_list, $        
        ;;      out_i_nonAlfven_eSpec_list, $
        ;;      out_i_nonAlfven_ion_list, $  
        ;;      FILENAME=saveDir+justIndsFile

        ;;Let others know
        PRINT,'DONE! Updating latest_OMNI_inds.txt ...'
        SPAWN,'echo ' + saveDir + justIndsFile + ' > ' + saveDir + 'latest_OMNI_inds.txt'

     ENDIF

     RETURN

  ENDIF

  ;;********************************************
  ;;Variables for histos
  ;;Bin sizes for 2d histos

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot lims
  SET_ALFVEN_STATS_PLOT_LIMS,EPLOTRANGE=EPlotRange, $
                             ENUMFLPLOTRANGE=ENumFlPlotRange, $
                             PPLOTRANGE=PPlotRange, $
                             CHAREPLOTRANGE=charePlotRange,CHARERANGE=charERange, $
                             CHARIEPLOTRANGE=chariEPlotRange, $
                             NEVENTPERMINRANGE=nEventPerMinRange, $
                             PROBOCCURRENCERANGE=probOccurrenceRange, $
                             THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                             NOWEPCO_RANGE=nowepco_range

  
  ;;********************************************
  ;;Now time for data summary

  IF ~KEYWORD_SET(no_maximus) THEN BEGIN
     PRINT_ALFVENDB_PLOTSUMMARY,maximus, $
                                plot_i_list, $
                                CLOCKSTR=clockStr, $
                                ANGLELIM1=angleLim1, $
                                ANGLELIM2=angleLim2, $
                                ORBRANGE=orbRange, $
                                ALTITUDERANGE=altitudeRange, $
                                CHARERANGE=charERange, $
                                minMLT=minM, $
                                maxMLT=maxM, $
                                BINMLT=binM, $
                                SHIFTMLT=shiftM, $
                                MINILAT=minI, $
                                MAXILAT=maxI, $
                                BINILAT=binI, $
                                EQUAL_AREA_BINNING=EA_binning, $
                                DO_LSHELL=do_lShell, $
                                MINLSHELL=minL, $
                                MAXLSHELL=maxL, $
                                BINLSHELL=binL, $
                                MIN_MAGCURRENT=minMC, $
                                MAX_NEGMAGCURRENT=maxNegMC, $
                                HWMAUROVAL=HwMAurOval, $
                                HWMKPIND=HwMKpInd, $
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
                                BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                PARAMSTRING=paramString, $
                                PARAMSTR_LIST=paramString_list, $
                                PARAMSTRPREFIX=plotPrefix, $
                                PARAMSTRSUFFIX=plotSuffix,$
                                SATELLITE=satellite, $
                                OMNI_COORDS=omni_Coords, $
                                HEMI=hemi, $
                                DELAY=delay, $
                                MULTIPLE_DELAYS=multiple_delays, $
                                MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                                STABLEIMF=stableIMF, $
                                SMOOTHWINDOW=smoothWindow, $
                                INCLUDENOCONSECDATA=includeNoConsecData, $
                                HOYDIA=hoyDia, $
                                MASKMIN=maskMin, $
                                LUN=lun
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Saving indices?
  IF KEYWORD_SET(save_alf_indices) AND ~KEYWORD_SET(no_maximus) THEN BEGIN
     IF N_ELEMENTS(paramString_list) GT 0 THEN BEGIN
        alfDB_ind_filename    = paramString_list.toArray() + '--' + 'alfDB_indices.sav'
     ENDIF ELSE BEGIN
        alfDB_ind_filename    = paramString + '--' + 'alfDB_indices.sav'
     ENDELSE
     alfDB_ind_fileDir     = plotDir + '../../saves_output_etc/'
     SAVE_ALFVENDB_INDICES,alfDB_ind_filename, $
                           alfDB_ind_fileDir, $
                           plot_i_list, $
                           CLOCKSTR=clockStr, $
                           ANGLELIM1=angleLim1, $
                           ANGLELIM2=angleLim2, $
                           ORBRANGE=orbRange, $
                           ALTITUDERANGE=altitudeRange, $
                           CHARERANGE=charERange, $
                           minMLT=minM, $
                           maxMLT=maxM, $
                           BINMLT=binM, $
                           SHIFTMLT=shiftM, $
                           MINILAT=minI, $
                           MAXILAT=maxI, $
                           BINILAT=binI, $
                           EQUAL_AREA_BINNING=EA_binning, $
                           DO_LSHELL=do_lShell, $
                           MINLSHELL=minL, $
                           MAXLSHELL=maxL, $
                           BINLSHELL=binL, $
                           MIN_MAGCURRENT=minMC, $
                           MAX_NEGMAGCURRENT=maxNegMC, $
                           HWMAUROVAL=HwMAurOval, $
                           HWMKPIND=HwMKpInd, $
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
                           BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                           PARAMSTRING=paramString, $
                           PARAMSTR_LIST=paramString_list, $
                           PARAMSTRPREFIX=plotPrefix, $
                           PARAMSTRSUFFIX=plotSuffix,$
                           SATELLITE=satellite, $
                           OMNI_COORDS=omni_Coords, $
                           HEMI=hemi, $
                           DELAY=delay, $
                           MULTIPLE_DELAYS=multiple_delays, $
                           MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                           STABLEIMF=stableIMF, $
                           SMOOTHWINDOW=smoothWindow, $
                           INCLUDENOCONSECDATA=includeNoConsecData, $
                           HOYDIA=hoyDia, $
                           MASKMIN=maskMin
  ENDIF

  ;;********************************************************
  ;;HISTOS

  tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                   MIN1=minM,MIN2=(KEYWORD_SET(DO_LSHELL) ? minL : minI),$
                                   MAX1=maxM,MAX2=(KEYWORD_SET(DO_LSHELL) ? maxL : maxI), $
                                   SHIFT1=shiftM,SHIFT2=shiftI, $
                                   EQUAL_AREA_BINNING=EA_binning, $
                                   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                   ;; DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                                   BOTH_HEMIS=STRUPCASE(hemi) EQ 'BOTH', $
                                   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                   CB_FORCE_OOBLOW=cb_force_oobLow)

  ;;Doing grossrates?
  IF KEYWORD_SET(do_grossRate_fluxQuantities) OR $
     KEYWORD_SET(do_grossRate_with_long_width) OR $
     KEYWORD_SET(grossRate_info_file) OR $
     KEYWORD_SET(show_integrals) OR $
     KEYWORD_SET(make_integral_txtfile) OR $
     KEYWORD_SET(make_integral_savfiles) $
  THEN grossRateMe = 1

  ;;Need area or length of each bin for gross rates
  IF KEYWORD_SET(grossRateMe) OR KEYWORD_SET(plotH2D_contour) THEN BEGIN
     IF KEYWORD_SET(do_grossRate_fluxQuantities) AND $
        KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        PRINTF,lun,"Can't do both types of gross rates simultaneously!!!"
        STOP
     ENDIF
     
     GET_H2D_BIN_AREAS,h2dAreas, $
                       CENTERS1=centersMLT,CENTERS2=centersILAT, $
                       BINSIZE1=binM*15.,BINSIZE2=binI, $
                       MAX1=maxM*15.,MAX2=maxI, $
                       MIN1=minM*15.,MIN2=minI, $
                       SHIFT1=shiftM*15.,SHIFT2=shiftI, $
                       EQUAL_AREA_BINNING=EA_binning

     IF KEYWORD_SET(EA_binning) THEN h2dAreas[*] = MEDIAN(h2dAreas)

     IF KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        GET_H2D_BIN_LENGTHS,h2dLongWidths, $
                            /LONGITUDINAL, $
                            CENTERS1=centersMLT,CENTERS2=centersILAT, $
                            BINSIZE1=binM*15., BINSIZE2=binI, $
                            MAX1=maxM*15.,MAX2=maxI, $
                            MIN1=minM*15.,MIN2=minI, $
                            SHIFT1=shiftM*15.,SHIFT2=shiftI, $
                            EQUAL_AREA_BINNING=EA_binning
     ENDIF
  ENDIF

  IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
     SETUP_GROSSRATE_INFO_FILE,grossRate_info_file, $
                               PARAMSTRING=paramString, $
                               TXTOUTPUTDIR=txtOutputDir, $
                               GROSSLUN=grossLun, $
                               LUN=lun
  ENDIF

  IF KEYWORD_SET(executing_multiples) THEN NIter = N_ELEMENTS(multiples) ELSE NIter = 1

  h2dStrArr_List                   = LIST()
  dataNameArr_List                 = LIST()
  dataRawPtrArr_List               = LIST()
  ;; FOR iMulti=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN
  FOR iMulti=0,NIter-1 DO BEGIN

     PRINT,'PLOT_ALFVEN_STATS_IMF_SCREENING: '+paramString_list[iMulti]

     IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
        PRINTF,grossLun,""
        PRINTF,grossLun,paramString_list[iMulti]
     ENDIF

     h2dStrArr                     = !NULL
     dataNameArr                   = !NULL
     dataRawPtrArr                 = !NULL

     IF KEYWORD_SET(indices__nonAlfven_ion_list) THEN BEGIN
        indices__nonAlfven_ion = indices__nonAlfven_ion_list[iMulti]
     ENDIF
     IF KEYWORD_SET(indices__nonAlfven_eSpec_list) THEN BEGIN
        indices__nonAlfven_eSpec   = indices__nonAlfven_eSpec_list[iMulti]
     ENDIF

     IF KEYWORD_SET(do_fastLoc_i) THEN BEGIN
        fastLocInterped_i          = fastLocInterped_i_list[iMulti]
     ENDIF

     GET_ALFVENDB_2DHISTOS, $
        maximus, $
        KEYWORD_SET(no_maximus) ? !NULL : plot_i_list[iMulti], $
        fastLocInterped_i, $
        CDBTIME=cdbTime, $
        H2DSTRARR=h2dStrArr, $
        KEEPME=keepMe, $
        DATARAWPTRARR=dataRawPtrArr, $
        DATANAMEARR=dataNameArr, $
        /DO_NOT_SET_DEFAULTS, $
        MINMLT=minM, $
        MAXMLT=maxM, $
        BINMLT=binM, $
        SHIFTMLT=shiftM, $
        MINILAT=minI, $
        MAXILAT=maxI, $
        BINILAT=binI, $
        EQUAL_AREA_BINNING=EA_binning, $
        USE_AACGM_COORDS=use_AACGM, $
        DO_LSHELL=do_lShell, $
        MINLSHELL=minL, $
        MAXLSHELL=maxL, $
        BINLSHELL=binL, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        POYNTRANGE=poyntRange, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        DISREGARD_SAMPLE_T=disregard_sample_t, $
        NUMORBLIM=numOrbLim, $
        MASKMIN=maskMin, $
        THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
        HEMI=hemi, $
        NPLOTS=nPlots, $
        NEVENTSPLOTRANGE=nEventsPlotRange, $
        LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
        ABSEFLUX=abseflux, $
        NOPOSEFLUX=noPosEFlux, $
        NONEGEFLUX=noNegEflux, EPLOTRANGE=EPlotRange, $
        ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
        LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
        NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
        AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
        NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
        NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
        NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
        NEWELL__COMBINE_ACCELERATED=Newell__comb_accelerated, $
        EFLUX_NONALFVEN_DATA=eFlux_nonAlfven_data, $
        ENUMFLUX_NONALFVEN_DATA=eNumFlux_nonAlfven_data, $
        IFLUX_NONALFVEN_DATA=iFlux_nonAlfven_data, $
        INUMFLUX_NONALFVEN_DATA=iNumFlux_nonAlfven_data, $
        INDICES__NONALFVEN_ESPEC=indices__nonAlfven_eSpec, $
        INDICES__NONALFVEN_ION=indices__nonAlfven_ion, $
        NONALFVEN__NO_MAXIMUS=no_maximus, $
        NONALFVEN__JUNK_ALFVEN_CANDIDATES=nonAlfven__junk_alfven_candidates, $
        NONALFVEN__ALL_FLUXES=nonalfven__all_fluxes, $
        ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
        ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
        ;; FOR_ESPEC_DB=for_eSpec_DB, $
        ESPEC__MLTS=eSpec__mlts, $
        ESPEC__ILATS=eSpec__ilats, $
        ;; FOR_ION_DB=for_ion_DB, $
        ION__MLTS=ion__mlts, $
        ION__ILATS=ion__ilats, $
        ESPEC_DELTA_T=eSpec_delta_t, $
        ION_DELTA_T=ion_delta_t, $
        PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
        NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
        IONPLOTS=ionPlots, $
        IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
        NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
        OXYPLOTS=oxyPlots, $
        OXYFLUXPLOTTYPE=oxyFluxPlotType, $
        LOGOXYFPLOT=logOxyfPlot, $
        ABSOXYFLUX=absOxyFlux, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        OXYPLOTRANGE=oxyPlotRange, $
        CHAREPLOTS=charEPlots, CHARETYPE=charEType, $
        LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
        NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
        CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
        NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
        AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
        FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
        FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
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
        PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        THISTDENOMINATORPLOT=tHistDenominatorPlot, $
        THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
        THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
        THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
        THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
        NEWELLPLOTS=newellPlots, $
        NEWELL_PLOTRANGE=newell_plotRange, $
        LOG_NEWELLPLOT=log_newellPlot, $
        NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
        NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
        NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
        NONALFVEN__NEWELLPLOT_PROBOCCURRENCE=nonAlfven__newellPlot_probOccurrence, $
        NONALFVEN__NEWELL_PLOTRANGE=nonalfven__newell_plotRange, $
        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
        TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
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
        MEDIANPLOT=medianPlot, MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
        LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots,$
        PARAMSTRING=paramString_list[iMulti], $
        PARAMSTRPREFIX=plotPrefix, $
        PARAMSTRSUFFIX=plotSuffix, $
        TMPLT_H2DSTR=tmplt_h2dStr, $
        RESET_GOOD_INDS=reset_good_inds, $
        RESET_OMNI_INDS=reset_omni_inds, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        TXTOUTPUTDIR=txtOutputDir, $
        LUN=lun

     h2dStrArr_List.add,h2dStrArr
     dataNameArr_list.add,dataNameArr
     dataRawPtrArr_list.add,dataRawPtrArr
  ENDFOR

  IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
     CLOSE_GROSSRATE_INFO_FILE,grossRate_info_file,grossLun
  ENDIF


  IF KEYWORD_SET(executing_multiples) AND KEYWORD_SET(group_like_plots_for_tiling) THEN BEGIN
     REARRANGE_H2DSTRARR_LIST_INTO_LIKE_PLOTS, $
        h2dStrArr_list, $
        dataNameArr_list, $
        dataRawPtrArr_list, $
        paramString_list, $
        HAS_NPLOTS=nplots, $
        NEW_PARAMSTR_FOR_LIKE_PLOTARRS=multiString, $
        SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
        DO_REARRANGE_DATARAWPTRARR_LIST=do_rearrange_dataRawPtrArr_list, $
        ADJ_UPPER_PLOTLIM_IF_NTH_MAX_IS_GREATER=adj_upper_plotlim_thresh, $
        ADJ_LOWER_PLOTLIM_IF_NTH_MIN_IS_GREATER=adj_lower_plotlim_thresh, $
        OUT_MASK_H2DSTRARR=h2dMaskArr
  ENDIF

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
     plot_i               = N_ELEMENTS(plot_i_list) GT 0 ? plot_i_list[iList] : !NULL
     paramString          = paramString_list[iList]

     IF ~KEYWORD_SET(group_like_plots_for_tiling) THEN BEGIN
        ;;Shift the way we historically have
        h2dStrArr         = SHIFT(h2dStrArr,-1-(nPlots))
        IF keepMe THEN BEGIN 
           dataNameArr    = SHIFT(dataNameArr,-1-(nPlots)) 
           dataRawPtrArr  = SHIFT(dataRawPtrArr,-1-(nPlots)) 
        ENDIF
        
        ;; h2dStrArr_list[iList]         = SHIFT(h2dStrArr_List[iList],-1-(nPlots))
        ;; IF keepMe THEN BEGIN 
        ;;    dataNameArr_list[iList]    = SHIFT(dataNameArr_list[iList],-2) 
        ;;    dataRawPtrArr_list[iList]  = SHIFT(dataRawPtrArr_list[iList],-2) 
        ;; ENDIF
     ENDIF

     IF N_ELEMENTS(squarePlot) EQ 0 THEN BEGIN
        SAVE_ALFVENDB_TEMPDATA, $
           H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,$
           MAXM=maxM,MINM=minM,MAXI=maxI,MINI=minI, $
           BINM=binM, $
           SHIFTM=shiftM, $
           BINI=binI, $
           DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell,$
           MINL=minL,MAXL=maxL,BINL=binL,$
           RAWDIR=rawDir,PARAMSTR=paramString,$
           CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg, $
           STABLEIMF=stableIMF,HOYDIA=hoyDia,HEMI=hemi, $
           OUT_TEMPFILE=out_tempFile
     ENDIF

     ;;Now plots
     IF ~KEYWORD_SET(justData) THEN BEGIN
        PLOT_ALFVENDB_2DHISTOS,H2DSTRARR=h2dStrArr, $
                               DATANAMEARR=dataNameArr, $
                               H2DMASKARR=h2dMaskArr, $
                               TEMPFILE=out_tempFile, $
                               EQUAL_AREA_BINNING=EA_binning, $
                               SQUAREPLOT=squarePlot, $
                               POLARCONTOUR=polarContour, $ 
                               JUSTDATA=justData, $
                               SHOWPLOTSNOSAVE=showPlotsNoSave, $
                               PLOTDIR=plotDir, $
                               PLOTMEDORAVG=plotMedOrAvg, $
                               PARAMSTR=paramString, $
                               ORG_PLOTS_BY_FOLDER=org_plots_by_folder, $
                               DEL_PS=del_PS, $
                               HEMI=hemi, $
                               CLOCKSTR=clockStr, $
                               SUPPRESS_THICKGRID=suppress_thickGrid, $
                               SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                               SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
                               SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
                               SUPPRESS_MLT_NAME=suppress_MLT_name, $
                               SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
                               SUPPRESS_TITLES=suppress_titles, $
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
                               PLOTH2D_CONTOUR=plotH2D_contour, $
                               CENTERS_MLT=centersMLT, $
                               CENTERS_ILAT=centersILAT, $
                               SHOW_INTEGRALS=show_integrals, $
                               MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
                               MAKE_INTEGRAL_SAVFILE=make_integral_savfiles, $
                               INTEGRALSAVFILEPREF=integralSavFilePref, $
                               TXTOUTPUTDIR=txtOutputDir, $
                               _EXTRA = e
     ENDIF

     IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
        CLOSE,lun 
        FREE_LUN,lun 
     ENDIF

     ;;Save raw data, if desired
     IF KEYWORD_SET(saveRaw) THEN BEGIN
        SAVE, /ALL, filename=rawDir+'fluxplots_'+paramString+".dat"

     ENDIF

     WRITE_ALFVENDB_2DHISTOS, $
        MAXIMUS=maximus,PLOT_I=plot_i, $
        WRITEHDF5=writeHDF5,WRITEPROCESSEDH2D=WRITEPROCESSEDH2D,WRITEASCII=writeASCII, $
        H2DSTRARR=h2dStrArr,DATARAWPTRARR=dataRawPtrArr,DATANAMEARR=dataNameArr, $
        PARAMSTR=paramString, $
        TXTOUTPUTDIR=txtOutputDir

     tempFile_list.add,out_tempFile
  ENDFOR

  out_tempFile_list      = tempFile_list
  out_dataNameArr_list   = dataNameArr_list
  out_paramString_list   = paramString_list
  out_plot_i_list        = N_ELEMENTS(plot_i_list) GT 0 ? plot_i_list : !NULL

END