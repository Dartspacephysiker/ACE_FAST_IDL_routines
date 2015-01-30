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
;                                            Can be 'dawnward', 'duskward', 'bzNorth', 'bzSouth', or 'all_IMF'
;		     ANGLELIM1         :     
;		     ANGLELIM2         :     
;		     ORBRANGE          :     
;		     MLTBINS           :  MLT binsize  (Default: 0.5)
;		     ILATBINS          :  ILAT binsize (Default: 2.0)
;		     MIN_NEVENTS       :  Minimum number of events an orbit must contain to qualify as a "participating orbit"
;                    MASKMIN           :  Minimum number of events a given MLT/ILAT bin must contain to show up on the plot.
;                                            Otherwise it gets shown as "no data". (Default: 1)
;		     NPLOTS            :  Plot number of orbits.   
;
;                *IMF SATELLITE PARAMETERS
;                    SATELLITE         :  Satellite to use for checking FAST data against IMF.
;                                           Can be any of "ACE", "wind", or "wind_ACE".
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
;                    CUSTOMERANGE      :  Range of allowable values for e- flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;
;                *POYNTING FLUX PLOT OPTIONS
;		     PPLOTS            :  Do Poynting flux plots.
;                    LOGPFPLOT         :  Do log plots of Poynting flux.
;                    ABSPFLUX          :  Use absolute value of Poynting flux (required for log plots).
;                    NONEGPFLUX        :  Do not use negative Poynting fluxes in any of the plots
;                    NOPOSPFLUX        :  Do not use positive Poynting fluxes in any of the plots
;                    CUSTOMPRANGE      :  Range of allowable values for e- flux plots. 
;                                         (Default: [0,3]; [-1,0.5] for log plots)
;
;                *ION FLUX PLOTS
;		     IPLOTS            :  Do ion plots.
;
;                *ORBIT PLOT OPTIONS
;		     ORBPLOT           :  Contributing orbit plots
;		     ORBTOTPLOT        :  Plot of total number of orbits for each bin, 
;                                            given user-specified restrictions on the database.
;		     ORBFREQPLOT       :  Plot of orbits contributing to a given bin, 
;                                            divided by total orbits passing through the bin.
;                    NEVENTPERORBPLOT  :  Plot of number of events per orbit.
;
;                *ASSORTED PLOT OPTIONS--APPLICABLE TO ALL PLOTS
;		     MEDIANPLOT        :  Do median plots instead of averages.
;		     LOGPLOT           :     
;		     POLARPLOT         :  Do plots in polar stereo coordinates. (Default: on)    
;                    WHOLECAP*         :   *(Only for polar plot!) Plot the entire polar cap, not just a range of MLTs and ILATs
;                    MIDNIGHT*         :   *(Only for polar plot!) Orient polar plot with midnight (24MLT) at bottom
;		     DBFILE            :  Which database file to use?
;		     DATADIR           :     
;		     DO_CHASTDB        :  Use Chaston's original ALFVEN_STATS_3 database. 
;                                            (He used it for a few papers, I think, so it's good).
;
;                  *VARIOUS OUTPUT OPTIONS
;		     WRITEASCII        :     
;		     WRITEHDF5         :      
;                    WRITEPROCESSEDH2D :  Use this to output processed, histogrammed data. That way you
;                                            can share with others!
;		     SAVERAW           :     
;                    NOPLOTSJUSTDATA   :  No plots whatsoever; just give me the dataz.
;                    NOSAVEPLOTS       :  Don't save plots, just show them immediately
;		     PLOTPREFIX        :     
;                    OUTPUTPLOTSUMMARY :  Make a text file with record of running params, various statistics
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
                                     CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, ORBRANGE=orbRange, $
                                     MLTBINS=MLTbinS, ILATBINS=ILATbinS, $
                                     SATELLITE=satellite, $
                                     DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                     NPLOTS=nPlots, $
                                     EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, ABSEFLUX=absEflux, $
                                     NONEGEFLUX=noNegEflux, NOPOSEFLUX=noPosEflux, $
                                     CUSTOMERANGE=customERange, $
                                     PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                     NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, $
                                     CUSTOMPRANGE=customPRange, $
                                     IPLOTS=iPlots, $
                                     ORBPLOT=orbPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                                     NEVENTPERORBPLOT=nEventPerOrbPlot, $
                                     MEDIANPLOT=medianPlot, LOGPLOT=logPlot, $
                                     POLARPLOT=polarPlot, $ ;WHOLECAP=wholeCap, $
                                     MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                                     DBFILE=dbfile, DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                                     WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, SAVERAW=saveRaw, $
                                     NOPLOTSJUSTDATA=noPlotsJustData, NOSAVEPLOTS=noSavePlots, PLOTPREFIX=plotPrefix, $
                                     OUTPUTPLOTSUMMARY=outputPlotSummary, $
                                     _EXTRA = e

  ;;variables to be used by interp_contplot.pro
  COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT,binMLT,binILAT,min_magc,max_negmagc

  !EXCEPT=0                                                      ;Do report errors, please
  ;;***********************************************
  tempSave=0

  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  ;;(Originally from JOURNAL_Oct112013_orb_avg_plots_extended.pro)
  
  mu_0 = 4.0e-7 * !PI                                            ;perm. of free space, for Poynt. est
  ;;mu_0 = 1 ;perm. of free space, for Poynt. est
  
  ;; Don't use minOrb or maxOrb; use orbRange as a keyword in call to this pro
  ;; minOrb=8100                   ;8260 for Strangeway study
  ;; maxOrb=8500                   ;8292 for Strangeway study
  ;;nOrbits = maxOrb - minOrb + 1
  
  IF NOT KEYWORD_SET(minE) THEN minE = 4                         ; 4 eV in Strangeway
  IF NOT KEYWORD_SET(maxE) THEN maxE = 250                       ; ~300 eV in Strangeway
  
  IF NOT KEYWORD_SET(minMLT) THEN minMLT = 6L
  IF NOT KEYWORD_SET(maxMLT) THEN maxMLT = 18L
  
  IF NOT KEYWORD_SET(minILAT) THEN minILAT = 68L
  IF NOT KEYWORD_SET(maxILAT) THEN maxILAT = 84L
  
  IF NOT KEYWORD_SET(min_magc) THEN min_magc = 10                ; Minimum current derived from mag data, in microA/m^2
  IF NOT KEYWORD_SET(max_negmagc) THEN max_negmagc = -10         ; Current must be less than this, if it's going to make the cut
  
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
           minMLT=0
           maxMLT=24
           minILAT=64
           maxILAT=88
        ENDIF
     ENDELSE
     
  ENDIF
  
  ;;********************************************
  ;;satellite data options
  
  IF NOT KEYWORD_SET(satellite) THEN satellite = "wind_ACE"      ;either "ACE", "wind", or "wind_ACE"
  
  IF NOT KEYWORD_SET(delay) THEN delay = 660                     ;Delay between ACE propagated data and ChastonDB data
                                                                 ;Bin recommends something like 11min
  
  IF NOT KEYWORD_SET(stableIMF) THEN stableIMF = 0S                    ;Set to a time (in minutes) over which IMF stability is required
  IF NOT KEYWORD_SET(includeNoConsecData) THEN includeNoConsecData = 0 ;Setting this to 1 includes Chaston data for which  
                                                                       ;there's no way to calculate IMF stability
                                                                       ;Only valid for stableIMF GE 1
  IF NOT KEYWORD_SET(checkBothWays) THEN checkBothWays = 0       ;
  
  IF NOT KEYWORD_SET(Bx_over_ByBz_Lim) THEN Bx_over_ByBz_Lim = 0 ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  
  ;;Want to make plots in plotDir?
  IF NOT KEYWORD_SET(plotDir) THEN plotDir = 'plots/'
  ;;plotPrefix='NESSF2014_reproduction_Jan2015'

  saveRaw=0                     ; save raw data plots?
  saveRawDir="testcode/laTEST/"
 
  ;;Write output file with data params? Only possible if noSavePlots=0...
  IF KEYWORD_SET(noSavePlots) AND KEYWORD_SET(outputPlotSummary) THEN BEGIN
     print, "Is it possible to have outputPlotSummary==1 while noSavePlots==0? You used to say no..."
     outputPlotSummary=1   ;;Change to zero if not wanted
  ENDIF 

  ;;Write plot data output for Bin?

  IF NOT KEYWORD_SET(dataDir) THEN dataDir="/SPENCEdata2/Research/Cusp/database/"
  ;;********************************************
  ;;Variables for histos
  ;;Bin sizes for 2d histos

  IF N_ELEMENTS(polarPlot) EQ 0 THEN BEGIN
     IF N_ELEMENTS(wholeCap) EQ 1 THEN PRINT,"Keyword WHOLECAP set without setting POLARPLOT! I'm doing it for you..."
     polarPlot=1                                                 ;do Polar plots instead?
  ENDIF

  IF N_ELEMENTS(nPlots) EQ 0 THEN nPlots = 0                     ; do num events plots?
  IF N_ELEMENTS(ePlots) EQ 0 THEN ePlots =  0                    ;electron flux plots?
  IF N_ELEMENTS(eFluxPlotType) EQ 0 THEN eFluxPlotType = "Integ" ;options are "Integ" and "Max"
  IF N_ELEMENTS(pPlots) EQ 0 THEN pPlots =  0                    ;Poynting flux [estimate] plots?
  IF N_ELEMENTS(iPlots) EQ 0 THEN iPlots =  0                    ;ion Plots?
  IF N_ELEMENTS(orbPlot) EQ 0 THEN orbPlot =  0                  ;Contributing orbits plot?
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
     angleLim1=45               ;in degrees
     angleLim2=135              ;in degrees
  ENDIF ELSE BEGIN 
     angleLim1=180              ;for doing all IMF
     angleLim2=180 
  ENDELSE

  ;;Bin sizes for 2D histos
  binMLT=(N_ELEMENTS(MLTbinS) EQ 0) ? 0.5 : MLTbinS
  binILAT=(N_ELEMENTS(ILATbinS) EQ 0) ? 2.0 : ILATbinS 

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr=''
  IF NOT KEYWORD_SET(maskMin) THEN maskMin=1 $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='maskMin_' + STRCOMPRESS(maskMin,/REMOVE_ALL) + '_'
     ENDIF
  ENDELSE
  
  ;;######ELECTRONS
  ;;Eflux max abs. value in interval, or integrated flux?
  ;;NOTE: max value has negative values, which can mess with
  ;;color bars
  
  IF KEYWORD_SET(logEfPlot) AND NOT KEYWORD_SET(absEflux) AND NOT KEYWORD_SET(noNegEflux) THEN BEGIN 
     print,"Warning!: You're trying to do log Eflux plots but you don't have 'absEflux', 'noNegEflux', or 'noPosEflux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Eflux values"
     WAIT, 1
;;     absEflux=1
     noNegEflux=1
  ENDIF

  IF KEYWORD_SET(noPosEflux) AND KEYWORD_SET (logEfPlot) THEN absEflux = 1

  ;;For linear or log EFlux plotrange
  IF NOT KEYWORD_SET(customERange) THEN BEGIN
     IF NOT KEYWORD_SET(logEfPlot) THEN customERange=[0.01,100] ELSE customERange=[-2,2]
  ENDIF
  
  ;;######Poynting flux
  IF KEYWORD_SET(logPfPlot) AND NOT KEYWORD_SET(absPflux) AND NOT KEYWORD_SET(noNegPflux) THEN BEGIN 
     print,"Warning!: You're trying to do log Pflux plots but you don't have 'absPflux', 'noNegPflux', or 'noPosPflux' set!"
     print,"Can't make log plots without using absolute value or only positive values..."
     print,"Default: junking all negative Pflux values"
     WAIT, 1
;;     absEflux=1
     noPosPflux=1
  ENDIF

  IF KEYWORD_SET(noPosPflux) AND KEYWORD_SET (logPfPlot) THEN absPflux = 1

  ;;For linear or log PFlux plotrange
  IF NOT KEYWORD_SET(customPRange) THEN BEGIN
     IF NOT KEYWORD_SET(logPfPlot) THEN customPRange=[0,3] ELSE customPRange=[-1,0.5]
  ENDIF

  ;;######Ion flux (up)
  logIonFluxPlot=0
  absIonFlux=0
  ;;For linear or log ion flux plotrange
  IF NOT KEYWORD_SET(logIonFluxPlot) THEN customIonRange=[0,1.5e8] ELSE customIonRange=[1,8.5]
  
  ;;######Oxy flux
  logOFluxPlot=0
  absOFlux=0
  ;;For linear or log ion flux plotrange
  ;;IF logOFluxPlot EQ 0 THEN customORange=[0,1e4] ELSE customRange=ALOG10([0,1e4]
    
  ;;********************************************
  ;;Stuff for output
  hoyDia= STRMID(SYSTIME(0), 4, 3) + "_" + $
          STRMID(SYSTIME(0), 8,2) + "_" + STRMID(SYSTIME(0), 22, 2)
  IF KEYWORD_SET(medianplot) THEN plotSuff = "_med" ELSE plotSuff = "_avg"
  IF NOT KEYWORD_SET(plotPrefix) THEN BEGIN
     plotType='Eflux_' +eFluxPlotType
     plotType=(logEfPlot EQ 0) ? plotType : 'log' + plotType
     plotType=(logPfPlot EQ 0) ? plotType : 'logPf_' + plotType
     plotDir=(polarPlot) ? plotDir + "polar/" + plotType + '/' : plotDir + plotType
  ENDIF ELSE plotDir += plotPrefix + "--"

  smoothStr=""

  IF KEYWORD_SET(smoothWindow) THEN smoothStr = strtrim(smoothWindow,2)+"min_IMFsmooth--"

  ;;********************************************
  ;;Figure out both hemisphere and plot indices, 
  ;;tap DBs, and setup output
  IF minILAT GT 0 THEN hemStr='North' ELSE IF maxILAT LT 0 THEN hemStr='South' $
  ELSE BEGIN 
     printf,lun,"Which hemisphere?" & hemStr = '??'
  ENDELSE
  
  ;;parameter string
  paramStr=hemStr+'_'+clockStr+plotSuff+"--"+strtrim(stableIMF,2)+"stable--"+smoothStr+satellite+"_"+maskStr+hoyDia


  ;;Open file for text summary, if desired
  IF KEYWORD_SET(outputPlotSummary) THEN $
     OPENW,lun,plotDir+'fluxplots_'+paramStr+'.txt',/GET_LUN $
  ELSE lun=-1                   ;-1 is lun for STDOUT
  
  ;;Now run these to tap the databases and interpolate satellite data
  
  ind_region_magc_geabs10_ACEstart = get_chaston_ind(maximus,satellite,lun,cdbTime=cdbTime,dbfile=dbfile,CHASTDB=do_chastdb,ORBRANGE=orbRange)
  phiChast= interp_mag_data(ind_region_magc_geabs10_ACEstart,satellite,delay,lun, $
                            cdbTime=cdbTime,CDBINTERP_I=cdbInterp_i,CDBACEPROPINTERP_I=cdbAcepropInterp_i,MAG_UTC=mag_utc, PHICLOCK=phiclock, $
                            DATADIR=dataDir,SMOOTHWINDOW=smoothWindow)
  phiImf_ii= check_imf_stability(clockStr,angleLim1,angleLim2,phiChast,cdbAcepropInterp_i,stableIMF,mag_utc,phiclock,LUN=lun,bx_over_bybz=Bx_over_ByBz_Lim)
  
  plot_i=cdbInterp_i(phiImf_ii)

  ;;********************************************************
  ;;WHICH ORBITS ARE UNIQUE?
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."
  
  ;;***********************************************
  ;;Calculate Poynting flux estimate
  
  ;;1.0e-9 to take stock of delta_b being recordin in nT
  POYNT_EST=maximus.DELTA_B * maximus.DELTA_E * 1.0e-9 / mu_0 
  goodpoynt=where(poynt_est(plot_i) GT 0)
  plot_i=plot_i(goodpoynt)
  ;;********************************************
  ;;Now time for data summary

  printf,lun,""
  printf,lun,"**********DATA SUMMARY**********"
  printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
  printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
  printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
  printf,lun,"Screening parameters: [Min] [Max]"
  printf,lun,"Mag current: " + strtrim(max_negmagc,2) + " " + strtrim(min_magc,2)
  printf,lun,"MLT: " + strtrim(minMLT,2) + " " + strtrim(maxMLT,2)
  printf,lun,"ILAT: " + strtrim(minILAT,2) + " " + strtrim(maxILAT,2)
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

  
  IF minMLT NE 0 THEN minMLT = 0L
  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  h2dFluxN=hist_2d(maximus.mlt(plot_i),$
                   maximus.ilat(plot_i),$
                   BIN1=binMLT,BIN2=binILAT,$
                   MIN1=MINMLT,MIN2=MINILAT,$
                   MAX1=MAXMLT,MAX2=MAXILAT)

  h2dFluxNTitle="Number of events"
  IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN BEGIN 
     dataName="nEvents_" 
     dataRawPtr=PTR_NEW() 
  ENDIF

  h2dStr={h2dStr, data: DOUBLE(h2dFluxN), $
          title : "Number of events", $
          lim : DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) }

  ;;Make a mask for plots so that we can show where no data exists
  h2dMaskStr={h2dStr}
  h2dMaskStr.data=h2dStr.data
  h2dMaskStr.data(where(h2dStr.data LT maskMin,/NULL))=255
  h2dMaskStr.data(where(h2dStr.data GE maskMin,NULL))=0
  h2dMaskStr.title="Histogram mask"

  IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN BEGIN 
     dataName=[dataName,"histoMask_"] 
     dataRawPtr=[dataRawPtr,PTR_NEW()] 
  ENDIF

;  IF KEYWORD_SET(nPlots) THEN h2dStr=[h2dStr,TEMPORARY(h2dMaskStr)] ELSE h2dStr = TEMPORARY(h2dMaskStr)
  IF KEYWORD_SET(nPlots) THEN h2dStr=[h2dStr,h2dMaskStr] ELSE h2dStr = h2dMaskStr

  ;;h2dStr={h2dStr, data : DBLARR(N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*))), title : "", lim : DBLARR(2) }


  ;;########Medians?########
  ;;IF medianplot GT 0 THEN $
  ;;medHist=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
  ;;                           plot_i,MIN1=MINMLT,MIN2=MINILAT,$
  ;;                           MAX1=MAXMLT,MAX2=MAXILAT,$
  ;;                           BINSIZE1=binMLT,BINSIZE2=binILAT,$
  ;;                           OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT)


  ;;########ELECTRON FLUX########

  h2dEStr={h2dStr}

  ;;If not allowing negative fluxes
  IF eFluxPlotType EQ "Integ" THEN BEGIN
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

  IF KEYWORD_SET(medianplot) THEN BEGIN 
     h2dEstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                              elecData,$
                              MIN1=MINMLT,MIN2=MINILAT,$
                              MAX1=MAXMLT,MAX2=MAXILAT,$
                              BINSIZE1=binMLT,BINSIZE2=binILAT,$
                              OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                              ABSMED=absEflux) 
  ENDIF ELSE BEGIN 
     h2dEStr.data=hist2d(maximus.mlt(plot_i), $
                         maximus.ilat(plot_i),$
                         elecData,$
                         MIN1=MINMLT,MIN2=MINILAT,$
                         MAX1=MAXMLT,MAX2=MAXILAT,$
                         BINSIZE1=binMLT,BINSIZE2=binILAT,$
                         OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) 
     h2dEStr.data(where(h2dFluxN NE 0,/NULL))=h2dEStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) 
  ENDELSE 

  ;;Log plots desired?
  absEstr=""
  negEstr=""
  posEstr=""
  logEstr=""
  IF KEYWORD_SET(absEflux)THEN BEGIN 
     h2dEStr.data = ABS(h2dEStr.data) 
     absEstr= "Abs--" 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN elecData=ABS(elecData) 
  ENDIF
  IF KEYWORD_SET(noNegEflux) THEN BEGIN
     negEstr = "NoNegs--"
  ENDIF
  IF KEYWORD_SET(noPosEflux) THEN BEGIN
     posEstr = "NoPos--"
  ENDIF
  IF KEYWORD_SET(logEfPlot) THEN BEGIN 
     logEstr="Log " 
     h2dEStr.data(where(h2dEStr.data GT 0,/NULL))=ALOG10(h2dEStr.data(where(h2dEStr.data GT 0,/null))) 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN elecData(where(elecData GT 0,/null))=ALOG10(elecData(where(elecData GT 0,/null))) 
  ENDIF
  absnegslogEstr=absEstr + negEstr + posEstr + logEstr

  ;;Do custom range for Eflux plots, if requested
  ;; IF  KEYWORD_SET(customERange) THEN h2dEStr.lim=TEMPORARY(customERange)$
  IF  KEYWORD_SET(customERange) THEN h2dEStr.lim=customERange $
  ELSE h2dEStr.lim = [MIN(h2dEstr.data),MAX(h2dEstr.data)]

  h2dEStr.title= absnegslogEstr + "Electron Flux (ergs/cm!U2!N-s)"
  ;; IF KEYWORD_SET(ePlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dEStr)] 
  IF KEYWORD_SET(ePlots) THEN BEGIN & h2dStr=[h2dStr,h2dEStr] 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN BEGIN 
        dataName=[dataName,STRTRIM(absnegslogEstr,2)+"eFlux"+eFluxPlotType+"_"] 
        dataRawPtr=[dataRawPtr,PTR_NEW(elecData)] 
     ENDIF 
  ENDIF

