;2016/02/15 Created to just yank out the right IMF indices
FUNCTION GET_OMNI_IMF_INDS_AND_QUANTITIES,satellite, $
                                          MAG_UTC=mag_utc, $
                                          PHICLOCK=phiclock, $
                                          DATADIR=datadir, $
                                          BYMIN=byMin, $
                                          BZMIN=bzMin, $
                                          BYMAX=byMax, $
                                          BZMAX=bzMax, $
                                          RESTRICT_TO_ALFVENDB_TIMES=restrict_to_alfvendb_times, $
                                          DO_ABS_BYMIN=abs_byMin, $
                                          DO_ABS_BYMAX=abs_byMax, $
                                          DO_ABS_BZMIN=abs_bzMin, $
                                          DO_ABS_BZMAX=abs_bzMax, $
                                          DO_ANGLES=do_angles, $
                                          ANGLELIM1=anglelim1, $
                                          ANGLELIM2=anglelim2, $
                                          CLOCKSTR=clockStr, $
                                          OMNI_COORDS=omni_Coords, $
                                          LUN=lun
  
  COMPILE_OPT idl2,strictarrsubs

  IF ~KEYWORD_SET(lun) THEN lun           = -1
  IF NOT KEYWORD_SET(dataDir) THEN dataDir="/SPENCEdata/Research/database/"

  ;;********************************************************
  ;;Restore ACE/OMNI data, if need be
  IF mag_utc EQ !NULL THEN restore,dataDir + "/processed/culled_"+satellite+"_magdata.dat"

  IF N_ELEMENTS(omni_coords) EQ 0 THEN omni_coords = 'GSM'

  IF satellite EQ "OMNI" THEN BEGIN ;We've got to select GSE or GSM coords. Default to GSE.
     IF OMNI_COORDS EQ "GSE" THEN BEGIN
        By           = By_GSE
        Bz           = Bz_GSE
        thetaCone    = thetaCone_GSE
        phiClock     = phiClock_GSE
     ENDIF ELSE BEGIN
        IF OMNI_COORDS EQ "GSM" THEN BEGIN
           By        = By_GSM
           Bz        = Bz_GSM
           thetaCone = thetaCone_GSM
           phiClock  = phiClock_GSM
        ENDIF ELSE BEGIN
           print,"Invalid coordinates chosen for OMNI data! Defaulting to GSE..."
           WAIT,1.0
           By        = By_GSE
           Bz        = Bz_GSE
        ENDELSE
     ENDELSE 
  ENDIF

  phi                    = ATAN(by,bz)
  theta                  = ACOS(abs(bx)/SQRT(bx*bx+by*by+bz*bz))
  bxy_over_bz            = SQRT(bx*bx+by*by)/abs(bz)
  cone_overClock         = theta/phi

  phi                    = phi*180/!PI
  thetaCone              = thetaCone*180/!PI
  phiClock               = phiClock*180/!PI

  ;;********************************************************
  ;;Text output 
  ;;
  printf,lun,""
  printf,lun,"****From GET_OMNI_IMF_INDS_AND_QUANTITIES.pro****"

  ;; IF KEYWORD_SET(smoothWindow) THEN printf,lun,"Smooth window is set to " + strcompress(smoothWindow,/remove_all) + " minutes"



  ;;Should we interpolate those guys?
  ;;Dah yeah

  ;; bz_slope=(bz[fastDBSatProppedInterped_i+1]-bz[fastDBSatProppedInterped_i])/(mag_utc[fastDBSatProppedInterped_i+1]-mag_utc[fastDBSatProppedInterped_i])
  ;; by_slope=(by[fastDBSatProppedInterped_i+1]-by[fastDBSatProppedInterped_i])/(mag_utc[fastDBSatProppedInterped_i+1]-mag_utc[fastDBSatProppedInterped_i])
  ;; bx_slope=(bx[fastDBSatProppedInterped_i+1]-bx[fastDBSatProppedInterped_i])/(mag_utc[fastDBSatProppedInterped_i+1]-mag_utc[fastDBSatProppedInterped_i])


  ;;plot,fastDBInterpTime,bzChast,psym=3,symsize=0.5
  ;; bzChast=bz[fastDBSatProppedInterped_i]+bz_slope*(fastDBInterpTime-mag_utc[fastDBSatProppedInterped_i]-delay)
  ;; byChast=by[fastDBSatProppedInterped_i]+by_slope*(fastDBInterpTime-mag_utc[fastDBSatProppedInterped_i]-delay)
  ;; bxChast=bx[fastDBSatProppedInterped_i]+bx_slope*(fastDBInterpTime-mag_utc[fastDBSatProppedInterped_i]-delay)


  IF KEYWORD_SET(restrict_to_alfvendb_times) THEN BEGIN
     maxTime                 = STR_TO_TIME('2000-10-06/00:08:46.938')
     minTime                 = STR_TO_TIME('1996-10-06/20:54:32.622')
     good_i                  = WHERE(mag_UTC LE maxTime AND mag_UTC GE minTime,/NULL,NCOMPLEMENT=nNotAlfvenDB)
     PRINTF,lun,"Losing " + STRCOMPRESS(nNotAlfvenDB,/REMOVE_ALL) + " OMNI entries because they don't happen during Alfven stuff"
  ENDIF ELSE BEGIN
     good_i                  = INDGEN(N_ELEMENTS(phiClock),/LONG)
  ENDELSE



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
        byMin_i=WHERE(by LE -ABS(byMin) OR by GE ABS(byMin),NCOMPLEMENT=byminLost)
     ENDIF ELSE BEGIN
        byMin_i=WHERE(by GE byMin,NCOMPLEMENT=byminLost)
     ENDELSE

     IF byMin_i[0] NE -1 THEN good_i = CGSETINTERSECTION(good_i,byMin_i)

     printf,lun,""
     printf,lun,"ByMin magnitude requirement: " + strcompress(byMin,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(byMinLost,/REMOVE_ALL) + " events because of minimum By requirement."
     printf,lun,""

  ENDIF

  ;; IF KEYWORD_SET(byMax) THEN BEGIN 
  IF N_ELEMENTS(byMax) GT 0 THEN BEGIN 
     ;;As they are after interpolation
     ;; fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_i] 
     ;; fastDBInterp_i=db_i[fastDBSatProppedInterped_i] 
     ;; fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_i]]
    
     ;; byMax_i are the indices (of indices) of events that meet the Maximum By requirement
     ;; byMax_i=WHERE(by GE -ABS(byMax) OR by LE ABS(byMax),NCOMPLEMENT=byMaxLost)
     IF KEYWORD_SET(abs_byMax) THEN BEGIN
        byMax_i=WHERE(ABS(by) LE ABS(byMax),NCOMPLEMENT=byMaxLost)
     ENDIF ELSE BEGIN
        byMax_i=WHERE(by LE byMax,NCOMPLEMENT=byMaxLost)
     ENDELSE
     
     IF byMax_i[0] NE -1 THEN good_i = CGSETINTERSECTION(good_i,byMax_i)

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
     ;; fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_i] 
     ;; fastDBInterp_i=db_i[fastDBSatProppedInterped_i] 
     ;; fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_i]]
    
     ;; bzMin_i are the indices (of indices) of events that meet the minimum Bz requirement
     IF KEYWORD_SET(abs_bzMin) THEN BEGIN
        bzMin_i=WHERE(bz LE -ABS(bzMin) OR bz GE ABS(bzMin),NCOMPLEMENT=bzminLost)
     ENDIF ELSE BEGIN
        bzMin_i=WHERE(bz GE bzMin,NCOMPLEMENT=bzminLost)
     ENDELSE

     IF bzMin_i[0] NE -1 THEN good_i = CGSETINTERSECTION(good_i,bzMin_i)

     printf,lun,""
     printf,lun,"BzMin magnitude requirement: " + strcompress(bzMin,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(bzMinLost,/REMOVE_ALL) + " events because of minimum Bz requirement."
     printf,lun,""

  ENDIF

  ;; IF KEYWORD_SET(bzMax) THEN BEGIN 
  IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
     ;;As they are after interpolation
     ;; fastDBSatProppedInterped_i=fastDBAceprop_i[fastDBSatProppedInterped_i] 
     ;; fastDBInterp_i=db_i[fastDBSatProppedInterped_i] 
     ;; fastDBInterpTime=dbTimes[db_i[fastDBSatProppedInterped_i]]
    
     ;; bzMax_i are the indices (of indices) of events that meet the Maximum Bz requirement
     ;; bzMax_i=WHERE(bz GE -ABS(bzMax) OR bz LE ABS(bzMax),NCOMPLEMENT=bzMaxLost)
     IF KEYWORD_SET(abs_bzMax) THEN BEGIN
        bzMax_i=WHERE(ABS(bz) LE ABS(bzMax),NCOMPLEMENT=bzMaxLost)
     ENDIF ELSE BEGIN
        bzMax_i=WHERE(bz LE bzMax,NCOMPLEMENT=bzMaxLost)
     ENDELSE
     
     IF bzMax_i[0] NE -1 THEN good_i = CGSETINTERSECTION(good_i,bzMax_i)

     printf,lun,""
     printf,lun,"BzMax magnitude requirement: " + strcompress(bzMax,/REMOVE_ALL) + " nT"
     printf,lun,"Losing " + strcompress(bzMaxLost,/REMOVE_ALL) + " events because of Maximum Bz requirement."
     printf,lun,""

  ENDIF

  IF KEYWORD_SET(do_angles) THEN BEGIN
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
                             ENDIF ELSE BEGIN
                                printf,lun, "Only nine options, brother." & good_i=-1
                                STOP
                             ENDELSE
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
     ;;we don't append a value of -1 to phiImf_i
     IF clockStr NE 'bzSouth' AND clockStr NE 'all_IMF' THEN BEGIN
        phiImf_i=where(phiClock GE negAngle AND phiClock LE posAngle)
     ENDIF ELSE BEGIN
        IF STRUPCASE(clockStr) EQ STRUPCASE('bzSouth') THEN BEGIN
           phiImf_i=CGSETUNION(where(phiClock GE negAngle, /NULL),$
                                where(phiClock LE posAngle, /NULL)) 
        ENDIF ELSE BEGIN
           IF STRUPCASE(clockStr) EQ STRUPCASE('all_IMF') THEN phiImf_i=where(phiClock EQ phiClock, /NULL)
        ENDELSE
     ENDELSE
     
  
     good_i                 = CGSETINTERSECTION(good_i,phiIMF_i)

     printf,lun,strtrim(N_ELEMENTS(good_i),2)+" minutes with IMF predominantly " $
            + clockStr + "."

  ENDIF

  printf,lun,"****END text from GET_OMNI_IMF_INDS_AND_QUANTITIES.pro****"
  printf,lun,""



  RETURN, good_i

END