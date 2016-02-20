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
;                    DIVNEVBYAPPLICABLE:  Divide number of events in given bin by the number of orbits occurring 
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
                                    CLOCKSTR=clockStr, $
                                    RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                    ANGLELIM1=angleLim1, $
                                    ANGLELIM2=angleLim2, $
                                    ORBRANGE=orbRange, $
                                    ALTITUDERANGE=altitudeRange, $
                                    CHARERANGE=charERange, $
                                    POYNTRANGE=poyntRange, $
                                    NUMORBLIM=numOrbLim, $
                                    MINMLT=minM,MAXMLT=maxM, $
                                    BINMLT=binM, $
                                    SHIFTMLT=shiftM, $
                                    MINILAT=minI,MAXILAT=maxI, $
                                    BINILAT=binI, $
                                    DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                    MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                    HWMAUROVAL=HwMAurOval, $
                                    HWMKPIND=HwMKpInd, $
                                    MIN_NEVENTS=min_nEvents, $
                                    MASKMIN=maskMin, $
                                    BYMIN=byMin, $
                                    BZMIN=bzMin, $
                                    BYMAX=byMax, $
                                    BZMAX=bzMax, $
                                    DO_ABS_BYMIN=abs_byMin, $
                                    DO_ABS_BYMAX=abs_byMax, $
                                    DO_ABS_BZMIN=abs_bzMin, $
                                    DO_ABS_BZMAX=abs_bzMax, $
                                    SATELLITE=satellite, $
                                    OMNI_COORDS=omni_Coords, $
                                    HEMI=hemi, $
                                    NORTH=north, $
                                    SOUTH=south, $
                                    BOTH_HEMIS=both_hemis, $
                                    DELAY=delay, $
                                    MULTIPLE_DELAYS=multiple_delays, $
                                    STABLEIMF=stableIMF, $
                                    SMOOTHWINDOW=smoothWindow, $
                                    INCLUDENOCONSECDATA=includeNoConsecData, $
                                    DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
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
                                    CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                    NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                    CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                                    NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
                                    ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                    ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                    NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                    DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                    NEVENTPERMINPLOT=nEventPerMinPlot, NEVENTPERMINRANGE=nEventPerMinRange, LOGNEVENTPERMIN=logNEventPerMin, $
                                    PROBOCCURRENCEPLOT=probOccurrencePlot, $
                                    PROBOCCURRENCERANGE=probOccurrenceRange, $
                                    LOGPROBOCCURRENCE=logProbOccurrence, $
                                    TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                                    TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                    LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                                    MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                    ALL_LOGPLOTS=all_logPlots, $
                                    SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                    DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, $
                                    DO_CHASTDB=do_chastDB, $
                                    DO_DESPUNDB=do_despunDB, $
                                    NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                    WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                    SAVERAW=saveRaw, RAWDIR=rawDir, $
                                    JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                    PLOTDIR=plotDir, $
                                    PLOTPREFIX=plotPrefix, $
                                    PLOTSUFFIX=plotSuffix, $
                                    MEDHISTOUTDATA=medHistOutData, $
                                    MEDHISTOUTTXT=medHistOutTxt, $
                                    OUTPUTPLOTSUMMARY=outputPlotSummary, $
                                    DEL_PS=del_PS, $
                                    EPS_OUTPUT=eps_output, $
                                    OUT_TEMPFILE_LIST=out_tempFile_list, $
                                    OUT_DATANAMEARR_list=out_dataNameArr_list, $
                                    NO_COLORBAR=no_colorbar, $
                                    CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                    CB_FORCE_OOBLOW=cb_force_oobLow, $
                                    FANCY_PLOTNAMES=fancy_plotNames, $
                                    _EXTRA = e
  
