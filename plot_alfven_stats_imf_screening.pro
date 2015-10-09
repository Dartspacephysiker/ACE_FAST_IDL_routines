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
;                    ABS_EFLUX          :  Use absolute value of electron energy flux (required for log plots).
;                    NONEG_EFLUX        :  Do not use negative e fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOS_EFLUX        :  Do not use positive e fluxes in any of the plots
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
; COMMON BLOCKS:
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
                                     OUTPUTPLOTSUMMARY=outputPlotSummary, MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, DEL_PS=del_PS, $
                                     _EXTRA = e

;;  COMPILE_OPT idl2

  ;;variables to be used by interp_contplot.pro
  ;;COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNEGMC

  !EXCEPT=0                                                      ;Do report errors, please
  ;;***********************************************
  ;;Tons of defaults
  
  ;ranges in MLT and ILAT
  ;Note, in Chaston's 2007 paper, "How important are dispersive Alfvén waves?", the occurrence plot
  ; has ilat bin size = 3.0 and mlt bin size = 1.0

  defCharERange = [4.0,300]
  defAltRange = [1000.0, 5000.0]

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

  defTempDir='/SPENCEdata/Research/Cusp/ACE_FAST/temp/'
  
  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, NUMORBLIM=numOrbLim, $
                                  minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, $
                                  PARAMSTRING=paramStr, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                  LUN=lun
  
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
     medHistOutData = 1
  ENDIF

  IF N_ELEMENTS(DEL_PS) EQ 0 THEN del_ps = 1

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

  ;;doing polar contour?
  polarContStr=''
  IF KEYWORD_SET(polarContour) THEN BEGIN
     polarContStr='polarCont_'
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

  ;;********************************************
  ;;Stuff for output
  IF KEYWORD_SET(medianplot) THEN plotMedOrAvg = "med_" ELSE BEGIN
     IF KEYWORD_SET(logAvgPlot) THEN plotMedOrAvg = "logAvg_" ELSE plotMedOrAvg = "avg_"
  ENDELSE

  ;;********************************************
  ;;A few other strings to tack on
  ;;tap DBs, and setup output
  IF KEYWORD_SET(no_burstData) THEN inc_burstStr ='burstData_excluded--' ELSE inc_burstStr=''

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr=''
  IF N_ELEMENTS(maskMin) EQ 0 THEN maskMin = defMaskMin $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='maskMin_' + STRCOMPRESS(maskMin,/REMOVE_ALL) + '_'
     ENDIF
  ENDELSE
  
  ;;parameter string
  paramStr=paramStr+plotMedOrAvg+maskStr+inc_burstStr + polarContStr

  ;;Open file for text summary, if desired
  IF KEYWORD_SET(outputPlotSummary) THEN $
     OPENW,lun,plotDir + 'outputSummary_'+paramStr+'.txt',/GET_LUN $
  ELSE lun=-1                   ;-1 is lun for STDOUT
  
  ;;Now run these to clean and tap the databases and interpolate satellite data
  final_i = get_chaston_ind(maximus,satellite,lun, $
                            DBTIMES=cdbTime,dbfile=dbfile,CHASTDB=do_chastdb, HEMI=hemi, $
                            ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                            MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                            HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData)
  phiChast = interp_mag_data(final_i,satellite,delay,lun,DBTIMES=cdbTime, $
                             FASTDBINTERP_I=cdbInterp_i,FASTDBSATPROPPEDINTERPED_I=cdbSatProppedInterped_i,MAG_UTC=mag_utc,PHICLOCK=phiClock, $
                             DATADIR=dataDir,SMOOTHWINDOW=smoothWindow, $
                             BYMIN=byMin,BZMIN=bzMin,BYMAX=byMax,BZMAX=bzMax, $
                             OMNI_COORDS=omni_Coords)
  phiImf_ii = check_imf_stability(clockStr,angleLim1,angleLim2,phiChast,cdbSatProppedInterped_i,stableIMF,mag_utc,phiClock,$
                                 LUN=lun,bx_over_bybz=Bx_over_ByBz_Lim)
  
  plot_i=cdbInterp_i[phiImf_ii]

  ;;********************************************************
  ;;WHICH ORBITS ARE UNIQUE?
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."
  
  ;;***********************************************
  ;;Calculate Poynting flux estimate
  
  ;;1.0e-9 to take stock of delta_b being recorded in nT
  ;;Since E is recorded in mV/m, units of POYNTEST here are mW/m^2
  ;;No need to worry about screening for FINITE(pfluxEst), since both delta_B and delta_E are
  ;;screened for finiteness in alfven_db_cleaner (which is called in get_chaston_ind.pro)
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

  printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
  printf,lun,"Number of orbits used: " + strtrim(N_ELEMENTS(uniqueOrbs_ii),2)
  printf,lun,"Total number of events used: " + strtrim(N_ELEMENTS(plot_i),2)
