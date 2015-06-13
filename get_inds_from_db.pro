;+
; NAME: GET_INDS_FROM_DB
;
;
;
; PURPOSE:  Get indices from maximus that are relevant to specified SW conditions. For example, get indices of Alfvén events when
; IMF By > 3 nT.
;
; CATEGORY:         You know.
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-
PRO GET_INDS_FROM_DB, DBFILE=dbfile, CDBTIMEFILE=cdbTimeFile, $
                      CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                      ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                      NEVENTSRANGE=nEventsRange, NUMORBLIM=numOrbLim, $
                      minMLT=minMLT,maxMLT=maxMLT, $ ;BINMLT=binMLT, $
                      MINILAT=minILAT,MAXILAT=maxILAT, $ ;BINILAT=binILAT, $
                      MIN_NEVENTS=min_nEvents, BYMIN=byMin, BZMIN=bzMin, $
                      SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                      HEMI=hemi, $
                      DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                      DATADIR=dataDir, DO_CHASTDB=do_chastDB, $
                      INDPREFIX=indPrefix,INDSUFFIX=indSuffix, $
                      OUTDIR=outDir, $
                      _EXTRA = e
;;                      MASKMIN=maskMin, $
  
  ;; some commoners
  COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNEGMC

  !EXCEPT=0                                                      ;Do report errors, please

  ;; Default
  ;; defDBFile = "/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus--cleaned.sav"
  ;; defDBFile = "/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav"
  defDBFile = "/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav"
  IF NOT KEYWORD_SET(dbFile) AND NOT KEYWORD_SET(do_ChastDB) THEN dbFile=defDBFILE ELSE BEGIN
     IF KEYWORD_SET(do_ChastDB) THEN dbFile = '/SPENCEdata/Research/Cusp/database/processed/maximus.dat' 
  ENDELSE
  restore,dbFile

  ;; defCDBTimeFile = "/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--cdbTime--cleaned.sav"
  defCDBTimeFile = "/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--cdbTime.sav"
  IF NOT KEYWORD_SET(cdbTimeFile) AND NOT KEYWORD_SET(do_ChastDB) THEN cdbTimeFile = defCDBTimeFile ELSE BEGIN
     IF KEYWORD_SET(do_ChastDB) THEN cdbTimeFile = '/SPENCEdata/Research/Cusp/database/processed/cdbTime.sav' 
  ENDELSE
  restore,cdbTimeFile

  defOutDir='plot_indices_saves/'
  IF NOT KEYWORD_SET(outDir) THEN outDir = defOutDir

  lun=-1 ;default to stdout

  PRINT,"You know this thing hasn't been updated to include Holzworth/Meng stuff..."
  STOP
  ;;***********************************************
  ;;Tons of defaults
  
  ;ranges in MLT and ILAT
  ;Note, in Chaston's 2007 paper, "How important are dispersive Alfvén waves?", the occurrence plot
  ; has ilat bin size = 3.0 and mlt bin size = 1.0
  defMinM = 0.0
  defMaxM = 24.0
  ;; defBinM = 0.75
  ;; defBinM = 0.5

  defMinI = 60.0 ;these might need to be longs (i.e., '60L')
  defMaxI = 88.0
  ;; defBinI = 3.0

  defMinMagC = 10
  defMaxNegMagC = -10

  defCharERange = [4.0,300]
  defAltRange = [1000.0, 5000.0]

  defEFluxPlotType = "Max"
  defIFluxPlotType = "Max"
  defCharEPlotType = "lossCone"

  ; satellite defaults
  defSatellite = "OMNI"    ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  defOmni_Coords = "GSM"             ; either "GSE" or "GSM"

  defDelay = 900

  defStableIMF = 1S             ;Set to a time (in minutes) over which IMF stability is required
  defIncludeNoConsecData = 0    ;Setting this to 1 includes Chaston data for which  
                                ;there's no way to calculate IMF stability
                                ;Only valid for stableIMF GE 1
  defCheckBothWays = 0          
  
  defBx_over_ByBz_Lim = 0       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  defClockStr = 'dawnward'
  
  defAngleLim1 = 45.0
  defAngleLim2 = 135.0

  ; assorted
  ;; defMaskMin = 1

  defPlotDir = 'plots/'
  defRawDir = 'rawsaves/'

  defOutSummary = 1 ;for output plot summary

  defDataDir = "/SPENCEdata/Research/Cusp/database/"


  ; Handle MLT and ILAT
  IF minMLT NE !NULL THEN minM = minMLT
  IF KEYWORD_SET(maxMLT) THEN maxM = maxMLT

  ;;Bin sizes for 2D histos
  ;; binM=(N_ELEMENTS(BinMLT) EQ 0) ? defBinM : BinMLT
  ;; binI=(N_ELEMENTS(BinILAT) EQ 0) ? defBinI : BinILAT 

  IF KEYWORD_SET(minILAT) THEN minI = minILAT
  IF KEYWORD_SET(maxILAT) THEN maxI = maxILAT


  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  ;;(Originally from JOURNAL_Oct112013_orb_avg_plots_extended.pro)
  
  mu_0 = 4.0e-7 * !PI                                            ;perm. of free space, for Poynt. est
  
  ;; Don't use minOrb or maxOrb; use orbRange as a keyword in call to this pro
  ;; minOrb=8100                   ;8260 for Strangeway study
  ;; maxOrb=8500                   ;8292 for Strangeway study
  ;;nOrbits = maxOrb - minOrb + 1
  
  IF NOT KEYWORD_SET(charERange) THEN charERange = defCharERange         ; 4,~300 eV in Strangeway

  IF NOT KEYWORD_SET(altitudeRange) THEN altitudeRange = defAltRange ;Rob Pfaff says no lower than 1000m
  
  IF minM EQ !NULL THEN minM = defMinM
  IF maxM EQ !NULL THEN maxM = defMaxM
  
  IF NOT KEYWORD_SET(hemi) THEN hemi = "North"

  ;take care of hemisphere
  IF hemi EQ "North" THEN BEGIN
     IF minI EQ !NULL THEN minI = defMinI
     IF maxI EQ !NULL THEN maxI = defMaxI
  ENDIF ELSE BEGIN
     IF hemi EQ "South" THEN BEGIN
        IF minI EQ !NULL THEN minI = -defMaxI
        IF maxI EQ !NULL THEN maxI = -defMinI
     ENDIF ELSE BEGIN
        PRINT,"Invalid hemisphere name provided! Should be 'North' or 'South'."
        PRINT,"Defaulting to 'North'."
        hemi="North"
     ENDELSE
  ENDELSE

  IF NOT KEYWORD_SET(minMC) THEN minMC = defMinMagC                ; Minimum current derived from mag data, in microA/m^2
  IF NOT KEYWORD_SET(maxNEGMC) THEN maxNEGMC = defMaxNegMagC         ; Current must be less than this, if it's going to make the cut
  
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
  
  ;;********************************************
  ;;satellite data options
  
  IF NOT KEYWORD_SET(satellite) THEN satellite = defSatellite          ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  IF NOT KEYWORD_SET(omni_Coords) THEN omni_Coords = defOmni_Coords    ; either "GSE" or "GSM"

  IF NOT KEYWORD_SET(delay) THEN delay = defDelay                      ;Delay between ACE propagated data and ChastonDB data
                                                                       ;Bin recommends something like 11min
  
  IF stableIMF EQ !NULL THEN stableIMF = defStableIMF                    ;Set to a time (in minutes) over which IMF stability is required
  IF NOT KEYWORD_SET(includeNoConsecData) THEN includeNoConsecData = defIncludeNoConsecData ;Setting this to 1 includes Chaston data for which  
                                                                       ;there's no way to calculate IMF stability
                                                                       ;Only valid for stableIMF GE 1
  IF NOT KEYWORD_SET(checkBothWays) THEN checkBothWays = defCheckBothWays       ;
  
  IF NOT KEYWORD_SET(Bx_over_ByBz_Lim) THEN Bx_over_ByBz_Lim = defBx_over_ByBz_Lim       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
    ;;Write plot data output for Bin?
  IF NOT KEYWORD_SET(dataDir) THEN dataDir = defDataDir

  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  
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
  
    ;;Which IMF clock angle are we doing?
  ;;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth', and 'all_IMF'
  IF NOT KEYWORD_SET(clockStr) THEN clockStr = defClockStr

  ;;How to set angles? Note, clock angle is measured with
  ;;Bz North at zero deg, ranging from -180<clock_angle<180
  ;;Setting angle limits 45 and 135, for example, gives a 90-deg
  ;;window for dawnward and duskward plots
  IF clockStr NE "all_IMF" THEN BEGIN
     angleLim1=defAngleLim1               ;in degrees
     angleLim2=defAngleLim2              ;in degrees
  ENDIF ELSE BEGIN 
     angleLim1=180.0              ;for doing all IMF
     angleLim2=180.0 
  ENDELSE

  ;; ;; Set minimum allowable number of events for a histo bin to be displayed
  ;; maskStr=''
  ;; IF NOT KEYWORD_SET(maskMin) THEN maskMin=1 $
  ;; ELSE BEGIN
  ;;    IF maskMin GT 1 THEN BEGIN
  ;;       maskStr='maskMin_' + STRCOMPRESS(maskMin,/REMOVE_ALL) + '_'
  ;;    ENDIF
  ;; ENDELSE
  
  ;;Requirement for IMF By magnitude?
  byMinStr=''
  IF KEYWORD_SET(byMin) THEN BEGIN
     byMinStr='byMin_' + String(byMin,format='(D0.1)') + '_' ;STRCOMPRESS(byMin,/REMOVE_ALL)
  ENDIF

  ;;Requirement for IMF Bz magnitude?
  bzMinStr=''
  IF KEYWORD_SET(bzMin) THEN BEGIN
     bzMinStr='bzMin_' + String(bzMin,format='(D0.1)') + '_' ;STRCOMPRESS(bzMin,/REMOVE_ALL)
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
  hoyDia= STRCOMPRESS(STRMID(SYSTIME(0), 4, 3),/REMOVE_ALL) + "_" + $
          STRCOMPRESS(STRMID(SYSTIME(0), 8,2),/REMOVE_ALL) + "_" + STRCOMPRESS(STRMID(SYSTIME(0), 22, 2),/REMOVE_ALL)

  IF NOT KEYWORD_SET(indSuffix) THEN indSuffix = "" ;; ELSE indSuffix = "--" + indSuffix
  IF NOT KEYWORD_SET(indPrefix) THEN indPrefix = "" ;; ELSE indPrefix = indPrefix + "--"

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
;;  paramStr=indPrefix+hemStr+'_'+clockStr+"--"+strtrim(stableIMF,2)+"stable--"+smoothStr+satellite+omniStr+"_"+delayStr+maskStr+byMinStr+indSuffix+hoyDia
  paramStr=indPrefix+hemStr+'_'+clockStr+"--"+strtrim(stableIMF,2)+"stable--"+smoothStr+satellite+omniStr+"_"+delayStr+byMinStr+bzMinStr+indSuffix+hoyDia

  ;;Now run these to clean and tap the databases and interpolate satellite data
  
  ind_region_magc_geabs10_ACEstart = get_chaston_ind(maximus,satellite,lun, $
                                                     CDBTIME=cdbTime,dbfile=dbfile,CHASTDB=do_chastdb, $
                                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange)
  phiChast = interp_mag_data(ind_region_magc_geabs10_ACEstart,satellite,delay,lun, $
                            cdbTime=cdbTime,CDBINTERP_I=cdbInterp_i,CDBACEPROPINTERP_I=cdbAcepropInterp_i,MAG_UTC=mag_utc, PHICLOCK=phiClock, $
                            DATADIR=dataDir,SMOOTHWINDOW=smoothWindow,BYMIN=byMin,BZMIN=bzMin,OMNI_COORDS=omni_Coords)
  phiImf_ii = check_imf_stability(clockStr,angleLim1,angleLim2,phiChast,cdbAcepropInterp_i,stableIMF,mag_utc,phiClock,$
                                 LUN=lun,bx_over_bybz=Bx_over_ByBz_Lim)
  
  plot_i=cdbInterp_i(phiImf_ii)

  IF KEYWORD_SET(poyntRange) THEN BEGIN
     IF N_ELEMENTS(poyntRange) NE 2 OR (poyntRange[1] LE poyntRange[0]) THEN BEGIN
        PRINT,"Invalid Poynting range specified! poyntRange should be a two-element vector, [minPoynt maxPoynt]"
        PRINT,"No Poynting range set..."
        RETURN
     ENDIF ELSE BEGIN
        plot_i=cgsetintersection(plot_i,where(pfluxEst GE poyntRange[0] AND pfluxEst LE poyntRange[1]))
     ENDELSE
  ENDIF

  ;;********************************************************
  ;;WHICH ORBITS ARE UNIQUE?
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)

  printf,lun,""
  printf,lun,"**********DATA SUMMARY**********"
  printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
  printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
  ;; printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
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
  printf,lun,"Percentage of current DB used: " + $
         strtrim((N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0,2) + "%"

  savFile=outDir+"PLOT_INDICES_"+paramStr+".sav"
  print,"Saving indices to " + savFile + "..."
  save,plot_i,paramStr, $
       angleLim1,angleLim2, $
       minMC,maxNEGMC, $
       minM,maxM,minI,maxI, $
       charERange,altitudeRange,poyntRange, $
       delay,stableIMF,smoothWindow,maskMin, $
       hemStr,clockStr,satellite,dbFile,filename=savFile

END