;;   undefine,h2dEStr   ;;,elecData 


  ;;########Poynting Flux########

  h2dPStr={h2dStr}

  IF KEYWORD_SET(noNegPflux) THEN BEGIN
     no_negs_i=WHERE(poynt_est GE 0.0)
     plot_i=cgsetintersection(no_negs_i,plot_i)
  ENDIF

  IF KEYWORD_SET(noPosPflux) THEN BEGIN
     no_pos_i=WHERE(poynt_est GE 0.0)
     plot_i=cgsetintersection(no_pos_i,plot_i)
  ENDIF


  IF KEYWORD_SET(medianplot) THEN BEGIN 
     h2dPstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                              poynt_est(plot_i),$
                              MIN1=MINMLT,MIN2=MINILAT,$
                              MAX1=MAXMLT,MAX2=MAXILAT,$
                              BINSIZE1=binMLT,BINSIZE2=binILAT,$
                              OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                              ABSMED=absPflux) 
  ENDIF ELSE BEGIN 
     h2dPStr.data=hist2d(maximus.mlt(plot_i),$
                         maximus.ilat(plot_i),$
                         poynt_est(plot_i),$
                         MIN1=MINMLT,MIN2=MINILAT,$
                         MAX1=MAXMLT,MAX2=MAXILAT,$
                         BINSIZE1=binMLT,BINSIZE2=binILAT) 
     h2dPStr.data(where(h2dFluxN NE 0,/null))=h2dPStr.data(where(h2dFluxN NE 0,/null))/h2dFluxN(where(h2dFluxN NE 0,/null)) 
  ENDELSE

  IF KEYWORD_SET(writeHDF5) or KEYWORD_SET(writeASCII) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN pData=poynt_est(plot_i)

  ;;Log plots desired?
  absPstr=""
  negPstr=""
  posPstr=""
  logPstr=""
  IF KEYWORD_SET(absPflux) THEN BEGIN 
     h2dPStr.data = ABS(h2dPStr.data) 
     absPstr= "Abs" 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN pData=ABS(pData) 
  ENDIF

  IF KEYWORD_SET(noNegPflux) THEN BEGIN
     negPstr = "NoNegs--"
  ENDIF

  IF KEYWORD_SET(noPosPflux) THEN BEGIN
     posPstr = "NoPos--"
  ENDIF

  IF KEYWORD_SET(logPfPlot) THEN BEGIN 
     logPstr="Log " 
     h2dPStr.data(where(h2dPStr.data GT 0,/null))=ALOG10(h2dPStr.data(where(h2dPStr.data GT 0,/NULL))) 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN $
        pData(where(pData GT 0,/NULL))=ALOG10(pData(where(pData GT 0,/NULL))) 
  ENDIF

  absnegslogPstr=absPstr + negPstr + posPstr + logPstr

  h2dPStr.title= absnegslogPstr + "Poynting Flux (mW/m!U2!N)"

  ;;Do custom range for Pflux plots, if requested
  ;; IF KEYWORD_SET(customPRange) THEN h2dPStr.lim=TEMPORARY(customPRange)$
  IF KEYWORD_SET(customPRange) THEN h2dPStr.lim=customPRange $
  ELSE h2dPStr.lim = [MIN(h2dPstr.data),MAX(h2dPstr.data)]

  ;;IF pPlots NE 0 THEN BEGIN 
  ;;  IF ePlots NE 0 THEN h2dStr=[h2dStr,TEMPORARY(h2dPStr)] $
  ;;  ELSE h2dStr=[TEMPORARY(h2dPStr)] 
  ;;ENDIF
  ;; IF KEYWORD_SET(pPlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dPStr)] 
  IF KEYWORD_SET(pPlots) THEN BEGIN & h2dStr=[h2dStr,h2dPStr] 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN BEGIN 
        dataName=[dataName,STRTRIM(absnegslogPstr,2)+"pFlux_"] 
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

