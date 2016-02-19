;********************************************************
;This script does the actual interpolation of ACE mag data.
;It uses an extremely simple linear interpolation between
;consecutive ACE data points to give an interpolated data
;point corresponding to an event in Chaston's database.
;
; *fastDBSatProppedInterped are indices corresponding to satellite data.
; *fastDBInterp are indices corresponding to the Alfven wave DB or the FAST ephemeris DB.
;
;Of course they are not interchangeable, so make sure to 
;use the right ones.
;
;2016/01/23 Added ABS_BZM{IN,MAX} keywords

FUNCTION INTERP_MAG_DATA,db_i, satellite, delay, lun, $
                         DBTIMES=dbTimes, FASTDBINTERP_I=fastDBInterp_i,FASTDBSATPROPPEDINTERPED_I=fastDBSatProppedInterped_i, $
                         MAG_UTC=mag_utc, PHICLOCK=phiclock, SMOOTHWINDOW=smoothWindow, $
                         DATADIR=datadir, $
                         BYMIN=byMin, $
                         BZMIN=bzMin, $
                         BYMAX=byMax, $
                         BZMAX=bzMax, $
                         DO_ABS_BYMIN=abs_byMin, $
                         DO_ABS_BYMAX=abs_byMax, $
                         DO_ABS_BZMIN=abs_bzMin, $
                         DO_ABS_BZMAX=abs_bzMax, $
                         OMNI_COORDS=omni_Coords ;, $

  COMPILE_OPT idl2


  ;;If using cleaned DB, use all indices!
  ;;  IF KEYWORD_SET(cleaned_DB) THEN db_i=lindgen(n_elements(cleaned_DB.time))

  IF NOT KEYWORD_SET(dataDir) THEN dataDir="/SPENCEdata/Research/Cusp/database/"

  ;;********************************************************
  ;;Restore ACE/OMNI data, if need be
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
  ;;to handle things from here. For dbTimes[db_i[[i]], 
  ;;value_locate returns fastDBAceprop_i[i], which is the 
  ;;index number of mag_utc_delayed such that dbTimes[db_i[[i]] 
  ;;lies between mag_utc_delayed[fastDBAceprop_i[i]] and 
  ;;mag_utc_delayed[fastDBAceprop_i[i+1]]

  fastDBAceprop_i    = VALUE_LOCATE((mag_utc+delay),dbTimes[db_i])

  mag_idiff          = abs( mag_utc[ fastDBAceprop_i ]- dbTimes[db_i])
  mag_iplusdiff      = abs( mag_utc[ fastDBAceprop_i ]- dbTimes[db_i])

  ;;trouble gives where i+1 is closer to chastondb current event
  trouble            = WHERE(ABS(mag_idiff) GT ABS(mag_iplusdiff))


  ;;********************************************************
  ;;Check the gap between ACE/OMNI data corresponding to Chaston times

  maxdiff=5.0                   ; (in minutes)

  bigdiff_ii=WHERE((mag_utc[fastDBAceprop_i+1]-mag_utc[fastDBAceprop_i])/60 GT maxdiff,$
                   complement=fastDBSatProppedInterped_ii)
  unique_iii=UNIQ(mag_utc[fastDBAceprop_i[bigdiff_ii]+1] - mag_utc[fastDBAceprop_i[bigdiff_ii]])
  ;;Just how big, these gaps?

  ;;********************************************************
  ;;Now check gap between current event and ACE/OMNI data
  ;;If gap is less than maxdiff/2, mark it as worthy of interpolation

  IF bigdiff_ii[0] NE -1 THEN BEGIN 

     interp_worthy_iii=where(abs((mag_utc[fastDBAceprop_i[bigdiff_ii]+1]+delay-dbTimes[db_i[bigdiff_ii]]))/60 LT maxdiff/2.0 OR $
                             abs(mag_utc[fastDBAceprop_i[bigdiff_ii]]+delay-dbTimes[db_i[bigdiff_ii]])/60 LT maxdiff/2.0, $
                             complement=interp_bad_iii) 

     ;;Combine indices of events that passed the first check with those passing worthiness test
     IF interp_worthy_iii[0] EQ -1 THEN BEGIN 
        fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_ii] 
        fastDBInterp_i=db_i[fastDBSatProppedInterped_ii] 
        fastDBInterpTime=dbTimes[db_i[[fastDBSatProppedInterped_ii]]]
     ENDIF ELSE BEGIN 
        fastDBSatProppedInterped_i=[fastDBAceprop_i[fastDBSatProppedInterped_ii],$
                            fastDBAceprop_i[bigdiff_ii[interp_worthy_iii]]] 
        fastDBInterp_i=[db_i[fastDBSatProppedInterped_ii],$
                     db_i[bigdiff_ii[interp_worthy_iii]]] 
        fastDBInterpTime=[dbTimes[db_i[[fastDBSatProppedInterped_ii]]],$
                       dbTimes[db_i[bigdiff_ii[interp_worthy_iii]]]]
        ;;SORT 'EM	
        ;;  s_fastDBSatProppedInterped_i=fastDBSatProppedInterped_i(SORT(fastDBSatProppedInterped_i)) 
        ;;  s_fastDBInterp_i=fastDBInterp_i(SORT(fastDBInterp_i)) 
        ;;  s_fastDBInterpTime=fastDBInterpTime(SORT(fastDBInterpTime)) 
        sortme=SORT(fastDBInterp_i) 
        fastDBSatProppedInterped_i=fastDBSatProppedInterped_i[sortme]
        fastDBInterp_i=fastDBInterp_i[sortme]
        fastDBInterpTime=fastDBInterpTime[sortme]
     ENDELSE 
  ENDIF ELSE BEGIN 
     fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_ii] 
     fastDBInterp_i=db_i[fastDBSatProppedInterped_ii] 
     fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_ii]]
  ENDELSE

  ;;********************************************************
  ;;Now we'd better make sure that we're not crazy.
  ;;It seems that one ACE/OMNI data point can sometimes correspond to up to
  ;;100 or more Chastondb events, and I want to make sure it isn't spurious.
  ;;checkTimeChast=fastDBInterpTime[1:-2]-(SHIFT(fastDBInterpTime,1))[1:-2]
  ;;print,N_ELEMENTS(WHERE(fastDBInterpTime[1:-2]-$
  ;;                      (SHIFT(fastDBInterpTime,1))[1:-2] LE 60))


  ;;********************************************************
  ;;Text output 
  ;;
  printf,lun,""
  printf,lun,"****From interp_mag_data.pro****"

  ;; only print this if there are gaps in IMF data
  IF bigDiff_ii[0] NE -1 THEN BEGIN
     printf,lun,"There are", $
            n_elements(bigdiff_ii), $
            " current events where the gap between consecutive ACE/OMNI data is GT", maxdiff, " min."
     printf,lun,"Those gaps are (in min)", $
            (mag_utc[fastDBAceprop_i[bigdiff_ii[unique_iii]]+1] -$
             mag_utc[fastDBAceprop_i[bigdiff_ii[unique_iii]]])/60
     PRINTF,LUN,"Of those events with large gaps, there are " + strtrim(n_elements(fastDBAceprop_i)-n_elements(fastDBSatProppedInterped_i),2) + $
            " events for which ACE/OMNI magdata can't be interpolated based on the max difference of " + strtrim(maxdiff,2) +" min provided."
     printf,lun,STRTRIM(N_ELEMENTS(WHERE(fastDBInterpTime[1:-2]-(SHIFT(fastDBInterpTime,1))[1:-2] LE 60)),2) + " events are less than one minute apart."
  ENDIF

  IF KEYWORD_SET(smoothWindow) THEN printf,lun,"Smooth window is set to " + strcompress(smoothWindow,/remove_all) + " minutes"

  ;;********************************************************
  ;;How about the distance between the ACE/OMNI magdata times twice removed from a current event?
  ;;bigdiff_arr is the smallest distance between chastondbtime and mag_utc[either i or i+1]
  ;;If the number is negative, mag_utc[i] is closer  ;; if positive, mag_utc[i+1] is closer

  ;;bigdiff_arr=dindgen(n_elements(bigdiff_ii))
  ;;
  ;;bigdiff_arr=MIN(TRANSPOSE([[abs((mag_utc[fastDBAceprop_i[bigdiff_ii]+1]+delay-dbTimes[db_i[bigdiff_ii]]))], $
  ;;	[abs(mag_utc[fastDBAceprop_i[bigdiff_ii]]+delay-dbTimes[db_i[bigdiff_ii]])]]),DIMENSION=1 )
  ;;bigdiff_byte=abs(mag_utc[fastDBAceprop_i[bigdiff_ii]+1]+delay-dbTimes[db_i[bigdiff_ii]]) LT abs(mag_utc[fastDBAceprop_i[bigdiff_ii]]+delay-dbTimes[db_i[bigdiff_ii]])
  ;;
  ;;  ;;make the ones corresponding to mag_utc[i] negative
  ;;bigdiff_arr(where(bigdiff_byte EQ 0))=-bigdiff_arr(where(bigdiff_byte EQ 0))

  ;;********************************************************
  ;;HEADCHECK on fastDBAceprop_i and dbTimes

  ;;printf,lun,mag_utc[fastDBAceprop_i[0]]-dbTimes(nlost)+delay
  ;;      -23.761000
  ;;printf,lun,mag_utc[fastDBAceprop_i[0]+1]-dbTimes(nlost)+delay
  ;;       36.239000

  ;;GOOD--it should be less than 60 seconds off between each

  ;;********************************************************
  ;;Let's see what ACE/OMNI data looks like
  ;;cgScatter2D,mag_utc[1:3600*24],bz(1:3600*24)

  ;;********************************************************
  ;;FINAL CHECK--Do we have enough magdata before and/or after to interpolate?

  ;;interp_t_r=mag_utc[[fastDBSatProppedInterped_i]+1]-mag_utc[fastDBSatProppedInterped_i]
  ;;interp_t_l=mag_utc[fastDBSatProppedInterped_i]-mag_utc[[fastDBSatProppedInterped_i]-1]
  ;;interp_scare=cgSetIntersection(where(interp_t_r GT 60),where(interp_t_l GT 60))

  ;;*********************************************************
  ;;If we're also going to smooth IMF data, it might as well happen here
  IF KEYWORD_SET(smoothWindow) THEN BEGIN

     IF smoothWindow EQ 1 THEN smoothWindow = 5 ;default to five-minute smoothing

     halfWind=floor(smoothWindow/2)

     ;; goodSmooth_ii = where(((shift(mag_utc,-halfWind))[fastDBSatProppedInterped_i]-(shift(mag_utc,halfWind))[fastDBSatProppedInterped_i])/60 EQ halfWind*2, nGoodSmooth)
     ;; IF nGoodSmooth EQ N_ELEMENTS(fastDBSatProppedInterped_i) THEN BEGIN
     ;;    print,"All data can be smoothed, thank goodness"
     ;; ENDIF ELSE BEGIN
     ;;    print,"Not all data can be smoothed!"
     ;;    print,"Losing "+strcompress(N_ELEMENTS(fastDBSatProppedInterped_i)-nGoodSmooth,/remove_all)+" events corresponding to IMF data that can't be smoothed..."
     ;;    wait,0.5
     ;;    fastDBSatProppedInterped_i=fastDBSatProppedInterped_i(goodSmooth_ii)
     ;;    fastDBInterp_i=fastDBInterp_i(goodSmooth_ii)
     ;;    fastDBInterpTime=fastDBInterpTime(goodSmooth_ii)
     ;; ENDELSE
     ;; bx[fastDBSatProppedInterped_i]=smooth(bx[fastDBSatProppedInterped_i],smoothWindow)
     ;; by[fastDBSatProppedInterped_i]=smooth(by[fastDBSatProppedInterped_i],smoothWindow)
     ;; bz[fastDBSatProppedInterped_i]=smooth(bz[fastDBSatProppedInterped_i],smoothWindow)

     ;; a different approach
     smoothRange=[fastDBSatProppedInterped_i[0]:fastDBSatProppedInterped_i[-1]]
     magUTCTEMP=mag_utc[smoothRange[0]-halfWind:smoothRange[-1]+halfWind];ALL times for which we have mag data between first and last FAC event 
     goodSmooth_k = where(((shift(magUTCTEMP,-halfWind))-(shift(magUTCTEMP,halfWind)))/60 EQ halfWind*2, $
                           nGoodSmooth,COMPLEMENT=badSmooth_k,NCOMPLEMENT=nBadSmooth) ;use k for index to distinguish it from data indices

     ;we know the ends won't work, so junk 'em
     goodSmooth_k = goodSmooth_k - halfWind
     magUTCTEMP = magUTCTEMP[halfWind:-halfWind-1]
     IF N_ELEMENTS(badSmooth_k) GT halfWind*2 THEN BEGIN
        badSmooth_k = badSmooth_k[halfWind:-halfWind-1] 
        nBadSmooth -= halfWind*2

        ;; find out if any of our events correspond to unsmoothable data
        MATCH, magUTCTEMP[badSmooth_k], mag_utc[fastDBSatProppedInterped_i], magUTCTEMP_bad_i, mag_utcfastDBAceprop_bad_i,COUNT=nMatches,EPSILON=1.0

        ;; magUTCTEMP_bad_i and mag_utcfastDBAceprop_bad_i are ordered such that 
        ;; (magUTCTEMP(badSmooth_k))(magUTCTEMP_bad_i) equals (mag_utc[fastDBSatProppedInterped_i])(mag_utcfastDBAceprop_bad_i)

        IF nMatches NE 0 THEN BEGIN ;get rid of unsmoothable data points
           ;say what?
        ENDIF

        PRINT,"Some elements of IMF data can't be smoothed, and you haven't written code to handle this situation!"
        PRINT,"Better pay a visit to interp_mag_data.pro..."
        STOP
     ENDIF ELSE BEGIN
        badSmooth_k = -1
        nBadSmooth = 0
     ENDELSE

     ;; NOW you can smooth them
     bx[smoothRange]=smooth(bx[smoothRange],smoothWindow)
     by[smoothRange]=smooth(by[smoothRange],smoothWindow)
     bz[smoothRange]=smooth(bz[smoothRange],smoothWindow)

  ENDIF

  ;;********************************************************
  ;;Should we interpolate those guys?
  ;;Dah yeah

  bz_slope=(bz[fastDBSatProppedInterped_i+1]-bz[fastDBSatProppedInterped_i])/(mag_utc[fastDBSatProppedInterped_i+1]-mag_utc[fastDBSatProppedInterped_i])
  by_slope=(by[fastDBSatProppedInterped_i+1]-by[fastDBSatProppedInterped_i])/(mag_utc[fastDBSatProppedInterped_i+1]-mag_utc[fastDBSatProppedInterped_i])
  bx_slope=(bx[fastDBSatProppedInterped_i+1]-bx[fastDBSatProppedInterped_i])/(mag_utc[fastDBSatProppedInterped_i+1]-mag_utc[fastDBSatProppedInterped_i])


  ;;plot,fastDBInterpTime,bzChast,psym=3,symsize=0.5
  bzChast=bz[fastDBSatProppedInterped_i]+bz_slope*(fastDBInterpTime-mag_utc[fastDBSatProppedInterped_i]-delay)
  byChast=by[fastDBSatProppedInterped_i]+by_slope*(fastDBInterpTime-mag_utc[fastDBSatProppedInterped_i]-delay)
  bxChast=bx[fastDBSatProppedInterped_i]+bx_slope*(fastDBInterpTime-mag_utc[fastDBSatProppedInterped_i]-delay)


  ;*********************************************************
  ;Any requirement for by magnitude?
  ;; IF KEYWORD_SET(byMin) THEN BEGIN 
  IF N_ELEMENTS(byMin) GT 0 THEN BEGIN 
     ;;As they are after interpolation
     ;; fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterp_i=db_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_ii]]
    
     ;; byMin_ii are the indices (of indices) of events that meet the minimum By requirement
     IF KEYWORD_SET(abs_byMin) THEN BEGIN
        byMin_ii=WHERE(byChast LE -ABS(byMin) OR byChast GE ABS(byMin),NCOMPLEMENT=byminLost)
     ENDIF ELSE BEGIN
        byMin_ii=WHERE(byChast GE byMin,NCOMPLEMENT=byminLost)
     ENDELSE

     ;; byMin_ii=WHERE(byChast LE -ABS(byMin) OR byChast GE ABS(byMin),NCOMPLEMENT=byminLost)
     
     bzChast=bzChast[byMin_ii]
     byChast=byChast[byMin_ii]
     bxChast=bxChast[byMin_ii]
     
     fastDBSatProppedInterped_i=fastDBSatProppedInterped_i[byMin_ii]
     fastDBInterp_i=fastDBInterp_i[byMin_ii]
     fastDBInterpTime=fastDBInterpTime[byMin_ii]

     printf,lun,""
     printf,lun,"ByMin magnitude requirement: " + strcompress(byMin,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(byMinLost,/REMOVE_ALL) + " events because of minimum By requirement."
     printf,lun,""

  ENDIF

  ;; IF KEYWORD_SET(byMax) THEN BEGIN 
  IF N_ELEMENTS(byMax) GT 0 THEN BEGIN 
     ;;As they are after interpolation
     ;; fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterp_i=db_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_ii]]
    
     ;; byMax_ii are the indices (of indices) of events that meet the Maximum By requirement
     ;; byMax_ii=WHERE(byChast GE -ABS(byMax) OR byChast LE ABS(byMax),NCOMPLEMENT=byMaxLost)
     IF KEYWORD_SET(abs_byMax) THEN BEGIN
        byMax_ii=WHERE(ABS(byChast) LE ABS(byMax),NCOMPLEMENT=byMaxLost)
     ENDIF ELSE BEGIN
        byMax_ii=WHERE(byChast LE byMax,NCOMPLEMENT=byMaxLost)
     ENDELSE
     

     ;; byMax_ii=WHERE(ABS(byChast) LE ABS(byMax),NCOMPLEMENT=byMaxLost)
     
     bzChast=bzChast[byMax_ii]
     byChast=byChast[byMax_ii]
     bxChast=bxChast[byMax_ii]
     
     fastDBSatProppedInterped_i=fastDBSatProppedInterped_i[byMax_ii]
     fastDBInterp_i=fastDBInterp_i[byMax_ii]
     fastDBInterpTime=fastDBInterpTime[byMax_ii]

     printf,lun,""
     printf,lun,"ByMax magnitude requirement: " + strcompress(byMax,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(byMaxLost,/REMOVE_ALL) + " events because of Maximum By requirement."
     printf,lun,""

  ENDIF

  ;*********************************************************
  ;Any requirement for bz magnitude?
  ;; IF KEYWORD_SET(bzMin) THEN BEGIN 
  IF N_ELEMENTS(bzMin) THEN BEGIN 
     ;;As they are after interpolation
     ;; fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterp_i=db_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_ii]]
    
     ;; bzMin_ii are the indices (of indices) of events that meet the minimum Bz requirement
     IF KEYWORD_SET(abs_bzMin) THEN BEGIN
        bzMin_ii=WHERE(bzChast LE -ABS(bzMin) OR bzChast GE ABS(bzMin),NCOMPLEMENT=bzminLost)
     ENDIF ELSE BEGIN
        bzMin_ii=WHERE(bzChast GE bzMin,NCOMPLEMENT=bzminLost)
     ENDELSE

     bzChast=bzChast[bzMin_ii]
     byChast=byChast[bzMin_ii]
     bxChast=bxChast[bzMin_ii]
     
     fastDBSatProppedInterped_i=fastDBSatProppedInterped_i[bzMin_ii]
     fastDBInterp_i=fastDBInterp_i[bzMin_ii]
     fastDBInterpTime=fastDBInterpTime[bzMin_ii]

     printf,lun,""
     printf,lun,"BzMin magnitude requirement: " + strcompress(bzMin,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(bzMinLost,/REMOVE_ALL) + " events because of minimum Bz requirement."
     printf,lun,""

  ENDIF

  ;; IF KEYWORD_SET(bzMax) THEN BEGIN 
  IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
     ;;As they are after interpolation
     ;; fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterp_i=db_i[fastDBSatProppedInterped_ii] 
     ;; fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_ii]]
    
     ;; bzMax_ii are the indices (of indices) of events that meet the Maximum Bz requirement
     ;; bzMax_ii=WHERE(bzChast GE -ABS(bzMax) OR bzChast LE ABS(bzMax),NCOMPLEMENT=bzMaxLost)
     IF KEYWORD_SET(abs_bzMax) THEN BEGIN
        bzMax_ii=WHERE(ABS(bzChast) LE ABS(bzMax),NCOMPLEMENT=bzMaxLost)
     ENDIF ELSE BEGIN
        bzMax_ii=WHERE(bzChast LE bzMax,NCOMPLEMENT=bzMaxLost)
     ENDELSE
     
     bzChast=bzChast[bzMax_ii]
     byChast=byChast[bzMax_ii]
     bxChast=bxChast[bzMax_ii]
     
     fastDBSatProppedInterped_i=fastDBSatProppedInterped_i[bzMax_ii]
     fastDBInterp_i=fastDBInterp_i[bzMax_ii]
     fastDBInterpTime=fastDBInterpTime[bzMax_ii]

     printf,lun,""
     printf,lun,"BzMax magnitude requirement: " + strcompress(bzMax,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(bzMaxLost,/REMOVE_ALL) + " events because of Maximum Bz requirement."
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

  ;; undefine,fastDBSatProppedInterped_ii,unique_iii,bigdiff_ii,sortme

  RETURN, phiChast

END