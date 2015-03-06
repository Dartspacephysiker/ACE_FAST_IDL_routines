;+
; NAME: PLOT_ALFVEN_STATS_IMF_SCREENING
;
;
;
; PURPOSE: Plot FAST data processed by Chris Chaston's ALFVEN_STATS_5 procedure (with mods).
;          All data are binned by MLT and ILAT (bin sizes can be set manually).
;
;
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE: PLOT_ALFVEN_STATS_IMF_SCREENING
;
;
;
; INPUTS:
;
;
;
; OPTIONAL INPUTS:   
;                *DATABASE PARAMETERS
;                    CLOCKSTR          :  Interplanetary magnetic field clock angle.
;                                            Can be 'dawnward', 'duskward', 'bzNorth', 'bzSouth', 'all_IMF',
;                                            'dawn-north', 'dawn-south', 'dusk-north', or 'dusk-south'.
;		     ANGLELIM1         :     
;		     ANGLELIM2         :     
;		     ORBRANGE          :  Two-element vector with lower and upper limit on orbits to include   
;		     ALTITUDERANGE     :  Two-element vector with lower and upper limit on altitudes to include   
;                    CHARERANGE        :  Two-element vector with lower ahd upper limit on characteristic energy of electrons in 
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
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
;		     NPLOTS            :  Plot number of orbits.   
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
;                    SMOOTHWINDOW      :  Smooth IMF data over a given window (default: 5 minutes)
;
;                *ELECTRON FLUX PLOT OPTIONS
;		     EPLOTS            :     
;                    EFLUXPLOTTYPE     :  Options are 'Integ' for integrated or 'Max' for max data point.
;                    LOGEFPLOT         :  Do log plots of electron flux.
;                    ABSEFLUX          :  Use absolute value of electron flux (required for log plots).
;                    NONEGEFLUX        :  Do not use negative e fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOSEFLUX        :  Do not use positive e fluxes in any of the plots
;                    EPLOTRANGE        :  Range of allowable values for e- flux plots. 
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
;                    NEVENTPERORBPLOT  :  Plot of number of events per orbit.
;                    NEVENTPERORBRANGE :  Range for Neventperorbplot.
;                    LOGNEVENTPERORB   :  Log of Neventperorbplot (for comparison with Chaston et al. [2003])
;                    DIVNEVBYAPPLICABLE:  Divide number of events in given bin by the number of orbits occurring 
;                                            during specified IMF conditions. (Default is to divide by total number of orbits 
;                                            pass through given bin for ANY IMF condition.)
;
;                *ASSORTED PLOT OPTIONS--APPLICABLE TO ALL PLOTS
;		     MEDIANPLOT        :  Do median plots instead of averages.
;		     LOGPLOT           :     
;		     SQUAREPLOT        :  Do plots in square bins. (Default plot is in polar stereo projection)    
;                    POLARCONTOUR      :  Do polar plot, but do a contour instead
;                    WHOLECAP*         :   *(Only for polar plot!) Plot the entire polar cap, not just a range of MLTs and ILATs
;                    MIDNIGHT*         :   *(Only for polar plot!) Orient polar plot with midnight (24MLT) at bottom
;		     DBFILE            :  Which database file to use?
;		     DATADIR           :     
;		     DO_CHASTDB        :  Use Chaston's original ALFVEN_STATS_3 database. 
;                                            (He used it for a few papers, I think, so it's good).
;                    NEVENTSRANGE      :  Range for nEvents plot.
;
;                  *VARIOUS OUTPUT OPTIONS
;		     WRITEASCII        :     
;		     WRITEHDF5         :      
;                    WRITEPROCESSEDH2D :  Use this to output processed, histogrammed data. That way you
;                                            can share with others!
;		     SAVERAW           :  Save all raw data
;		     RAWDIR            :  Directory in which to store raw data
;                    NOPLOTSJUSTDATA   :  No plots whatsoever; just give me the dataz.
;                    NOSAVEPLOTS       :  Don't save plots, just show them immediately
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
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS: 
;                    MAXIMUS           :  Return maximus structure used in this pro.
;
;
;
; COMMON BLOCKS:
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPLE: 
;     Use Chaston's original (ALFVEN_STATS_3) database, only including orbits falling in the range 1000-4230
;     plot_alfven_stats_imf_screening,clockstr="duskward",/do_chastdb,$
;                                          plotpref='NESSF2014_reproduction_Jan2015--orbs1000-4230',ORBRANGE=[1000,4230]
;
;
;
; MODIFICATION HISTORY: Best to follow my mod history on the Github repository...
;                       Jan 2015: Finally turned interp_plots_str into a procedure! Here you have
;                                 the result.
;-

PRO plot_alfven_stats_imf_screening, maximus, $
                                     CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                     minMLT=minMLT,maxMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                     MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, BYMIN=byMin, $
                                     SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                     DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                     NPLOTS=nPlots, $
                                     EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, ABSEFLUX=absEflux, $
                                     NONEGEFLUX=noNegEflux, NOPOSEFLUX=noPosEflux, EPLOTRANGE=EPlotRange, $
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
                                     MEDIANPLOT=medianPlot, LOGPLOT=logPlot, $
                                     SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                     DBFILE=dbfile, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                                     NEVENTSRANGE=nEventsRange, $
                                     WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                                     SAVERAW=saveRaw, RAWDIR=rawDir, $
                                     NOPLOTSJUSTDATA=noPlotsJustData, NOSAVEPLOTS=noSavePlots, $
                                     PLOTDIR=plotDir, PLOTPREFIX=plotPrefix, PLOTSUFFIX=plotSuffix, $
                                     OUTPUTPLOTSUMMARY=outputPlotSummary, MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, DEL_PS=del_PS, $
                                     _EXTRA = e

  ;;variables to be used by interp_contplot.pro
  COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNEGMC

  !EXCEPT=0                                                      ;Do report errors, please
  ;;***********************************************

  IF KEYWORD_SET(minMLT) then minM = minMLT
  IF KEYWORD_SET(maxMLT) then maxM = maxMLT
  IF KEYWORD_SET(binMLT) then binM = binMLT
  IF KEYWORD_SET(minILAT) then minI = minILAT
  IF KEYWORD_SET(maxILAT) then maxI = maxILAT
  IF KEYWORD_SET(binILAT) then binI = binILAT

  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  ;;(Originally from JOURNAL_Oct112013_orb_avg_plots_extended.pro)
  
  mu_0 = 4.0e-7 * !PI                                            ;perm. of free space, for Poynt. est
  
  ;; Don't use minOrb or maxOrb; use orbRange as a keyword in call to this pro
  ;; minOrb=8100                   ;8260 for Strangeway study
  ;; maxOrb=8500                   ;8292 for Strangeway study
  ;;nOrbits = maxOrb - minOrb + 1
  
  IF NOT KEYWORD_SET(charERange) THEN charERange = [4.0,300]         ; 4,~300 eV in Strangeway

  IF NOT KEYWORD_SET(altitudeRange) THEN altitudeRange = [1000.0, 5000.0] ;Rob Pfaff says no lower than 1000m
  
  IF NOT KEYWORD_SET(minM) THEN minM = 6L
  IF NOT KEYWORD_SET(maxM) THEN maxM = 18L
  
  IF NOT KEYWORD_SET(minI) THEN minI = 60L
  IF NOT KEYWORD_SET(maxI) THEN maxI = 84L
  
  IF NOT KEYWORD_SET(minMC) THEN minMC = 10                ; Minimum current derived from mag data, in microA/m^2
  IF NOT KEYWORD_SET(maxNEGMC) THEN maxNEGMC = -10         ; Current must be less than this, if it's going to make the cut
  
  ;;Shouldn't be leftover unused params from batch call
  IF ISA(e) THEN BEGIN
     IF $
        NOT tag_exist(e,"wholecap") AND NOT tag_exist(e,"noplotintegral") $ ;keywords for interp_polar2dhist
     THEN BEGIN                                                            ;Check for passed variables here
        help,e
        print,e
        print,"Why the extra parameters? They have no home..."
        RETURN
     ENDIF ELSE BEGIN
        IF tag_exist(e,"wholecap") THEN BEGIN
           IF e.wholecap GT 0 THEN BEGIN
              minM=0
              maxM=24
              minI=60
              maxI=84
           ENDIF
        ENDIF
     ENDELSE
     
  ENDIF
  
  ;;********************************************
  ;;satellite data options
  
  IF NOT KEYWORD_SET(satellite) THEN satellite = "OMNI"                ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  IF NOT KEYWORD_SET(omni_Coords) THEN omni_Coords = "GSE"             ; either "GSE" or "GSM"

  defDelay = 660
  IF NOT KEYWORD_SET(delay) THEN delay = defDelay                      ;Delay between ACE propagated data and ChastonDB data
                                                                       ;Bin recommends something like 11min
  
  IF NOT KEYWORD_SET(stableIMF) THEN stableIMF = 0S                    ;Set to a time (in minutes) over which IMF stability is required
  IF NOT KEYWORD_SET(includeNoConsecData) THEN includeNoConsecData = 0 ;Setting this to 1 includes Chaston data for which  
                                                                       ;there's no way to calculate IMF stability
                                                                       ;Only valid for stableIMF GE 1
  IF NOT KEYWORD_SET(checkBothWays) THEN checkBothWays = 0       ;
  
  IF NOT KEYWORD_SET(Bx_over_ByBz_Lim) THEN Bx_over_ByBz_Lim = 0       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  
  ;;Want to make plots in plotDir?
  IF NOT KEYWORD_SET(plotDir) THEN plotDir = 'plots/'
  ;;plotPrefix='NESSF2014_reproduction_Jan2015'

  IF NOT KEYWORD_SET(rawDir) THEN rawDir="rawsaves/"
 
  ;;Write output file with data params? Only possible if noSavePlots=0...
  IF KEYWORD_SET(noSavePlots) AND KEYWORD_SET(outputPlotSummary) THEN BEGIN
     print, "Is it possible to have outputPlotSummary==1 while noSavePlots==0? You used to say no..."
     outputPlotSummary=1   ;;Change to zero if not wanted
  ENDIF 

  ;;Write plot data output for Bin?
  IF NOT KEYWORD_SET(dataDir) THEN dataDir="/SPENCEdata/Research/Cusp/database/"

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

  ;;********************************************
  ;;Variables for histos
  ;;Bin sizes for 2d histos

  IF N_ELEMENTS(squarePlot) EQ 1 THEN BEGIN
;;     IF N_ELEMENTS(wholeCap) EQ 1 THEN PRINT,"Keyword WHOLECAP set without POLARPLOT! I'm doing it for you..."
;;     polarPlot=1                                                 ;do Polar plots instead?
  ENDIF

  IF N_ELEMENTS(nPlots) EQ 0 THEN nPlots = 0                     ; do num events plots?
  IF N_ELEMENTS(ePlots) EQ 0 THEN ePlots =  0                    ;electron flux plots?
  IF N_ELEMENTS(eFluxPlotType) EQ 0 THEN eFluxPlotType = "Max"   ;options are "Integ" and "Max"
  IF N_ELEMENTS(iFluxPlotType) EQ 0 THEN iFluxPlotType = "Max"   ;options are "Integ", "Max", "Integ_Up", "Max_Up", and "Energy"
  IF N_ELEMENTS(pPlots) EQ 0 THEN pPlots =  0                    ;Poynting flux [estimate] plots?
  IF N_ELEMENTS(ionPlots) EQ 0 THEN ionPlots =  0                    ;ion Plots?
  IF N_ELEMENTS(charEPlots) EQ 0 THEN charEPlots =  0              ;char E plots?
  IF N_ELEMENTS(charEType) EQ 0 THEN charEType = "lossCone"      ;options are "lossCone" and "Total"
  IF N_ELEMENTS(orbContribPlot) EQ 0 THEN orbContribPlot =  0                  ;Contributing orbits plot?
  IF N_ELEMENTS(orbTotPlot) EQ 0 THEN orbTotPlot =  0            ;"Total orbits considered" plot?
  IF N_ELEMENTS(orbFreqPlot) EQ 0 THEN orbFreqPlot =  0          ;Contributing/total orbits plot?
  IF N_ELEMENTS(nEventPerOrbPlot) EQ 0 THEN nEventPerOrbPlot =  0 ;N Events/orbit plot?

  IF KEYWORD_SET(nEventPerOrbPlot) AND NOT KEYWORD_SET(nPlots) THEN BEGIN
     print,"Can't do nEventPerOrbPlot without nPlots!!"
     print,"Enabling nPlots..."
     nPlots=1
  ENDIF

  ;;Which IMF clock angle are we doing?
  ;;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth', and 'all_IMF'
  IF NOT KEYWORD_SET(clockStr) THEN clockStr='dawnward'

  ;;How to set angles? Note, clock angle is measured with
  ;;Bz North at zero deg, ranging from -180<clock_angle<180
  ;;Setting angle limits 45 and 135, for example, gives a 90-deg
  ;;window for dawnward and duskward plots
  IF clockStr NE "all_IMF" THEN BEGIN
     angleLim1=45.0               ;in degrees
     angleLim2=135.0              ;in degrees
  ENDIF ELSE BEGIN 
     angleLim1=180.0              ;for doing all IMF
     angleLim2=180.0 
  ENDELSE

  ;;Bin sizes for 2D histos
  binM=(N_ELEMENTS(BinMLT) EQ 0) ? 0.5 : BinMLT
  binI=(N_ELEMENTS(BinILAT) EQ 0) ? 2.0 : BinILAT 

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr=''
  IF NOT KEYWORD_SET(maskMin) THEN maskMin=1 $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='maskMin_' + STRCOMPRESS(maskMin,/REMOVE_ALL) + '_'
     ENDIF
  ENDELSE
  
  ;;Requirement for IMF By magnitude?
  byMinStr=''
  IF KEYWORD_SET(byMin) THEN BEGIN
     byMinStr='byMin_' + STRCOMPRESS(byMin,/REMOVE_ALL) + '_'
  ENDIF

  ;;doing polar contour?
  polarContStr=''
  IF KEYWORD_SET(polarContour) THEN BEGIN
     polarContStr='polarCont_'
  ENDIF


  ;;######ELECTRONS
  ;;Eflux max abs. value in interval, or integrated flux?
  ;;NOTE: max value has negative values, which can mess with
  ;;color bars
  
  IF KEYWORD_SET(logEfPlot) AND NOT KEYWORD_SET(absEflux) AND NOT KEYWORD_SET(noNegEflux) AND NOT KEYWORD_SET(noPosEflux) THEN BEGIN 
     print,"Warning!: You're trying to do log Eflux plots but you don't have 'absEflux', 'noNegEflux', or 'noPosEflux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Eflux values"
     WAIT, 1
;;     absEflux=1
     noNegEflux=1
  ENDIF

  IF KEYWORD_SET(noPosEflux) AND KEYWORD_SET (logEfPlot) THEN absEflux = 1

  ;;For linear or log EFlux plotrange
  IF NOT KEYWORD_SET(EPlotRange) THEN BEGIN
     IF NOT KEYWORD_SET(logEfPlot) THEN EPlotRange=[0.01,100] ELSE EPlotRange=[-2,2]
  ENDIF
  
  ;;######Poynting flux
  IF KEYWORD_SET(logPfPlot) AND NOT KEYWORD_SET(absPflux) AND NOT KEYWORD_SET(noNegPflux) AND NOT KEYWORD_SET(noPosPflux) THEN BEGIN 
     print,"Warning!: You're trying to do log Pflux plots but you don't have 'absPflux', 'noNegPflux', or 'noPosPflux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Pflux values"
     WAIT, 1
;;     absEflux=1
     noPosPflux=1
  ENDIF

  IF KEYWORD_SET(noPosPflux) AND KEYWORD_SET (logPfPlot) THEN absPflux = 1

  ;;For linear or log PFlux plotrange
  IF NOT KEYWORD_SET(PPlotRange) THEN BEGIN
     IF NOT KEYWORD_SET(logPfPlot) THEN PPlotRange=[0.1,2.5] ELSE PPlotRange=[-1,0.4]
  ENDIF

  ;;######Ion flux (up)
  ;;For linear or log ion flux plotrange
  IF NOT KEYWORD_SET(iPlotRange) THEN iPlotRange=(KEYWORD_SET(logIfPlot)) ? [6,9.5] : [1e6,1.5e9]
  
  IF KEYWORD_SET(logIfPlot) AND NOT KEYWORD_SET(absIflux) AND NOT KEYWORD_SET(noNegIflux) AND NOT KEYWORD_SET(noPosIflux) THEN BEGIN 
     print,"Warning!: You're trying to do log(ionFlux) plots but you don't have 'absIflux', 'noNegIflux', or 'noPosIflux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Iflux values"
     WAIT, 1
;;     absIflux=1
     noNegIflux=1
  ENDIF


  IF KEYWORD_SET(logCharEPlot) AND NOT KEYWORD_SET(absCharE) AND NOT KEYWORD_SET(noNegCharE) AND NOT KEYWORD_SET(noPosCharE) THEN BEGIN 
     print,"Warning!: You're trying to do log(charE) plots but you don't have 'absCharE', 'noNegCharE', or 'noPosCharE' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative CharE values"
     WAIT, 1
;;     absCharE=1
     noNegCharE=1
  ENDIF

  IF KEYWORD_SET(noPosCharE) AND KEYWORD_SET (logCharEPlot) THEN absCharE = 1

  ;;For linear or log charE plotrange
  IF NOT KEYWORD_SET(CharEPlotRange) THEN BEGIN
     IF NOT KEYWORD_SET(logCharEPlot) THEN CharEPlotRange=[1,4000] ELSE CharEPlotRange=[0,3.60208]; [0,3.69897]
  ENDIF

  ;;********************************************
  ;;Stuff for output
  hoyDia= STRMID(SYSTIME(0), 4, 3) + "_" + $
          STRMID(SYSTIME(0), 8,2) + "_" + STRMID(SYSTIME(0), 22, 2)

  IF KEYWORD_SET(medianplot) THEN plotMedOrAvg = "_med" ELSE plotMedOrAvg = "_avg"

  IF NOT KEYWORD_SET(plotSuffix) THEN plotSuffix = "" ELSE plotSuffix = "--" + plotSuffix
  ;; IF NOT KEYWORD_SET(plotPrefix) THEN BEGIN
  ;;    plotType='Eflux_' +eFluxPlotType
  ;;    plotType=(N_ELEMENTS(logEfPlot) EQ 0) ? plotType : 'log' + plotType
  ;;    plotType=(N_ELEMENTS(logPfPlot) EQ 0) ? plotType : 'logPf_' + plotType
  ;;    plotDir=(KEYWORD_SET(squarePlot)) ? plotDir + plotType : plotDir + "polar/" + plotType + '/' 
  ;; ENDIF ELSE 
  IF NOT KEYWORD_SET(plotPrefix) THEN plotPrefix = "" ELSE plotPrefix = plotPrefix + "--"

  smoothStr=""

  IF KEYWORD_SET(smoothWindow) THEN smoothStr = strtrim(smoothWindow,2)+"min_IMFsmooth--"

  ;;********************************************
  ;;Figure out both hemisphere and plot indices, 
  ;;tap DBs, and setup output
  IF minI GT 0 THEN hemStr='North' ELSE IF maxI LT 0 THEN hemStr='South' $
  ELSE BEGIN 
     printf,lun,"Which hemisphere?" & hemStr = '??'
  ENDELSE
  
  ;;parameter string
  omniStr = ""
  IF satellite EQ "OMNI" then omniStr = "_" + omni_Coords 
  IF delay NE defDelay THEN delayStr = strcompress(delay/60,/remove_all) + "mindelay_" ELSE delayStr = ""
  paramStr=hemStr+'_'+clockStr+plotMedOrAvg+"--"+strtrim(stableIMF,2)+"stable--"+smoothStr+satellite+omniStr+"_"+delayStr+maskStr+byMinStr+polarContStr+hoyDia


  ;;Open file for text summary, if desired
  IF KEYWORD_SET(outputPlotSummary) THEN $
     OPENW,lun,plotDir + plotPrefix+'outputSummary_'+paramStr+plotSuffix+'.txt',/GET_LUN $
  ELSE lun=-1                   ;-1 is lun for STDOUT
  
  ;;Now run these to clean and tap the databases and interpolate satellite data
  
  ind_region_magc_geabs10_ACEstart = get_chaston_ind(maximus,satellite,lun, $
                                                     CDBTIME=cdbTime,dbfile=dbfile,CHASTDB=do_chastdb, $
                                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange)
  phiChast = interp_mag_data(ind_region_magc_geabs10_ACEstart,satellite,delay,lun, $
                            cdbTime=cdbTime,CDBINTERP_I=cdbInterp_i,CDBACEPROPINTERP_I=cdbAcepropInterp_i,MAG_UTC=mag_utc, PHICLOCK=phiClock, $
                            DATADIR=dataDir,SMOOTHWINDOW=smoothWindow,BYMIN=byMin,OMNI_COORDS=omni_Coords)
  phiImf_ii = check_imf_stability(clockStr,angleLim1,angleLim2,phiChast,cdbAcepropInterp_i,stableIMF,mag_utc,phiClock,$
                                 LUN=lun,bx_over_bybz=Bx_over_ByBz_Lim)
  
  plot_i=cdbInterp_i(phiImf_ii)

  ;;********************************************************
  ;;WHICH ORBITS ARE UNIQUE?
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."
  
  ;;***********************************************
  ;;Calculate Poynting flux estimate
  
  ;;1.0e-9 to take stock of delta_b being recordin in nT
  ;;Since E is recorded in mV/m, units of POYNT_EST here are mW/m^2
  POYNT_EST=maximus.DELTA_B * maximus.DELTA_E * 1.0e-9 / mu_0 
  ;; goodpoynt=where(poynt_est(plot_i) GT 0)
  ;; plot_i=plot_i(goodpoynt)
  ;;********************************************
  ;;Now time for data summary

  printf,lun,""
  printf,lun,"**********DATA SUMMARY**********"
  printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
  printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
  printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
  printf,lun,"Screening parameters: [Min] [Max]"
  printf,lun,"Mag current: " + strtrim(maxNEGMC,2) + " " + strtrim(minMC,2)
  printf,lun,"MLT: " + strtrim(minM,2) + " " + strtrim(maxM,2)
  printf,lun,"ILAT: " + strtrim(minI,2) + " " + strtrim(maxI,2)
  printf,lun,"Hemisphere: " + hemStr
  printf,lun,"IMF Predominance: " + clockStr
  printf,lun,"Angle lim 1: " + strtrim(angleLim1,2)
  printf,lun,"Angle lim 2: " + strtrim(angleLim2,2)
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
  h2dFluxN=hist_2d(maximus.mlt(plot_i),$
                   maximus.ilat(plot_i),$
                   BIN1=binM,BIN2=binI,$
                   MIN1=MINM,MIN2=MINI,$
                   MAX1=MAXM,MAX2=MAXI)

  h2dFluxNTitle="Number of events"
  IF keepMe THEN BEGIN 
     dataName="nEvents_" 
     dataRawPtr=PTR_NEW() 
  ENDIF

  h2dStr={h2dStr, data: DOUBLE(h2dFluxN), $
          title : "Number of events", $
          lim : (KEYWORD_SET(nEventsRange) AND N_ELEMENTS(nEventsRange) EQ 2) ? DOUBLE(nEventsRange) : DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) }

  ;;Make a mask for plots so that we can show where no data exists
  h2dMaskStr={h2dStr}
  h2dMaskStr.data=h2dStr.data
  h2dMaskStr.data(where(h2dStr.data LT maskMin,/NULL))=255
  h2dMaskStr.data(where(h2dStr.data GE maskMin,NULL))=0
  h2dMaskStr.title="Histogram mask"

  IF keepMe THEN BEGIN 
     dataName=[dataName,"histoMask_"] 
     dataRawPtr=[dataRawPtr,PTR_NEW()] 
  ENDIF