;;  COMPILE_OPT idl2

  !EXCEPT=0                                                      ;Do report errors, please

  IF KEYWORD_SET(do_not_consider_IMF) THEN  BEGIN
     SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
  ENDIF ELSE BEGIN
     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  ENDELSE

  SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                             MINMLT=minM,MAXMLT=maxM, $
                             BINMLT=binM, $
                             SHIFTMLT=shiftM, $
                             MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                             MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                             HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                             MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
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
                             ORBCONTRIBPLOT=orbContribPlot, $
                             ORBTOTPLOT=orbTotPlot, $
                             ORBFREQPLOT=orbFreqPlot, $
                             NEVENTPERORBPLOT=nEventPerOrbPlot, $
                             NEVENTPERMINPLOT=nEventPerMinPlot, $
                             PROBOCCURRENCEPLOT=probOccurrencePlot, $
                             SQUAREPLOT=squarePlot, $
                             POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                             MEDIANPLOT=medianPlot, $
                             LOGAVGPLOT=logAvgPlot, $
                             PLOTMEDORAVG=plotMedOrAvg, $
                             DATADIR=dataDir, NO_BURSTDATA=no_burstData, $
                             WRITEASCII=writeASCII, $
                             WRITEHDF5=writeHDF5, $
                             WRITEPROCESSEDH2D=writeProcessedH2d, $
                             SAVERAW=saveRaw, RAWDIR=rawDir, $
                             SHOWPLOTSNOSAVE=showPlotsNoSave, $
                             PLOTDIR=plotDir, $
                             MEDHISTOUTDATA=medHistOutData, $
                             MEDHISTOUTTXT=medHistOutTxt, $
                             OUTPUTPLOTSUMMARY=outputPlotSummary, $
                             ;; OUT_TEMPFILE=out_tempFile, $
                             PRINT_ALFVENDB_2DHISTOS=print_alfvendb_2dhistos, $
                             DEL_PS=del_PS, $
                             KEEPME=keepMe, $
                             PARAMSTRING=paramString, $
                             PARAMSTRPREFIX=plotPrefix, $
                             PARAMSTRSUFFIX=plotSuffix,$
                             HOYDIA=hoyDia,LUN=lun,_EXTRA=e
  
  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, $
                                  ANGLELIM1=angleLim1, $
                                  ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, $
                                  ALTITUDERANGE=altitudeRange, $
                                  CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  BZMIN=bzMin, $
                                  BYMAX=byMax, $
                                  BZMAX=bzMax, $
                                  DO_ABS_BYMIN=abs_byMin, $
                                  DO_ABS_BYMAX=abs_byMax, $
                                  DO_ABS_BZMIN=abs_bzMin, $
                                  DO_ABS_BZMAX=abs_bzMax, $
                                  BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                  DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                  PARAMSTRING=paramString, $
                                  PARAMSTR_LIST=paramString_list, $
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  DELAY=delay, $
                                  MULTIPLE_DELAYS=multiple_delays, $
                                  STABLEIMF=stableIMF, $
                                  SMOOTHWINDOW=smoothWindow, $
                                  INCLUDENOCONSECDATA=includeNoConsecData, $
                                  LUN=lun


  ;;Open file for text summary, if desired
  IF KEYWORD_SET(outputPlotSummary) THEN BEGIN
     OPENW,lun,plotDir + 'outputSummary_'+paramString+'.txt',/GET_LUN 
     IF KEYWORD_SET(multiple_delays) THEN BEGIN
        PRINT,"What are you thinking? You're not setup to get multi-output..."
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     lun=-1                     ;-1 is lun for STDOUT
  ENDELSE
  
  ;;********************************************************
  ;;Now clean and tap the databases and interpolate satellite data
  IF KEYWORD_SET(nonStorm) OR KEYWORD_SET(mainPhase) OR KEYWORD_SET(recoveryPhase) THEN BEGIN
     GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
        DSTCUTOFF=dstCutoff, $
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
           PRINTF,lun,'Restricting with non-storm indices ...'
           restrict_with_these_i = ns_i
           t1_arr                = ns_t1
           t2_arr                = ns_t2
           stormString           = 'non-storm'
           paramString          += '--' + stormString
           IF KEYWORD_SET(multiple_delays) THEN BEGIN
              FOR iDel=0,N_ELEMENTS(delay)-1 DO BEGIN
                 paramString_list[iDel] += '--' + stormString
              ENDFOR
           ENDIF
        END
        KEYWORD_SET(mainPhase): BEGIN
           PRINTF,lun,'Restricting with main-phase indices ...'
           restrict_with_these_i = mp_i
           t1_arr                = mp_t1
           t2_arr                = mp_t2
           stormString           = 'mainPhase'
           paramString          += '--' + stormString
           IF KEYWORD_SET(multiple_delays) THEN BEGIN
              FOR iDel=0,N_ELEMENTS(delay)-1 DO BEGIN
                 paramString_list[iDel] += '--' + stormString
              ENDFOR
           ENDIF         
        END
        KEYWORD_SET(recoveryPhase): BEGIN
           PRINTF,lun,'Restricting with recovery-phase indices ...'
           restrict_with_these_i = rp_i
           t1_arr                = rp_t1
           t2_arr                = rp_t2
           stormString           = 'recoveryPhase'
           paramString          += '--' + stormString
           IF KEYWORD_SET(multiple_delays) THEN BEGIN
              FOR iDel=0,N_ELEMENTS(delay)-1 DO BEGIN
                 paramString_list[iDel] += '--' + stormString
              ENDFOR
           ENDIF
         END
     ENDCASE
  ENDIF

  plot_i_list                    = GET_RESTRICTED_AND_INTERPED_DB_INDICES(maximus,satellite,delay,LUN=lun, $
                                                                          DBTIMES=cdbTime,dbfile=dbfile, $
                                                                          DO_CHASTDB=do_chastdb, $
                                                                          DO_DESPUNDB=do_despunDB, $
                                                                          HEMI=hemi, $
                                                                          ;; NORTH=north, $
                                                                          ;; SOUTH=south, $
                                                                          ;; BOTH_HEMIS=both_hemis, $
                                                                          ORBRANGE=orbRange, $
                                                                          ALTITUDERANGE=altitudeRange, $
                                                                          CHARERANGE=charERange,POYNTRANGE=poyntRange, $
                                                                          MINMLT=minM,MAXMLT=maxM, $
                                                                          BINM=binM, $
                                                                          SHIFTM=shiftM, $
                                                                          MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                                                          DO_LSHELL=do_lshell, $
                                                                          MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                                          SMOOTHWINDOW=smoothWindow, $
                                                                          BYMIN=byMin,BZMIN=bzMin, $
                                                                          BYMAX=byMax,BZMAX=bzMax, $
                                                                          DO_ABS_BYMIN=abs_byMin, $
                                                                          DO_ABS_BYMAX=abs_byMax, $
                                                                          DO_ABS_BZMIN=abs_bzMin, $
                                                                          DO_ABS_BZMAX=abs_bzMax, $
                                                                          CLOCKSTR=clockStr, $
                                                                          RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                                                          BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                          MULTIPLE_DELAYS=multiple_delays, $
                                                                          STABLEIMF=stableIMF, $
                                                                          DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                                                          OMNI_COORDS=omni_Coords, $
                                                                          ANGLELIM1=angleLim1, $
                                                                          ANGLELIM2=angleLim2, $
                                                                          HWMAUROVAL=HwMAurOval, $
                                                                          HWMKPIND=HwMKpInd, $
                                                                          NO_BURSTDATA=no_burstData)
    
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
                             PROBOCCURRENCERANGE=probOccurrenceRange
  
  ;;********************************************
  ;;Now time for data summary

  PRINT_ALFVENDB_PLOTSUMMARY,maximus,plot_i_list,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                             ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                             minMLT=minM,maxMLT=maxM, $
                             BINMLT=binM, $
                             SHIFTMLT=shiftM, $
                             MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                             MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                             HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                             BYMIN=byMin, $
                             BZMIN=bzMin, $
                             BYMAX=byMax, $
                             BZMAX=bzMax, $
                             DO_ABS_BYMIN=abs_byMin, $
                             DO_ABS_BYMAX=abs_byMax, $
                             DO_ABS_BZMIN=abs_bzMin, $
                             DO_ABS_BZMAX=abs_bzMax, $
                             BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                             PARAMSTRING=paramString, $
                             PARAMSTR_LIST=paramString_list, $
                             PARAMSTRPREFIX=plotPrefix, $
                             PARAMSTRSUFFIX=plotSuffix,$
                             SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                             HEMI=hemi, $
                             DELAY=delay, $
                             MULTIPLE_DELAYS=multiple_delays, $
                             STABLEIMF=stableIMF, $
                             SMOOTHWINDOW=smoothWindow, $
                             INCLUDENOCONSECDATA=includeNoConsecData, $
                             HOYDIA=hoyDia, $
                             MASKMIN=maskMin, $
                             LUN=lun



  ;;********************************************************
  ;;HISTOS

  tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                   MIN1=minM,MIN2=(KEYWORD_SET(DO_LSHELL) ? minL : minI),$
                                   MAX1=maxM,MAX2=(KEYWORD_SET(DO_LSHELL) ? maxL : maxI), $
                                   SHIFT1=shiftM,SHIFT2=shiftI, $
                                   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                   CB_FORCE_OOBLOW=cb_force_oobLow)

  GET_ALFVENDB_2DHISTOS,maximus,plot_i_list, H2DSTRARR_LIST=h2dStrArr_List, $
                        KEEPME=keepMe, DATARAWPTRARR_LIST=dataRawPtrArr_List,DATANAMEARR_LIST=dataNameArr_List, $
                        MINMLT=minM,MAXMLT=maxM, $
                        BINMLT=binM, $
                        SHIFTMLT=shiftM, $
                        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                        DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                        ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, $
                        CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                        MASKMIN=maskMin, $
                        SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                        HEMI=hemi, $
                        CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                        DO_IMF_CONDS=~KEYWORD_SET(do_not_consider_IMF), $
                        DO_UTC_RANGE=KEYWORD_SET(nonStorm) OR KEYWORD_SET(mainPhase) OR KEYWORD_SET(recoveryPhase), $
                        STORMSTRING=stormString, $
                        DSTCUTOFF=dstCutoff, $
                        T1_ARR=t1_arr, $
                        T2_ARR=t2_arr, $
                        BYMIN=byMin, BZMIN=bzMin, $
                        BYMAX=byMax, BZMAX=bzMax, $
                        DO_ABS_BYMIN=abs_byMin, $
                        DO_ABS_BYMAX=abs_byMax, $
                        DO_ABS_BZMIN=abs_bzMin, $
                        DO_ABS_BZMAX=abs_bzMax, $
                        DELAY=delay, $
                        MULTIPLE_DELAYS=multiple_delays, $
                        STABLEIMF=stableIMF, $
                        SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                        NPLOTS=nPlots, NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                        EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                        ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, EPLOTRANGE=EPlotRange, $
                        ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                        NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                        PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                        NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                        IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                        NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                        CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                        NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                        CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                        NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
                        ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                        ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                        NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                        DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                        NEVENTPERMINPLOT=nEventPerMinPlot, NEVENTPERMINRANGE=nEventPerMinRange, LOGNEVENTPERMIN=logNEventPerMin, $
                        PROBOCCURRENCEPLOT=probOccurrencePlot, $
                        PROBOCCURRENCERANGE=probOccurrenceRange, $
                        LOGPROBOCCURRENCE=logProbOccurrence, $
                        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                        MEDIANPLOT=medianPlot, MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                        LOGAVGPLOT=logAvgPlot, $
                        ALL_LOGPLOTS=all_logPlots,$
                        TMPLT_H2DSTR=tmplt_h2dStr, $
                        FANCY_PLOTNAMES=fancy_plotNames, $
                        LUN=lun


  ;;********************************************************
  ;;Handle Plots all at once

  ;;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively
  tempFile_list                    = LIST()
  FOR iList=0,N_ELEMENTS(h2dStrArr_list)-1 DO BEGIN
     h2dStrArr                     = h2dStrArr_list[iList]
     dataNameArr                   = dataNameArr_list[iList]
     dataRawPtrArr                 = dataRawPtrArr_list[iList]
     plot_i                        = plot_i_list[iList]
     paramString                   = paramString_list[iList]

     h2dStrArr                     = SHIFT(h2dStrArr,-1-(nPlots))
     IF keepMe THEN BEGIN 
        dataNameArr                = SHIFT(dataNameArr,-2) 
        dataRawPtrArr              = SHIFT(dataRawPtrArr,-2) 
     ENDIF

     ;; h2dStrArr_list[iList]         = SHIFT(h2dStrArr_List[iList],-1-(nPlots))
     ;; IF keepMe THEN BEGIN 
     ;;    dataNameArr_list[iList]    = SHIFT(dataNameArr_list[iList],-2) 
     ;;    dataRawPtrArr_list[iList]  = SHIFT(dataRawPtrArr_list[iList],-2) 
     ;; ENDIF

     IF N_ELEMENTS(squarePlot) EQ 0 THEN BEGIN
        SAVE_ALFVENDB_TEMPDATA,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,$
                               MAXM=maxM,MINM=minM,MAXI=maxI,MINI=minI, $
                               BINM=binM, $
                               SHIFTM=shiftM, $
                               BINI=binI, $
                               DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell,$
                               MINL=minL,MAXL=maxL,BINL=binL,$
                               RAWDIR=rawDir,PARAMSTR=paramString,$
                               CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg,STABLEIMF=stableIMF,HOYDIA=hoyDia,HEMI=hemi,TEMPFILE=tempFile
     ENDIF

     ;;Now plots
     PLOT_ALFVENDB_2DHISTOS,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,TEMPFILE=tempFile, $
                            SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                            JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                            PLOTDIR=plotDir, PLOTMEDORAVG=plotMedOrAvg, $
                            PARAMSTR=paramString, DEL_PS=del_PS, $
                            HEMI=hemi, $
                            CLOCKSTR=clockStr, $
                            NO_COLORBAR=no_colorbar, $
                            EPS_OUTPUT=eps_output, $
                            _EXTRA = e

     IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
        CLOSE,lun 
        FREE_LUN,lun 
     ENDIF

     ;;Save raw data, if desired
     IF KEYWORD_SET(saveRaw) THEN BEGIN
        SAVE, /ALL, filename=rawDir+'fluxplots_'+paramString+".dat"

     ENDIF

     ;; WRITE_ALFVENDB_2DHISTOS,MAXIMUS=maximus,PLOT_I_LIST=plot_i_list, $
     ;;                           WRITEHDF5=writeHDF5,WRITEPROCESSEDH2D=WRITEPROCESSEDH2D,WRITEASCII=writeASCII, $
     ;;                           H2DSTRARR_LIST=h2dStrArr_List,DATARAWPTRARR_LIST=dataRawPtrArr_List,DATANAMEARR_LIST=dataNameArr_List, $
     ;;                           PARAMSTRING_LIST=paramstring_list,PLOTDIR=plotDir
     WRITE_ALFVENDB_2DHISTOS,MAXIMUS=maximus,PLOT_I=plot_i, $
                             WRITEHDF5=writeHDF5,WRITEPROCESSEDH2D=WRITEPROCESSEDH2D,WRITEASCII=writeASCII, $
                             H2DSTRARR=h2dStrArr,DATARAWPTRARR=dataRawPtrArr,DATANAMEARR=dataNameArr, $
                             PARAMSTR=paramString,PLOTDIR=plotDir

     tempFile_list.add,tempFile
  ENDFOR

  out_tempFile_list      = tempFile_list
  out_dataNameArr_list   = dataNameArr_list

END