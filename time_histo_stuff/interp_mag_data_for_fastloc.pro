;********************************************************
;This script does the actual interpolation of satellite mag data, and is a rip-off of interp_mag_data, the routine used for
;getting appropriate indices of events in the Alfvén wave database. Here, we are simply using it to find out how long FAST spent
;in a given MLT/ILAT bin under user-specified magnetic field conditions.
;It will be important to use a standardized method of naming the output files so that we're not generating them every single time.

;-->satdbInterp_i are indices corresponding to the NASA OMNI data set. 
;-->fastLocInterp_i are indices of data in the arrays of the
;-->fastLoc struct outputted by fastLoc* files that correspond to user-specified IMF conditions.

;FROM THE ORIGINAL INTERP_MAG_DATA_HEADER
;It uses an extremely simple linear interpolation between
;consecutive satellite data points to give an interpolated data
;point corresponding to an event in Chaston's database.
;cdbAcepropInterp are indices corresponding to ACE data.
;cdbInterp are indices corresponding to Chaston's FAC database.
;Of course they are not interchangeable, so make sure to 
;use the right ones.
; HISTORY 2015/04/08 Born
FUNCTION interp_mag_data_for_fastloc, satellite,DELAY=delay,LUN=lun, $
                                      FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCDIR=fastLocDir, $
                                      FASTLOC_TIMES=fastLoc_Times, FASTLOCINTERP_I=fastLocInterp_i,SATDBINTERP_I=SATdbInterp_i, $
                                      MAG_UTC=mag_utc, PHICLOCK=phiclock, SMOOTHWINDOW=smoothWindow, MAXDIFF=maxDiff, $
                                      SATDBDIR=satDBDir,BYMIN=byMin, BZMIN=bzMin, OMNI_COORDS=OMNI_Coords 

  ;def IMF params
  defSatellite = 'OMNI'
  defDelay = 660
  defLun = -1 ;stdout
  defByMin = 0
  defBzMin = 0
  defSmoothWindow = 5
  defMaxDiff=5.0 ; (in minutes)

  ;defaults
  defFastLocDir = '/SPENCEdata/Research/Cusp/database/time_histos/'
  defFastLocFile = 'fastLoc_intervals2--500-16361_all--20150613.sav'
  defFastLocTimeFile = 'fastLoc_intervals2--500-16361_all--20150613--times.sav'

  ;def SAT db stuff
  defSATdbDir = '/home/spencerh/Research/Cusp/database/processed/'
  ;; defSATdbFile = 'culled_OMNI_magdata.dat'
  defOMNI_Coords = 'GSM'

  ;def outputs
  defOutFilePrefix = 'fastLoc_intervals2--timeHisto--INDS_from_interp_mag_data_for_fastloc'
  ;; defOutFileSuffix = '--timeHisto'
  defOutFileSuffix = ''
  defOutDir = '/SPENCEdata/Research/Cusp/database/time_histos/'

  defMinMLT = 0.0
  defMaxMLT = 24.0
  defBinMLT = 0.75

  defMinILAT = 60
  defMaxILAT = 89.0
  defBinILAT = 3.0

  ;; defMinALT = 0.0
  ;; defMaxALT = 5000.0
  ;; defBinALT = 1000.0

  ;Handle all defaults
  IF N_ELEMENTS(satellite) EQ 0 THEN satellite = defSatellite
  IF N_ELEMENTS(delay) EQ 0 THEN delay = defDelay
  IF N_ELEMENTS(lun) EQ 0 THEN lun = defLun
  IF N_ELEMENTS(ByMin) EQ 0 THEN ByMin = defByMin
  IF N_ELEMENTS(BzMin) EQ 0 THEN BzMin = defBzMin
  IF N_ELEMENTS(maxDiff) EQ 0 THEN maxDiff = defMaxDiff

  ;files
  IF N_ELEMENTS(fastLocDir) EQ 0 THEN fastLocDir = defFastLocDir
  IF N_ELEMENTS(fastLocFile) EQ 0 THEN fastLocFile = defFastLocFile
  IF N_ELEMENTS(fastLocTimeFile) EQ 0 THEN fastLocTimeFile = defFastLocTimeFile
  IF N_ELEMENTS(outFilePrefix) EQ 0 THEN outFilePrefix = defOutFilePrefix
  IF N_ELEMENTS(outFileSuffix) EQ 0 THEN outFileSuffix = defOutFileSuffix
  IF N_ELEMENTS(outDir) EQ 0 THEN outDir = defOutDir

  ;MLT
  IF N_ELEMENTS(minMLT) EQ 0 THEN minMLT = defMinMLT
  IF N_ELEMENTS(maxMLT) EQ 0 THEN maxMLT = defMaxMLT
  IF N_ELEMENTS(binMLT) EQ 0 THEN binMLT = defBinMLT

  ;ILAT
  IF N_ELEMENTS(minILAT) EQ 0 THEN minILAT = defMinILAT
  IF N_ELEMENTS(maxILAT) EQ 0 THEN maxILAT = defMaxILAT
  IF N_ELEMENTS(binILAT) EQ 0 THEN binILAT = defBinILAT

  ;Don't do altitudes now
  ;; IF 
  ;; IF N_ELEMENTS(minALT) EQ 0 THEN minALT = defMinALT
  ;; IF N_ELEMENTS(maxALT) EQ 0 THEN maxALT = defMaxALT
  ;; IF N_ELEMENTS(binALT) EQ 0 THEN binALT = defBinALT

  IF N_ELEMENTS(satDBDir) EQ 0 THEN satDBDir = defSatDBDir




  ;open dem files
  RESTORE,fastLocDir+fastLocFile
  IF FILE_TEST(fastLocDir+fastLocTimeFile) THEN RESTORE, fastLocDir+fastLocTimeFile ELSE fastLoc_Times = str_to_time(fastLoc.time)

  ;set up outfilename
  ;It's gotta be standardized!
  baseFormat='(A0,I0,"-",I0,"-",G0.2,"_MLT--",I0,"-",I0,"-",G0.2,"_ILAT--orbs",I0,"-",I0,'
  formatStr=baseFormat

  ;; IF KEYWORD_SET(byMin) THEN BEGIN
  ;;    byMinStr = "By_min" + STRCOMPRESS(byMin,/remove_all) + "--" 
  ;;    formatStr += ',"--",'
  ;; ENDIF

  minOrb = MIN(fastLoc.orbit,MAX=maxOrb)
  formatStr += 'A0)' ;cap it off
  fNameSansExt = STRING(format=formatStr, $
                         outFilePrefix,minMLT,maxMLT,binMLT,minILAT,maxILAT,binILAT,minOrb,maxOrb,outFileSuffix)
  outFileName=fNameSansExt + ".sav"

  ;;********************************************************
  ;;Restore satellite data
  restore,satDBDir + "culled_"+satellite+"_magdata.dat"

  IF satellite EQ "OMNI" THEN BEGIN ;We've got to select GSE or GSM coords. Default to GSE.
     IF OMNI_Coords EQ "GSE" THEN BEGIN
        By        = By_GSE
        Bz        = Bz_GSE
        thetaCone = thetaCone_GSE
        phiClock  = phiClock_GSE
     ENDIF ELSE BEGIN
        IF OMNI_Coords EQ "GSM" THEN BEGIN
           By        = By_GSM
           Bz        = Bz_GSM
           thetaCone = thetaCone_GSM
           phiClock  = phiClock_GSM
        ENDIF ELSE BEGIN
           print,"Invalid coordinates chosen for OMNI data! Defaulting to GSM..."
           WAIT,1.0
           By = By_GSM
           Bz = Bz_GSM
        ENDELSE
     ENDELSE 
  ENDIF

  ;;***********************************************
  ;;Now, we call upon Craig Markwardt's elegant IDL practices 
  ;;to handle things from here. For fastLoc_Times[i], 
  ;;value_locate returns fastLocSatProp_i[i], which is the 
  ;;index number of mag_utc_delayed such that fastLoc_Times[i] 
  ;;lies between mag_utc_delayed[fastLocSatProp_i[i]] and 
  ;;mag_utc_delayed[fastLocSatProp_i[i+1]]

  fastLocSatProp_i=VALUE_LOCATE((mag_utc+delay),fastLoc_Times)

  mag_idiff=abs( mag_utc( fastLocSatProp_i )- fastLoc_Times)
  mag_iplusdiff=abs( mag_utc( fastLocSatProp_i )- fastLoc_Times)

  ;;trouble gives where i+1 is closer to fastLocdb time segment
  trouble=where(abs(mag_idiff) GT abs(mag_iplusdiff))


  ;;********************************************************
  ;;Check the gap between ACE data corresponding to fastLoc times

  bigdiff_ii=where((mag_utc(fastLocSatProp_i+1)-mag_utc(fastLocSatProp_i))/60 GT maxdiff,$
                   complement=SATdbInterp_ii)
  unique_iii=uniq(mag_utc(fastLocSatProp_i(bigdiff_ii)+1) - mag_utc(fastLocSatProp_i(bigdiff_ii)))
  ;;Just how big, these gaps?

  ;;********************************************************
  ;;Now check gap between current event and ACE data
  ;;If gap is less than maxdiff/2, mark it as worthy of interpolation

  IF bigdiff_ii[0] NE -1 THEN BEGIN 

     interp_worthy_iii=where(abs((mag_utc(fastLocSatProp_i(bigdiff_ii)+1)+delay-fastLoc_Times(bigdiff_ii)))/60 LT maxdiff/2.0 OR $
                             abs(mag_utc(fastLocSatProp_i(bigdiff_ii))+delay-fastLoc_Times(bigdiff_ii))/60 LT maxdiff/2.0, $
                             complement=interp_bad_iii) 

     ;;Combine indices of events that passed the first check with those passing worthiness test
     IF interp_worthy_iii[0] EQ -1 THEN BEGIN 
        SATdbInterp_i=fastLocSatProp_i(SATdbInterp_ii) 
        ;; fastLocInterp_i=ind_region_magc_geabs10_acestart(SATdbInterp_ii) 
        fastLocInterp_i=SATdbInterp_ii ;Why is this possible, you ask? Because SATdbInterp_ii was pulled
                                       ;from mag_utc(fastLocSatProp_i), and fastLocSatProp_i has exactly as many elements as fastLoc_Times
        fastLocInterpTime=fastLoc_Times(SATdbInterp_ii) 
     ENDIF ELSE BEGIN 
        SATdbInterp_i=[fastLocSatProp_i(SATdbInterp_ii),$
                            fastLocSatProp_i(bigdiff_ii(interp_worthy_iii))] 
        fastLocInterp_i=[SATdbInterp_ii,$
                     bigdiff_ii(interp_worthy_iii)] 
        fastLocInterpTime=[fastLoc_Times(SATdbInterp_ii),$
                       fastLoc_Times(bigdiff_ii(interp_worthy_iii))] 
        ;;SORT 'EM	
        ;;  s_SATdbInterp_i=SATdbInterp_i(SORT(SATdbInterp_i)) 
        ;;  s_fastLocInterp_i=fastLocInterp_i(SORT(fastLocInterp_i)) 
        ;;  s_fastLocInterpTime=fastLocInterpTime(SORT(fastLocInterpTime)) 
        sortme=SORT(fastLocInterp_i) 
        SATdbInterp_i=SATdbInterp_i(sortme) 
        fastLocInterp_i=fastLocInterp_i(sortme) 
        fastLocInterpTime=fastLocInterpTime(sortme) 
     ENDELSE 
  ENDIF ELSE BEGIN 
     SATdbInterp_i=fastLocSatProp_i(SATdbInterp_ii) 
     fastLocInterp_i=SATdbInterp_ii 
     fastLocInterpTime=fastLoc_Times(SATdbInterp_ii) 
  ENDELSE

  ;;********************************************************
  ;;Now we'd better make sure that we're not crazy.
  ;;It seems that one ACE data point can sometimes correspond to up to
  ;;100 or more Chastondb events, and I want to make sure it isn't spurious.
  ;;checkTimeFastLoc=fastLocInterpTime[1:-2]-(SHIFT(fastLocInterpTime,1))[1:-2]
  ;;print,N_ELEMENTS(WHERE(fastLocInterpTime[1:-2]-$
  ;;                      (SHIFT(fastLocInterpTime,1))[1:-2] LE 60))


  ;;********************************************************
  ;;Text output 
  ;;
  printf,lun,""
  printf,lun,"****From interp_mag_data_for_fastloc.pro****"

  ;; only print this if there are gaps in IMF data
  IF bigDiff_ii[0] NE -1 THEN BEGIN
     printf,lun,"There are", $
            n_elements(bigdiff_ii), $
            " current events where the gap between consecutive " + satellite + "data is GT", maxdiff, " min."
     printf,lun,"Those gaps are (in min)", $
            (mag_utc(fastLocSatProp_i(bigdiff_ii(unique_iii))+1) -$
             mag_utc(fastLocSatProp_i(bigdiff_ii(unique_iii))))/60
     PRINTF,LUN,"Of those events with large gaps, there are " + strtrim(n_elements(fastLocSatProp_i)-n_elements(SATdbInterp_i),2) + $
            " events for which ACE magdata can't be interpolated based on the max difference of " + strtrim(maxdiff,2) +" min provided."
     printf,lun,STRTRIM(N_ELEMENTS(WHERE(fastLocInterpTime[1:-2]-(SHIFT(fastLocInterpTime,1))[1:-2] LE 60)),2) + " events are less than one minute apart."
  ENDIF

  IF KEYWORD_SET(smoothWindow) THEN printf,lun,"Smooth window is set to " + strcompress(smoothWindow,/remove_all) + " minutes"

  ;;********************************************************
  ;;How about the distance between the ACE magdata times twice removed from a current event?
  ;;bigdiff_arr is the smallest distance between chastondbtime and mag_utc[either i or i+1]
  ;;If the number is negative, mag_utc[i] is closer  ;; if positive, mag_utc[i+1] is closer

  ;;bigdiff_arr=dindgen(n_elements(bigdiff_ii))
  ;;
  ;;bigdiff_arr=MIN(TRANSPOSE([[abs((mag_utc(fastLocSatProp_i(bigdiff_ii)+1)+delay-fastLoc_Times(bigdiff_ii)))], $
  ;;	[abs(mag_utc(fastLocSatProp_i(bigdiff_ii))+delay-fastLoc_Times(bigdiff_ii))]]),DIMENSION=1 )
  ;;bigdiff_byte=abs(mag_utc(fastLocSatProp_i(bigdiff_ii)+1)+delay-fastLoc_Times(bigdiff_ii)) LT abs(mag_utc(fastLocSatProp_i(bigdiff_ii))+delay-fastLoc_Times(bigdiff_ii))
  ;;
  ;;  ;;make the ones corresponding to mag_utc[i] negative
  ;;bigdiff_arr(where(bigdiff_byte EQ 0))=-bigdiff_arr(where(bigdiff_byte EQ 0))

  ;;********************************************************
  ;;HEADCHECK on fastLocSatProp_i and fastLoc_Times

  ;;printf,lun,mag_utc(fastLocSatProp_i(0))-fastLoc_Times(nlost)+delay
  ;;      -23.761000
  ;;printf,lun,mag_utc(fastLocSatProp_i(0)+1)-fastLoc_Times(nlost)+delay
  ;;       36.239000

  ;;GOOD--it should be less than 60 seconds off between each

  ;;********************************************************
  ;;Let's see what ACE data looks like
  ;;cgScatter2D,mag_utc(1:3600*24),bz(1:3600*24)

  ;;********************************************************
  ;;FINAL CHECK--Do we have enough magdata before and/or after to interpolate?

  ;;interp_t_r=mag_utc((SATdbInterp_i)+1)-mag_utc(SATdbInterp_i)
  ;;interp_t_l=mag_utc(SATdbInterp_i)-mag_utc((SATdbInterp_i)-1)
  ;;interp_scare=cgSetIntersection(where(interp_t_r GT 60),where(interp_t_l GT 60))

  ;;*********************************************************
  ;;If we're also going to smooth IMF data, it might as well happen here
  IF KEYWORD_SET(smoothWindow) THEN BEGIN

     IF smoothWindow EQ 1 THEN smoothWindow = 5 ;default to five-minute smoothing

     halfWind=floor(smoothWindow/2)

     ;; goodSmooth_ii = where(((shift(mag_utc,-halfWind))(SATdbInterp_i)-(shift(mag_utc,halfWind))(SATdbInterp_i))/60 EQ halfWind*2, nGoodSmooth)
     ;; IF nGoodSmooth EQ N_ELEMENTS(SATdbInterp_i) THEN BEGIN
     ;;    print,"All data can be smoothed, thank goodness"
     ;; ENDIF ELSE BEGIN
     ;;    print,"Not all data can be smoothed!"
     ;;    print,"Losing "+strcompress(N_ELEMENTS(SATdbInterp_i)-nGoodSmooth,/remove_all)+" events corresponding to IMF data that can't be smoothed..."
     ;;    wait,0.5
     ;;    SATdbInterp_i=SATdbInterp_i(goodSmooth_ii)
     ;;    fastLocInterp_i=fastLocInterp_i(goodSmooth_ii)
     ;;    fastLocInterpTime=fastLocInterpTime(goodSmooth_ii)
     ;; ENDELSE
     ;; bx(SATdbInterp_i)=smooth(bx(SATdbInterp_i),smoothWindow)
     ;; by(SATdbInterp_i)=smooth(by(SATdbInterp_i),smoothWindow)
     ;; bz(SATdbInterp_i)=smooth(bz(SATdbInterp_i),smoothWindow)

     ;; a different approach
     smoothRange=[SATdbInterp_i[0]:SATdbInterp_i[-1]]
     magUTCTEMP=mag_utc(smoothRange[0]-halfWind:smoothRange[-1]+halfWind);ALL times for which we have mag data between first and last FAC event 
     goodSmooth_k = where(((shift(magUTCTEMP,-halfWind))-(shift(magUTCTEMP,halfWind)))/60 EQ halfWind*2, $
                           nGoodSmooth,COMPLEMENT=badSmooth_k,NCOMPLEMENT=nBadSmooth) ;use k for index to distinguish it from data indices

     ;we know the ends won't work, so junk 'em
     goodSmooth_k = goodSmooth_k - halfWind
     magUTCTEMP = magUTCTEMP[halfWind:-halfWind-1]
     IF N_ELEMENTS(badSmooth_k) GT halfWind*2 THEN BEGIN
        badSmooth_k = badSmooth_k[halfWind:-halfWind-1] 
        nBadSmooth -= halfWind*2

        ;; find out if any of our events correspond to unsmoothable data
        MATCH, magUTCTEMP(badSmooth_k), mag_utc(SATdbInterp_i), magUTCTEMP_bad_i, mag_utcfastLocSatProp_bad_i,COUNT=nMatches,EPSILON=1.0

        ;; magUTCTEMP_bad_i and mag_utcfastLocSatProp_bad_i are ordered such that 
        ;; (magUTCTEMP(badSmooth_k))(magUTCTEMP_bad_i) equals (mag_utc(SATdbInterp_i))(mag_utcfastLocSatProp_bad_i)

        IF nMatches NE 0 THEN BEGIN ;get rid of unsmoothable data points
           ;say what?
        ENDIF

        PRINT,"Some elements of IMF data can't be smoothed, and you haven't written code to handle this situation!"
        PRINT,"Better pay a visit to interp_mag_data.pro..."
        wait,1.0
     ENDIF ELSE BEGIN
        badSmooth_k = -1
        nBadSmooth = 0
     ENDELSE

     ;; NOW you can smooth them
     bx(smoothRange)=smooth(bx(smoothRange),smoothWindow)
     by(smoothRange)=smooth(by(smoothRange),smoothWindow)
     bz(smoothRange)=smooth(bz(smoothRange),smoothWindow)

  ENDIF

  ;;********************************************************
  ;;Should we interpolate those guys?
  ;;Dah yeah

  bz_slope=(bz(SATdbInterp_i+1)-bz(SATdbInterp_i))/(mag_utc(SATdbInterp_i+1)-mag_utc(SATdbInterp_i))
  by_slope=(by(SATdbInterp_i+1)-by(SATdbInterp_i))/(mag_utc(SATdbInterp_i+1)-mag_utc(SATdbInterp_i))
  bx_slope=(bx(SATdbInterp_i+1)-bx(SATdbInterp_i))/(mag_utc(SATdbInterp_i+1)-mag_utc(SATdbInterp_i))


  ;;plot,fastLocInterpTime,bzFastLoc,psym=3,symsize=0.5
  bzFastLoc=bz(SATdbInterp_i)+bz_slope*(fastLocInterpTime-mag_utc(SATdbInterp_i)-delay)
  byFastLoc=by(SATdbInterp_i)+by_slope*(fastLocInterpTime-mag_utc(SATdbInterp_i)-delay)
  bxFastLoc=bx(SATdbInterp_i)+bx_slope*(fastLocInterpTime-mag_utc(SATdbInterp_i)-delay)


  ;*********************************************************
  ;Any requirement for by magnitude?
  IF N_ELEMENTS(byMin NE 0) AND byMin NE 0 THEN BEGIN 
     ;;As they are after interpolation
     ;; SATdbInterp_i=fastLocSatProp_i(SATdbInterp_ii) 
     ;; fastLocInterp_i=SATdbInterp_ii 
     ;; fastLocInterpTime=fastLoc_Times(SATdbInterp_ii) 
    
     ;; byMin_ii are the indices (of indices) of events that meet the minimum By requirement
     byMin_ii=WHERE(byFastLoc LE -ABS(byMin) OR byFastLoc GE ABS(byMin),NCOMPLEMENT=byminLost)
     
     bzFastLoc=bzFastLoc(byMin_ii)
     byFastLoc=byFastLoc(byMin_ii)
     bxFastLoc=bxFastLoc(byMin_ii)
     
     SATdbInterp_i=SATdbInterp_i(byMin_ii)
     fastLocInterp_i=fastLocInterp_i(byMin_ii)
     fastLocInterpTime=fastLocInterpTime(byMin_ii)

     printf,lun,""
     printf,lun,"ByMin magnitude requirement: " + strcompress(byMin,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(byMinLost,/REMOVE_ALL) + " time segments because of minimum By requirement."
     printf,lun,""

  ENDIF

  ;*********************************************************
  ;Any requirement for bz magnitude?
  IF N_ELEMENTS(bzMin NE 0) AND bzMin NE 0 THEN BEGIN 
     ;;As they are after interpolation
     ;; SATdbInterp_i=fastLocSatProp_i(SATdbInterp_ii) 
     ;; fastLocInterp_i=SATdbInterp_ii 
     ;; fastLocInterpTime=fastLoc_Times(SATdbInterp_ii) 
    
     ;; bzMin_ii are the indices (of indices) of events that meet the minimum Bz requirement
     bzMin_ii=WHERE(bzFastLoc LE -ABS(bzMin) OR bzFastLoc GE ABS(bzMin),NCOMPLEMENT=bzminLost)
     
     bzFastLoc=bzFastLoc(bzMin_ii)
     byFastLoc=byFastLoc(bzMin_ii)
     bxFastLoc=bxFastLoc(bzMin_ii)
     
     SATdbInterp_i=SATdbInterp_i(bzMin_ii)
     fastLocInterp_i=fastLocInterp_i(bzMin_ii)
     fastLocInterpTime=fastLocInterpTime(bzMin_ii)

     printf,lun,""
     printf,lun,"BzMin magnitude requirement: " + strcompress(bzMin,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(bzMinLost,/REMOVE_ALL) + " time segments because of minimum Bz requirement."
     printf,lun,""

  ENDIF



  printf,lun,"****END text from interp_mag_data_for_fastloc.pro****"
  printf,lun,""


  phiFastLoc=ATAN(byFastLoc,bzFastLoc)
  thetaFastLoc=ACOS(abs(bxFastLoc)/SQRT(bxFastLoc*bxFastLoc+byFastLoc*byFastLoc+bzFastLoc*bzFastLoc))
  bxy_over_bzFastLoc=sqrt(bxFastLoc*bxFastLoc+byFastLoc*byFastLoc)/abs(bzFastLoc)
  cone_overClockFastLoc=thetaFastLoc/phiFastLoc

  phiFastLoc=phiFastLoc*180/!PI

  thetaCone=thetaCone*180/!PI
  phiClock=phiClock*180/!PI

  ;; undefine,SATdbInterp_ii,unique_iii,bigdiff_ii,sortme

  RETURN, phiFastLoc

END