;; printf,lun,"Percentage of Chaston DB used: " + $
;;        strtrim((N_ELEMENTS(plot_i))/134925.0*100.0,2) + "%"
  printf,lun,"Percentage of current DB used: " + $
         strtrim((N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0,2) + "%"

  ;;********************************************
  ;;junk=where(cdbInterp_i(phi_dusk_ii) EQ cdbInterp_i(phi_dawn_ii))
  ;;IF n_elements(junk) EQ 1 THEN BEGIN 
  ;;	IF junk NE -1 THEN PRINTF,LUN,"NO!!!! JUNK ISN'T JUNK!!!" 
  ;;ENDIF
  ;;********************************************************
  ;;HISTOS

  minM=FLOOR(minM*4.0)/4.0  ;to 1/4 precision
  maxM=FLOOR(maxM*4.0)/4.0 
  minI=FLOOR(minI*4.0)/4.0 
  maxI=FLOOR(maxI*4.0)/4.0 
  
  ;;########Flux_N and Mask########
  ;;First, histo to show where events are

  GET_NEVENTS_AND_MASK,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                       H2DSTR=h2dStr,H2DMASKSTR=h2dMaskStr,TMPLT_h2dStr=tmplt_h2dStr, $
                       DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme

  IF KEYWORD_SET(nPlots) THEN h2dStr=[h2dStr,h2dMaskStr] ELSE h2dStr = h2dMaskStr

  ;;########ELECTRON FLUX########
  IF KEYWORD_SET(eplots) THEN BEGIN

     GET_ELEC_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                           EFLUXPLOTTYPE=eFluxPlotType,NOPOS_EFLUX=noPos_eFlux,NONEG_EFLUX=noNeg_eFlux,LOGEFPLOT=logEfPlot, $
                           H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                           DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                           MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,LOGAVGPLOT=logAvgPlot,EPLOTRANGE=ePlotRange
  ENDIF

  ;;########ELECTRON NUMBER FLUX########
  IF KEYWORD_SET(eNumFlPlots) THEN BEGIN

     h2dENumStr={tmplt_h2dStr}

     ;;If not allowing negative fluxes
     IF STRLOWCASE(eNumFlPlotType) EQ STRLOWCASE("Total_Eflux_Integ") THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.total_eflux_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegENumFl) THEN BEGIN
           no_negs_i=WHERE(maximus.total_eflux_integ GE 0.0)
           print,"N elements in elec #flux data before junking neg elecNumFData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_negs_i,plot_i)
           print,"N elements in elec #flux data after junking neg elecNumFData: ",N_ELEMENTS(plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosENumFl) THEN BEGIN
              no_pos_i=WHERE(maximus.total_eflux_integ LT 0.0)
              print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
              print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(plot_i)
           ENDIF
        ENDELSE
        elecNumFData= maximus.total_eflux_integ(plot_i) 
     ENDIF ELSE BEGIN
        IF STRLOWCASE(eNumFlPlotType) EQ STRLOWCASE("Eflux_Losscone_Integ") THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.eflux_losscone_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegENumFl) THEN BEGIN
              no_negs_i=WHERE(maximus.eflux_losscone_integ GE 0.0)
              print,"N elements in elec data before junking neg elecNumFData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
              print,"N elements in elec data after junking neg elecNumFData: ",N_ELEMENTS(plot_i)
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosENumFl) THEN BEGIN
                 no_pos_i=WHERE(maximus.eflux_losscone_integ LT 0.0)
                 print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
                 print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(plot_i)
              ENDIF
           ENDELSE
           elecNumFData = maximus.eflux_losscone_integ(plot_i)
        ENDIF ELSE BEGIN
           IF STRLOWCASE(eNumFlPlotType) EQ STRLOWCASE("ESA_Number_flux") THEN BEGIN
              plot_i=cgsetintersection(WHERE(FINITE(maximus.esa_current),NCOMPLEMENT=lost),plot_i) ;;NaN check
              print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
              IF KEYWORD_SET(noNegENumFl) THEN BEGIN
                 no_negs_i=WHERE(maximus.esa_current GE 0.0)
                 print,"N elements in elec #flux data before junking neg elecNumFData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_negs_i,plot_i)
                 print,"N elements in elec #flux data after junking neg elecNumFData: ",N_ELEMENTS(plot_i)
              ENDIF ELSE BEGIN
                 IF KEYWORD_SET(noPosENumFl) THEN BEGIN
                    no_pos_i=WHERE(maximus.esa_current LT 0.0)
                    print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(plot_i)
                    plot_i=cgsetintersection(no_pos_i,plot_i)        
                    print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(plot_i)
                 ENDIF
              ENDELSE
           ENDIF
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           elecNumFData= maximus.esa_current(plot_i) * 1. / 1.6e-9
        ENDELSE
     ENDELSE

     ;;Handle name of data
     ;;Log plots desired?
     absEFStr=""
     negEFStr=""
     posEFStr=""
     logEFStr=""
     IF KEYWORD_SET(abs_eFlux)THEN BEGIN
        absEFStr= "Abs--" 
        print,"N pos elements in elec data: ",N_ELEMENTS(where(elecNumFData GT 0.))
        print,"N neg elements in elec data: ",N_ELEMENTS(where(elecNumFData LT 0.))
        elecNumFData = ABS(elecNumFData)
     ENDIF
     IF KEYWORD_SET(noNegENumFl) THEN BEGIN
        negEStr = "NoNegs--"
        print,"N elements in elec data before junking neg elecNumFData: ",N_ELEMENTS(elecNumFData)
        elecNumFData = elecNumFData(where(elecNumFData GT 0.))
        print,"N elements in elec data after junking neg elecNumFData: ",N_ELEMENTS(elecNumFData)
     ENDIF
     IF KEYWORD_SET(noPosENumFl) THEN BEGIN
        posEStr = "NoPos--"
        print,"N elements in elec data before junking pos elecNumFData: ",N_ELEMENTS(elecNumFData)
        elecNumFData = elecNumFData(where(elecNumFData LT 0.))
        print,"N elements in elec data after junking pos elecNumFData: ",N_ELEMENTS(elecNumFData)
        elecNumFData = ABS(elecNumFData)
     ENDIF
     IF KEYWORD_SET(logENumFlPlot) THEN logEFStr="Log "
     absnegslogEFStr=absEFStr + negEFStr + posEFStr + logEFStr
     efDatName = STRTRIM(absnegslogEFStr,2)+"eNumFl"+eNumFlPlotType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 

        medHistDataDir = 'out/medHistData/'

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + efDatName+"medhist_data.sav"

        h2dENumStr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                 elecNumFData,$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                 ABSMED=absENumFl,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + efDatName + "medhist.txt"

     ENDIF ELSE BEGIN 

        elecNumFData=(KEYWORD_SET(logAvgPlot)) ? alog10(elecNumFData) : elecNumFData

        h2dENumStr.data=hist2d(maximus.mlt(plot_i), $
                            maximus.ilat(plot_i),$
                            elecNumFData,$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI,$
                            OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dENumStr.data(where(h2dFluxN NE 0,/NULL))=h2dENumStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
        IF KEYWORD_SET(logAvgPlot) THEN h2dENumStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dENumStr.data(where(h2dFluxN NE 0,/null)))        

     ENDELSE

     ;data mods?
     IF KEYWORD_SET(absENumFl)THEN BEGIN 
        h2dENumStr.data = ABS(h2dENumStr.data) 
        IF keepMe THEN elecNumFData=ABS(elecNumFData) 
     ENDIF
     IF KEYWORD_SET(logENumFlPlot) THEN BEGIN 
        h2dENumStr.data(where(h2dENumStr.data GT 0,/NULL))=ALOG10(h2dENumStr.data(where(h2dENumStr.data GT 0,/null))) 
        IF keepMe THEN elecNumFData(where(elecNumFData GT 0,/null))=ALOG10(elecNumFData(where(elecNumFData GT 0,/null))) 
     ENDIF

     ;;Do custom range for ENumFl plots, if requested
     IF  KEYWORD_SET(ENumFlPlotRange) THEN h2dENumStr.lim=ENumFlPlotRange $
     ELSE h2dENumStr.lim = [MIN(h2dENumStr.data),MAX(h2dENumStr.data)]

     h2dENumStr.title= absnegslogEFstr + "Electron Number Flux (#/cm!U2!N-s)"
     ;; IF KEYWORD_SET(eNumFlPlots) THEN BEGIN 
     h2dStr=[h2dStr,h2dENumStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,efDatName] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(elecNumFData)] 
     ENDIF 
     ;; ENDIF

  ENDIF

  ;;########Poynting Flux########
  IF KEYWORD_SET(pplots) THEN BEGIN

     h2dPStr={tmplt_h2dStr}

     ;;check for NaNs
     goodPF_i = WHERE(FINITE(pfluxEst),NCOMPLEMENT=lostNans)
     IF goodPF_i[0] NE -1 THEN BEGIN
        print,"Found some NaNs in Poynting flux! Losing another " + strcompress(lostNans,/REMOVE_ALL) + " events..."
        plot_i = cgsetintersection(plot_i,goodPF_i)
     ENDIF
     
     IF KEYWORD_SET(noNegPflux) THEN BEGIN
        no_negs_i=WHERE(pfluxEst GE 0.0)
        plot_i=cgsetintersection(no_negs_i,plot_i)
     ENDIF

     IF KEYWORD_SET(noPosPflux) THEN BEGIN
        no_pos_i=WHERE(pfluxEst LE 0.0)
        plot_i=cgsetintersection(no_pos_i,plot_i)
     ENDIF

     ;;Log plots desired?
     absPstr=""
     negPstr=""
     posPstr=""
     logPstr=""
     IF KEYWORD_SET(absPflux) THEN absPstr= "Abs"
     IF KEYWORD_SET(noNegPflux) THEN negPstr = "NoNegs--"
     IF KEYWORD_SET(noPosPflux) THEN posPstr = "NoPos--"
     IF KEYWORD_SET(logPfPlot) THEN logPstr="Log "
     absnegslogPstr=absPstr + negPstr + posPstr + logPstr
     pfDatName = STRTRIM(absnegslogPstr,2)+"pFlux_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + pfDatName+"medhist_data.sav"

        h2dPstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                 pfluxEst(plot_i),$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                 ABSMED=absPflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + pfDatName + "medhist.txt"

     ENDIF ELSE BEGIN 
        IF KEYWORD_SET(logAvgPlot) THEN BEGIN
           pfluxEst(where(pfluxEst NE 0,/null)) = ALOG10(pfluxEst(where(pfluxEst NE 0,/null)))
        ENDIF

        h2dPStr.data=hist2d(maximus.mlt(plot_i),$
                            maximus.ilat(plot_i),$
                            pfluxEst(plot_i),$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI) 
        h2dPStr.data(where(h2dFluxN NE 0,/null))=h2dPStr.data(where(h2dFluxN NE 0,/null))/h2dFluxN(where(h2dFluxN NE 0,/null)) 
        IF KEYWORD_SET(logAvgPlot) THEN h2dPStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dPStr.data(where(h2dFluxN NE 0,/null)))
     ENDELSE

     IF KEYWORD_SET(writeHDF5) or KEYWORD_SET(writeASCII) OR NOT KEYWORD_SET(squarePlot) OR KEYWORD_SET(saveRaw) THEN pData=pfluxEst(plot_i)

     ;;data mods?
     IF KEYWORD_SET(absPflux) THEN BEGIN 
        h2dPStr.data = ABS(h2dPStr.data) 
        IF keepMe THEN pData=ABS(pData) 
     ENDIF

     IF KEYWORD_SET(logPfPlot) THEN BEGIN 
        h2dPStr.data(where(h2dPStr.data GT 0,/null))=ALOG10(h2dPStr.data(where(h2dPStr.data GT 0,/NULL))) 
        IF keepMe THEN pData(where(pData GT 0,/NULL))=ALOG10(pData(where(pData GT 0,/NULL))) 
     ENDIF

     h2dPStr.title= absnegslogPstr + "Poynting Flux (mW/m!U2!N)"

     ;;Do custom range for Pflux plots, if requested
     ;; IF KEYWORD_SET(PPlotRange) THEN h2dPStr.lim=TEMPORARY(PPlotRange)$
     IF KEYWORD_SET(PPlotRange) THEN h2dPStr.lim=PPlotRange $
     ELSE h2dPStr.lim = [MIN(h2dPstr.data),MAX(h2dPstr.data)]

     ;;IF pPlots NE 0 THEN BEGIN 
     ;;  IF ePlots NE 0 THEN h2dStr=[h2dStr,TEMPORARY(h2dPStr)] $
     ;;  ELSE h2dStr=[TEMPORARY(h2dPStr)] 
     ;;ENDIF
     ;; IF KEYWORD_SET(pPlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dPStr)] 
     ;; IF KEYWORD_SET(pPlots) THEN BEGIN & 
     h2dStr=[h2dStr,h2dPStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,pfDatName] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(pData)] 
     ENDIF  
     ;; ENDIF