;;   IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN undefine,pData

  ;;if iPlots NE 0 THEN @interp_plots_ions.pro

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
  
  h2dOrbStr={h2dStr}

  h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))
  orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))

  IF(minMLT NE 0) THEN minMLT=0L

  FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
     tempOrb=maximus.orbit(plot_i(uniqueOrbs_ii(j))) 
     temp_ii=WHERE(maximus.orbit(plot_i) EQ tempOrb,/NULL) 
     h2dOrbTemp=hist_2d(maximus.mlt(plot_i(temp_ii)),$
                        maximus.ilat(plot_i(temp_ii)),$
                        BIN1=binMLT,BIN2=binILAT,$
                        MIN1=MINMLT,MIN2=MINILAT,$
                        MAX1=MAXMLT,MAX2=MAXILAT) 
     orbARR[j,*,*]=h2dOrbTemp 
     h2dOrbTemp(WHERE(h2dOrbTemp GT 0,/NULL)) = 1 
     h2dOrbStr.data += h2dOrbTemp 
  ENDFOR

  h2dOrbStr.title="Num Contributing Orbits"

  ;;h2dOrbStr.lim=[MIN(h2dOrbStr.data),MAX(h2dOrbStr.data)]
  h2dOrbStr.lim=[1,60]

  IF KEYWORD_SET(orbPlot) THEN BEGIN & h2dStr=[h2dStr,h2dOrbStr] 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN dataName=[dataName,"orbsContributing_"] 
  ENDIF

  ;;########TOTAL Orbits########

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
  ;;                      BIN1=binMLT,BIN2=binILAT,$
  ;;                      MIN1=MINMLT,MIN2=MINILAT,$
  ;;                      MAX1=MAXMLT,MAX2=MAXILAT) 
  ;;   orbARR[j,*,*]=h2dOrbTemp 
  ;;   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 
  ;;   h2dTotOrbStr.data += h2dOrbTemp 
  ;;ENDFOR

  FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
     tempOrb=maximus.orbit(uniqueOrbs_ii(j)) 
     temp_ii=WHERE(maximus.orbit EQ tempOrb,/NULL) 
     h2dOrbTemp=hist_2d(maximus.mlt(temp_ii),$
                        maximus.ilat(temp_ii),$
                        BIN1=binMLT,BIN2=binILAT,$
                        MIN1=MINMLT,MIN2=MINILAT,$
                        MAX1=MAXMLT,MAX2=MAXILAT) 
     orbARR[j,*,*]=h2dOrbTemp 
     h2dOrbTemp(WHERE(h2dOrbTemp GT 0,/NULL)) = 1 
     h2dTotOrbStr.data += h2dOrbTemp 
  ENDFOR

  h2dTotOrbStr.title="Total Orbits"
  h2dTotOrbStr.lim=[MIN(h2dTotOrbStr.data),MAX(h2dTotOrbStr.data)]

  IF KEYWORD_SET(orbTotPlot) THEN BEGIN & h2dStr=[h2dStr,h2dTotOrbStr] 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN dataName=[dataName,"orbTot_"] 
  ENDIF

  ;;########Orbit FREQUENCY########
  h2dFreqOrbStr={h2dStr}
  h2dFreqOrbStr.data=h2dOrbStr.data
  h2dFreqOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))=h2dOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))/h2dTotOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))
  h2dFreqOrbStr.title="Orbit Frequency"
  ;;h2dFreqOrbStr.lim=[MIN(h2dFreqOrbStr.data),MAX(h2dFreqOrbStr.data)]
  h2dFreqOrbStr.lim=[0,0.5]