;  IF KEYWORD_SET(nPlots) THEN h2dStr=[h2dStr,TEMPORARY(h2dMaskStr)] ELSE h2dStr = TEMPORARY(h2dMaskStr)
  IF KEYWORD_SET(nPlots) THEN h2dStr=[h2dStr,h2dMaskStr] ELSE h2dStr = h2dMaskStr

  ;;h2dStr={h2dStr, data : DBLARR(N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*))), title : "", lim : DBLARR(2) }

  ;;########ELECTRON FLUX########

  IF KEYWORD_SET(eplots) THEN BEGIN
     h2dEStr={h2dStr}

     ;;If not allowing negative fluxes
     IF eFluxPlotType EQ "Integ" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegEflux) THEN BEGIN
           no_negs_i=WHERE(maximus.integ_elec_energy_flux GE 0.0)
           plot_i=cgsetintersection(no_negs_i,plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosEflux) THEN BEGIN
              no_pos_i=WHERE(maximus.integ_elec_energy_flux LT 0.0)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
           ENDIF
        ENDELSE
        elecData=maximus.integ_elec_energy_flux(plot_i) 
     ENDIF ELSE BEGIN
        IF eFluxPlotType EQ "Max" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegEflux) THEN BEGIN
              no_negs_i=WHERE(maximus.elec_energy_flux GE 0.0)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosEflux) THEN BEGIN
                 no_pos_i=WHERE(maximus.elec_energy_flux LT 0.0)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
              ENDIF
           ENDELSE
           elecData=maximus.elec_energy_flux(plot_i)
        ENDIF
     ENDELSE

     ;;Handle name of data
     ;;Log plots desired?
     absEstr=""
     negEstr=""
     posEstr=""
     logEstr=""
     IF KEYWORD_SET(absEflux)THEN absEstr = "Abs--"
     IF KEYWORD_SET(noNegEflux) THEN negEstr = "NoNegs--"
     IF KEYWORD_SET(noPosEflux) THEN posEstr = "NoPos--"
     IF KEYWORD_SET(logEfPlot) THEN logEstr="Log "
     absnegslogEstr=absEstr + negEstr + posEstr + logEstr
     efDatName = STRTRIM(absnegslogEstr,2)+"eFlux"+eFluxPlotType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = 'medHistData/' + efDatName+"medhist_data.sav"

        h2dEstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                 elecData,$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                 ABSMED=absEflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile='medHistData/' + efDatName + "medhist.txt"

     ENDIF ELSE BEGIN 
        h2dEStr.data=hist2d(maximus.mlt(plot_i), $
                            maximus.ilat(plot_i),$
                            elecData,$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI,$
                            OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dEStr.data(where(h2dFluxN NE 0,/NULL))=h2dEStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
     ENDELSE 

     ;data mods?
     IF KEYWORD_SET(absEflux)THEN BEGIN 
        h2dEStr.data = ABS(h2dEStr.data) 
        IF keepMe THEN elecData=ABS(elecData) 
     ENDIF
     IF KEYWORD_SET(logEfPlot) THEN BEGIN 
        h2dEStr.data(where(h2dEStr.data GT 0,/NULL))=ALOG10(h2dEStr.data(where(h2dEStr.data GT 0,/null))) 
        IF keepMe THEN elecData(where(elecData GT 0,/null))=ALOG10(elecData(where(elecData GT 0,/null))) 
     ENDIF

     ;;Do custom range for Eflux plots, if requested
     ;; IF  KEYWORD_SET(EPlotRange) THEN h2dEStr.lim=TEMPORARY(EPlotRange)$
     IF  KEYWORD_SET(EPlotRange) THEN h2dEStr.lim=EPlotRange $
     ELSE h2dEStr.lim = [MIN(h2dEstr.data),MAX(h2dEstr.data)]

     h2dEStr.title= absnegslogEstr + "Electron Flux (ergs/cm!U2!N-s)"
     ;; IF KEYWORD_SET(ePlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dEStr)] 
     IF KEYWORD_SET(ePlots) THEN BEGIN & h2dStr=[h2dStr,h2dEStr] 
        IF keepMe THEN BEGIN 
           dataName=[dataName,efDatName] 
           dataRawPtr=[dataRawPtr,PTR_NEW(elecData)] 
        ENDIF 
     ENDIF

  ENDIF


  ;;########Poynting Flux########

  IF KEYWORD_SET(pplots) THEN BEGIN

     h2dPStr={h2dStr}

     ;;check for NaNs
     goodPF_i = WHERE(FINITE(poynt_est),NCOMPLEMENT=lostNans)
     IF goodPF_i[0] NE -1 THEN BEGIN
        print,"Found some NaNs in Poynting flux! Losing another " + strcompress(lostNans,/REMOVE_ALL) + " events..."
        plot_i = cgsetintersection(plot_i,goodPF_i)
     ENDIF
     
     IF KEYWORD_SET(noNegPflux) THEN BEGIN
        no_negs_i=WHERE(poynt_est GE 0.0)
        plot_i=cgsetintersection(no_negs_i,plot_i)
     ENDIF

     IF KEYWORD_SET(noPosPflux) THEN BEGIN
        no_pos_i=WHERE(poynt_est GE 0.0)
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

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = 'medHistData/' + pfDatName+"medhist_data.sav"

        h2dPstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                 poynt_est(plot_i),$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                 ABSMED=absPflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile='medHistData/' + pfDatName + "medhist.txt"

     ENDIF ELSE BEGIN 
        h2dPStr.data=hist2d(maximus.mlt(plot_i),$
                            maximus.ilat(plot_i),$
                            poynt_est(plot_i),$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI) 
        h2dPStr.data(where(h2dFluxN NE 0,/null))=h2dPStr.data(where(h2dFluxN NE 0,/null))/h2dFluxN(where(h2dFluxN NE 0,/null)) 
     ENDELSE

     IF KEYWORD_SET(writeHDF5) or KEYWORD_SET(writeASCII) OR NOT KEYWORD_SET(squarePlot) OR KEYWORD_SET(saveRaw) THEN pData=poynt_est(plot_i)

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
     IF KEYWORD_SET(pPlots) THEN BEGIN & h2dStr=[h2dStr,h2dPStr] 
        IF keepMe THEN BEGIN 
           dataName=[dataName,pfDatName] 
           dataRawPtr=[dataRawPtr,PTR_NEW(pData)] 
        ENDIF  
     ENDIF

