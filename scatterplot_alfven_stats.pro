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
;		     NPLOTS            :  Plot number of orbits.   
;                    HEMI              :  Hemisphere for which to show statistics. Can be "North" or "South".
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
                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                                     minMLT=minMLT,maxMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                     MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, BYMIN=byMin, $
                                     SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                     HEMI=hemi, $
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
  
  IF NOT KEYWORD_SET(hemi) THEN hemi = "North"

  ;take care of hemisphere
  IF hemi EQ "North" THEN BEGIN
     IF NOT KEYWORD_SET(minI) THEN minI = 60L
     IF NOT KEYWORD_SET(maxI) THEN maxI = 84L
  ENDIF ELSE BEGIN
     IF hemi EQ "South" THEN BEGIN
        IF NOT KEYWORD_SET(minI) THEN minI = -84L
        IF NOT KEYWORD_SET(maxI) THEN maxI = -60L
     ENDIF ELSE BEGIN
        PRINT,"Invalid hemisphere name provided! Should be 'North' or 'South'."
        PRINT,"Defaulting to 'North'."
        hemi="North"
     ENDELSE
  ENDELSE

  IF NOT KEYWORD_SET(minMC) THEN minMC = 1                ; Minimum current derived from mag data, in microA/m^2
  IF NOT KEYWORD_SET(maxNEGMC) THEN maxNEGMC = -1         ; Current must be less than this, if it's going to make the cut
  
  ;;Shouldn't be leftover unused params from batch call
  IF ISA(e) THEN BEGIN
     IF $
        NOT tag_exist(e,"wholecap") AND NOT tag_exist(e,"noplotintegral") AND NOT tag_exist(e,"mirror") $ ;keywords for interp_polar2dhist
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
              IF hemi EQ "North" THEN BEGIN
                 minI=60
                 maxI=84
              ENDIF ELSE BEGIN
                 minI=-84
                 maxI=-60
              ENDELSE
           ENDIF
        ENDIF
     ENDELSE
     
  ENDIF
  
  ;;********************************************
  ;;satellite data options
  
  IF NOT KEYWORD_SET(satellite) THEN satellite = "OMNI"                ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  IF NOT KEYWORD_SET(omni_Coords) THEN omni_Coords = "GSM"             ; either "GSE" or "GSM"

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
     byMinStr='byMin_' + String(byMin,format='(D0.1)') + '_' ;STRCOMPRESS(byMin,/REMOVE_ALL)
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
;;     IF NOT KEYWORD_SET(logCharEPlot) THEN CharEPlotRange=[1,4000] ELSE CharEPlotRange=[0,3.60206]; [0,3.69897]
     IF NOT KEYWORD_SET(logCharEPlot) THEN CharEPlotRange=charERange ELSE CharEPlotRange=ALOG10(charERange)
  ENDIF

  ;;********************************************
  ;;Stuff for output
  hoyDia= STRMID(SYSTIME(0), 4, 3) + "_" + $
          STRMID(SYSTIME(0), 8,2) + "_" + STRMID(SYSTIME(0), 22, 2)

  IF KEYWORD_SET(medianplot) THEN plotMedOrAvg = "_med" ELSE plotMedOrAvg = "_avg"

  IF NOT KEYWORD_SET(plotSuffix) THEN plotSuffix = "" ;; ELSE plotSuffix = "--" + plotSuffix
  ;; IF NOT KEYWORD_SET(plotPrefix) THEN BEGIN
  ;;    plotType='Eflux_' +eFluxPlotType
  ;;    plotType=(N_ELEMENTS(logEfPlot) EQ 0) ? plotType : 'log' + plotType
  ;;    plotType=(N_ELEMENTS(logPfPlot) EQ 0) ? plotType : 'logPf_' + plotType
  ;;    plotDir=(KEYWORD_SET(squarePlot)) ? plotDir + plotType : plotDir + "polar/" + plotType + '/' 
  ;; ENDIF ELSE 
  IF NOT KEYWORD_SET(plotPrefix) THEN plotPrefix = "" ;; ELSE plotPrefix = plotPrefix + "--"

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

  minM=FLOOR(minM*4.0)/4.0  ;to 1/4 precision
  maxM=FLOOR(maxM*4.0)/4.0 
  minI=FLOOR(minI*4.0)/4.0 
  maxI=FLOOR(maxI*4.0)/4.0 
  


END