;  IF KEYWORD_SET(orbFreqPlot) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dFreqOrbStr)] 
  IF KEYWORD_SET(orbFreqPlot) THEN BEGIN & h2dStr=[h2dStr,h2dFreqOrbStr] 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN dataName=[dataName,"orbFreq_"] 
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
;;   undefine,h2dTotOrbStr
;;   undefine,h2dOrbStr
;;   undefine,h2dFreqOrbStr

  ;;########NEvents/orbit########
  h2dNEvPerOrbStr={h2dStr}
  h2dNEvPerOrbStr.data=h2dStr(0).data
  h2dNEvPerOrb_i=WHERE(h2dStr(0).data NE 0,/NULL)
  h2dNEvPerOrbStr.data(h2dNEvPerOrb_i)=h2dNEvPerOrbStr.data(h2dNEvPerOrb_i)/h2dTotOrbStr.data(h2dNEvPerOrb_i)
  h2dNEvPerOrbStr.title="N Events per Orbit"
  ;;h2dNEvPerOrbStr.lim=[MIN(h2dNEvPerOrbStr.data),MAX(h2dNEvPerOrbStr.data)]
  h2dNEvPerOrbStr.lim=[0,10]

  IF KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN 
     h2dStr=[h2dStr,h2dNEvPerOrbStr] 
     IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN dataName=[dataName,"nEventPerOrb_"] 
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
  IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR KEYWORD_SET(polarPlot) OR KEYWORD_SET(saveRaw) THEN BEGIN 
     dataName=SHIFT(dataName,-2) 
     dataRawPtr=SHIFT(dataRawPtr,-2) 
  ENDIF

  IF KEYWORD_SET(polarPlot) THEN save,h2dStr,dataName,maxMLT,minMLT,maxILAT,minILAT,binMLT,binILAT,$
                           saveRawDir,clockStr,plotSuff,stableIMF,hoyDia,hemstr,$
                           ;;                       filename=saveRawDir+'fluxplots_'+paramStr+".dat"
                           filename='temp/polarplots_'+paramStr+".dat"

  ;;if not saving plots and plots not turned off, do some stuff  ;; otherwise, make output
  IF KEYWORD_SET(noSavePlots) THEN BEGIN 
     IF NOT KEYWORD_SET(noPlotsJustData) AND NOT KEYWORD_SET(polarPlot) THEN $
        cgWindow, 'interp_contplotmulti_str', h2dStr,$
                  ;; SAVERAW=(saveRaw) ? saveRawDir + 'fluxplots_'+paramStr : 0,$
                  Background='White', $
                  WTitle='Flux plots for '+hemStr+'ern Hemisphere, '+clockStr+ $
                  ' IMF, ' + strmid(plotSuff,1) $
     ELSE IF NOT KEYWORD_SET(noPlotsJustData) THEN $  ;FOR j=0, N_ELEMENTS(h2dStr)-1 DO $
        ;;    cgWindow,'interp_polar_plot',[[*dataRawPtr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
                ;;             h2dStr[0].lim,Background="White",wxsize=800,wysize=600, $
                ;;             WTitle='Polar plot_'+dataName[0]+','+hemStr+'ern Hemisphere, '+clockStr+ $
                ;;             ' IMF, ' + strmid(plotSuff,1) $
        FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO $ 
           cgWindow,'interp_polar2dhist',h2dStr[i],dataName[i], $
                'temp/polarplots_'+paramStr+".dat",_extra=e,$
                Background="White",wxsize=800,wysize=600, $
                WTitle='Polar plot_'+dataName[i]+','+hemStr+'ern Hemisphere, '+clockStr+ $
                ' IMF, ' + strmid(plotSuff,1) $
                
     ELSE PRINTF,LUN,"**Plots turned off with noPlotsJustData**" 
  ENDIF ELSE BEGIN 
     IF NOT KEYWORD_SET(polarPlot) AND NOT KEYWORD_SET(noPlotsJustData) THEN BEGIN 
        CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
        PRINTF,LUN, "Creating output files..." 

        ;;Create a PostScript file.
        cgPS_Open, plotDir + 'fluxplots_'+paramStr+'.ps' 
        interp_contplotmulti_str,h2dStr 
        cgPS_Close 

        ;;Create a PNG file with a width of 800 pixels.
        cgPS2Raster, plotDir + 'fluxplots_'+paramStr+'.ps', $
                     /PNG, Width=1000, /DELETE_PS 
     
     ENDIF ELSE IF NOT KEYWORD_SET(noPlotsJustData) THEN BEGIN 
        CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
        PRINTF,LUN, "Creating output files..." 
        
        FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO BEGIN  
           
           ;;Create a PostScript file.
           cgPS_Open, plotDir + 'plot_'+dataName[i]+paramStr+'.ps' 
           ;;interp_polar_plot,[[*dataRawPtr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
           ;;          h2dStr[0].lim 
           interp_polar2dhist,h2dStr[i],dataName[i],'temp/polarplots_'+paramStr+".dat",_extra=e;WHOLECAP=tag_exist(e,"wholecap") ? 1 : 0 
           cgPS_Close 
           
           ;;Create a PNG file with a width of 800 pixels.
           cgPS2Raster, plotDir + 'plot_'+dataName[i]+paramStr+'.ps', $
                        /PNG, Width=1000, /DELETE_PS
        ENDFOR    
        
     ENDIF 
  ENDELSE

  ;;For altitude histograms
  ;;cgWindow,"cgHistoPlot",maximus.alt(plot_i),title="Current events for predom. " +clockStr+" IMF, 15Min stability",fill="red"

  IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
     CLOSE,lun 
     FREE_LUN,lun 
  ENDIF


   ;;********************************************************
   ;;Thanks, IDL Coyote--time to write out lots of data

   IF KEYWORD_SET(writeHDF5) THEN BEGIN 
      ;;write out raw data here
      FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN 
         fname=plotDir+dataName[j]+paramStr+'.h5' 
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
      ;;      fname=plotDir+h2dStr[i].title+'_'+ $
      ;;            paramStr+'.h5' 
      ;;      fileID=H5F_CREATE(fname) 
      ;;      datatypeID=H5T_IDL_CREATE(h2dStr[i]) 
      ;;      dataspaceID=H5S_CREATE_SIMPLE(1) 
      ;;      datasetID = H5D_CREATE(fileID,$
      ;;                             h2dStr[i].title+'_'+hemStr+'_'+clockStr+plotSuff, $
      ;;                             datatypeID, dataspaceID) 
      ;;      H5D_WRITE,datasetID, h2dStr[i] 
      ;;      H5F_CLOSE,fileID    
      ;;   ENDFOR 

      ;;To read your newly produced HDF5 file, do this:
      ;;s = H5_PARSE(fname, /READ_DATA)
      ;;HELP, s.mydata._DATA, /STRUCTURE  
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN 
            fname=plotDir+dataName[j]+paramStr+'.h5' 
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
   ;;  fname=plotDir+'fluxplots_'+paramStr+'.ascii' 
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
         fname=plotDir+dataName[j]+paramStr+'.ascii' 
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
            fname=plotDir+"h2d_"+dataName[i]+paramStr+'.ascii' 
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