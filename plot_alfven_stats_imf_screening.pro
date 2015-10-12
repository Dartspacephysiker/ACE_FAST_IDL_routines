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
;                    ABS_EFLUX         :  Use absolute value of electron energy flux (required for log plots).
;                    NONEG_EFLUX       :  Do not use negative e fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOS_EFLUX       :  Do not use positive e fluxes in any of the plots
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
;		     LOGPLOT           :     
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
;-

PRO plot_alfven_stats_imf_screening, maximus, $
                                     CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                                     minMLT=minMLT,maxMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                     HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                     MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                                     BYMIN=byMin, BZMIN=bzMin, $
                                     BYMAX=byMax, BZMAX=bzMax, $
                                     SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                     HEMI=hemi, $
                                     DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                     NPLOTS=nPlots, $
                                     EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, ABS_EFLUX=abs_eFlux, $
                                     ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
                                     NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                     PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                     NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                     IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                     NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                     CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                     NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                     ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                     ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
                                     NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
                                     DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                     NEVENTPERMINPLOT=nEventPerMinPlot, LOGNEVENTPERMIN=logNEventPerMin, $
                                     MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                     LOGPLOT=logPlot, $
                                     SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                     DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                                     NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                     WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                     SAVERAW=saveRaw, RAWDIR=rawDir, $
                                     JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                     PLOTDIR=plotDir, PLOTPREFIX=plotPrefix, PLOTSUFFIX=plotSuffix, $
                                     MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                                     OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                                     _EXTRA = e

