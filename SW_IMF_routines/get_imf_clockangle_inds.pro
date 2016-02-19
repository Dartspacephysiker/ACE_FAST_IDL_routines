;;2016/02/18 This thing's whole purpose is to give us info on the stability of the IMF clock angle
PRO GET_IMF_CLOCKANGLE_INDS,phiClock, $
                            CLOCKSTR=clockStr, $
                            ANGLELIM1=angleLim1, $
                            ANGLELIM2=angleLim2

  COMPILE_OPT idl2

  COMMON OMNI_STABILITY  

  ;;Everyone but bzSouth is amenable to what's below
  ;;NOTE: /NULL used in WHERE so that if no elements are returned,
  ;;we don't append a value of -1 to phiImf_ii
  IF C_OMNI__clockStr NE 'bzSouth' AND C_OMNI__clockStr NE 'all_IMF' THEN BEGIN
     C_OMNI_phiIMF_i                          = WHERE(phiClock GE C_OMNI__negAngle AND phiClock LE C_OMNI__posAngle)
  ENDIF ELSE BEGIN
     IF STRUPCASE(C_OMNI__clockStr) EQ STRUPCASE('bzSouth') THEN BEGIN
        C_OMNI_phiIMF_i                       = CGSETUNION(WHERE(phiClock GE C_OMNI__negAngle, /NULL),$
        WHERE(phiClock LE C_OMNI__posAngle, /NULL)) 
     ENDIF ELSE BEGIN
        IF STRUPCASE(C_OMNI__clockStr) EQ STRUPCASE('all_IMF') THEN BEGIN
           C_OMNI_phiIMF_i                    = WHERE(phiClock EQ phiClock, /NULL)
        ENDIF
     ENDELSE
  ENDELSE

  C_OMNI__paramStr                           += STRING(FORMAT='("--",A0,"--negAngle_",I0,"__posAngle_",I0,)', $
                                                        C_OMNI__clockStr,C_OMNI__negAngle,C_OMNI__posAngle)

  PRINTF,lun,STRTRIM(N_ELEMENTS(C_OMNI__phiIMF_i),2)+" instances in OMNI where IMF is predominantly " $
         + C_OMNI__clockStr + "."
  
END