;;   undefine,h2dPStr

     ;;use these n stuff
     IF KEYWORD_SET(tempSAVE) THEN BEGIN 
        print,"saving tempdata..." 
        save,elecData,filename="testcode/elecdata.dat" 
        mlts=maximus.mlt(plot_i) 
        ilats=maximus.ilat(plot_i) 
        save,mlts,ilats,filename="testcode/mlts_ilats.dat" 
        pData=poynt_est(plot_i) 
        save,pData,filename="testcode/pData.dat" 
     ENDIF

  ENDIF


  ;;########ION FLUX########

  IF KEYWORD_SET(ionPlots) THEN BEGIN
     h2dIStr={h2dStr}

     ;;If not allowing negative fluxes
     IF iFluxPlotType EQ "Integ" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegIflux) THEN BEGIN
           no_negs_i=WHERE(maximus.integ_ion_flux GE 0.0)
           plot_i=cgsetintersection(no_negs_i,plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosIflux) THEN BEGIN
              no_pos_i=WHERE(maximus.integ_ion_flux LE 0.0)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
           ENDIF
        ENDELSE
     ionData=maximus.integ_ion_flux(plot_i) 
     ENDIF ELSE BEGIN
        IF ifluxPlotType EQ "Max" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegIflux) THEN BEGIN
              no_negs_i=WHERE(maximus.ion_flux GE 0.0)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosIflux) THEN BEGIN
                 no_pos_i=WHERE(maximus.ion_flux LE 0.0)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
              ENDIF
           ENDELSE
           ionData=maximus.ion_flux(plot_i)
        ENDIF ELSE BEGIN
           IF ifluxPlotType EQ "Max_Up" THEN BEGIN
              plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
              print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
              IF KEYWORD_SET(noNegIflux) THEN BEGIN
                 no_negs_i=WHERE(maximus.ion_flux_up GE 0.0)
                 plot_i=cgsetintersection(no_negs_i,plot_i)        
              ENDIF ELSE BEGIN
                 IF KEYWORD_SET(noPosIflux) THEN BEGIN
                    no_pos_i=WHERE(maximus.ion_flux_up LE 0.0)
                    plot_i=cgsetintersection(no_pos_i,plot_i)        
                 ENDIF
              ENDELSE
              ionData=maximus.ion_flux_up(plot_i)
           ENDIF ELSE BEGIN
              IF ifluxPlotType EQ "Integ_Up" THEN BEGIN
                 plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
                 print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                 IF KEYWORD_SET(noNegIflux) THEN BEGIN
                    no_negs_i=WHERE(maximus.integ_ion_flux_up GE 0.0)
                    plot_i=cgsetintersection(no_negs_i,plot_i)        
                 ENDIF ELSE BEGIN
                    IF KEYWORD_SET(noPosIflux) THEN BEGIN
                       no_pos_i=WHERE(maximus.integ_ion_flux_up LE 0.0)
                       plot_i=cgsetintersection(no_pos_i,plot_i)        
                    ENDIF
                 ENDELSE
                 ionData=maximus.integ_ion_flux_up(plot_i)
              ENDIF ELSE BEGIN
                 IF ifluxPlotType EQ "Energy" THEN BEGIN
                    plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
                    print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
                    IF KEYWORD_SET(noNegIflux) THEN BEGIN
                       no_negs_i=WHERE(maximus.ion_energy_flux GE 0.0)
                       plot_i=cgsetintersection(no_negs_i,plot_i)        
                    ENDIF ELSE BEGIN
                       IF KEYWORD_SET(noPosIflux) THEN BEGIN
                          no_pos_i=WHERE(maximus.ion_energy_flux LE 0.0)
                          plot_i=cgsetintersection(no_pos_i,plot_i)        
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
     IF KEYWORD_SET(absIflux)THEN absIonStr= "Abs--" 
     IF KEYWORD_SET(noNegIflux) THEN negIonStr = "NoNegs--"
     IF KEYWORD_SET(noPosIflux) THEN posIonStr = "NoPos--"
     IF KEYWORD_SET(logIfPlot) THEN logIonStr="Log "
     absnegslogIonStr=absIonStr + negIonStr + posIonStr + logIonStr
     ifDatName = STRTRIM(absnegslogIonStr,2)+"iflux"+ifluxPlotType+"_"

     IF KEYWORD_SET(medianplot) THEN BEGIN 

        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = 'medHistData/' + ifDatName+"medhist_data.sav"

        h2dIStr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                 ionData,$
                                 MIN1=MINM,MIN2=MINI,$
                                 MAX1=MAXM,MAX2=MAXI,$
                                 BINSIZE1=binM,BINSIZE2=binI,$
                                 OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                 ABSMED=absIflux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile='medHistData/' + ifDatName + "medhist.txt"

     ENDIF ELSE BEGIN 
        h2dIStr.data=hist2d(maximus.mlt(plot_i), $
                            maximus.ilat(plot_i),$
                            ionData,$
                            MIN1=MINM,MIN2=MINI,$
                            MAX1=MAXM,MAX2=MAXI,$
                            BINSIZE1=binM,BINSIZE2=binI,$
                            OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dIStr.data(where(h2dFluxN NE 0,/NULL))=h2dIStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
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
     IF KEYWORD_SET(ionPlots) THEN BEGIN & h2dStr=[h2dStr,h2dIStr] 
        IF keepMe THEN BEGIN 
           dataName=[dataName,STRTRIM(absnegslogIonStr,2)+"iflux"+ifluxPlotType+"_"] 
           dataRawPtr=[dataRawPtr,PTR_NEW(ionData)] 
        ENDIF 
     ENDIF

  ENDIF

  ;;########CHARACTERISTIC ENERGY########

  IF KEYWORD_SET(charEPlots) THEN BEGIN

     h2dCharEStr={h2dStr}

     ;;If not allowing negative fluxes
     IF charEType EQ "lossCone" THEN BEGIN
        plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_losscone),NCOMPLEMENT=lost),plot_i) ;;NaN check
        print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
        IF KEYWORD_SET(noNegCharE) THEN BEGIN
           no_negs_i=WHERE(maximus.max_chare_losscone GE 0.0)
           plot_i=cgsetintersection(no_negs_i,plot_i)
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(noPosCharE) THEN BEGIN
              no_pos_i=WHERE(maximus.max_chare_losscone LT 0.0)
              plot_i=cgsetintersection(no_pos_i,plot_i)        
           ENDIF
        ENDELSE
        charEData=maximus.max_chare_losscone(plot_i) 
     ENDIF ELSE BEGIN
        IF charEType EQ "Total" THEN BEGIN
           plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_total),NCOMPLEMENT=lost),plot_i) ;;NaN check
           print,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in data..."
           IF KEYWORD_SET(noNegCharE) THEN BEGIN
              no_negs_i=WHERE(maximus.max_chare_total GE 0.0)
              plot_i=cgsetintersection(no_negs_i,plot_i)        
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(noPosCharE) THEN BEGIN
                 no_pos_i=WHERE(maximus.max_chare_total LT 0.0)
                 plot_i=cgsetintersection(no_pos_i,plot_i)        
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
        IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = 'medHistData/' + chareDatName+"medhist_data.sav"

        h2dCharEStr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                                     charEData,$
                                     MIN1=MINM,MIN2=MINI,$
                                     MAX1=MAXM,MAX2=MAXI,$
                                     BINSIZE1=binM,BINSIZE2=binI,$
                                     OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                                     ABSMED=absCharE,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

        IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile='medHistData/' + chareDatName + "medhist.txt"
        
     ENDIF ELSE BEGIN 
        h2dCharEStr.data=hist2d(maximus.mlt(plot_i), $
                                maximus.ilat(plot_i),$
                                charEData,$
                                MIN1=MINM,MIN2=MINI,$
                                MAX1=MAXM,MAX2=MAXI,$
                                BINSIZE1=binM,BINSIZE2=binI,$
                                OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
        h2dCharEStr.data(where(h2dFluxN NE 0,/NULL))=h2dCharEStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
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
     IF KEYWORD_SET(charEPlots) THEN BEGIN & h2dStr=[h2dStr,h2dCharEStr] 
        IF keepMe THEN BEGIN 
           dataName=[dataName,chareDatName] 
           dataRawPtr=[dataRawPtr,PTR_NEW(charEData)] 
        ENDIF 
     ENDIF

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
  
  IF KEYWORD_SET(orbContribPlot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) THEN BEGIN
     
     h2dOrbStr={h2dStr}

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
     IF NOT KEYWORD_SET(orbContribRange) OR N_ELEMENTS(orbContribRange) NE 2 THEN h2dOrbStr.lim=[1,60] ELSE h2dOrbStr.lim=orbContribRange

     IF KEYWORD_SET(orbContribPlot) THEN BEGIN & h2dStr=[h2dStr,h2dOrbStr] 
        IF keepMe THEN dataName=[dataName,"orbsContributing_"] 
     ENDIF

  ENDIF

  ;;########TOTAL Orbits########

  IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) THEN BEGIN

     ;;uniqueOrbs_ii=UNIQ(maximus.orbit(ind_region_magc_geabs10_acestart),SORT(maximus.orbit(ind_region_magc_geabs10_acestart)))
     uniqueOrbs_ii=UNIQ(maximus.orbit,SORT(maximus.orbit))

     h2dTotOrbStr={h2dStr}
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
     IF NOT KEYWORD_SET(orbTotRange) OR N_ELEMENTS(orbTotRange) NE 2 THEN h2dTotOrbStr.lim=[MIN(h2dTotOrbStr.data),MAX(h2dTotOrbStr.data)] $ 
     ELSE h2dTotOrbStr.lim=orbTotRange

     IF KEYWORD_SET(orbTotPlot) THEN BEGIN & h2dStr=[h2dStr,h2dTotOrbStr] 
        IF keepMe THEN dataName=[dataName,"orbTot_"] 
     ENDIF
     
  ENDIF

  ;;########Orbit FREQUENCY########

  IF KEYWORD_SET(orbfreqplot) THEN BEGIN

     h2dFreqOrbStr={h2dStr}
     h2dFreqOrbStr.data=h2dOrbStr.data
     h2dFreqOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))=h2dOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))/h2dTotOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))
     h2dFreqOrbStr.title="Orbit Frequency"
     ;;h2dFreqOrbStr.lim=[MIN(h2dFreqOrbStr.data),MAX(h2dFreqOrbStr.data)]
     IF NOT KEYWORD_SET(orbFreqRange) OR N_ELEMENTS(orbFreqRange) NE 2 THEN h2dFreqOrbStr.lim=[0,0.5] ELSE h2dFreqOrbStr.lim=orbFreqRange

     IF KEYWORD_SET(orbFreqPlot) THEN BEGIN & h2dStr=[h2dStr,h2dFreqOrbStr] 
        IF keepMe THEN dataName=[dataName,"orbFreq_"] 
     ENDIF

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

     h2dNEvPerOrbStr={h2dStr}
     h2dNEvPerOrbStr.data=h2dStr(0).data
     h2dNEvPerOrb_i=WHERE(h2dStr(0).data NE 0,/NULL)
     IF KEYWORD_SET(divNEvByApplicable) THEN BEGIN
        divisor = h2dOrbStr.data(h2dNevPerOrb_i) ;Only divide by number of orbits that occurred during specified IMF conditions
     ENDIF ELSE BEGIN
        divisor = h2dTotOrbStr.data(h2dNEvPerOrb_i) ;Divide by all orbits passing through relevant bin
     ENDELSE
     h2dNEvPerOrbStr.data(h2dNEvPerOrb_i)=h2dNEvPerOrbStr.data(h2dNEvPerOrb_i)/divisor

     logNEvStr=""
     ;;IF KEYWORD_SET(logNEventPerOrb) THEN logNEvStr="Log "
     h2dNEvPerOrbStr.title= logNEvStr + "N Events per Orbit"

     IF NOT KEYWORD_SET(nEventPerOrbRange) OR N_ELEMENTS(nEventPerOrbRange) NE 2 THEN BEGIN
        IF NOT KEYWORD_SET(logNEventPerOrb) THEN h2dNEvPerOrbStr.lim=[0,7] ELSE h2dNEvPerOrbStr.lim=[-2,1]
     ENDIF ELSE h2dNEvPerOrbStr.lim=nEventPerOrbRange
     
     IF KEYWORD_SET(logNEventPerOrb) THEN BEGIN 
        h2dNEvPerOrbStr.data(where(h2dNEvPerOrbStr.data GT 0,/NULL))=ALOG10(h2dNEvPerOrbStr.data(where(h2dNEvPerOrbStr.data GT 0,/null))) 
     ENDIF

     h2dStr=[h2dStr,h2dNEvPerOrbStr] 
     IF keepMe THEN dataName=[dataName,logNEvStr + "nEventPerOrb_"] 

  ENDIF

  ;;********************************************************
  ;;If something screwy goes on, better take stock of it and alert user

  FOR i = 2, N_ELEMENTS(h2dStr)-1 DO BEGIN 
     IF n_elements(where(h2dStr[i].data EQ 0,/NULL)) NE $
        n_elements(where(h2dStr[0].data EQ 0,/NULL)) THEN BEGIN 
        printf,lun,"h2dStr."+h2dStr[i].title + " has ", strtrim(n_elements(where(h2dStr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_elements(where(h2dStr[0].data EQ 0)),2),"." 
     printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
  ENDFOR

  ;;********************************************************
  ;;Handle Plots all at once

  ;;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively

  h2dStr=SHIFT(h2dStr,-1-(nPlots))
  IF keepMe THEN BEGIN 
     dataName=SHIFT(dataName,-2) 
     dataRawPtr=SHIFT(dataRawPtr,-2) 
  ENDIF

  IF NOT KEYWORD_SET(squarePlot) THEN save,h2dStr,dataName,maxM,minM,maxI,minI,binM,binI,$
                           rawDir,clockStr,plotMedOrAvg,stableIMF,hoyDia,hemstr,$
                           filename='temp/polarplots_'+paramStr+plotSuffix+".dat"

  ;;if not saving plots and plots not turned off, do some stuff  ;; otherwise, make output
  IF KEYWORD_SET(noSavePlots) THEN BEGIN 
     IF NOT KEYWORD_SET(noPlotsJustData) AND KEYWORD_SET(squarePlot) THEN $
        cgWindow, 'interp_contplotmulti_str', h2dStr,$
                  Background='White', $
                  WTitle='Flux plots for '+hemStr+'ern Hemisphere, '+clockStr+ $
                  ' IMF, ' + strmid(plotMedOrAvg,1) $
     ELSE IF NOT KEYWORD_SET(noPlotsJustData) THEN $  ;FOR j=0, N_ELEMENTS(h2dStr)-1 DO $
        ;;    cgWindow,'interp_polar_plot',[[*dataRawPtr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
                ;;             h2dStr[0].lim,Background="White",wxsize=800,wysize=600, $
                ;;             WTitle='Polar plot_'+dataName[0]+','+hemStr+'ern Hemisphere, '+clockStr+ $
                ;;             ' IMF, ' + strmid(plotMedOrAvg,1) $
        FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO $ 
           cgWindow,'interp_polar2dhist',h2dStr[i],dataName[i], $
                'temp/polarplots_'+paramStr+plotSuffix+".dat",_extra=e,$
                Background="White",wxsize=800,wysize=600, $
                WTitle='Polar plot_'+dataName[i]+','+hemStr+'ern Hemisphere, '+clockStr+ $
                ' IMF, ' + strmid(plotMedOrAvg,1) $
                
     ELSE PRINTF,LUN,"**Plots turned off with noPlotsJustData**" 
  ENDIF ELSE BEGIN 
     IF KEYWORD_SET(squarePlot) AND NOT KEYWORD_SET(noPlotsJustData) THEN BEGIN 
        CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
        PRINTF,LUN, "Creating output files..." 

        ;;Create a PostScript file.
        cgPS_Open, plotDir + plotPrefix + 'fluxplots_'+paramStr+plotSuffix+'.ps', /nomatch, xsize=1000, ysize=1000
        interp_contplotmulti_str,h2dStr 
        cgPS_Close 

        ;;Create a PNG file with a width of 800 pixels.
        cgPS2Raster, plotDir + plotPrefix + 'fluxplots_'+paramStr+plotSuffix+'.ps', $
                     /PNG, Width=800, DELETE_PS = del_PS
     
     ENDIF ELSE IF NOT KEYWORD_SET(noPlotsJustData) THEN BEGIN 
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
              interp_polar2dcontour,h2dStr[i],dataName[i],'temp/polarplots_'+paramStr+plotSuffix+".dat", $
                                    fname=plotDir + plotPrefix+dataName[i]+paramStr+plotSuffix+'.png', _extra=e
              ;; Close the PostScript file:
              DEVICE, /CLOSE
              ;; Return plotting to the original device:
              SET_PLOT, mydevice
           ENDIF ELSE BEGIN
              ;;Create a PostScript file.
              cgPS_Open, plotDir + plotPrefix+dataName[i]+paramStr+plotSuffix+'.ps' 
              ;;interp_polar_plot,[[*dataRawPtr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
              ;;          h2dStr[0].lim 
              interp_polar2dhist,h2dStr[i],dataName[i],'temp/polarplots_'+paramStr+plotSuffix+".dat",_extra=e 
              cgPS_Close 
              ;;Create a PNG file with a width of 800 pixels.
              cgPS2Raster, plotDir + plotPrefix+dataName[i]+paramStr+plotSuffix+'.ps', $
                           /PNG, Width=800, DELETE_PS = del_PS
           ENDELSE
           
        ENDFOR    
        
     ENDIF 
  ENDELSE

  IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
     CLOSE,lun 
     FREE_LUN,lun 
  ENDIF

  ;;Save raw data, if desired
  IF KEYWORD_SET(saveRaw) THEN BEGIN
     SAVE, /ALL, filename=rawDir+'fluxplots_'+paramStr+plotSuffix+".dat"

  ENDIF


   ;;********************************************************
   ;;Thanks, IDL Coyote--time to write out lots of data

   IF KEYWORD_SET(writeHDF5) THEN BEGIN 
      ;;write out raw data here
      FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN 
         fname=plotDir + plotPrefix+dataName[j]+paramStr+plotSuffix+'.h5' 
         PRINT,"Writing HDF5 file: " + fname 
         fileID=H5F_CREATE(fname) 
         datatypeID=H5T_IDL_CREATE(h2dStr[j].data) 
         dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
         datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) 
         H5D_WRITE,datasetID, h2dStr[j].data 
         H5F_CLOSE,fileID 
      ENDFOR 
      ;;loop style for individual structures
      ;;   FOR i=0, N_ELEMENTS(h2dStr)-1 DO BEGIN 
      ;;      fname=plotDir + plotPrefix+h2dStr[i].title+'_'+ $
      ;;            paramStr+plotSuffix+'.h5' 
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
            fname=plotDir + plotPrefix+dataName[j]+paramStr+plotSuffix+'.h5' 
            PRINT,"Writing HDF5 file: " + fname 
            fileID=H5F_CREATE(fname) 
            
            ;;    datatypeID=H5T_IDL_CREATE() 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStr[j].data 
            
            datatypeID=H5T_IDL_CREATE(h2dStr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStr[j].data     
            
            
            datatypeID=H5T_IDL_CREATE(h2dStr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStr[j].data 
            H5F_CLOSE,fileID 
         ENDFOR 
      ENDIF 
   ENDIF

   ;;IF writeASCII NE 0 THEN BEGIN 
   ;;  fname=plotDir + plotPrefix+'fluxplots_'+paramStr+plotSuffix+'.ascii' 
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
      FOR j = 0, n_elements(dataRawPtr)-3 DO BEGIN 
         fname=plotDir + plotPrefix+dataName[j]+paramStr+plotSuffix+'.ascii' 
         PRINT,"Writing ASCII file: " + fname 
         OPENW,lun2, fname, /get_lun 

         FOR i = 0, N_ELEMENTS(plot_i) - 1 DO BEGIN 
            PRINTF,lun2,(maximus.ILAT(plot_i))[i],(maximus.MLT(plot_i))[i],$
                   (*dataRawPtr[j])[i],$
                   FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
         ENDFOR 
         CLOSE, lun2   
         FREE_LUN, lun2 
      ENDFOR 
      
      ;;NOW DO PROCESSED H2D DATA 
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR i = 0, n_elements(h2dStr)-1 DO BEGIN 
            fname=plotDir + plotPrefix+"h2d_"+dataName[i]+paramStr+plotSuffix+'.ascii' 
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

;;   IF KEYWORD_SET(writeHDF5) OR KEYWORD_SET(writeASCII) THEN BEGIN & undefine,dataRawPtr & HEAP_GC & ENDIF
   ;;********************************************************
   ;;OLD THINGS FOR SINGLE PLOTS FOLLOW HERE

   ;;********************************************************
   ;;histo for current event based on clock angle

   ;;cghistoplot,phiChast,$
   ;; xtickvalues=(indgen(5)*90-180),$
   ;; xtitle="Clock angle",$
   ;; title="> 10 microA/m^2 current events in "+hemStr+"ern hemisphere"  ;;,$output=hemStr+"_INTERP_clock_angle_cur_event_histo.png"

   ;;********************************************************
   ;;scatterplot of Poynting estimate vs. clock angle

   ;;cgscatter2d,phiChast,$
   ;; poynt_est(cdbInterp_i),$
   ;; xtitle="Clock angle",ytitle="|E||B| (Poynting flux estimate)",$
   ;; title="Poynt flux est. vs. IMF angle in "+hemStr+"ern hemisphere--"+strtrim(delay/60,2)+" min. delay",$
   ;; /ylog,yrange=[1.0e-5,1.0e-1],$
   ;; xrange=[-180,180]  ;;,$output=hemStr+"_INTERP_poynt_est_vs_clock_angle.png"

   ;;********************************************************
   ;;SCATTERPLOTS

   ;;For all phi
   ;;cgscatter2d,maximus.mlt(cdbInterp_i),$
   ;; poynt_est(cdbInterp_i),$
   ;; xtitle="MLT", ytitle="|E||B| (Poynt flux est.)",$
   ;; title="Spread in latitude of Poynting flux for all phi"
   ;;output="Poynt_vs_MLT_Phi_all_'+hemStr+'.png"
   ;;write_png,'Poynt_vs_MLT_Phi_all_'+hemStr+'.png',tvrd()
   ;;
   ;;cgscatter2d,maximus.mlt(cdbInterp_i),$
   ;; maximus.elec_energy_flux(cdbInterp_i),$
   ;; xtitle="MLT", ytitle="Electron [number?] flux",$
   ;; title="Spread in latitude of electron flux for all phi",$
   ;;output="elecflux_vs_MLT_Phi_all_'+hemStr+'.png"
   ;;  ;;write_png,'elecflux_vs_MLT_Phi_all_'+hemStr+'.png',tvrd()
   ;;
   ;;For phi based on clockStr
   ;;window,0
   ;;cgscatter2d,maximus.mlt(plot_i),$
   ;; poynt_est(plot_i),$
   ;; xtitle="MLT", ytitle="|E||B| (Poynt flux est.)",$
   ;; title="Spread in latitude of Poynting flux for phiClock " + clockStr,$
   ;;output="Poynt_vs_MLT_'+clockStr+'_'+hemStr+'.png"
   ;;write_png,'Poynt_vs_MLT_'+clockStr+'.png',tvrd()
   ;;
   ;;window,2
   ;;cgscatter2d,maximus.mlt(plot_i),$
   ;; maximus.elec_energy_flux(plot_i),$
   ;; xtitle="MLT", ytitle="Electron [number?] flux",$
   ;; title="Spread in latitude of electron flux for phiClock " + clockStr,$
   ;;output="elecflux_vs_MLT_'+clockStr+'_'+hemStr+'.png"
   ;;write_png,'elecflux_vs_MLT_' + clockStr + '_'+hemStr+'.png',tvrd()

END