;;  COMPILE_OPT idl2

  ;;variables to be used by interp_contplot.pro

  !EXCEPT=0                                                      ;Do report errors, please
  ;;***********************************************
  ;;Tons of defaults
  
  defeFluxPlotType = "Max"
  defENumFlPlotType = "ESA_Number_flux" 
  defIFluxPlotType = "Max"
  defCharEPlotType = "lossCone"

  ; assorted
  defMaskMin = 1

  defPlotDir = '/SPENCEdata/Research/Cusp/ACE_FAST/plots/'
  defRawDir = 'rawsaves/'

  defOutSummary = 1 ;for output plot summary

  defDataDir = "/SPENCEdata/Research/Cusp/database/"
  defMedHistDataDir = 'out/medHistData/'
  defTempDir='/SPENCEdata/Research/Cusp/ACE_FAST/temp/'
  
  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                  PARAMSTRING=paramStr, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                  HOYDIA=hoyDia,LUN=lun
  
  ;;Shouldn't be leftover unused params from batch call
  
  IF ISA(e) THEN BEGIN
     IF $
        NOT tag_exist(e,"wholecap") AND NOT tag_exist(e,"noplotintegral") $
        AND NOT tag_exist(e,"mirror") AND NOT tag_exist(e,"labelFormat") $ ;keywords for interp_polar2dhist
        AND NOT tag_exist(e,"plottitle") $
     THEN BEGIN                 ;Check for passed variables here
        help,e
        print,e
        print,"Why the extra parameters? They have no home..."
        RETURN
     ENDIF ELSE BEGIN
        IF tag_exist(e,"wholecap") THEN BEGIN
           IF e.wholecap GT 0 THEN BEGIN
              minM=0.0
              maxM=24.0
              IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
                 minI=defMinI
                 maxI=defMaxI
              ENDIF ELSE BEGIN
                 minI=-defMaxI
                 maxI=-defMinI
              ENDELSE
           ENDIF
        ENDIF
     ENDELSE
     
  ENDIF
  
  ;;Check on ILAT stuff; if I don't do this, all kinds of plots get boogered up
  IF ( (maxI-minI) MOD binI ) NE 0 THEN BEGIN
     IF STRLOWCASE(hemi) EQ "north" THEN BEGIN
        minI += CEIL(maxI-minI) MOD binI
     ENDIF ELSE BEGIN
        maxI -= CEIL(maxI-minI) MOD binI
     ENDELSE
  ENDIF

  ;;Want to make plots in plotDir?
  IF N_ELEMENTS(plotDir) EQ 0 THEN plotDir = defPlotDir
  ;;plotPrefix='NESSF2014_reproduction_Jan2015'

  IF N_ELEMENTS(rawDir) EQ 0 THEN rawDir=defRawDir
 
  ;;Write output file with data params? Only possible if showPlotsNoSave=0...
  IF KEYWORD_SET(showPlotsNoSave) AND KEYWORD_SET(outputPlotSummary) THEN BEGIN
     print, "Is it possible to have outputPlotSummary==1 while showPlotsNoSave==0? You used to say no..."
     outputPlotSummary=defOutSummary   ;;Change to zero if not wanted
  ENDIF 

  ;;Write plot data output for Bin?
  IF N_ELEMENTS(dataDir) EQ 0 THEN dataDir = defDataDir

  ;;Any of multifarious reasons for needing output?
  IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR NOT KEYWORD_SET(squarePlot) OR KEYWORD_SET(saveRaw) THEN BEGIN
     keepMe = 1
  ENDIF ELSE keepMe = 0

  IF KEYWORD_SET(medHistOutTxt) AND NOT KEYWORD_SET(medHistOutData) THEN BEGIN
     PRINT, "medHistOutTxt is enabled, but medHistOutData is not!"
     print, "Enabling medHistOutData, since corresponding output is necessary for medHistOutTxt"
     WAIT, 0.5
     IF ~KEYWORD_SET(medHistDataDir) THEN medHistDataDir = defMedHistDataDir 
     medHistOutData = 1
  ENDIF

  IF N_ELEMENTS(DEL_PS) EQ 0 THEN del_ps = 1

  ;;********************************************
  ;;A few other strings to tack on
  ;;tap DBs, and setup output
  IF KEYWORD_SET(no_burstData) THEN inc_burstStr ='burstData_excluded--' ELSE inc_burstStr=''

  IF KEYWORD_SET(medianplot) THEN plotMedOrAvg = "_med" ELSE BEGIN
     IF KEYWORD_SET(logAvgPlot) THEN plotMedOrAvg = "_logAvg" ELSE plotMedOrAvg = "_avg"
  ENDELSE

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr=''
  IF N_ELEMENTS(maskMin) EQ 0 THEN maskMin = defMaskMin $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='maskMin_' + STRCOMPRESS(maskMin,/REMOVE_ALL) + '_'
     ENDIF
  ENDELSE
  
  ;;doing polar contour?
  polarContStr=''
  IF KEYWORD_SET(polarContour) THEN BEGIN
     polarContStr='polarCont_'
  ENDIF

  ;;parameter string
  paramStr=paramStr+plotMedOrAvg+maskStr+inc_burstStr + polarContStr

  ;;Open file for text summary, if desired
  IF KEYWORD_SET(outputPlotSummary) THEN $
     OPENW,lun,plotDir + 'outputSummary_'+paramStr+'.txt',/GET_LUN $
  ELSE lun=-1                   ;-1 is lun for STDOUT
  
  ;;Now clean and tap the databases and interpolate satellite data
    plot_i = GET_RESTRICTED_AND_INTERPED_DB_INDICES(maximus,satellite,delay,LUN=lun, $
                                                    DBTIMES=cdbTime,dbfile=dbfile,DO_CHASTDB=do_chastdb, HEMI=hemi, $
                                                    ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                                    MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                                    BYMIN=byMin,BZMIN=bzMin,BYMAX=byMax,BZMAX=bzMax,CLOCKSTR=clockStr,BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                    STABLEIMF=stableIMF,OMNI_COORDS=omni_Coords,ANGLELIM1=angleLim1,ANGLELIM2=angleLim2, $
                                                    HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData)
    
  ;;********************************************************
  ;;WHICH ORBITS ARE UNIQUE?
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  ;;printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."
  
  ;;********************************************
  ;;Variables for histos
  ;;Bin sizes for 2d histos

  IF N_ELEMENTS(nPlots) EQ 0 THEN nPlots = 0                              ; do num events plots?
  IF N_ELEMENTS(ePlots) EQ 0 THEN ePlots =  0                             ;electron energy flux plots?
  IF N_ELEMENTS(eFluxPlotType) EQ 0 THEN eFluxPlotType = defEFluxPlotType ;options are "Integ" and "Max"
  IF N_ELEMENTS(iFluxPlotType) EQ 0 THEN iFluxPlotType = defIFluxPlotType ;options are "Integ", "Max", "Integ_Up", "Max_Up", and "Energy"
  IF N_ELEMENTS(eNumFlPlots) EQ 0 THEN eNumFlPlots = 0                    ;electron number flux plots?
  IF N_ELEMENTS(eNumFlPlotType) EQ 0 THEN eNumFlPlotType = defENumFlPlotType ;options are "Total_Eflux_Integ","Eflux_Losscone_Integ", "ESA_Number_flux" 
  IF N_ELEMENTS(pPlots) EQ 0 THEN pPlots =  0                             ;Poynting flux [estimate] plots?
  IF N_ELEMENTS(ionPlots) EQ 0 THEN ionPlots =  0                         ;ion Plots?
  IF N_ELEMENTS(charEPlots) EQ 0 THEN charEPlots =  0                     ;char E plots?
  IF N_ELEMENTS(charEType) EQ 0 THEN charEType = defCharEPlotType         ;options are "lossCone" and "Total"
  IF N_ELEMENTS(orbContribPlot) EQ 0 THEN orbContribPlot =  0             ;Contributing orbits plot?
  IF N_ELEMENTS(orbTotPlot) EQ 0 THEN orbTotPlot =  0                     ;"Total orbits considered" plot?
  IF N_ELEMENTS(orbFreqPlot) EQ 0 THEN orbFreqPlot =  0                   ;Contributing/total orbits plot?
  IF N_ELEMENTS(nEventPerOrbPlot) EQ 0 THEN nEventPerOrbPlot =  0         ;N Events/orbit plot?
  IF N_ELEMENTS(nEventPerMinPlot) EQ 0 THEN nEventPerMinPlot =  0         ;N Events/min plot?
  
  IF (KEYWORD_SET(nEventPerOrbPlot) OR KEYWORD_SET(nEventPerMinPlot) ) AND NOT KEYWORD_SET(nPlots) THEN BEGIN
     print,"Can't do nEventPerOrbPlot without nPlots!!"
     print,"Enabling nPlots..."
     nPlots=1
  ENDIF

  ;;######ELECTRON FLUXES, ENERGY AND NUMBER 

  ;;#########e- energy flux
  ;;Eflux max abs. value in interval, or integrated flux?
  ;;NOTE: max value has negative values, which can mess with
  ;;color bars
  IF KEYWORD_SET(logEfPlot) AND NOT KEYWORD_SET(abs_eFlux) AND NOT KEYWORD_SET(noNeg_eFlux) AND NOT KEYWORD_SET(noPos_eFlux) THEN BEGIN 
     print,"Warning!: You're trying to do log Eflux plots but you don't have 'abs_eFlux', 'noNeg_eFlux', or 'noPos_eFlux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Eflux values"
     WAIT, 1
     noNeg_eFlux=1
  ENDIF
  IF KEYWORD_SET(noPos_eFlux) AND KEYWORD_SET (logEfPlot) THEN abs_eFlux = 1

  IF N_ELEMENTS(EPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- energy Flux plotrange
     IF N_ELEMENTS(logEfPlot) EQ 0 THEN EPlotRange=[0.01,100] ELSE EPlotRange=[-2,2]
  ENDIF
  
  ;;#########e- number flux
  ;; Safety for electron number flux plots 
  IF KEYWORD_SET(logENumFlPlot) AND NOT KEYWORD_SET(absENumFl) AND NOT KEYWORD_SET(noNegENumFl) AND NOT KEYWORD_SET(noPosENumFl) THEN BEGIN 
     print,"Warning!: You're trying to do log e- number flux plots but you don't have 'absENumFl', 'noNegENumFl', or 'noPosENumFl' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative ENumFl values"
     WAIT, 1
     noNegENumFl=1
  ENDIF
  IF KEYWORD_SET(noPosENumFl) AND KEYWORD_SET (logENumFlPlot) THEN absENumFl = 1

  IF N_ELEMENTS(ENumFlPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- number flux plotrange
     IF N_ELEMENTS(logENumFlPlot) EQ 0 THEN ENumFlPlotRange=[1e5,1e9] ELSE ENumFlPlotRange=[1,9]
  ENDIF

  ;;######Poynting flux
  IF KEYWORD_SET(logPfPlot) AND NOT KEYWORD_SET(absPflux) AND NOT KEYWORD_SET(noNegPflux) AND NOT KEYWORD_SET(noPosPflux) THEN BEGIN 
     print,"Warning!: You're trying to do log Pflux plots but you don't have 'absPflux', 'noNegPflux', or 'noPosPflux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Pflux values"
     WAIT, 1
;;     abs_eFlux=1
     noPosPflux=1
  ENDIF

  IF KEYWORD_SET(noPosPflux) AND KEYWORD_SET (logPfPlot) THEN absPflux = 1

  ;;For linear or log PFlux plotrange
  IF N_ELEMENTS(PPlotRange) EQ 0 THEN BEGIN
     IF N_ELEMENTS(logPfPlot) EQ 0 THEN PPlotRange=[0.1,2.5] ELSE PPlotRange=[-1.5288,0.39794]
  ENDIF

  ;;######Ion flux (up)
  ;;For linear or log ion flux plotrange
  IF N_ELEMENTS(iPlotRange) EQ 0 THEN iPlotRange=(KEYWORD_SET(logIfPlot)) ? [6,9.5] : [1e6,1.5e9]
  
  IF KEYWORD_SET(logIfPlot) AND NOT KEYWORD_SET(absIflux) AND NOT KEYWORD_SET(noNegIflux) AND NOT KEYWORD_SET(noPosIflux) THEN BEGIN 
     print,"Warning!: You're trying to do log(ionFlux) plots but you don't have 'absIflux', 'noNegIflux', or 'noPosIflux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Iflux values"
     WAIT, 1
;;     absIflux=1
     noNegIflux=1
  ENDIF

  ;;######e- characteristic energy stuff
  IF KEYWORD_SET(logCharEPlot) AND NOT KEYWORD_SET(absCharE) AND NOT KEYWORD_SET(noNegCharE) AND NOT KEYWORD_SET(noPosCharE) THEN BEGIN 
     print,"Warning!: You're trying to do log(charE) plots but you don't have 'absCharE', 'noNegCharE', or 'noPosCharE' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative CharE values"
     WAIT, 1
;;     absCharE=1
     noNegCharE=1
  ENDIF

  IF KEYWORD_SET(noPosCharE) AND KEYWORD_SET (logCharEPlot) THEN absCharE = 1

  IF N_ELEMENTS(CharEPlotRange) EQ 0 THEN BEGIN   ;;For linear or log charE plotrange
;;     IF N_ELEMENTS(logCharEPlot) EQ 0 THEN CharEPlotRange=[1,4000] ELSE CharEPlotRange=[0,3.60206]; [0,3.69897]
     IF N_ELEMENTS(logCharEPlot) EQ 0 THEN CharEPlotRange=charERange ELSE CharEPlotRange=ALOG10(charERange)
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(logCharEPlot) GT 0 THEN CharEPlotRange=ALOG10(charEPlotRange)
  ENDELSE

  ;;***********************************************
  ;;Calculate Poynting flux estimate
  
  ;;1.0e-9 to take stock of delta_b being recorded in nT
  ;;Since E is recorded in mV/m, units of POYNTEST here are mW/m^2
  ;;No need to worry about screening for FINITE(pfluxEst), since both delta_B and delta_E are
  ;;screened for finiteness in alfven_db_cleaner (which is called in get_chaston_ind.pro)
  mu_0 = 4.0e-7 * !PI                                            ;perm. of free space, for Poynt. est
  pfluxEst=maximus.DELTA_B * maximus.DELTA_E * 1.0e-9 / mu_0 

  ;;********************************************
  ;;Now time for data summary

;; was using this to compare our Poynting flux estimates against Keiling et al. 2003 Fig. 3
  IF KEYWORD_SET(poyntRange) THEN BEGIN
     IF N_ELEMENTS(poyntRange) NE 2 OR (poyntRange[1] LE poyntRange[0]) THEN BEGIN
        PRINT,"Invalid Poynting range specified! poyntRange should be a two-element vector, [minPoynt maxPoynt]"
        PRINT,"No Poynting range set..."
        RETURN
     ENDIF ELSE BEGIN
        plot_i=cgsetintersection(plot_i,where(pfluxEst GE poyntRange[0] AND pfluxEst LE poyntRange[1]))
     ENDELSE
  ENDIF

  printf,lun,FORMAT='("Events per bin req            : >=",T35,I8)',maskMin
  printf,lun,FORMAT='("Number of orbits used         :",T35,I8)',N_ELEMENTS(uniqueOrbs_ii)
  printf,lun,FORMAT='("Total N events                :",T35,I8)',N_ELEMENTS(plot_i)
;; printf,lun,FORMAT='("Percentage of Chaston DB used: ",T35,I0)' + $
;;        strtrim((N_ELEMENTS(plot_i))/134925.0*100.0,2) + "%"
  printf,lun,FORMAT='("Percentage of DB used         :",T35,G8.4,"%")',(FLOAT(N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0)

  ;;********************************************
  ;;junk=where(cdbInterp_i(phi_dusk_ii) EQ cdbInterp_i(phi_dawn_ii))
  ;;IF n_elements(junk) EQ 1 THEN BEGIN 
  ;;	IF junk NE -1 THEN PRINTF,LUN,"NO!!!! JUNK ISN'T JUNK!!!" 
  ;;ENDIF
  ;;********************************************************
  ;;HISTOS

  ;;########Flux_N and Mask########
  ;;First, histo to show where events are

  GET_NEVENTS_AND_MASK,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       NEVENTSPLOTRANGE=nEventsPlotRange, $
                       H2DSTR=h2dStr,H2DMASKSTR=h2dMaskStr,H2DFLUXN=h2dFluxN,MASKMIN=maskMin,TMPLT_H2DSTR=tmplt_h2dStr, $
                       DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme

  IF KEYWORD_SET(nPlots) THEN h2dStr=[h2dStr,h2dMaskStr] ELSE h2dStr = h2dMaskStr

  ;;########ELECTRON FLUX########
  IF KEYWORD_SET(eplots) THEN BEGIN
     GET_ELEC_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                            EFLUXPLOTTYPE=eFluxPlotType,NOPOS_EFLUX=noPos_eFlux,NONEG_EFLUX=noNeg_eFlux,ABS_EFLUX=abs_eFlux,LOGEFPLOT=logEfPlot, $
                            H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                            DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                            MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                            LOGAVGPLOT=logAvgPlot,EPLOTRANGE=ePlotRange
  ENDIF

  ;;########ELECTRON NUMBER FLUX########
  IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
     GET_ELEC_NUMFLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                               ENUMFLPLOTTYPE=eNumFlPlotType,EPLOTRANGE=ePlotRange, $
                               NOPOSENUMFL=noPosENumFl,NONEGENUMFL=noNegENumFl,ABSENUMFL=absENumFl,LOGEFPLOT=logEfPlot, $
                               H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                               DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                               MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                               LOGAVGPLOT=logAvgPlot, $
                               OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT
  ENDIF

  ;;########Poynting Flux########
  IF KEYWORD_SET(pplots) THEN BEGIN
     GET_PFLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                        PPLOTRANGE=PPlotRange, $
                        NOPOSPFLUX=noPosPflux,NONEGPFLUX=noNegPflux,ABSPFLUX=absPflux,LOGPFPLOT=logPfPlot, $
                        H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                        DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                        MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                        LOGAVGPLOT=logAvgPlot, $
                        OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT
  ENDIF

  ;;########ION FLUX########
  IF KEYWORD_SET(ionPlots) THEN BEGIN
     GET_IFLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                        IFLUXPLOTTYPE=iFluxPlotType,iPLOTRANGE=iPlotRange, $
                        NOPOSIFLUX=noPosIflux,NONEGIFLUX=noNegIflux,ABSIFLUX=absIflux,LOGIFPLOT=logIfPlot, $
                        H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                        DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                        MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                        LOGAVGPLOT=logAvgPlot
  ENDIF

  ;;########CHARACTERISTIC ENERGY########
  IF KEYWORD_SET(charEPlots) THEN BEGIN
     GET_CHARE_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                        CHARETYPE=charEType,CHAREPLOTRANGE=charEPlotRange, $
                        NOPOSCHARE=noPosCharE,NONEGCHARE=noNegCharE,ABSCHARE=absCharE,LOGCHAREPLOT=logCharEPlot, $
                        H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                        MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,LOGAVGPLOT=logAvgPlot,EPLOTRANGE=ePlotRange, $
                        DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme
  ENDIF

  ;;########################################
  ;;
  ;;########Orbits########
  ;;Now do orbit data to show how many orbits contributed to each thingy.
  ;;A little extra tomfoolery is in order to get this right
  ;;h2dOrbN is a 2d histo just like the others
  ;;orbArr, on the other hand, is a 3D array, where the
  ;;2D array pointed to is indexed by MLTbin and ILATbin. The contents of
  ;;the 3D array are of the format [UniqueOrbs_ii index,MLT,ILAT]

  ;;The following two lines shouldn't be necessary; the data are being corrupted somewhere when I run this with clockstr="dawnward"
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  
  IF KEYWORD_SET(orbContribPlot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) OR KEYWORD_SET(numOrbLim) THEN BEGIN
     GET_CONTRIBUTING_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                      ORBCONTRIBRANGE=orbContribRange, $
                                      H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr, $
                                      DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                                      NPLOTS=nPlots,ORBCONTRIBPLOT=orbContribPlot,UNIQUEORBS_II=uniqueOrbs_ii,NORBS=nOrbs
  ENDIF

  ;;########TOTAL Orbits########
  IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) THEN BEGIN
     GET_TOTAL_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                              ORBTOTRANGE=orbTotRange, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DTOTORBSTR=h2dTotOrbStr, $
                              DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                              NPLOTS=nPlots,ORBTOTPLOT=orbTotPlot,UNIQUEORBS_II=uniqueOrbs_ii
  ENDIF

  ;;########Orbit FREQUENCY########
  IF KEYWORD_SET(orbfreqplot) THEN BEGIN
     GET_ORBIT_FREQUENCY_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                  ORBFREQRANGE=orbFreqRange, $
                                  H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                  DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                                  NPLOTS=nPlots,ORBTOTPLOT=orbTotPlot,UNIQUEORBS_II=uniqueOrbs_ii
  ENDIF
     
  ;;########NEvents/orbit########
  IF KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN 
     GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                    ORBFREQRANGE=orbFreqRange,DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                    H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                    DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme
  ENDIF

  ;;########NEvents/minute########
  IF KEYWORD_SET(nEventPerMinPlot) THEN BEGIN 

     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.
     h2dNEvPerMinStr={tmplt_h2dStr}
     h2dNEvPerMinStr.data=h2dStr[0].data
     h2dNonzeroNEv_i=WHERE(h2dStr[0].data NE 0,/NULL)

     ;Get the appropriate divisor for IMF conditions
     GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                HEMI='BOTH', DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                HWMAUROVAL=0,HWMKPIND=!NULL, $
                                MAKE_OUTINDSFILE=make_outIndsFile, $
                                FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                BURSTDATA_EXCLUDED=burstData_excluded

     ;; MAKE_FASTLOC_HISTO,TIMEHISTO=divisor,FASTLOC_INDS=fastLoc_inds, $
     MAKE_FASTLOC_HISTO,FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                        FASTLOC_INDS=fastLocInterped_i, OUTTIMEHISTO=divisor, $
                        MINMLT=minM,MAXMLT=maxM,BINMLT=binM, $
                        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                        FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                        OUTFILEPREFIX=outFilePrefix,OUTFILESUFFIX=outFileSuffix, OUTDIR=fastLocOutputDir, $
                        OUTPUT_TEXTFILE=output_textFile

     ;output is in seconds, but we'll do minutes
     ;
     divisor = divisor(h2dNonzeroNEv_i)/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
     h2dNEvPerMinStr.data(h2dNonzeroNEv_i)=h2dNEvPerMinStr.data(h2dNonzeroNEv_i)/divisor

     ;2015/04/09 TEMPORARILY skip the lines above because our fastLoc file currently only includes orbits 500-11000.
     ; This means that, according to fastLoc and maximus, there are events where FAST has never been!
     ; So we have to do some trickery
     ;; divisor_nonZero_i = WHERE(divisor GT 0.0)
     ;; h2dNonzeroNEv_i = cgsetintersection(divisor_nonZero_i,h2dNonzeroNEv_i)
     ;; divisor = divisor(h2dNonzeroNEv_i)/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
     ;; h2dNEvPerMinStr.data(h2dNonzeroNEv_i)=h2dNEvPerMinStr.data(h2dNonzeroNEv_i)/divisor

     logNEvStr=""
     IF KEYWORD_SET(logNEventPerMin) THEN logNEvStr="Log "
     h2dNEvPerMinStr.title= logNEvStr + 'N Events per minute'

     IF N_ELEMENTS(nEventPerMinRange) EQ 0 OR N_ELEMENTS(nEventPerMinRange) NE 2 THEN BEGIN
        IF N_ELEMENTS(logNEventPerMin) EQ 0 THEN h2dNEvPerMinStr.lim=[0,25] ELSE h2dNEvPerMinStr.lim=[1,ALOG10(25.0)]
     ENDIF ELSE h2dNEvPerMinStr.lim=nEventPerMinRange
     
     IF KEYWORD_SET(logNEventPerMin) THEN BEGIN 
        h2dNEvPerMinStr.data(where(h2dNEvPerMinStr.data GT 0,/NULL))=ALOG10(h2dNEvPerMinStr.data(where(h2dNEvPerMinStr.data GT 0,/null))) 
     ENDIF

     h2dStr=[h2dStr,h2dNEvPerMinStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,logNEvStr + "nEventPerMin"] 

  ENDIF

  ;; Temporary data thing
  ;;use these n stuff
  IF KEYWORD_SET(tempSAVE) THEN BEGIN 
     print,"saving tempdata..." 
     IF KEYWORD_SET(ePlots) THEN save,elecData,filename="testcode/elecdata.dat" 
     mlts=maximus.mlt(plot_i) 
     ilats=maximus.ilat(plot_i) 
     save,mlts,ilats,filename="testcode/mlts_ilats.dat" 
     pData=pfluxEst(plot_i) 
     IF KEYWORD_SET(pplots) THEN save,pData,filename="testcode/pData.dat" 
  ENDIF

  ;;********************************************************
  ;;If something screwy goes on, better take stock of it and alert user

  FOR i = 2, N_ELEMENTS(h2dStr)-1 DO BEGIN 
     IF n_elements(where(h2dStr[i].data EQ 0,/NULL)) LT $
        n_elements(where(h2dStr[0].data EQ 0,/NULL)) THEN BEGIN 
        printf,lun,"h2dStr."+h2dStr[i].title + " has ", strtrim(n_elements(where(h2dStr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_elements(where(h2dStr[0].data EQ 0)),2),"." 
     printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
  ENDFOR

  ;;Now that we're done using nplots, let's log it, if requested:
  IF KEYWORD_SET(nPlots) AND KEYWORD_SET(logNEventsPlot) THEN BEGIN
     dataNameArr[0] = 'log_' + dataNameArr[0]
     h2dStr[0].data(where(h2dStr.data GT 0)) = ALOG10(h2dStr[0].data(where(h2dStr.data GT 0)))
     h2dStr[0].lim = [(h2dStr[0].lim[0] LT 1) ? 0 : ALOG10(h2dStr[0].lim[0]),ALOG10(h2dStr[0].lim[1])] ;lower bound must be one
     h2dStr[0].title = 'Log ' + h2dStr[0].title
  ENDIF
  ;;********************************************************
  ;;Handle Plots all at once

  ;;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively

  h2dStr=SHIFT(h2dStr,-1-(nPlots))
  IF keepMe THEN BEGIN 
     dataNameArr=SHIFT(dataNameArr,-2) 
     dataRawPtrArr=SHIFT(dataRawPtrArr,-2) 
  ENDIF

  IF N_ELEMENTS(squarePlot) EQ 0 THEN save,h2dStr,dataNameArr,maxM,minM,maxI,minI,binM,binI,$
                           rawDir,clockStr,plotMedOrAvg,stableIMF,hoyDia,hemi,$
                           filename=defTempDir + 'polarplots_'+paramStr+".dat"

  ;;if not saving plots and plots not turned off, do some stuff  ;; otherwise, make output
  IF KEYWORD_SET(showPlotsNoSave) THEN BEGIN 
     IF N_ELEMENTS(justData) EQ 0 AND KEYWORD_SET(squarePlot) THEN $
        cgWindow, 'interp_contplotmulti_str', h2dStr,$
                  Background='White', $
                  WTitle='Flux plots for '+hemi+'ern Hemisphere, '+clockStr+ $
                  ' IMF, ' + strmid(plotMedOrAvg,1) $
     ELSE IF N_ELEMENTS(justData) EQ 0 THEN $
        FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO $ 
           cgWindow,'interp_polar2dhist',h2dStr[i],defTempDir + 'polarplots_'+paramStr+".dat", $
                CLOCKSTR=clockStr, _extra=e,$
                Background="White",wxsize=800,wysize=600, $
                WTitle='Polar plot_'+dataNameArr[i]+','+hemi+'ern Hemisphere, '+clockStr+ $
                ' IMF, ' + strmid(plotMedOrAvg,1) $
                
     ELSE PRINTF,LUN,"**Plots turned off with justData**" 
  ENDIF ELSE BEGIN 
     IF KEYWORD_SET(squarePlot) AND NOT KEYWORD_SET(justData) THEN BEGIN 
        CD, CURRENT=c ;; & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
        PRINTF,LUN, "Creating output files..." 

        ;;Create a PostScript file.
        cgPS_Open, plotDir + plotPrefix + 'fluxplots_'+paramStr+'.ps', /nomatch, xsize=1000, ysize=1000
        interp_contplotmulti_str,h2dStr 
        cgPS_Close 

        ;;Create a PNG file with a width of 800 pixels.
        cgPS2Raster, plotDir + plotPrefix + 'fluxplots_'+paramStr+'.ps', $
                     /PNG, Width=800, DELETE_PS = del_PS
     
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(justData) EQ 0 THEN BEGIN 
           CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
           PRINTF,LUN, "Creating output files..." 
           
           FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO BEGIN  
              
              IF KEYWORD_SET(polarContour) THEN BEGIN
                 ;; The NAME field of the !D system variable contains the name of the
                 ;; current plotting device.
                 mydevice = !D.NAME
                 ;; Set plotting to PostScript:
                 SET_PLOT, 'PS'
                 ;; Use DEVICE to set some PostScript device options:
                 DEVICE, FILENAME='myfile.ps', /LANDSCAPE
                 ;; Make a simple plot to the PostScript file:
                 interp_polar2dcontour,h2dStr[i],dataNameArr[i],defTempDir + 'polarplots_'+paramStr+".dat", $
                                       fname=plotDir + dataNameArr[i]+paramStr+'.png', _extra=e
                 ;; Close the PostScript file:
                 DEVICE, /CLOSE
                 ;; Return plotting to the original device:
                 SET_PLOT, mydevice
              ENDIF ELSE BEGIN
                 ;;Create a PostScript file.
                 cgPS_Open, plotDir + dataNameArr[i]+paramStr+'.ps' 
                 ;;interp_polar_plot,[[*dataRawPtrArr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
                 ;;          h2dStr[0].lim 
                 interp_polar2dhist,h2dStr[i],defTempDir + 'polarplots_'+paramStr+".dat",CLOCKSTR=clockStr,_extra=e 
                 cgPS_Close 
                 ;;Create a PNG file with a width of 800 pixels.
                 cgPS2Raster, plotDir + dataNameArr[i]+paramStr+'.ps', $
                              /PNG, Width=800, DELETE_PS = del_PS
              ENDELSE
              
           ENDFOR    
        
        ENDIF
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
     CLOSE,lun 
     FREE_LUN,lun 
  ENDIF

  ;;Save raw data, if desired
  IF KEYWORD_SET(saveRaw) THEN BEGIN
     SAVE, /ALL, filename=rawDir+'fluxplots_'+paramStr+".dat"

  ENDIF

   ;;********************************************************
   ;;Thanks, IDL Coyote--time to write out lots of data

   IF KEYWORD_SET(writeHDF5) THEN BEGIN 
      ;;write out raw data here
      FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN 
         fname=plotDir + dataNameArr[j]+paramStr+'.h5' 
         PRINT,"Writing HDF5 file: " + fname 
         fileID=H5F_CREATE(fname) 
         datatypeID=H5T_IDL_CREATE(h2dStr[j].data) 
         dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
         datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
         H5D_WRITE,datasetID, h2dStr[j].data 
         H5F_CLOSE,fileID 
      ENDFOR 

      ;;To read your newly produced HDF5 file, do this:
      ;;s = H5_PARSE(fname, /READ_DATA)
      ;;HELP, s.mydata._DATA, /STRUCTURE  
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN 
            fname=plotDir + dataNameArr[j]+paramStr+'.h5' 
            PRINT,"Writing HDF5 file: " + fname 
            fileID=H5F_CREATE(fname) 
            
            ;;    datatypeID=H5T_IDL_CREATE() 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStr[j].data 
            
            datatypeID=H5T_IDL_CREATE(h2dStr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStr[j].data     
            
            
            datatypeID=H5T_IDL_CREATE(h2dStr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStr[j].data 
            H5F_CLOSE,fileID 
         ENDFOR 
      ENDIF 
   ENDIF

   IF KEYWORD_SET(writeASCII) THEN BEGIN 
      ;;These are the "raw" data, just as we got them from Chris
      FOR j = 0, n_elements(dataRawPtrArr)-3 DO BEGIN 
         fname=plotDir + dataNameArr[j]+paramStr+'.ascii' 
         PRINT,"Writing ASCII file: " + fname 
         OPENW,lun2, fname, /get_lun 

         FOR i = 0, N_ELEMENTS(plot_i) - 1 DO BEGIN 
            PRINTF,lun2,(maximus.ILAT(plot_i))[i],(maximus.MLT(plot_i))[i],$
                   (*dataRawPtrArr[j])[i],$
                   FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
         ENDFOR 
         CLOSE, lun2   
         FREE_LUN, lun2 
      ENDFOR 
      
      ;;NOW DO PROCESSED H2D DATA 
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR i = 0, n_elements(h2dStr)-1 DO BEGIN 
            fname=plotDir + "h2d_"+dataNameArr[i]+paramStr+'.ascii' 
            PRINT,"Writing ASCII file: " + fname 
            OPENW,lun2, fname, /get_lun 
            FOR j = 0, N_ELEMENTS(outH2DBinsMLT) - 1 DO BEGIN 
               FOR k = 0, N_ELEMENTS(outH2DBinsILAT) -1 DO BEGIN 
                  PRINTF,lun2,outH2DBinsILAT[k],$
                         outH2DBinsMLT[j],$
                         (h2dStr[i].data)[j,k],$
                         FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
               ENDFOR 
            ENDFOR 
            CLOSE, lun2   
            FREE_LUN, lun2 
         ENDFOR 
      ENDIF 
   ENDIF

END