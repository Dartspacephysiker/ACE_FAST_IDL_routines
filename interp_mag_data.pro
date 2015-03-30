;********************************************************
;This script does the actual interpolation of ACE mag data.
;It uses an extremely simple linear interpolation between
;consecutive ACE data points to give an interpolated data
;point corresponding to an event in Chaston's database.
;cdbAcepropInterp are indices corresponding to ACE data.
;cdbInterp are indices corresponding to Chaston's FAC database.
;Of course they are not interchangeable, so make sure to 
;use the right ones.

FUNCTION interp_mag_data,ind_region_magc_geabs10_ACEstart, satellite, delay, lun, $
                         CDBTIME=cdbTime, CDBINTERP_I=cdbInterp_i,CDBACEPROPINTERP_I=cdbacepropinterp_i, $
                         MAG_UTC=mag_utc, PHICLOCK=phiclock, SMOOTHWINDOW=smoothWindow, $
                         DATADIR=datadir,BYMIN=byMin, OMNI_COORDS=omni_Coords;, $
;;                         CLEANED_DB=cleaned_DB

  ;;If using cleaned DB, use all indices!
;;  IF KEYWORD_SET(cleaned_DB) THEN ind_region_magc_geabs10_ACEstart=lindgen(n_elements(cleaned_DB.time))

  IF NOT KEYWORD_SET(dataDir) THEN dataDir="/SPENCEdata/Research/Cusp/database/"

  ;;********************************************************
  ;;Restore ACE data, if need be
  IF mag_utc EQ !NULL THEN restore,dataDir + "/processed/culled_"+satellite+"_magdata.dat"

  IF satellite EQ "OMNI" THEN BEGIN ;We've got to select GSE or GSM coords. Default to GSE.
     IF OMNI_COORDS EQ "GSE" THEN BEGIN
        By        = By_GSE
        Bz        = Bz_GSE
        thetaCone = thetaCone_GSE
        phiClock  = phiClock_GSE
     ENDIF ELSE BEGIN
        IF OMNI_COORDS EQ "GSM" THEN BEGIN
           By        = By_GSM
           Bz        = Bz_GSM
           thetaCone = thetaCone_GSM
           phiClock  = phiClock_GSM
        ENDIF ELSE BEGIN
           print,"Invalid coordinates chosen for OMNI data! Defaulting to GSE..."
           WAIT,1.0
           By = By_GSE
           Bz = Bz_GSE
        ENDELSE
     ENDELSE 
  ENDIF

  ;;***********************************************
  ;;Now, we call upon Craig Markwardt's elegant IDL practices 
  ;;to handle things from here. For cdbTime[i], 
  ;;value_locate returns cdbAceprop_i[i], which is the 
  ;;index number of mag_utc_delayed such that cdbTime[i] 
  ;;lies between mag_utc_delayed[cdbAceprop_i[i]] and 
  ;;mag_utc_delayed[cdbAceprop_i[i+1]]

  cdbAceprop_i=VALUE_LOCATE((mag_utc+delay),cdbTime)

  mag_idiff=abs( mag_utc( cdbAceprop_i )- cdbTime)
  mag_iplusdiff=abs( mag_utc( cdbAceprop_i )- cdbTime)

  ;;trouble gives where i+1 is closer to chastondb current event
  trouble=where(abs(mag_idiff) GT abs(mag_iplusdiff))


  ;;********************************************************
  ;;Check the gap between ACE data corresponding to Chaston times

  maxdiff=5.0                   ; (in minutes)

  bigdiff_ii=where((mag_utc(cdbAceprop_i+1)-mag_utc(cdbAceprop_i))/60 GT maxdiff,$
                   complement=cdbAcepropInterp_ii)
  unique_iii=uniq(mag_utc(cdbAceprop_i(bigdiff_ii)+1) - mag_utc(cdbAceprop_i(bigdiff_ii)))
  ;;Just how big, these gaps?

  ;;********************************************************
  ;;Now check gap between current event and ACE data
  ;;If gap is less than maxdiff/2, mark it as worthy of interpolation

  IF bigdiff_ii[0] NE -1 THEN BEGIN 

     interp_worthy_iii=where(abs((mag_utc(cdbAceprop_i(bigdiff_ii)+1)+delay-cdbTime(bigdiff_ii)))/60 LT maxdiff/2.0 OR $
                             abs(mag_utc(cdbAceprop_i(bigdiff_ii))+delay-cdbTime(bigdiff_ii))/60 LT maxdiff/2.0, $
                             complement=interp_bad_iii) 

     ;;Combine indices of events that passed the first check with those passing worthiness test
     IF interp_worthy_iii[0] EQ -1 THEN BEGIN 
        cdbAcepropInterp_i=cdbAceprop_i(cdbAcepropInterp_ii) 
        cdbInterp_i=ind_region_magc_geabs10_acestart(cdbAcepropInterp_ii) 
        cdbInterpTime=cdbTime(cdbAcepropInterp_ii) 
     ENDIF ELSE BEGIN 
        cdbAcepropInterp_i=[cdbAceprop_i(cdbAcepropInterp_ii),$
                            cdbAceprop_i(bigdiff_ii(interp_worthy_iii))] 
        cdbInterp_i=[ind_region_magc_geabs10_acestart(cdbAcepropInterp_ii),$
                     ind_region_magc_geabs10_acestart(bigdiff_ii(interp_worthy_iii))] 
        cdbInterpTime=[cdbTime(cdbAcepropInterp_ii),$
                       cdbTime(bigdiff_ii(interp_worthy_iii))] 
        ;;SORT 'EM	
        ;;  s_cdbAcepropInterp_i=cdbAcepropInterp_i(SORT(cdbAcepropInterp_i)) 
        ;;  s_cdbInterp_i=cdbInterp_i(SORT(cdbInterp_i)) 
        ;;  s_cdbInterpTime=cdbInterpTime(SORT(cdbInterpTime)) 
        sortme=SORT(cdbInterp_i) 
        cdbAcepropInterp_i=cdbAcepropInterp_i(sortme) 
        cdbInterp_i=cdbInterp_i(sortme) 
        cdbInterpTime=cdbInterpTime(sortme) 
     ENDELSE 
  ENDIF ELSE BEGIN 
     cdbAcepropInterp_i=cdbAceprop_i(cdbAcepropInterp_ii) 
     cdbInterp_i=ind_region_magc_geabs10_acestart(cdbAcepropInterp_ii) 
     cdbInterpTime=cdbTime(cdbAcepropInterp_ii) 
  ENDELSE

  ;;********************************************************
  ;;Now we'd better make sure that we're not crazy.
  ;;It seems that one ACE data point can sometimes correspond to up to
  ;;100 or more Chastondb events, and I want to make sure it isn't spurious.
  ;;checkTimeChast=cdbInterpTime[1:-2]-(SHIFT(cdbInterpTime,1))[1:-2]
  ;;print,N_ELEMENTS(WHERE(cdbInterpTime[1:-2]-$
  ;;                      (SHIFT(cdbInterpTime,1))[1:-2] LE 60))


  ;;********************************************************
  ;;Text output 
  ;;
  printf,lun,""
  printf,lun,"****From interp_mag_data.pro****"

  ;; only print this if there are gaps in IMF data
  IF bigDiff_ii[0] NE -1 THEN BEGIN
     printf,lun,"There are", $
            n_elements(bigdiff_ii), $
            " current events where the gap between consecutive ACE data is GT", maxdiff, " min."
     printf,lun,"Those gaps are (in min)", $
            (mag_utc(cdbAceprop_i(bigdiff_ii(unique_iii))+1) -$
             mag_utc(cdbAceprop_i(bigdiff_ii(unique_iii))))/60
     PRINTF,LUN,"Of those events with large gaps, there are " + strtrim(n_elements(cdbAceprop_i)-n_elements(cdbAcepropInterp_i),2) + $
            " events for which ACE magdata can't be interpolated based on the max difference of " + strtrim(maxdiff,2) +" min provided."
     printf,lun,STRTRIM(N_ELEMENTS(WHERE(cdbInterpTime[1:-2]-(SHIFT(cdbInterpTime,1))[1:-2] LE 60)),2) + " events are less than one minute apart."
  ENDIF

  IF KEYWORD_SET(smoothWindow) THEN printf,lun,"Smooth window is set to " + strcompress(smoothWindow,/remove_all) + " minutes"

  ;;********************************************************
  ;;How about the distance between the ACE magdata times twice removed from a current event?
  ;;bigdiff_arr is the smallest distance between chastondbtime and mag_utc[either i or i+1]
  ;;If the number is negative, mag_utc[i] is closer  ;; if positive, mag_utc[i+1] is closer

  ;;bigdiff_arr=dindgen(n_elements(bigdiff_ii))
  ;;
  ;;bigdiff_arr=MIN(TRANSPOSE([[abs((mag_utc(cdbAceprop_i(bigdiff_ii)+1)+delay-cdbTime(bigdiff_ii)))], $
  ;;	[abs(mag_utc(cdbAceprop_i(bigdiff_ii))+delay-cdbTime(bigdiff_ii))]]),DIMENSION=1 )
  ;;bigdiff_byte=abs(mag_utc(cdbAceprop_i(bigdiff_ii)+1)+delay-cdbTime(bigdiff_ii)) LT abs(mag_utc(cdbAceprop_i(bigdiff_ii))+delay-cdbTime(bigdiff_ii))
  ;;
  ;;  ;;make the ones corresponding to mag_utc[i] negative
  ;;bigdiff_arr(where(bigdiff_byte EQ 0))=-bigdiff_arr(where(bigdiff_byte EQ 0))

  ;;********************************************************
  ;;HEADCHECK on cdbAceprop_i and cdbTime

  ;;printf,lun,mag_utc(cdbAceprop_i(0))-cdbTime(nlost)+delay
  ;;      -23.761000
  ;;printf,lun,mag_utc(cdbAceprop_i(0)+1)-cdbTime(nlost)+delay
  ;;       36.239000

  ;;GOOD--it should be less than 60 seconds off between each

  ;;********************************************************
  ;;Let's see what ACE data looks like
  ;;cgScatter2D,mag_utc(1:3600*24),bz(1:3600*24)

  ;;********************************************************
  ;;FINAL CHECK--Do we have enough magdata before and/or after to interpolate?

  ;;interp_t_r=mag_utc((cdbAcepropInterp_i)+1)-mag_utc(cdbAcepropInterp_i)
  ;;interp_t_l=mag_utc(cdbAcepropInterp_i)-mag_utc((cdbAcepropInterp_i)-1)
  ;;interp_scare=cgSetIntersection(where(interp_t_r GT 60),where(interp_t_l GT 60))

  ;;*********************************************************
  ;;If we're also going to smooth IMF data, it might as well happen here
  IF KEYWORD_SET(smoothWindow) THEN BEGIN

     IF smoothWindow EQ 1 THEN smoothWindow = 5 ;default to five-minute smoothing

     halfWind=floor(smoothWindow/2)

     ;; goodSmooth_ii = where(((shift(mag_utc,-halfWind))(cdbAcepropInterp_i)-(shift(mag_utc,halfWind))(cdbAcepropInterp_i))/60 EQ halfWind*2, nGoodSmooth)
     ;; IF nGoodSmooth EQ N_ELEMENTS(cdbAcepropInterp_i) THEN BEGIN
     ;;    print,"All data can be smoothed, thank goodness"
     ;; ENDIF ELSE BEGIN
     ;;    print,"Not all data can be smoothed!"
     ;;    print,"Losing "+strcompress(N_ELEMENTS(cdbAcepropInterp_i)-nGoodSmooth,/remove_all)+" events corresponding to IMF data that can't be smoothed..."
     ;;    wait,0.5
     ;;    cdbAcepropInterp_i=cdbAcepropInterp_i(goodSmooth_ii)
     ;;    cdbInterp_i=cdbInterp_i(goodSmooth_ii)
     ;;    cdbInterpTime=cdbInterpTime(goodSmooth_ii)
     ;; ENDELSE
     ;; bx(cdbAcepropInterp_i)=smooth(bx(cdbAcepropInterp_i),smoothWindow)
     ;; by(cdbAcepropInterp_i)=smooth(by(cdbAcepropInterp_i),smoothWindow)
     ;; bz(cdbAcepropInterp_i)=smooth(bz(cdbAcepropInterp_i),smoothWindow)

     ;; a different approach
     smoothRange=[cdbAcepropinterp_i[0]:cdbAcepropinterp_i[-1]]
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
        MATCH, magUTCTEMP(badSmooth_k), mag_utc(cdbAcepropInterp_i), magUTCTEMP_bad_i, mag_utccdbAceprop_bad_i,COUNT=nMatches,EPSILON=1.0

        ;; magUTCTEMP_bad_i and mag_utccdbAceprop_bad_i are ordered such that 
        ;; (magUTCTEMP(badSmooth_k))(magUTCTEMP_bad_i) equals (mag_utc(cdbAcepropInterp_i))(mag_utccdbAceprop_bad_i)

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

  bz_slope=(bz(cdbAcepropInterp_i+1)-bz(cdbAcepropInterp_i))/(mag_utc(cdbAcepropInterp_i+1)-mag_utc(cdbAcepropInterp_i))
  by_slope=(by(cdbAcepropInterp_i+1)-by(cdbAcepropInterp_i))/(mag_utc(cdbAcepropInterp_i+1)-mag_utc(cdbAcepropInterp_i))
  bx_slope=(bx(cdbAcepropInterp_i+1)-bx(cdbAcepropInterp_i))/(mag_utc(cdbAcepropInterp_i+1)-mag_utc(cdbAcepropInterp_i))


  ;;plot,cdbInterpTime,bzChast,psym=3,symsize=0.5
  bzChast=bz(cdbAcepropInterp_i)+bz_slope*(cdbInterpTime-mag_utc(cdbAcepropInterp_i)-delay)
  byChast=by(cdbAcepropInterp_i)+by_slope*(cdbInterpTime-mag_utc(cdbAcepropInterp_i)-delay)
  bxChast=bx(cdbAcepropInterp_i)+bx_slope*(cdbInterpTime-mag_utc(cdbAcepropInterp_i)-delay)


  ;*********************************************************
  ;Any requirement for by magnitude?
  IF KEYWORD_SET(byMin) THEN BEGIN 
     ;;As they are after interpolation
     ;; cdbAcepropInterp_i=cdbAceprop_i(cdbAcepropInterp_ii) 
     ;; cdbInterp_i=ind_region_magc_geabs10_acestart(cdbAcepropInterp_ii) 
     ;; cdbInterpTime=cdbTime(cdbAcepropInterp_ii) 
    
     ;; byMin_ii are the indices (of indices) of events that meet the minimum By requirement
     byMin_ii=WHERE(byChast LE -ABS(byMin) OR byChast GE ABS(byMin),NCOMPLEMENT=byminLost)
     
     bzChast=bzChast(byMin_ii)
     byChast=byChast(byMin_ii)
     bxChast=bxChast(byMin_ii)
     
     cdbAcepropInterp_i=cdbAcepropInterp_i(byMin_ii)
     cdbInterp_i=cdbInterp_i(byMin_ii)
     cdbInterpTime=cdbInterpTime(byMin_ii)

     printf,lun,""
     printf,lun,"ByMin magnitude requirement: " + strcompress(byMin,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(byMinLost,/REMOVE_ALL) + " events because of minimum By requirement."
     printf,lun,""

  ENDIF

  printf,lun,"****END text from interp_mag_data.pro****"
  printf,lun,""


  phiChast=ATAN(byChast,bzChast)
  thetaChast=ACOS(abs(bxChast)/SQRT(bxChast*bxChast+byChast*byChast+bzChast*bzChast))
  bxy_over_bzChast=sqrt(bxChast*bxChast+byChast*byChast)/abs(bzChast)
  cone_overClockChast=thetaChast/phiChast

  phiChast=phiChast*180/!PI

  thetaCone=thetaCone*180/!PI
  phiClock=phiClock*180/!PI

  ;; undefine,cdbAcepropInterp_ii,unique_iii,bigdiff_ii,sortme

  RETURN, phiChast

END