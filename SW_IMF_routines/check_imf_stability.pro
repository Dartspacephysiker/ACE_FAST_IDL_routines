;*************************************************
;The purpose of this routine is to check the
;stability of IMF for either data in the Alfven wave 
;DB or in the FAST ephemeris DB so that, if we
;have unstable IMF, we can screen out those events
;It is meant to be used following 'get_chaston_ind' 
;and 'interp_mag_data'.

;One point worth noting is that "IMF stability"
;is treated as simply checking that the IMF clock
;angle remains within the bounds defined by
;angleLim1, angleLim2, and clockStr.
;There is no 'relative angle' checking to, e.g.,
;ensure that the angle doesn't deviate too sharply
;from its initial 'approved' value

FUNCTION CHECK_IMF_STABILITY,clockStr,angleLim1,angleLim2,phiDB, $
                             fastDBSatProppedInterped_i, stableIMF, mag_utc, phiclock, $
                             BX_OVER_BYBZ=bx_over_bybz,INCLUDENOCONSECDATA=includenoconsecdata, $
                             LUN=lun

  COMPILE_OPT idl2

  printf,lun,"****From check_imf_stability.pro****"


  ;;Set up to check correct region: negAngle<phi<posAngle
  IF STRUPCASE(clockStr) EQ STRUPCASE('duskward') THEN BEGIN 
     ;;   ctrAngle=90 
     negAngle=angleLim1 
     posAngle=angleLim2 
  ENDIF ELSE BEGIN
     IF STRUPCASE(clockStr) EQ STRUPCASE('dawnward') THEN BEGIN  
        ;;   ctrAngle=-90 
        negAngle=-angleLim2 
        posAngle=-angleLim1 
     ENDIF ELSE BEGIN
        IF STRUPCASE(clockStr) EQ STRUPCASE('bzNorth') THEN BEGIN 
           ;;   ctrAngle=0 
           negAngle=-angleLim1 
           posAngle=angleLim1 
        ENDIF ELSE BEGIN
           IF STRUPCASE(clockStr) EQ STRUPCASE('bzSouth') THEN BEGIN  
              ;;   ctrAngle=180 
              negAngle=angleLim2 
              posAngle=-angleLim2 
           ENDIF ELSE BEGIN
              IF STRUPCASE(clockStr) EQ STRUPCASE('all_IMF') THEN BEGIN 
                 negAngle=-angleLim1 
                 posAngle=angleLim2 
              ENDIF ELSE BEGIN
                 IF STRUPCASE(clockStr) EQ STRUPCASE('dawn-north') THEN BEGIN
                    negAngle=-90.0
                    posAngle=-angleLim1
                 ENDIF ELSE BEGIN
                    IF STRUPCASE(clockStr) EQ STRUPCASE('dawn-south') THEN BEGIN
                       negAngle=-angleLim2
                       posAngle=-90.0
                    ENDIF ELSE BEGIN
                       IF STRUPCASE(clockStr) EQ STRUPCASE('dusk-north') THEN BEGIN
                          negAngle=angleLim1
                          posAngle=90.0
                       ENDIF ELSE BEGIN
                          IF STRUPCASE(clockStr) EQ STRUPCASE('dusk-south') THEN BEGIN
                             negAngle=90.0
                             posAngle=angleLim2
                          ENDIF ELSE printf,lun, "Only nine options, brother." & plot_i=-1
                       ENDELSE
                    ENDELSE
                 ENDELSE
              ENDELSE
           ENDELSE
        ENDELSE
     ENDELSE
  ENDELSE


  ;;Everyone but bzSouth is amenable to what's below
  ;;NOTE: /NULL used in WHERE so that if no elements are returned,
  ;;we don't append a value of -1 to phiImf_ii
  IF clockStr NE 'bzSouth' AND clockStr NE 'all_IMF' THEN BEGIN
     phiImf_ii=where(phiDB GE negAngle AND phiDB LE posAngle)
  ENDIF ELSE BEGIN
     IF STRUPCASE(clockStr) EQ STRUPCASE('bzSouth') THEN BEGIN
        phiImf_ii=cgSetUnion(where(phiDB GE negAngle, /NULL),$
        where(phiDB LE posAngle, /NULL)) 
     ENDIF ELSE BEGIN
        IF STRUPCASE(clockStr) EQ STRUPCASE('all_IMF') THEN phiImf_ii=where(phiDB EQ phiDB, /NULL)
     ENDELSE
  ENDELSE
  
  
  printf,lun,strtrim(N_ELEMENTS(phiImf_ii),2)+" events with IMF predominantly " $
         + clockStr + "."
  
  IF stableIMF GT 0 THEN BEGIN 
     
     imfDurArr=INTARR(N_ELEMENTS(phiImf_ii)) 
     oldCount=0    
     ;;   sumCount=0 
     FOR j = stableIMF, 1, -1 DO BEGIN 
        ;;   FOR j = 1, stableIMF DO BEGIN 
        ;;      printf,lun,"Sumcount is " + strtrim(sumCount,2) 
        ;;Uh-oh, it's going to be complicated
        ;;How can I possibly know which situation we're dealing with?
        temp_ii=WHERE((mag_utc[fastDBSatProppedInterped_i[phiImf_ii]])[j:*]-$
                      (SHIFT(mag_utc[fastDBSatProppedInterped_i[phiImf_ii]],j))[j:*] $
                      LT (60*j+2),thisCount) 
        ;;This tempArr checks to make sure that no element of imfDurArr
        ;;gets replaced by a lower number, so that we know the MAX duration
        tempArr=imfDurArr[j:*] 
        tempArr[temp_ii]=j 
        tempArr=[INTARR(j),tempArr] 
        imfDurArr[WHERE(tempArr GT imfDurArr)]=j 
        printf,lun,"There are " +strtrim(thisCount-oldCount,2)+ " instances" + $
               " prior to which we have " +strtrim(j,2)+ " minutes of consecutive" + $
               " mag data."    
        ;;      sumCount += thisCount-oldCount 
        oldCount = thisCount  
     ENDFOR  
     ;;      sumCount+=N_ELEMENTS(WHERE(imfDurArr EQ 0)) 
     ;;      printf,lun,sumCount 
     
     ;;OK, with "worthy" data in hand, let's check IMF stability.
     ;;This only includes those that have the proper clock angle to begin
     ;;with AND are associated with sufficiently long streaks of IMF data.
     
     ;;The indices of the points which are awesome enough are
     checkWorthy_iii=WHERE(imfDurArr GE stableIMF) 
     
     nUnstable=N_ELEMENTS(WHERE(imfDurArr GE stableIMF))-N_ELEMENTS(checkWorthy_iii)
     IF nUnstable GT 0 THEN BEGIN
        printf,lun,"Losing "+strtrim(nUnstable,2) + " events because of insufficient data to check IMF stability." 
        wait,0.5
     ENDIF
     
     ;;The following is a reasonable index number for aceprop data
     ;;print,fastDBSatProppedInterped_i[phiimf_ii[checkworthy_iii[1100]]]
     ;;      133290
     
     ;;Initialize stableIMF_ii
     stableIMF_ii=0 
     FOR i=0,N_ELEMENTS(checkWorthy_iii)-1 DO BEGIN 
        temp_ii=phiImf_ii[checkWorthy_iii[i]] 
        phiTemp=phiClock[fastDBSatProppedInterped_i[temp_ii]-$
                         stableIMF+1:fastDBSatProppedInterped_i[temp_ii]] 
        IF clockStr NE 'bzSouth' THEN $
           stableTemp=where(phiTemp GE negAngle AND phiTemp LE posAngle) $
        ELSE stableTemp=cgSetUnion(where(phiTemp GE negAngle),$
                                   where(phiTemp LE posAngle)) 
        
        ;;Now we've got to decide what to do with those lousy events 
        ;;corresponding to unstable periods
        ;;Kick 'em out of the house!
        IF N_ELEMENTS(stableTemp(WHERE(stableTemp GT -1))) EQ stableIMF THEN $ 
           stableIMF_ii=[stableIMF_ii,temp_ii] 
     ENDFOR 
     
     ;;Remove first element since I had to initialize it
     stableIMF_ii=stableIMF_ii[1:*] 
     
     printf,lun,"Losing " +strtrim(N_ELEMENTS(checkWorthy_iii)-$
                                   N_ELEMENTS(stableIMF_ii),2) + $
            " events associated with unstable IMF." 
     
     ;;Include data that probably don't have stability info?
     IF KEYWORD_SET(includeNoConsecData) THEN BEGIN 
        noConsec_ii=WHERE(imfDurArr EQ 0) 
        IF noConsec_ii[0] NE -1 THEN BEGIN 
           printf,lun,"Including "+strtrim(N_ELEMENTS(noConsec_ii),2)+ $
                  " events which don't seem capable of providing stability info..." 
           stableIMF_ii=[stableIMF_ii,imfDurArr(noConsec_ii)] 
           stableIMF_ii=stableIMF_ii(SORT(stableIMF_ii)) 
        ENDIF   
     ENDIF 

     ;;Last of all, set up plot indices