;;   undefine,h2dPStr

  ENDIF


  ;;########ION FLUX########
  IF KEYWORD_SET(ionPlots) THEN BEGIN
     h2dIStr={tmplt_h2dStr}

     ;;If not allowing negative fluxes
     IF iFluxPlotType EQ "Integ" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegIflux) THEN BEGIN
           no_negs_i=WHERE(maximus.integ_ion_flux GE 0.0)
           print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_negs_i,plot_i)
           print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosIflux) THEN BEGIN
              no_pos_i=WHERE(maximus.integ_ion_flux LE 0.0)
              print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
              print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
           ENDIF
        ENDELSE
     ionData=maximus.integ_ion_flux(plot_i) 
     ENDIF ELSE BEGIN
        IF ifluxPlotType EQ "Max" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegIflux) THEN BEGIN
              no_negs_i=WHERE(maximus.ion_flux GE 0.0)
              print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
              print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosIflux) THEN BEGIN
                 no_pos_i=WHERE(maximus.ion_flux LE 0.0)
                 print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
                 print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
              ENDIF
           ENDELSE
           ionData=maximus.ion_flux(plot_i)
        ENDIF ELSE BEGIN
           IF ifluxPlotType EQ "Max_Up" THEN BEGIN
              plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
              print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
              IF KEYWORD_SET(noNegIflux) THEN BEGIN
                 no_negs_i=WHERE(maximus.ion_flux_up GE 0.0)
                 print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_negs_i,plot_i)        
                 print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
              ENDIF ELSE BEGIN
                 IF KEYWORD_SET(noPosIflux) THEN BEGIN
                    no_pos_i=WHERE(maximus.ion_flux_up LE 0.0)
                    print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                    plot_i=cgsetintersection(no_pos_i,plot_i)        
                    print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
                 ENDIF
              ENDELSE
              ionData=maximus.ion_flux_up(plot_i)
           ENDIF ELSE BEGIN
              IF ifluxPlotType EQ "Integ_Up" THEN BEGIN
                 plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
                 print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                 IF KEYWORD_SET(noNegIflux) THEN BEGIN
                    no_negs_i=WHERE(maximus.integ_ion_flux_up GE 0.0)
                    print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
                    plot_i=cgsetintersection(no_negs_i,plot_i)        
                    print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
                 ENDIF ELSE BEGIN
                    IF KEYWORD_SET(noPosIflux) THEN BEGIN
                       no_pos_i=WHERE(maximus.integ_ion_flux_up LE 0.0)
                       print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                       plot_i=cgsetintersection(no_pos_i,plot_i)        
                       print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
                    ENDIF
                 ENDELSE
                 ionData=maximus.integ_ion_flux_up(plot_i)
              ENDIF ELSE BEGIN
                 IF ifluxPlotType EQ "Energy" THEN BEGIN
                    plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
                    print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                    IF KEYWORD_SET(noNegIflux) THEN BEGIN
                       no_negs_i=WHERE(maximus.ion_energy_flux GE 0.0)
                       print,"N elements in ion data before junking neg ionData: ",N_ELEMENTS(plot_i)
                       plot_i=cgsetintersection(no_negs_i,plot_i)        
                       print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(plot_i)
                    ENDIF ELSE BEGIN
                       IF KEYWORD_SET(noPosIflux) THEN BEGIN
                          no_pos_i=WHERE(maximus.ion_energy_flux LE 0.0)
                          print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(plot_i)
                          plot_i=cgsetintersection(no_pos_i,plot_i)        
                          print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(plot_i)
                       ENDIF
                    ENDELSE
                    ionData=maximus.ion_energy_flux(plot_i)
                 ENDIF
              ENDELSE
           ENDELSE
        ENDELSE
     ENDELSE

     ;;Log plots desired?
     absIonStr=""
     negIonStr=""
     posIonStr=""
     logIonStr=""
     IF KEYWORD_SET(absIflux)THEN BEGIN
        absIonStr= "Abs--" 
        print,"N pos elements in ion data: ",N_ELEMENTS(where(ionData GT 0.))
        print,"N neg elements in ion data: ",N_ELEMENTS(where(ionData LT 0.))
        ionData = ABS(ionData)
     ENDIF
     IF KEYWORD_SET(noNegIflux) THEN BEGIN
        negIonStr = "NoNegs--"
        ionData = ionData(where(ionData GT 0.))
        print,"N elements in ion data after junking neg ionData: ",N_ELEMENTS(ionData)
     ENDIF
     IF KEYWORD_SET(noPosIflux) THEN BEGIN
        posIonStr = "NoPos--"
        print,"N elements in ion data before junking pos ionData: ",N_ELEMENTS(ionData)
        ionData = ionData(where(ionData LT 0.))
        print,"N elements in ion data after junking pos ionData: ",N_ELEMENTS(ionData)
        ionData = ABS(ionData)
     ENDIF
     IF KEYWORD_SET(logIfPlot) THEN logIonStr="Log "
     absnegslogIonStr=absIonStr + negIonStr + posIonStr + logIonStr
     ifDatName = STRTRIM(absnegslogIonStr,2)+"iflux"+ifluxPlotType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + ifDatName+"medhist_data.sav"

        h2dIStr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                 ionData,$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                 ABSMED=absIflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + ifDatName + "medhist.txt"

     ENDIF ELSE BEGIN 
        ionData=(KEYWORD_SET(logAvgPlot)) ? alog10(ionData) : ionData
        h2dIStr.data=hist2d(maximus.mlt(plot_i), $
                            maximus.ilat(plot_i),$
                            ionData,$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI,$
                            OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dIStr.data(where(h2dFluxN NE 0,/NULL))=h2dIStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
        IF KEYWORD_SET(logAvgPlot) THEN h2dIStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dIStr.data(where(h2dFluxN NE 0,/null)))        
     ENDELSE 

     ;;data mods?
     IF KEYWORD_SET(absIflux)THEN BEGIN 
        h2dIStr.data = ABS(h2dIStr.data) 
        IF keepMe THEN ionData=ABS(ionData) 
     ENDIF
     IF KEYWORD_SET(logIfPlot) THEN BEGIN 
        h2dIStr.data(where(h2dIStr.data GT 0,/NULL))=ALOG10(h2dIStr.data(where(h2dIStr.data GT 0,/null))) 
        IF keepMe THEN ionData(where(ionData GT 0,/null))=ALOG10(ionData(where(ionData GT 0,/null))) 
     ENDIF

     ;;Do custom range for Iflux plots, if requested
     IF  KEYWORD_SET(iPlotRange) THEN h2dIStr.lim=iPlotRange $
     ELSE h2dIStr.lim = [MIN(h2dIStr.data),MAX(h2dIStr.data)]

     h2dIStr.title= absnegslogIonStr + "Ion Flux (ergs/cm!U2!N-s)"
     ;; IF KEYWORD_SET(ionPlots) THEN BEGIN & 
     h2dStr=[h2dStr,h2dIStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,STRTRIM(absnegslogIonStr,2)+"iflux"+ifluxPlotType+"_"] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(ionData)] 
     ENDIF 
     ;; ENDIF

  ENDIF

  ;;########CHARACTERISTIC ENERGY########
  IF KEYWORD_SET(charEPlots) THEN BEGIN

     h2dCharEStr={tmplt_h2dStr}

     ;;If not allowing negative fluxes
     IF charEType EQ "lossCone" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_losscone),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegCharE) THEN BEGIN
           no_negs_i=WHERE(maximus.max_chare_losscone GE 0.0)
           print,"N elements in elec data before junking negs elecData: ",N_ELEMENTS(plot_i)
           plot_i=cgsetintersection(no_negs_i,plot_i)
           print,"N elements in elec data after junking negs elecData: ",N_ELEMENTS(plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosCharE) THEN BEGIN
              no_pos_i=WHERE(maximus.max_chare_losscone LT 0.0)
              print,"N elements in elec data before junking pos elecData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
              print,"N elements in elec data after junking pos elecData: ",N_ELEMENTS(plot_i)
           ENDIF
        ENDELSE
        charEData=maximus.max_chare_losscone(plot_i) 
     ENDIF ELSE BEGIN
        IF charEType EQ "Total" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_total),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegCharE) THEN BEGIN
              no_negs_i=WHERE(maximus.max_chare_total GE 0.0)
              print,"N elements in elec data before junking neg elecData: ",N_ELEMENTS(plot_i)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
              print,"N elements in elec data after junking neg elecData: ",N_ELEMENTS(plot_i)
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosCharE) THEN BEGIN
                 no_pos_i=WHERE(maximus.max_chare_total LT 0.0)
                 print,"N elements in elec data before junking pos elecData: ",N_ELEMENTS(plot_i)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
                 print,"N elements in elec data after junking pos elecData: ",N_ELEMENTS(plot_i)
              ENDIF
           ENDELSE
           charEData=maximus.max_chare_total(plot_i)
        ENDIF
     ENDELSE

     ;get data name ready
     absCharEStr=""
     negCharEStr=""
     posCharEStr=""
     logCharEStr=""
     IF KEYWORD_SET(absCharE)THEN absCharEStr= "Abs--" 
     IF KEYWORD_SET(noNegCharE) THEN negCharEStr = "NoNegs--"
     IF KEYWORD_SET(noPosCharE) THEN posCharEStr = "NoPos--"
     IF KEYWORD_SET(logCharEPlot) THEN logCharEStr="Log "
     absnegslogCharEStr=absCharEStr + negCharEStr + posCharEStr + logCharEStr
     chareDatName = STRTRIM(absnegslogCharEStr,2)+"charE"+charEType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 
        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + chareDatName+"medhist_data.sav"

        h2dCharEStr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                     charEData,$
                                     MIN1=MINM,MIN2=MINI,$
                                     MAX1=MAXM,MAX2=MAXI,$
                                     BINSIZE1=binM,BINSIZE2=binI,$
                                     OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                     ABSMED=absCharE,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + chareDatName + "medhist.txt"
        
     ENDIF ELSE BEGIN 
        charEData=(KEYWORD_SET(logAvgPlot)) ? alog10(charEData) : charEData

        h2dCharEStr.data=hist2d(maximus.mlt(plot_i), $
                                maximus.ilat(plot_i),$
                                charEData,$
                                MIN1=MINM,MIN2=MINI,$
                                MAX1=MAXM,MAX2=MAXI,$
                                BINSIZE1=binM,BINSIZE2=binI,$
                                OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dCharEStr.data(where(h2dFluxN NE 0,/NULL))=h2dCharEStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
        IF KEYWORD_SET(logAvgPlot) THEN h2dCharEStr.data(where(h2dFluxN NE 0,/null)) = 10^(h2dCharEStr.data(where(h2dFluxN NE 0,/null)))        
     ENDELSE 

     ;;data mods?
     IF KEYWORD_SET(absCharE)THEN BEGIN 
        h2dCharEStr.data = ABS(h2dCharEStr.data) 
        IF keepMe THEN charEData=ABS(charEData) 
     ENDIF
     IF KEYWORD_SET(logCharEPlot) THEN BEGIN 
        h2dCharEStr.data(where(h2dCharEStr.data GT 0,/NULL))=ALOG10(h2dCharEStr.data(where(h2dCharEStr.data GT 0,/null))) 
        IF keepMe THEN charEData(where(charEData GT 0,/null))=ALOG10(charEData(where(charEData GT 0,/null))) 
     ENDIF

     ;;Do custom range for charE plots, if requested
     ;; IF  KEYWORD_SET(CharEPlotRange) THEN h2dCharEStr.lim=TEMPORARY(charEPlotRange)$
     IF  KEYWORD_SET(CharEPlotRange) THEN h2dCharEStr.lim=CharEPlotRange $
     ELSE h2dCharEStr.lim = [MIN(h2dCharEStr.data),MAX(h2dCharEStr.data)]

     h2dCharEStr.title= absnegslogCharEStr + "Characteristic Energy (eV)"
     ;; IF KEYWORD_SET(charEPlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dCharEStr)] 
     ;; IF KEYWORD_SET(charEPlots) THEN BEGIN 
     h2dStr=[h2dStr,h2dCharEStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,chareDatName] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(charEData)]
     ENDIF 
     ;; ENDIF

