;;11/30/16
;SAVE,stableIMF,smoothWindow,fastLocInterped_i,keepme,minM,maxM,binM,shiftM,minI,maxI,binI,EA_binning,orbRange,altitudeRange,charERange,disregard_sample_t,maskMin,tHist_mask_bins_below_thresh,hemi,ePlots,nonegeflux,eplotrange,enumflplots,logenumflplot,nonegenumfl,enumflplotrange,newell_analyze_eFlux,newell__comb_accelerated,eflux_nonalfven_data,enumflux_nonalfven_data,indices__nonAlfven_eSpec,no_maximus,nonAlfven__all_fluxes,eSpec__Newell_2009_interp,eSpec__mlts,eSpec__ilats,eSpec_delta_t,tHistDenominatorPlot,tHIstDenomPlotRange,tHistDenomPlotAutoscale,tHistDenomPlot_noMask,newellPlots,nonAlfven__newellPlot_probOccurrence,nonAlfven__newell_plotRange,do_timeAvg_fluxQuantities,h2dAreas,show_integrals,centersMLT,centersILAT,write_obsArr_textFile,write_obsArr__inc_IMF,write_obsArr__orb_avg_obs,tmplt_h2dStr,reset_good_inds,reset_OMNI_inds,plotDir,txtOutputDir,FILENAME='/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/TEMP--newellDB--duskwardIMF.sav'
PRO JOURNAL__20161130__DIAGNOSING_WHY_NEWELLDB_CANT_OUTPUT_ORB_SUMMARY

  COMPILE_OPT IDL2

  ;;NOTE, you must manually set breakpoint in PLOT_ALFVEN_STATS_IMF_SCREENING to save indices
  create_indices = 0

  IF ~KEYWORD_SET(create_indices) THEN BEGIN

     reset_omni_inds = 1
     stableIMF = 2
     smoothWindow = 5

     savFile = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/TEMP--newellDB--duskwardIMF.sav'

     ;; eFluxPlotType                  = 'Max'
     eFluxPlotType                  = 'eFlux_nonAlfven--2009_interp'
     
     ePlotRange                     = [0,0.20]
     logEfPlot                      = 0
     ;; noNegEflux                     = 0
     ;; ePlotRange                     = [1e-3,1e1]
     ;; logEfPlot                      = 1
     noNegEflux                     = 1

     eNumFlPlotType                 = ['eNumFlux_nonAlfven--2009_interp']
     ;; noNegENumFl                    = [1,1]
     ;; logENumFlPlot               = [1,1]
     ;; ENumFlPlotRange             = [[5e-2,5e1], $
     ;;                             [1e7,1e10]]
     logENumFlPlot                  = [0]
     ENumFlPlotRange                = [[0,5.0e8]]

     h2dStrArr_List                   = LIST()
     dataNameArr_List                 = LIST()
     dataRawPtrArr_List               = LIST()
     iMulti                           = 0
     paramString_list                 = LIST('duskward_IMF--diagnose_NewellDB_output')


     ;;Code for generating the savefile is after the end of the pro
     PRINT,'Restoring ' + savFile + ' ...'
     RESTORE,savFile

     newell__comb_accelerated         = 0

     junk = GET_STABLE_IMF_INDS( $
            MAG_UTC=mag_utc, $
            CLOCKSTR=clockStr, $
            ANGLELIM1=angleLim1, $
            ANGLELIM2=angleLim2, $
            DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
            STABLEIMF=stableIMF, $
            SMOOTH_IMF=smooth_IMF, $
            ;; RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
            EARLIEST_UTC=earliest_UTC, $
            LATEST_UTC=latest_UTC, $
            USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
            EARLIEST_JULDAY=earliest_julDay, $
            LATEST_JULDAY=latest_julDay, $
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
            RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
            RESET_OMNI_INDS=reset_omni_inds, $
            ;; GET_BX=get_Bx, $
            ;; GET_BY=get_By, $
            ;; GET_BZ=get_Bz, $
            ;; GET_BT=get_Bt, $
            GET_THETACONE=get_thetaCone, $
            GET_CLOCKANGLE=get_clockAngle, $
            GET_CONE_OVERCLOCK=get_cone_overClock, $
            GET_BXY_OVER_BZ=get_Bxy_over_Bz, $
            BX_OUT=bx_out,$
            BY_OUT=by_out,$
            BZ_OUT=bz_out,$
            BT_OUT=bt_out,$
            THETACONE_OUT=thetaCone_out, $
            CLOCKANGLE_OUT=clockAngle_out, $
            CONE_OVERCLOCK_OUT=cone_overClock_out, $
            BXY_OVER_BZ_OUT=Bxy_over_Bz_out, $
            OMNI_COORDS=OMNI_coords, $
            OMNI_PARAMSTR=omni_paramStr, $
            PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
            PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
            PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
            SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
            MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
            OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
            CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
            LUN=lun, $
            TXTOUTPUTDIR=txtOutputDir)

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
  ENDIF ELSE BEGIN

     restore_last_session           = 0

     nonstorm                       = 1
     DSTcutoff                      = -25
     smooth_dst                     = 5
     use_mostRecent_Dst_files       = 1
     plotPref                       = 'Dst_' + STRCOMPRESS(DSTcutoff,/REMOVE_ALL) + '_'
     IF KEYWORD_SET(smooth_dst) THEN BEGIN
        CASE smooth_dst OF
           1: plotPref += 'sm--'
           ELSE: plotPref += 'sm_' + STRCOMPRESS(smooth_dst,/REMOVE_ALL)+'hr-'
        ENDCASE
     ENDIF

     FOR_BUFF_BTMIN                 = 1

     ;; include_32Hz                   = 
     ;; sample_t_restriction           = 10
     disregard_sample_t             = 1

     show_integrals                 = 1

     write_obsArr_textFile          = 1
     write_obsArr__inc_IMF          = 1
     write_obsArr__orb_avg_obs      = 1
     justData                       = 0

     EA_binning                     = 0
     plotH2D_contour                = 1

     ;; minMC                          = 5
     ;; maxNegMC                       = -5

     do_timeAvg_fluxQuantities      = 1
     logAvgPlot                     = 0
     medianPlot                     = 0
     divide_by_width_x              = 1

     ;;DB stuff
     do_despun                      = 0
     use_AACGM                      = 0
     use_MAG                        = 0

     ;; plotPref                       = 

     autoscale_fluxPlots            = 0
     fluxPlots__remove_outliers     = 0
     fluxPlots__remove_log_outliers = 0
     
     group_like_plots_for_tiling    = 1
     scale_like_plots_for_tiling    = 0
     adj_upper_plotlim_thresh       = 3 ;;Check third maxima
     adj_lower_plotlim_thresh       = 2 ;;Check minima

     tile__include_IMF_arrows       = 0
     tile__cb_in_center_panel       = 1
     cb_force_oobHigh               = 1

     suppress_gridLabels            = [0,1,1, $
                                       1,1,1, $
                                       1,1,1]

     ;;bonus
     print_avg_imf_components       = 0
     print_master_OMNI_file         = 0
     save_master_OMNI_inds          = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;The plots
     no_maximus                     = 1
     nonAlfven_flux_plots           = 1
     Newell_analyze_eFlux           = 1
     nonalfven__all_fluxes          = 1
     Newell__comb_accelerated       = 1

     eSpec__Newell_2009_interp      = 1
     eSpec__use_2000km_file         = 0
     eSpec__remove_outliers         = 0

     newellplots                    = 1
     newellPlot_autoscale           = 1

     ePlots                         = 1
     eNumFlPlots                    = 1
     pPlots                         = 0
     ionPlots                       = 0
     probOccurrencePlot             = 0

     tHistDenominatorPlot           = 1
     ;; tHistDenomPlotRange  = 
     ;; tHistDenomPlotNormalize        = 0
     tHistDenomPlotAutoscale        = 1
     tHistDenomPlot_noMask          = 1

     sum_electron_and_poyntingflux  = 0
     nOrbsWithEventsPerContribOrbsPlot = 0
     nonAlfven__newellPlot_probOccurrence = 1
     nonalfven__newell_plotRange    = [[0,0.25],[0,0.15],[0.6,1.0]]

     nowepco_range                  = [0,1.0]

     ;;e- energy flux
     ;; eFluxPlotType                  = 'Eflux_losscone_integ'
     eFluxPlotType                  = 'Max'
     ePlotRange                     = [0,0.20]
     logEfPlot                      = 0
     ;; noNegEflux                     = 0
     ;; ePlotRange                     = [1e-3,1e1]
     ;; logEfPlot                      = 1
     noNegEflux                     = 1

     eNumFlPlotType                 = ['Eflux_Losscone_Integ','ESA_Number_flux']
     ;; noNegENumFl                    = [1,1]
     ;; logENumFlPlot               = [1,1]
     ;; ENumFlPlotRange             = [[5e-2,5e1], $
     ;;                             [1e7,1e10]]
     logENumFlPlot                  = [0,0]
     ENumFlPlotRange                = [[0,0.20], $
                                       [0,5.0e8]]
     ;; eNumFlPlotType                 = 'ESA_Number_flux'
     ;; noNegENumFl                    = 0
     ;; logENumFlPlot                  = 0
     ;; ENumFlPlotRange                = [0,2e9]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Southern hemi ranges
     ;; ePlotRange                     = [0,0.25]

     ;; noNegENumFl                    = [1,1]
     ;; logENumFlPlot                  = [0,0]
     ;; ENumFlPlotRange                = [[0,0.25], $
     ;;                                   [0,8.0e8]]

     IF KEYWORD_SET(FOR_BUFF_BTMIN) THEN BEGIN
        ePlotRange                     = [0,0.40]
        logEfPlot                      = 0

        noNegEflux                     = 1

        logENumFlPlot                  = [0,0]
        ENumFlPlotRange                = [[0,0.20], $
                                          [0,5.0e8]]
        
     ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Tiled plot options

     ;; altRange                    = [[340,1180], $
     ;;                             [1180,2180], $
     ;;                             [2180,3180], $
     ;;                             [3180,4180]]

     altRange                       = [[300,4300]]
     ;; altRange                       = [[300,2000]]

     IF KEYWORD_SET(eSpec__use_2000km_file) THEN BEGIN
        altRange                    = [300,2000]
     ENDIF

     orbRange                       = [1000,10600]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;IMF condition stuff--run the ring!
     btMin                          = 1.5
     ;; btMax                       = 5

     smoothWindow                   = 7

     stableIMF                      = 2

     ;;Delay stuff
     nDelays                        = 1
     delayDeltaSec                  = 1800
     binOffset_delay                = 0
     delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec

     reset_omni_inds                = 1
     reset_good_inds                = 1
     
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;ILAT stuff
     hemi                           = 'NORTH'
     minILAT                        = 60
     maxILAT                        = 90
     ;; maskMin                        = 5
     ;; tHist_mask_bins_below_thresh   = 1
     ;; numOrbLim                      = 5

     ;; hemi                           = 'SOUTH'
     ;; minILAT                        = -90
     ;; maxILAT                        = -60
     ;; maskMin                        =  1
     tHist_mask_bins_below_thresh   = 2

     ;; numOrbLim                      = 10

     ;; binILAT                     = 2.0
     binILAT                        = 2.5

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;MLT stuff
     binMLT                         = 1.0
     shiftMLT                       = 0.0

     ;; minMLT                      = 6
     ;; maxMLT                      = 18

     ;;Bonus

     FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
        altitudeRange               = altRange[*,i]
        altStr                      = STRING(FORMAT='(I0,"-",I0,"km-orbs_",I0,"-",I0)', $
                                             altitudeRange[0], $
                                             altitudeRange[1], $
                                             orbRange[0], $
                                             orbRange[1])
        plotPrefix = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

        ;; SETUP_TO_RUN_ALL_CLOCK_ANGLES,multiple_IMF_clockAngles,clockStrings, $
        ;;                               angleLim1,angleLim2, $
        ;;                               IMFStr,IMFTitle, $
        ;;                               BYMIN=byMin, $
        ;;                               BYMAX=byMax, $
        ;;                               BZMIN=bzMin, $
        ;;                               BZMAX=bzMax, $
        ;;                               BTMIN=btMin, $
        ;;                               BTMAX=btMax, $
        ;;                               BXMIN=bxMin, $
        ;;                               BXMAX=bxMax, $
        ;;                               /AND_TILING_OPTIONS, $
        ;;                               GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
        ;;                               TILE_IMAGES=tile_images, $
        ;;                               TILING_ORDER=tiling_order, $
        ;;                               N_TILE_COLUMNS=n_tile_columns, $
        ;;                               N_TILE_ROWS=n_tile_rows, $
        ;;                               TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
        ;;                               TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
        ;;                               TILEPLOTSUFF=plotSuff


        multiple_IMF_clockAngles = 0
        clockStrings             = ['duskward']
        angleLim1       = 67.5
        angleLim2       = 112.5  
        IMFStr          = '3--duskward'
        IMFTitle        = 'Duskward'
        
        PLOT_ALFVEN_STATS_IMF_SCREENING, $
           CLOCKSTR=clockStrings, $
           MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
           SAMPLE_T_RESTRICTION=sample_t_restriction, $
           INCLUDE_32HZ=include_32Hz, $
           DISREGARD_SAMPLE_T=disregard_sample_t, $
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
           DSTCUTOFF=dstCutoff, $
           SMOOTH_DST=smooth_dst, $
           USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
           NPLOTS=nPlots, $
           EPLOTS=ePlots, $
           EPLOTRANGE=ePlotRange, $                                       
           EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
           ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
           ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
           LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
           NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
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
           NONALFVEN__NEWELLPLOT_PROBOCCURRENCE=nonAlfven__newellPlot_probOccurrence, $
           NONALFVEN__NEWELL_PLOTRANGE=nonalfven__newell_plotRange, $
           PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
           NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
           IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, $
           LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
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
           NEWELLPLOTS=newellPlots, $
           NEWELL_PLOTRANGE=newell_plotRange, $
           LOG_NEWELLPLOT=log_newellPlot, $
           NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
           NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
           NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
           TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
           TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
           LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
           TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
           TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
           LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
           DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
           DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
           WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
           WRITE_ORB_AND_OBS__INC_IMF=write_obsArr__inc_IMF, $
           WRITE_ORB_AND_OBS__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
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
           CHASTDB=chastDB, $
           DESPUNDB=despun, $
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
           ADJ_UPPER_PLOTLIM=adj_upper_plotlim_thresh, $
           ADJ_LOWER_PLOTLIM=adj_lower_plotlim_thresh, $
           TILE_IMAGES=tile_images, $
           N_TILE_ROWS=n_tile_rows, $
           N_TILE_COLUMNS=n_tile_columns, $
           ;; TILEPLOTSUFFS=tilePlotSuffs, $
           TILING_ORDER=tiling_order, $
           TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
           TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
           TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
           TILEPLOTTITLE=tilePlotTitle, $
           NO_COLORBAR=no_colorbar, $
           CB_FORCE_OOBHIGH=cb_force_oobHigh, $
           CB_FORCE_OOBLOW=cb_force_oobLow, $
           PLOTH2D_CONTOUR=plotH2D_contour, $
           /MIDNIGHT, $
           FANCY_PLOTNAMES=fancy_plotNames, $
           SHOW_INTEGRALS=show_integrals, $
           RESTORE_LAST_SESSION=restore_last_session, $
           _EXTRA=e
        
     ENDFOR
  ENDELSE
END

