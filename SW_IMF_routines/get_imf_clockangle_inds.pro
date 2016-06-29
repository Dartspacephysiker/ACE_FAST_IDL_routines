;;2016/02/18 This thing's whole purpose is to give us info on the stability of the IMF clock angle
PRO GET_IMF_CLOCKANGLE_INDS,phiClock, $
                            CLOCKSTR=clockStr, $
                            ANGLELIM1=angleLim1, $
                            ANGLELIM2=angleLim2, $
                            LUN=lun

  COMPILE_OPT idl2

  COMMON OMNI_STABILITY  

  ;;Everyone but bzSouth (and sometimes the off-cardinal directions) is amenable to what's below
  ;;NOTE: /NULL used in WHERE so that if no elements are returned,
  ;;we don't append a value of -1 to phiImf_ii
  CASE C_OMNI__N_angle_sets OF
     1: BEGIN
        IF C_OMNI__clockStr NE 'bzSouth' AND C_OMNI__clockStr NE 'all_IMF' THEN BEGIN
           C_OMNI__phiIMF_i                         = WHERE(phiClock GE C_OMNI__negAngle AND phiClock LE C_OMNI__posAngle)
        ENDIF ELSE BEGIN
           IF STRUPCASE(C_OMNI__clockStr) EQ STRUPCASE('bzSouth') OR KEYWORD_SET(C_OMNI__treat_angles_like_bz_south) THEN BEGIN
              C_OMNI__phiIMF_i                      = CGSETUNION(WHERE(phiClock GE C_OMNI__negAngle, /NULL),$
                                                                 WHERE(phiClock LE C_OMNI__posAngle, /NULL)) 
           ENDIF ELSE BEGIN
              IF STRUPCASE(C_OMNI__clockStr) EQ STRUPCASE('all_IMF') THEN BEGIN
                 C_OMNI__phiIMF_i                   = WHERE(phiClock EQ phiClock, /NULL)
              ENDIF
           ENDELSE
        ENDELSE
        C_OMNI__paramStr                           += STRING(FORMAT='("--",A0,"--negAngle_",I0,"__posAngle_",I0)', $
                                                             C_OMNI__clockStr,C_OMNI__negAngle,C_OMNI__posAngle)
     END
     2: BEGIN
        PRINTF,lun,'Two sets of IMF clock angles: ' + clockStr
        IF ( STRUPCASE(clockStr) NE STRUPCASE('all_Bz') ) AND $
           ( STRUPCASE(clockStr) NE STRUPCASE('all_By') ) THEN BEGIN
           PRINTF,lun,"Shouldn't be able to get here! Only applies for all_Bz and all_By!"
           STOP
        ENDIF
        IF STRUPCASE(C_OMNI__clockStr) NE STRUPCASE('all_Bz') THEN BEGIN
           C_OMNI__phiIMF_i                         = !NULL
           FOR iAngle=0,C_OMNI__N_angle_sets-1 DO BEGIN
              temp_i                                = WHERE(phiClock GE C_OMNI__negAngle[iAngle] AND phiClock LE C_OMNI__posAngle[iAngle],nTemp)

              IF nTemp GT 0 THEN BEGIN
                 C_OMNI__phiIMF_i                   = [C_OMNI__phiIMF_i,temp_i]
              ENDIF ELSE BEGIN
                 PRINTF,lun,"No inds available for the angle ranges you've set!"
                 STOP
              ENDELSE
           ENDFOR
           C_OMNI__phiIMF_i                         = C_OMNI__phiIMF_i[SORT(C_OMNI__phiIMF_i)]
        ENDIF ELSE BEGIN
           C_OMNI__phiIMF_i                         = !NULL
           FOR iAngle=0,C_OMNI__N_angle_sets-1 DO BEGIN
              IF STRUPCASE(C_OMNI__clockStr) EQ STRUPCASE('bzSouth') OR KEYWORD_SET(C_OMNI__treat_angles_like_bz_south[iAngle]) THEN BEGIN
                 temp_i                             = CGSETUNION(WHERE(phiClock GE C_OMNI__negAngle[iAngle], /NULL),$
                                                                 WHERE(phiClock LE C_OMNI__posAngle[iAngle], /NULL)) 
                 nTemp                              = N_ELEMENTS(temp_i)
              ENDIF ELSE BEGIN
                 temp_i                             = WHERE(phiClock GE C_OMNI__negAngle[iAngle] AND phiClock LE C_OMNI__posAngle[iAngle],nTemp)
              ENDELSE
              IF nTemp GT 0 THEN BEGIN
                 C_OMNI__phiIMF_i                   = [C_OMNI__phiIMF_i,temp_i]
              ENDIF ELSE BEGIN
                 PRINTF,lun,"No inds available for the angle ranges you've set!"
                 STOP
              ENDELSE
           ENDFOR
           C_OMNI__phiIMF_i                         = C_OMNI__phiIMF_i[SORT(C_OMNI__phiIMF_i)]
        ENDELSE
        C_OMNI__paramStr                           += STRING(FORMAT='("--",A0,"--negAngle_",I0,"__posAngle_",I0)', $
                                                             C_OMNI__clockStr,C_OMNI__negAngle[0],C_OMNI__posAngle[0])
        
     END
     ELSE: STOP
  ENDCASE

  PRINTF,lun,STRTRIM(N_ELEMENTS(C_OMNI__phiIMF_i),2)+" instances in OMNI where IMF is predominantly " $
         + C_OMNI__clockStr + "."
  
END
