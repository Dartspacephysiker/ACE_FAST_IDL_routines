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
                         DATADIR=datadir,BYMIN=byMin, OMNI_COORDS=omni_Coords

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
  printf,lun,"There are", $
         n_elements(bigdiff_ii), $
         " current events where the gap between consecutive ACE data is GT", maxdiff, " min."
  printf,lun,"Those gaps are (in min)", $
         (mag_utc(cdbAceprop_i(bigdiff_ii(unique_iii))+1) -$
          mag_utc(cdbAceprop_i(bigdiff_ii(unique_iii))))/60
  PRINTF,LUN,"Of those events with large gaps, there are " + strtrim(n_elements(cdbAceprop_i)-n_elements(cdbAcepropInterp_i),2) + " events for which ACE magdata can't be interpolated based on the max difference of " + strtrim(maxdiff,2) +" min provided."
  printf,lun,STRTRIM(N_ELEMENTS(WHERE(cdbInterpTime[1:-2]-$
                                      (SHIFT(cdbInterpTime,1))[1:-2] LE 60)),2) + $
         " events are less than one minute apart."

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
     bx(cdbAcepropInterp_i)=smooth(bx(cdbAcepropInterp_i),smoothWindow)
     by(cdbAcepropInterp_i)=smooth(by(cdbAcepropInterp_i),smoothWindow)
     bz(cdbAcepropInterp_i)=smooth(bz(cdbAcepropInterp_i),smoothWindow)
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