;;   undefine,h2dCharEStr   ;;,charEData 

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
     
     h2dOrbStr={tmplt_h2dStr}

     h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))
     orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))

     FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
        tempOrb=maximus.orbit(plot_i(uniqueOrbs_ii(j))) 
        temp_ii=WHERE(maximus.orbit(plot_i) EQ tempOrb,/NULL) 
        h2dOrbTemp=hist_2d(maximus.mlt(plot_i(temp_ii)),$
                           maximus.ilat(plot_i(temp_ii)),$
                           BIN1=binM,BIN2=binI,$
                           MIN1=MINM,MIN2=MINI,$
                           MAX1=MAXM,MAX2=MAXI) 
        orbARR[j,*,*]=h2dOrbTemp 
        h2dOrbTemp(WHERE(h2dOrbTemp GT 0,/NULL)) = 1 
        h2dOrbStr.data += h2dOrbTemp 
     ENDFOR

     h2dOrbStr.title="Num Contributing Orbits"

     ;;h2dOrbStr.lim=[MIN(h2dOrbStr.data),MAX(h2dOrbStr.data)]
     IF N_ELEMENTS(orbContribRange) EQ 0 OR N_ELEMENTS(orbContribRange) NE 2 THEN h2dOrbStr.lim=[1,60] ELSE h2dOrbStr.lim=orbContribRange

     ;;Mask all bins that don't have requisite number of orbits passing through
     IF KEYWORD_SET(numOrbLim) THEN BEGIN 
        h2dStr(KEYWORD_SET(nPlots)).data(WHERE(h2dOrbStr.data LT numOrbLim)) = 255 ;mask 'em!

        ;;little check to see how many more elements are getting masked
        ;;exc_orb_i = where(h2dOrbStr.data LT numOrbLim)
        ;;masked_i = where(h2dStr(1).data EQ 255)
        ;;print,n_elements(exc_orb_i) - n_elements(cgsetintersection(exc_orb_i,masked_i))
        ;;8

     ENDIF
        
     IF KEYWORD_SET(orbContribPlot) THEN BEGIN 
        h2dStr=[h2dStr,h2dOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,"orbsContributing_"] 
     ENDIF

  ENDIF

  ;;########TOTAL Orbits########
  IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) THEN BEGIN

     ;;uniqueOrbs_ii=UNIQ(maximus.orbit(ind_region_magc_geabs10_acestart),SORT(maximus.orbit(ind_region_magc_geabs10_acestart)))
     uniqueOrbs_ii=UNIQ(maximus.orbit,SORT(maximus.orbit))

     h2dTotOrbStr={tmplt_h2dStr}
     orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))
     h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))


     ;;FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
     ;;   tempOrb=maximus.orbit(ind_region_magc_geabs10_acestart(uniqueOrbs_ii(j))) 
     ;;   temp_ii=WHERE(maximus.orbit(ind_region_magc_geabs10_acestart) EQ tempOrb) 
     ;;   h2dOrbTemp=hist_2d(maximus.mlt(ind_region_magc_geabs10_acestart(temp_ii)),$
     ;;                      maximus.ilat(ind_region_magc_geabs10_acestart(temp_ii)),$
     ;;                      BIN1=binM,BIN2=binI,$
     ;;                      MIN1=MINM,MIN2=MINI,$
     ;;                      MAX1=MAXM,MAX2=MAXI) 
     ;;   orbARR[j,*,*]=h2dOrbTemp 
     ;;   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 
     ;;   h2dTotOrbStr.data += h2dOrbTemp 
     ;;ENDFOR

     FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
        tempOrb=maximus.orbit(uniqueOrbs_ii(j)) 
        temp_ii=WHERE(maximus.orbit EQ tempOrb,/NULL) 
        h2dOrbTemp=hist_2d(maximus.mlt(temp_ii),$
                           maximus.ilat(temp_ii),$
                           BIN1=binM,BIN2=binI,$
                           MIN1=MINM,MIN2=MINI,$
                           MAX1=MAXM,MAX2=MAXI) 
        orbARR[j,*,*]=h2dOrbTemp 
        h2dOrbTemp(WHERE(h2dOrbTemp GT 0,/NULL)) = 1 
        h2dTotOrbStr.data += h2dOrbTemp 
     ENDFOR

     h2dTotOrbStr.title="Total Orbits"
     IF N_ELEMENTS(orbTotRange) EQ 0 OR N_ELEMENTS(orbTotRange) NE 2 THEN h2dTotOrbStr.lim=[MIN(h2dTotOrbStr.data),MAX(h2dTotOrbStr.data)] $ 
     ELSE h2dTotOrbStr.lim=orbTotRange

     IF KEYWORD_SET(orbTotPlot) THEN BEGIN & h2dStr=[h2dStr,h2dTotOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,"orbTot_"] 
     ENDIF
     
  ENDIF

  ;;########Orbit FREQUENCY########
  IF KEYWORD_SET(orbfreqplot) THEN BEGIN

     h2dFreqOrbStr={tmplt_h2dStr}
     h2dFreqOrbStr.data=h2dOrbStr.data
     h2dFreqOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))=h2dOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))/h2dTotOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))
     h2dFreqOrbStr.title="Orbit Frequency"
     ;;h2dFreqOrbStr.lim=[MIN(h2dFreqOrbStr.data),MAX(h2dFreqOrbStr.data)]
     IF N_ELEMENTS(orbFreqRange) EQ 0 OR N_ELEMENTS(orbFreqRange) NE 2 THEN h2dFreqOrbStr.lim=[0,0.5] ELSE h2dFreqOrbStr.lim=orbFreqRange

     h2dStr=[h2dStr,h2dFreqOrbStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,"orbFreq_"] 

     ;;What if I use indices where neither tot orbits nor contributing orbits is zero?
     orbs_w_events_histo_i=where(h2dorbstr.data NE 0)
     orbs_histo_i=where(h2dtotorbstr.data NE 0)
     orbfreq_histo_i=cgsetintersection(orbs_w_events_histo_i,orbs_histo_i)
     h2dnewdata=h2dOrbStr.data
     h2dnewdata(orbfreq_histo_i)=h2dOrbStr.data(orbfreq_histo_i)/h2dTotOrbStr.data(orbfreq_histo_i)
     diff=where(h2dfreqorbstr.data NE h2dnewdata)
     ;;  print,diff
     wait, 2
  ENDIF
     
  ;;########NEvents/orbit########
  IF KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN 

     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.
     h2dNEvPerOrbStr={tmplt_h2dStr}
     h2dNEvPerOrbStr.data=h2dStr(0).data
     h2dNonzeroNEv_i=WHERE(h2dStr(0).data NE 0,/NULL)
     IF KEYWORD_SET(divNEvByApplicable) THEN BEGIN
        divisor = h2dOrbStr.data(h2dNevPerOrb_i) ;Only divide by number of orbits that occurred during specified IMF conditions
     ENDIF ELSE BEGIN
        divisor = h2dTotOrbStr.data(h2dNonzeroNEv_i) ;Divide by all orbits passing through relevant bin
     ENDELSE
     h2dNEvPerOrbStr.data(h2dNonzeroNEv_i)=h2dNEvPerOrbStr.data(h2dNonzeroNEv_i)/divisor

     logNEvStr=""
     nEvByAppStr=""
     IF KEYWORD_SET(logNEventPerOrb) THEN logNEvStr="Log "
     IF KEYWORD_SET(divNEvByApplicable) THEN nEvByAppStr="Applicable_"
     h2dNEvPerOrbStr.title= logNEvStr + 'Number of Events per ' + nEvByAppStr + 'Orbit'

     IF N_ELEMENTS(nEventPerOrbRange) EQ 0 OR N_ELEMENTS(nEventPerOrbRange) NE 2 THEN BEGIN
        IF N_ELEMENTS(logNEventPerOrb) EQ 0 THEN h2dNEvPerOrbStr.lim=[0,7] ELSE h2dNEvPerOrbStr.lim=[-2,1]
     ENDIF ELSE h2dNEvPerOrbStr.lim=nEventPerOrbRange
     
     IF KEYWORD_SET(logNEventPerOrb) THEN BEGIN 
        h2dNEvPerOrbStr.data(where(h2dNEvPerOrbStr.data GT 0,/NULL))=ALOG10(h2dNEvPerOrbStr.data(where(h2dNEvPerOrbStr.data GT 0,/null))) 
     ENDIF

     h2dStr=[h2dStr,h2dNEvPerOrbStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,logNEvStr + "nEventPerOrb_" +nEvByAppStr] 

  ENDIF

  ;;########NEvents/minute########
  IF KEYWORD_SET(nEventPerMinPlot) THEN BEGIN 

     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.
     h2dNEvPerMinStr={tmplt_h2dStr}
     h2dNEvPerMinStr.data=h2dStr(0).data
     h2dNonzeroNEv_i=WHERE(h2dStr(0).data NE 0,/NULL)

     ;Get the appropriate divisor for IMF conditions
     get_fastloc_inds_IMF_conds,fastLoc_inds,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                BYMIN=byMin,BZMIN=bzMin, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCDIR=fastLocDir, /MAKE_OUTINDSFILE, $
                                BURSTDATA_EXCLUDED=no_burstData

     make_fastloc_histo,TIMEHISTO=divisor,FASTLOC_INDS=fastLoc_inds, $
                        MINMLT=minM,MAXMLT=maxM,BINMLT=binM, $
                        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                        DELTA_T=delta_T, $
                        FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                        OUTFILEPREFIX=outFilePrefix,OUTFILESUFFIX=outFileSuffix, OUTDIR=outDir, $
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
                           rawDir,clockStr,plotMedOrAvg,stableIMF,hoyDia,hemstr,$
                           filename=defTempDir + 'polarplots_'+paramStr+".dat"

  ;;if not saving plots and plots not turned off, do some stuff  ;; otherwise, make output
  IF KEYWORD_SET(showPlotsNoSave) THEN BEGIN 
     IF N_ELEMENTS(justData) EQ 0 AND KEYWORD_SET(squarePlot) THEN $
        cgWindow, 'interp_contplotmulti_str', h2dStr,$
                  Background='White', $
                  WTitle='Flux plots for '+hemStr+'ern Hemisphere, '+clockStr+ $
                  ' IMF, ' + strmid(plotMedOrAvg,1) $
     ELSE IF N_ELEMENTS(justData) EQ 0 THEN $  ;FOR j=0, N_ELEMENTS(h2dStr)-1 DO $
        ;;    cgWindow,'interp_polar_plot',[[*dataRawPtrArr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
                ;;             h2dStr[0].lim,Background="White",wxsize=800,wysize=600, $
                ;;             WTitle='Polar plot_'+dataNameArr[0]+','+hemStr+'ern Hemisphere, '+clockStr+ $
                ;;             ' IMF, ' + strmid(plotMedOrAvg,1) $
        FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO $ 
           cgWindow,'interp_polar2dhist',h2dStr[i],defTempDir + 'polarplots_'+paramStr+".dat", $
                CLOCKSTR=clockStr, _extra=e,$
                Background="White",wxsize=800,wysize=600, $
                WTitle='Polar plot_'+dataNameArr[i]+','+hemStr+'ern Hemisphere, '+clockStr+ $
                ' IMF, ' + strmid(plotMedOrAvg,1) $
                
     ELSE PRINTF,LUN,"**Plots turned off with justData**" 
  ENDIF ELSE BEGIN 
     IF KEYWORD_SET(squarePlot) AND NOT KEYWORD_SET(justData) THEN BEGIN 
        CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
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
      ;;loop style for individual structures
      ;;   FOR i=0, N_ELEMENTS(h2dStr)-1 DO BEGIN 
      ;;      fname=plotDir + h2dStr[i].title+'_'+ $
      ;;            paramStr+'.h5' 
      ;;      fileID=H5F_CREATE(fname) 
      ;;      datatypeID=H5T_IDL_CREATE(h2dStr[i]) 
      ;;      dataspaceID=H5S_CREATE_SIMPLE(1) 
      ;;      datasetID = H5D_CREATE(fileID,$
      ;;                             h2dStr[i].title+'_'+hemStr+'_'+clockStr+plotMedOrAvg, $
      ;;                             datatypeID, dataspaceID) 
      ;;      H5D_WRITE,datasetID, h2dStr[i] 
      ;;      H5F_CLOSE,fileID    
      ;;   ENDFOR 

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

   ;;IF writeASCII NE 0 THEN BEGIN 
   ;;  fname=plotDir + 'fluxplots_'+paramStr+'.ascii' 
   ;;   PRINT,"Writing ASCII file: " + fname 
   ;;   OPENW,lun2, fname, /get_lun 
   ;;   PRINT_STRUCT,h2dStr,LUN_OUT=lun2 
   ;;   FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO BEGIN 
   ;;    PRINTF,lun2,h2dStr[i].title 
   ;;    PRINT,h2dStr[i].title 
   ;;    PRINTF,lun2,h2dStr[i].data 
   ;;    PRINTF,lun2,"" 
   ;;   ENDFOR 
   ;;   CLOSE, lun2 
   ;;   FREE_LUN, lun2 
   ;;ENDIF

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
            FOR j = 0, N_ELEMENTS(h2dBinsMLT) - 1 DO BEGIN 
               FOR k = 0, N_ELEMENTS(h2dBinsILAT) -1 DO BEGIN 
                  PRINTF,lun2,h2dBinsILAT[k],$
                         h2dBinsMLT[j],$
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