;     phiIMF_ii=TEMPORARY(stableIMF_ii) 
     phiIMF_ii=stableIMF_ii
     
  ENDIF 
  
  ;;DIAGNOSTIC
  ;;FOR i=300,305 DO BEGIN 
  ;;   print,"Durarr["+strtrim(i,2)+"]="+strtrim(imfDurArr[i],2) 
  ;;   FOR j=0,imfDurArr[i] DO BEGIN 
  ;;      tDiff=mag_utc(chastondbAceprop_i[i])-mag_utc(chastondbAceprop_i[i]-j) 
  ;;      print,"j="+strtrim(j,2)+" and tdiff="+strtrim(tdiff,2) 
  ;;   ENDFOR 
  ;;ENDFOR
  
  
  
  IF KEYWORD_SET(Bx_over_ByBz) AND Bx_over_ByBz GT 0 THEN BEGIN 
     Printf,Lun,"Print dat bx" 
  ENDIF
  
  IF stableIMF EQ 0 AND KEYWORD_SET(Bx_over_ByBz) AND Bx_over_ByBz EQ 0 THEN printf,lun,"No stability or Bx requirement..." ; $
  ;;ELSE BEGIN 
  ;;   printf,lun,"Launching" 
  ;;ENDELSE
  
  printf,lun,"****END check_imf_stability.pro****"
  
  RETURN, phiIMF_ii

END